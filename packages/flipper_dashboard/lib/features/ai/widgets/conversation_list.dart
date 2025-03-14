import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import '../theme/ai_theme.dart';

/// Widget that displays a list of AI conversations with their latest messages.
/// Supports selecting, deleting, and creating new conversations.
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
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversationId = conversations.keys.elementAt(index);
                final messages = conversations[conversationId]!;
                final lastMessage = messages.isNotEmpty ? messages.first : null;

                return _buildConversationTile(
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Conversations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onNewConversation,
            tooltip: 'New Conversation',
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile({
    required String conversationId,
    Message? lastMessage,
  }) {
    final isSelected = conversationId == currentConversationId;
    final title = lastMessage?.text.split('\n').first ?? 'New Conversation';
    final timestamp = lastMessage?.timestamp ?? DateTime.now();

    return ListTile(
      selected: isSelected,
      selectedTileColor: AiTheme.inputBackgroundColor,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatTimestamp(timestamp),
        style: const TextStyle(fontSize: 12),
      ),
      leading: const Icon(Icons.chat_bubble_outline),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => onDeleteConversation(conversationId),
        tooltip: 'Delete Conversation',
      ),
      onTap: () => onConversationSelected(conversationId),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
