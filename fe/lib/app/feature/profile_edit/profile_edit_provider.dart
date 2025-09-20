import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_state.dart';
import 'package:hankan/app/provider/user_provider.dart';
import 'package:hankan/app/service/sendbird_service.dart';

final profileEditProvider = NotifierProvider<ProfileEditNotifier, ProfileEditState>(
  ProfileEditNotifier.new,
);

class ProfileEditNotifier extends Notifier<ProfileEditState> {
  late final SendbirdService _sendbirdService;

  @override
  ProfileEditState build() {
    _sendbirdService = SendbirdService.I;

    // Load current user data from UserProvider
    final currentUser = ref.read(userProvider);
    return ProfileEditState(
      nickname: currentUser.nickname,
      profileUrl: currentUser.profile_image,
      originalProfileUrl: currentUser.profile_image,
    );
  }

  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void updateProfileUrl(String url) {
    state = state.copyWith(profileUrl: url);
  }

  Future<bool> saveProfile() async {
    if (state.nickname.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: '닉네임을 입력해주세요.',
      );
      return false;
    }

    if (state.nickname.length > 20) {
      state = state.copyWith(
        errorMessage: '닉네임은 20자 이하로 입력해주세요.',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      String? profileImagePath;
      bool hasImageChanged = state.profileUrl != state.originalProfileUrl;

      // Only send image if it has changed and is a local file
      if (hasImageChanged && state.profileUrl.isNotEmpty && !state.profileUrl.startsWith('http')) {
        profileImagePath = state.profileUrl;
      }

      // Call API to update user profile
      final result = await ApiService.I.updateUserProfile(
        nickname: state.nickname.trim(),
        profileImagePath: profileImagePath,
      );

      return await result.fold(
        onSuccess: (updatedUser) async {
          // Update UserProvider with new user data
          ref.read(userProvider.notifier).updateUser(updatedUser);

          // Update Sendbird profile if connected
          if (_sendbirdService.isConnected) {
            try {
              await _sendbirdService.updateCurrentUserInfo(
                nickname: updatedUser.nickname,
                profileUrl: updatedUser.profile_image,
              );
            } catch (e) {
              // Sendbird update failed, but API succeeded, so we continue
            }
          }

          state = state.copyWith(isSaving: false);
          return true;
        },
        onFailure: (error) {
          state = state.copyWith(
            isSaving: false,
            errorMessage: '프로필 업데이트에 실패했습니다. 다시 시도해주세요.',
          );
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: '프로필 업데이트에 실패했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}