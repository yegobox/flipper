import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:intl/intl.dart'; // Import for date formatting

import '../theme/ai_theme.dart';

/// Widget that displays a chat message bubble.
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isUser;

  const MessageBubble({
    Key? key, // Add key
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 16), // Reduced vertical padding
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align avatars to the top
        children: [
          if (!isUser) _buildAvatar(Icons.smart_toy, theme),
          const SizedBox(width: 8),
          Expanded(
            // Use Expanded instead of Flexible
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start, // Align content
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10), // Adjusted padding
                  decoration: BoxDecoration(
                    color: isUser
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface, // Use theme colors
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser
                          ? const Radius.circular(16)
                          : const Radius.circular(2),
                      bottomRight: isUser
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
                    message.text ?? '', // Null-safe access
                    style: TextStyle(
                      color: isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatTimestamp(message.timestamp), // Format the timestamp
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
          if (isUser) _buildAvatar(Icons.person, theme),
        ],
      ),
    );
  }

  Widget _buildAvatar(IconData icon, ThemeData theme) {
    return Container(
      width: 36, // Fixed size
      height: 36,
      decoration: BoxDecoration(
        color: AiTheme.inputBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        // Center the icon
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

    return DateFormat('jm').format(timestamp); // Format as time only
  }
}
