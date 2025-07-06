import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/message.model.dart';
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
  Map<String, List<Message>> _conversations = {};
  String _currentConversationId = '';
  List<Message> _messages = [];
  bool _isLoading = false;
  StreamSubscription<List<Message>>? _subscription;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAllConversations();
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAllConversations() async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw Exception('Branch ID is required');
      }

      final conversations = await ProxyService.strategy.getConversations(
        branchId: branchId,
        limit: 100,
      );

      if (!mounted) return;

      if (conversations.isEmpty) {
        _startNewConversation();
        return;
      }

      // Load messages for each conversation
      final groupedMessages = <String, List<Message>>{};
      for (var conversation in conversations) {
        final messages = await ProxyService.strategy.getMessagesForConversation(
          conversationId: conversation.id,
          limit: 100,
        );
        groupedMessages[conversation.id] = messages;
      }

      if (mounted) {
        setState(() {
          _conversations = groupedMessages;
          _currentConversationId = conversations.first.id;
          _messages = _conversations[_currentConversationId] ?? [];
          _subscribeToCurrentConversation();
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Error loading conversations: ${e.toString()}');
      }
    }
  }

  Future<void> _startNewConversation() async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw Exception('Branch ID is required');
      }

      final conversation = await ProxyService.strategy.createConversation(
        title: 'New Conversation',
        branchId: branchId,
      );

      if (mounted) {
        setState(() {
          _currentConversationId = conversation.id;
          _conversations[conversation.id] = [];
          _messages = [];
          _subscribeToCurrentConversation();
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Error creating conversation: ${e.toString()}');
      }
    }
  }

  Future<void> _deleteCurrentConversation(String conversationId) async {
    try {
      await ProxyService.strategy.deleteConversation(conversationId);

      if (mounted) {
        setState(() {
          _conversations.remove(conversationId);
          if (_conversations.isNotEmpty) {
            _currentConversationId = _conversations.keys.first;
            _messages = _conversations[_currentConversationId] ?? [];
          } else {
            _startNewConversation();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Error deleting conversation: ${e.toString()}');
      }
    }
  }

  void _subscribeToCurrentConversation() {
    _subscription?.cancel();
    _subscription = ProxyService.strategy
        .subscribeToMessages(_currentConversationId)
        .listen((messages) {
      if (mounted) {
        setState(() {
          _messages = messages;
          _conversations[_currentConversationId] = messages;
        });
      }
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
        throw Exception('Branch ID is required');
      }

      // Create user message
      await ProxyService.strategy.saveMessage(
        text: text,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'user',
        conversationId: _currentConversationId,
      );

      _controller.clear();
      _scrollToBottom();

      // Get AI response
      final aiResponseText = await ref.read(
        geminiBusinessAnalyticsProvider(branchId, text).future,
      );

      // Save AI response
      await ProxyService.strategy.saveMessage(
        text: aiResponseText,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'assistant',
        conversationId: _currentConversationId,
        aiResponse: aiResponseText,
        aiContext: text,
      );

      _scrollToBottom();
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Create a scaffold key to access the scaffold from anywhere
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AiTheme.backgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('AI Assistant'),
            elevation: 0,
            backgroundColor: AiTheme.surfaceColor,
            foregroundColor: Colors.black,
          ),
          drawer: isMobile ? _buildDrawer() : null,
          body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ),
      );
    });
  }

  // Drawer for mobile view
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: AiTheme.surfaceColor,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AiTheme.primaryColor.withOpacity(0.1),
              ),
              child: const Center(
                child: Text(
                  'Conversations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ConversationList(
                conversations: _conversations,
                currentConversationId: _currentConversationId,
                onConversationSelected: (id) {
                  setState(() {
                    _currentConversationId = id;
                    _messages = _conversations[id] ?? [];
                  });
                  _subscribeToCurrentConversation();
                  // Close drawer after selection on mobile
                  Navigator.of(context).pop();
                },
                onDeleteConversation: (id) => _deleteCurrentConversation(id),
                onNewConversation: () {
                  _startNewConversation();
                  // Close drawer after creating new conversation
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
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
                        horizontal: 16, vertical: 20),
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
    );
  }

  // Desktop layout
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar - Conversation List
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 300, // Width for desktop
          curve: Curves.easeInOut,
          child: ClipRect(
            child: Container(
              decoration: BoxDecoration(
                color: AiTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(5, 0),
                  ),
                ],
              ),
              child: ConversationList(
                conversations: _conversations,
                currentConversationId: _currentConversationId,
                onConversationSelected: (id) {
                  setState(() {
                    _currentConversationId = id;
                    _messages = _conversations[id] ?? [];
                  });
                  _subscribeToCurrentConversation();
                },
                onDeleteConversation: (id) => _deleteCurrentConversation(id),
                onNewConversation: _startNewConversation,
              ),
            ),
          ),
        ),

        // Main Content - Messages and Input
        Expanded(
          child: Column(
            children: [
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
                              horizontal: 16, vertical: 20),
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
