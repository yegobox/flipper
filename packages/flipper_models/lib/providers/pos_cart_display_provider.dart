import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:hooks_riverpod/hooks_riverpod.dart';

bool _posCartIsExpense() => ProxyService.box.isOrdering() ?? false;

/// Bumped on every cart tap so [posCartDisplayItemsProvider] recomputes same frame.
final posCartDisplayEpochProvider = StateProvider<int>((ref) => 0);

/// When set, pending-cart cache/stream reconciliation must not switch to another txn.
///
/// Used by mobile checkout and ticket resume so [posCartStreamReconciliationProvider]
/// does not replace the sale with a freshly auto-created empty pending cart.
final pinnedPosCartTransactionIdProvider = StateProvider<String?>((ref) => null);

/// Transaction id of the sale that just completed. While set, the cart shows
/// empty for that id across every consumer (list, totals, badges) in the same
/// frame — instead of lingering until the Ditto stream/pending providers
/// reconcile. Cleared once a different pending transaction becomes active (the
/// next sale), so a completed id is never permanently suppressed.
final suppressedCartTransactionIdProvider =
    StateProvider<String?>((ref) => null);

void bumpPosCartDisplayEpoch(Ref ref) {
  ref.read(posCartDisplayEpochProvider.notifier).update((n) => n + 1);
}

/// Pending sale/purchase id for cart merge — cache first, then stream (id only).
final posCartPendingTransactionIdProvider = Provider.family<String?, bool>((
  ref,
  isExpense,
) {
  final pinned = ref.watch(pinnedPosCartTransactionIdProvider);
  if (pinned != null && pinned.isNotEmpty) return pinned;

  final cacheId = ref.watch(
    cachedPendingCartTransactionProvider(isExpense).select((t) => t?.id),
  );
  if (cacheId != null && cacheId.isNotEmpty) return cacheId;

  final streamId = ref.watch(
    pendingTransactionStreamProvider(isExpense: isExpense)
        .select((a) => a.asData?.value.id),
  );
  if (streamId != null && streamId.isNotEmpty) return streamId;

  final optId = ref.watch(
    optimisticCartProvider.select((s) => s.activeTransactionId),
  );
  if (optId == null || optId.isEmpty || OptimisticCartBootstrap.isBootstrap(optId)) {
    return null;
  }
  return optId;
});

/// Settling session for the cart on screen: the live hand-off when one is set,
/// else one rebuilt from the resumed ticket itself.
///
/// [settlingTillTicketProvider] lives only in memory, so anything that drops it
/// mid-collection (a web reload, an app restart, a re-created provider scope)
/// left the resumed ticket rendering as a plain cart — no settling banner and,
/// with it, no "Back to new sale". Read this wherever the banner / return action
/// is shown so both are always available for a resumed ticket; Pay binding and
/// cart scoping still key off the live session only.
///
/// Reads the pending-cart rows the checkout already observes (cache, then
/// stream) rather than opening another [transactionByIdProvider] observer on
/// the POS hot path.
final effectiveSettlingTillTicketProvider = Provider<SettlingTillTicket?>((ref) {
  final live = ref.watch(settlingTillTicketProvider);
  if (live != null) return live;

  // Purchases (ordering mode) never go through the till queue.
  if (_posCartIsExpense()) return null;

  final pinnedId = ref.watch(pinnedPosCartTransactionIdProvider);
  final candidates = <ITransaction?>[
    ref.watch(cachedPendingCartTransactionProvider(false)),
    ref.watch(pendingTransactionStreamProvider(isExpense: false)).asData?.value,
  ];
  final row = candidates.firstWhere(
    (t) =>
        t != null &&
        t.id.isNotEmpty &&
        (pinnedId == null || pinnedId.isEmpty || t.id == pinnedId),
    orElse: () => null,
  );
  if (row == null) return null;

  // A just-settled / just-re-parked ticket is suppressed before its row leaves
  // PENDING; recovering from it would flash the banner back on.
  if (ref.watch(suppressedCartTransactionIdProvider) == row.id) return null;

  return recoverSettlingTillTicketFromResumedCart(row);
});

