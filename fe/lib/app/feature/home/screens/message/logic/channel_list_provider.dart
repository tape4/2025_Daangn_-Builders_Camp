import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/screens/message/logic/message_provider.dart';
import 'package:hankan/app/service/sendbird_service.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

final channelProvider = FutureProvider.family<GroupChannel, String>(
  (ref, channelUrl) async {
    final sendbirdService = SendbirdService.I;
    return await sendbirdService.getChannel(channelUrl);
  },
);

final channelSearchProvider = StateProvider<String>((ref) => '');

final filteredChannelsProvider = Provider((ref) {
  final messageState = ref.watch(messageProvider);
  final searchQuery = ref.watch(channelSearchProvider).toLowerCase();

  if (searchQuery.isEmpty) {
    return messageState.channels;
  }

  return messageState.channels.where((channel) {
    final name = channel.name.toLowerCase();
    final lastMessage = channel.last_message?.toLowerCase() ?? '';
    return name.contains(searchQuery) || lastMessage.contains(searchQuery);
  }).toList();
});