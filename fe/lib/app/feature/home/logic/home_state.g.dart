// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeStateImpl _$$HomeStateImplFromJson(Map<String, dynamic> json) =>
    _$HomeStateImpl(
      filters:
          (json['filters'] as List<dynamic>).map((e) => e as String).toList(),
      isBorrowMode: json['isBorrowMode'] as bool? ?? true,
      availableSpaces: (json['availableSpaces'] as List<dynamic>?)
              ?.map((e) => SpaceDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentCarouselIndex:
          (json['currentCarouselIndex'] as num?)?.toInt() ?? 0,
      isLoading: json['isLoading'] as bool? ?? false,
      hasError: json['hasError'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$HomeStateImplToJson(_$HomeStateImpl instance) =>
    <String, dynamic>{
      'filters': instance.filters,
      'isBorrowMode': instance.isBorrowMode,
      'availableSpaces': instance.availableSpaces,
      'currentCarouselIndex': instance.currentCarouselIndex,
      'isLoading': instance.isLoading,
      'hasError': instance.hasError,
      'errorMessage': instance.errorMessage,
    };
