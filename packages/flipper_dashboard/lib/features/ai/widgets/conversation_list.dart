import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import '../theme/ai_theme.dart';
import 'package:intl/intl.dart';

/// Widget that displays a list of AI conversations with a modern, clean design.
class ConversationList extends StatelessWidget {
  final Map<String, List<Message>> conversations;
  final String currentConversationId;
  final Function(String) onConversationSelected;
  final Function(String) onDeleteConversation;
  final VoidCallback onNewConversation;

  const ConversationList({
    super.key,
    required this.conversations,
    required this.currentConversationId,
    required this.onConversationSelected,
    required this.onDeleteConversation,
    required this.onNewConversation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: AiTheme.surfaceColor,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversationId = conversations.keys.elementAt(index);
                final messages = conversations[conversationId]!;
                final lastMessage = messages.isNotEmpty ? messages.first : null;

                return _buildConversationTile(
                  context: context,
                  conversationId: conversationId,
                  lastMessage: lastMessage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12), // Reduced padding
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AiTheme.borderColor, width: 1)),
      ),
      child: Row(
        children: [
          const Text(
            'Conversations',
            style: TextStyle(
              fontSize: 16, // Slightly smaller font
              fontWeight: FontWeight.w600,
              color: AiTheme.textColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AiTheme.primaryColor),
            onPressed: onNewConversation,
            tooltip: 'New Conversation',
            splashRadius: 16, // Smaller splash radius
            padding: EdgeInsets.zero, // Minimize padding
            constraints: const BoxConstraints(), // Remove default constraints
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile({
    required BuildContext context,
    required String conversationId,
    Message? lastMessage,
  }) {
    final isSelected = conversationId == currentConversationId;
    final title = lastMessage?.text.split('\n').first ?? 'New Conversation';
    final timestamp = lastMessage?.timestamp ?? DateTime.now();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onConversationSelected(conversationId),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2), // Reduced margin
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 8), // Reduced padding
          decoration: BoxDecoration(
            color: isSelected
                ? AiTheme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color:
                    isSelected ? AiTheme.primaryColor : AiTheme.secondaryColor,
                size: 18, // Slightly smaller icon
              ),
              const SizedBox(width: 8), // Reduced spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13, // Slightly smaller font
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: AiTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    Text(
                      _formatTimestamp(timestamp),
                      style: TextStyle(
                        fontSize: 11, // Slightly smaller font
                        color: AiTheme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    size: 18), // Smaller icon
                color: AiTheme.secondaryColor,
                onPressed: () => onDeleteConversation(conversationId),
                tooltip: 'Delete Conversation',
                splashRadius: 16, // Smaller splash radius
                padding: EdgeInsets.zero, // Minimize padding
                constraints:
                    const BoxConstraints(), // Remove default constraints
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
