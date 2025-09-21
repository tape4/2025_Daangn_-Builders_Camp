// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_storage_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemStorageStateImpl _$$ItemStorageStateImplFromJson(
        Map<String, dynamic> json) =>
    _$ItemStorageStateImpl(
      imageUrl: json['imageUrl'] as String? ?? '',
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      region: json['region'] as String? ?? '',
      detailAddress: json['detailAddress'] as String? ?? '',
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      minPrice: (json['minPrice'] as num?)?.toInt() ?? 0,
      maxPrice: (json['maxPrice'] as num?)?.toInt() ?? 0,
      isLoading: json['isLoading'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$ItemStorageStateImplToJson(
        _$ItemStorageStateImpl instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'width': instance.width,
      'depth': instance.depth,
      'height': instance.height,
      'region': instance.region,
      'detailAddress': instance.detailAddress,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
    };
