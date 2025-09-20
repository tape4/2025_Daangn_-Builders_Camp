import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/screens/history/logic/history_provider.dart';
import 'package:hankan/app/feature/home/screens/history/models/rental_history.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '빌려준 공간',
                      style: ShadTheme.of(context).textTheme.h2,
                    ),
                    ShadButton.ghost(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: () => ref.read(historyProvider.notifier).refresh(),
                    ),
                  ],
                ),
              ),
            ),
            if (state.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (state.rentalHistories.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.home_work,
                          size: 64,
                          color: ShadTheme.of(context).colorScheme.muted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '아직 등록된 공간이 없습니다',
                          style: ShadTheme.of(context).textTheme.large,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '첫 번째 공간을 등록해보세요',
                          style: ShadTheme.of(context).textTheme.muted,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final history = state.rentalHistories[index];
                      return _RentalHistoryCard(history: history);
                    },
                    childCount: state.rentalHistories.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }
}

class _RentalHistoryCard extends StatelessWidget {
  final RentalHistory history;

  const _RentalHistoryCard({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ShadCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: ShadTheme.of(context)
                          .colorScheme
                          .muted
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ShadTheme.of(context).colorScheme.border,
                      ),
                    ),
                    child: history.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              history.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.home_work,
                                  size: 40,
                                  color:
                                      ShadTheme.of(context).colorScheme.muted,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.home_work,
                            size: 40,
                            color: ShadTheme.of(context).colorScheme.muted,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                history.title,
                                style: ShadTheme.of(context).textTheme.large,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _StatusBadge(status: history.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          history.region,
                          style: ShadTheme.of(context).textTheme.muted,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          history.detailAddress,
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                color: ShadTheme.of(context)
                                    .colorScheme
                                    .mutedForeground,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.straighten,
                              size: 14,
                              color: ShadTheme.of(context).colorScheme.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              history.volumeText,
                              style: ShadTheme.of(context).textTheme.small,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.inventory_2,
                      label: '보관 옵션',
                      value: '${history.storageOptions.length}종류',
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.storage,
                      label: '이용률',
                      value: '${history.occupancyRate}%',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.calendar_today,
                      label: '등록일',
                      value: dateFormat.format(history.createdAt),
                      color: Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.attach_money,
                      label: '총 수익',
                      value:
                          '₩${NumberFormat('#,###').format(history.totalIncome)}',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              if (history.storageOptions.isNotEmpty) ...[
                const SizedBox(height: 16),
                Divider(),
                const SizedBox(height: 16),
                Text(
                  '제공 중인 보관 옵션',
                  style: ShadTheme.of(context).textTheme.p.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: history.storageOptions.entries.map((entry) {
                    final price = history.storagePrices[entry.key] ?? 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ShadTheme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ShadTheme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            entry.key.toUpperCase(),
                            style:
                                ShadTheme.of(context).textTheme.small.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'x${entry.value}',
                            style: ShadTheme.of(context).textTheme.small,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₩${NumberFormat('#,###').format(price)}/월',
                            style: ShadTheme.of(context)
                                .textTheme
                                .small
                                .copyWith(
                                  color:
                                      ShadTheme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (history.isActive && history.currentRentedCount > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '현재 ${history.currentRentedCount}개 보관 중 (전체 ${history.totalCapacity}개)',
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RentalStatus status;

  const _StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case RentalStatus.active:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        break;
      case RentalStatus.completed:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
        break;
      case RentalStatus.cancelled:
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        break;
      case RentalStatus.pending:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
              ),
              Text(
                value,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
