import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponse with _$AuthResponse {
  factory AuthResponse({
    required String access_token,
    required String refresh_token,
    required UserModel user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required int id,
    required String email,
    required String username,
    String? phone,
    String? profile_image,
    DateTime? created_at,
    DateTime? updated_at,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}