/// Transaction id used to merge Ditto line items with optimistic ghosts.
final posCartMergeTxnIdProvider = Provider.family<String, bool>((ref, isExpense) {
  final pendingId = ref.watch(posCartPendingTransactionIdProvider(isExpense));
  final optimisticId = ref.watch(
    optimisticCartProvider.select((s) => s.activeTransactionId),
  );
  final preferBootstrap = ref.watch(
    optimisticCartProvider.select(
      (s) => s.pendingQtyByVariantId.values.any((q) => q > 0),
    ),
  );
  return cartTransactionIdForMergeIds(
    pendingTransactionId: pendingId,
    optimisticTransactionId: optimisticId,
    preferBootstrapWhilePending: preferBootstrap,
  );
});

/// Whether an emitted pending cart may replace the one currently on screen.
///
/// Pure so the rule can be tested without Ditto. The rule exists because the
/// pending-cart observer emits `items.first ORDER BY lastTouched DESC`: a row
/// minted a moment ago outranks the cart the cashier is filling, so adopting
/// every emission let a freshly minted empty cart wipe a cart full of lines.
bool shouldAdoptEmittedPendingCart({
  required String currentCartId,
  required String incomingCartId,
  required bool currentHasLines,
  required bool incomingHasLines,
  String? suppressedCartId,
  required bool completing,
}) {
  if (incomingCartId.isEmpty) return false;
  if (currentCartId.isEmpty || currentCartId == incomingCartId) return true;
  // Completion hand-off: the sold cart is suppressed and must be handed over.
  if (suppressedCartId != null &&
      suppressedCartId.isNotEmpty &&
      suppressedCartId == currentCartId) {
    return true;
  }
  if (completing) return true;
  // The only refusal: a cart with lines being replaced by an empty one.
  if (currentHasLines && !incomingHasLines) return false;
  return true;
}

/// Drops the cached cart when it is no longer a PENDING row.
///
/// Pairs with the "refuse to swap an active cart" guard below: the guard is only
/// safe because a cart that has actually left PENDING stops being defended.
Future<void> _releaseCachedCartIfNotPending(
  Ref ref, {
  required bool isExpense,
  required String transactionId,
}) async {
  try {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) return;
    final txn = await ProxyService.getStrategy(
      Strategy.capella,
    ).getTransaction(id: transactionId, branchId: branchId);
    if (txn != null && txn.status == PENDING) return;
    talker.warning(
      'posCartStreamReconciliation: held cart $transactionId is '
      '${txn == null ? "gone" : "status=${txn.status}"} — releasing it so the '
      'next pending cart can take over.',
    );
    clearCachedPendingCartTransaction(ref, isExpense: isExpense);
  } catch (e, s) {
    talker.warning(
      'posCartStreamReconciliation: could not verify held cart '
      '$transactionId: $e\n$s',
    );
  }
}

