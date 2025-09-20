import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/screens/history/logic/history_provider.dart';
import 'package:hankan/app/feature/home/screens/history/logic/history_state.dart';
import 'package:hankan/app/feature/home/screens/history/widgets/history_widgets.dart';
import 'package:hankan/app/feature/home/screens/history/widgets/my_rental_card.dart';
import 'package:hankan/app/feature/home/screens/history/widgets/my_space_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, notifier),
            HistoryTabBar(
              selectedTab: state.selectedTab,
              onTabChanged: notifier.setSelectedTab,
            ),
            Expanded(
              child: state.selectedTab == 0
                  ? _MySpacesTab(state: state)
                  : _MyRentalsTab(state: state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HistoryProvider notifier) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '대여 내역',
            style: ShadTheme.of(context).textTheme.h2,
          ),
          ShadButton.ghost(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: notifier.refresh,
          ),
        ],
      ),
    );
  }
}

class _MySpacesTab extends StatelessWidget {
  final HistoryState state;

  const _MySpacesTab({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const HistoryLoadingState();
    }

    if (state.errorMessage != null) {
      return HistoryErrorState(errorMessage: state.errorMessage!);
    }

    if (state.mySpaces.isEmpty) {
      return const HistoryEmptyState(
        icon: Icons.home_work,
        title: '아직 등록된 공간이 없습니다',
        subtitle: '첫 번째 공간을 등록해보세요',
      );
    }

    // Calculate total statistics
    double totalMonthlyRevenue = 0;
    int totalPeopleHelped = 0;

    for (final space in state.mySpaces) {
      // Calculate monthly revenue from all storage prices
      space.storagePrices.forEach((option, price) {
        final quantity = space.storageOptions[option] ?? 0;
        if (quantity > 0) {
          totalMonthlyRevenue += price * quantity;
        }
      });

      // Add current rented count as people helped
      totalPeopleHelped += space.currentRentedCount;
    }

    return Column(
      children: [
        // Revenue statistics card
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
                  ShadTheme.of(context).colorScheme.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ShadTheme.of(context).colorScheme.border.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: ShadTheme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '월간 예상 수익',
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₩${totalMonthlyRevenue.toStringAsFixed(0)}',
                      style: ShadTheme.of(context).textTheme.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ShadTheme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 80,
                  color: ShadTheme.of(context).colorScheme.border.withOpacity(0.3),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.people_alt,
                        color: ShadTheme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '도움 제공',
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalPeopleHelped명',
                      style: ShadTheme.of(context).textTheme.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ShadTheme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Space list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.mySpaces.length,
            itemBuilder: (context, index) {
              return MySpaceCard(space: state.mySpaces[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _MyRentalsTab extends StatelessWidget {
  final HistoryState state;

  const _MyRentalsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const HistoryLoadingState();
    }

    if (state.errorMessage != null) {
      return HistoryErrorState(errorMessage: state.errorMessage!);
    }

    if (state.myRentals.isEmpty) {
      return const HistoryEmptyState(
        icon: Icons.inventory_2,
        title: '대여중인 공간이 없습니다',
        subtitle: '필요한 보관 공간을 찾아보세요',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.myRentals.length,
      itemBuilder: (context, index) {
        return MyRentalCard(rental: state.myRentals[index]);
      },
    );
  }
}
