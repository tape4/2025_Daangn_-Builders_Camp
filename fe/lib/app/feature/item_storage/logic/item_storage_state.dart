import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_storage_state.freezed.dart';
part 'item_storage_state.g.dart';

@freezed
class ItemStorageState with _$ItemStorageState {
  const factory ItemStorageState({
    @Default('') String imageUrl,
    @Default(0.0) double width,
    @Default(0.0) double depth,
    @Default(0.0) double height,
    @Default('') String region,
    @Default('') String detailAddress,
    DateTime? startDate,
    DateTime? endDate,
    @Default(0) int minPrice,
    @Default(0) int maxPrice,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ItemStorageState;

  factory ItemStorageState.fromJson(Map<String, dynamic> json) =>
      _$ItemStorageStateFromJson(json);
}

extension ItemStorageStateExtension on ItemStorageState {
  double get volume => width * depth * height;

  int get storageDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays + 1;
  }

  int get recommendedMinPrice {
    if (volume == 0) return 0;

    if (volume < 50000) {
      return 10000;
    } else if (volume < 200000) {
      return 30000;
    } else {
      return 80000;
    }
  }

  int get recommendedMaxPrice {
    if (volume == 0) return 0;

    if (volume < 50000) {
      return 30000;
    } else if (volume < 200000) {
      return 80000;
    } else {
      return 200000;
    }
  }

  int get recommendedPrice {
    if (volume == 0) return 0;

    const pricePerCm3PerMonth = 0.001;
    final basePrice = (volume * pricePerCm3PerMonth * 30).round();

    return basePrice.clamp(recommendedMinPrice, recommendedMaxPrice);
  }

  bool get isValid {
    return imageUrl.isNotEmpty &&
        width > 0 &&
        depth > 0 &&
        height > 0 &&
        region.isNotEmpty &&
        startDate != null &&
        endDate != null &&
        startDate!.isBefore(endDate!) &&
        minPrice > 0 &&
        maxPrice > 0 &&
        minPrice <= maxPrice;
  }
}