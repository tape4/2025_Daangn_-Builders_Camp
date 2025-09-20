import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/api/result.dart';
import 'package:hankan/app/auth/auth_state.dart';
import 'package:hankan/app/model/auth_request_model.dart';
import 'package:hankan/app/model/auth_response_model.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:hankan/app/service/secure_storage_service.dart';

class AuthService {
  static AuthService get I => GetIt.I<AuthService>();

  late final ProviderContainer container;
  final ApiService _api;
  final SecureStorageService secureStorageService;

  AuthState get state => container.read(authStateProvider);

  AuthService({
    required ApiService api,
    required this.secureStorageService,
    required this.container,
  }) : _api = api {
    _api.setAuthService(this);
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final accessToken = await secureStorageService.read('access_token');
    final refreshToken = await secureStorageService.read('refresh_token');

    if (accessToken != null && refreshToken != null) {
      container.read(authStateProvider.notifier).updateAuthState(
        isLoggedIn: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }

  Future<Result<Map<String, dynamic>>> sendOtp({
    required String phone,
    required String purpose,
  }) async {
    final request = SendOtpRequest(phone: phone, purpose: purpose);
    return await _api.sendOtp(request);
  }

  Future<Result<UserModel>> verifyOtpLogin({
    required String phone,
    required String otp,
  }) async {
    final request = VerifyOtpRequest(
      phone: phone,
      otp: otp,
      purpose: 'login',
    );

    final result = await _api.verifyOtp(request);

    return await result.asyncMap((response) async {
      await secureStorageService.write('access_token', response.access_token);
      await secureStorageService.write('refresh_token', response.refresh_token);

      container.read(authStateProvider.notifier).updateAuthState(
        isLoggedIn: true,
        accessToken: response.access_token,
        refreshToken: response.refresh_token,
      );

      return response.user;
    });
  }

  Future<Result<UserModel>> verifyOtpRegister({
    required String phone,
    required String otp,
    required String username,
  }) async {
    final request = VerifyOtpRequest(
      phone: phone,
      otp: otp,
      purpose: 'register',
      username: username,
    );

    final result = await _api.verifyOtp(request);

    return await result.asyncMap((response) async {
      await secureStorageService.write('access_token', response.access_token);
      await secureStorageService.write('refresh_token', response.refresh_token);

      container.read(authStateProvider.notifier).updateAuthState(
        isLoggedIn: true,
        accessToken: response.access_token,
        refreshToken: response.refresh_token,
      );

      return response.user;
    });
  }

  Future<void> logout() async {
    await _api.logout();
    await secureStorageService.delete('access_token');
    await secureStorageService.delete('refresh_token');

    container.read(authStateProvider.notifier).updateAuthState(
      isLoggedIn: false,
      accessToken: null,
      refreshToken: null,
    );

    RouterService.I.router.go(Routes.login);
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await secureStorageService.read('refresh_token');
    if (refreshToken == null) {
      await handleTokenExpiration();
      return;
    }

    final result = await _api.refreshToken(refreshToken);

    await result.fold(
      onSuccess: (response) async {
        await secureStorageService.write('access_token', response.access_token);
        await secureStorageService.write('refresh_token', response.refresh_token);

        container.read(authStateProvider.notifier).updateAuthState(
          isLoggedIn: true,
          accessToken: response.access_token,
          refreshToken: response.refresh_token,
        );
      },
      onFailure: (error) async {
        await handleTokenExpiration();
      },
    );
  }

  Future<void> handleTokenExpiration() async {
    await secureStorageService.delete('access_token');
    await secureStorageService.delete('refresh_token');

    container.read(authStateProvider.notifier).updateAuthState(
      isLoggedIn: false,
      accessToken: null,
      refreshToken: null,
    );

    RouterService.I.router.go(Routes.login);
  }
}
