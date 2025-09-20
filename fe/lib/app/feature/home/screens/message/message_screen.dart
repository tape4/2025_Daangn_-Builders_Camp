import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/feature/home/screens/message/logic/channel_list_provider.dart';
import 'package:hankan/app/feature/home/screens/message/logic/message_provider.dart';
import 'package:hankan/app/feature/home/screens/message/widgets/channel_list_item.dart';
import 'package:hankan/app/model/user.dart';
import 'package:hankan/app/provider/user_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
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
    final user = ref.read(userProvider);
    if (!state.isConnected && user.id != -1) {
      await messageNotifier.connectUser(
        userId: 'user_${user.id}',
        nickname: user.nickname,
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
          '메시지함',
          style: ShadTheme.of(context).textTheme.h3,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ShadInput(
              placeholder: const Text('메시지 검색...'),
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
                      '메시지 로드 오류',
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
                      child: const Text('다시 시도'),
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
                      searchQuery.isNotEmpty
                          ? Symbols.chat_error
                          : Symbols.chat_bubble_outline,
                      size: 64,
                      color: context.colorScheme.mutedForeground,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isNotEmpty ? '검색 결과가 없습니다' : '아직 대화가 없습니다',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
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
}
