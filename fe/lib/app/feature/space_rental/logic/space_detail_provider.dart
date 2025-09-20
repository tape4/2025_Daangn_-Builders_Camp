import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/space_rental/logic/space_detail_state.dart';
import 'package:hankan/app/api/space_api_service.dart';
import 'package:get_it/get_it.dart';

final spaceDetailProvider = StateNotifierProvider.family<SpaceDetailNotifier, SpaceDetailState, int>((ref, spaceId) {
  return SpaceDetailNotifier(spaceId);
});

class SpaceDetailNotifier extends StateNotifier<SpaceDetailState> {
  final int spaceId;
  final _apiService = GetIt.I<SpaceApiService>();

  SpaceDetailNotifier(this.spaceId) : super(const SpaceDetailState()) {
    loadSpaceDetail();
  }

  Future<void> loadSpaceDetail() async {
    state = state.copyWith(isLoading: true, hasError: false);

    final result = await _apiService.getSpaceDetail(spaceId);

    result.fold(
      onFailure: (error) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.message,
        );
      },
      onSuccess: (spaceDetail) {
        state = state.copyWith(
          isLoading: false,
          spaceDetail: spaceDetail,
          hasError: false,
        );
      },
    );
  }

  void selectSize(String size) {
    state = state.copyWith(selectedSize: size);
  }

  void updateQuantity(int quantity) {
    state = state.copyWith(selectedQuantity: quantity);
  }

  void updateDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      selectedStartDate: startDate,
      selectedEndDate: endDate,
    );
  }

  Future<bool> submitRentalRequest() async {
    if (state.spaceDetail == null || state.selectedSize == null) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    final result = await _apiService.createRentalRequest(
      spaceId: spaceId,
      size: state.selectedSize!,
      quantity: state.selectedQuantity,
      startDate: state.selectedStartDate,
      endDate: state.selectedEndDate,
    );

    return result.fold(
      onFailure: (error) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.message,
        );
        return false;
      },
      onSuccess: (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }
}