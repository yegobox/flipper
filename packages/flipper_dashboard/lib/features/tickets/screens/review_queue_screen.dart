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

import '../widgets/tickets_list.dart';

/// Ticket Review + Handover workflow: reviewer-facing queue of fully-paid
/// tickets awaiting confirmation that the declared payment landed in the
/// right channel before they can proceed to handover. Entry point is gated
/// on both the business's `enableTicketReviewWorkflow` setting and the
/// current user's `AppFeature.TicketReview` access.
class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  static Future<void> _markReviewed(
    BuildContext context,
    ITransaction ticket,
  ) async {
    try {
      await markTicketReviewed(
        transactionId: ticket.id,
        reviewedByUserId: ProxyService.box.getUserId() ?? '',
      );
      if (context.mounted) {
        showCustomSnackBarUtil(
          context,
          'Ticket reviewed',
          backgroundColor: Colors.green,
        );
      }
    } catch (e, st) {
      talker.error('Mark ticket reviewed failed: $e', st);
      if (context.mounted) {
        showCustomSnackBarUtil(
          context,
          'Failed to mark ticket as reviewed',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(reviewQueueStreamProvider);
    final canReview = ref.watch(
      featureAccessProvider(
        userId: ProxyService.box.getUserId() ?? '',
        featureName: AppFeature.TicketReview,
      ),
    );

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
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              final paid = ticket.cashReceived ?? ticket.subTotal ?? 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TicketCard(
                  key: ValueKey(ticket.id),
                  ticket: ticket,
                  isSelected: false,
                  paidAmount: paid,
                  showResume: false,
                  showMarkReviewed: canReview,
                  canManage: false,
                  onTap: () {},
                  onMarkReviewed: () => _markReviewed(context, ticket),
                  onDelete: () => showCustomSnackBarUtil(
                    context,
                    'This ticket is paid and pending review — it cannot be deleted',
                    backgroundColor: Colors.orange,
                  ),
                  onSelectionChanged: (_) {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
