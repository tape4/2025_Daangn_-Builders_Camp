import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_state.freezed.dart';
part 'history_state.g.dart';

@freezed
class HistoryState with _$HistoryState {
  factory HistoryState({
    required List<String> histories,
  }) = _HistoryState;

  factory HistoryState.fromJson(Map<String, dynamic> json) =>
      _$HistoryStateFromJson(json);
}
