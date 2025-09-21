import 'package:flutter/material.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/model/message_model.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool showAvatar;
  final VoidCallback? onLongPress;

  const MessageBubble({
    Key? key,
    required this.message,
    this.showAvatar = true,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message.is_mine;
    final time = DateTime.fromMillisecondsSinceEpoch(message.created_at);

    return Padding(
      padding: EdgeInsets.only(
        left: isMyMessage ? 48 : 8,
        right: isMyMessage ? 8 : 48,
        top: 4,
        bottom: 4,
      ),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage && showAvatar) ...[
            const SizedBox(width: 8),
          ] else if (!isMyMessage) ...[
            const SizedBox(width: 40),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMyMessage && showAvatar)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      message.sender.nickname,
                      style: ShadTheme.of(context).textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isMyMessage
                          ? context.colorScheme.primary
                          : context.colorScheme.muted,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMyMessage ? 16 : 4),
                        bottomRight: Radius.circular(isMyMessage ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.type == 'file' &&
                            message.file_url != null) ...[
                          if (_isImage(message.file_type ?? ''))
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                message.file_url!,
                                width: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildFileAttachment(
                                      context, isMyMessage);
                                },
                              ),
                            )
                          else
                            _buildFileAttachment(context, isMyMessage),
                          if (message.message.isNotEmpty)
                            const SizedBox(height: 8),
                        ],
                        if (message.message.isNotEmpty)
                          Text(
                            message.message,
                            style: TextStyle(
                              color: isMyMessage
                                  ? context.colorScheme.primaryForeground
                                  : context.colorScheme.foreground,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message.sending_status == 'pending')
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: context.colorScheme.mutedForeground,
                        )
                      else if (message.sending_status == 'failed')
                        Icon(
                          Icons.error_outline,
                          size: 12,
                          color: context.colorScheme.destructive,
                        ),
                      if (message.sending_status != 'none')
                        const SizedBox(width: 4),
                      Text(
                        _formatTime(time),
                        style: ShadTheme.of(context).textTheme.small.copyWith(
                              fontSize: 11,
                              color: context.colorScheme.mutedForeground,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileAttachment(BuildContext context, bool isMyMessage) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMyMessage
            ? context.colorScheme.primary.withOpacity(0.8)
            : context.colorScheme.muted.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFileIcon(message.file_type ?? ''),
            size: 20,
            color: isMyMessage
                ? context.colorScheme.primaryForeground
                : context.colorScheme.foreground,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.file_name ?? 'File',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isMyMessage
                        ? context.colorScheme.primaryForeground
                        : context.colorScheme.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (message.file_size != null)
                  Text(
                    _formatFileSize(message.file_size!),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMyMessage
                          ? context.colorScheme.primaryForeground
                              .withOpacity(0.8)
                          : context.colorScheme.foreground.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isImage(String fileType) {
    final imageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    return imageTypes.contains(fileType.toLowerCase());
  }

  IconData _getFileIcon(String fileType) {
    if (_isImage(fileType)) return Icons.image;
    if (fileType.contains('video')) return Icons.videocam;
    if (fileType.contains('audio')) return Icons.audiotrack;
    if (fileType.contains('pdf')) return Icons.picture_as_pdf;
    return Icons.attach_file;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(time)}';
    } else {
      return DateFormat('MM/dd HH:mm').format(time);
    }
  }
}
