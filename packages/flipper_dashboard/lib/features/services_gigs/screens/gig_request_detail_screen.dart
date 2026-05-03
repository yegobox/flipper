import 'package:flipper_dashboard/features/services_gigs/models/service_gig_chat_message.dart';
import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/widgets/gig_payment_sheet.dart';
import 'package:flipper_dashboard/features/services_gigs/widgets/request_status_timeline.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Full request view: timeline, chat, pay / job actions, review.
class GigRequestDetailScreen extends StatefulWidget {
  final String requestId;
  /// Top title (e.g. provider name or "Request from …").
  final String headline;
  /// Shown on MTN sheet; only used when the viewer is the customer.
  final String? paymentRecipientLabel;

  const GigRequestDetailScreen({
    Key? key,
    required this.requestId,
    required this.headline,
    this.paymentRecipientLabel,
  }) : super(key: key);

  @override
  State<GigRequestDetailScreen> createState() => _GigRequestDetailScreenState();
}

class _GigRequestDetailScreenState extends State<GigRequestDetailScreen> {
  final _repo = ServiceGigRequestRepository();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  RealtimeChannel? _messageChannel;
  ServiceGigRequest? _request;
  List<ServiceGigChatMessage> _messages = [];
  bool _loading = true;
  bool _sending = false;
  bool _acting = false;

