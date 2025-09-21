// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpaceDetailImpl _$$SpaceDetailImplFromJson(Map<String, dynamic> json) =>
    _$SpaceDetailImpl(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String? ?? "",
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String? ?? "",
      boxCapacityXs: (json['boxCapacityXs'] as num).toInt(),
      boxCapacityS: (json['boxCapacityS'] as num).toInt(),
      boxCapacityM: (json['boxCapacityM'] as num).toInt(),
      boxCapacityL: (json['boxCapacityL'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      owner: SpaceOwner.fromJson(json['owner'] as Map<String, dynamic>),
      availableStartDate: DateTime.parse(json['availableStartDate'] as String),
      availableEndDate: DateTime.parse(json['availableEndDate'] as String),
      totalBoxCount: (json['totalBoxCount'] as num).toInt(),
    );

Map<String, dynamic> _$$SpaceDetailImplToJson(_$SpaceDetailImpl instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
      'boxCapacityXs': instance.boxCapacityXs,
      'boxCapacityS': instance.boxCapacityS,
      'boxCapacityM': instance.boxCapacityM,
      'boxCapacityL': instance.boxCapacityL,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'owner': instance.owner,
      'availableStartDate': instance.availableStartDate.toIso8601String(),
      'availableEndDate': instance.availableEndDate.toIso8601String(),
      'totalBoxCount': instance.totalBoxCount,
    };

_$SpaceOwnerImpl _$$SpaceOwnerImplFromJson(Map<String, dynamic> json) =>
    _$SpaceOwnerImpl(
      id: (json['id'] as num).toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      nickname: json['nickname'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      gender: json['gender'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SpaceOwnerImplToJson(_$SpaceOwnerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'nickname': instance.nickname,
      'birthDate': instance.birthDate?.toIso8601String(),
      'gender': instance.gender,
      'profileImageUrl': instance.profileImageUrl,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
    };
