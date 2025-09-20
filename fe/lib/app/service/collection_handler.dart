import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

// Basic GroupChannelCollectionHandler implementation for SDK v4.5.2
class BasicGroupChannelCollectionHandler extends GroupChannelCollectionHandler {
  @override
  void onChannelsAdded(GroupChannelContext context, List<GroupChannel> channels) {
    // Handle channels added
  }

  @override
  void onChannelsUpdated(GroupChannelContext context, List<GroupChannel> channels) {
    // Handle channels updated
  }

  @override
  void onChannelsDeleted(GroupChannelContext context, List<String> deletedChannelUrls) {
    // Handle channels deleted
  }
}