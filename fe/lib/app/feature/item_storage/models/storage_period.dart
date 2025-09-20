class StoragePeriod {
  final DateTime startDate;
  final DateTime endDate;

  StoragePeriod({
    required this.startDate,
    required this.endDate,
  });

  int get days => endDate.difference(startDate).inDays + 1;

  bool get isValid => startDate.isBefore(endDate);

  String get displayText {
    final start = '${startDate.year}.${startDate.month.toString().padLeft(2, '0')}.${startDate.day.toString().padLeft(2, '0')}';
    final end = '${endDate.year}.${endDate.month.toString().padLeft(2, '0')}.${endDate.day.toString().padLeft(2, '0')}';
    return '$start ~ $end';
  }

  String get durationText {
    if (days == 1) {
      return '1일';
    } else if (days < 7) {
      return '$days일';
    } else if (days < 30) {
      final weeks = (days / 7).floor();
      return '$weeks주';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '$months개월';
    } else {
      final years = (days / 365).floor();
      return '$years년';
    }
  }
}