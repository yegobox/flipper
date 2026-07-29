import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/whatsapp_ditto_inbox.dart';
import 'package:flipper_services/whatsapp_service.dart';
import 'package:http/http.dart' as http;

import '../../providers/whatsapp_message_provider.dart';
import '../../services/flo_chat_service.dart';
import '../../theme/flo_theme.dart';
import 'flo_icons.dart';
import 'flo_mark.dart';

/// WhatsApp Messages inbox — reads Ditto `whatsapp_messages` directly.
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
  String? _selectedWaId;
  String? _draftText;
  final _replyController = TextEditingController();
  bool _draftLoading = false;
  bool _sending = false;

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

    final threadsAsync = ref.watch(whatsappDittoThreadsProvider);
    final isMobile =
        MediaQuery.sizeOf(context).width < FloTheme.mobileBreakpoint;

    return threadsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(FloTheme.blue),
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: FloTheme.loss, size: 32),
              const SizedBox(height: 12),
              Text(
                'Could not read Ditto whatsapp_messages\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: FloTheme.ink2, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(whatsappDittoThreadsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (threads) {
        final selected = _selectedWaId == null
            ? null
            : threads.cast<WhatsAppDittoThread?>().firstWhere(
                  (t) => t?.waId == _selectedWaId,
                  orElse: () => null,
                );

        if (isMobile && selected != null) {
          return _ThreadPane(
            thread: selected,
            draftText: _draftText,
            draftLoading: _draftLoading,
            sending: _sending,
            replyController: _replyController,
            onBack: () => setState(() => _selectedWaId = null),
            onSend: () => _sendReply(selected),
            onDraft: () => _loadDraft(selected),
          );
        }

        return Row(
          children: [
            SizedBox(
              width: isMobile ? double.infinity : 340,
              child: _ListPane(
                threads: threads,
                selectedWaId: _selectedWaId,
                onSelect: (waId) {
                  setState(() {
                    _selectedWaId = waId;
                    _draftText = null;
                  });
                  final t = threads.cast<WhatsAppDittoThread?>().firstWhere(
                        (x) => x?.waId == waId,
                        orElse: () => null,
                      );
                  if (t != null) _loadDraft(t);
                },
              ),
            ),
            if (!isMobile) ...[
              const VerticalDivider(width: 1, color: FloTheme.line),
              Expanded(
                child: selected == null
                    ? const _EmptyThreadHint()
                    : _ThreadPane(
                        thread: selected,
                        draftText: _draftText,
                        draftLoading: _draftLoading,
                        sending: _sending,
                        replyController: _replyController,
                        onBack: null,
                        onSend: () => _sendReply(selected),
                        onDraft: () => _loadDraft(selected),
                      ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _loadDraft(WhatsAppDittoThread thread) async {
    setState(() => _draftLoading = true);
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return;
      final inbound = thread.messages.reversed.cast<WhatsAppDittoMessage?>().firstWhere(
            (m) => m != null && !m.outbound,
            orElse: () => null,
          );
      if (inbound == null) return;
      final draft = await widget.chatService.requestDraft(
        branchId: branchId,
        customerMessage: inbound.body,
      );
      if (mounted) {
        setState(() => _draftText = draft.draft);
        _replyController.text = draft.draft;
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _draftLoading = false);
    }
  }

  Future<void> _sendReply(WhatsAppDittoThread thread) async {
    final text = _replyController.text.trim();
    if (text.isEmpty || _sending) return;
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) return;

    setState(() => _sending = true);
    try {
      final phoneNumberId = await resolveWhatsAppPhoneNumberId();
      if (phoneNumberId == null) return;

      final sendResult = await WhatsAppService().sendWhatsAppMessage(
        phoneNumberId: phoneNumberId,
        recipientPhone: thread.waId,
        messageBody: text,
      );
      final metaMessageId = () {
        final messages = sendResult['messages'];
        if (messages is List && messages.isNotEmpty) {
          final first = messages.first;
          if (first is Map && first['id'] != null) {
            return first['id'].toString();
          }
        }
        return null;
      }();

      // Persist with Meta wamid so inbound reactions attach to this bubble.
      await ref.read(whatsappDittoInboxProvider).appendOutbound(
            phoneNumberId: phoneNumberId,
            waId: thread.waId,
            body: text,
            contactName: thread.displayName,
            messageId: metaMessageId,
          );

      _replyController.clear();
      setState(() => _draftText = null);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Send failed: $e'),
            backgroundColor: FloTheme.loss,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
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
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: FloTheme.blueTint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: FloIcons.whatsApp(size: 28, color: FloTheme.blueDeep),
            ),
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
            SizedBox(
              height: 44,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onConnect,
                  borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: FloTheme.gradBtn,
                      borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                      boxShadow: const [FloTheme.shBlue],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloIcons.link(size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text(
                          'Connect WhatsApp',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyThreadHint extends StatelessWidget {
  const _EmptyThreadHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FloTheme.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: FloTheme.line),
            ),
            child: FloIcons.whatsApp(size: 24, color: FloTheme.ink3),
          ),
          const SizedBox(height: 14),
          const Text(
            'Select a customer',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: FloTheme.ink1,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'WhatsApp inbox · data-connector + Ditto',
            style: TextStyle(fontSize: 13, color: FloTheme.ink3),
          ),
        ],
      ),
    );
  }
}

class _ListPane extends StatelessWidget {
  const _ListPane({
    required this.threads,
    required this.selectedWaId,
    required this.onSelect,
  });

  final List<WhatsAppDittoThread> threads;
  final String? selectedWaId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FloTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                FloIcons.whatsApp(size: 16, color: FloTheme.blueDeep),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Customers · WhatsApp',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.01,
                      color: FloTheme.ink1,
                    ),
                  ),
                ),
                Text(
                  '${threads.length}',
                  style: FloTheme.mono(12).copyWith(color: FloTheme.ink3),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: FloTheme.line),
          Expanded(
            child: threads.isEmpty
                ? const _EmptyCustomerList()
                : ListView.separated(
                    itemCount: threads.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: FloTheme.lineSoft),
                    itemBuilder: (context, i) {
                      final t = threads[i];
                      final selected = t.waId == selectedWaId;
                      return Material(
                        color: selected ? FloTheme.blueTint : FloTheme.surface,
                        child: InkWell(
                          onTap: () => onSelect(t.waId),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                _Avatar(label: t.displayName),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.displayName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: FloTheme.ink1,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        t.lastPreview ?? t.waId,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: FloTheme.ink3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _relativeTime(t.lastMessageAt),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: FloTheme.ink4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  static String _relativeTime(DateTime at) {
    final local = at.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) {
      final h = local.hour.toString().padLeft(2, '0');
      final m = local.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${local.day}/${local.month}';
  }
}

class _EmptyCustomerList extends StatelessWidget {
  const _EmptyCustomerList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline_rounded,
                size: 36, color: FloTheme.ink4),
            SizedBox(height: 12),
            Text(
              'No WhatsApp messages yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: FloTheme.ink1,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Inbound messages load from data-connector (local Ditto is a backup). When Meta posts to the webhook they appear here within a few seconds.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, height: 1.4, color: FloTheme.ink3),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final initial = label.isNotEmpty ? label[0].toUpperCase() : '?';
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: FloTheme.blueTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FloTheme.blueTint2),
      ),
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: FloTheme.blueDeep,
        ),
      ),
    );
  }
}

