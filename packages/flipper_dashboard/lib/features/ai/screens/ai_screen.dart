import 'dart:async';

import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/business_analytic.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:flipper_models/providers/ai_provider.dart';

import '../widgets/message_bubble.dart';
import '../widgets/ai_input_field.dart';
import '../widgets/conversation_list.dart';
import '../theme/ai_theme.dart';
import '../widgets/welcome_view.dart';

/// Main screen for the AI feature with a modern, polished UI.
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
  StreamSubscription<List<BusinessAnalytic>>? _analyticsSubscription;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadAllConversations();
    _subscribeToAnalytics();
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    _analyticsSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _subscribeToAnalytics() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      talker
          .warning('Branch ID is null, cannot subscribe to analytics stream.');
      return;
    }
    ref.listen(streamedBusinessAnalyticsProvider(branchId), (previous, next) {
      next.when(
        data: (data) {
          talker.info('Received new analytics data: ${data.length} items');
          // Process the data further, e.g., update a state variable
          // for real-time insights or charts.
        },
        loading: () {
          talker.info('Analytics data is loading...');
          // Optionally handle loading state (e.g., show a loading indicator).
        },
        error: (error, stackTrace) {
          talker.error('Error receiving analytics data: $error');
          // Handle error state (e.g., show an error message).
        },
      );
    });
  }

  Future<void> _loadAllConversations() async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) throw Exception('Branch ID is required');

      final conversations = await ProxyService.strategy.getConversations(
        branchId: branchId,
        limit: 100,
      );

      if (!mounted) return;

      if (conversations.isEmpty) {
        _startNewConversation();
        return;
      }

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
        });
        _subscribeToCurrentConversation();
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) _showError('Error loading conversations: ${e.toString()}');
    }
  }

  Future<void> _startNewConversation() async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) throw Exception('Branch ID is required');

      final conversation = await ProxyService.strategy.createConversation(
        title: 'New Conversation',
        branchId: branchId,
      );

      if (mounted) {
        setState(() {
          _currentConversationId = conversation.id;
          _conversations[conversation.id] = [];
          _messages = [];
        });
        _subscribeToCurrentConversation();
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) _showError('Error creating conversation: ${e.toString()}');
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
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) _showError('Error deleting conversation: ${e.toString()}');
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
        _scrollToBottom(); // Scroll to bottom when new messages arrive
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) throw Exception('Branch ID is required');

      await ProxyService.strategy.saveMessage(
        text: text,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'user',
        conversationId: _currentConversationId,
      );

      _controller.clear();
      _scrollToBottom();

      final aiResponseText = await ref
          .refresh(
        geminiBusinessAnalyticsProvider(branchId, text).future,
      )
          .catchError((e) {
        if (e.toString().contains('RESOURCE_EXHAUSTED')) {
          return 'I\'m having trouble analyzing your data right now. Please try again in a moment.';
        }
        throw e; // Re-throw other errors
      });

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
      if (mounted) setState(() => _isLoading = false);
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
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AiTheme.backgroundColor,
        appBar: isMobile ? _buildMobileAppBar() : null,
        drawer: isMobile ? _buildDrawer() : null,
        body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      );
    });
  }

  AppBar _buildMobileAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AiTheme.secondaryColor),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: const Text('AI Assistant',
          style: TextStyle(color: AiTheme.textColor)),
      backgroundColor: AiTheme.surfaceColor,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.1),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ConversationList(
        conversations: _conversations,
        currentConversationId: _currentConversationId,
        onConversationSelected: (id) {
          setState(() {
            _currentConversationId = id;
            _messages = _conversations[id] ?? [];
          });
          _subscribeToCurrentConversation();
          _scrollToBottom(); // Scroll to bottom after selecting conversation
          Navigator.of(context).pop();
        },
        onDeleteConversation: (id) => _deleteCurrentConversation(id),
        onNewConversation: () {
          _startNewConversation();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(child: _buildMessageList()),
        AiInputField(
          controller: _controller,
          onSend: _sendMessage,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        ConversationList(
          conversations: _conversations,
          currentConversationId: _currentConversationId,
          onConversationSelected: (id) {
            setState(() {
              _currentConversationId = id;
              _messages = _conversations[id] ?? [];
            });
            _subscribeToCurrentConversation();
            _scrollToBottom(); // Scroll to bottom after selecting conversation
          },
          onDeleteConversation: (id) => _deleteCurrentConversation(id),
          onNewConversation: _startNewConversation,
        ),
        const VerticalDivider(width: 1, color: AiTheme.borderColor),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _buildMessageList()),
              AiInputField(
                controller: _controller,
                onSend: _sendMessage,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return WelcomeView(onSend: _sendMessage);
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return MessageBubble(
          message: message,
          isUser: message.role == 'user',
        );
      },
    );
  }
}
