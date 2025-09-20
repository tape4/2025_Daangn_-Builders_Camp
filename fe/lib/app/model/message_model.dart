import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/model/sendbird_user_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String message_id,
    required String message,
    required String channel_url,
    required String type,
    required SendbirdUserModel sender,
    required int created_at,
    @Default(false) bool is_mine,
    @Default('') String custom_type,
    @Default({}) Map<String, dynamic> data,
    @Default(0) int updated_at,
    String? file_url,
    String? file_name,
    String? file_type,
    int? file_size,
    @Default([]) List<String> thumbnails,
    @Default('none') String sending_status,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}