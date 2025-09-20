import 'package:flutter/material.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/model/channel_model.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChannelListItem extends StatelessWidget {
  final ChannelModel channel;
  final VoidCallback onTap;

  const ChannelListItem({
    Key? key,
    required this.channel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ShadAvatar(
                channel.cover_url,
                placeholder: Text(
                  channel.name.isNotEmpty ? channel.name[0].toUpperCase() : 'C',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            channel.name,
                            style: ShadTheme.of(context).textTheme.p.copyWith(
                                  fontWeight: channel.unread_message_count > 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (channel.last_message_created_at != null)
                          Text(
                            _formatTime(channel.last_message_created_at!),
                            style: ShadTheme.of(context)
                                .textTheme
                                .small
                                .copyWith(
                                  color: context.colorScheme.mutedForeground,
                                ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (channel.is_typing) ...[
                          Text(
                            channel.typing_members.isNotEmpty
                                ? '${channel.typing_members.join(', ')} typing...'
                                : 'Someone is typing...',
                            style:
                                ShadTheme.of(context).textTheme.small.copyWith(
                                      color: context.colorScheme.primary,
                                      fontStyle: FontStyle.italic,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ] else ...[
                          Expanded(
                            child: Text(
                              channel.last_message ?? 'No messages yet',
                              style: ShadTheme.of(context)
                                  .textTheme
                                  .small
                                  .copyWith(
                                    color: context.colorScheme.mutedForeground,
                                    fontWeight: channel.unread_message_count > 0
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (channel.unread_message_count > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              channel.unread_message_count > 99
                                  ? '99+'
                                  : channel.unread_message_count.toString(),
                              style: TextStyle(
                                color: context.colorScheme.primaryForeground,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('MM/dd').format(date);
    }
  }
}
