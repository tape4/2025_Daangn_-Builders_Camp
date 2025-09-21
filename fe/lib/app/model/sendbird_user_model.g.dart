// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sendbird_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SendbirdUserModelImpl _$$SendbirdUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SendbirdUserModelImpl(
      user_id: json['user_id'] as String,
      nickname: json['nickname'] as String,
      profile_url: json['profile_url'] as String? ?? '',
      is_active: json['is_active'] as bool? ?? false,
      is_online: json['is_online'] as bool? ?? false,
      last_seen_at: (json['last_seen_at'] as num?)?.toInt(),
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$SendbirdUserModelImplToJson(
        _$SendbirdUserModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'nickname': instance.nickname,
      'profile_url': instance.profile_url,
      'is_active': instance.is_active,
      'is_online': instance.is_online,
      'last_seen_at': instance.last_seen_at,
      'metadata': instance.metadata,
    };
