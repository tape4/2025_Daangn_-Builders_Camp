import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('History', style: ShadTheme.of(context).textTheme.h3),
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildHistoryList(context),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final historyItems = [
      HistoryItem(
        date: DateTime.now().subtract(const Duration(days: 1)),
        title: 'Completed Task A',
        description: 'Successfully completed the assigned task',
        type: HistoryType.success,
      ),
      HistoryItem(
        date: DateTime.now().subtract(const Duration(days: 2)),
        title: 'Updated Profile',
        description: 'Profile information was updated',
        type: HistoryType.info,
      ),
      HistoryItem(
        date: DateTime.now().subtract(const Duration(days: 3)),
        title: 'Failed Action',
        description: 'Action could not be completed',
        type: HistoryType.error,
      ),
      HistoryItem(
        date: DateTime.now().subtract(const Duration(days: 5)),
        title: 'Started New Project',
        description: 'New project was initiated',
        type: HistoryType.info,
      ),
      HistoryItem(
        date: DateTime.now().subtract(const Duration(days: 7)),
        title: 'Achievement Unlocked',
        description: 'Earned a new achievement',
        type: HistoryType.success,
      ),
    ];

    if (historyItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.history,
              size: 64,
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
            const SizedBox(height: 16),
            Text(
              'No history available',
              style: ShadTheme.of(context).textTheme.muted,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: historyItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = historyItems[index];
        return _buildHistoryItem(context, item);
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, HistoryItem item) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistoryIcon(context, item.type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: ShadTheme.of(context).textTheme.p,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                          color:
                              ShadTheme.of(context).colorScheme.mutedForeground,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(item.date),
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                          color: ShadTheme.of(context).colorScheme.muted,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryIcon(BuildContext context, HistoryType type) {
    IconData icon;
    Color color;

    switch (type) {
      case HistoryType.success:
        icon = Symbols.check_circle;
        color = Colors.green;
        break;
      case HistoryType.error:
        icon = Symbols.error;
        color = ShadTheme.of(context).colorScheme.destructive;
        break;
      case HistoryType.info:
        icon = Symbols.info;
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class HistoryItem {
  final DateTime date;
  final String title;
  final String description;
  final HistoryType type;

  HistoryItem({
    required this.date,
    required this.title,
    required this.description,
    required this.type,
  });
}

enum HistoryType { success, error, info }
