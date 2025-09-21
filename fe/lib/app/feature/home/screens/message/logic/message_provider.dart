import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/screens/message/state/message_state.dart';
import 'package:hankan/app/model/channel_model.dart';
import 'package:hankan/app/model/sendbird_user_model.dart';
import 'package:hankan/app/service/sendbird_service.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

final messageProvider = NotifierProvider<MessageNotifier, MessageState>(
  MessageNotifier.new,
);

class MessageNotifier extends Notifier<MessageState> {
  late final SendbirdService _sendbirdService;
  GroupChannelCollection? _channelCollection;

  @override
  MessageState build() {
    _sendbirdService = SendbirdService.I;
    return const MessageState();
  }

  Future<void> connectUser({
    required String userId,
    String? nickname,
    String? accessToken,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _sendbirdService.connect(
        userId: userId,
        nickname: nickname,
        accessToken: accessToken,
      );

      state = state.copyWith(
        isConnected: true,
        currentUser: SendbirdUserModel(
          user_id: user.userId,
          nickname: user.nickname,
          profile_url: user.profileUrl,
          is_active: true,
          is_online: true,
        ),
        isLoading: false,
      );

      await loadChannels();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadChannels() async {
    if (_channelCollection != null) {
      _channelCollection!.dispose();
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      _channelCollection = _sendbirdService.createChannelCollection();
      _setupChannelCollectionHandler();

      await _channelCollection!.loadMore();
      final channels = _convertChannels(_channelCollection!.channelList);

      state = state.copyWith(
        channels: channels,
        hasMore: _channelCollection!.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMoreChannels() async {
    if (state.isLoadingMore || _channelCollection == null) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      await _channelCollection!.loadMore();
      final channels = _convertChannels(_channelCollection!.channelList);

      state = state.copyWith(
        channels: channels,
        hasMore: _channelCollection!.hasMore,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _setupChannelCollectionHandler() {
    // The SDK v4.5.2 handles channel events automatically through the collection
    // No manual handler setup needed - the collection will update channelList automatically
  }

  List<ChannelModel> _convertChannels(List<GroupChannel> channels) {
    return channels.map(_convertChannel).toList();
  }

  ChannelModel _convertChannel(GroupChannel channel) {
    return ChannelModel(
      channel_url: channel.channelUrl,
      name: channel.name ?? 'Unnamed Channel',
      cover_url: channel.coverUrl ?? '',
      member_count: channel.memberCount,
      unread_message_count: channel.unreadMessageCount,
      last_message: channel.lastMessage?.message,
      last_message_created_at: channel.lastMessage?.createdAt,
      is_typing: channel.isTyping,
      typing_members: channel.getTypingUsers()
          .map((user) => user.nickname ?? user.userId)
          .toList(),
    );
  }

  Future<GroupChannel> createChannel({
    required List<String> userIds,
    String? name,
    String? coverUrl,
    bool isDistinct = true,
  }) async {
    try {
      final channel = await _sendbirdService.createChannel(
        userIds: userIds,
        name: name,
        coverUrl: coverUrl,
        isDistinct: isDistinct,
      );
      return channel;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> disconnectUser() async {
    await _sendbirdService.disconnect();
    _channelCollection?.dispose();
    _channelCollection = null;
    state = const MessageState();
  }

  void dispose() {
    _channelCollection?.dispose();
  }
}