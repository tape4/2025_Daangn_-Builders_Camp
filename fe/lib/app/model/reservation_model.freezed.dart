// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MySpaceReservation _$MySpaceReservationFromJson(Map<String, dynamic> json) {
  return _MySpaceReservation.fromJson(json);
}

/// @nodoc
mixin _$MySpaceReservation {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get depth => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  Map<String, int> get storageOptions => throw _privateConstructorUsedError;
  Map<String, double> get storagePrices => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;
  int get currentRentedCount => throw _privateConstructorUsedError;
  int get totalCapacity => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get renterName => throw _privateConstructorUsedError;
  String? get renterPhone => throw _privateConstructorUsedError;
  String? get renterProfileImage => throw _privateConstructorUsedError;

  /// Serializes this MySpaceReservation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MySpaceReservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MySpaceReservationCopyWith<MySpaceReservation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MySpaceReservationCopyWith<$Res> {
  factory $MySpaceReservationCopyWith(
          MySpaceReservation value, $Res Function(MySpaceReservation) then) =
      _$MySpaceReservationCopyWithImpl<$Res, MySpaceReservation>;
  @useResult
  $Res call(
      {int id,
      String title,
      String imageUrl,
      String region,
      String address,
      double width,
      double depth,
      double height,
      Map<String, int> storageOptions,
      Map<String, double> storagePrices,
      DateTime createdAt,
      String status,
      double totalIncome,
      int currentRentedCount,
      int totalCapacity,
      DateTime? startDate,
      DateTime? endDate,
      String? renterName,
      String? renterPhone,
      String? renterProfileImage});
}

/// @nodoc
class _$MySpaceReservationCopyWithImpl<$Res, $Val extends MySpaceReservation>
    implements $MySpaceReservationCopyWith<$Res> {
  _$MySpaceReservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MySpaceReservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? region = null,
    Object? address = null,
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
    Object? renterName = freezed,
    Object? renterPhone = freezed,
    Object? renterProfileImage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
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
              as Map<String, double>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
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
      renterName: freezed == renterName
          ? _value.renterName
          : renterName // ignore: cast_nullable_to_non_nullable
              as String?,
      renterPhone: freezed == renterPhone
          ? _value.renterPhone
          : renterPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      renterProfileImage: freezed == renterProfileImage
          ? _value.renterProfileImage
          : renterProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MySpaceReservationImplCopyWith<$Res>
    implements $MySpaceReservationCopyWith<$Res> {
  factory _$$MySpaceReservationImplCopyWith(_$MySpaceReservationImpl value,
          $Res Function(_$MySpaceReservationImpl) then) =
      __$$MySpaceReservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String imageUrl,
      String region,
      String address,
      double width,
      double depth,
      double height,
      Map<String, int> storageOptions,
      Map<String, double> storagePrices,
      DateTime createdAt,
      String status,
      double totalIncome,
      int currentRentedCount,
      int totalCapacity,
      DateTime? startDate,
      DateTime? endDate,
      String? renterName,
      String? renterPhone,
      String? renterProfileImage});
}

