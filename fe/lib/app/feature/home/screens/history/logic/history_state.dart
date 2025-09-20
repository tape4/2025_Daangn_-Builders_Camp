import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/model/reservation_model.dart';

part 'history_state.freezed.dart';
part 'history_state.g.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default([]) List<MySpaceReservation> mySpaces,
    @Default([]) List<MyRentalReservation> myRentals,
    @Default(false) bool isLoading,
    @Default(0) int selectedTab,
    String? errorMessage,
  }) = _HistoryState;

  factory HistoryState.fromJson(Map<String, dynamic> json) =>
      _$HistoryStateFromJson(json);
}
