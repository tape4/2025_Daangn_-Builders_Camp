import 'package:dio/dio.dart';
import 'package:hankan/app/api/api_error.dart';
import 'package:hankan/app/api/dio_client.dart';
import 'package:hankan/app/api/result.dart';
import 'package:hankan/app/auth/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/model/reservation_model.dart';
import 'package:hankan/app/model/token.dart';
import 'package:hankan/app/model/user.dart';

class ApiService {
  static ApiService get I => GetIt.I<ApiService>();

  late final MyDio _dio;
  late final Dio _kakaoDio;
  static const String _kakaoApiKey =
      'YOUR_KAKAO_REST_API_KEY'; // Replace with your actual API key

  void setAuthService(AuthService authService) =>
      _dio.setAuthService(authService);

  ApiService() {
    _dio = MyDio(dio: Dio());
    _kakaoDio = Dio(BaseOptions(
      baseUrl: 'https://dapi.kakao.com',
      headers: {
        'Authorization': 'KakaoAK $_kakaoApiKey',
      },
    ));
  }

  Future<Result<User>> getUser() => _dio.get(
        '/api/users/me',
        fromJson: User.fromJson,
      );

  Future<Result<Map<String, dynamic>>> sendOtp(String phoneNumber) => _dio.post(
        '/api/auth/sms/send',
        data: {'phoneNumber': phoneNumber},
        fromJson: (json) => json,
      );

  Future<Result<Token>> verifyOtp(String phoneNumber, String code) => _dio.post(
        '/api/auth/login',
        data: {
          'phoneNumber': phoneNumber,
          'verificationCode': code,
        },
        fromJson: Token.fromJson,
      );

  Future<Result<void>> logout() => _dio.post(
        '/api/auth/token/logout',
        fromJson: (_) {},
      );

  Future<Result<Token>> register(String phoneNumber, String nickname) =>
      _dio.post(
        '/api/auth/signup',
        queryParameters: {
          "phoneNumber": phoneNumber,
          "nickname": nickname,
          "birthDate": "1999-01-01",
          "gender": "MALE",
        },
        fromJson: Token.fromJson,
      );

  Future<Result<List<MySpaceReservation>>> getMySpaceReservations() async {
    final result = await _dio.get<Map<String, dynamic>>(
      '/api/reservations/my-spaces',
      fromJson: (json) => json,
    );

    return result.map((data) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((item) =>
              MySpaceReservation.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Result<List<MyRentalReservation>>> getMyReservations() async {
    final result = await _dio.get<Map<String, dynamic>>(
      '/api/reservations/my',
      fromJson: (json) => json,
    );

    return result.map((data) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((item) =>
              MyRentalReservation.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Result<(double latitude, double longitude)>> getKakaoGeoCoding({
    required String address,
  }) async {
    try {
      final response = await _kakaoDio.get(
        '/v2/local/search/address.JSON',
        queryParameters: {
          'query': address,
        },
      );

      return Result.success((
        double.parse(response.data['documents'][0]['y']),
        double.parse(response.data['documents'][0]['x']),
      ));
    } on DioException catch (e) {
      return Result.failure(
        e.response?.data?['message'] ??
            'Failed to get address from coordinates',
      );
    } catch (e) {
      return Result.failure(
        ApiError(type: ErrorType.unknown, message: e.toString()),
      );
    }
  }

  Future<Result<User>> updateUserProfile({
    String? nickname,
    String? profileImagePath,
  }) async {
    final formData = FormData();

    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      formData.files.add(MapEntry(
        'profileImage',
        await MultipartFile.fromFile(
          profileImagePath,
          filename: profileImagePath.split('/').last,
        ),
      ));
    }

    return _dio.patch(
      '/api/users/me',
      data: formData,
      queryParameters: nickname != null ? {'nickname': nickname} : null,
      fromJson: User.fromJson,
    );
  }
}
