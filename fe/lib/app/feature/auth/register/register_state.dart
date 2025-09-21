import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  factory RegisterState({
    @Default('') String phone,
    @Default('') String username,
    @Default('') String otp,
    @Default(false) bool isLoading,
    @Default(false) bool otpSent,
    @Default(60) int resendTimer,
    @Default(false) bool canResend,
    @Default(false) bool agreeTerms,
    String? errorMessage,
  }) = _RegisterState;
}