import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import '../theme/ai_theme.dart';

/// Widget that displays a chat message bubble with:
/// - Different styles for user and AI messages
/// - Avatar icons for both participants
/// - Support for text formatting and layout
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(Icons.smart_toy),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? AiTheme.primaryColor : AiTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: !isUser ? Border.all(color: Colors.grey[200]!) : null,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(Icons.person),
        ],
      ),
    );
  }

  Widget _buildAvatar(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AiTheme.inputBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: AiTheme.secondaryColor),
    );
  }
}
