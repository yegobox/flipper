import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/local_inference_engine.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/whatsapp_service.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:supabase_models/brick/models/message.model.dart';

import '../providers/conversation_provider.dart';
import '../providers/whatsapp_connection_provider.dart';
import '../providers/whatsapp_message_provider.dart';
import '../models/flo_models.dart';
import '../local/sales_rag_indexer.dart';
import '../services/flo_chat_service.dart';
import '../services/local_flo_service.dart';
import '../services/flo_local_briefing_service.dart';
import '../theme/flo_theme.dart';
import '../widgets/conversation_list.dart';
import '../widgets/data_source/data_source_list_screen.dart';
import '../widgets/excel_analysis_modal.dart';
import '../widgets/flo/flo_composer.dart';
import '../widgets/flo/flo_header.dart';
import '../widgets/flo/flo_model_selector.dart';
import '../widgets/flo/flo_home_view.dart';
import '../widgets/flo/flo_inbox_view.dart';
import '../widgets/flo/flo_thread_view.dart';
import '../widgets/whatsapp_connection_dialog.dart';

/// Flo — redesigned AI business assistant (Ask Flo + Messages).
class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key, this.onPurchaseCredits});

  final VoidCallback? onPurchaseCredits;

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> with WidgetsBindingObserver {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatService = FloChatService();
  final _localFloService = const LocalFloService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// AI mode: true = on-device (local), false = cloud (via data-connector).
  /// Defaults tier-aware (local for free users on capable devices, cloud
  /// otherwise) and is forced to cloud when on-device isn't supported.
  /// The user toggles it via the header selector.
  bool _useLocal = false;
  bool _modeInitialized = false;

  bool get _localAvailable => LocalInferenceRegistry.isAvailable;

  String _currentConversationId = '';
  List<Message> _messages = [];
  StreamSubscription<List<Message>>? _messageSub;
  StreamSubscription<FloDailyBriefing?>? _localBriefingSub;
  bool _isLoading = false;
  bool _menuOpen = false;
  FloPanelMode _mode = FloPanelMode.askFlo;
  List<String> _thinkingSteps = [];
  int? _thinkingActiveIndex;
  String? _attachedFilePath;
  String _shopName = 'your shop';
  FloDailyBriefing? _briefing;
  FloDailyBriefing? _remoteBriefing;
  bool _briefingLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(whatsappMessageSyncProvider);
      _loadShopName();
      _loadBriefing();
      _subscribeLocalBriefing();
      _loadDefaultModel();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadBriefing();
    }
  }

  void _subscribeLocalBriefing() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    _localBriefingSub?.cancel();
    _localBriefingSub =
        FloLocalBriefingService.watchToday(branchId).listen((local) {
      if (!mounted) return;
      setState(() {
        _briefing = FloLocalBriefingService.merge(_remoteBriefing, local);
        if (local != null) _briefingLoading = false;
      });
    });
  }

  Future<void> _loadBriefing() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      if (mounted) setState(() => _briefingLoading = false);
      return;
    }
    if (mounted) setState(() => _briefingLoading = true);
    try {
      final briefing =
          await _chatService.fetchDailyBriefing(branchId: branchId);
      if (mounted) {
        setState(() {
          _remoteBriefing = briefing;
          _briefing = FloLocalBriefingService.merge(briefing, _briefing);
          _briefingLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _briefingLoading = false);
    }
  }

  Future<void> _loadDefaultModel() async {
    if (_modeInitialized) return;
    // Tier-aware default: free users on a capable device get on-device; paid
    // users and unsupported devices get cloud. defaultAiModelProvider already
    // filters local models out where unsupported, so this falls back to cloud.
    var useLocal = false;
    try {
      final model = await ref.read(defaultAiModelProvider.future);
      useLocal = (model?.isLocal ?? false) && _localAvailable;
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _useLocal = useLocal;
      _modeInitialized = true;
    });
    _maybeIndexLocalRag();
  }

  /// Warm the on-device sales index when local mode is active (background,
  /// best-effort; no-op in cloud mode or on unsupported platforms).
  void _maybeIndexLocalRag() {
    if (!_useLocal || !_localAvailable) return;
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    unawaited(SalesRagIndexer.maybeIndex(branchId));
  }

  Future<void> _loadShopName() async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) return;
      final business =
          await ProxyService.strategy.getBusiness(businessId: businessId);
      final name = business?.name?.trim();
      if (name != null && name.isNotEmpty && mounted) {
        setState(() => _shopName = name);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageSub?.cancel();
    _localBriefingSub?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isMobile =>
      MediaQuery.sizeOf(context).width < FloTheme.mobileBreakpoint;

  bool get _showHome =>
      _mode == FloPanelMode.askFlo &&
      _messages.isEmpty &&
      !_isLoading &&
      _currentConversationId.isEmpty;

  Future<void> _newChat() async {
    await _messageSub?.cancel();
    _messageSub = null;
    if (!mounted) return;
    setState(() {
      _currentConversationId = '';
      _messages = [];
      _thinkingSteps = [];
      _thinkingActiveIndex = null;
      _isLoading = false;
      _menuOpen = false;
    });
    _controller.clear();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    _loadBriefing();
    _subscribeLocalBriefing();
  }

  Future<void> _ensureConversation() async {
    if (_currentConversationId.isNotEmpty) return;
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    final conversation = await ProxyService.strategy.createConversation(
      title: 'New Conversation',
      branchId: branchId,
      useCase: 'business',
    );
    if (!mounted) return;
    setState(() => _currentConversationId = conversation.id);
    _subscribeToMessages(conversation.id);
  }

  void _subscribeToMessages(String conversationId) {
    _messageSub?.cancel();
    _messageSub =
        ProxyService.strategy.subscribeToMessages(conversationId).listen((msgs) {
      if (!mounted) return;
      setState(() => _messages = msgs);
      _scrollToBottom();
    });
  }

  void _scrollToBottom({bool animated = true, int layoutFrames = 1}) {
    void scroll() {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(target);
      }
    }

    void afterFrames(int remaining) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (remaining <= 1) {
          scroll();
        } else {
          afterFrames(remaining - 1);
        }
      });
    }

    afterFrames(layoutFrames);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      _showError('Branch ID is required');
      return;
    }
    if (text.startsWith('[file](')) return;

    setState(() {
      _isLoading = true;
      _thinkingSteps = [];
      _thinkingActiveIndex = 0;
    });
    _scrollToBottom();

    try {
      if (_currentConversationId.isEmpty) {
        await _ensureConversation();
      }
      final conversationId = _currentConversationId;

      Message? lastWa;
      for (final m in _messages.reversed) {
        if (m.messageSource == 'whatsapp') {
          lastWa = m;
          break;
        }
      }
      final isWhatsAppReply = lastWa != null;

      await ProxyService.strategy.saveMessage(
        text: text,
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'user',
        conversationId: conversationId,
        messageSource: isWhatsAppReply ? 'whatsapp' : 'ai',
      );
      _controller.clear();

      if (isWhatsAppReply) {
        await _sendWhatsAppReply(text, lastWa, branchId, conversationId);
        return;
      }

      final history = _buildHistory();
      final deviceSales =
          await FloLocalBriefingService.todayDeviceSalesContext(branchId);
      FloChatResponse? response;
      final steps = <String>[];

      // Route to the on-device model in local mode; otherwise the cloud
      // data-connector. Both yield the same FloChatEvent shape.
      final useLocal = _useLocal && _localAvailable;
      final eventStream = useLocal
          ? _localFloService.streamChat(
              branchId: branchId,
              message: text,
              history: history,
              deviceSales: deviceSales,
              shopName: _shopName,
            )
          : _chatService.streamChat(
              branchId: branchId,
              message: text,
              history: history,
              mode: 'business',
              conversationId: conversationId,
              deviceSales: deviceSales,
              shopName: _shopName,
            );

      await for (final event in eventStream) {
        if (event.event == 'thinking') {
          steps.add(event.data);
          if (mounted) {
            setState(() {
              _thinkingSteps = List.from(steps);
              _thinkingActiveIndex = steps.length - 1;
            });
            _scrollToBottom();
          }
        } else if (event.event == 'error') {
          throw FloChatException(event.data);
        } else if (event.event == 'blocks') {
          if (mounted && steps.isNotEmpty) {
            setState(() => _thinkingActiveIndex = steps.length);
            await Future<void>.delayed(const Duration(milliseconds: 400));
          }
          final blocks = (jsonDecode(event.data) as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          response = FloChatResponse(
            blocks: blocks,
            modelUsed: '',
            thinking: steps,
          );
        } else if (event.event == 'meta') {
          try {
            final meta = jsonDecode(event.data) as Map<String, dynamic>;
            if (response != null) {
              response = FloChatResponse(
                blocks: response.blocks,
                modelUsed: meta['model_used'] as String? ?? '',
                thinking: (meta['thinking'] as List?)
                        ?.map((e) => e.toString())
                        .toList() ??
                    steps,
              );
            }
          } catch (_) {}
        }
      }

      if (response == null && !useLocal) {
        response = await _chatService.chat(
          branchId: branchId,
          message: text,
          history: history,
          conversationId: conversationId,
          deviceSales: deviceSales,
          shopName: _shopName,
        );
      }
      response ??= const FloChatResponse(
        blocks: [
          {
            'type': 'text',
            'html': 'No response was produced. Please try again.',
          },
        ],
        modelUsed: '',
        thinking: [],
      );

      final payload = FloMessagePayload(blocks: response.blocks);
      await ProxyService.strategy.saveMessage(
        text: payload.toStorageString(),
        phoneNumber: ProxyService.box.getUserPhone() ?? '',
        branchId: branchId,
        role: 'assistant',
        conversationId: conversationId,
        aiResponse: payload.toStorageString(),
        aiContext: text,
        messageSource: 'ai',
      );

      if (_messages.length <= 2) {
        final title = text.length > 40 ? '${text.substring(0, 40)}…' : text;
        try {
          final convs = ref.read(conversationProvider).value ?? [];
          final conv = convs.firstWhere((c) => c.id == conversationId);
          conv.title = title;
          await ProxyService.strategy.updateConversation(conv);
          ref.invalidate(conversationProvider);
        } catch (_) {}
      }
    } on FloChatException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _thinkingActiveIndex = null;
        });
        _scrollToBottom(layoutFrames: 2);
      }
    }
  }

  List<Map<String, String>> _buildHistory() {
    final history = <Map<String, String>>[];
    for (final msg in _messages) {
      if (msg.role != 'user' && msg.role != 'assistant') continue;
      var content = msg.text;
      if (FloMessagePayload.isFloMessage(content)) {
        content = FloMessagePayload.tryParse(content).blocks
            .where((b) => b['type'] == 'text')
            .map((b) => b['html']?.toString() ?? '')
            .join('\n');
      }
      history.add({'role': msg.role ?? 'user', 'content': content});
    }
    return history;
  }

  Future<void> _sendWhatsAppReply(
    String text,
    Message lastMessage,
    String branchId,
    String conversationId,
  ) async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) throw Exception('Business ID not found');
      final business =
          await ProxyService.strategy.getBusiness(businessId: businessId);
      final phoneNumberId = business?.getWhatsAppPhoneNumberId();
      if (phoneNumberId == null) {
        throw Exception('WhatsApp not configured');
      }
      var recipient = lastMessage.phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      if (!recipient.startsWith('+')) recipient = '+$recipient';
      await WhatsAppService().sendWhatsAppMessage(
        phoneNumberId: phoneNumberId,
        recipientPhone: recipient,
        messageBody: text,
        replyToMessageId: lastMessage.whatsappMessageId,
      );
    } catch (e) {
      _showError('Failed to send WhatsApp message: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    showCustomSnackBarUtil(context, message, backgroundColor: Colors.red);
  }

  void _openWhatsAppModal() {
    showDialog<void>(
      context: context,
      builder: (_) => WhatsAppConnectionDialog(
        onConnectionChanged: () =>
            ref.invalidate(whatsAppConnectionStateProvider),
      ),
    );
  }

  void _openSources() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DataSourceListScreen()),
    );
  }

  void _handleAttach() {
    if (_attachedFilePath != null &&
        (_attachedFilePath!.endsWith('.xlsx') ||
            _attachedFilePath!.endsWith('.xls'))) {
      ExcelAnalysisModal.show(context, _attachedFilePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final waState = ref.watch(whatsAppConnectionStateProvider);
    final waConnected = waState.value?.isConnected ?? false;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: FloTheme.chatBg,
      drawer: _isMobile
          ? Drawer(
              child: Consumer(
                builder: (context, ref, _) {
                  final conversations =
                      ref.watch(conversationProvider).value ?? [];
                  return ConversationList(
                    conversations: conversations,
                    currentConversationId: _currentConversationId,
                    onConversationSelected: (id) {
                      setState(() => _currentConversationId = id);
                      _subscribeToMessages(id);
                      _scrollToBottom(animated: false);
                      Navigator.pop(context);
                    },
                    onDeleteConversation: (id) async {
                      await ProxyService.strategy.deleteConversation(id);
                      if (_currentConversationId == id) {
                        await _messageSub?.cancel();
                        _messageSub = null;
                        setState(() {
                          _currentConversationId = '';
                          _messages = [];
                        });
                      }
                    },
                    onNewConversation: () {
                      _newChat();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            )
          : null,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_menuOpen) setState(() => _menuOpen = false);
          },
          child: Column(
            children: [
              FloHeader(
                mode: _mode,
                onModeChanged: (m) {
                  setState(() => _mode = m);
                  if (m == FloPanelMode.askFlo && _showHome) {
                    _loadBriefing();
                  }
                },
                isMobile: _isMobile,
                miniDataConnected: true,
                whatsAppConnected: waConnected,
                modelSelector: FloModelSelector(
                  localAvailable: _localAvailable,
                  useLocal: _useLocal,
                  onChanged: (useLocal) {
                    setState(() => _useLocal = useLocal);
                    _maybeIndexLocalRag();
                  },
                ),
                onNewChat: _newChat,
                onConnectWhatsApp: _openWhatsAppModal,
                onManageSources: _openSources,
                menuOpen: _menuOpen,
                onMenuToggle: () {
                  if (_isMobile) {
                    _scaffoldKey.currentState?.openDrawer();
                  } else {
                    setState(() => _menuOpen = !_menuOpen);
                  }
                },
                menuContent: _menuOpen && !_isMobile
                    ? FloMenuPopover(
                        onNewChat: () {
                          setState(() => _menuOpen = false);
                          _newChat();
                        },
                        onWhatsApp: () {
                          setState(() => _menuOpen = false);
                          _openWhatsAppModal();
                        },
                        onSources: () {
                          setState(() => _menuOpen = false);
                          _openSources();
                        },
                        whatsAppConnected: waConnected,
                      )
                    : null,
              ),
              Expanded(
                child: _mode == FloPanelMode.messages
                    ? FloInboxView(
                        connected: waConnected,
                        onConnect: _openWhatsAppModal,
                        chatService: _chatService,
                      )
                    : _showHome
                        ? SingleChildScrollView(
                            controller: _scrollController,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: FloTheme.contentMaxWidth,
                                ),
                                child: FloHomeView(
                                  shopName: _shopName,
                                  isMobile: _isMobile,
                                  briefing: _briefing,
                                  briefingLoading: _briefingLoading,
                                  onSuggestionTap: _sendMessage,
                                  whatsAppConnected: waConnected,
                                  onConnectWhatsApp: _openWhatsAppModal,
                                  onManageSources: _openSources,
                                ),
                              ),
                            ),
                          )
                        : FloThreadView(
                            scrollController: _scrollController,
                            messages: _messages,
                            thinkingSteps: _thinkingSteps,
                            thinkingActiveIndex: _thinkingActiveIndex,
                            isLoading: _isLoading,
                            isMobile: _isMobile,
                            onAsk: _sendMessage,
                          ),
              ),
              if (_mode == FloPanelMode.askFlo)
                FloComposer(
                  controller: _controller,
                  enabled: !_isLoading,
                  isMobile: _isMobile,
                  showQuickPrompts: !_showHome && _messages.isNotEmpty,
                  onSend: () => _sendMessage(_controller.text),
                  onAttach: _handleAttach,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
