import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tickets_provider.g.dart';

List<ITransaction> _sortOpenTickets(List<ITransaction> tickets) {
  final marked = tickets.map((ticket) {
    ticket.dataSource = Strategy.capella;
    return ticket;
  }).toList();

  marked.sort((a, b) {
    final priority = <String, int>{
      WAITING: 3,
      PARKED: 2,
      IN_PROGRESS: 1,
    };
    final aPrio = priority[a.status] ?? 0;
    final bPrio = priority[b.status] ?? 0;
    if (aPrio != bPrio) return bPrio.compareTo(aPrio);

    final aDate = a.createdAt ?? DateTime(1970);
    final bDate = b.createdAt ?? DateTime(1970);
    return bDate.compareTo(aDate);
  });

  return marked;
}

List<ITransaction> _filterTicketsForRole(
  List<ITransaction> tickets, {
  required bool canCollect,
  required String? agentId,
}) {
  if (canCollect || agentId == null || agentId.isEmpty) return tickets;
  return tickets.where((t) => t.agentId == agentId).toList();
}

/// Batch payment sums for all visible tickets (one query per stream update).
@riverpod
Future<Map<String, double>> ticketsPaymentSums(Ref ref) async {
  final ticketsAsync = ref.watch(visibleTicketsProvider);
  final tickets = ticketsAsync.value;
  if (tickets == null) {
    // First load: wait for the branch stream so sums stay in sync with the list.
    await ref.watch(ticketsStreamProvider.future);
    final after = ref.read(visibleTicketsProvider).value ?? const [];
    return _paymentSumsForTickets(after);
  }
  return _paymentSumsForTickets(tickets);
}

Future<Map<String, double>> _paymentSumsForTickets(
  List<ITransaction> tickets,
) async {
  final ids = tickets.map((t) => t.id).where((id) => id.isNotEmpty).toList();
  if (ids.isEmpty) return {};

  final branchId = ProxyService.box.getBranchId() ?? '';
  if (branchId.isEmpty) return {};

  final sums = await getPaymentSumsByTransactionIdsChunked(
    ids,
    branchId: branchId,
  );
  return {for (final e in sums.entries) e.key: e.value.byHand};
}

/// Branch-wide open tickets stream (PARKED / WAITING / IN_PROGRESS).
///
/// Does **not** watch [canCollectPosPaymentProvider] — that async role used to
/// tear down and recreate the Ditto observer (losing emits; badge flashed to 0).
/// Staff vs till filtering happens in [visibleTicketsProvider].
@riverpod
Stream<List<ITransaction>> ticketsStream(Ref ref) {
  final capellaStrategy = ProxyService.getStrategy(Strategy.capella);
  final branchId = ProxyService.box.getBranchId();

  return capellaStrategy
      .openPosTicketsTransactionsStream(
        branchId: branchId,
        removeAdjustmentTransactions: true,
        forceRealData: true,
        skipOriginalTransactionCheck: false,
        restrictToCurrentAgent: false,
      )
      .map(_sortOpenTickets)
      .handleError((e, st) {
        talker.error('Ticket stream error: $e', st);
        throw e;
      });
}

/// Tickets visible to the current POS role (full branch queue for till roles,
/// own tickets only for staff). Keeps prior data while the stream reloads.
final visibleTicketsProvider = Provider<AsyncValue<List<ITransaction>>>((ref) {
  final asyncTickets = ref.watch(ticketsStreamProvider);
  final canCollect = ref.watch(canCollectPosPaymentProvider);
  final agentId = ProxyService.box.getUserId();

  return asyncTickets.whenData(
    (tickets) => _filterTicketsForRole(
      tickets,
      canCollect: canCollect,
      agentId: agentId,
    ),
  );
});

/// PARKED tickets awaiting till collection — drives the Tickets button badge.
///
/// Uses [AsyncValue.value] (not [AsyncValue.asData]) so a reload keeps the
/// previous count instead of flashing to 0.
final pendingTillTicketsCountProvider = Provider<int>((ref) {
  final tickets = ref.watch(visibleTicketsProvider).value ?? const [];
  return tickets
      .where((t) => (t.status ?? '').toLowerCase() == PARKED)
      .length;
});

/// Ticket Review + Handover workflow: branch-wide tickets awaiting reviewer
/// sign-off (`pendingReview`). Deliberately separate from [ticketsStream] —
/// these tickets do not appear in the normal Tickets list.
@riverpod
Stream<List<ITransaction>> reviewQueueStream(Ref ref) {
  final capellaStrategy = ProxyService.getStrategy(Strategy.capella);
  final branchId = ProxyService.box.getBranchId();

  return capellaStrategy
      .reviewQueueTransactionsStream(
        branchId: branchId,
        removeAdjustmentTransactions: true,
        forceRealData: true,
        skipOriginalTransactionCheck: false,
      )
      .handleError((e, st) {
        talker.error('Review queue stream error: $e', st);
        throw e;
      });
}

/// Review Queue badge count. Uses [AsyncValue.value] so a reload keeps the
/// previous count instead of flashing to 0 (same rationale as
/// [pendingTillTicketsCountProvider]).
final reviewQueueCountProvider = Provider<int>((ref) {
  return ref.watch(reviewQueueStreamProvider).value?.length ?? 0;
});
