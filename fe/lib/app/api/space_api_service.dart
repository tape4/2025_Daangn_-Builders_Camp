import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/api/dio_client.dart';
import 'package:hankan/app/api/result.dart';
import 'package:hankan/app/model/space_detail_model.dart';

class SpaceApiService {
  static SpaceApiService get I => GetIt.I<SpaceApiService>();

  late final MyDio _dio;

  SpaceApiService() {
    _dio = MyDio(dio: Dio());
  }

  Future<Result<SpaceDetail>> getSpaceDetail(int spaceId) => _dio.get(
    '/api/spaces/$spaceId',
    fromJson: SpaceDetail.fromJson,
  );

  Future<Result<Map<String, dynamic>>> createRentalRequest({
    required int spaceId,
    required String size,
    required int quantity,
    DateTime? startDate,
    DateTime? endDate,
  }) => _dio.post(
    '/api/rental-requests',
    data: {
      'spaceId': spaceId,
      'size': size,
      'quantity': quantity,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    },
    fromJson: (json) => json,
  );

  Future<Result<List<SpaceDetail>>> getAvailableSpaces({
    String? region,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (region != null) queryParams['region'] = region;
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    final result = await _dio.get<Map<String, dynamic>>(
      '/api/spaces',
      queryParameters: queryParams,
      fromJson: (json) => json,
    );

    return result.map((data) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list.map((item) => SpaceDetail.fromJson(item as Map<String, dynamic>)).toList();
    });
  }
}