class _ThreadPane extends StatefulWidget {
  const _ThreadPane({
    required this.thread,
    required this.draftText,
    required this.draftLoading,
    required this.sending,
    required this.replyController,
    this.onBack,
    required this.onSend,
    required this.onDraft,
  });

  final WhatsAppDittoThread thread;
  final String? draftText;
  final bool draftLoading;
  final bool sending;
  final TextEditingController replyController;
  final VoidCallback? onBack;
  final VoidCallback onSend;
  final VoidCallback onDraft;

  @override
  State<_ThreadPane> createState() => _ThreadPaneState();
}

class _ThreadPaneState extends State<_ThreadPane> {
  final _scroll = ScrollController();
  String? _trackedWaId;
  String? _lastMessageId;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _trackedWaId = widget.thread.waId;
    _syncMessageCursor(forceScroll: true);
  }

  @override
  void didUpdateWidget(covariant _ThreadPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.thread.waId != _trackedWaId) {
      _trackedWaId = widget.thread.waId;
      _lastMessageId = null;
      _lastMessageCount = 0;
      _syncMessageCursor(forceScroll: true);
      return;
    }
    _syncMessageCursor(forceScroll: false);
  }

  void _syncMessageCursor({required bool forceScroll}) {
    final msgs = widget.thread.messages;
    final lastId = msgs.isEmpty ? null : msgs.last.id;
    final grew =
        msgs.length > _lastMessageCount || lastId != _lastMessageId;
    _lastMessageCount = msgs.length;
    _lastMessageId = lastId;
    if (forceScroll || grew) {
      _scrollToLatest(animate: !forceScroll);
    }
  }

  void _scrollToLatest({required bool animate}) {
    void jump() {
      if (!mounted || !_scroll.hasClients) return;
      final max = _scroll.position.maxScrollExtent;
      if (animate) {
        _scroll.animateTo(
          max,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      } else {
        _scroll.jumpTo(max);
      }
    }

    // Layout may need two frames after the list grows.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jump();
      WidgetsBinding.instance.addPostFrameCallback((_) => jump());
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thread = widget.thread;
    return ColoredBox(
      color: FloTheme.chatBg,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: FloTheme.surface,
              border: Border(bottom: BorderSide(color: FloTheme.line)),
            ),
            child: Row(
              children: [
                if (widget.onBack != null)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    onPressed: widget.onBack,
                    color: FloTheme.ink2,
                  ),
                _Avatar(label: thread.displayName),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: FloTheme.ink1,
                        ),
                      ),
                      Text(
                        thread.waId,
                        style:
                            FloTheme.mono(11.5).copyWith(color: FloTheme.ink3),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: FloTheme.blueTint,
                    borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloIcons.whatsApp(size: 12, color: FloTheme.blueDeep),
                      const SizedBox(width: 4),
                      Text(
                        '${thread.messages.length}',
                        style: FloTheme.mono(11).copyWith(
                          fontWeight: FontWeight.w700,
                          color: FloTheme.blueDeep,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: thread.messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages in this thread yet',
                      style: TextStyle(color: FloTheme.ink3),
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    itemCount: thread.messages.length,
                    itemBuilder: (context, i) {
                      final m = thread.messages[i];
                      return _Bubble(message: m);
                    },
                  ),
          ),
          if (widget.draftText != null && widget.draftText!.isNotEmpty)
            _DraftCard(
              draft: widget.draftText!,
              replyController: widget.replyController,
              onSend: widget.onSend,
            ),
          _ComposerBar(
            replyController: widget.replyController,
            draftLoading: widget.draftLoading,
            sending: widget.sending,
            onDraft: widget.onDraft,
            onSend: widget.onSend,
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final WhatsAppDittoMessage message;

  @override
  Widget build(BuildContext context) {
    final fromUs = message.outbound;
    final reactions = message.reactions;
    final onBlue = fromUs;
    return Align(
      alignment: fromUs ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: reactions.isEmpty ? 10 : 4),
          child: Column(
            crossAxisAlignment:
                fromUs ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: fromUs ? FloTheme.blue : FloTheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(fromUs ? 16 : 4),
                    bottomRight: Radius.circular(fromUs ? 4 : 16),
                  ),
                  border: fromUs ? null : Border.all(color: FloTheme.line),
                  boxShadow: const [FloTheme.sh1],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.isDocument) ...[
                      _PdfAttachment(message: message, onBlue: onBlue),
                      if (_captionForDocument(message) != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _captionForDocument(message)!,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: onBlue ? Colors.white : FloTheme.ink1,
                          ),
                        ),
                      ],
                    ] else
                      Text(
                        message.body,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: onBlue ? Colors.white : FloTheme.ink1,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 10.5,
                        color: onBlue
                            ? Colors.white.withValues(alpha: 0.75)
                            : FloTheme.ink4,
                      ),
                    ),
                  ],
                ),
              ),
              if (reactions.isNotEmpty)
                Transform.translate(
                  offset: const Offset(0, -6),
                  child: _ReactionChips(
                    reactions: reactions,
                    alignEnd: fromUs,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String? _captionForDocument(WhatsAppDittoMessage m) {
    final body = m.body.trim();
    if (body.isEmpty) return null;
    final name = m.displayFilename;
    if (body == name || body == '[${m.messageType}]') return null;
    if (body.toLowerCase() == 'document') return null;
    return body;
  }

  static String _formatTime(DateTime t) {
    final local = t.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _PdfAttachment extends StatefulWidget {
  const _PdfAttachment({
    required this.message,
    required this.onBlue,
  });

  final WhatsAppDittoMessage message;
  final bool onBlue;

  @override
  State<_PdfAttachment> createState() => _PdfAttachmentState();
}

class _PdfAttachmentState extends State<_PdfAttachment> {
  bool _busy = false;

  Future<void> _download() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final bytes = await _loadPdfBytes(widget.message);
      if (!mounted) return;
      if (bytes == null || bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not download this PDF'),
            backgroundColor: FloTheme.loss,
          ),
        );
        return;
      }

      final fileName = widget.message.displayFilename.endsWith('.pdf')
          ? widget.message.displayFilename
          : '${widget.message.displayFilename}.pdf';

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        bytes: bytes,
      );
      if (!mounted) return;
      if (savedPath == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved $fileName'),
          backgroundColor: FloTheme.blueDeep,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: FloTheme.loss,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onBlue = widget.onBlue;
    final name = widget.message.displayFilename;
    final canDownload = widget.message.hasDownloadableMedia;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canDownload && !_busy ? _download : null,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: onBlue
                ? Colors.white.withValues(alpha: 0.14)
                : FloTheme.blueTint,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: onBlue
                  ? Colors.white.withValues(alpha: 0.22)
                  : FloTheme.line,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: onBlue
                      ? Colors.white.withValues(alpha: 0.18)
                      : FloTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  size: 22,
                  color: onBlue ? Colors.white : FloTheme.loss,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: onBlue ? Colors.white : FloTheme.ink1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'PDF document',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: onBlue
                            ? Colors.white.withValues(alpha: 0.75)
                            : FloTheme.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_busy)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: onBlue ? Colors.white : FloTheme.blue,
                  ),
                )
              else
                Icon(
                  Icons.download_rounded,
                  size: 20,
                  color: onBlue
                      ? Colors.white.withValues(alpha: 0.9)
                      : FloTheme.blueDeep,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Uint8List?> _loadPdfBytes(WhatsAppDittoMessage message) async {
  final embedded = message.mediaBase64?.trim();
  if (embedded != null && embedded.isNotEmpty) {
    try {
      return Uint8List.fromList(base64Decode(embedded));
    } catch (_) {}
  }

  final direct = message.mediaUrl?.trim();
  if (direct != null && direct.isNotEmpty) {
    final response =
        await http.get(Uri.parse(direct)).timeout(const Duration(seconds: 45));
    if (response.statusCode >= 200 && response.statusCode < 400) {
      return response.bodyBytes;
    }
  }

  for (final base in await _mediaCandidateBases()) {
    final uri = Uri.parse('${base}api/whatsapp/inbound-media').replace(
      queryParameters: {
        if (message.id.isNotEmpty) 'message_id': message.id,
        if ((message.mediaId ?? '').isNotEmpty) 'media_id': message.mediaId!,
      },
    );
    try {
      final response =
          await http.get(uri).timeout(const Duration(seconds: 45));
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return response.bodyBytes;
      }
    } catch (_) {}
  }
  return null;
}

