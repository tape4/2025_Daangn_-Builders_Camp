// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rental_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RentalHistory _$RentalHistoryFromJson(Map<String, dynamic> json) {
  return _RentalHistory.fromJson(json);
}

/// @nodoc
mixin _$RentalHistory {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  String get detailAddress => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get depth => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  Map<String, int> get storageOptions => throw _privateConstructorUsedError;
  Map<String, int> get storagePrices => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  RentalStatus get status => throw _privateConstructorUsedError;
  int get totalIncome => throw _privateConstructorUsedError;
  int get currentRentedCount => throw _privateConstructorUsedError;
  int get totalCapacity => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Serializes this RentalHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RentalHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentalHistoryCopyWith<RentalHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentalHistoryCopyWith<$Res> {
  factory $RentalHistoryCopyWith(
          RentalHistory value, $Res Function(RentalHistory) then) =
      _$RentalHistoryCopyWithImpl<$Res, RentalHistory>;
  @useResult
  $Res call(
      {String id,
      String title,
      String imageUrl,
      String region,
      String detailAddress,
      double width,
      double depth,
      double height,
      Map<String, int> storageOptions,
      Map<String, int> storagePrices,
      DateTime createdAt,
      RentalStatus status,
      int totalIncome,
      int currentRentedCount,
      int totalCapacity,
      DateTime? startDate,
      DateTime? endDate});
}

/// @nodoc
class _$RentalHistoryCopyWithImpl<$Res, $Val extends RentalHistory>
    implements $RentalHistoryCopyWith<$Res> {
  _$RentalHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentalHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? region = null,
    Object? detailAddress = null,
    Object? width = null,
    Object? depth = null,
    Object? height = null,
    Object? storageOptions = null,
    Object? storagePrices = null,
    Object? createdAt = null,
    Object? status = null,
    Object? totalIncome = null,
    Object? currentRentedCount = null,
    Object? totalCapacity = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _value.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      storageOptions: null == storageOptions
          ? _value.storageOptions
          : storageOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      storagePrices: null == storagePrices
          ? _value.storagePrices
          : storagePrices // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RentalStatus,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      currentRentedCount: null == currentRentedCount
          ? _value.currentRentedCount
          : currentRentedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCapacity: null == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RentalHistoryImplCopyWith<$Res>
    implements $RentalHistoryCopyWith<$Res> {
  factory _$$RentalHistoryImplCopyWith(
          _$RentalHistoryImpl value, $Res Function(_$RentalHistoryImpl) then) =
      __$$RentalHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String imageUrl,
      String region,
      String detailAddress,
      double width,
      double depth,
      double height,
      Map<String, int> storageOptions,
      Map<String, int> storagePrices,
      DateTime createdAt,
      RentalStatus status,
      int totalIncome,
      int currentRentedCount,
      int totalCapacity,
      DateTime? startDate,
      DateTime? endDate});
}

