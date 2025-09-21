import 'package:freezed_annotation/freezed_annotation.dart';

part 'rental_history.freezed.dart';
part 'rental_history.g.dart';

enum RentalStatus {
  active,
  completed,
  cancelled,
  pending;

  String get displayName {
    switch (this) {
      case RentalStatus.active:
        return '진행중';
      case RentalStatus.completed:
        return '완료';
      case RentalStatus.cancelled:
        return '취소됨';
      case RentalStatus.pending:
        return '대기중';
    }
  }
}

@freezed
class RentalHistory with _$RentalHistory {
  const factory RentalHistory({
    required String id,
    required String title,
    required String imageUrl,
    required String region,
    required String detailAddress,
    required double width,
    required double depth,
    required double height,
    required Map<String, int> storageOptions,
    required Map<String, int> storagePrices,
    required DateTime createdAt,
    required RentalStatus status,
    @Default(0) int totalIncome,
    @Default(0) int currentRentedCount,
    @Default(0) int totalCapacity,
    DateTime? startDate,
    DateTime? endDate,
  }) = _RentalHistory;

  factory RentalHistory.fromJson(Map<String, dynamic> json) =>
      _$RentalHistoryFromJson(json);
}

extension RentalHistoryExtension on RentalHistory {
  double get totalVolume => width * depth * height;

  String get volumeText => '${width.toStringAsFixed(0)} x ${depth.toStringAsFixed(0)} x ${height.toStringAsFixed(0)} cm';

  int get occupancyRate {
    if (totalCapacity == 0) return 0;
    return ((currentRentedCount / totalCapacity) * 100).round();
  }

  bool get isActive => status == RentalStatus.active;
}