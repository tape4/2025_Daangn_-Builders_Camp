import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

// Custom handler for GroupChannelCollection
// Since the SDK doesn't expose CollectionHandler directly,
// we'll use the handler through the collection itself
class MyGroupChannelCollectionHandler {
  final Function(List<GroupChannel>)? onChannelsAddedCallback;
  final Function(List<GroupChannel>)? onChannelsUpdatedCallback;
  final Function(List<String>)? onChannelsDeletedCallback;

  MyGroupChannelCollectionHandler({
    this.onChannelsAddedCallback,
    this.onChannelsUpdatedCallback,
    this.onChannelsDeletedCallback,
  });
}