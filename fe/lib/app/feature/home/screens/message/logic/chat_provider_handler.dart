import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MyMessageCollectionHandler extends MessageCollectionHandler {
  final Function(MessageContext, GroupChannel, List<BaseMessage>)? onMessagesAddedCallback;
  final Function(MessageContext, GroupChannel, List<BaseMessage>)? onMessagesUpdatedCallback;
  final Function(MessageContext, GroupChannel, List<BaseMessage>)? onMessagesDeletedCallback;
  final Function(GroupChannelContext, GroupChannel)? onChannelUpdatedCallback;
  final Function(GroupChannelContext, String)? onChannelDeletedCallback;
  final Function()? onHugeGapDetectedCallback;

  MyMessageCollectionHandler({
    this.onMessagesAddedCallback,
    this.onMessagesUpdatedCallback,
    this.onMessagesDeletedCallback,
    this.onChannelUpdatedCallback,
    this.onChannelDeletedCallback,
    this.onHugeGapDetectedCallback,
  });

  @override
  void onMessagesAdded(MessageContext context, GroupChannel channel, List<BaseMessage> messages) {
    onMessagesAddedCallback?.call(context, channel, messages);
  }

  @override
  void onMessagesUpdated(MessageContext context, GroupChannel channel, List<BaseMessage> messages) {
    onMessagesUpdatedCallback?.call(context, channel, messages);
  }

  @override
  void onMessagesDeleted(MessageContext context, GroupChannel channel, List<BaseMessage> messages) {
    onMessagesDeletedCallback?.call(context, channel, messages);
  }

  @override
  void onChannelUpdated(GroupChannelContext context, GroupChannel channel) {
    onChannelUpdatedCallback?.call(context, channel);
  }

  @override
  void onChannelDeleted(GroupChannelContext context, String deletedChannelUrl) {
    onChannelDeletedCallback?.call(context, deletedChannelUrl);
  }

  @override
  void onHugeGapDetected() {
    onHugeGapDetectedCallback?.call();
  }
}

class MyGroupChannelHandler extends GroupChannelHandler {
  final Function(GroupChannel)? onTypingStatusUpdatedCallback;

  MyGroupChannelHandler({this.onTypingStatusUpdatedCallback});

  @override
  void onTypingStatusUpdated(GroupChannel channel) {
    onTypingStatusUpdatedCallback?.call(channel);
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    // Handle message received event if needed
  }
}