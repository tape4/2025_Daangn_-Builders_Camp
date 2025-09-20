import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/logic/home_state.dart';

final homeProvider = NotifierProvider<HomeProvider, HomeState>(
  HomeProvider.new,
);

class HomeProvider extends Notifier<HomeState> {
  @override
  build() {
    return HomeState(filters: ["asdf"], sometings: []);
  }

  void someFunctions() {
    state = state.copyWith(
      filters: [
        ...state.filters,
        "aaa",
      ],
    );
  }
}
