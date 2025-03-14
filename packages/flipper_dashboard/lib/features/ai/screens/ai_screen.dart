import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:intl/intl.dart';

import '../widgets/message_bubble.dart';
import '../widgets/ai_input_field.dart';
import '../widgets/conversation_list.dart';
import '../theme/ai_theme.dart'; // Keep your theme for consistent styling

/// Main screen for the AI feature.
class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = false;
  bool _showSidebar = true;
  String _currentConversationId = const Uuid().v4();
  Map<String, List<Message>> _conversations = {};

  @override
  void initState() {
    super.initState();
    _loadAllConversations();
    _subscribeToCurrentConversation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAllConversations() async {
    try {
      final allMessages = await ProxyService.strategy
          .getConversationHistory(conversationId: '', limit: 100);

      final groupedMessages = <String, List<Message>>{};
      for (var msg in allMessages) {
        if (msg.conversationId != null) {
          if (!groupedMessages.containsKey(msg.conversationId)) {
            groupedMessages[msg.conversationId!] = [];
          }
          groupedMessages[msg.conversationId]!.add(msg);
        }
      }

      for (var messages in groupedMessages.values) {
        messages.sort((a, b) => (b.timestamp ?? DateTime.now())
            .compareTo(a.timestamp ?? DateTime.now()));
      }

      final sortedConversations =
          Map.fromEntries(groupedMessages.entries.toList()
            ..sort((a, b) {
              final aTime = a.value.first.timestamp ?? DateTime.now();
              final bTime = b.value.first.timestamp ?? DateTime.now();
              return bTime.compareTo(aTime);
            }));

      setState(() {
        _conversations = sortedConversations;
        _updateMessagesForCurrentConversation();
      });
    } catch (e) {
      _showError('Error loading conversations: ${e.toString()}');
    }
  }

  void _subscribeToCurrentConversation() {
    ProxyService.strategy
        .conversationStream(conversationId: _currentConversationId)
        .listen((messages) {
      messages.sort((a, b) => (a.timestamp ?? DateTime.now())
          .compareTo(b.timestamp ?? DateTime.now()));
      setState(() {
        _messages = messages;
        _conversations[_currentConversationId] = messages;
      });
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw Exception('Branch ID is required for AI responses');
      }

      final userMessage = Message(
        text: text,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'user',
        delivered: false,
        conversationId: _currentConversationId,
        timestamp: DateTime.now(),
      );
      await ProxyService.strategy.saveMessage(
        text: userMessage.text,
        phoneNumber: userMessage.phoneNumber,
        branchId: userMessage.branchId,
        role: userMessage.role ?? '',
        conversationId: userMessage.conversationId ?? '',
      );

      setState(() {
        _messages = [..._messages, userMessage];
      });

      _controller.clear();

      final aiResponseText = await ref.read(
        geminiBusinessAnalyticsProvider(branchId, text).future,
      );

      final aiMessage = Message(
        delivered: false,
        text: aiResponseText,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'assistant',
        conversationId: _currentConversationId,
        aiResponse: aiResponseText,
        aiContext: text,
        timestamp: DateTime.now(),
      );
      await ProxyService.strategy.saveMessage(
        text: aiMessage.text,
        phoneNumber: aiMessage.phoneNumber,
        branchId: aiMessage.branchId,
        role: aiMessage.role ?? '',
        conversationId: aiMessage.conversationId ?? '',
        aiResponse: aiMessage.aiResponse ?? '',
        aiContext: aiMessage.aiContext ?? '',
      );
      setState(() {
        _messages = [..._messages, aiMessage];
      });

      _scrollToBottom();
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewConversation() {
    final newConversationId = const Uuid().v4();
    setState(() {
      _currentConversationId = newConversationId;
      _messages.clear();
    });
    _subscribeToCurrentConversation();
  }

  Future<void> _deleteConversation(String conversationId) async {
    try {
      await ProxyService.strategy
          .deleteConversation(conversationId: conversationId);
      setState(() {
        _conversations.remove(conversationId);
        if (conversationId == _currentConversationId) {
          _startNewConversation();
        } else {
          _updateMessagesForCurrentConversation();
        }
      });
    } catch (e) {
      _showError('Error deleting conversation: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _updateMessagesForCurrentConversation() {
    setState(() {
      _messages = _conversations[_currentConversationId] ?? [];
      _messages.sort((a, b) => (a.timestamp ?? DateTime.now())
          .compareTo(b.timestamp ?? DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AiTheme.backgroundColor,
      body: Row(
        children: [
          // Sidebar - Conversation List
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _showSidebar ? 300 : 0, // Animate width
            curve: Curves.easeInOut,
            child: ClipRect(
              // Prevents overflow when animating
              child: Container(
                decoration: BoxDecoration(
                  color: AiTheme.surfaceColor, // Or a custom color
                  boxShadow: [
                    if (_showSidebar) // Only show shadow when visible
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(5, 0),
                      ),
                  ],
                ),
                child: _showSidebar
                    ? ConversationList(
                        conversations: _conversations,
                        currentConversationId: _currentConversationId,
                        onConversationSelected: (id) {
                          setState(() {
                            _currentConversationId = id;
                            _updateMessagesForCurrentConversation();
                          });
                          _subscribeToCurrentConversation();
                        },
                        onDeleteConversation: _deleteConversation,
                        onNewConversation: _startNewConversation,
                      )
                    : null, // Or an empty placeholder
              ),
            ),
          ),

          // Main Content - Messages and Input
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _messages.isEmpty && !_isLoading
                      ? Center(
                          child: Text(
                            "No messages yet. Start a conversation!",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            // Dismiss keyboard when tapping outside input
                            FocusScope.of(context).unfocus();
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20), // More spacing
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return MessageBubble(
                                message: message,
                                isUser: message.role == 'user',
                              );
                            },
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AiInputField(
                    controller: _controller,
                    onSend: _sendMessage,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the header of the conversation list.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AiTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          // Hamburger Icon
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: AlwaysStoppedAnimation(_showSidebar ? 1 : 0),
              color: AiTheme.secondaryColor,
            ),
            onPressed: () {
              setState(() {
                _showSidebar = !_showSidebar;
              });
            },
          ),
          const SizedBox(width: 8),
          Text(
            'AI Assistant',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600, // Semi-bold
            ),
          ),
          const Spacer(),
          if (_messages.isNotEmpty)
            Text(
              _formatTimestamp(_messages.last.timestamp),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 1) {
      return DateFormat('MMM d, yyyy').format(timestamp);
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
