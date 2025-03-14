import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_models/providers/ai_provider.dart';

import '../widgets/message_bubble.dart';
import '../widgets/ai_input_field.dart';
import '../widgets/conversation_list.dart';
import '../theme/ai_theme.dart';

/// Main screen for the AI feature that handles:
/// - Conversation management via ProxyService.strategy
/// - AI responses via geminiBusinessAnalyticsProvider
/// - Message history and UI state
class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  bool _showSidebar = true;
  String _currentConversationId = const Uuid().v4();
  Map<String, List<Message>> _conversations = {};

  /// Loads all conversations from ProxyService.strategy and updates the UI state.
  Future<void> _loadAllConversations() async {
    try {
      final allMessages = await ProxyService.strategy.getConversationHistory(
        conversationId: '',
        limit: 100,
      );

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
        _messages.clear();
        _messages.addAll(_conversations[_currentConversationId] ?? []);
      });
    } catch (e) {
      _showError('Error loading conversations: ${e.toString()}');
    }
  }

  /// Subscribes to the current conversation and updates the UI state when new messages are received.
  void _subscribeToCurrentConversation() {
    ProxyService.strategy
        .conversationStream(conversationId: _currentConversationId)
        .listen((messages) {
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        _conversations[_currentConversationId] = messages;
      });
    });
  }

  /// Sends a message to the AI and updates the UI state with the response.
  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get branch ID first to fail fast
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw Exception('Branch ID is required for AI responses');
      }

      // Save user message
      await ProxyService.strategy.saveMessage(
        text: text,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'user',
        conversationId: _currentConversationId,
      );

      _controller.clear();

      // Get AI response using business analytics
      final aiResponse = await ref.read(
        geminiBusinessAnalyticsProvider(branchId, text).future,
      );

      // Save AI response
      await ProxyService.strategy.saveMessage(
        text: aiResponse,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'assistant',
        conversationId: _currentConversationId,
        aiResponse: aiResponse,
        aiContext: text,
      );

      _scrollToBottom();
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Scrolls to the bottom of the conversation list.
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

  /// Starts a new conversation and updates the UI state.
  void _startNewConversation() {
    setState(() {
      _currentConversationId = const Uuid().v4();
      _messages.clear();
      _conversations[_currentConversationId] = [];
    });
    _subscribeToCurrentConversation();
  }

  /// Deletes a conversation and updates the UI state.
  Future<void> _deleteConversation(String conversationId) async {
    await ProxyService.strategy
        .deleteConversation(conversationId: conversationId);
    setState(() {
      _conversations.remove(conversationId);
      if (conversationId == _currentConversationId) {
        _startNewConversation();
      }
    });
  }

  /// Shows an error message to the user.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AiTheme.backgroundColor,
      body: Row(
        children: [
          if (_showSidebar)
            Container(
              width: 300,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: ConversationList(
                conversations: _conversations,
                currentConversationId: _currentConversationId,
                onConversationSelected: (id) {
                  setState(() {
                    _currentConversationId = id;
                    _messages.clear();
                    _messages.addAll(_conversations[id] ?? []);
                  });
                  _subscribeToCurrentConversation();
                },
                onDeleteConversation: _deleteConversation,
                onNewConversation: _startNewConversation,
              ),
            ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
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
          IconButton(
            icon: Icon(
              _showSidebar ? Icons.menu_open : Icons.menu,
              color: AiTheme.secondaryColor,
            ),
            onPressed: () {
              setState(() {
                _showSidebar = !_showSidebar;
              });
            },
          ),
          const Text(
            'AI Assistant',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
