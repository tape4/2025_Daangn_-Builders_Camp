import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/item_storage/logic/item_storage_state.dart';

final itemStorageProvider =
    NotifierProvider<ItemStorageNotifier, ItemStorageState>(
  ItemStorageNotifier.new,
);

class ItemStorageNotifier extends Notifier<ItemStorageState> {
  @override
  ItemStorageState build() {
    return const ItemStorageState();
  }

  void updateImageUrl(String url) {
    state = state.copyWith(imageUrl: url);
  }

  void updateDimensions({
    double? width,
    double? depth,
    double? height,
  }) {
    state = state.copyWith(
      width: width ?? state.width,
      depth: depth ?? state.depth,
      height: height ?? state.height,
    );
  }

  void updateLocation(String region, String detailAddress) {
    state = state.copyWith(
      region: region,
      detailAddress: detailAddress,
    );
  }

  void updateStoragePeriod(DateTime? startDate, DateTime? endDate) {
    if (startDate != null && endDate != null) {
      if (startDate.isAfter(endDate)) {
        state = state.copyWith(
          errorMessage: '종료일이 시작일보다 빨라야 합니다.',
        );
        return;
      }
    }

    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
      errorMessage: null,
    );
  }

  void updatePriceRange(int minPrice, int maxPrice) {
    if (minPrice > maxPrice) {
      state = state.copyWith(
        errorMessage: '최소 금액이 최대 금액보다 클 수 없습니다.',
      );
      return;
    }

    state = state.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      errorMessage: null,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> submitItemStorage() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: '모든 필수 항목을 입력해주세요.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '등록 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  void reset() {
    state = const ItemStorageState();
  }
}
