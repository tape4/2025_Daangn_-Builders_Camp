import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/api/result.dart';
import 'package:hankan/app/auth/auth_state.dart';
import 'package:hankan/app/model/token.dart';
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
  }) async {
    return await _api.sendOtp(phone);
  }

  Future<Result<Token>> verifyOtpLogin({
    required String phone,
    required String otp,
  }) async {
    final result = await _api.verifyOtp(phone, otp);

    return await result.asyncMap((response) async {
      await secureStorageService.write('access_token', response.accessToken);
      await secureStorageService.write('refresh_token', response.refreshToken);

      container.read(authStateProvider.notifier).updateAuthState(
            isLoggedIn: true,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

      return response;
    });
  }

  Future<Result<Token>> register({
    required String phone,
    required String nickname,
  }) async {
    final result = await _api.register(phone, nickname);

    return await result.asyncMap((response) async {
      await secureStorageService.write('access_token', response.accessToken);
      await secureStorageService.write('refresh_token', response.refreshToken);

      container.read(authStateProvider.notifier).updateAuthState(
            isLoggedIn: true,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

      return response;
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

  Future<void> refreshAccessToken() async {}

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
