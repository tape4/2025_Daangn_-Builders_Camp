import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/model/space_detail_model.dart';

part 'home_state.freezed.dart';
part 'home_state.g.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    required List<String> filters,
    @Default(true) bool isBorrowMode,
    @Default([]) List<SpaceDetail> availableSpaces,
    @Default(0) int currentCarouselIndex,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
    required DateTime startDate,
    required DateTime endDate,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}
