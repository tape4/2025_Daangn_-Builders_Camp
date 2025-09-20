import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/model/space_detail_model.dart';

part 'space_detail_state.freezed.dart';

@freezed
class SpaceDetailState with _$SpaceDetailState {
  const factory SpaceDetailState({
    SpaceDetail? spaceDetail,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
    @Default(1) int selectedQuantity,
    String? selectedSize,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
  }) = _SpaceDetailState;
}