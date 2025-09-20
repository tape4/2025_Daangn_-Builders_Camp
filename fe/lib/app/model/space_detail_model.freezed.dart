// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpaceDetail _$SpaceDetailFromJson(Map<String, dynamic> json) {
  return _SpaceDetail.fromJson(json);
}

/// @nodoc
mixin _$SpaceDetail {
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get boxCapacityXs => throw _privateConstructorUsedError;
  int get boxCapacityS => throw _privateConstructorUsedError;
  int get boxCapacityM => throw _privateConstructorUsedError;
  int get boxCapacityL => throw _privateConstructorUsedError;
  int get boxCapacityXl => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  SpaceOwner get owner => throw _privateConstructorUsedError;
  DateTime get availableStartDate => throw _privateConstructorUsedError;
  DateTime get availableEndDate => throw _privateConstructorUsedError;
  int get totalBoxCount => throw _privateConstructorUsedError;

  /// Serializes this SpaceDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpaceDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpaceDetailCopyWith<SpaceDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceDetailCopyWith<$Res> {
  factory $SpaceDetailCopyWith(
          SpaceDetail value, $Res Function(SpaceDetail) then) =
      _$SpaceDetailCopyWithImpl<$Res, SpaceDetail>;
  @useResult
  $Res call(
      {DateTime createdAt,
      DateTime updatedAt,
      int id,
      String name,
      String description,
      double latitude,
      double longitude,
      String address,
      String imageUrl,
      int boxCapacityXs,
      int boxCapacityS,
      int boxCapacityM,
      int boxCapacityL,
      int boxCapacityXl,
      double rating,
      int reviewCount,
      SpaceOwner owner,
      DateTime availableStartDate,
      DateTime availableEndDate,
      int totalBoxCount});

  $SpaceOwnerCopyWith<$Res> get owner;
}