/// Side-effect wiring: cache + bind bootstrap → real id + stream reconciliation.
/// Subscribed via [ref.listen] from checkout (not [ref.watch]) to avoid extra rebuilds.
final posCartStreamReconciliationProvider = Provider<void>((ref) {
  ref.keepAlive();

  final isExpense = _posCartIsExpense();
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);

  /// Lines the cashier can see for [transactionId]: saved rows plus ghosts.
  bool cartHasLines(String transactionId) {
    if (transactionId.isEmpty) return false;
    if (ref
        .read(optimisticCartProvider.notifier)
        .hasPendingFor(transactionId)) {
      return true;
    }
    final cached = readCachedPendingCartTransaction(ref, isExpense: isExpense);
    final cachedBranch = cached?.branchId?.trim();
    final rowsBranchId = cachedBranch != null && cachedBranch.isNotEmpty
        ? cachedBranch
        : (ProxyService.box.getBranchId() ?? '0');
    final rows = ref
        .read(
          transactionItemsStreamProvider(
            transactionId: transactionId,
            branchId: rowsBranchId,
          ),
        )
        .value;
    return rows != null && rows.any((i) => i.active != false);
  }

  void syncPendingTransaction(ITransaction txn) {
    final pinned = ref.read(pinnedPosCartTransactionIdProvider);
    if (pinned != null && pinned.isNotEmpty && txn.id != pinned) {
      return;
    }

    // Never let a cart the cashier is filling be replaced by an empty one.
    //
    // The observer behind this stream emits `items.first ORDER BY lastTouched
    // DESC`, so a PENDING row minted a moment ago outranks the cart in front of
    // the operator. That is exactly what happens when replication makes the
    // pending query blink empty: `_ensureNextPendingCartIfNeeded` mints a second
    // id, it wins the ordering, and adopting it here re-resolved the display to
    // an empty sale — 57 scanned lines vanishing in one frame, orphaned on the
    // old id. A genuine switch (a cart that itself has lines) is still adopted.
    final current = readCachedPendingCartTransaction(ref, isExpense: isExpense);
    final currentId = current?.id ?? '';
    if (currentId.isNotEmpty && currentId != txn.id) {
      if (!shouldAdoptEmittedPendingCart(
        currentCartId: currentId,
        incomingCartId: txn.id,
        currentHasLines: cartHasLines(currentId),
        incomingHasLines: cartHasLines(txn.id),
        suppressedCartId: ref.read(suppressedCartTransactionIdProvider),
        completing:
            ProxyService.box.readBool(key: 'transactionCompleting') ?? false,
      )) {
        talker.warning(
          'posCartStreamReconciliation: refusing to swap the active cart '
          '$currentId (has lines) for empty pending ${txn.id}. Keeping the '
          'cart on screen; verifying the held cart is still pending.',
        );
        // Self-heal: if the cart we just defended is not actually PENDING any
        // more, release it so the next emission is adopted. Without this a
        // stale cached id could hold the till on a dead cart.
        unawaited(
          _releaseCachedCartIfNotPending(
            ref,
            isExpense: isExpense,
            transactionId: currentId,
          ),
        );
        return;
      }
    }
    // A different pending sale is now active — stop suppressing the previously
    // completed one (it will never come back as the cart, so this is the only
    // place the flag needs clearing).
    final suppressed = ref.read(suppressedCartTransactionIdProvider);
    if (suppressed != null && suppressed.isNotEmpty && suppressed != txn.id) {
      Future.microtask(
        () =>
            ref.read(suppressedCartTransactionIdProvider.notifier).state = null,
      );
    }
    scheduleWriteCachedPendingCartTransaction(
      ref,
      isExpense: isExpense,
      transaction: txn,
    );
    Future.microtask(
      () => ref
          .read(optimisticCartProvider.notifier)
          .bindPendingTransaction(txn.id),
    );
  }

  ref.listen(pendingProv, (_, next) {
    if (next.hasValue && next.value != null) {
      syncPendingTransaction(next.value!);
    }
  }, fireImmediately: true);

  final pendingId = ref.watch(posCartPendingTransactionIdProvider(isExpense));
  if (pendingId == null || pendingId.isEmpty) {
    return;
  }

  final cachedTxn = readCachedPendingCartTransaction(ref, isExpense: isExpense);
  final cachedBranch = cachedTxn?.branchId?.trim();
  final itemsBranchId = cachedBranch != null && cachedBranch.isNotEmpty
      ? cachedBranch
      : (ProxyService.box.getBranchId() ?? '0');
  final itemsProv = transactionItemsStreamProvider(
    transactionId: pendingId,
    branchId: itemsBranchId,
  );

  ref.listen(itemsProv, (_, next) {
    if (!next.hasValue) return;
    final items = next.value!;
    Future.microtask(
      () => ref.read(optimisticCartProvider.notifier).onStreamEmitted(
            transactionId: pendingId,
            items: items,
          ),
    );
  }, fireImmediately: true);
});