  String get _myId => ProxyService.box.getUserId() ?? '';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _syncFromServer(showFullScreenLoader: true);
    if (!mounted) return;
    _subscribeMessagesRealtime();
  }

  @override
  void dispose() {
    _messageChannel?.unsubscribe();
    _messageChannel = null;
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTowardsEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final pos = _scrollController.position;
      _scrollController.animateTo(
        pos.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _mergeMessage(ServiceGigChatMessage m) {
    if (_messages.any((x) => x.id == m.id)) return;
    final next = [..._messages, m]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _messages = next;
  }

  /// Reload request + messages. Use [showFullScreenLoader] only for first paint.
  Future<void> _syncFromServer({required bool showFullScreenLoader}) async {
    if (showFullScreenLoader) {
      setState(() => _loading = true);
    }
    try {
      final r = await _repo.getRequestForParticipant(widget.requestId);
      final msgs = r != null
          ? await _repo.listMessages(widget.requestId)
          : <ServiceGigChatMessage>[];
      if (!mounted) return;
      setState(() {
        _request = r;
        _messages = msgs;
      });
      _scrollTowardsEnd();
    } finally {
      if (showFullScreenLoader && mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _subscribeMessagesRealtime() {
    final id = widget.requestId;
    _messageChannel?.unsubscribe();
    _messageChannel = Supabase.instance.client
        .channel(
          'gig_request_messages_$id',
          opts: const RealtimeChannelConfig(ack: true),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'service_gig_request_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'request_id',
            value: id,
          ),
          callback: (PostgresChangePayload payload) {
            final raw = payload.newRecord;
            if (raw.isEmpty) return;
            final map = Map<String, dynamic>.from(raw);
            if (map['id'] == null) return;
            final m = ServiceGigChatMessage.fromJson(map);
            if (!mounted) return;
            setState(() => _mergeMessage(m));
            _scrollTowardsEnd();
          },
        )
        .subscribe();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    setState(() => _sending = true);
    try {
      final sent = await _repo.sendMessage(
        requestId: widget.requestId,
        body: text,
      );
      _messageController.clear();
      if (!mounted) return;
      setState(() => _mergeMessage(sent));
      _scrollTowardsEnd();
    } on ServiceGigRequestException catch (e) {
      if (mounted) showErrorNotification(context, e.message);
    } catch (_) {
      if (mounted) {
        showErrorNotification(context, 'Could not send message.');
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openPay() async {
    final r = _request;
    if (r == null) return;
    final done = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => GigPaymentSheet(
        request: r,
        providerLabel: widget.paymentRecipientLabel ?? 'Provider',
      ),
    );
    if (done == true && mounted) {
      showSuccessNotification(context, 'Payment recorded.');
      await _syncFromServer(showFullScreenLoader: false);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  Future<void> _startJob() async {
    setState(() => _acting = true);
    try {
      await _repo.providerStartJob(widget.requestId);
      if (mounted) showSuccessNotification(context, 'Marked as in progress.');
      await _syncFromServer(showFullScreenLoader: false);
    } on ServiceGigRequestException catch (e) {
      if (mounted) showErrorNotification(context, e.message);
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _completeJob() async {
    setState(() => _acting = true);
    try {
      await _repo.providerCompleteJob(widget.requestId);
      if (mounted) {
        showSuccessNotification(context, 'Job marked complete. Customer can review.');
      }
      await _syncFromServer(showFullScreenLoader: false);
    } on ServiceGigRequestException catch (e) {
      if (mounted) showErrorNotification(context, e.message);
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _openReview() async {
    final r = _request;
    if (r == null || !r.canLeaveReview) return;
    final reviewCtrl = TextEditingController();
    var stars = 5;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text(
            'Rate your experience',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final star = i + 1;
                    return IconButton(
                      onPressed: () => setSt(() => stars = star),
                      icon: Icon(
                        star <= stars ? Icons.star : Icons.star_border,
                        color: Colors.amber.shade700,
                        size: 32,
                      ),
                    );
                  }),
                ),
                TextField(
                  controller: reviewCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
              ),
              child: Text('Submit', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
    final comment = reviewCtrl.text;
    reviewCtrl.dispose();
    if (ok != true || !mounted) return;
    setState(() => _acting = true);
    try {
      await _repo.submitCustomerReview(
        requestId: widget.requestId,
        rating: stars,
        comment: comment,
      );
      if (mounted) showSuccessNotification(context, 'Thanks for your review.');
      await _syncFromServer(showFullScreenLoader: false);
    } on ServiceGigRequestException catch (e) {
      if (mounted) showErrorNotification(context, e.message);
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _request;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Request details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : r == null
              ? Center(
                  child: Text(
                    'Request not found.',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      _syncFromServer(showFullScreenLoader: false),
                  color: const Color(0xFF0D9488),
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        widget.headline,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        r.statusLabel,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Color(r.statusColor),
                        ),
                      ),
                      if (r.requestedService != null &&
                          r.requestedService!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          r.requestedService!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        r.customerMessage,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RequestStatusTimeline(request: r),
                      const SizedBox(height: 24),
                      Text(
                        'Messages',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_messages.isEmpty)
                        Text(
                          'No messages yet. Coordinate time and location here.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        )
                      else
                        ..._messages.map((m) {
                          final mine = m.senderUserId == _myId;
                          return Align(
                            alignment:
                                mine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                              ),
                              decoration: BoxDecoration(
                                color: mine
                                    ? const Color(0xFF0D9488).withValues(alpha: 0.15)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                m.body,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                          );
                        }),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              minLines: 1,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Type a message…',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _sending ? null : _sendMessage,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0D9488),
                              padding: const EdgeInsets.all(14),
                              shape: const CircleBorder(),
                            ),
                            child: _sending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_acting)
                        const Center(child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ))
                      else ..._actionButtons(r),
                    ],
                  ),
                ),
    );
  }

  List<Widget> _actionButtons(ServiceGigRequest r) {
    final uid = _myId;
    final isCustomer = r.customerUserId == uid;
    final isProvider = r.providerUserId == uid;
    final out = <Widget>[];

    if (isCustomer && r.canCustomerPay) {
      out.add(
        FilledButton.icon(
          onPressed: _openPay,
          icon: const Icon(Icons.phone_android),
          label: const Text('Pay with MTN'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0D9488),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
    }

    if (isProvider && r.status == 'paid') {
      out.add(
        FilledButton.icon(
          onPressed: _startJob,
          icon: const Icon(Icons.play_circle_outline),
          label: const Text('Start job'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0F766E),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
    }

    if (isProvider && (r.status == 'paid' || r.status == 'in_progress')) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: OutlinedButton.icon(
            onPressed: _completeJob,
            icon: const Icon(Icons.task_alt),
            label: const Text('Mark job complete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0D9488),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );
    }

    if (isCustomer && r.canLeaveReview) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: FilledButton.icon(
            onPressed: _openReview,
            icon: const Icon(Icons.star_outline),
            label: const Text('Leave a review'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber.shade800,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );
    }

    if (r.customerRating != null && r.customerReview != null) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your review',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < (r.customerRating ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber.shade700,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.customerReview!,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return out;
  }
}
