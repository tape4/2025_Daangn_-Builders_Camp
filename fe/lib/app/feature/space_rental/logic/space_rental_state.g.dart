// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_rental_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpaceRentalStateImpl _$$SpaceRentalStateImplFromJson(
        Map<String, dynamic> json) =>
    _$SpaceRentalStateImpl(
      imagePath: json['imagePath'] as String?,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      region: json['region'] as String? ?? '',
      detailAddress: json['detailAddress'] as String? ?? '',
      optionQuantities:
          (json['optionQuantities'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    $enumDecode(_$StorageOptionEnumMap, k), (e as num).toInt()),
              ) ??
              const {},
      optionPrices: (json['optionPrices'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                $enumDecode(_$StorageOptionEnumMap, k), (e as num).toInt()),
          ) ??
          const {},
      isLoading: json['isLoading'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$SpaceRentalStateImplToJson(
        _$SpaceRentalStateImpl instance) =>
    <String, dynamic>{
      'imagePath': instance.imagePath,
      'width': instance.width,
      'depth': instance.depth,
      'height': instance.height,
      'region': instance.region,
      'detailAddress': instance.detailAddress,
      'optionQuantities': instance.optionQuantities
          .map((k, e) => MapEntry(_$StorageOptionEnumMap[k]!, e)),
      'optionPrices': instance.optionPrices
          .map((k, e) => MapEntry(_$StorageOptionEnumMap[k]!, e)),
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
    };

const _$StorageOptionEnumMap = {
  StorageOption.box: 'box',
  StorageOption.xs: 'xs',
  StorageOption.s: 's',
  StorageOption.m: 'm',
  StorageOption.l: 'l',
};
