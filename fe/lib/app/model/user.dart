import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    required int id,
    required String email,
    required String username,
    String? nickname,
    String? phone,
    @Default("") String profile_image,
    @Default(36.5) double rating,
    DateTime? created_at,
    DateTime? updated_at,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
