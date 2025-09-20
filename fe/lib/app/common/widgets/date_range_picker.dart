import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CommonDateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDateRangeChanged;
  final String title;
  final String? startDateLabel;
  final String? endDateLabel;
  final String? description;
  final IconData? icon;
  final bool showDurationInfo;

  const CommonDateRangePicker({
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

  void _showDateRangePicker(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text(title),
        description: Text(description ?? '날짜 범위를 선택해주세요'),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ShadDatePicker.range(
            selected: startDate != null && endDate != null
                ? ShadDateTimeRange(start: startDate!, end: endDate!)
                : null,
            onChanged: (DateTime? value) {
              // For range picker, we need to handle this differently
              // The value parameter is not used for range picker
            },
            onRangeChanged: (ShadDateTimeRange? range) {
              if (range != null) {
                onDateRangeChanged(range.start, range.end);
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
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
          InkWell(
            onTap: () => _showDateRangePicker(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ShadTheme.of(context).colorScheme.border,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          startDateLabel!,
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ShadTheme.of(context)
                                    .colorScheme
                                    .mutedForeground,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          startDate != null ? _formatDate(startDate!) : '날짜 선택',
                          style: startDate != null
                              ? ShadTheme.of(context).textTheme.p
                              : ShadTheme.of(context).textTheme.muted,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          endDateLabel!,
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ShadTheme.of(context)
                                    .colorScheme
                                    .mutedForeground,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          endDate != null ? _formatDate(endDate!) : '날짜 선택',
                          style: endDate != null
                              ? ShadTheme.of(context).textTheme.p
                              : ShadTheme.of(context).textTheme.muted,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: ShadTheme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (hasValidRange && isValidRange && showDurationInfo) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (description != null) ...[
                          Text(
                            description!,
                            style:
                                ShadTheme.of(context).textTheme.muted.copyWith(
                                      fontSize: 11,
                                    ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          '${_formatDate(startDate!)} ~ ${_formatDate(endDate!)}',
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '총 $_duration일 ($_durationText)',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
