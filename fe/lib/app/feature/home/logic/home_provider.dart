import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/api/space_api_service.dart';
import 'package:hankan/app/feature/home/logic/home_state.dart';

final homeProvider = NotifierProvider<HomeProvider, HomeState>(
  HomeProvider.new,
);

class HomeProvider extends Notifier<HomeState> {
  late final SpaceApiService _spaceApiService;

  @override
  build() {
    _spaceApiService = GetIt.I<SpaceApiService>();
    // Schedule fetch after build completes to avoid state access issues
    Future.microtask(() => fetchAvailableSpaces());
    return HomeState(filters: []);
  }

  Future<void> fetchAvailableSpaces() async {
    state = state.copyWith(isLoading: true, hasError: false);

    final result = await _spaceApiService.getAvailableSpaces();

    result.fold(
      onFailure: (error) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.message,
        );
      },
      onSuccess: (spaces) {
        state = state.copyWith(
          isLoading: false,
          availableSpaces: spaces,
          hasError: false,
        );
      },
    );
  }

  void updateCarouselIndex(int index) {
    state = state.copyWith(currentCarouselIndex: index);
  }

  void toggleBorrowMode() {
    state = state.copyWith(isBorrowMode: !state.isBorrowMode);
  }
}
