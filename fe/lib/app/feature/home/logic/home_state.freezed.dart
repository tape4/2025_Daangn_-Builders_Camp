// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomeState _$HomeStateFromJson(Map<String, dynamic> json) {
  return _HomeState.fromJson(json);
}

/// @nodoc
mixin _$HomeState {
  List<String> get filters => throw _privateConstructorUsedError;
  bool get isBorrowMode => throw _privateConstructorUsedError;
  List<SpaceDetail> get availableSpaces => throw _privateConstructorUsedError;
  int get currentCarouselIndex => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasError => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this HomeState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {List<String> filters,
      bool isBorrowMode,
      List<SpaceDetail> availableSpaces,
      int currentCarouselIndex,
      bool isLoading,
      bool hasError,
      String? errorMessage});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filters = null,
    Object? isBorrowMode = null,
    Object? availableSpaces = null,
    Object? currentCarouselIndex = null,
    Object? isLoading = null,
    Object? hasError = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBorrowMode: null == isBorrowMode
          ? _value.isBorrowMode
          : isBorrowMode // ignore: cast_nullable_to_non_nullable
              as bool,
      availableSpaces: null == availableSpaces
          ? _value.availableSpaces
          : availableSpaces // ignore: cast_nullable_to_non_nullable
              as List<SpaceDetail>,
      currentCarouselIndex: null == currentCarouselIndex
          ? _value.currentCarouselIndex
          : currentCarouselIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> filters,
      bool isBorrowMode,
      List<SpaceDetail> availableSpaces,
      int currentCarouselIndex,
      bool isLoading,
      bool hasError,
      String? errorMessage});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filters = null,
    Object? isBorrowMode = null,
    Object? availableSpaces = null,
    Object? currentCarouselIndex = null,
    Object? isLoading = null,
    Object? hasError = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HomeStateImpl(
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBorrowMode: null == isBorrowMode
          ? _value.isBorrowMode
          : isBorrowMode // ignore: cast_nullable_to_non_nullable
              as bool,
      availableSpaces: null == availableSpaces
          ? _value._availableSpaces
          : availableSpaces // ignore: cast_nullable_to_non_nullable
              as List<SpaceDetail>,
      currentCarouselIndex: null == currentCarouselIndex
          ? _value.currentCarouselIndex
          : currentCarouselIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
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
class _$HomeStateImpl implements _HomeState {
  _$HomeStateImpl(
      {required final List<String> filters,
      this.isBorrowMode = true,
      final List<SpaceDetail> availableSpaces = const [],
      this.currentCarouselIndex = 0,
      this.isLoading = false,
      this.hasError = false,
      this.errorMessage})
      : _filters = filters,
        _availableSpaces = availableSpaces;

  factory _$HomeStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeStateImplFromJson(json);

  final List<String> _filters;
  @override
  List<String> get filters {
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filters);
  }

  @override
  @JsonKey()
  final bool isBorrowMode;
  final List<SpaceDetail> _availableSpaces;
  @override
  @JsonKey()
  List<SpaceDetail> get availableSpaces {
    if (_availableSpaces is EqualUnmodifiableListView) return _availableSpaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableSpaces);
  }

  @override
  @JsonKey()
  final int currentCarouselIndex;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasError;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HomeState(filters: $filters, isBorrowMode: $isBorrowMode, availableSpaces: $availableSpaces, currentCarouselIndex: $currentCarouselIndex, isLoading: $isLoading, hasError: $hasError, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.isBorrowMode, isBorrowMode) ||
                other.isBorrowMode == isBorrowMode) &&
            const DeepCollectionEquality()
                .equals(other._availableSpaces, _availableSpaces) &&
            (identical(other.currentCarouselIndex, currentCarouselIndex) ||
                other.currentCarouselIndex == currentCarouselIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_filters),
      isBorrowMode,
      const DeepCollectionEquality().hash(_availableSpaces),
      currentCarouselIndex,
      isLoading,
      hasError,
      errorMessage);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeStateImplToJson(
      this,
    );
  }
}

abstract class _HomeState implements HomeState {
  factory _HomeState(
      {required final List<String> filters,
      final bool isBorrowMode,
      final List<SpaceDetail> availableSpaces,
      final int currentCarouselIndex,
      final bool isLoading,
      final bool hasError,
      final String? errorMessage}) = _$HomeStateImpl;

  factory _HomeState.fromJson(Map<String, dynamic> json) =
      _$HomeStateImpl.fromJson;

  @override
  List<String> get filters;
  @override
  bool get isBorrowMode;
  @override
  List<SpaceDetail> get availableSpaces;
  @override
  int get currentCarouselIndex;
  @override
  bool get isLoading;
  @override
  bool get hasError;
  @override
  String? get errorMessage;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