/// @nodoc
class __$$MySpaceReservationImplCopyWithImpl<$Res>
    extends _$MySpaceReservationCopyWithImpl<$Res, _$MySpaceReservationImpl>
    implements _$$MySpaceReservationImplCopyWith<$Res> {
  __$$MySpaceReservationImplCopyWithImpl(_$MySpaceReservationImpl _value,
      $Res Function(_$MySpaceReservationImpl) _then)
      : super(_value, _then);

  /// Create a copy of MySpaceReservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? region = null,
    Object? address = null,
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
    Object? renterName = freezed,
    Object? renterPhone = freezed,
    Object? renterProfileImage = freezed,
  }) {
    return _then(_$MySpaceReservationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
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
              as Map<String, double>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
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
      renterName: freezed == renterName
          ? _value.renterName
          : renterName // ignore: cast_nullable_to_non_nullable
              as String?,
      renterPhone: freezed == renterPhone
          ? _value.renterPhone
          : renterPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      renterProfileImage: freezed == renterProfileImage
          ? _value.renterProfileImage
          : renterProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MySpaceReservationImpl implements _MySpaceReservation {
  const _$MySpaceReservationImpl(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.region,
      required this.address,
      required this.width,
      required this.depth,
      required this.height,
      required final Map<String, int> storageOptions,
      required final Map<String, double> storagePrices,
      required this.createdAt,
      required this.status,
      this.totalIncome = 0.0,
      this.currentRentedCount = 0,
      this.totalCapacity = 0,
      this.startDate,
      this.endDate,
      this.renterName,
      this.renterPhone,
      this.renterProfileImage})
      : _storageOptions = storageOptions,
        _storagePrices = storagePrices;

  factory _$MySpaceReservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MySpaceReservationImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final String region;
  @override
  final String address;
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

  final Map<String, double> _storagePrices;
  @override
  Map<String, double> get storagePrices {
    if (_storagePrices is EqualUnmodifiableMapView) return _storagePrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_storagePrices);
  }

  @override
  final DateTime createdAt;
  @override
  final String status;
  @override
  @JsonKey()
  final double totalIncome;
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
  final String? renterName;
  @override
  final String? renterPhone;
  @override
  final String? renterProfileImage;

  @override
  String toString() {
    return 'MySpaceReservation(id: $id, title: $title, imageUrl: $imageUrl, region: $region, address: $address, width: $width, depth: $depth, height: $height, storageOptions: $storageOptions, storagePrices: $storagePrices, createdAt: $createdAt, status: $status, totalIncome: $totalIncome, currentRentedCount: $currentRentedCount, totalCapacity: $totalCapacity, startDate: $startDate, endDate: $endDate, renterName: $renterName, renterPhone: $renterPhone, renterProfileImage: $renterProfileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MySpaceReservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.address, address) || other.address == address) &&
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
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.renterName, renterName) ||
                other.renterName == renterName) &&
            (identical(other.renterPhone, renterPhone) ||
                other.renterPhone == renterPhone) &&
            (identical(other.renterProfileImage, renterProfileImage) ||
                other.renterProfileImage == renterProfileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        imageUrl,
        region,
        address,
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
        endDate,
        renterName,
        renterPhone,
        renterProfileImage
      ]);

  /// Create a copy of MySpaceReservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MySpaceReservationImplCopyWith<_$MySpaceReservationImpl> get copyWith =>
      __$$MySpaceReservationImplCopyWithImpl<_$MySpaceReservationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MySpaceReservationImplToJson(
      this,
    );
  }
}

abstract class _MySpaceReservation implements MySpaceReservation {
  const factory _MySpaceReservation(
      {required final int id,
      required final String title,
      required final String imageUrl,
      required final String region,
      required final String address,
      required final double width,
      required final double depth,
      required final double height,
      required final Map<String, int> storageOptions,
      required final Map<String, double> storagePrices,
      required final DateTime createdAt,
      required final String status,
      final double totalIncome,
      final int currentRentedCount,
      final int totalCapacity,
      final DateTime? startDate,
      final DateTime? endDate,
      final String? renterName,
      final String? renterPhone,
      final String? renterProfileImage}) = _$MySpaceReservationImpl;

  factory _MySpaceReservation.fromJson(Map<String, dynamic> json) =
      _$MySpaceReservationImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get imageUrl;
  @override
  String get region;
  @override
  String get address;
  @override
  double get width;
  @override
  double get depth;
  @override
  double get height;
  @override
  Map<String, int> get storageOptions;
  @override
  Map<String, double> get storagePrices;
  @override
  DateTime get createdAt;
  @override
  String get status;
  @override
  double get totalIncome;
  @override
  int get currentRentedCount;
  @override
  int get totalCapacity;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get renterName;
  @override
  String? get renterPhone;
  @override
  String? get renterProfileImage;

  /// Create a copy of MySpaceReservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MySpaceReservationImplCopyWith<_$MySpaceReservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MyRentalReservation _$MyRentalReservationFromJson(Map<String, dynamic> json) {
  return _MyRentalReservation.fromJson(json);
}

/// @nodoc
mixin _$MyRentalReservation {
  int get id => throw _privateConstructorUsedError;
  String get spaceName => throw _privateConstructorUsedError;
  String get spaceImageUrl => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String get ownerPhone => throw _privateConstructorUsedError;
  String? get ownerProfileImage => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get itemType => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get monthlyPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MyRentalReservation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyRentalReservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyRentalReservationCopyWith<MyRentalReservation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyRentalReservationCopyWith<$Res> {
  factory $MyRentalReservationCopyWith(
          MyRentalReservation value, $Res Function(MyRentalReservation) then) =
      _$MyRentalReservationCopyWithImpl<$Res, MyRentalReservation>;
  @useResult
  $Res call(
      {int id,
      String spaceName,
      String spaceImageUrl,
      String ownerName,
      String ownerPhone,
      String? ownerProfileImage,
      String region,
      String address,
      DateTime startDate,
      DateTime endDate,
      String itemType,
      int quantity,
      double monthlyPrice,
      double totalPrice,
      String status,
      String? note,
      DateTime? createdAt});
}

/// @nodoc
class _$MyRentalReservationCopyWithImpl<$Res, $Val extends MyRentalReservation>
    implements $MyRentalReservationCopyWith<$Res> {
  _$MyRentalReservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyRentalReservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? spaceName = null,
    Object? spaceImageUrl = null,
    Object? ownerName = null,
    Object? ownerPhone = null,
    Object? ownerProfileImage = freezed,
    Object? region = null,
    Object? address = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? itemType = null,
    Object? quantity = null,
    Object? monthlyPrice = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      spaceName: null == spaceName
          ? _value.spaceName
          : spaceName // ignore: cast_nullable_to_non_nullable
              as String,
      spaceImageUrl: null == spaceImageUrl
          ? _value.spaceImageUrl
          : spaceImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerPhone: null == ownerPhone
          ? _value.ownerPhone
          : ownerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      ownerProfileImage: freezed == ownerProfileImage
          ? _value.ownerProfileImage
          : ownerProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyPrice: null == monthlyPrice
          ? _value.monthlyPrice
          : monthlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyRentalReservationImplCopyWith<$Res>
    implements $MyRentalReservationCopyWith<$Res> {
  factory _$$MyRentalReservationImplCopyWith(_$MyRentalReservationImpl value,
          $Res Function(_$MyRentalReservationImpl) then) =
      __$$MyRentalReservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String spaceName,
      String spaceImageUrl,
      String ownerName,
      String ownerPhone,
      String? ownerProfileImage,
      String region,
      String address,
      DateTime startDate,
      DateTime endDate,
      String itemType,
      int quantity,
      double monthlyPrice,
      double totalPrice,
      String status,
      String? note,
      DateTime? createdAt});
}

