// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) {
  return _ChannelModel.fromJson(json);
}

/// @nodoc
mixin _$ChannelModel {
  String get channel_url => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cover_url => throw _privateConstructorUsedError;
  int get member_count => throw _privateConstructorUsedError;
  int get unread_message_count => throw _privateConstructorUsedError;
  String? get last_message => throw _privateConstructorUsedError;
  int? get last_message_created_at => throw _privateConstructorUsedError;
  bool get is_typing => throw _privateConstructorUsedError;
  List<String> get typing_members => throw _privateConstructorUsedError;
  Map<String, dynamic> get custom_type => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Serializes this ChannelModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChannelModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChannelModelCopyWith<ChannelModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelModelCopyWith<$Res> {
  factory $ChannelModelCopyWith(
          ChannelModel value, $Res Function(ChannelModel) then) =
      _$ChannelModelCopyWithImpl<$Res, ChannelModel>;
  @useResult
  $Res call(
      {String channel_url,
      String name,
      String cover_url,
      int member_count,
      int unread_message_count,
      String? last_message,
      int? last_message_created_at,
      bool is_typing,
      List<String> typing_members,
      Map<String, dynamic> custom_type,
      Map<String, dynamic> data});
}

/// @nodoc
class _$ChannelModelCopyWithImpl<$Res, $Val extends ChannelModel>
    implements $ChannelModelCopyWith<$Res> {
  _$ChannelModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChannelModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel_url = null,
    Object? name = null,
    Object? cover_url = null,
    Object? member_count = null,
    Object? unread_message_count = null,
    Object? last_message = freezed,
    Object? last_message_created_at = freezed,
    Object? is_typing = null,
    Object? typing_members = null,
    Object? custom_type = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      channel_url: null == channel_url
          ? _value.channel_url
          : channel_url // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cover_url: null == cover_url
          ? _value.cover_url
          : cover_url // ignore: cast_nullable_to_non_nullable
              as String,
      member_count: null == member_count
          ? _value.member_count
          : member_count // ignore: cast_nullable_to_non_nullable
              as int,
      unread_message_count: null == unread_message_count
          ? _value.unread_message_count
          : unread_message_count // ignore: cast_nullable_to_non_nullable
              as int,
      last_message: freezed == last_message
          ? _value.last_message
          : last_message // ignore: cast_nullable_to_non_nullable
              as String?,
      last_message_created_at: freezed == last_message_created_at
          ? _value.last_message_created_at
          : last_message_created_at // ignore: cast_nullable_to_non_nullable
              as int?,
      is_typing: null == is_typing
          ? _value.is_typing
          : is_typing // ignore: cast_nullable_to_non_nullable
              as bool,
      typing_members: null == typing_members
          ? _value.typing_members
          : typing_members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      custom_type: null == custom_type
          ? _value.custom_type
          : custom_type // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChannelModelImplCopyWith<$Res>
    implements $ChannelModelCopyWith<$Res> {
  factory _$$ChannelModelImplCopyWith(
          _$ChannelModelImpl value, $Res Function(_$ChannelModelImpl) then) =
      __$$ChannelModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String channel_url,
      String name,
      String cover_url,
      int member_count,
      int unread_message_count,
      String? last_message,
      int? last_message_created_at,
      bool is_typing,
      List<String> typing_members,
      Map<String, dynamic> custom_type,
      Map<String, dynamic> data});
}

