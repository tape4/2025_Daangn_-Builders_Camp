// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MySpaceReservationImpl _$$MySpaceReservationImplFromJson(
        Map<String, dynamic> json) =>
    _$MySpaceReservationImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      region: json['region'] as String,
      address: json['address'] as String,
      width: (json['width'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      storageOptions: Map<String, int>.from(json['storageOptions'] as Map),
      storagePrices: (json['storagePrices'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      currentRentedCount: (json['currentRentedCount'] as num?)?.toInt() ?? 0,
      totalCapacity: (json['totalCapacity'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      renterName: json['renterName'] as String?,
      renterPhone: json['renterPhone'] as String?,
      renterProfileImage: json['renterProfileImage'] as String?,
    );

Map<String, dynamic> _$$MySpaceReservationImplToJson(
        _$MySpaceReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'region': instance.region,
      'address': instance.address,
      'width': instance.width,
      'depth': instance.depth,
      'height': instance.height,
      'storageOptions': instance.storageOptions,
      'storagePrices': instance.storagePrices,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'totalIncome': instance.totalIncome,
      'currentRentedCount': instance.currentRentedCount,
      'totalCapacity': instance.totalCapacity,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'renterName': instance.renterName,
      'renterPhone': instance.renterPhone,
      'renterProfileImage': instance.renterProfileImage,
    };

_$MyRentalReservationImpl _$$MyRentalReservationImplFromJson(
        Map<String, dynamic> json) =>
    _$MyRentalReservationImpl(
      id: (json['id'] as num).toInt(),
      spaceName: json['spaceName'] as String,
      spaceImageUrl: json['spaceImageUrl'] as String,
      ownerName: json['ownerName'] as String,
      ownerPhone: json['ownerPhone'] as String,
      ownerProfileImage: json['ownerProfileImage'] as String?,
      region: json['region'] as String,
      address: json['address'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      itemType: json['itemType'] as String,
      quantity: (json['quantity'] as num).toInt(),
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MyRentalReservationImplToJson(
        _$MyRentalReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spaceName': instance.spaceName,
      'spaceImageUrl': instance.spaceImageUrl,
      'ownerName': instance.ownerName,
      'ownerPhone': instance.ownerPhone,
      'ownerProfileImage': instance.ownerProfileImage,
      'region': instance.region,
      'address': instance.address,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'itemType': instance.itemType,
      'quantity': instance.quantity,
      'monthlyPrice': instance.monthlyPrice,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$ReservationListResponseImpl _$$ReservationListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationListResponseImpl(
      data: json['data'] as List<dynamic>,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReservationListResponseImplToJson(
        _$ReservationListResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalCount': instance.totalCount,
    };