/// Single cart list for checkout UI: Ditto rows + unresolved optimistic qty.
final posCartDisplayItemsProvider = Provider<List<TransactionItem>>((ref) {
  ref.keepAlive();

  // While a till role settles a queued ticket, the whole checkout acts on that
  // ticket — not the collector's own (usually empty) pending cart. Source the
  // lines straight from the ticket's item stream so totals, the payment gate,
  // and completion hints all see it. Read-only; no optimistic merge needed.
  final settling = ref.watch(settlingTillTicketProvider);
  if (settling != null && settling.transactionId.isNotEmpty) {
    final settlingBranchId =
        (settling.branchId != null && settling.branchId!.isNotEmpty)
            ? settling.branchId!
            : (ProxyService.box.getBranchId() ?? '0');
    // The live Ditto stream is the source of truth once it warms up, but on a
    // cold subscription it resolves AsyncLoading first — so fall back to the
    // items pre-fetched at Collect time (settling.seedItems) so the cart paints
    // instantly instead of flashing empty. Settling is read-only, so the
    // ticket's lines don't legitimately empty out mid-settle; prefer the seed
    // until the stream actually has rows.
    final streamItems = ref
            .watch(
              transactionItemsStreamProvider(
                transactionId: settling.transactionId,
                branchId: settlingBranchId,
              ),
            )
            .asData
            ?.value ??
        const <TransactionItem>[];
    final scoped =
        streamItems.isNotEmpty ? streamItems : settling.seedItems;
    return scoped.where((i) => i.active != false).toList();
  }

  final isExpense = _posCartIsExpense();
  final optimisticState = ref.watch(optimisticCartProvider);
  final hasPending =
      optimisticState.pendingQtyByVariantId.values.any((q) => q > 0);

  final pendingId = ref.watch(posCartPendingTransactionIdProvider(isExpense));
  final mergeTxnId = ref.watch(posCartMergeTxnIdProvider(isExpense));
  final pinnedTxnId = ref.watch(pinnedPosCartTransactionIdProvider);
  final branchId = ProxyService.box.getBranchId() ?? '0';
  final cachedPending =
      readCachedPendingCartTransaction(ref, isExpense: isExpense);
  // Prefer the pending cart's own branch (where saveTransactionItem wrote
  // lines). Using only the box branch made the stream show rows while a
  // branch-scoped completion poll for transaction.branchId returned [].
  final cachedBranch = cachedPending?.branchId?.trim();
  final mergeBranchId = pinnedTxnId != null && pinnedTxnId.isNotEmpty
      ? (cachedBranch != null && cachedBranch.isNotEmpty
          ? cachedBranch
          : branchId)
      : (cachedBranch != null && cachedBranch.isNotEmpty
          ? cachedBranch
          : branchId);

  final txnIdForMerge = (pendingId != null && pendingId.isNotEmpty)
      ? pendingId
      : mergeTxnId;

  // A sale just completed: hide its lines immediately, even while the stream /
  // pending providers still point at it. The next sale uses a different id.
  final suppressedTxnId = ref.watch(suppressedCartTransactionIdProvider);
  if (suppressedTxnId != null &&
      suppressedTxnId.isNotEmpty &&
      (suppressedTxnId == txnIdForMerge ||
          suppressedTxnId == mergeTxnId ||
          suppressedTxnId == pendingId)) {
    return const [];
  }

  if (txnIdForMerge.isEmpty && !hasPending) return const [];

  // In-flight taps: sync-read last stream snapshot (no Ditto wait), merge ghosts.
  if (hasPending) {
    final cachedStream = txnIdForMerge.isEmpty ||
            OptimisticCartBootstrap.isBootstrap(txnIdForMerge)
        ? const <TransactionItem>[]
        : (ref
                .read(
                  transactionItemsStreamProvider(
                    transactionId: txnIdForMerge,
                    branchId: mergeBranchId,
                  ),
                )
                .value ??
            const <TransactionItem>[]);
    return mergeTransactionItemsWithOptimisticCart(
      streamItems: cachedStream,
      optimistic: optimisticState,
      transactionId: txnIdForMerge,
    );
  }

  if (mergeTxnId.isEmpty) return const [];

  final streamAsync = ref.watch(
    transactionItemsStreamProvider(
      transactionId: mergeTxnId,
      branchId: mergeBranchId,
    ),
  );

  List<TransactionItem> merge(List<TransactionItem> raw) =>
      mergeTransactionItemsWithOptimisticCart(
        streamItems: raw,
        optimistic: optimisticState,
        transactionId: mergeTxnId,
      );

  return streamAsync.when(
    data: (raw) {
      if (raw.isEmpty) {
        // Normal between sales and on a freshly minted cart, so debug: at
        // warning this fired on every rebuild of an empty cart.
        talker.debug(
          'posCartDisplayItemsProvider: no-pending branch, '
          'transactionItemsStreamProvider(txn=$mergeTxnId, branch=$mergeBranchId) '
          'has 0 rows this frame — cart will render empty unless another '
          'source has lines.',
        );
      }
      return merge(raw);
    },
    loading: () {
      // Every cold subscription passes through here (checkout open, branch
      // switch); it is not a fault.
      talker.debug(
        'posCartDisplayItemsProvider: no-pending branch, '
        'transactionItemsStreamProvider(txn=$mergeTxnId, branch=$mergeBranchId) '
        'is still loading — rendering empty rows this frame.',
      );
      return merge(const []);
    },
    error: (e, _) {
      talker.warning(
        'posCartDisplayItemsProvider: no-pending branch, '
        'transactionItemsStreamProvider(txn=$mergeTxnId, branch=$mergeBranchId) '
        'errored: $e — rendering empty rows this frame.',
      );
      return merge(const []);
    },
  );
});

