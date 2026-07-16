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

/// Batch payment sums for all visible tickets (one query per stream update).
@riverpod
Future<Map<String, double>> ticketsPaymentSums(Ref ref) async {
  final tickets = await ref.watch(ticketsStreamProvider.future);
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

@riverpod
Stream<List<ITransaction>> ticketsStream(Ref ref) {
  final capellaStrategy = ProxyService.getStrategy(Strategy.capella);
  final branchId = ProxyService.box.getBranchId();

  // Till roles see the full branch queue; staff see only their own tickets.
  // Use the same ownership-aware decision as the Collect button/Pay controls
  // (canCollectPosPaymentProvider) — an owner whose tenant.type is null/"Agent"
  // still qualifies via business ownership, so the cashier's sent tickets show.
  final canCollect = ref.watch(canCollectPosPaymentProvider);

  return capellaStrategy
      .openPosTicketsTransactionsStream(
        branchId: branchId,
        removeAdjustmentTransactions: true,
        forceRealData: true,
        skipOriginalTransactionCheck: false,
        restrictToCurrentAgent: !canCollect,
      )
      .map((tickets) {
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
      })
      .handleError((e, st) {
        talker.error('Ticket stream error: $e', st);
        throw e;
      });
}

/// PARKED tickets awaiting till collection — drives the Tickets button badge.
final pendingTillTicketsCountProvider = Provider<int>((ref) {
  final tickets = ref.watch(ticketsStreamProvider).asData?.value ?? const [];
  return tickets
      .where((t) => (t.status ?? '').toLowerCase() == PARKED)
      .length;
});
