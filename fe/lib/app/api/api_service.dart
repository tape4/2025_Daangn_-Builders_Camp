import 'package:dio/dio.dart';
import 'package:hankan/app/api/dio_client.dart';
import 'package:hankan/app/api/result.dart';
import 'package:hankan/app/auth/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/model/auth_request_model.dart';
import 'package:hankan/app/model/auth_response_model.dart';
import 'package:hankan/app/model/user.dart';

class ApiService {
  static ApiService get I => GetIt.I<ApiService>();

  late final MyDio _dio;

  void setAuthService(AuthService authService) =>
      _dio.setAuthService(authService);

  ApiService() {
    _dio = MyDio(dio: Dio());
  }

  Future<Result<User>> getUser() => _dio.get(
        '/user',
        fromJson: User.fromJson,
      );

  Future<Result<Map<String, dynamic>>> sendOtp(SendOtpRequest request) =>
      _dio.post(
        '/auth/send-otp',
        data: request.toJson(),
        fromJson: (json) => json,
      );

  Future<Result<AuthResponse>> verifyOtp(VerifyOtpRequest request) => _dio.post(
        '/auth/verify-otp',
        data: request.toJson(),
        fromJson: AuthResponse.fromJson,
      );

  Future<Result<void>> logout() => _dio.post(
        '/auth/logout',
        fromJson: (_) {},
      );

  Future<Result<AuthResponse>> refreshToken(String refreshToken) => _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        fromJson: AuthResponse.fromJson,
      );

  Future<Result<UserModel>> getCurrentUser() => _dio.get(
        '/auth/me',
        fromJson: UserModel.fromJson,
      );
}