/// Lightweight cart metrics for catalog chrome (avoids rebuilding the product grid).
class PosCartSummary {
  const PosCartSummary({
    this.activeLineCount = 0,
    this.unitQtyTotal = 0,
    this.lineSubtotal = 0,
    this.lineTax = 0,
  });

  final int activeLineCount;
  final int unitQtyTotal;
  final double lineSubtotal;
  final double lineTax;

  bool get isNotEmpty => activeLineCount > 0;
}

PosCartSummary computePosCartSummary(List<TransactionItem> items) {
  final active = items.where((i) => i.active != false).toList();
  var lineSub = 0.0;
  var lineTax = 0.0;
  var qty = 0;
  for (final it in active) {
    lineSub += (it.price * it.qty).toDouble();
    lineTax += (it.taxAmt ?? 0).toDouble();
    qty += it.qty.round();
  }
  return PosCartSummary(
    activeLineCount: active.length,
    unitQtyTotal: qty,
    lineSubtotal: lineSub,
    lineTax: lineTax,
  );
}

final posCartSummaryProvider = Provider<PosCartSummary>((ref) {
  return computePosCartSummary(ref.watch(posCartDisplayItemsProvider));
});

/// Bumps when cart line totals change — for payment chrome without full epoch.
final posCartPaymentRefreshSignalProvider = Provider<double>((ref) {
  final s = ref.watch(posCartSummaryProvider);
  return s.lineSubtotal + s.lineTax;
});

