import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_model.freezed.dart';
part 'reservation_model.g.dart';

// Model for spaces that I've lent out (내가 빌려준 공간)
@freezed
class MySpaceReservation with _$MySpaceReservation {
  const factory MySpaceReservation({
    required int id,
    required String title,
    required String imageUrl,
    required String region,
    required String address,
    required double width,
    required double depth,
    required double height,
    required Map<String, int> storageOptions,
    required Map<String, double> storagePrices,
    required DateTime createdAt,
    required String status,
    @Default(0.0) double totalIncome,
    @Default(0) int currentRentedCount,
    @Default(0) int totalCapacity,
    DateTime? startDate,
    DateTime? endDate,
    String? renterName,
    String? renterPhone,
    String? renterProfileImage,
  }) = _MySpaceReservation;

  factory MySpaceReservation.fromJson(Map<String, dynamic> json) =>
      _$MySpaceReservationFromJson(json);
}

// Model for spaces that I'm renting (내가 대여중인 공간)
@freezed
class MyRentalReservation with _$MyRentalReservation {
  const factory MyRentalReservation({
    required int id,
    required String spaceName,
    required String spaceImageUrl,
    required String ownerName,
    required String ownerPhone,
    String? ownerProfileImage,
    required String region,
    required String address,
    required DateTime startDate,
    required DateTime endDate,
    required String itemType,
    required int quantity,
    required double monthlyPrice,
    required double totalPrice,
    required String status,
    String? note,
    DateTime? createdAt,
  }) = _MyRentalReservation;

  factory MyRentalReservation.fromJson(Map<String, dynamic> json) =>
      _$MyRentalReservationFromJson(json);
}

// Response wrapper for API responses
@freezed
class ReservationListResponse with _$ReservationListResponse {
  const factory ReservationListResponse({
    required List<dynamic> data,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(0) int totalCount,
  }) = _ReservationListResponse;

  factory ReservationListResponse.fromJson(Map<String, dynamic> json) =>
      _$ReservationListResponseFromJson(json);
}