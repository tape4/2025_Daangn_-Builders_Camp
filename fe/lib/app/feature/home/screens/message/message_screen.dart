import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/feature/home/screens/message/logic/channel_list_provider.dart';
import 'package:hankan/app/feature/home/screens/message/logic/message_provider.dart';
import 'package:hankan/app/feature/home/screens/message/widgets/channel_list_item.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMessages();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(messageProvider.notifier).loadMoreChannels();
    }
  }

  Future<void> _initializeMessages() async {
    final messageNotifier = ref.read(messageProvider.notifier);
    final state = ref.read(messageProvider);

    if (!state.isConnected) {
      // TODO: Replace with actual user ID from your auth system
      await messageNotifier.connectUser(
        userId: 'test_user_${DateTime.now().millisecondsSinceEpoch}',
        nickname: 'Test User',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageProvider);
    final filteredChannels = ref.watch(filteredChannelsProvider);
    final searchQuery = ref.watch(channelSearchProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        backgroundColor: context.colorScheme.background,
        title: Text(
          'Messages',
          style: ShadTheme.of(context).textTheme.h3,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.colorScheme.foreground),
            onPressed: _showCreateChannelDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ShadInput(
              placeholder: const Text('Search messages...'),
              prefix: Icon(
                Icons.search,
                color: context.colorScheme.mutedForeground,
                size: 20,
              ),
              onChanged: (value) {
                ref.read(channelSearchProvider.notifier).state = value;
              },
            ),
          ),
          if (state.isLoading && state.channels.isEmpty)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (state.errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: context.colorScheme.destructive,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading messages',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      style: ShadTheme.of(context).textTheme.small,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ShadButton(
                      onPressed: _initializeMessages,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredChannels.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: context.colorScheme.mutedForeground,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isNotEmpty
                          ? 'No results found'
                          : 'No conversations yet',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      searchQuery.isNotEmpty
                          ? 'Try a different search term'
                          : 'Start a new conversation',
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                    if (searchQuery.isEmpty) ...[
                      const SizedBox(height: 16),
                      ShadButton(
                        onPressed: _showCreateChannelDialog,
                        child: const Text('Start New Chat'),
                      ),
                    ],
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(messageProvider.notifier).loadChannels();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      filteredChannels.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredChannels.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final channel = filteredChannels[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ChannelListItem(
                        channel: channel,
                        onTap: () {
                          context.push('/chat/${channel.channel_url}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCreateChannelDialog() {
    final userIdController = TextEditingController();
    final channelNameController = TextEditingController();

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('New Conversation'),
        description: const Text('Start a new chat with other users'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadInputFormField(
              controller: channelNameController,
              placeholder: const Text('Channel name (optional)'),
              label: const Text('Channel Name'),
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              controller: userIdController,
              placeholder: const Text('Enter user IDs separated by commas'),
              label: const Text('User IDs'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter at least one user ID';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          ShadButton.outline(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ShadButton(
            child: const Text('Create'),
            onPressed: () async {
              final userIds = userIdController.text
                  .split(',')
                  .map((id) => id.trim())
                  .where((id) => id.isNotEmpty)
                  .toList();

              if (userIds.isNotEmpty) {
                try {
                  final channel =
                      await ref.read(messageProvider.notifier).createChannel(
                            userIds: userIds,
                            name: channelNameController.text.trim().isEmpty
                                ? null
                                : channelNameController.text.trim(),
                          );

                  Navigator.of(context).pop();
                  context.push('/chat/${channel.channelUrl}');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create channel: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
