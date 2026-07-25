import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../screens/review_queue_screen.dart';

/// Collapsible banner surfaced at the top of the POS checkout pane so reviewers
/// see the Ticket-Review queue without first navigating into Tickets.
///
/// Renders nothing unless both of the following hold:
///  * the current user has [AppFeature.TicketReview] view access, and
///  * there is at least one ticket awaiting review.
///
/// It deliberately does **not** gate on `SettingsService.enableTicketReviewWorkflow`:
/// that in-memory getter defaults to `false` until `hydrateToggleStatesFromSettings`
/// runs, is read non-reactively, and can lag the Ditto-synced setting on a fresh
/// client. The review queue itself is the authoritative, reactive signal —
/// `pendingReview` tickets only exist when the workflow was on at payment time,
/// so a non-empty queue already implies the workflow is in use.
///
/// Collapsed it shows the count ("N tickets waiting to review"); tapping it
/// expands an inline list. Rows and the footer both open [ReviewQueueScreen],
/// where the actual mark-reviewed action lives — this widget is a read-only
/// surface that mirrors the Review Queue badge already inside Tickets.
class ReviewQueueBanner extends HookConsumerWidget {
  /// [margin] is kept *inside* the widget (rather than wrapping the call site)
  /// so a hidden banner contributes no stray spacing. Each layout passes the
  /// inset that matches its sibling checkout card: the desktop pinned header
  /// insets cards by 2px, the small-device sliver list by 16px.
  const ReviewQueueBanner({
    super.key,
    this.margin = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final EdgeInsetsGeometry margin;

  /// Matches the Review Queue badge accent used inside the Tickets screen.
  static const Color _accent = Color(0xFF7C3AED);
  static const int _maxRows = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canView = ref.watch(
      featureViewAccessProvider(
        userId: ProxyService.box.getUserId() ?? '',
        featureName: AppFeature.TicketReview,
      ),
    );
    if (!canView) return const SizedBox.shrink();

    // .value (not .asData) keeps the banner steady across stream reloads
    // instead of collapsing to empty, matching reviewQueueCountProvider.
    final tickets =
        ref.watch(reviewQueueStreamProvider).value ?? const <ITransaction>[];
    if (tickets.isEmpty) return const SizedBox.shrink();

    final expanded = useState(false);
    final count = tickets.length;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        border: Border.all(color: _accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, count, expanded),
          if (expanded.value) ...[
            Divider(height: 1, color: _accent.withValues(alpha: 0.2)),
            ...tickets.take(_maxRows).map((t) => _buildRow(context, t)),
            if (count > _maxRows) _buildMore(context, count - _maxRows),
            _buildOpenFull(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int count,
    ValueNotifier<bool> expanded,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(PosTokens.radiusSm),
      onTap: () => expanded.value = !expanded.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.fact_check_outlined, size: 20, color: _accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                count == 1
                    ? '1 ticket waiting to review'
                    : '$count tickets waiting to review',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _accent,
                ),
              ),
            ),
            Icon(
              expanded.value ? Icons.expand_less : Icons.expand_more,
              size: 22,
              color: _accent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, ITransaction ticket) {
    final label = _ticketLabel(ticket);
    final paid = ticket.cashReceived ?? ticket.subTotal ?? 0.0;
    return InkWell(
      onTap: () => _openReviewQueue(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: PosTokens.ink1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${paid.toCurrencyFormatted()} · ${_relativeTime(ticket.createdAt)}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: PosTokens.ink2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: PosTokens.ink3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMore(BuildContext context, int remaining) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
      child: Text(
        '+ $remaining more',
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: PosTokens.ink3,
        ),
      ),
    );
  }

  Widget _buildOpenFull(BuildContext context) {
    return InkWell(
      onTap: () => _openReviewQueue(context),
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(PosTokens.radiusSm),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: _accent.withValues(alpha: 0.2)),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'Open review queue →',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _accent,
          ),
        ),
      ),
    );
  }

  void _openReviewQueue(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ReviewQueueScreen()),
    );
  }

  String _ticketLabel(ITransaction ticket) {
    final name = (ticket.customerName ?? ticket.ticketName ?? '').trim();
    if (name.isNotEmpty) return name;
    final ref = (ticket.reference ?? '').trim();
    if (ref.isNotEmpty) return 'Ticket #$ref';
    return 'Ticket';
  }

  String _relativeTime(DateTime? when) {
    if (when == null) return '';
    final diff = DateTime.now().difference(when);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
