import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/feature/space_rental/logic/space_detail_state.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:hankan/app/service/sendbird_service.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import 'package:get_it/get_it.dart';

final spaceDetailProvider =
    StateNotifierProvider.family<SpaceDetailNotifier, SpaceDetailState, int>(
        (ref, spaceId) {
  return SpaceDetailNotifier(spaceId);
});

class SpaceDetailNotifier extends StateNotifier<SpaceDetailState> {
  final int spaceId;

  SpaceDetailNotifier(this.spaceId) : super(const SpaceDetailState()) {
    loadSpaceDetail();
  }

  Future<void> loadSpaceDetail() async {
    state = state.copyWith(isLoading: true, hasError: false);

    final result = await ApiService.I.getSpaceDetail(spaceId);

    result.fold(
      onFailure: (error) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.message,
        );
      },
      onSuccess: (spaceDetail) {
        state = state.copyWith(
          isLoading: false,
          spaceDetail: spaceDetail,
          hasError: false,
        );
      },
    );
  }

  void selectSize(String size) {
    state = state.copyWith(selectedSize: size);
  }

  void updateQuantity(int quantity) {
    state = state.copyWith(selectedQuantity: quantity);
  }

  void updateDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      selectedStartDate: startDate,
      selectedEndDate: endDate,
    );
  }

  Future<GroupChannel?> startChatting(String nickname) async {
    final sendbirdService = SendbirdService.I;

    if (!sendbirdService.isConnected) {
      state = state.copyWith(
        errorMessage: 'Chat service not connected',
      );
      return null;
    }

    try {
      final currentUserId = sendbirdService.currentUser?.userId;
      if (currentUserId == null) {
        state = state.copyWith(
          errorMessage: 'User not authenticated',
        );
        return null;
      }

      final ownerId = "user_${state.spaceDetail?.owner.id}";

      final channelName = '$nickname - ${state.selectedSize}';

      final channel = await sendbirdService.createChannel(
        userIds: [currentUserId, ownerId],
        name: channelName,
        isDistinct: false,
      );

      final initialMessage = '''
공간 요청:
- 크기: ${state.selectedSize}
- 수량: ${state.selectedQuantity}
- 위치: ${state.spaceDetail?.address}
      ''';

      await sendbirdService.sendTextMessage(
        channel: channel,
        text: initialMessage,
      );
      RouterService.I.router.pushReplacement('/chat/${channel.channelUrl}');

      return channel;
    } catch (e) {
      log(e.toString());
      state = state.copyWith(
        errorMessage: 'Failed to start chat: ${e.toString()}',
      );
      return null;
    }
  }
}
