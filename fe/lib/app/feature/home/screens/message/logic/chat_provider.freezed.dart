// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatState {
  String get channelUrl => throw _privateConstructorUsedError;
  List<MessageModel> get messages => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  bool get isSending => throw _privateConstructorUsedError;
  List<String> get typingUserIds => throw _privateConstructorUsedError;
  GroupChannel? get channel => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatStateCopyWith<ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
  @useResult
  $Res call(
      {String channelUrl,
      List<MessageModel> messages,
      bool isLoading,
      bool hasMore,
      bool isLoadingMore,
      bool isSending,
      List<String> typingUserIds,
      GroupChannel? channel,
      String? errorMessage});
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelUrl = null,
    Object? messages = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? isSending = null,
    Object? typingUserIds = null,
    Object? channel = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      channelUrl: null == channelUrl
          ? _value.channelUrl
          : channelUrl // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isSending: null == isSending
          ? _value.isSending
          : isSending // ignore: cast_nullable_to_non_nullable
              as bool,
      typingUserIds: null == typingUserIds
          ? _value.typingUserIds
          : typingUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as GroupChannel?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatStateImplCopyWith<$Res>
    implements $ChatStateCopyWith<$Res> {
  factory _$$ChatStateImplCopyWith(
          _$ChatStateImpl value, $Res Function(_$ChatStateImpl) then) =
      __$$ChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String channelUrl,
      List<MessageModel> messages,
      bool isLoading,
      bool hasMore,
      bool isLoadingMore,
      bool isSending,
      List<String> typingUserIds,
      GroupChannel? channel,
      String? errorMessage});
}

/// @nodoc
class __$$ChatStateImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateImpl>
    implements _$$ChatStateImplCopyWith<$Res> {
  __$$ChatStateImplCopyWithImpl(
      _$ChatStateImpl _value, $Res Function(_$ChatStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelUrl = null,
    Object? messages = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? isSending = null,
    Object? typingUserIds = null,
    Object? channel = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ChatStateImpl(
      channelUrl: null == channelUrl
          ? _value.channelUrl
          : channelUrl // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isSending: null == isSending
          ? _value.isSending
          : isSending // ignore: cast_nullable_to_non_nullable
              as bool,
      typingUserIds: null == typingUserIds
          ? _value._typingUserIds
          : typingUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as GroupChannel?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChatStateImpl implements _ChatState {
  const _$ChatStateImpl(
      {required this.channelUrl,
      final List<MessageModel> messages = const [],
      this.isLoading = false,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.isSending = false,
      final List<String> typingUserIds = const [],
      this.channel,
      this.errorMessage})
      : _messages = messages,
        _typingUserIds = typingUserIds;

  @override
  final String channelUrl;
  final List<MessageModel> _messages;
  @override
  @JsonKey()
  List<MessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool isSending;
  final List<String> _typingUserIds;
  @override
  @JsonKey()
  List<String> get typingUserIds {
    if (_typingUserIds is EqualUnmodifiableListView) return _typingUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typingUserIds);
  }

  @override
  final GroupChannel? channel;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ChatState(channelUrl: $channelUrl, messages: $messages, isLoading: $isLoading, hasMore: $hasMore, isLoadingMore: $isLoadingMore, isSending: $isSending, typingUserIds: $typingUserIds, channel: $channel, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateImpl &&
            (identical(other.channelUrl, channelUrl) ||
                other.channelUrl == channelUrl) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isSending, isSending) ||
                other.isSending == isSending) &&
            const DeepCollectionEquality()
                .equals(other._typingUserIds, _typingUserIds) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      channelUrl,
      const DeepCollectionEquality().hash(_messages),
      isLoading,
      hasMore,
      isLoadingMore,
      isSending,
      const DeepCollectionEquality().hash(_typingUserIds),
      channel,
      errorMessage);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      __$$ChatStateImplCopyWithImpl<_$ChatStateImpl>(this, _$identity);
}

abstract class _ChatState implements ChatState {
  const factory _ChatState(
      {required final String channelUrl,
      final List<MessageModel> messages,
      final bool isLoading,
      final bool hasMore,
      final bool isLoadingMore,
      final bool isSending,
      final List<String> typingUserIds,
      final GroupChannel? channel,
      final String? errorMessage}) = _$ChatStateImpl;

  @override
  String get channelUrl;
  @override
  List<MessageModel> get messages;
  @override
  bool get isLoading;
  @override
  bool get hasMore;
  @override
  bool get isLoadingMore;
  @override
  bool get isSending;
  @override
  List<String> get typingUserIds;
  @override
  GroupChannel? get channel;
  @override
  String? get errorMessage;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
