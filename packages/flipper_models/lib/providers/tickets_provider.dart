import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/sync/ditto_observer_utils.dart';
import 'package:flipper_models/sync/transaction_payment_records_sync.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_web/services/ditto_service.dart';
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
    final aPrio = priority[(a.status ?? '').toLowerCase()] ?? 0;
    final bPrio = priority[(b.status ?? '').toLowerCase()] ?? 0;
    if (aPrio != bPrio) return bPrio.compareTo(aPrio);

    final aDate = a.createdAt ?? DateTime(1970);
    final bDate = b.createdAt ?? DateTime(1970);
    return bDate.compareTo(aDate);
  });

  return marked;
}

List<ITransaction> _filterTicketsForRole(
  List<ITransaction> tickets, {
  required bool canViewAll,
  required String? agentId,
}) {
  if (canViewAll || agentId == null || agentId.isEmpty) return tickets;
  return tickets.where((t) => (t.agentId ?? '') == agentId).toList();
}

/// Wait until session box has a branch (startup / login race), matching
/// [pendingTransactionStream].
Future<String?> _waitForBranchId() async {
  String? branchId = ProxyService.box.getBranchId();
  const maxAttempts = 50;
  var attempt = 0;
  while ((branchId == null || branchId.isEmpty) && attempt < maxAttempts) {
    await Future.delayed(const Duration(milliseconds: 100));
    branchId = ProxyService.box.getBranchId();
    attempt++;
  }
  return branchId;
}

/// Batch payment sums for all visible tickets.
///
/// Streams so peer machines refresh PAID / Partial when
/// `transaction_payment_records` arrive via Ditto (ticket rows alone do not
/// re-emit when only tender lines sync).
@riverpod
Stream<Map<String, double>> ticketsPaymentSums(Ref ref) async* {
  final ticketsAsync = ref.watch(visibleTicketsProvider);
  List<ITransaction> tickets = ticketsAsync.value ?? const [];
  if (ticketsAsync.value == null) {
    // First load: wait for the branch stream so sums stay in sync with the list.
    await ref.watch(ticketsStreamProvider.future);
    tickets = ref.read(visibleTicketsProvider).value ?? const [];
  }

  final branchId = ProxyService.box.getBranchId() ?? '';
  if (branchId.isEmpty) {
    yield const {};
    return;
  }

  final ditto = DittoService.instance.dittoInstance;
  if (ditto != null) {
    ensureTransactionPaymentRecordsSyncSubscription(ditto);
  }

  Future<Map<String, double>> loadSums() => _paymentSumsForTickets(tickets);

  yield await loadSums();

  if (ditto == null) return;

  final controller = StreamController<void>();
  dynamic observer;
  try {
    observer = ditto.store.registerObserver(
      kTransactionPaymentRecordsAllSql,
      onChange: (_) {
        if (!controller.isClosed) controller.add(null);
      },
    );
    ref.onDispose(() {
      unawaited(cancelDittoStoreObserver(observer));
      if (!controller.isClosed) {
        unawaited(controller.close());
      }
    });

    await for (final _ in controller.stream) {
      yield await loadSums();
    }
  } catch (e, s) {
    talker.warning('ticketsPaymentSums: payment observer failed: $e', s);
  }
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
///
/// Watches [activeBranchProvider] and waits for [branchId] so the Ditto sync
/// subscription is never registered with a null branch (which would miss
/// cross-device parked tickets for the whole session).
@riverpod
Stream<List<ITransaction>> ticketsStream(Ref ref) async* {
  // Re-subscribe when the active branch changes (startup / branch switch).
  ref.watch(activeBranchProvider);

  final branchId = await _waitForBranchId();
  if (branchId == null || branchId.isEmpty) {
    talker.error('ticketsStream: no branchId after wait');
    yield const <ITransaction>[];
    return;
  }

  final capellaStrategy = ProxyService.getStrategy(Strategy.capella);
  yield* capellaStrategy
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
  // canCollectPosPaymentProvider rebuilds on access/tenant changes and re-reads
  // the box user id; keep agent filter in lockstep with that decision.
  final agentId = ProxyService.box.getUserId();

  // Till roles see the full branch queue; so do reviewers (TicketReview access)
  // for oversight — read-only, since collecting still requires canCollect.
  // Regular staff continue to see only their own tickets.
  final canViewAll = canCollect ||
      ref.watch(
        featureViewAccessProvider(
          userId: agentId ?? '',
          featureName: AppFeature.TicketReview,
        ),
      );

  return asyncTickets.whenData(
    (tickets) => _filterTicketsForRole(
      tickets,
      canViewAll: canViewAll,
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
Stream<List<ITransaction>> reviewQueueStream(Ref ref) async* {
  ref.watch(activeBranchProvider);

  final branchId = await _waitForBranchId();
  if (branchId == null || branchId.isEmpty) {
    talker.error('reviewQueueStream: no branchId after wait');
    yield const <ITransaction>[];
    return;
  }

  final capellaStrategy = ProxyService.getStrategy(Strategy.capella);
  yield* capellaStrategy
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