/// @nodoc
class __$$RentalHistoryImplCopyWithImpl<$Res>
    extends _$RentalHistoryCopyWithImpl<$Res, _$RentalHistoryImpl>
    implements _$$RentalHistoryImplCopyWith<$Res> {
  __$$RentalHistoryImplCopyWithImpl(
      _$RentalHistoryImpl _value, $Res Function(_$RentalHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of RentalHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? region = null,
    Object? detailAddress = null,
    Object? width = null,
    Object? depth = null,
    Object? height = null,
    Object? storageOptions = null,
    Object? storagePrices = null,
    Object? createdAt = null,
    Object? status = null,
    Object? totalIncome = null,
    Object? currentRentedCount = null,
    Object? totalCapacity = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_$RentalHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _value.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      storageOptions: null == storageOptions
          ? _value._storageOptions
          : storageOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      storagePrices: null == storagePrices
          ? _value._storagePrices
          : storagePrices // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RentalStatus,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      currentRentedCount: null == currentRentedCount
          ? _value.currentRentedCount
          : currentRentedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCapacity: null == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RentalHistoryImpl implements _RentalHistory {
  const _$RentalHistoryImpl(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.region,
      required this.detailAddress,
      required this.width,
      required this.depth,
      required this.height,
      required final Map<String, int> storageOptions,
      required final Map<String, int> storagePrices,
      required this.createdAt,
      required this.status,
      this.totalIncome = 0,
      this.currentRentedCount = 0,
      this.totalCapacity = 0,
      this.startDate,
      this.endDate})
      : _storageOptions = storageOptions,
        _storagePrices = storagePrices;

  factory _$RentalHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentalHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final String region;
  @override
  final String detailAddress;
  @override
  final double width;
  @override
  final double depth;
  @override
  final double height;
  final Map<String, int> _storageOptions;
  @override
  Map<String, int> get storageOptions {
    if (_storageOptions is EqualUnmodifiableMapView) return _storageOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_storageOptions);
  }

  final Map<String, int> _storagePrices;
  @override
  Map<String, int> get storagePrices {
    if (_storagePrices is EqualUnmodifiableMapView) return _storagePrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_storagePrices);
  }

  @override
  final DateTime createdAt;
  @override
  final RentalStatus status;
  @override
  @JsonKey()
  final int totalIncome;
  @override
  @JsonKey()
  final int currentRentedCount;
  @override
  @JsonKey()
  final int totalCapacity;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'RentalHistory(id: $id, title: $title, imageUrl: $imageUrl, region: $region, detailAddress: $detailAddress, width: $width, depth: $depth, height: $height, storageOptions: $storageOptions, storagePrices: $storagePrices, createdAt: $createdAt, status: $status, totalIncome: $totalIncome, currentRentedCount: $currentRentedCount, totalCapacity: $totalCapacity, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentalHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.detailAddress, detailAddress) ||
                other.detailAddress == detailAddress) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality()
                .equals(other._storageOptions, _storageOptions) &&
            const DeepCollectionEquality()
                .equals(other._storagePrices, _storagePrices) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.currentRentedCount, currentRentedCount) ||
                other.currentRentedCount == currentRentedCount) &&
            (identical(other.totalCapacity, totalCapacity) ||
                other.totalCapacity == totalCapacity) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      imageUrl,
      region,
      detailAddress,
      width,
      depth,
      height,
      const DeepCollectionEquality().hash(_storageOptions),
      const DeepCollectionEquality().hash(_storagePrices),
      createdAt,
      status,
      totalIncome,
      currentRentedCount,
      totalCapacity,
      startDate,
      endDate);

  /// Create a copy of RentalHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentalHistoryImplCopyWith<_$RentalHistoryImpl> get copyWith =>
      __$$RentalHistoryImplCopyWithImpl<_$RentalHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RentalHistoryImplToJson(
      this,
    );
  }
}

abstract class _RentalHistory implements RentalHistory {
  const factory _RentalHistory(
      {required final String id,
      required final String title,
      required final String imageUrl,
      required final String region,
      required final String detailAddress,
      required final double width,
      required final double depth,
      required final double height,
      required final Map<String, int> storageOptions,
      required final Map<String, int> storagePrices,
      required final DateTime createdAt,
      required final RentalStatus status,
      final int totalIncome,
      final int currentRentedCount,
      final int totalCapacity,
      final DateTime? startDate,
      final DateTime? endDate}) = _$RentalHistoryImpl;

  factory _RentalHistory.fromJson(Map<String, dynamic> json) =
      _$RentalHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get imageUrl;
  @override
  String get region;
  @override
  String get detailAddress;
  @override
  double get width;
  @override
  double get depth;
  @override
  double get height;
  @override
  Map<String, int> get storageOptions;
  @override
  Map<String, int> get storagePrices;
  @override
  DateTime get createdAt;
  @override
  RentalStatus get status;
  @override
  int get totalIncome;
  @override
  int get currentRentedCount;
  @override
  int get totalCapacity;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;

  /// Create a copy of RentalHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentalHistoryImplCopyWith<_$RentalHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