/// @nodoc
class __$$MyRentalReservationImplCopyWithImpl<$Res>
    extends _$MyRentalReservationCopyWithImpl<$Res, _$MyRentalReservationImpl>
    implements _$$MyRentalReservationImplCopyWith<$Res> {
  __$$MyRentalReservationImplCopyWithImpl(_$MyRentalReservationImpl _value,
      $Res Function(_$MyRentalReservationImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyRentalReservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? spaceName = null,
    Object? spaceImageUrl = null,
    Object? ownerName = null,
    Object? ownerPhone = null,
    Object? ownerProfileImage = freezed,
    Object? region = null,
    Object? address = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? itemType = null,
    Object? quantity = null,
    Object? monthlyPrice = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$MyRentalReservationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      spaceName: null == spaceName
          ? _value.spaceName
          : spaceName // ignore: cast_nullable_to_non_nullable
              as String,
      spaceImageUrl: null == spaceImageUrl
          ? _value.spaceImageUrl
          : spaceImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerPhone: null == ownerPhone
          ? _value.ownerPhone
          : ownerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      ownerProfileImage: freezed == ownerProfileImage
          ? _value.ownerProfileImage
          : ownerProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyPrice: null == monthlyPrice
          ? _value.monthlyPrice
          : monthlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MyRentalReservationImpl implements _MyRentalReservation {
  const _$MyRentalReservationImpl(
      {required this.id,
      required this.spaceName,
      required this.spaceImageUrl,
      required this.ownerName,
      required this.ownerPhone,
      this.ownerProfileImage,
      required this.region,
      required this.address,
      required this.startDate,
      required this.endDate,
      required this.itemType,
      required this.quantity,
      required this.monthlyPrice,
      required this.totalPrice,
      required this.status,
      this.note,
      this.createdAt});

  factory _$MyRentalReservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyRentalReservationImplFromJson(json);

  @override
  final int id;
  @override
  final String spaceName;
  @override
  final String spaceImageUrl;
  @override
  final String ownerName;
  @override
  final String ownerPhone;
  @override
  final String? ownerProfileImage;
  @override
  final String region;
  @override
  final String address;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String itemType;
  @override
  final int quantity;
  @override
  final double monthlyPrice;
  @override
  final double totalPrice;
  @override
  final String status;
  @override
  final String? note;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MyRentalReservation(id: $id, spaceName: $spaceName, spaceImageUrl: $spaceImageUrl, ownerName: $ownerName, ownerPhone: $ownerPhone, ownerProfileImage: $ownerProfileImage, region: $region, address: $address, startDate: $startDate, endDate: $endDate, itemType: $itemType, quantity: $quantity, monthlyPrice: $monthlyPrice, totalPrice: $totalPrice, status: $status, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyRentalReservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.spaceName, spaceName) ||
                other.spaceName == spaceName) &&
            (identical(other.spaceImageUrl, spaceImageUrl) ||
                other.spaceImageUrl == spaceImageUrl) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerPhone, ownerPhone) ||
                other.ownerPhone == ownerPhone) &&
            (identical(other.ownerProfileImage, ownerProfileImage) ||
                other.ownerProfileImage == ownerProfileImage) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.monthlyPrice, monthlyPrice) ||
                other.monthlyPrice == monthlyPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      spaceName,
      spaceImageUrl,
      ownerName,
      ownerPhone,
      ownerProfileImage,
      region,
      address,
      startDate,
      endDate,
      itemType,
      quantity,
      monthlyPrice,
      totalPrice,
      status,
      note,
      createdAt);

  /// Create a copy of MyRentalReservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyRentalReservationImplCopyWith<_$MyRentalReservationImpl> get copyWith =>
      __$$MyRentalReservationImplCopyWithImpl<_$MyRentalReservationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyRentalReservationImplToJson(
      this,
    );
  }
}

