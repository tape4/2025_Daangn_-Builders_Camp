import 'package:flutter/material.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSendText;
  final VoidCallback? onAttachFile;
  final VoidCallback? onTypingStart;
  final VoidCallback? onTypingEnd;
  final bool isSending;

  const MessageInput({
    Key? key,
    required this.onSendText,
    this.onAttachFile,
    this.onTypingStart,
    this.onTypingEnd,
    this.isSending = false,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (_isTyping) {
      widget.onTypingEnd?.call();
    }
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;

    if (hasText && !_isTyping) {
      _isTyping = true;
      widget.onTypingStart?.call();
    } else if (!hasText && _isTyping) {
      _isTyping = false;
      widget.onTypingEnd?.call();
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;

    widget.onSendText(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (widget.onAttachFile != null)
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: context.colorScheme.mutedForeground,
                  ),
                  onPressed: widget.isSending ? null : widget.onAttachFile,
                ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 120,
                  ),
                  child: ShadInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    placeholder: const Text('Type a message...'),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    enabled: !widget.isSending,
                    onSubmitted: (value) {
                      if (!_isShiftPressed()) {
                        _sendMessage();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, child) {
                  final hasText = value.text.trim().isNotEmpty;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      icon: widget.isSending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colorScheme.primary,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.send,
                              color: hasText
                                  ? context.colorScheme.primary
                                  : context.colorScheme.mutedForeground,
                            ),
                      onPressed:
                          hasText && !widget.isSending ? _sendMessage : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isShiftPressed() {
    // This is a simplified implementation
    // In a real app, you might want to track keyboard modifiers
    return false;
  }
}