/// Per-variant qty for catalog badges. While optimistic qty is pending, derive
/// from [optimisticCartProvider] only so the product grid does not watch Ditto.
final posCartQtyByVariantIdProvider = Provider<Map<String, int>>((ref) {
  final optimistic = ref.watch(optimisticCartProvider);
  final hasPending =
      optimistic.pendingQtyByVariantId.values.any((q) => q > 0);
  if (hasPending) {
    final out = <String, int>{};
    final keys = <String>{
      ...optimistic.pendingQtyByVariantId.keys,
      ...optimistic.lastStreamQtySumByVariantId.keys,
    };
    for (final vid in keys) {
      final q = (optimistic.lastStreamQtySumByVariantId[vid] ?? 0) +
          (optimistic.pendingQtyByVariantId[vid] ?? 0);
      if (q > 0) out[vid] = q.round();
    }
    return out;
  }

  final items = ref.watch(posCartDisplayItemsProvider);
  final out = <String, int>{};
  for (final it in items) {
    if (it.active == false) continue;
    final vid = it.variantId;
    if (vid == null || vid.isEmpty) continue;
    out[vid] = (out[vid] ?? 0) + it.qty.round();
  }
  return out;
});

/// Per-variant in-cart qty for catalog tiles — only this variant rebuilds on tap.
final posCartQtyForVariantProvider = Provider.family<int, String>((
  ref,
  variantId,
) {
  if (variantId.isEmpty) return 0;

  final hasPending = ref.watch(
    optimisticCartProvider.select(
      (s) => s.pendingQtyByVariantId.values.any((q) => q > 0),
    ),
  );
  if (hasPending) {
    final streamQty = ref.watch(
      optimisticCartProvider.select(
        (s) => s.lastStreamQtySumByVariantId[variantId] ?? 0,
      ),
    );
    final pending = ref.watch(
      optimisticCartProvider.select(
        (s) => s.pendingQtyByVariantId[variantId] ?? 0,
      ),
    );
    final q = streamQty + pending;
    return q > 0 ? q.round() : 0;
  }

  return ref.watch(
    posCartDisplayItemsProvider.select((items) {
      var sum = 0;
      for (final it in items) {
        if (it.active == false) continue;
        if (it.variantId != variantId) continue;
        sum += it.qty.round();
      }
      return sum;
    }),
  );
});

/// Merged cart lines for a specific transaction (e.g. mobile checkout screen).
List<TransactionItem> posCartDisplayItemsForTransaction(
  List<TransactionItem> merged,
  String transactionId,
) {
  if (transactionId.isEmpty) return const [];
  return merged
      .where(
        (i) =>
            i.active != false &&
            (i.transactionId == transactionId ||
                OptimisticCartIds.isOptimistic(i.id)),
      )
      .toList();
}

/// Checkout lines for a known transaction: merged cart first, then Ditto stream.
///
/// After resuming a parked ticket, [posCartDisplayItemsProvider] can still point
/// at another pending row until the stream catches up; the stream for
/// [transactionId] is the source of truth for that sale.
List<TransactionItem> checkoutLineItemsForTransaction({
  required List<TransactionItem> mergedCart,
  required String transactionId,
  List<TransactionItem>? streamItems,
}) {
  final fromMerged =
      posCartDisplayItemsForTransaction(mergedCart, transactionId);
  if (fromMerged.isNotEmpty) return fromMerged;
  if (streamItems == null || streamItems.isEmpty) return const [];
  final active = streamItems.where((i) => i.active != false).toList();
  if (active.isEmpty) return const [];
  final linked = active
      .where(
        (i) =>
            i.transactionId == null ||
            i.transactionId!.isEmpty ||
            i.transactionId == transactionId,
      )
      .toList();
  return linked.isNotEmpty ? linked : active;
}

/// Line items for [MobileCheckoutScreen]: stream-first unless optimistic taps pending.
List<TransactionItem> resolveMobileCheckoutLineItems({
  required String transactionId,
  required List<TransactionItem> mergedCart,
  required List<TransactionItem>? scopedStreamItems,
  required bool hasOptimisticPendingForTxn,
}) {
  if (transactionId.isEmpty) return const [];
  if (hasOptimisticPendingForTxn) {
    return checkoutLineItemsForTransaction(
      mergedCart: mergedCart,
      transactionId: transactionId,
      streamItems: scopedStreamItems,
    );
  }
  final stream = scopedStreamItems ?? const <TransactionItem>[];
  final activeStream = stream.where((i) => i.active != false).toList();
  if (activeStream.isNotEmpty) return activeStream;
  return checkoutLineItemsForTransaction(
    mergedCart: mergedCart,
    transactionId: transactionId,
    streamItems: scopedStreamItems,
  );
}

