import 'package:freezed_annotation/freezed_annotation.dart';

part 'space_detail_model.freezed.dart';
part 'space_detail_model.g.dart';

@freezed
class SpaceDetail with _$SpaceDetail {
  const factory SpaceDetail({
    required DateTime createdAt,
    required DateTime updatedAt,
    required int id,
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required String address,
    required String imageUrl,
    required int boxCapacityXs,
    required int boxCapacityS,
    required int boxCapacityM,
    required int boxCapacityL,
    required int boxCapacityXl,
    required double rating,
    required int reviewCount,
    required SpaceOwner owner,
    required DateTime availableStartDate,
    required DateTime availableEndDate,
    required int totalBoxCount,
  }) = _SpaceDetail;

  factory SpaceDetail.fromJson(Map<String, dynamic> json) =>
      _$SpaceDetailFromJson(json);
}

@freezed
class SpaceOwner with _$SpaceOwner {
  const factory SpaceOwner({
    required DateTime createdAt,
    required DateTime updatedAt,
    required int id,
    required String phoneNumber,
    required String nickname,
    required DateTime birthDate,
    required String gender,
    required String profileImageUrl,
    required double rating,
    required int reviewCount,
  }) = _SpaceOwner;

  factory SpaceOwner.fromJson(Map<String, dynamic> json) =>
      _$SpaceOwnerFromJson(json);
}