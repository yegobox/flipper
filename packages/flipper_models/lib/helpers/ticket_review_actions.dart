import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

/// Ticket Review + Handover workflow (opt-in per business via
/// `Setting.enableTicketReviewWorkflow`). Both actions are pure status +
/// audit-metadata writes — no payment recomputation, no tax re-signing, no
/// stock mutation (stock was already deducted earlier in the sale).
///
/// Each call is guarded by [TransactionInterface.updateTransaction]'s
/// `requireCurrentStatus`, so a stale/duplicate tap (two reviewers, or a
/// reviewer and a stock manager racing) is a safe no-op rather than an
/// incorrect double transition.

/// Reviewer confirms the declared payment landed in the right channel.
/// Transitions `pendingReview` -> `awaitingHandover`.
Future<void> markTicketReviewed({
  required String transactionId,
  required String reviewedByUserId,
}) async {
  await ProxyService.getStrategy(Strategy.capella).updateTransaction(
    transactionId: transactionId,
    status: AWAITING_HANDOVER,
    reviewedBy: reviewedByUserId,
    reviewedAt: DateTime.now().toUtc(),
    requireCurrentStatus: PENDING_REVIEW,
  );
}

/// Stock manager confirms the item physically left stock. Transitions
/// `awaitingHandover` -> `completed` — the same terminal status/behavior as
/// today's normal sale completion (ticket disappears from the Tickets list).
Future<void> recordTicketHandover({
  required String transactionId,
  required String handoverByUserId,
}) async {
  await ProxyService.getStrategy(Strategy.capella).updateTransaction(
    transactionId: transactionId,
    status: COMPLETE,
    handoverBy: handoverByUserId,
    handoverAt: DateTime.now().toUtc(),
    requireCurrentStatus: AWAITING_HANDOVER,
  );
}
