// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HistoryState _$HistoryStateFromJson(Map<String, dynamic> json) {
  return _HistoryState.fromJson(json);
}

/// @nodoc
mixin _$HistoryState {
  List<RentalHistory> get rentalHistories => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this HistoryState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryStateCopyWith<HistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryStateCopyWith<$Res> {
  factory $HistoryStateCopyWith(
          HistoryState value, $Res Function(HistoryState) then) =
      _$HistoryStateCopyWithImpl<$Res, HistoryState>;
  @useResult
  $Res call(
      {List<RentalHistory> rentalHistories,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$HistoryStateCopyWithImpl<$Res, $Val extends HistoryState>
    implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rentalHistories = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      rentalHistories: null == rentalHistories
          ? _value.rentalHistories
          : rentalHistories // ignore: cast_nullable_to_non_nullable
              as List<RentalHistory>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryStateImplCopyWith<$Res>
    implements $HistoryStateCopyWith<$Res> {
  factory _$$HistoryStateImplCopyWith(
          _$HistoryStateImpl value, $Res Function(_$HistoryStateImpl) then) =
      __$$HistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RentalHistory> rentalHistories,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$HistoryStateImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryStateImpl>
    implements _$$HistoryStateImplCopyWith<$Res> {
  __$$HistoryStateImplCopyWithImpl(
      _$HistoryStateImpl _value, $Res Function(_$HistoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rentalHistories = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HistoryStateImpl(
      rentalHistories: null == rentalHistories
          ? _value._rentalHistories
          : rentalHistories // ignore: cast_nullable_to_non_nullable
              as List<RentalHistory>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryStateImpl implements _HistoryState {
  const _$HistoryStateImpl(
      {final List<RentalHistory> rentalHistories = const [],
      this.isLoading = false,
      this.errorMessage})
      : _rentalHistories = rentalHistories;

  factory _$HistoryStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryStateImplFromJson(json);

  final List<RentalHistory> _rentalHistories;
  @override
  @JsonKey()
  List<RentalHistory> get rentalHistories {
    if (_rentalHistories is EqualUnmodifiableListView) return _rentalHistories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rentalHistories);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HistoryState(rentalHistories: $rentalHistories, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._rentalHistories, _rentalHistories) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_rentalHistories),
      isLoading,
      errorMessage);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      __$$HistoryStateImplCopyWithImpl<_$HistoryStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryStateImplToJson(
      this,
    );
  }
}

abstract class _HistoryState implements HistoryState {
  const factory _HistoryState(
      {final List<RentalHistory> rentalHistories,
      final bool isLoading,
      final String? errorMessage}) = _$HistoryStateImpl;

  factory _HistoryState.fromJson(Map<String, dynamic> json) =
      _$HistoryStateImpl.fromJson;

  @override
  List<RentalHistory> get rentalHistories;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
