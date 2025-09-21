import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/feature/home/logic/home_provider.dart';
import 'package:hankan/app/feature/space_rental/logic/space_rental_state.dart';
import 'package:hankan/app/feature/space_rental/models/space_rental_option.dart';

final spaceRentalProvider =
    NotifierProvider<SpaceRentalNotifier, SpaceRentalState>(
  SpaceRentalNotifier.new,
);

class SpaceRentalNotifier extends Notifier<SpaceRentalState> {
  @override
  SpaceRentalState build() {
    return const SpaceRentalState();
  }

  void updateImagePath(String? path) {
    state = state.copyWith(imagePath: path);
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
    _validateQuantities();
  }

  void updateLocation(String region, String detailAddress) {
    state = state.copyWith(
      region: region,
      detailAddress: detailAddress,
    );
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
    );
  }

  void updateOptionQuantity(StorageOption option, int quantity) {
    if (quantity < 0) return;

    final newQuantities = Map<StorageOption, int>.from(state.optionQuantities);

    if (quantity == 0) {
      newQuantities.remove(option);
    } else {
      final currentQuantityWithoutThis = state.optionQuantities.entries
          .where((e) => e.key != option)
          .fold<double>(0, (sum, e) => sum + (e.key.volume * e.value));

      final maxQuantity =
          ((state.totalVolume - currentQuantityWithoutThis) / option.volume)
              .floor();

      if (quantity > maxQuantity) {
        state = state.copyWith(
          errorMessage: '남은 공간이 부족합니다. 최대 ${maxQuantity}개까지 가능합니다.',
        );
        return;
      }

      newQuantities[option] = quantity;
    }

    state = state.copyWith(
      optionQuantities: newQuantities,
      errorMessage: null,
    );
  }

  void incrementOption(StorageOption option) {
    final currentQuantity = state.optionQuantities[option] ?? 0;
    updateOptionQuantity(option, currentQuantity + 1);
  }

  void decrementOption(StorageOption option) {
    final currentQuantity = state.optionQuantities[option] ?? 0;
    if (currentQuantity > 0) {
      updateOptionQuantity(option, currentQuantity - 1);
    }
  }

  void updateOptionPrice(StorageOption option, int price) {
    final newPrices = Map<StorageOption, int>.from(state.optionPrices);

    if (price <= 0) {
      newPrices.remove(option);
    } else {
      newPrices[option] = price;
    }

    state = state.copyWith(optionPrices: newPrices);
  }

  void _validateQuantities() {
    final newQuantities = Map<StorageOption, int>.from(state.optionQuantities);
    bool hasChanges = false;

    for (final entry in state.optionQuantities.entries) {
      final maxQuantity = state.getMaxQuantityForOption(entry.key);
      if (entry.value > maxQuantity) {
        if (maxQuantity > 0) {
          newQuantities[entry.key] = maxQuantity;
        } else {
          newQuantities.remove(entry.key);
        }
        hasChanges = true;
      }
    }

    if (hasChanges) {
      state = state.copyWith(
        optionQuantities: newQuantities,
        errorMessage: '공간 크기가 변경되어 일부 옵션 수량이 조정되었습니다.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> submitSpaceRental() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: '모든 필수 항목을 입력해주세요.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // First get geocoding data from the address
      final fullAddress = '${state.region} ${state.detailAddress}'.trim();
      final geoResult = await ApiService.I.getKakaoGeoCoding(
        address: fullAddress,
      );

      if (!geoResult.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '주소 검색에 실패했습니다. 올바른 주소를 입력해주세요.',
        );
        return false;
      }

      final (latitude, longitude) = geoResult.data;

      // Format dates to ISO 8601 format (YYYY-MM-DD)
      final startDateStr = state.startDate!.toIso8601String().split('T')[0];
      final endDateStr = state.endDate!.toIso8601String().split('T')[0];

      // Calculate box capacities from optionQuantities
      final boxCapacityXs = state.optionQuantities[StorageOption.xs] ?? 0;
      final boxCapacityS = state.optionQuantities[StorageOption.s] ?? 0;
      final boxCapacityM = state.optionQuantities[StorageOption.m] ?? 0;
      final boxCapacityL = state.optionQuantities[StorageOption.l] ?? 0;

      // Call the API
      final result = await ApiService.I.postSpace(
        address: fullAddress,
        latitude: latitude,
        longitude: longitude,
        availableStartDate: startDateStr,
        availableEndDate: endDateStr,
        boxCapacityXs: boxCapacityXs,
        boxCapacityS: boxCapacityS,
        boxCapacityM: boxCapacityM,
        boxCapacityL: boxCapacityL,
      );

      if (result.isSuccess) {
        state = state.copyWith(isLoading: false);
        ref.read(homeProvider.notifier).addSpaceDetail(result.data);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '공간 등록에 실패했습니다.',
        );
        return false;
      }
    } catch (e) {
      log('Error submitting space rental: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '등록 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }
}
