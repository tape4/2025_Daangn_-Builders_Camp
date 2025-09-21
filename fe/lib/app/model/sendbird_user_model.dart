import 'package:freezed_annotation/freezed_annotation.dart';

part 'sendbird_user_model.freezed.dart';
part 'sendbird_user_model.g.dart';

@freezed
class SendbirdUserModel with _$SendbirdUserModel {
  const factory SendbirdUserModel({
    required String user_id,
    required String nickname,
    @Default('') String profile_url,
    @Default(false) bool is_active,
    @Default(false) bool is_online,
    int? last_seen_at,
    @Default({}) Map<String, String> metadata,
  }) = _SendbirdUserModel;

  factory SendbirdUserModel.fromJson(Map<String, dynamic> json) =>
      _$SendbirdUserModelFromJson(json);
}