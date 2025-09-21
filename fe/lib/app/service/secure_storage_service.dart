import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class SecureStorageService {
  static SecureStorageService get I => GetIt.I<SecureStorageService>();

  late final FlutterSecureStorage secureStorage;

  Future<String?> get accessToken => secureStorage.read(key: "jwtAccessToken");
  Future<String?> get refreshToken =>
      secureStorage.read(key: "jwtRefreshToken");

  void init() {
    secureStorage = const FlutterSecureStorage();
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      secureStorage.write(key: "jwtAccessToken", value: accessToken),
      secureStorage.write(key: "jwtRefreshToken", value: refreshToken),
    ]);
  }

  Future<void> write(String key, String value) async {
    final keyMap = {
      'access_token': 'jwtAccessToken',
      'refresh_token': 'jwtRefreshToken',
    };
    await secureStorage.write(key: keyMap[key] ?? key, value: value);
  }

  Future<String?> read(String key) async {
    final keyMap = {
      'access_token': 'jwtAccessToken',
      'refresh_token': 'jwtRefreshToken',
    };
    return await secureStorage.read(key: keyMap[key] ?? key);
  }

  Future<void> delete(String key) async {
    final keyMap = {
      'access_token': 'jwtAccessToken',
      'refresh_token': 'jwtRefreshToken',
    };
    await secureStorage.delete(key: keyMap[key] ?? key);
  }

  Future<void> deleteAll() async {
    await secureStorage.deleteAll();
  }
}
