import 'dart:async';

import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/features/ai/widgets/audio_player_widget.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/conversation.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:supabase_models/brick/repository.dart';

import '../widgets/message_bubble.dart';
import '../widgets/ai_input_field.dart';
import '../widgets/conversation_list.dart';
import '../theme/ai_theme.dart';
import '../widgets/welcome_view.dart';
import '../providers/whatsapp_message_provider.dart';
import '../providers/conversation_provider.dart';
import 'package:flipper_services/whatsapp_service.dart';

/// Main screen for the AI feature with a modern, polished UI.
class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  // List<Conversation> _conversations = []; // Removed
  String _currentConversationId = '';
  List<Message> _messages = [];
  bool _isLoading = false;
  StreamSubscription<List<Message>>? _subscription;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    // Initialize WhatsApp message sync by reading the provider
    // The provider uses keepAlive to maintain lifecycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(whatsappMessageSyncProvider);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    _scrollController.dispose();
    super.dispose();
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
      // State update handled by stream listener
    } catch (e) {
      if (mounted) _showError('Error deleting conversation: ${e.toString()}');
    }
  }

  void _subscribeToCurrentConversation() {
    _subscription?.cancel();
    _subscription = ProxyService.strategy
        .subscribeToMessages(_currentConversationId)
        .listen(
          (messages) {
            if (mounted) {
              setState(() {
                _messages = messages;
                // No need to update _conversations list as it's from provider now
              });
              _scrollToBottom();
            }
          },
          onError: (e) {
            if (mounted) {
              _showError('Error subscribing to messages: ${e.toString()}');
            }
          },
        );
  }

  Future<void> _sendMessage(String text, {String? conversationId}) async {
    final targetConversationId = conversationId ?? _currentConversationId;
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) throw Exception('Branch ID is required');

      // Check context: Is this a reply to a WhatsApp message?
      // We look at the last message in the conversation history (that isn't from the user)
      final repository = Repository();
      // Fetch specifically from DB to ensure accuracy
      final lastMessages = await repository.get<Message>(
        query: Query(
          where: [Where('conversationId').isExactly(targetConversationId)],
          orderBy: [OrderBy('timestamp', ascending: false)],
          limit: 10,
        ),
      );

      final lastMessage = lastMessages.firstWhere(
        (m) => m.messageSource == 'whatsapp',
        orElse: () => Message(
          text: '',
          phoneNumber: '',
          delivered: false,
          branchId: 0,
          messageSource: 'ai',
        ),
      );

      final isWhatsAppReply = lastMessage.messageSource == 'whatsapp';

      // Save user message to local database immediately for UI responsiveness
      // We'll update the message source if it's a WhatsApp reply
      await ProxyService.strategy.saveMessage(
        text: text,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'user',
        conversationId: targetConversationId,
        messageSource: isWhatsAppReply ? 'whatsapp' : 'ai',
      );

      _controller.clear();
      _scrollToBottom();

      // If the message is a file placeholder, we just save it and wait for a follow-up question.
      if (text.startsWith('[file](')) {
        setState(() => _isLoading = false);
        return; // Do not hit AI provider yet
      }

      if (isWhatsAppReply) {
        // Handle WhatsApp Reply
        await _handleWhatsAppReply(
          text,
          lastMessage,
          branchId,
          targetConversationId,
        );
        // Do NOT proceed to AI logic
        return;
      }

      // --- AI Logic (Only if NOT WhatsApp) ---

      // Prepare parts for the AI prompt
      String processedText = text;
      String? fileToAnalyzePath = _attachedFilePath;

      // Prepare the user's content for the history, including any attached files.
      final List<Part> userPartsForHistory = [Part.text(processedText)];
      if (fileToAnalyzePath != null) {
        try {
          final fileData = await fileToBase64(fileToAnalyzePath);
          userPartsForHistory.add(
            Part.inlineData(fileData['mime_type'], fileData['data']),
          );
        } catch (e) {
          _showError("Error processing attached file: ${e.toString()}");
          setState(() => _isLoading = false);
          return;
        }
      }
      final userContentForHistory = Content(
        role: "user",
        parts: userPartsForHistory,
      );

      // Clear attached file path after it's used for AI analysis for the current turn
      if (_attachedFilePath != null) {
        _attachedFilePath = null;
      }

      final aiResponseText = await ref
          .refresh(
            geminiBusinessAnalyticsProvider(
              branchId,
              processedText,
              filePath:
                  fileToAnalyzePath, // Provider still needs the path for the current call
              history: _conversationHistory, // Pass conversation history
            ).future,
          )
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
        conversationId: targetConversationId,
        aiResponse: aiResponseText,
        aiContext: text,
        messageSource: 'ai',
      );

      // Clean the response for conversation history to avoid confusing the AI.
      final cleanedForHistory = aiResponseText.replaceAll(
        RegExp(
          r'\{\{VISUALIZATION_DATA\}\}.*?\{\{/VISUALIZATION_DATA\}\}',
          dotAll: true,
        ),
        '',
      );

      // Update conversation history with the user's prompt and the cleaned AI response.
      _conversationHistory.add(userContentForHistory);
      _conversationHistory.add(
        Content(role: "assistant", parts: [Part.text(cleanedForHistory)]),
      );

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
          conversationId: targetConversationId,
          messageSource: 'ai',
        );

        // Also add the summary to the conversation history for complete context.
        _conversationHistory.add(
          Content(role: "assistant", parts: [Part.text(summaryText)]),
        );
      }

      _scrollToBottom();
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleWhatsAppReply(
    String text,
    Message lastMessage,
    int branchId,
    String conversationId,
  ) async {
    try {
      // 1. Get Business Configuration for WhatsApp
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) throw Exception('Business ID not found');

      final business = await ProxyService.strategy.getBusiness(
        businessId: businessId,
      );
      if (business == null) throw Exception('Business not found');

      final phoneNumberId = business.getWhatsAppPhoneNumberId();
      if (phoneNumberId == null) {
        throw Exception('WhatsApp not configured for this business');
      }

      // 2. Validate and sanitize recipient phone number
      String? recipientPhone = lastMessage.phoneNumber;

      if (recipientPhone.trim().isEmpty) {
        _showError('Recipient phone number is missing');
        return; // Exit early without calling the service
      }

      // Remove whitespace and non-digit characters
      recipientPhone = recipientPhone.replaceAll(RegExp(r'[^\d+]'), '');

      // Validate format (E.164 format: + followed by 7-14 digits, or just 7-14 digits)
      if (!RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(recipientPhone)) {
        _showError(
          'Invalid phone number format. Please use E.164 format (e.g., +1234567890).',
        );
        return; // Exit early without calling the service
      }

      // Ensure the phone number is in E.164 format (with + prefix)
      if (!recipientPhone.startsWith('+')) {
        recipientPhone = '+$recipientPhone';
      }

      // 3. Instantiate WhatsApp Service
      final whatsAppService = WhatsAppService();

      // 4. Send Message
      await whatsAppService.sendWhatsAppMessage(
        phoneNumberId: phoneNumberId,
        recipientPhone:
            recipientPhone, // The validated and sanitized phone number
        messageBody: text,
        replyToMessageId: lastMessage
            .whatsappMessageId, // Context: replying to specific message
      );

      // Update the message to mark it as delivered after successful WhatsApp send
      try {
        final repository = Repository();
        final messages = await repository.get<Message>(
          query: Query(
            where: [
              Where('conversationId').isExactly(conversationId),
              Where('role').isExactly('user'),
              Where('text').isExactly(text), // Match the text that was sent
            ],
            orderBy: [OrderBy('timestamp', ascending: false)],
            limit: 1,
          ),
        );

        if (messages.isNotEmpty) {
          final latestUserMessage = messages.first;
          // Update the message to mark it as delivered by creating a new instance
          final updatedMessage = Message(
            id: latestUserMessage.id,
            text: latestUserMessage.text,
            phoneNumber: latestUserMessage.phoneNumber,
            delivered: true, // Mark as delivered after successful WhatsApp send
            branchId: latestUserMessage.branchId,
            role: latestUserMessage.role,
            timestamp: latestUserMessage.timestamp,
            conversationId: latestUserMessage.conversationId,
            aiResponse: latestUserMessage.aiResponse,
            aiContext: latestUserMessage.aiContext,
            messageType: latestUserMessage.messageType,
            messageSource: latestUserMessage.messageSource,
            whatsappMessageId: latestUserMessage.whatsappMessageId,
            whatsappPhoneNumberId: latestUserMessage.whatsappPhoneNumberId,
            contactName: latestUserMessage.contactName,
            waId: latestUserMessage.waId,
            replyToMessageId: latestUserMessage.replyToMessageId,
          );

          await repository.upsert<Message>(updatedMessage);
        }
      } catch (updateError) {
        // If update fails, just log the error and continue
        print(
          'Failed to update message status after successful WhatsApp send: $updateError',
        );
      }
    } catch (e) {
      // If sending fails, update the message status to reflect the failure
      // Find the most recently saved user message in this conversation and mark it as not delivered
      try {
        final repository = Repository();
        final messages = await repository.get<Message>(
          query: Query(
            where: [
              Where('conversationId').isExactly(conversationId),
              Where('role').isExactly('user'),
              Where('text').isExactly(text), // Match the text that was sent
            ],
            orderBy: [OrderBy('timestamp', ascending: false)],
            limit: 1,
          ),
        );

        if (messages.isNotEmpty) {
          final latestUserMessage = messages.first;
          // Update the message by creating a new one with same data but mark as not delivered
          final updatedMessage = Message(
            id: latestUserMessage.id,
            text: latestUserMessage.text,
            phoneNumber: latestUserMessage.phoneNumber,
            delivered:
                false, // Mark as not delivered due to WhatsApp API failure
            branchId: latestUserMessage.branchId,
            role: latestUserMessage.role,
            timestamp: latestUserMessage.timestamp,
            conversationId: latestUserMessage.conversationId,
            aiResponse: latestUserMessage.aiResponse,
            aiContext: latestUserMessage.aiContext,
            messageType: latestUserMessage.messageType,
            messageSource: latestUserMessage.messageSource,
            whatsappMessageId: latestUserMessage.whatsappMessageId,
            whatsappPhoneNumberId: latestUserMessage.whatsappPhoneNumberId,
            contactName: latestUserMessage.contactName,
            waId: latestUserMessage.waId,
            replyToMessageId: latestUserMessage.replyToMessageId,
          );

          await repository.upsert<Message>(updatedMessage);
        }
      } catch (updateError) {
        // If update fails, just log the error and continue
        print(
          'Failed to update message status after WhatsApp send failure: $updateError',
        );
      }

      _showError('Failed to send WhatsApp message: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
    final conversationsAsync = ref.watch(conversationProvider);

    // Handle initial selection if needed
    ref.listen(conversationProvider, (previous, next) {
      next.whenData((conversations) {
        if (conversations.isNotEmpty && _currentConversationId.isEmpty) {
          setState(() {
            _currentConversationId = conversations.first.id;
            _messages = conversations.first.messages ?? [];
          });
          _subscribeToCurrentConversation();
        } else if (conversations.isNotEmpty &&
            !conversations.any((c) => c.id == _currentConversationId)) {
          // If current selected is gone (deleted), select first
          setState(() {
            _currentConversationId = conversations.first.id;
            _messages = conversations.first.messages ?? [];
          });
          _subscribeToCurrentConversation();
        } else if (conversations.isEmpty && _currentConversationId.isNotEmpty) {
          // If all deleted
          setState(() {
            _currentConversationId = '';
            _messages = [];
          });
          _startNewConversation();
        }
      });
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AiTheme.backgroundColor,
          appBar: isMobile ? _buildMobileAppBar() : null,
          drawer: isMobile
              ? _buildDrawer(conversationsAsync.value ?? [])
              : null,
          body: isMobile
              ? _buildMobileLayout()
              : _buildDesktopLayout(conversationsAsync.value ?? []),
        );
      },
    );
  }

  AppBar _buildMobileAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AiTheme.secondaryColor),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: const Text(
        'AI Assistant',
        style: TextStyle(color: AiTheme.textColor),
      ),
      backgroundColor: AiTheme.surfaceColor,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.1),
    );
  }

  Widget _buildDrawer(List<Conversation> conversations) {
    return Drawer(
      child: ConversationList(
        conversations: conversations,
        currentConversationId: _currentConversationId,
        onConversationSelected: (id) {
          setState(() {
            _currentConversationId = id;
            try {
              _messages =
                  conversations.firstWhere((c) => c.id == id).messages ?? [];
            } catch (e) {
              _messages = [];
            }
            // Clear history on conversation selection
            _conversationHistory = [];
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
          onSend: (text) =>
              _sendMessage(text, conversationId: _currentConversationId),
          isLoading: _isLoading,
          onAttachFile: _handleAttachedFile,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(List<Conversation> conversations) {
    return Row(
      children: [
        ConversationList(
          conversations: conversations,
          currentConversationId: _currentConversationId,
          onConversationSelected: (id) {
            setState(() {
              _currentConversationId = id;
              try {
                _messages =
                    conversations.firstWhere((c) => c.id == id).messages ?? [];
              } catch (e) {
                _messages = [];
              }
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
                onSend: (text) =>
                    _sendMessage(text, conversationId: _currentConversationId),
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
      return WelcomeView(
        onSend: (text) =>
            _sendMessage(text, conversationId: _currentConversationId),
      );
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

        return MessageBubble(message: message, isUser: isUser);
      },
    );
  }
}
