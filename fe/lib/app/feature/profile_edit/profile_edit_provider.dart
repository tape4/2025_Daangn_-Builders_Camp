import 'dart:io';
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

    // Load current user data if available
    final currentUser = _sendbirdService.currentUser;
    if (currentUser != null) {
      return ProfileEditState(
        nickname: currentUser.nickname ?? '',
        profileUrl: currentUser.profileUrl ?? '',
      );
    }

    // Return default state if no user is connected
    return const ProfileEditState(
      nickname: '',
      profileUrl: '',
    );
  }

  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void updateProfileUrl(String url) {
    state = state.copyWith(profileUrl: url);
  }

  Future<bool> saveProfile() async {
    // Check if Sendbird is connected
    if (!_sendbirdService.isConnected) {
      state = state.copyWith(
        errorMessage: '서버에 연결되지 않았습니다. 잠시 후 다시 시도해주세요.',
      );
      return false;
    }

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
      String? profileUrlToSave = state.profileUrl;

      // If the profile URL is a local file path, upload it to server first
      if (profileUrlToSave.isNotEmpty && !profileUrlToSave.startsWith('http')) {
        // TODO: Implement image upload to server
        // This is where you would upload the image file to your server
        // and get back a URL that can be saved to Sendbird
        //
        // Example implementation:
        // final file = File(profileUrlToSave);
        // final uploadedUrl = await uploadImageToServer(file);
        // profileUrlToSave = uploadedUrl;
        //
        // For now, we'll skip saving the local file path
        // In production, you must implement the upload functionality
        profileUrlToSave = null;
      }

      await _sendbirdService.updateCurrentUserInfo(
        nickname: state.nickname.trim(),
        profileUrl: profileUrlToSave,
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