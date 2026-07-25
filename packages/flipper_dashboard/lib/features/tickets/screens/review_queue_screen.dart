import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/ticket_review_actions.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

import '../widgets/review_ticket_dialog.dart';
import '../widgets/tickets_list.dart';

/// Ticket Review + Handover workflow: reviewer-facing queue of fully-paid
/// tickets awaiting confirmation that the declared payment landed in the
/// right channel before they can proceed to handover. Entry point is gated
/// on both the business's `enableTicketReviewWorkflow` setting and the
/// current user's `AppFeature.TicketReview` access.
///
/// Desktop: list + right detail panel (same pattern as Customers). Mobile:
/// bottom sheet for details so the queue isn't covered by a dialog on a
/// small screen unnecessarily — sheet still leaves chrome for back.
class ReviewQueueScreen extends ConsumerStatefulWidget {
  const ReviewQueueScreen({super.key});

  @override
  ConsumerState<ReviewQueueScreen> createState() => _ReviewQueueScreenState();
}

class _ReviewQueueScreenState extends ConsumerState<ReviewQueueScreen> {
  static const double _detailPanelWidth = 420;

  /// Selected ticket for the desktop side panel; null when closed.
  ITransaction? _selectedTicket;

  bool _isWideLayout(BuildContext context) {
    return MediaQuery.sizeOf(context).width >=
        PosLayoutBreakpoints.mobileLayoutMaxWidth;
  }

  void _closeDetailPanel() {
    if (!mounted) return;
    setState(() => _selectedTicket = null);
  }

  Future<void> _markReviewed(ITransaction ticket) async {
    try {
      await markTicketReviewed(
        transactionId: ticket.id,
        reviewedByUserId: ProxyService.box.getUserId() ?? '',
      );
    } catch (e, st) {
      talker.error('Mark ticket reviewed failed: $e', st);
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Failed to mark ticket as reviewed',
          backgroundColor: Colors.red,
        );
      }
      rethrow;
    }
  }

  Future<void> _openReviewDetails(
    ITransaction ticket, {
    required bool canReview,
  }) async {
    final isWide = _isWideLayout(context);

    // Desktop: side panel keeps the full queue visible while reviewing.
    if (isWide) {
      setState(() => _selectedTicket = ticket);
      return;
    }

    final approved = await showReviewTicketDialog(
      context: context,
      ticket: ticket,
      canReview: canReview,
      onMarkReviewed: _markReviewed,
    );
    if (approved == true && mounted) {
      showCustomSnackBarUtil(
        context,
        'Ticket reviewed',
        backgroundColor: Colors.green,
      );
    }
  }

  void _onReviewedSuccess() {
    _closeDetailPanel();
    if (!mounted) return;
    showCustomSnackBarUtil(
      context,
      'Ticket reviewed',
      backgroundColor: Colors.green,
    );
  }

  /// Drop selection if the ticket left the queue (e.g. after approve / sync).
  ITransaction? _resolveSelected(List<ITransaction> tickets) {
    final selected = _selectedTicket;
    if (selected == null) return null;
    for (final t in tickets) {
      if (t.id == selected.id) return t;
    }
    // Ticket gone — clear on next frame to avoid setState during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedTicket?.id == selected.id) {
        setState(() => _selectedTicket = null);
      }
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(reviewQueueStreamProvider);
    final canReview = ref.watch(
      featureAccessProvider(
        userId: ProxyService.box.getUserId() ?? '',
        featureName: AppFeature.TicketReview,
      ),
    );
    final isWide = _isWideLayout(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => locator<RouterService>().back(),
        ),
        title: Text(
          'Review Queue',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: ticketsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text(
            'Could not load the review queue',
            style: GoogleFonts.outfit(color: Colors.grey[700]),
          ),
        ),
        data: (tickets) {
          if (tickets.isEmpty) {
            return Center(
              child: Text(
                'Nothing waiting for review',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          final selected = isWide ? _resolveSelected(tickets) : null;

          final listPane = ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              final paid = ticket.cashReceived ?? ticket.subTotal ?? 0.0;
              final isSelected = selected?.id == ticket.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TicketCard(
                  key: ValueKey(ticket.id),
                  ticket: ticket,
                  isSelected: isSelected,
                  paidAmount: paid,
                  showResume: false,
                  showMarkReviewed: true,
                  markReviewedLabel: 'Review details',
                  canManage: false,
                  onTap: () => _openReviewDetails(
                    ticket,
                    canReview: canReview,
                  ),
                  onMarkReviewed: () => _openReviewDetails(
                    ticket,
                    canReview: canReview,
                  ),
                  onDelete: () => showCustomSnackBarUtil(
                    context,
                    ticketDeleteBlockedByReviewMessage(ticket.status),
                    backgroundColor: Colors.orange,
                  ),
                  onSelectionChanged: (_) {},
                ),
              );
            },
          );

          if (!isWide) return listPane;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: listPane),
              if (selected != null)
                SizedBox(
                  width: _detailPanelWidth,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x14000000),
                          offset: Offset(-4, 0),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: ReviewTicketPanel(
                      key: ValueKey('review-panel-${selected.id}'),
                      ticket: selected,
                      canReview: canReview,
                      panelMode: true,
                      showSheetHandle: false,
                      onDismissed: _closeDetailPanel,
                      onReviewed: _onReviewedSuccess,
                      onMarkReviewed: _markReviewed,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