/// @nodoc
class __$$ChannelModelImplCopyWithImpl<$Res>
    extends _$ChannelModelCopyWithImpl<$Res, _$ChannelModelImpl>
    implements _$$ChannelModelImplCopyWith<$Res> {
  __$$ChannelModelImplCopyWithImpl(
      _$ChannelModelImpl _value, $Res Function(_$ChannelModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChannelModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel_url = null,
    Object? name = null,
    Object? cover_url = null,
    Object? member_count = null,
    Object? unread_message_count = null,
    Object? last_message = freezed,
    Object? last_message_created_at = freezed,
    Object? is_typing = null,
    Object? typing_members = null,
    Object? custom_type = null,
    Object? data = null,
  }) {
    return _then(_$ChannelModelImpl(
      channel_url: null == channel_url
          ? _value.channel_url
          : channel_url // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cover_url: null == cover_url
          ? _value.cover_url
          : cover_url // ignore: cast_nullable_to_non_nullable
              as String,
      member_count: null == member_count
          ? _value.member_count
          : member_count // ignore: cast_nullable_to_non_nullable
              as int,
      unread_message_count: null == unread_message_count
          ? _value.unread_message_count
          : unread_message_count // ignore: cast_nullable_to_non_nullable
              as int,
      last_message: freezed == last_message
          ? _value.last_message
          : last_message // ignore: cast_nullable_to_non_nullable
              as String?,
      last_message_created_at: freezed == last_message_created_at
          ? _value.last_message_created_at
          : last_message_created_at // ignore: cast_nullable_to_non_nullable
              as int?,
      is_typing: null == is_typing
          ? _value.is_typing
          : is_typing // ignore: cast_nullable_to_non_nullable
              as bool,
      typing_members: null == typing_members
          ? _value._typing_members
          : typing_members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      custom_type: null == custom_type
          ? _value._custom_type
          : custom_type // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChannelModelImpl implements _ChannelModel {
  const _$ChannelModelImpl(
      {required this.channel_url,
      required this.name,
      this.cover_url = '',
      this.member_count = 0,
      this.unread_message_count = 0,
      this.last_message,
      this.last_message_created_at,
      this.is_typing = false,
      final List<String> typing_members = const [],
      final Map<String, dynamic> custom_type = const {},
      final Map<String, dynamic> data = const {}})
      : _typing_members = typing_members,
        _custom_type = custom_type,
        _data = data;

  factory _$ChannelModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelModelImplFromJson(json);

  @override
  final String channel_url;
  @override
  final String name;
  @override
  @JsonKey()
  final String cover_url;
  @override
  @JsonKey()
  final int member_count;
  @override
  @JsonKey()
  final int unread_message_count;
  @override
  final String? last_message;
  @override
  final int? last_message_created_at;
  @override
  @JsonKey()
  final bool is_typing;
  final List<String> _typing_members;
  @override
  @JsonKey()
  List<String> get typing_members {
    if (_typing_members is EqualUnmodifiableListView) return _typing_members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typing_members);
  }

  final Map<String, dynamic> _custom_type;
  @override
  @JsonKey()
  Map<String, dynamic> get custom_type {
    if (_custom_type is EqualUnmodifiableMapView) return _custom_type;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_custom_type);
  }

  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'ChannelModel(channel_url: $channel_url, name: $name, cover_url: $cover_url, member_count: $member_count, unread_message_count: $unread_message_count, last_message: $last_message, last_message_created_at: $last_message_created_at, is_typing: $is_typing, typing_members: $typing_members, custom_type: $custom_type, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelModelImpl &&
            (identical(other.channel_url, channel_url) ||
                other.channel_url == channel_url) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cover_url, cover_url) ||
                other.cover_url == cover_url) &&
            (identical(other.member_count, member_count) ||
                other.member_count == member_count) &&
            (identical(other.unread_message_count, unread_message_count) ||
                other.unread_message_count == unread_message_count) &&
            (identical(other.last_message, last_message) ||
                other.last_message == last_message) &&
            (identical(
                    other.last_message_created_at, last_message_created_at) ||
                other.last_message_created_at == last_message_created_at) &&
            (identical(other.is_typing, is_typing) ||
                other.is_typing == is_typing) &&
            const DeepCollectionEquality()
                .equals(other._typing_members, _typing_members) &&
            const DeepCollectionEquality()
                .equals(other._custom_type, _custom_type) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      channel_url,
      name,
      cover_url,
      member_count,
      unread_message_count,
      last_message,
      last_message_created_at,
      is_typing,
      const DeepCollectionEquality().hash(_typing_members),
      const DeepCollectionEquality().hash(_custom_type),
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of ChannelModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelModelImplCopyWith<_$ChannelModelImpl> get copyWith =>
      __$$ChannelModelImplCopyWithImpl<_$ChannelModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelModelImplToJson(
      this,
    );
  }
}

abstract class _ChannelModel implements ChannelModel {
  const factory _ChannelModel(
      {required final String channel_url,
      required final String name,
      final String cover_url,
      final int member_count,
      final int unread_message_count,
      final String? last_message,
      final int? last_message_created_at,
      final bool is_typing,
      final List<String> typing_members,
      final Map<String, dynamic> custom_type,
      final Map<String, dynamic> data}) = _$ChannelModelImpl;

  factory _ChannelModel.fromJson(Map<String, dynamic> json) =
      _$ChannelModelImpl.fromJson;

  @override
  String get channel_url;
  @override
  String get name;
  @override
  String get cover_url;
  @override
  int get member_count;
  @override
  int get unread_message_count;
  @override
  String? get last_message;
  @override
  int? get last_message_created_at;
  @override
  bool get is_typing;
  @override
  List<String> get typing_members;
  @override
  Map<String, dynamic> get custom_type;
  @override
  Map<String, dynamic> get data;

  /// Create a copy of ChannelModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChannelModelImplCopyWith<_$ChannelModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
