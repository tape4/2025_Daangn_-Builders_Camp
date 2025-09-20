import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDateRangeChanged;
  final String title;
  final String? startDateLabel;
  final String? endDateLabel;
  final String? description;
  final IconData? icon;
  final bool showDurationInfo;

  const DateRangePicker({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onDateRangeChanged,
    this.title = '기간 선택',
    this.startDateLabel = '시작일',
    this.endDateLabel = '종료일',
    this.description,
    this.icon = Icons.calendar_today,
    this.showDurationInfo = true,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  int get _duration {
    if (startDate != null && endDate != null) {
      return endDate!.difference(startDate!).inDays + 1;
    }
    return 0;
  }

  String get _durationText {
    final days = _duration;
    if (days == 1) {
      return '1일';
    } else if (days < 7) {
      return '$days일';
    } else if (days < 30) {
      final weeks = (days / 7).floor();
      final remainingDays = days % 7;
      return remainingDays > 0 ? '$weeks주 $remainingDays일' : '$weeks주';
    } else if (days < 365) {
      final months = (days / 30).floor();
      final remainingDays = days % 30;
      return remainingDays > 0 ? '$months개월 $remainingDays일' : '$months개월';
    } else {
      final years = (days / 365).floor();
      final remainingDays = days % 365;
      if (remainingDays >= 30) {
        final months = (remainingDays / 30).floor();
        return '$years년 $months개월';
      }
      return '$years년';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValidRange = startDate != null && endDate != null;
    final isValidRange = hasValidRange &&
        startDate!.isBefore(endDate!.add(const Duration(days: 1)));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: ShadTheme.of(context).colorScheme.border,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: ShadTheme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: ShadTheme.of(context).textTheme.h4,
              ),
              if (hasValidRange && isValidRange && showDurationInfo) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _durationText,
                    style: ShadTheme.of(context).textTheme.muted.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ShadTheme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.maxFinite,
            height: 60,
            child: ShadDatePicker.range(
              selected: startDate != null && endDate != null
                  ? ShadDateTimeRange(start: startDate!, end: endDate!)
                  : null,
              onRangeChanged: (ShadDateTimeRange? range) {
                if (range != null) {
                  onDateRangeChanged(range.start, range.end);
                  // Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