/// Pins pending-cart providers to [transaction] (resume / dedicated checkout).
///
/// Deferred to the next microtask so callers in [initState] / build do not trip
/// Riverpod's "modify provider while building" guard on [cachedPendingCartTransactionProvider].
void _primePosCartForTransactionContainer(
  ProviderContainer container, {
  required bool isExpense,
  required ITransaction transaction,
}) {
  final id = transaction.id;
  final txn = transaction;
  Future.microtask(() {
    // [transaction] is being revived as the active cart, so any suppression left
    // on it — from the park / send-to-till / completion that hid it earlier —
    // must go first, or the pinned cart renders empty and nothing can release
    // the flag again. See [clearSuppressedCartTransactionIfContainer].
    clearSuppressedCartTransactionIfContainer(container, transactionId: id);
    container.read(pinnedPosCartTransactionIdProvider.notifier).state = id;
    writeCachedPendingCartTransactionContainer(
      container,
      isExpense: isExpense,
      transaction: txn,
    );
    container.read(optimisticCartProvider.notifier).bindPendingTransaction(id);
  });
}

void primePosCartForTransaction(
  Ref ref, {
  required bool isExpense,
  required ITransaction transaction,
}) {
  _primePosCartForTransactionContainer(
    ref.container,
    isExpense: isExpense,
    transaction: transaction,
  );
}

/// [WidgetRef] variant — not assignable to [Ref] in this Riverpod version.
void primePosCartForTransactionWidget(
  WidgetRef ref, {
  required bool isExpense,
  required ITransaction transaction,
}) {
  _primePosCartForTransactionContainer(
    ref.container,
    isExpense: isExpense,
    transaction: transaction,
  );
}

/// Clears the resume/checkout cart pin without a live [WidgetRef] (safe in [dispose]).
void clearPinnedPosCartTransactionContainer(ProviderContainer container) {
  container.read(pinnedPosCartTransactionIdProvider.notifier).state = null;
}

void clearPinnedPosCartTransaction(Ref ref) {
  clearPinnedPosCartTransactionContainer(ref.container);
}

void clearPinnedPosCartTransactionWidget(WidgetRef ref) {
  clearPinnedPosCartTransactionContainer(ref.container);
}

/// Drops the cart pin only when it still points at [transactionId].
///
/// The pin outranks the pending-cart cache in
/// [posCartPendingTransactionIdProvider], and — unlike that cache, which refuses
/// any non-`PENDING` row — it holds a bare id that is never re-validated against
/// the transaction's status. So a pin left behind on a sale that has since
/// completed (or been parked) keeps resolving the cart to that transaction's
/// line items, which stay `active: true` in Ditto forever.
/// [suppressedCartTransactionIdProvider] hides them, but the moment suppression
/// is released the finished sale's lines reappear and cannot be cleared without
/// an app restart (this provider is not autoDispose).
///
/// Returns true when a stale pin was actually dropped.
bool clearPinnedPosCartTransactionIfContainer(
  ProviderContainer container, {
  required String transactionId,
}) {
  if (transactionId.isEmpty) return false;
  final pinned = container.read(pinnedPosCartTransactionIdProvider);
  if (pinned == null || pinned.isEmpty || pinned != transactionId) return false;
  container.read(pinnedPosCartTransactionIdProvider.notifier).state = null;
  return true;
}

