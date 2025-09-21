// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get message_id => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get channel_url => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  SendbirdUserModel get sender => throw _privateConstructorUsedError;
  int get created_at => throw _privateConstructorUsedError;
  bool get is_mine => throw _privateConstructorUsedError;
  String get custom_type => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  int get updated_at => throw _privateConstructorUsedError;
  String? get file_url => throw _privateConstructorUsedError;
  String? get file_name => throw _privateConstructorUsedError;
  String? get file_type => throw _privateConstructorUsedError;
  int? get file_size => throw _privateConstructorUsedError;
  List<String> get thumbnails => throw _privateConstructorUsedError;
  String get sending_status => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String message_id,
      String message,
      String channel_url,
      String type,
      SendbirdUserModel sender,
      int created_at,
      bool is_mine,
      String custom_type,
      Map<String, dynamic> data,
      int updated_at,
      String? file_url,
      String? file_name,
      String? file_type,
      int? file_size,
      List<String> thumbnails,
      String sending_status});

  $SendbirdUserModelCopyWith<$Res> get sender;
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message_id = null,
    Object? message = null,
    Object? channel_url = null,
    Object? type = null,
    Object? sender = null,
    Object? created_at = null,
    Object? is_mine = null,
    Object? custom_type = null,
    Object? data = null,
    Object? updated_at = null,
    Object? file_url = freezed,
    Object? file_name = freezed,
    Object? file_type = freezed,
    Object? file_size = freezed,
    Object? thumbnails = null,
    Object? sending_status = null,
  }) {
    return _then(_value.copyWith(
      message_id: null == message_id
          ? _value.message_id
          : message_id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      channel_url: null == channel_url
          ? _value.channel_url
          : channel_url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as SendbirdUserModel,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      is_mine: null == is_mine
          ? _value.is_mine
          : is_mine // ignore: cast_nullable_to_non_nullable
              as bool,
      custom_type: null == custom_type
          ? _value.custom_type
          : custom_type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      file_url: freezed == file_url
          ? _value.file_url
          : file_url // ignore: cast_nullable_to_non_nullable
              as String?,
      file_name: freezed == file_name
          ? _value.file_name
          : file_name // ignore: cast_nullable_to_non_nullable
              as String?,
      file_type: freezed == file_type
          ? _value.file_type
          : file_type // ignore: cast_nullable_to_non_nullable
              as String?,
      file_size: freezed == file_size
          ? _value.file_size
          : file_size // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnails: null == thumbnails
          ? _value.thumbnails
          : thumbnails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sending_status: null == sending_status
          ? _value.sending_status
          : sending_status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SendbirdUserModelCopyWith<$Res> get sender {
    return $SendbirdUserModelCopyWith<$Res>(_value.sender, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message_id,
      String message,
      String channel_url,
      String type,
      SendbirdUserModel sender,
      int created_at,
      bool is_mine,
      String custom_type,
      Map<String, dynamic> data,
      int updated_at,
      String? file_url,
      String? file_name,
      String? file_type,
      int? file_size,
      List<String> thumbnails,
      String sending_status});

  @override
  $SendbirdUserModelCopyWith<$Res> get sender;
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message_id = null,
    Object? message = null,
    Object? channel_url = null,
    Object? type = null,
    Object? sender = null,
    Object? created_at = null,
    Object? is_mine = null,
    Object? custom_type = null,
    Object? data = null,
    Object? updated_at = null,
    Object? file_url = freezed,
    Object? file_name = freezed,
    Object? file_type = freezed,
    Object? file_size = freezed,
    Object? thumbnails = null,
    Object? sending_status = null,
  }) {
    return _then(_$MessageModelImpl(
      message_id: null == message_id
          ? _value.message_id
          : message_id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      channel_url: null == channel_url
          ? _value.channel_url
          : channel_url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as SendbirdUserModel,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      is_mine: null == is_mine
          ? _value.is_mine
          : is_mine // ignore: cast_nullable_to_non_nullable
              as bool,
      custom_type: null == custom_type
          ? _value.custom_type
          : custom_type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as int,
      file_url: freezed == file_url
          ? _value.file_url
          : file_url // ignore: cast_nullable_to_non_nullable
              as String?,
      file_name: freezed == file_name
          ? _value.file_name
          : file_name // ignore: cast_nullable_to_non_nullable
              as String?,
      file_type: freezed == file_type
          ? _value.file_type
          : file_type // ignore: cast_nullable_to_non_nullable
              as String?,
      file_size: freezed == file_size
          ? _value.file_size
          : file_size // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnails: null == thumbnails
          ? _value._thumbnails
          : thumbnails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sending_status: null == sending_status
          ? _value.sending_status
          : sending_status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl(
      {required this.message_id,
      required this.message,
      required this.channel_url,
      required this.type,
      required this.sender,
      required this.created_at,
      this.is_mine = false,
      this.custom_type = '',
      final Map<String, dynamic> data = const {},
      this.updated_at = 0,
      this.file_url,
      this.file_name,
      this.file_type,
      this.file_size,
      final List<String> thumbnails = const [],
      this.sending_status = 'none'})
      : _data = data,
        _thumbnails = thumbnails;

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String message_id;
  @override
  final String message;
  @override
  final String channel_url;
  @override
  final String type;
  @override
  final SendbirdUserModel sender;
  @override
  final int created_at;
  @override
  @JsonKey()
  final bool is_mine;
  @override
  @JsonKey()
  final String custom_type;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final int updated_at;
  @override
  final String? file_url;
  @override
  final String? file_name;
  @override
  final String? file_type;
  @override
  final int? file_size;
  final List<String> _thumbnails;
  @override
  @JsonKey()
  List<String> get thumbnails {
    if (_thumbnails is EqualUnmodifiableListView) return _thumbnails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thumbnails);
  }

  @override
  @JsonKey()
  final String sending_status;

  @override
  String toString() {
    return 'MessageModel(message_id: $message_id, message: $message, channel_url: $channel_url, type: $type, sender: $sender, created_at: $created_at, is_mine: $is_mine, custom_type: $custom_type, data: $data, updated_at: $updated_at, file_url: $file_url, file_name: $file_name, file_type: $file_type, file_size: $file_size, thumbnails: $thumbnails, sending_status: $sending_status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.message_id, message_id) ||
                other.message_id == message_id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.channel_url, channel_url) ||
                other.channel_url == channel_url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.is_mine, is_mine) || other.is_mine == is_mine) &&
            (identical(other.custom_type, custom_type) ||
                other.custom_type == custom_type) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.file_url, file_url) ||
                other.file_url == file_url) &&
            (identical(other.file_name, file_name) ||
                other.file_name == file_name) &&
            (identical(other.file_type, file_type) ||
                other.file_type == file_type) &&
            (identical(other.file_size, file_size) ||
                other.file_size == file_size) &&
            const DeepCollectionEquality()
                .equals(other._thumbnails, _thumbnails) &&
            (identical(other.sending_status, sending_status) ||
                other.sending_status == sending_status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      message_id,
      message,
      channel_url,
      type,
      sender,
      created_at,
      is_mine,
      custom_type,
      const DeepCollectionEquality().hash(_data),
      updated_at,
      file_url,
      file_name,
      file_type,
      file_size,
      const DeepCollectionEquality().hash(_thumbnails),
      sending_status);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel(
      {required final String message_id,
      required final String message,
      required final String channel_url,
      required final String type,
      required final SendbirdUserModel sender,
      required final int created_at,
      final bool is_mine,
      final String custom_type,
      final Map<String, dynamic> data,
      final int updated_at,
      final String? file_url,
      final String? file_name,
      final String? file_type,
      final int? file_size,
      final List<String> thumbnails,
      final String sending_status}) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get message_id;
  @override
  String get message;
  @override
  String get channel_url;
  @override
  String get type;
  @override
  SendbirdUserModel get sender;
  @override
  int get created_at;
  @override
  bool get is_mine;
  @override
  String get custom_type;
  @override
  Map<String, dynamic> get data;
  @override
  int get updated_at;
  @override
  String? get file_url;
  @override
  String? get file_name;
  @override
  String? get file_type;
  @override
  int? get file_size;
  @override
  List<String> get thumbnails;
  @override
  String get sending_status;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
