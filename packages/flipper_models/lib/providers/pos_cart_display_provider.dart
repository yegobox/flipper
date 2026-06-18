import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
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

/// Side-effect wiring: cache + bind bootstrap → real id + stream reconciliation.
/// Subscribed via [ref.listen] from checkout (not [ref.watch]) to avoid extra rebuilds.
final posCartStreamReconciliationProvider = Provider<void>((ref) {
  ref.keepAlive();

  final isExpense = _posCartIsExpense();
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);

  void syncPendingTransaction(ITransaction txn) {
    final pinned = ref.read(pinnedPosCartTransactionIdProvider);
    if (pinned != null && pinned.isNotEmpty && txn.id != pinned) {
      return;
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

  final isExpense = _posCartIsExpense();
  final optimisticState = ref.watch(optimisticCartProvider);
  final hasPending =
      optimisticState.pendingQtyByVariantId.values.any((q) => q > 0);

  final pendingId = ref.watch(posCartPendingTransactionIdProvider(isExpense));
  final mergeTxnId = ref.watch(posCartMergeTxnIdProvider(isExpense));
  final pinnedTxnId = ref.watch(pinnedPosCartTransactionIdProvider);
  final branchId = ProxyService.box.getBranchId() ?? '0';
  final mergeBranchId = pinnedTxnId != null && pinnedTxnId.isNotEmpty
      ? (readCachedPendingCartTransaction(ref, isExpense: isExpense)?.branchId ??
          branchId)
      : branchId;

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
    data: merge,
    loading: () => merge(const []),
    error: (_, __) => merge(const []),
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

/// Synchronous txn id for grid tap (no stream subscription).
String? readPosCartTransactionIdFast(Ref ref, {required bool isExpense}) {
  final cacheId = readCachedPendingCartTransaction(ref, isExpense: isExpense)?.id;
  if (cacheId != null && cacheId.isNotEmpty) return cacheId;

  final streamId = ref
      .read(pendingTransactionStreamProvider(isExpense: isExpense))
      .value
      ?.id;
  if (streamId != null && streamId.isNotEmpty) return streamId;

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
