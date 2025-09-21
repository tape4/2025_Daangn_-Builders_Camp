// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profile_image: json['profile_image'] as String? ?? "",
      rating: (json['rating'] as num?)?.toDouble() ?? 36.5,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'phoneNumber': instance.phoneNumber,
      'profile_image': instance.profile_image,
      'rating': instance.rating,
    };
