import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/whatsapp_service.dart';
import 'package:supabase_models/brick/models/conversation.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:supabase_models/brick/repository.dart';

import '../../models/flo_models.dart';
import '../../providers/conversation_provider.dart';
import '../../services/flo_chat_service.dart';
import '../../theme/flo_theme.dart';
import 'flo_mark.dart';

/// WhatsApp Messages inbox (Handover §11) — master-detail when connected.
class FloInboxView extends ConsumerStatefulWidget {
  const FloInboxView({
    super.key,
    required this.connected,
    required this.onConnect,
    required this.chatService,
  });

  final bool connected;
  final VoidCallback onConnect;
  final FloChatService chatService;

  @override
  ConsumerState<FloInboxView> createState() => _FloInboxViewState();
}

class _FloInboxViewState extends ConsumerState<FloInboxView> {
  String? _selectedConversationId;
  FloWhatsAppDraft? _draft;
  final _replyController = TextEditingController();
  bool _draftLoading = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.connected) {
      return _LockedState(onConnect: widget.onConnect);
    }

    final conversations = ref.watch(conversationProvider).value ?? [];
    final waConversations = conversations
        .where((c) => c.useCase == 'business')
        .toList();

    final isMobile =
        MediaQuery.sizeOf(context).width < FloTheme.mobileBreakpoint;

    if (isMobile && _selectedConversationId != null) {
      return _ThreadPane(
        conversationId: _selectedConversationId!,
        draft: _draft,
        draftLoading: _draftLoading,
        replyController: _replyController,
        onBack: () => setState(() => _selectedConversationId = null),
        onSend: _sendReply,
        onDraft: () => _loadDraft(_selectedConversationId!),
        chatService: widget.chatService,
      );
    }

    return Row(
      children: [
        SizedBox(
          width: isMobile ? double.infinity : 326,
          child: _ListPane(
            conversations: waConversations,
            selectedId: _selectedConversationId,
            onSelect: (id) {
              setState(() {
                _selectedConversationId = id;
                _draft = null;
              });
              _loadDraft(id);
            },
          ),
        ),
        if (!isMobile)
          Expanded(
            child: _selectedConversationId == null
                ? const Center(
                    child: Text(
                      'Select a conversation',
                      style: TextStyle(color: FloTheme.ink3),
                    ),
                  )
                : _ThreadPane(
                    conversationId: _selectedConversationId!,
                    draft: _draft,
                    draftLoading: _draftLoading,
                    replyController: _replyController,
                    onBack: null,
                    onSend: _sendReply,
                    onDraft: () => _loadDraft(_selectedConversationId!),
                    chatService: widget.chatService,
                  ),
          ),
      ],
    );
  }

  Future<void> _loadDraft(String conversationId) async {
    setState(() => _draftLoading = true);
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return;
      final repo = Repository();
      final msgs = await repo.get<Message>(
        query: Query(
          where: [Where('conversationId').isExactly(conversationId)],
          orderBy: [OrderBy('timestamp', ascending: false)],
          limit: 5,
        ),
      );
      final inbound = msgs.cast<Message?>().firstWhere(
            (m) => m?.messageSource == 'whatsapp' && m?.role == 'user',
            orElse: () => null,
          );
      if (inbound == null) return;
      final draft = await widget.chatService.requestDraft(
        branchId: branchId,
        customerMessage: inbound.text,
      );
      if (mounted) setState(() => _draft = draft);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _draftLoading = false);
    }
  }

  Future<void> _sendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty || _selectedConversationId == null) return;
    final branchId = ProxyService.box.getBranchId();
    final businessId = ProxyService.box.getBusinessId();
    if (branchId == null || businessId == null) return;

    await ProxyService.strategy.saveMessage(
      text: text,
      phoneNumber: ProxyService.box.getUserPhone() ?? '',
      branchId: branchId,
      role: 'user',
      conversationId: _selectedConversationId!,
      messageSource: 'whatsapp',
    );

    try {
      final business =
          await ProxyService.strategy.getBusiness(businessId: businessId);
      final phoneNumberId = business?.getWhatsAppPhoneNumberId();
      if (phoneNumberId != null) {
        await WhatsAppService().sendWhatsAppMessage(
          phoneNumberId: phoneNumberId,
          recipientPhone: ProxyService.box.getUserPhone() ?? '',
          messageBody: text,
        );
      }
    } catch (_) {}

    _replyController.clear();
    setState(() => _draft = null);
  }
}

class _LockedState extends StatelessWidget {
  const _LockedState({required this.onConnect});
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat, size: 48, color: FloTheme.wa.withValues(alpha: 0.8)),
            const SizedBox(height: 16),
            const Text(
              'Answer customers on WhatsApp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FloTheme.ink1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Connect your Meta WhatsApp Business account to see customer messages here and draft replies with Flo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: FloTheme.ink2),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onConnect,
              style: FilledButton.styleFrom(backgroundColor: FloTheme.wa),
              child: const Text('Connect WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListPane extends StatelessWidget {
  const _ListPane({
    required this.conversations,
    required this.selectedId,
    required this.onSelect,
  });

  final List<Conversation> conversations;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Customers · via WhatsApp',
            style: TextStyle(fontWeight: FontWeight.w700, color: FloTheme.ink1),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, i) {
              final c = conversations[i];
              final selected = c.id == selectedId;
              return ListTile(
                selected: selected,
                title: Text(c.title ?? 'Customer'),
                subtitle: Text(c.useCase ?? ''),
                onTap: () => onSelect(c.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThreadPane extends StatelessWidget {
  const _ThreadPane({
    required this.conversationId,
    required this.draft,
    required this.draftLoading,
    required this.replyController,
    this.onBack,
    required this.onSend,
    required this.onDraft,
    required this.chatService,
  });

  final String conversationId;
  final FloWhatsAppDraft? draft;
  final bool draftLoading;
  final TextEditingController replyController;
  final VoidCallback? onBack;
  final VoidCallback onSend;
  final VoidCallback onDraft;
  final FloChatService chatService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onBack != null)
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            title: const Text('WhatsApp thread'),
          ),
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: ProxyService.strategy.subscribeToMessages(conversationId),
            builder: (context, snap) {
              final msgs = snap.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: msgs.length,
                itemBuilder: (context, i) {
                  final m = msgs[i];
                  final outbound = m.role == 'user';
                  return Align(
                    alignment:
                        outbound ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: outbound ? FloTheme.waTint : FloTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: FloTheme.line),
                      ),
                      child: Text(m.text),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (draft != null)
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FloTheme.blueTint,
              borderRadius: BorderRadius.circular(FloTheme.radiusMd),
              border: Border.all(color: FloTheme.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    FloMark(size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Flo suggested reply',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(draft!.src, style: const TextStyle(fontSize: 11, color: FloTheme.ink3)),
                const SizedBox(height: 6),
                Text(draft!.draft),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        replyController.text = draft!.draft;
                        onSend();
                      },
                      child: const Text('Send reply'),
                    ),
                    TextButton(
                      onPressed: () => replyController.text = draft!.draft,
                      child: const Text('Edit first'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              TextButton(onPressed: draftLoading ? null : onDraft, child: const Text('Draft')),
              Expanded(
                child: TextField(
                  controller: replyController,
                  decoration: const InputDecoration(
                    hintText: 'Reply on WhatsApp…',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                onPressed: onSend,
                icon: const Icon(Icons.send, color: FloTheme.wa),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
