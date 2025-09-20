import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_model.freezed.dart';
part 'channel_model.g.dart';

@freezed
abstract class ChannelModel with _$ChannelModel {
  const factory ChannelModel({
    required String channel_url,
    required String name,
    @Default('') String cover_url,
    @Default(0) int member_count,
    @Default(0) int unread_message_count,
    String? last_message,
    int? last_message_created_at,
    @Default(false) bool is_typing,
    @Default([]) List<String> typing_members,
    @Default({}) Map<String, dynamic> custom_type,
    @Default({}) Map<String, dynamic> data,
  }) = _ChannelModel;

  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);
}
