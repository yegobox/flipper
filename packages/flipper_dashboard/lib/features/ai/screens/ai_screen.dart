import 'dart:async';

import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/features/ai/widgets/audio_player_widget.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/conversation.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';

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
  List<Conversation> _conversations = [];
  String _currentConversationId = '';
  List<Message> _messages = [];
  bool _isLoading = false;
  StreamSubscription<List<Message>>? _subscription;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _analyticsSubscribed = false;
  String? _attachedFilePath; // New variable to store attached file path
  List<Content> _conversationHistory =
      []; // To store conversation history for AI

  void _handleAttachedFile(String filePath) {
    setState(() {
      _attachedFilePath = filePath;
    });
    // Send a placeholder message to display the file in the chat bubble
    _sendMessage('[file](' + filePath + ')');
  }

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
      if (branchId == null) throw Exception('Branch ID is required');

      final conversations = await ProxyService.strategy.getConversations(
        branchId: branchId,
        limit: 100,
      );

      if (!mounted) return;

      if (conversations.isEmpty) {
        await _startNewConversation();
        return;
      }

      if (mounted) {
        setState(() {
          _conversations = conversations;
          _currentConversationId = conversations.first.id;
          _messages = conversations.first.messages ?? [];
          _conversationHistory = []; // Clear history on conversation load
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
          _conversations.insert(0, conversation);
          _currentConversationId = conversation.id;
          _messages = [];
          _conversationHistory = []; // Clear history on new conversation
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
          _conversations.removeWhere((c) => c.id == conversationId);
          if (_conversations.isNotEmpty) {
            _currentConversationId = _conversations.first.id;
            _messages = _conversations.first.messages ?? [];
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
          final index = _conversations
              .indexWhere((c) => c.id == _currentConversationId);
          if (index != -1) {
            _conversations[index].messages = messages;
          }
        });
        _scrollToBottom();
      }
    }, onError: (e) {
      if (mounted) {
        _showError('Error subscribing to messages: ${e.toString()}');
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) throw Exception('Branch ID is required');

      // Save user message to local database
      await ProxyService.strategy.saveMessage(
        text: text,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'user',
        conversationId: _currentConversationId,
      );

      _controller.clear();
      _scrollToBottom();

      // If the message is a file placeholder, we just save it and wait for a follow-up question.
      if (text.startsWith('[file](')) {
        setState(() => _isLoading = false);
        return; // Do not hit AI provider yet
      }

      // Prepare parts for the AI prompt
      String processedText = text;
      String? fileToAnalyzePath = _attachedFilePath;

      // Prepare the user's content for the history, including any attached files.
      final List<Part> userPartsForHistory = [Part.text(processedText)];
      if (fileToAnalyzePath != null) {
        try {
          final fileData = await fileToBase64(fileToAnalyzePath);
          userPartsForHistory
              .add(Part.inlineData(fileData['mime_type'], fileData['data']));
        } catch (e) {
          _showError("Error processing attached file: ${e.toString()}");
          setState(() => _isLoading = false);
          return;
        }
      }
      final userContentForHistory =
          Content(role: "user", parts: userPartsForHistory);

      // Clear attached file path after it's used for AI analysis for the current turn
      if (_attachedFilePath != null) {
        _attachedFilePath = null;
      }

      final aiResponseText = await ref
          .refresh(geminiBusinessAnalyticsProvider(
        branchId,
        processedText,
        filePath:
            fileToAnalyzePath, // Provider still needs the path for the current call
        history: _conversationHistory, // Pass conversation history
      ).future)
          .catchError((e) {
        if (e.toString().contains('RESOURCE_EXHAUSTED')) {
          return 'I\'m having trouble analyzing your data right now. Please try again in a moment.';
        }
        throw e;
      });

      // Always save the full, original AI response first.
      await ProxyService.strategy.saveMessage(
        text: aiResponseText,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'assistant',
        conversationId: _currentConversationId,
        aiResponse: aiResponseText,
        aiContext: text,
      );

      // Clean the response for conversation history to avoid confusing the AI.
      final cleanedForHistory = aiResponseText.replaceAll(
          RegExp(r'\{\{VISUALIZATION_DATA\}\}.*?\{\{/VISUALIZATION_DATA\}\}',
              dotAll: true),
          '');

      // Update conversation history with the user's prompt and the cleaned AI response.
      _conversationHistory.add(userContentForHistory);
      _conversationHistory.add(
          Content(role: "assistant", parts: [Part.text(cleanedForHistory)]));

      // If the response contained visualization data, generate and save a separate summary message.
      if (aiResponseText.contains('{{VISUALIZATION_DATA}}')) {
        final summaryPrompt =
            "Summarize the key insight from the following data visualization in one or two concise sentences. "
            "Focus on the most important takeaway for a business owner.\n\n"
            "$aiResponseText";

        final summaryText = await ref
            .refresh(geminiSummaryProvider(summaryPrompt).future)
            .onError((error, stackTrace) {
          talker.error("Failed to generate summary: $error");
          return "Error: Could not generate summary.";
        });

        await ProxyService.strategy.saveMessage(
          text: summaryText,
          phoneNumber: ProxyService.box.getUserPhone() ?? '',
          branchId: branchId,
          role: 'assistant',
          conversationId: _currentConversationId,
        );

        // Also add the summary to the conversation history for complete context.
        _conversationHistory
            .add(Content(role: "assistant", parts: [Part.text(summaryText)]));
      }

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
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null && !_analyticsSubscribed) {
      // Subscribe to analytics only once
      _analyticsSubscribed = true;
      ref.listen(
        streamedBusinessAnalyticsProvider(branchId),
        (previous, next) {
          next.when(
            data: (data) {
              talker.info('Received new analytics data: ${data.length} items');
            },
            loading: () {
              talker.info('Analytics data is loading...');
            },
            error: (error, stackTrace) {
              talker.error('Error receiving analytics data: $error');
            },
          );
        },
      );
    }

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
            _messages = _conversations.firstWhere((c) => c.id == id).messages ?? [];
            _conversationHistory =
                []; // Clear history on conversation selection
          });
          _subscribeToCurrentConversation();
          _scrollToBottom();
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
          onAttachFile: _handleAttachedFile,
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
              _messages = _conversations.firstWhere((c) => c.id == id).messages ?? [];
            });
            _subscribeToCurrentConversation();
            _scrollToBottom();
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
                onAttachFile: _handleAttachedFile,
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
        final isUser = message.role == 'user';

        if (message.text.startsWith('[voice](')) {
          final path = message.text.substring(8, message.text.length - 1);
          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: AudioPlayerWidget(audioPath: path),
            ),
          );
        } else if (message.text.startsWith('[file](')) {
          final path = message.text.substring(7, message.text.length - 1);
          final fileName = path.split('/').last;
          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Card(
                color: isUser ? AiTheme.userBubbleColor : AiTheme.aiBubbleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attached File:',
                        style: TextStyle(
                          color: isUser ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_file,
                            color: isUser ? Colors.white : Colors.black87,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              fileName,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return MessageBubble(
          message: message,
          isUser: isUser,
        );
      },
    );
  }
}
