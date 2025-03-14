import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:intl/intl.dart';

import '../theme/ai_theme.dart';

/// Widget that displays a chat message bubble.
class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isHovering = false;
  bool _showCopied = false;

  void _copyToClipboard() async {
    final text = widget.message.text;
    await Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _showCopied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isUser) _buildAvatar(Icons.smart_toy, theme),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: widget.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                MouseRegion(
                  onEnter: (_) => setState(() => _isHovering = true),
                  onExit: (_) => setState(() => _isHovering = false),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isUser
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: widget.isUser
                                ? const Radius.circular(16)
                                : const Radius.circular(2),
                            bottomRight: widget.isUser
                                ? const Radius.circular(2)
                                : const Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.message.text,
                          style: TextStyle(
                            color: widget.isUser
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (_isHovering)
                        Positioned(
                          top: 0,
                          right: widget.isUser ? null : 0,
                          left: widget.isUser ? 0 : null,
                          child: Material(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_showCopied)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Copied!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 20),
                                    color: Colors.grey[600],
                                    onPressed: _copyToClipboard,
                                    tooltip: 'Copy message',
                                    splashRadius: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatTimestamp(widget.message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (widget.isUser) _buildAvatar(Icons.person, theme),
        ],
      ),
    );
  }

  Widget _buildAvatar(IconData icon, ThemeData theme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AiTheme.inputBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: 20,
          color: AiTheme.secondaryColor,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('jm').format(timestamp);
  }
}
