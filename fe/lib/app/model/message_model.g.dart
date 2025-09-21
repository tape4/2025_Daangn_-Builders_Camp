// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      message_id: json['message_id'] as String,
      message: json['message'] as String,
      channel_url: json['channel_url'] as String,
      type: json['type'] as String,
      sender:
          SendbirdUserModel.fromJson(json['sender'] as Map<String, dynamic>),
      created_at: (json['created_at'] as num).toInt(),
      is_mine: json['is_mine'] as bool? ?? false,
      custom_type: json['custom_type'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>? ?? const {},
      updated_at: (json['updated_at'] as num?)?.toInt() ?? 0,
      file_url: json['file_url'] as String?,
      file_name: json['file_name'] as String?,
      file_type: json['file_type'] as String?,
      file_size: (json['file_size'] as num?)?.toInt(),
      thumbnails: (json['thumbnails'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sending_status: json['sending_status'] as String? ?? 'none',
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'message_id': instance.message_id,
      'message': instance.message,
      'channel_url': instance.channel_url,
      'type': instance.type,
      'sender': instance.sender,
      'created_at': instance.created_at,
      'is_mine': instance.is_mine,
      'custom_type': instance.custom_type,
      'data': instance.data,
      'updated_at': instance.updated_at,
      'file_url': instance.file_url,
      'file_name': instance.file_name,
      'file_type': instance.file_type,
      'file_size': instance.file_size,
      'thumbnails': instance.thumbnails,
      'sending_status': instance.sending_status,
    };
