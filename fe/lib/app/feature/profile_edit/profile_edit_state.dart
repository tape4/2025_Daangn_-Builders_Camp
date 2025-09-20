import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/model/sendbird_user_model.dart';

part 'profile_edit_state.freezed.dart';

@freezed
class ProfileEditState with _$ProfileEditState {
  const factory ProfileEditState({
    @Default('') String nickname,
    @Default('') String profileUrl,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
    SendbirdUserModel? currentUser,
  }) = _ProfileEditState;
}