import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/feature/home/screens/message/logic/chat_provider_handler.dart';
import 'package:hankan/app/model/message_model.dart';
import 'package:hankan/app/model/sendbird_user_model.dart';
import 'package:hankan/app/service/sendbird_service.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

part 'chat_provider.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required String channelUrl,
    @Default([]) List<MessageModel> messages,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isSending,
    @Default([]) List<String> typingUserIds,
    GroupChannel? channel,
    String? errorMessage,
  }) = _ChatState;
}

final chatProvider = NotifierProvider.family<ChatNotifier, ChatState, String>(
  ChatNotifier.new,
);

class ChatNotifier extends FamilyNotifier<ChatState, String> {
  late final SendbirdService _sendbirdService;
  MessageCollection? _messageCollection;
  GroupChannel? _channel;

  @override
  ChatState build(String arg) {
    _sendbirdService = SendbirdService.I;

    return ChatState(channelUrl: arg, isLoading: true);
  }

  Future<void> initializeChat() async {
    try {
      _channel = await _sendbirdService.getChannel(arg);
      state = state.copyWith(channel: _channel);

      await _loadMessages();
      _setupChannelHandler();
      await _markAsRead();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _loadMessages() async {
    if (_channel == null) return;

    _messageCollection?.dispose();
    _messageCollection = _sendbirdService.createMessageCollection(
      channel: _channel!,
      handler: _createMessageCollectionHandler(),
    );

    await _messageCollection!.initialize();
    final messages = _convertMessages(_messageCollection!.messageList);

    state = state.copyWith(
      messages: messages,
      hasMore: _messageCollection!.hasPrevious,
      isLoading: false,
    );
  }

  MessageCollectionHandler _createMessageCollectionHandler() {
    return MyMessageCollectionHandler(
      onMessagesAddedCallback: (context, channel, messages) {
        final newMessages = _convertMessages(messages);
        state = state.copyWith(
          messages: [...state.messages, ...newMessages],
        );
        _markAsRead();
      },
      onMessagesUpdatedCallback: (context, channel, messages) {
        final updatedMessageIds = messages.map((m) => m.messageId).toSet();
        final updatedMessages = state.messages.map((message) {
          if (updatedMessageIds.contains(int.tryParse(message.message_id))) {
            final updatedMessage = messages.firstWhere(
              (m) => m.messageId.toString() == message.message_id,
            );
            return _convertMessage(updatedMessage);
          }
          return message;
        }).toList();

        state = state.copyWith(messages: updatedMessages);
      },
      onMessagesDeletedCallback: (context, channel, messages) {
        final deletedMessageIds =
            messages.map((m) => m.messageId.toString()).toSet();
        final remainingMessages = state.messages
            .where((message) => !deletedMessageIds.contains(message.message_id))
            .toList();
        state = state.copyWith(messages: remainingMessages);
      },
      onChannelUpdatedCallback: (context, channel) {
        state = state.copyWith(channel: channel);
      },
      onChannelDeletedCallback: (context, channelUrl) {
        state = state.copyWith(errorMessage: 'Channel has been deleted');
      },
      onHugeGapDetectedCallback: () {
        _loadMessages();
      },
    );
  }

  void _setupChannelHandler() {
    if (_channel == null) return;

    SendbirdChat.addChannelHandler(
      'chat_$arg',
      MyGroupChannelHandler(
        onTypingStatusUpdatedCallback: (channel) {
          if (channel.channelUrl == arg) {
            final typingUserIds =
                channel.getTypingUsers().map((user) => user.userId).toList();
            state = state.copyWith(typingUserIds: typingUserIds);
          }
        },
      ),
    );
  }

  List<MessageModel> _convertMessages(List<BaseMessage> messages) {
    return messages.map(_convertMessage).toList();
  }

  MessageModel _convertMessage(BaseMessage message) {
    final currentUserId = _sendbirdService.currentUser?.userId;

    return MessageModel(
      message_id: message.messageId.toString(),
      message: message.message,
      channel_url: message.channelUrl,
      type: message.messageType.name,
      sender: SendbirdUserModel(
        user_id: message.sender?.userId ?? '',
        nickname: message.sender?.nickname ?? '',
        profile_url: message.sender?.profileUrl ?? '',
      ),
      created_at: message.createdAt,
      is_mine: message.sender?.userId == currentUserId,
      custom_type: message.customType ?? '',
      data: message.data is Map<String, dynamic>
          ? message.data as Map<String, dynamic>
          : {},
      updated_at: message.updatedAt,
      file_url: message is FileMessage ? message.url : null,
      file_name: message is FileMessage ? message.name : null,
      file_type: message is FileMessage ? message.type : null,
      file_size: message is FileMessage ? message.size : null,
      sending_status: message.sendingStatus?.name ?? 'none',
    );
  }

  Future<void> sendTextMessage(String text) async {
    if (_channel == null || text.trim().isEmpty) return;

    state = state.copyWith(isSending: true, errorMessage: null);

    try {
      await _sendbirdService.sendTextMessage(
        channel: _channel!,
        text: text,
      );
      state = state.copyWith(isSending: false);
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> sendFileMessage(FileMessageCreateParams params) async {
    if (_channel == null) return;

    state = state.copyWith(isSending: true, errorMessage: null);

    try {
      await _sendbirdService.sendFileMessage(
        channel: _channel!,
        params: params,
      );
      state = state.copyWith(isSending: false);
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadPreviousMessages() async {
    if (state.isLoadingMore || !state.hasMore || _messageCollection == null) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      await _messageCollection!.loadPrevious();
      final hasMore = _messageCollection!.hasPrevious;
      final messages = _convertMessages(_messageCollection!.messageList);

      state = state.copyWith(
        messages: messages,
        hasMore: hasMore,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  void startTyping() {
    if (_channel != null) {
      _channel!.startTyping();
    }
  }

  void endTyping() {
    if (_channel != null) {
      _channel!.endTyping();
    }
  }

  Future<void> _markAsRead() async {
    if (_channel != null) {
      await _sendbirdService.markAsRead(_channel!);
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      final messageIdInt = int.tryParse(messageId);
      if (messageIdInt == null) return;

      final message = _messageCollection?.messageList.firstWhere(
        (m) => m.messageId == messageIdInt,
      );

      if (message != null && _channel != null) {
        await _channel!.deleteMessage(message.messageId);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void dispose() {
    _messageCollection?.dispose();
    SendbirdChat.removeChannelHandler('chat_$arg');
  }
}
