import 'dart:async';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/service/collection_handler.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class SendbirdService {
  static SendbirdService get I => GetIt.I<SendbirdService>();

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isConnected => _currentUser != null;

  void init() {
    final appId = dotenv.env['SENDBIRD_APP_ID'];
    if (appId == null || appId.isEmpty || appId == 'YOUR_SENDBIRD_APP_ID') {
      throw Exception('SENDBIRD_APP_ID not configured in .env file');
    }

    SendbirdChat.init(appId: appId);

    _setupEventHandlers();
  }

  void _setupEventHandlers() {
    // Connection handlers will be set up as needed
    // The SDK v4.5.2 handles connection events internally
  }

  Future<User> connect({
    required String userId,
    String? nickname,
    String? accessToken,
  }) async {
    try {
      _currentUser = await SendbirdChat.connect(
        userId,
        nickname: nickname,
        accessToken: accessToken,
      );
      return _currentUser!;
    } catch (e) {
      throw Exception('Failed to connect to Sendbird: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      await SendbirdChat.disconnect();
      _currentUser = null;
    } catch (e) {
      log('Error disconnecting from Sendbird: $e');
    }
  }

  Future<void> updateCurrentUserInfo({
    String? nickname,
    String? profileUrl,
  }) async {
    if (_currentUser == null) {
      throw Exception('User not connected');
    }

    try {
      await SendbirdChat.updateCurrentUserInfo(
        nickname: nickname,
      );
    } catch (e) {
      throw Exception('Failed to update user info: $e');
    }
  }

  GroupChannelCollection createChannelCollection() {
    final query = GroupChannelListQuery()
      ..order = GroupChannelListQueryOrder.latestLastMessage
      ..limit = 20;

    // Create collection with basic handler
    return GroupChannelCollection(
      query: query,
      handler: BasicGroupChannelCollectionHandler(),
    );
  }

  Future<GroupChannel> createChannel({
    required List<String> userIds,
    String? name,
    String? coverUrl,
    bool isDistinct = true,
  }) async {
    try {
      final params = GroupChannelCreateParams()
        ..userIds = userIds
        ..name = name
        ..isDistinct = isDistinct;

      return await GroupChannel.createChannel(params);
    } catch (e) {
      throw Exception('Failed to create channel: $e');
    }
  }

  Future<GroupChannel> getChannel(String channelUrl) async {
    try {
      return await GroupChannel.getChannel(channelUrl);
    } catch (e) {
      throw Exception('Failed to get channel: $e');
    }
  }

  MessageCollection createMessageCollection({
    required GroupChannel channel,
    required MessageCollectionHandler handler,
  }) {
    final params = MessageListParams()
      ..reverse = false
      ..previousResultSize = 20
      ..nextResultSize = 20;

    return MessageCollection(
      channel: channel,
      params: params,
      handler: handler,
    );
  }

  Future<BaseMessage> sendTextMessage({
    required GroupChannel channel,
    required String text,
  }) async {
    try {
      final params = UserMessageCreateParams(message: text);
      return channel.sendUserMessage(params);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<FileMessage> sendFileMessage({
    required GroupChannel channel,
    required FileMessageCreateParams params,
  }) async {
    try {
      return channel.sendFileMessage(params);
    } catch (e) {
      throw Exception('Failed to send file message: $e');
    }
  }

  Future<void> markAsRead(GroupChannel channel) async {
    try {
      await channel.markAsRead();
    } catch (e) {
      log('Failed to mark channel as read: $e');
    }
  }

  void dispose() {
    SendbirdChat.removeConnectionHandler('main_connection_handler');
  }
}