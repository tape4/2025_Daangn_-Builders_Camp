import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/feature/home/logic/home_state.dart';
import 'package:hankan/app/model/space_detail_model.dart';

final homeProvider = NotifierProvider<HomeProvider, HomeState>(
  HomeProvider.new,
);

class HomeProvider extends Notifier<HomeState> {
  @override
  build() {
    Future.microtask(() => fetchAvailableSpaces());
    return HomeState(
      filters: [],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 90)),
    );
  }

  Future<void> fetchAvailableSpaces() async {
    state = state.copyWith(isLoading: true, hasError: false);

    final result = await ApiService.I.getAvailableSpaces(
      startDate: state.startDate,
      endDate: state.endDate,
    );

    result.fold(
      onFailure: (error) {
        log(error.rawError.toString());
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.message,
        );
      },
      onSuccess: (spaces) {
        log(spaces.toString());
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
    // Fetch spaces with date filters when in borrow mode
    if (state.isBorrowMode &&
        (state.startDate != null || state.endDate != null)) {
      searchSpacesByDate();
    } else if (!state.isBorrowMode) {
      fetchAvailableSpaces();
    }
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
    // If in borrow mode and dates are set, fetch spaces by date
    if (state.isBorrowMode) {
      searchSpacesByDate();
    }
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
    // If in borrow mode and dates are set, fetch spaces by date
    if (state.isBorrowMode) {
      searchSpacesByDate();
    }
  }

  void addSpaceDetail(SpaceDetail space) {
    final updatedSpaces = List<SpaceDetail>.from(state.availableSpaces)
      ..add(space);
    state = state.copyWith(availableSpaces: updatedSpaces);
  }

  Future<void> searchSpacesByDate() async {
    if (!state.isBorrowMode) return;

    state = state.copyWith(isLoading: true, hasError: false);

    final result = await ApiService.I.getAvailableSpaces(
      startDate: state.startDate,
      endDate: state.endDate,
    );

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
}