/// Drops cart suppression when it still points at [transactionId].
///
/// Mirror of [clearPinnedPosCartTransactionIfContainer] for the *other* flag
/// that blanks the cart. [suppressedCartTransactionIdProvider] has exactly one
/// release site — `syncPendingTransaction` in
/// [posCartStreamReconciliationProvider] — and it only fires when a
/// **different** pending row becomes active. Resuming a parked ticket makes
/// that same id both the pinned cart and the emitted pending row, so the guard
/// can never fire: the ticket's lines stay hidden (the provider short-circuits
/// to `const []`) until the app restarts. Park / send-to-till / completion all
/// suppress the id the operator may resume next, so reviving a transaction as
/// the cart must always release it.
///
/// Returns true when stale suppression was actually dropped.
bool clearSuppressedCartTransactionIfContainer(
  ProviderContainer container, {
  required String transactionId,
}) {
  if (transactionId.isEmpty) return false;
  final suppressed = container.read(suppressedCartTransactionIdProvider);
  if (suppressed == null ||
      suppressed.isEmpty ||
      suppressed != transactionId) {
    return false;
  }
  container.read(suppressedCartTransactionIdProvider.notifier).state = null;
  return true;
}

bool clearPinnedPosCartTransactionIf(Ref ref, {required String transactionId}) {
  return clearPinnedPosCartTransactionIfContainer(
    ref.container,
    transactionId: transactionId,
  );
}

/// [WidgetRef] variant — not assignable to [Ref] in this Riverpod version.
bool clearPinnedPosCartTransactionIfWidget(
  WidgetRef ref, {
  required String transactionId,
}) {
  return clearPinnedPosCartTransactionIfContainer(
    ref.container,
    transactionId: transactionId,
  );
}

/// Synchronous txn id for grid tap (no stream subscription).
///
/// Only returns a **pending** cart id. After Send-for-Review / Pay the stream
/// can briefly still hold the just-completed (or `pendingReview`) row; tapping
/// into that id orphans lines off the next empty cart.
String? readPosCartTransactionIdFast(Ref ref, {required bool isExpense}) {
  final cached = readCachedPendingCartTransaction(ref, isExpense: isExpense);
  if (cached != null &&
      cached.id.isNotEmpty &&
      cached.status == PENDING) {
    return cached.id;
  }

  final streamTxn = ref
      .read(pendingTransactionStreamProvider(isExpense: isExpense))
      .value;
  if (streamTxn != null &&
      streamTxn.id.isNotEmpty &&
      streamTxn.status == PENDING) {
    return streamTxn.id;
  }

  final optId = ref.read(optimisticCartProvider).activeTransactionId;
  if (optId != null &&
      optId.isNotEmpty &&
      !OptimisticCartBootstrap.isBootstrap(optId)) {
    return optId;
  }

  return null;
}

/// Writes stream pending txn into cache when checkout opens (desktop split).
void warmPosCartPendingTransactionCache(Ref ref, {required bool isExpense}) {
  final txn = ref.read(pendingTransactionStreamProvider(isExpense: isExpense)).value;
  scheduleWriteCachedPendingCartTransaction(
    ref,
    isExpense: isExpense,
    transaction: txn,
  );
  if (txn != null && txn.id.isNotEmpty) {
    Future.microtask(
      () => ref
          .read(optimisticCartProvider.notifier)
          .bindPendingTransaction(txn.id),
    );
  }
}

/// [WidgetRef] variant — not assignable to [Ref] in this Riverpod version.
void warmPosCartPendingTransactionCacheWidget(
  WidgetRef ref, {
  required bool isExpense,
}) {
  final txn = ref.read(pendingTransactionStreamProvider(isExpense: isExpense)).value;
  scheduleWriteCachedPendingCartTransactionWidget(
    ref,
    isExpense: isExpense,
    transaction: txn,
  );
  if (txn != null && txn.id.isNotEmpty) {
    Future.microtask(
      () => ref
          .read(optimisticCartProvider.notifier)
          .bindPendingTransaction(txn.id),
    );
  }
}