abstract class _MyRentalReservation implements MyRentalReservation {
  const factory _MyRentalReservation(
      {required final int id,
      required final String spaceName,
      required final String spaceImageUrl,
      required final String ownerName,
      required final String ownerPhone,
      final String? ownerProfileImage,
      required final String region,
      required final String address,
      required final DateTime startDate,
      required final DateTime endDate,
      required final String itemType,
      required final int quantity,
      required final double monthlyPrice,
      required final double totalPrice,
      required final String status,
      final String? note,
      final DateTime? createdAt}) = _$MyRentalReservationImpl;

  factory _MyRentalReservation.fromJson(Map<String, dynamic> json) =
      _$MyRentalReservationImpl.fromJson;

  @override
  int get id;
  @override
  String get spaceName;
  @override
  String get spaceImageUrl;
  @override
  String get ownerName;
  @override
  String get ownerPhone;
  @override
  String? get ownerProfileImage;
  @override
  String get region;
  @override
  String get address;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get itemType;
  @override
  int get quantity;
  @override
  double get monthlyPrice;
  @override
  double get totalPrice;
  @override
  String get status;
  @override
  String? get note;
  @override
  DateTime? get createdAt;

  /// Create a copy of MyRentalReservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyRentalReservationImplCopyWith<_$MyRentalReservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReservationListResponse _$ReservationListResponseFromJson(
    Map<String, dynamic> json) {
  return _ReservationListResponse.fromJson(json);
}

/// @nodoc
mixin _$ReservationListResponse {
  List<dynamic> get data => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;

  /// Serializes this ReservationListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationListResponseCopyWith<ReservationListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationListResponseCopyWith<$Res> {
  factory $ReservationListResponseCopyWith(ReservationListResponse value,
          $Res Function(ReservationListResponse) then) =
      _$ReservationListResponseCopyWithImpl<$Res, ReservationListResponse>;
  @useResult
  $Res call(
      {List<dynamic> data, int currentPage, int totalPages, int totalCount});
}

/// @nodoc
class _$ReservationListResponseCopyWithImpl<$Res,
        $Val extends ReservationListResponse>
    implements $ReservationListResponseCopyWith<$Res> {
  _$ReservationListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalCount = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationListResponseImplCopyWith<$Res>
    implements $ReservationListResponseCopyWith<$Res> {
  factory _$$ReservationListResponseImplCopyWith(
          _$ReservationListResponseImpl value,
          $Res Function(_$ReservationListResponseImpl) then) =
      __$$ReservationListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<dynamic> data, int currentPage, int totalPages, int totalCount});
}

/// @nodoc
class __$$ReservationListResponseImplCopyWithImpl<$Res>
    extends _$ReservationListResponseCopyWithImpl<$Res,
        _$ReservationListResponseImpl>
    implements _$$ReservationListResponseImplCopyWith<$Res> {
  __$$ReservationListResponseImplCopyWithImpl(
      _$ReservationListResponseImpl _value,
      $Res Function(_$ReservationListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalCount = null,
  }) {
    return _then(_$ReservationListResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationListResponseImpl implements _ReservationListResponse {
  const _$ReservationListResponseImpl(
      {required final List<dynamic> data,
      this.currentPage = 1,
      this.totalPages = 1,
      this.totalCount = 0})
      : _data = data;

  factory _$ReservationListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationListResponseImplFromJson(json);

  final List<dynamic> _data;
  @override
  List<dynamic> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final int totalCount;

  @override
  String toString() {
    return 'ReservationListResponse(data: $data, currentPage: $currentPage, totalPages: $totalPages, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationListResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      currentPage,
      totalPages,
      totalCount);

  /// Create a copy of ReservationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationListResponseImplCopyWith<_$ReservationListResponseImpl>
      get copyWith => __$$ReservationListResponseImplCopyWithImpl<
          _$ReservationListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationListResponseImplToJson(
      this,
    );
  }
}

abstract class _ReservationListResponse implements ReservationListResponse {
  const factory _ReservationListResponse(
      {required final List<dynamic> data,
      final int currentPage,
      final int totalPages,
      final int totalCount}) = _$ReservationListResponseImpl;

  factory _ReservationListResponse.fromJson(Map<String, dynamic> json) =
      _$ReservationListResponseImpl.fromJson;

  @override
  List<dynamic> get data;
  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get totalCount;

  /// Create a copy of ReservationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationListResponseImplCopyWith<_$ReservationListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
