import 'dart:async';

import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
// import 'package:flipper_dashboard/features/ai/widgets/audio_player_widget.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/conversation.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:supabase_models/brick/repository.dart';

import 'package:flipper_models/models/ai_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/ai_input_field.dart';
import '../widgets/conversation_list.dart';
import '../theme/ai_theme.dart';
import '../widgets/welcome_view.dart';
import '../providers/whatsapp_message_provider.dart';
import '../providers/conversation_provider.dart';
import 'package:flipper_services/whatsapp_service.dart';
import '../widgets/excel_analysis_modal.dart';

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
  AIModel? _selectedModel; // State for selected AI model

  void _handleAttachedFile(String filePath) {
    // Check if it's an Excel file
    if (filePath.endsWith('.xlsx') || filePath.endsWith('.xls')) {
      // Launch the dedicated Excel analysis modal
      ExcelAnalysisModal.show(context, filePath);
      return;
    }

    // For other files, use the standard attachment flow
    setState(() {
      _attachedFilePath = filePath;
    });
    // Send a placeholder message to display the file in the chat bubble
    _sendMessage('[file]($filePath)');
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
    String targetConversationId = conversationId ?? _currentConversationId;
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) throw Exception('Branch ID is required');

      // If no conversation exists, create a new one
      if (targetConversationId.isEmpty) {
        final conversation = await ProxyService.strategy.createConversation(
          title: text.length > 30 ? '${text.substring(0, 30)}...' : text,
          branchId: branchId,
        );
        targetConversationId = conversation.id;

        if (mounted) {
          setState(() {
            _currentConversationId = targetConversationId;
            _messages = [];
            _conversationHistory = []; // Clear history on new conversation
          });
          _subscribeToCurrentConversation();
        }
      }

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
          branchId: "0",
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
              aiModel: _selectedModel, // Pass the selected model
            ).future,
          )
          .catchError((e) {
            if (e.toString().contains('RESOURCE_EXHAUSTED')) {
              return 'I\'m having trouble analyzing your data right now. Please try again in a moment.';
            } else if (e.toString().contains('Operation cancelled')) {
              return 'The operation was cancelled. Please try again.';
            } else if (e.toString().contains('Upgrade Required')) {
              // Extract the model name from the error message for a more personalized message
              final modelMatch = RegExp(
                r'The selected model \(([^)]+)\)',
              ).firstMatch(e.toString());
              final modelName = modelMatch?.group(1) ?? 'this AI model';
              return "To use $modelName, you need either a Pro plan subscription or sufficient credits. You can upgrade your subscription or purchase credits to access this feature.";
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
    String branchId,
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
    final availableModelsAsync = ref.watch(availableModelsProvider);

    // Initialize selected model if not set
    if (_selectedModel == null &&
        availableModelsAsync.value != null &&
        availableModelsAsync.value!.isNotEmpty) {
      // Prefer default model, otherwise first active
      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedModel = availableModelsAsync.value!.firstWhere(
                (m) => m.isDefault,
                orElse: () => availableModelsAsync.value!.first,
              );
            });
          }
        });
      } catch (e) {
        // Handle case where no models might be available momentarily
      }
    }

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
          appBar: isMobile
              ? _buildMobileAppBar(availableModelsAsync.value ?? [])
              : null,
          drawer: isMobile
              ? _buildDrawer(conversationsAsync.value ?? [])
              : null,
          body: isMobile
              ? _buildMobileLayout()
              : _buildDesktopLayout(
                  conversationsAsync.value ?? [],
                  availableModelsAsync.value ?? [],
                ),
        );
      },
    );
  }

  AppBar _buildMobileAppBar(List<AIModel> availableModels) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AiTheme.secondaryColor),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: const Text(
        'AI Assistant',
        style: TextStyle(color: AiTheme.textColor),
      ),
      actions: [
        if (availableModels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<AIModel>(
              initialValue: _selectedModel,
              icon: const Icon(Icons.psychology, color: AiTheme.primaryColor),
              tooltip: 'Select AI Model',
              onSelected: (AIModel model) {
                setState(() {
                  _selectedModel = model;
                });
              },
              itemBuilder: (BuildContext context) {
                return availableModels.map((AIModel model) {
                  return PopupMenuItem<AIModel>(
                    value: model,
                    child: Row(
                      children: [
                        if (model.id == _selectedModel?.id)
                          const Icon(
                            Icons.check,
                            color: AiTheme.primaryColor,
                            size: 18,
                          ),
                        if (model.id == _selectedModel?.id)
                          const SizedBox(width: 8),
                        Text(
                          model.name,
                          style: TextStyle(
                            fontWeight: model.id == _selectedModel?.id
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (model.isPaidOnly) const SizedBox(width: 8),
                        if (model.isPaidOnly)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.amber),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
      ],
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

  Widget _buildDesktopLayout(
    List<Conversation> conversations,
    List<AIModel> availableModels,
  ) {
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
              // Desktop Header with Model Selector
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: AiTheme.surfaceColor,
                  border: Border(
                    bottom: BorderSide(color: AiTheme.borderColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AiTheme.textColor,
                      ),
                    ),
                    if (availableModels.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AiTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AiTheme.borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<AIModel>(
                            value: _selectedModel,
                            hint: const Text('Select Model'),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: AiTheme.secondaryColor,
                            ),
                            onChanged: (AIModel? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedModel = newValue;
                                });
                              }
                            },
                            items: availableModels
                                .map<DropdownMenuItem<AIModel>>((
                                  AIModel model,
                                ) {
                                  return DropdownMenuItem<AIModel>(
                                    value: model,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.psychology,
                                          size: 16,
                                          color: AiTheme.primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          model.name,
                                          style: TextStyle(
                                            color: AiTheme.textColor,
                                            fontWeight:
                                                model.id == _selectedModel?.id
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        if (model.isPaidOnly) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withValues(
                                                alpha: 0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Colors.amber,
                                              ),
                                            ),
                                            child: const Text(
                                              'PRO',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
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
          //TODO: resume this when just_audio is updated to support 16 page size
          // final path = message.text.substring(8, message.text.length - 1);
          // return Align(
          //   alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 4.0),
          //     child: AudioPlayerWidget(audioPath: path),
          //   ),
          // );
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
