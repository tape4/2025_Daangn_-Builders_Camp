import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/feature/home/screens/history/logic/history_state.dart';
import 'package:hankan/app/model/reservation_model.dart';

final historyProvider = NotifierProvider<HistoryProvider, HistoryState>(
  HistoryProvider.new,
);

class HistoryProvider extends Notifier<HistoryState> {
  @override
  HistoryState build() {
    return const HistoryState(isLoading: true);
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Load both types of reservations in parallel
      final results = await Future.wait([
        ApiService.I.getMySpaceReservations(),
        ApiService.I.getMyReservations(),
      ]);

      final mySpacesResult = results[0];
      final myRentalsResult = results[1];

      // Handle my spaces result
      mySpacesResult.fold(
        onSuccess: (mySpaces) {
          // Handle my rentals result
          myRentalsResult.fold(
            onSuccess: (myRentals) {
              state = state.copyWith(
                mySpaces: mySpaces as List<MySpaceReservation>,
                myRentals: myRentals as List<MyRentalReservation>,
                isLoading: false,
                errorMessage: null,
              );
            },
            onFailure: (error) {
              state = state.copyWith(
                mySpaces: mySpaces as List<MySpaceReservation>,
                myRentals: [],
                isLoading: false,
                errorMessage: '대여중인 공간 정보를 불러오는데 실패했습니다: ${error.message}',
              );
            },
          );
        },
        onFailure: (error) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: '공간 정보를 불러오는데 실패했습니다: ${error.message}',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '데이터를 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  void setSelectedTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  Future<void> refresh() async {
    await loadData();
  }
}
