// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelModelImpl _$$ChannelModelImplFromJson(Map<String, dynamic> json) =>
    _$ChannelModelImpl(
      channel_url: json['channel_url'] as String,
      name: json['name'] as String,
      cover_url: json['cover_url'] as String? ?? '',
      member_count: (json['member_count'] as num?)?.toInt() ?? 0,
      unread_message_count:
          (json['unread_message_count'] as num?)?.toInt() ?? 0,
      last_message: json['last_message'] as String?,
      last_message_created_at:
          (json['last_message_created_at'] as num?)?.toInt(),
      is_typing: json['is_typing'] as bool? ?? false,
      typing_members: (json['typing_members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      custom_type: json['custom_type'] as Map<String, dynamic>? ?? const {},
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ChannelModelImplToJson(_$ChannelModelImpl instance) =>
    <String, dynamic>{
      'channel_url': instance.channel_url,
      'name': instance.name,
      'cover_url': instance.cover_url,
      'member_count': instance.member_count,
      'unread_message_count': instance.unread_message_count,
      'last_message': instance.last_message,
      'last_message_created_at': instance.last_message_created_at,
      'is_typing': instance.is_typing,
      'typing_members': instance.typing_members,
      'custom_type': instance.custom_type,
      'data': instance.data,
    };
