import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/feature/home/screens/history/models/rental_history.dart';

part 'history_state.freezed.dart';
part 'history_state.g.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default([]) List<RentalHistory> rentalHistories,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _HistoryState;

  factory HistoryState.fromJson(Map<String, dynamic> json) =>
      _$HistoryStateFromJson(json);
}
