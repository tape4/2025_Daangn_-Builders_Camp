import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/feature/space_rental/models/space_rental_option.dart';

part 'space_rental_state.freezed.dart';
part 'space_rental_state.g.dart';

@freezed
class SpaceRentalState with _$SpaceRentalState {
  const factory SpaceRentalState({
    String? imagePath,
    @Default(0.0) double width,
    @Default(0.0) double depth,
    @Default(0.0) double height,
    @Default('') String region,
    @Default('') String detailAddress,
    DateTime? startDate,
    DateTime? endDate,
    @Default({}) Map<StorageOption, int> optionQuantities,
    @Default({}) Map<StorageOption, int> optionPrices,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SpaceRentalState;

  factory SpaceRentalState.fromJson(Map<String, dynamic> json) =>
      _$SpaceRentalStateFromJson(json);
}

extension SpaceRentalStateExtension on SpaceRentalState {
  double get totalVolume => width * depth * height;

  double get usedVolume {
    double total = 0;
    optionQuantities.forEach((option, quantity) {
      total += option.volume * quantity;
    });
    return total;
  }

  double get remainingVolume => totalVolume - usedVolume;

  bool canAddOption(StorageOption option) {
    return option.volume <= remainingVolume;
  }

  int getMaxQuantityForOption(StorageOption option) {
    if (option.volume == 0) return 0;
    return (remainingVolume / option.volume).floor();
  }

  bool get isValid {
    return width > 0 &&
        depth > 0 &&
        height > 0 &&
        region.isNotEmpty &&
        startDate != null &&
        endDate != null &&
        optionQuantities.values.any((quantity) => quantity > 0) &&
        optionPrices.entries
            .where((entry) => (optionQuantities[entry.key] ?? 0) > 0)
            .every((entry) => entry.value > 0);
  }
}
