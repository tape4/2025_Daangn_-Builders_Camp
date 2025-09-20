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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.mySpaces.length,
      itemBuilder: (context, index) {
        return MySpaceCard(space: state.mySpaces[index]);
      },
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