/// @nodoc
class _$SpaceDetailCopyWithImpl<$Res, $Val extends SpaceDetail>
    implements $SpaceDetailCopyWith<$Res> {
  _$SpaceDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpaceDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? imageUrl = null,
    Object? boxCapacityXs = null,
    Object? boxCapacityS = null,
    Object? boxCapacityM = null,
    Object? boxCapacityL = null,
    Object? boxCapacityXl = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? owner = null,
    Object? availableStartDate = null,
    Object? availableEndDate = null,
    Object? totalBoxCount = null,
  }) {
    return _then(_value.copyWith(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      boxCapacityXs: null == boxCapacityXs
          ? _value.boxCapacityXs
          : boxCapacityXs // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityS: null == boxCapacityS
          ? _value.boxCapacityS
          : boxCapacityS // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityM: null == boxCapacityM
          ? _value.boxCapacityM
          : boxCapacityM // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityL: null == boxCapacityL
          ? _value.boxCapacityL
          : boxCapacityL // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityXl: null == boxCapacityXl
          ? _value.boxCapacityXl
          : boxCapacityXl // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpaceOwner,
      availableStartDate: null == availableStartDate
          ? _value.availableStartDate
          : availableStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableEndDate: null == availableEndDate
          ? _value.availableEndDate
          : availableEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalBoxCount: null == totalBoxCount
          ? _value.totalBoxCount
          : totalBoxCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of SpaceDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpaceOwnerCopyWith<$Res> get owner {
    return $SpaceOwnerCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpaceDetailImplCopyWith<$Res>
    implements $SpaceDetailCopyWith<$Res> {
  factory _$$SpaceDetailImplCopyWith(
          _$SpaceDetailImpl value, $Res Function(_$SpaceDetailImpl) then) =
      __$$SpaceDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime createdAt,
      DateTime updatedAt,
      int id,
      String name,
      String description,
      double latitude,
      double longitude,
      String address,
      String imageUrl,
      int boxCapacityXs,
      int boxCapacityS,
      int boxCapacityM,
      int boxCapacityL,
      int boxCapacityXl,
      double rating,
      int reviewCount,
      SpaceOwner owner,
      DateTime availableStartDate,
      DateTime availableEndDate,
      int totalBoxCount});

  @override
  $SpaceOwnerCopyWith<$Res> get owner;
}

/// @nodoc
class __$$SpaceDetailImplCopyWithImpl<$Res>
    extends _$SpaceDetailCopyWithImpl<$Res, _$SpaceDetailImpl>
    implements _$$SpaceDetailImplCopyWith<$Res> {
  __$$SpaceDetailImplCopyWithImpl(
      _$SpaceDetailImpl _value, $Res Function(_$SpaceDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpaceDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? imageUrl = null,
    Object? boxCapacityXs = null,
    Object? boxCapacityS = null,
    Object? boxCapacityM = null,
    Object? boxCapacityL = null,
    Object? boxCapacityXl = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? owner = null,
    Object? availableStartDate = null,
    Object? availableEndDate = null,
    Object? totalBoxCount = null,
  }) {
    return _then(_$SpaceDetailImpl(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      boxCapacityXs: null == boxCapacityXs
          ? _value.boxCapacityXs
          : boxCapacityXs // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityS: null == boxCapacityS
          ? _value.boxCapacityS
          : boxCapacityS // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityM: null == boxCapacityM
          ? _value.boxCapacityM
          : boxCapacityM // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityL: null == boxCapacityL
          ? _value.boxCapacityL
          : boxCapacityL // ignore: cast_nullable_to_non_nullable
              as int,
      boxCapacityXl: null == boxCapacityXl
          ? _value.boxCapacityXl
          : boxCapacityXl // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpaceOwner,
      availableStartDate: null == availableStartDate
          ? _value.availableStartDate
          : availableStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableEndDate: null == availableEndDate
          ? _value.availableEndDate
          : availableEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalBoxCount: null == totalBoxCount
          ? _value.totalBoxCount
          : totalBoxCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpaceDetailImpl implements _SpaceDetail {
  const _$SpaceDetailImpl(
      {required this.createdAt,
      required this.updatedAt,
      required this.id,
      required this.name,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.imageUrl,
      required this.boxCapacityXs,
      required this.boxCapacityS,
      required this.boxCapacityM,
      required this.boxCapacityL,
      required this.boxCapacityXl,
      required this.rating,
      required this.reviewCount,
      required this.owner,
      required this.availableStartDate,
      required this.availableEndDate,
      required this.totalBoxCount});

  factory _$SpaceDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpaceDetailImplFromJson(json);

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String address;
  @override
  final String imageUrl;
  @override
  final int boxCapacityXs;
  @override
  final int boxCapacityS;
  @override
  final int boxCapacityM;
  @override
  final int boxCapacityL;
  @override
  final int boxCapacityXl;
  @override
  final double rating;
  @override
  final int reviewCount;
  @override
  final SpaceOwner owner;
  @override
  final DateTime availableStartDate;
  @override
  final DateTime availableEndDate;
  @override
  final int totalBoxCount;

  @override
  String toString() {
    return 'SpaceDetail(createdAt: $createdAt, updatedAt: $updatedAt, id: $id, name: $name, description: $description, latitude: $latitude, longitude: $longitude, address: $address, imageUrl: $imageUrl, boxCapacityXs: $boxCapacityXs, boxCapacityS: $boxCapacityS, boxCapacityM: $boxCapacityM, boxCapacityL: $boxCapacityL, boxCapacityXl: $boxCapacityXl, rating: $rating, reviewCount: $reviewCount, owner: $owner, availableStartDate: $availableStartDate, availableEndDate: $availableEndDate, totalBoxCount: $totalBoxCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceDetailImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.boxCapacityXs, boxCapacityXs) ||
                other.boxCapacityXs == boxCapacityXs) &&
            (identical(other.boxCapacityS, boxCapacityS) ||
                other.boxCapacityS == boxCapacityS) &&
            (identical(other.boxCapacityM, boxCapacityM) ||
                other.boxCapacityM == boxCapacityM) &&
            (identical(other.boxCapacityL, boxCapacityL) ||
                other.boxCapacityL == boxCapacityL) &&
            (identical(other.boxCapacityXl, boxCapacityXl) ||
                other.boxCapacityXl == boxCapacityXl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.availableStartDate, availableStartDate) ||
                other.availableStartDate == availableStartDate) &&
            (identical(other.availableEndDate, availableEndDate) ||
                other.availableEndDate == availableEndDate) &&
            (identical(other.totalBoxCount, totalBoxCount) ||
                other.totalBoxCount == totalBoxCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        createdAt,
        updatedAt,
        id,
        name,
        description,
        latitude,
        longitude,
        address,
        imageUrl,
        boxCapacityXs,
        boxCapacityS,
        boxCapacityM,
        boxCapacityL,
        boxCapacityXl,
        rating,
        reviewCount,
        owner,
        availableStartDate,
        availableEndDate,
        totalBoxCount
      ]);

  /// Create a copy of SpaceDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceDetailImplCopyWith<_$SpaceDetailImpl> get copyWith =>
      __$$SpaceDetailImplCopyWithImpl<_$SpaceDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpaceDetailImplToJson(
      this,
    );
  }
}

abstract class _SpaceDetail implements SpaceDetail {
  const factory _SpaceDetail(
      {required final DateTime createdAt,
      required final DateTime updatedAt,
      required final int id,
      required final String name,
      required final String description,
      required final double latitude,
      required final double longitude,
      required final String address,
      required final String imageUrl,
      required final int boxCapacityXs,
      required final int boxCapacityS,
      required final int boxCapacityM,
      required final int boxCapacityL,
      required final int boxCapacityXl,
      required final double rating,
      required final int reviewCount,
      required final SpaceOwner owner,
      required final DateTime availableStartDate,
      required final DateTime availableEndDate,
      required final int totalBoxCount}) = _$SpaceDetailImpl;

  factory _SpaceDetail.fromJson(Map<String, dynamic> json) =
      _$SpaceDetailImpl.fromJson;

  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get address;
  @override
  String get imageUrl;
  @override
  int get boxCapacityXs;
  @override
  int get boxCapacityS;
  @override
  int get boxCapacityM;
  @override
  int get boxCapacityL;
  @override
  int get boxCapacityXl;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  SpaceOwner get owner;
  @override
  DateTime get availableStartDate;
  @override
  DateTime get availableEndDate;
  @override
  int get totalBoxCount;

  /// Create a copy of SpaceDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpaceDetailImplCopyWith<_$SpaceDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpaceOwner _$SpaceOwnerFromJson(Map<String, dynamic> json) {
  return _SpaceOwner.fromJson(json);
}

/// @nodoc
mixin _$SpaceOwner {
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  DateTime get birthDate => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;

  /// Serializes this SpaceOwner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpaceOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpaceOwnerCopyWith<SpaceOwner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceOwnerCopyWith<$Res> {
  factory $SpaceOwnerCopyWith(
          SpaceOwner value, $Res Function(SpaceOwner) then) =
      _$SpaceOwnerCopyWithImpl<$Res, SpaceOwner>;
  @useResult
  $Res call(
      {DateTime createdAt,
      DateTime updatedAt,
      int id,
      String phoneNumber,
      String nickname,
      DateTime birthDate,
      String gender,
      String profileImageUrl,
      double rating,
      int reviewCount});
}

/// @nodoc
class _$SpaceOwnerCopyWithImpl<$Res, $Val extends SpaceOwner>
    implements $SpaceOwnerCopyWith<$Res> {
  _$SpaceOwnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpaceOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = null,
    Object? phoneNumber = null,
    Object? nickname = null,
    Object? birthDate = null,
    Object? gender = null,
    Object? profileImageUrl = null,
    Object? rating = null,
    Object? reviewCount = null,
  }) {
    return _then(_value.copyWith(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpaceOwnerImplCopyWith<$Res>
    implements $SpaceOwnerCopyWith<$Res> {
  factory _$$SpaceOwnerImplCopyWith(
          _$SpaceOwnerImpl value, $Res Function(_$SpaceOwnerImpl) then) =
      __$$SpaceOwnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime createdAt,
      DateTime updatedAt,
      int id,
      String phoneNumber,
      String nickname,
      DateTime birthDate,
      String gender,
      String profileImageUrl,
      double rating,
      int reviewCount});
}

/// @nodoc
class __$$SpaceOwnerImplCopyWithImpl<$Res>
    extends _$SpaceOwnerCopyWithImpl<$Res, _$SpaceOwnerImpl>
    implements _$$SpaceOwnerImplCopyWith<$Res> {
  __$$SpaceOwnerImplCopyWithImpl(
      _$SpaceOwnerImpl _value, $Res Function(_$SpaceOwnerImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpaceOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = null,
    Object? phoneNumber = null,
    Object? nickname = null,
    Object? birthDate = null,
    Object? gender = null,
    Object? profileImageUrl = null,
    Object? rating = null,
    Object? reviewCount = null,
  }) {
    return _then(_$SpaceOwnerImpl(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpaceOwnerImpl implements _SpaceOwner {
  const _$SpaceOwnerImpl(
      {required this.createdAt,
      required this.updatedAt,
      required this.id,
      required this.phoneNumber,
      required this.nickname,
      required this.birthDate,
      required this.gender,
      required this.profileImageUrl,
      required this.rating,
      required this.reviewCount});

  factory _$SpaceOwnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpaceOwnerImplFromJson(json);

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int id;
  @override
  final String phoneNumber;
  @override
  final String nickname;
  @override
  final DateTime birthDate;
  @override
  final String gender;
  @override
  final String profileImageUrl;
  @override
  final double rating;
  @override
  final int reviewCount;

  @override
  String toString() {
    return 'SpaceOwner(createdAt: $createdAt, updatedAt: $updatedAt, id: $id, phoneNumber: $phoneNumber, nickname: $nickname, birthDate: $birthDate, gender: $gender, profileImageUrl: $profileImageUrl, rating: $rating, reviewCount: $reviewCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceOwnerImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      createdAt,
      updatedAt,
      id,
      phoneNumber,
      nickname,
      birthDate,
      gender,
      profileImageUrl,
      rating,
      reviewCount);

  /// Create a copy of SpaceOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceOwnerImplCopyWith<_$SpaceOwnerImpl> get copyWith =>
      __$$SpaceOwnerImplCopyWithImpl<_$SpaceOwnerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpaceOwnerImplToJson(
      this,
    );
  }
}

abstract class _SpaceOwner implements SpaceOwner {
  const factory _SpaceOwner(
      {required final DateTime createdAt,
      required final DateTime updatedAt,
      required final int id,
      required final String phoneNumber,
      required final String nickname,
      required final DateTime birthDate,
      required final String gender,
      required final String profileImageUrl,
      required final double rating,
      required final int reviewCount}) = _$SpaceOwnerImpl;

  factory _SpaceOwner.fromJson(Map<String, dynamic> json) =
      _$SpaceOwnerImpl.fromJson;

  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get id;
  @override
  String get phoneNumber;
  @override
  String get nickname;
  @override
  DateTime get birthDate;
  @override
  String get gender;
  @override
  String get profileImageUrl;
  @override
  double get rating;
  @override
  int get reviewCount;

  /// Create a copy of SpaceOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpaceOwnerImplCopyWith<_$SpaceOwnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
