import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_state.dart';
import 'package:hankan/app/service/sendbird_service.dart';

final profileEditProvider = NotifierProvider<ProfileEditNotifier, ProfileEditState>(
  ProfileEditNotifier.new,
);

class ProfileEditNotifier extends Notifier<ProfileEditState> {
  late final SendbirdService _sendbirdService;

  @override
  ProfileEditState build() {
    _sendbirdService = SendbirdService.I;
    _loadCurrentUser();
    return const ProfileEditState();
  }

  void _loadCurrentUser() {
    final currentUser = _sendbirdService.currentUser;
    if (currentUser != null) {
      state = state.copyWith(
        nickname: currentUser.nickname ?? '',
        profileUrl: currentUser.profileUrl ?? '',
        currentUser: null,
      );
    }
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
      await _sendbirdService.updateCurrentUserInfo(
        nickname: state.nickname.trim(),
        profileUrl: state.profileUrl.isEmpty ? null : state.profileUrl,
      );

      state = state.copyWith(isSaving: false);
      return true;
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