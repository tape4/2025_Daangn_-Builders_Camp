import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request_model.freezed.dart';
part 'auth_request_model.g.dart';

@freezed
class SendOtpRequest with _$SendOtpRequest {
  factory SendOtpRequest({
    required String phone,
    required String purpose, // 'login' or 'register'
  }) = _SendOtpRequest;

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestFromJson(json);
}

@freezed
class VerifyOtpRequest with _$VerifyOtpRequest {
  factory VerifyOtpRequest({
    required String phone,
    required String otp,
    required String purpose, // 'login' or 'register'
    String? username, // Required for registration
  }) = _VerifyOtpRequest;

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);
}