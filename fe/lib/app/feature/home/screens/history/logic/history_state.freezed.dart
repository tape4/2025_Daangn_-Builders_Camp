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
  List<MySpaceReservation> get mySpaces => throw _privateConstructorUsedError;
  List<MyRentalReservation> get myRentals => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  int get selectedTab => throw _privateConstructorUsedError;
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
      {List<MySpaceReservation> mySpaces,
      List<MyRentalReservation> myRentals,
      bool isLoading,
      int selectedTab,
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
    Object? mySpaces = null,
    Object? myRentals = null,
    Object? isLoading = null,
    Object? selectedTab = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      mySpaces: null == mySpaces
          ? _value.mySpaces
          : mySpaces // ignore: cast_nullable_to_non_nullable
              as List<MySpaceReservation>,
      myRentals: null == myRentals
          ? _value.myRentals
          : myRentals // ignore: cast_nullable_to_non_nullable
              as List<MyRentalReservation>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as int,
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
      {List<MySpaceReservation> mySpaces,
      List<MyRentalReservation> myRentals,
      bool isLoading,
      int selectedTab,
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
    Object? mySpaces = null,
    Object? myRentals = null,
    Object? isLoading = null,
    Object? selectedTab = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HistoryStateImpl(
      mySpaces: null == mySpaces
          ? _value._mySpaces
          : mySpaces // ignore: cast_nullable_to_non_nullable
              as List<MySpaceReservation>,
      myRentals: null == myRentals
          ? _value._myRentals
          : myRentals // ignore: cast_nullable_to_non_nullable
              as List<MyRentalReservation>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as int,
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
      {final List<MySpaceReservation> mySpaces = const [],
      final List<MyRentalReservation> myRentals = const [],
      this.isLoading = false,
      this.selectedTab = 0,
      this.errorMessage})
      : _mySpaces = mySpaces,
        _myRentals = myRentals;

  factory _$HistoryStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryStateImplFromJson(json);

  final List<MySpaceReservation> _mySpaces;
  @override
  @JsonKey()
  List<MySpaceReservation> get mySpaces {
    if (_mySpaces is EqualUnmodifiableListView) return _mySpaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mySpaces);
  }

  final List<MyRentalReservation> _myRentals;
  @override
  @JsonKey()
  List<MyRentalReservation> get myRentals {
    if (_myRentals is EqualUnmodifiableListView) return _myRentals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myRentals);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final int selectedTab;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HistoryState(mySpaces: $mySpaces, myRentals: $myRentals, isLoading: $isLoading, selectedTab: $selectedTab, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryStateImpl &&
            const DeepCollectionEquality().equals(other._mySpaces, _mySpaces) &&
            const DeepCollectionEquality()
                .equals(other._myRentals, _myRentals) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.selectedTab, selectedTab) ||
                other.selectedTab == selectedTab) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_mySpaces),
      const DeepCollectionEquality().hash(_myRentals),
      isLoading,
      selectedTab,
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
      {final List<MySpaceReservation> mySpaces,
      final List<MyRentalReservation> myRentals,
      final bool isLoading,
      final int selectedTab,
      final String? errorMessage}) = _$HistoryStateImpl;

  factory _HistoryState.fromJson(Map<String, dynamic> json) =
      _$HistoryStateImpl.fromJson;

  @override
  List<MySpaceReservation> get mySpaces;
  @override
  List<MyRentalReservation> get myRentals;
  @override
  bool get isLoading;
  @override
  int get selectedTab;
  @override
  String? get errorMessage;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