Future<List<String>> _mediaCandidateBases() async {
  String normalize(String url) {
    var u = url.trim();
    if (!u.endsWith('/')) u = '$u/';
    return u.replaceFirst('://localhost:', '://127.0.0.1:');
  }

  final out = <String>[];
  void add(String? raw) {
    if (raw == null || raw.trim().isEmpty) return;
    final n = normalize(raw);
    if (!out.contains(n)) out.add(n);
  }

  add(await resolveEbmDataConnectorUrl());
  if (kDebugMode) add('http://127.0.0.1:8084/');
  add('https://data-connector.yegobox.com/');
  return out;
}

class _ReactionChips extends StatelessWidget {
  const _ReactionChips({
    required this.reactions,
    required this.alignEnd,
  });

  final List<WhatsAppReaction> reactions;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    // Collapse duplicate emojis with counts (WhatsApp-style).
    final counts = <String, int>{};
    for (final r in reactions) {
      counts.update(r.emoji, (v) => v + 1, ifAbsent: () => 1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Wrap(
        alignment: alignEnd ? WrapAlignment.end : WrapAlignment.start,
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final e in counts.entries)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: FloTheme.surface,
                borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                border: Border.all(color: FloTheme.line),
                boxShadow: const [FloTheme.sh1],
              ),
              child: Text(
                e.value > 1 ? '${e.key} ${e.value}' : e.key,
                style: const TextStyle(fontSize: 13, height: 1.1),
              ),
            ),
        ],
      ),
    );
  }
}

