import 'package:hankan/app/model/reservation_model.dart';

extension MySpaceReservationExtension on MySpaceReservation {
  String get volumeText =>
      '${width.toStringAsFixed(0)} x ${depth.toStringAsFixed(0)} x ${height.toStringAsFixed(0)} cm';

  int get occupancyRate {
    if (totalCapacity == 0) return 0;
    return ((currentRentedCount / totalCapacity) * 100).round();
  }

  String get occupancyRateText => '$occupancyRate%';

  bool get hasRenter => renterName != null;

  double get totalVolume => width * depth * height;
}

extension MyRentalReservationExtension on MyRentalReservation {
  String get itemDisplay => '$itemType x$quantity';

  bool get hasNote => note != null && note!.isNotEmpty;

  Duration get rentalDuration => endDate.difference(startDate);

  int get rentalMonths {
    final days = rentalDuration.inDays;
    return (days / 30).ceil();
  }
}