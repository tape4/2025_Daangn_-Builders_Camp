import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/logic/home_state.dart';
import 'package:hankan/app/feature/home/screens/history/logic/history_state.dart';

final historyProvider = NotifierProvider<HistoryProvider, HistoryState>(
  HistoryProvider.new,
);

class HistoryProvider extends Notifier<HistoryState> {
  @override
  build() {
    return HistoryState(
      histories: ["hello", "hi"],
    );
  }
}