class _DraftCard extends StatelessWidget {
  const _DraftCard({
    required this.draft,
    required this.replyController,
    required this.onSend,
  });

  final String draft;
  final TextEditingController replyController;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FloTheme.surface,
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
        border: Border.all(color: FloTheme.blueTint2),
        boxShadow: const [FloTheme.sh1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              FloMark(size: 18),
              SizedBox(width: 8),
              Text(
                'Flo suggested reply',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: FloTheme.ink1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            draft,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: FloTheme.ink2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  replyController.text = draft;
                  onSend();
                },
                child: const Text('Send'),
              ),
              TextButton(
                onPressed: () => replyController.text = draft,
                child: const Text('Edit first'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.replyController,
    required this.draftLoading,
    required this.sending,
    required this.onDraft,
    required this.onSend,
  });

  final TextEditingController replyController;
  final bool draftLoading;
  final bool sending;
  final VoidCallback onDraft;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: const BoxDecoration(
        color: FloTheme.surface,
        border: Border(top: BorderSide(color: FloTheme.line)),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: draftLoading ? null : onDraft,
            style: TextButton.styleFrom(
              foregroundColor: FloTheme.blueDeep,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: draftLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Draft'),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: replyController,
              minLines: 1,
              maxLines: 4,
              enabled: !sending,
              decoration: InputDecoration(
                hintText: 'Reply on WhatsApp…',
                hintStyle: const TextStyle(color: FloTheme.ink4),
                filled: true,
                fillColor: FloTheme.surface2,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                  borderSide: const BorderSide(color: FloTheme.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                  borderSide: const BorderSide(color: FloTheme.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                  borderSide:
                      const BorderSide(color: FloTheme.blue, width: 1.5),
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: sending ? null : onSend,
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: FloTheme.gradBtn,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [FloTheme.shBlue],
                ),
                child: Center(
                  child: sending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : FloIcons.send(size: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
