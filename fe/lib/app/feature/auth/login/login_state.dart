import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';
part 'login_state.g.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    @Default('') String phone,
    @Default('') String otp,
    @Default(false) bool isLoading,
    @Default(false) bool otpSent,
    @Default(60) int resendTimer,
    @Default(false) bool canResend,
    String? errorMessage,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, dynamic> json) =>
      _$LoginStateFromJson(json);
}
