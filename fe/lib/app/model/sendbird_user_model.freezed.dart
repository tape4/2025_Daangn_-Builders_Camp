// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sendbird_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SendbirdUserModel _$SendbirdUserModelFromJson(Map<String, dynamic> json) {
  return _SendbirdUserModel.fromJson(json);
}

/// @nodoc
mixin _$SendbirdUserModel {
  String get user_id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String get profile_url => throw _privateConstructorUsedError;
  bool get is_active => throw _privateConstructorUsedError;
  bool get is_online => throw _privateConstructorUsedError;
  int? get last_seen_at => throw _privateConstructorUsedError;
  Map<String, String> get metadata => throw _privateConstructorUsedError;

  /// Serializes this SendbirdUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendbirdUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendbirdUserModelCopyWith<SendbirdUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendbirdUserModelCopyWith<$Res> {
  factory $SendbirdUserModelCopyWith(
          SendbirdUserModel value, $Res Function(SendbirdUserModel) then) =
      _$SendbirdUserModelCopyWithImpl<$Res, SendbirdUserModel>;
  @useResult
  $Res call(
      {String user_id,
      String nickname,
      String profile_url,
      bool is_active,
      bool is_online,
      int? last_seen_at,
      Map<String, String> metadata});
}

/// @nodoc
class _$SendbirdUserModelCopyWithImpl<$Res, $Val extends SendbirdUserModel>
    implements $SendbirdUserModelCopyWith<$Res> {
  _$SendbirdUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendbirdUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_id = null,
    Object? nickname = null,
    Object? profile_url = null,
    Object? is_active = null,
    Object? is_online = null,
    Object? last_seen_at = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profile_url: null == profile_url
          ? _value.profile_url
          : profile_url // ignore: cast_nullable_to_non_nullable
              as String,
      is_active: null == is_active
          ? _value.is_active
          : is_active // ignore: cast_nullable_to_non_nullable
              as bool,
      is_online: null == is_online
          ? _value.is_online
          : is_online // ignore: cast_nullable_to_non_nullable
              as bool,
      last_seen_at: freezed == last_seen_at
          ? _value.last_seen_at
          : last_seen_at // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendbirdUserModelImplCopyWith<$Res>
    implements $SendbirdUserModelCopyWith<$Res> {
  factory _$$SendbirdUserModelImplCopyWith(_$SendbirdUserModelImpl value,
          $Res Function(_$SendbirdUserModelImpl) then) =
      __$$SendbirdUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String user_id,
      String nickname,
      String profile_url,
      bool is_active,
      bool is_online,
      int? last_seen_at,
      Map<String, String> metadata});
}

/// @nodoc
class __$$SendbirdUserModelImplCopyWithImpl<$Res>
    extends _$SendbirdUserModelCopyWithImpl<$Res, _$SendbirdUserModelImpl>
    implements _$$SendbirdUserModelImplCopyWith<$Res> {
  __$$SendbirdUserModelImplCopyWithImpl(_$SendbirdUserModelImpl _value,
      $Res Function(_$SendbirdUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SendbirdUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_id = null,
    Object? nickname = null,
    Object? profile_url = null,
    Object? is_active = null,
    Object? is_online = null,
    Object? last_seen_at = freezed,
    Object? metadata = null,
  }) {
    return _then(_$SendbirdUserModelImpl(
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profile_url: null == profile_url
          ? _value.profile_url
          : profile_url // ignore: cast_nullable_to_non_nullable
              as String,
      is_active: null == is_active
          ? _value.is_active
          : is_active // ignore: cast_nullable_to_non_nullable
              as bool,
      is_online: null == is_online
          ? _value.is_online
          : is_online // ignore: cast_nullable_to_non_nullable
              as bool,
      last_seen_at: freezed == last_seen_at
          ? _value.last_seen_at
          : last_seen_at // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendbirdUserModelImpl implements _SendbirdUserModel {
  const _$SendbirdUserModelImpl(
      {required this.user_id,
      required this.nickname,
      this.profile_url = '',
      this.is_active = false,
      this.is_online = false,
      this.last_seen_at,
      final Map<String, String> metadata = const {}})
      : _metadata = metadata;

  factory _$SendbirdUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendbirdUserModelImplFromJson(json);

  @override
  final String user_id;
  @override
  final String nickname;
  @override
  @JsonKey()
  final String profile_url;
  @override
  @JsonKey()
  final bool is_active;
  @override
  @JsonKey()
  final bool is_online;
  @override
  final int? last_seen_at;
  final Map<String, String> _metadata;
  @override
  @JsonKey()
  Map<String, String> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'SendbirdUserModel(user_id: $user_id, nickname: $nickname, profile_url: $profile_url, is_active: $is_active, is_online: $is_online, last_seen_at: $last_seen_at, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendbirdUserModelImpl &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profile_url, profile_url) ||
                other.profile_url == profile_url) &&
            (identical(other.is_active, is_active) ||
                other.is_active == is_active) &&
            (identical(other.is_online, is_online) ||
                other.is_online == is_online) &&
            (identical(other.last_seen_at, last_seen_at) ||
                other.last_seen_at == last_seen_at) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      user_id,
      nickname,
      profile_url,
      is_active,
      is_online,
      last_seen_at,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of SendbirdUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendbirdUserModelImplCopyWith<_$SendbirdUserModelImpl> get copyWith =>
      __$$SendbirdUserModelImplCopyWithImpl<_$SendbirdUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendbirdUserModelImplToJson(
      this,
    );
  }
}

abstract class _SendbirdUserModel implements SendbirdUserModel {
  const factory _SendbirdUserModel(
      {required final String user_id,
      required final String nickname,
      final String profile_url,
      final bool is_active,
      final bool is_online,
      final int? last_seen_at,
      final Map<String, String> metadata}) = _$SendbirdUserModelImpl;

  factory _SendbirdUserModel.fromJson(Map<String, dynamic> json) =
      _$SendbirdUserModelImpl.fromJson;

  @override
  String get user_id;
  @override
  String get nickname;
  @override
  String get profile_url;
  @override
  bool get is_active;
  @override
  bool get is_online;
  @override
  int? get last_seen_at;
  @override
  Map<String, String> get metadata;

  /// Create a copy of SendbirdUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendbirdUserModelImplCopyWith<_$SendbirdUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
