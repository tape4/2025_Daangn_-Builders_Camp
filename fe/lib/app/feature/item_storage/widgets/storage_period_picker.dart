import 'package:flutter/material.dart';
import 'package:hankan/app/feature/item_storage/models/storage_period.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StoragePeriodPicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onPeriodChanged;

  const StoragePeriodPicker({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<StoragePeriodPicker> createState() => _StoragePeriodPickerState();
}

class _StoragePeriodPickerState extends State<StoragePeriodPicker> {
  void _showStartDatePicker() {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('시작일 선택'),
        description: const Text('물건을 맡기기 시작할 날짜를 선택해주세요.'),
        child: ShadCalendar(
          selected: widget.startDate ?? DateTime.now(),
          onChanged: (date) {
            widget.onPeriodChanged(date, widget.endDate);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showEndDatePicker() {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('종료일 선택'),
        description: const Text('물건을 찾아갈 날짜를 선택해주세요.'),
        child: ShadCalendar(
          selected: widget.endDate ?? DateTime.now().add(const Duration(days: 7)),
          onChanged: (date) {
            widget.onPeriodChanged(widget.startDate, date);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final hasValidPeriod = widget.startDate != null && widget.endDate != null;
    final period = hasValidPeriod
        ? StoragePeriod(startDate: widget.startDate!, endDate: widget.endDate!)
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.card,
        border: Border(
          bottom: BorderSide(
            color: ShadTheme.of(context).colorScheme.border,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 20,
                color: ShadTheme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '보관 기간',
                style: ShadTheme.of(context).textTheme.h4,
              ),
              if (period != null && period.isValid) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    period.durationText,
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '시작일',
                      style: ShadTheme.of(context).textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _showStartDatePicker,
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
                            Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: widget.startDate != null
                                  ? ShadTheme.of(context).colorScheme.foreground
                                  : ShadTheme.of(context).colorScheme.mutedForeground,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.startDate != null
                                    ? _formatDate(widget.startDate!)
                                    : '날짜 선택',
                                style: widget.startDate != null
                                    ? ShadTheme.of(context).textTheme.small
                                    : ShadTheme.of(context).textTheme.muted.copyWith(
                                          fontSize: 14,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward,
                size: 20,
                color: ShadTheme.of(context).colorScheme.mutedForeground,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '종료일',
                      style: ShadTheme.of(context).textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: widget.startDate != null ? _showEndDatePicker : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: widget.startDate == null
                                ? ShadTheme.of(context).colorScheme.border.withOpacity(0.5)
                                : ShadTheme.of(context).colorScheme.border,
                          ),
                          color: widget.startDate == null
                              ? ShadTheme.of(context).colorScheme.muted.withOpacity(0.1)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: widget.endDate != null
                                  ? ShadTheme.of(context).colorScheme.foreground
                                  : ShadTheme.of(context).colorScheme.mutedForeground,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.endDate != null
                                    ? _formatDate(widget.endDate!)
                                    : '날짜 선택',
                                style: widget.endDate != null
                                    ? ShadTheme.of(context).textTheme.small
                                    : ShadTheme.of(context).textTheme.muted.copyWith(
                                          fontSize: 14,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (period != null && period.isValid) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ShadTheme.of(context).colorScheme.border,
                ),
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
                        Text(
                          '보관 기간',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 11,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          period.displayText,
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '총 ${period.days}일 (${period.durationText})',
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