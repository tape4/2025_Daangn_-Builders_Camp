import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/feature/home/screens/message/logic/chat_provider.dart';
import 'package:hankan/app/feature/home/screens/message/widgets/message_bubble.dart';
import 'package:hankan/app/feature/home/screens/message/widgets/message_input.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String channelUrl;

  const ChatScreen({
    Key? key,
    required this.channelUrl,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    ref.read(chatProvider(widget.channelUrl).notifier).initializeChat();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 200) {
      ref.read(chatProvider(widget.channelUrl).notifier).loadPreviousMessages();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.channelUrl));
    final chatNotifier = ref.read(chatProvider(widget.channelUrl).notifier);

    // Auto-scroll when new messages arrive
    ref.listen(chatProvider(widget.channelUrl), (previous, next) {
      if (previous != null && next.messages.length > previous.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        backgroundColor: context.colorScheme.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colorScheme.foreground),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatState.channel?.name ?? '채팅',
              style: ShadTheme.of(context).textTheme.h4,
            ),
            if (chatState.typingUserIds.isNotEmpty)
              Text(
                '입력 중...',
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: context.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
              )
            else if (chatState.channel != null)
              Text(
                '${chatState.channel!.memberCount}명',
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: context.colorScheme.mutedForeground,
                    ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (chatState.isLoading && chatState.messages.isEmpty)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (chatState.errorMessage != null && chatState.messages.isEmpty)
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
                      '메시지를 불러올 수 없습니다',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      chatState.errorMessage!,
                      style: ShadTheme.of(context).textTheme.small,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: chatState.messages.length +
                        (chatState.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0 && chatState.isLoadingMore) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final messageIndex =
                          chatState.isLoadingMore ? index - 1 : index;
                      if (messageIndex < 0 ||
                          messageIndex >= chatState.messages.length) {
                        return const SizedBox.shrink();
                      }

                      final message = chatState.messages[messageIndex];
                      final previousMessage = messageIndex > 0
                          ? chatState.messages[messageIndex - 1]
                          : null;

                      final showAvatar = previousMessage == null ||
                          previousMessage.sender.user_id !=
                              message.sender.user_id ||
                          (message.created_at - previousMessage.created_at) >
                              60000;

                      return MessageBubble(
                        message: message,
                        showAvatar: showAvatar,
                        onLongPress: message.is_mine
                            ? () => _showMessageOptions(message.message_id)
                            : null,
                      );
                    },
                  ),
                  if (chatState.hasMore && !chatState.isLoadingMore)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              context.colorScheme.background.withOpacity(0.9),
                              context.colorScheme.background.withOpacity(0),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '더 보기',
                            style: ShadTheme.of(context)
                                .textTheme
                                .small
                                .copyWith(
                                  color: context.colorScheme.mutedForeground,
                                ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          MessageInput(
            onSendText: (text) async {
              await chatNotifier.sendTextMessage(text);
            },
            onAttachFile: () {
              // TODO: Implement file attachment
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('파일 첨부 기능은 곧 제공될 예정입니다!')),
              );
            },
            onTypingStart: chatNotifier.startTyping,
            onTypingEnd: chatNotifier.endTyping,
            isSending: chatState.isSending,
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(String messageId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  Icon(Icons.delete, color: context.colorScheme.destructive),
              title: Text(
                '메시지 삭제',
                style: TextStyle(color: context.colorScheme.destructive),
              ),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(chatProvider(widget.channelUrl).notifier)
                    .deleteMessage(messageId);
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: context.colorScheme.foreground),
              title: Text(
                '메시지 복사',
                style: TextStyle(color: context.colorScheme.foreground),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement copy to clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('메시지가 복사되었습니다!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
