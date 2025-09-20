import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/screens/history/logic/history_state.dart';
import 'package:hankan/app/feature/home/screens/history/models/rental_history.dart';

final historyProvider = NotifierProvider<HistoryProvider, HistoryState>(
  HistoryProvider.new,
);

class HistoryProvider extends Notifier<HistoryState> {
  @override
  HistoryState build() {
    _loadRentalHistories();
    return const HistoryState(isLoading: true);
  }

  Future<void> _loadRentalHistories() async {
    await Future.delayed(Duration(milliseconds: 100));
    final sampleHistories = [
      RentalHistory(
        id: '1',
        title: '강남구 아파트 창고',
        imageUrl: 'https://example.com/image1.jpg',
        region: '서울특별시 강남구',
        detailAddress: '테헤란로 123 아파트 101동',
        width: 200,
        depth: 150,
        height: 180,
        storageOptions: {
          'box': 5,
          'xs': 3,
          's': 2,
        },
        storagePrices: {
          'box': 10000,
          'xs': 25000,
          's': 40000,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        status: RentalStatus.active,
        totalIncome: 450000,
        currentRentedCount: 7,
        totalCapacity: 10,
        startDate: DateTime.now().subtract(const Duration(days: 60)),
      ),
      RentalHistory(
        id: '2',
        title: '마포구 빌라 다용도실',
        imageUrl: 'https://example.com/image2.jpg',
        region: '서울특별시 마포구',
        detailAddress: '와우산로 456 빌라 2층',
        width: 150,
        depth: 100,
        height: 200,
        storageOptions: {
          'box': 10,
          'xs': 2,
        },
        storagePrices: {
          'box': 8000,
          'xs': 20000,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        status: RentalStatus.active,
        totalIncome: 120000,
        currentRentedCount: 8,
        totalCapacity: 12,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
      RentalHistory(
        id: '3',
        title: '송파구 주택 지하실',
        imageUrl: 'https://example.com/image3.jpg',
        region: '서울특별시 송파구',
        detailAddress: '올림픽로 789',
        width: 300,
        depth: 250,
        height: 220,
        storageOptions: {
          'm': 2,
          'l': 1,
        },
        storagePrices: {
          'm': 60000,
          'l': 80000,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        status: RentalStatus.completed,
        totalIncome: 600000,
        currentRentedCount: 0,
        totalCapacity: 3,
        startDate: DateTime.now().subtract(const Duration(days: 120)),
        endDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    state = state.copyWith(rentalHistories: sampleHistories, isLoading: false);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadRentalHistories();
    state = state.copyWith(isLoading: false);
  }
}
