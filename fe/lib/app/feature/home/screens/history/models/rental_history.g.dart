// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RentalHistoryImpl _$$RentalHistoryImplFromJson(Map<String, dynamic> json) =>
    _$RentalHistoryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      region: json['region'] as String,
      detailAddress: json['detailAddress'] as String,
      width: (json['width'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      storageOptions: Map<String, int>.from(json['storageOptions'] as Map),
      storagePrices: Map<String, int>.from(json['storagePrices'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: $enumDecode(_$RentalStatusEnumMap, json['status']),
      totalIncome: (json['totalIncome'] as num?)?.toInt() ?? 0,
      currentRentedCount: (json['currentRentedCount'] as num?)?.toInt() ?? 0,
      totalCapacity: (json['totalCapacity'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$RentalHistoryImplToJson(_$RentalHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'region': instance.region,
      'detailAddress': instance.detailAddress,
      'width': instance.width,
      'depth': instance.depth,
      'height': instance.height,
      'storageOptions': instance.storageOptions,
      'storagePrices': instance.storagePrices,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$RentalStatusEnumMap[instance.status]!,
      'totalIncome': instance.totalIncome,
      'currentRentedCount': instance.currentRentedCount,
      'totalCapacity': instance.totalCapacity,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };

const _$RentalStatusEnumMap = {
  RentalStatus.active: 'active',
  RentalStatus.completed: 'completed',
  RentalStatus.cancelled: 'cancelled',
  RentalStatus.pending: 'pending',
};
