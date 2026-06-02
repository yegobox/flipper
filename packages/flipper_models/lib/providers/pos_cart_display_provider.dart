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

void bumpPosCartDisplayEpoch(Ref ref) {
  ref.read(posCartDisplayEpochProvider.notifier).update((n) => n + 1);
}

/// Pending sale/purchase id for cart merge — cache first, then stream (id only).
final posCartPendingTransactionIdProvider = Provider.family<String?, bool>((
  ref,
  isExpense,
) {
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
  final optimistic = ref.watch(optimisticCartProvider);
  final optimisticId = optimistic.activeTransactionId;
  final preferBootstrap =
      optimistic.pendingQtyByVariantId.values.any((q) => q > 0);
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
    writeCachedPendingCartTransaction(
      ref,
      isExpense: isExpense,
      transaction: txn,
    );
    ref.read(optimisticCartProvider.notifier).bindPendingTransaction(txn.id);
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

  final itemsProv = transactionItemsStreamProvider(
    transactionId: pendingId,
    branchId: ProxyService.box.getBranchId() ?? '0',
  );

  ref.listen(itemsProv, (_, next) {
    if (next.hasValue) {
      ref.read(optimisticCartProvider.notifier).onStreamEmitted(
            transactionId: pendingId,
            items: next.value!,
          );
    }
  }, fireImmediately: true);
});

/// Single cart list for checkout UI: Ditto rows + unresolved optimistic qty.
final posCartDisplayItemsProvider = Provider<List<TransactionItem>>((ref) {
  ref.keepAlive();

  ref.watch(posCartDisplayEpochProvider);
  final isExpense = _posCartIsExpense();
  final mergeTxnId = ref.watch(posCartMergeTxnIdProvider(isExpense));

  final optimisticState = ref.watch(optimisticCartProvider);

  if (mergeTxnId.isEmpty) return const [];

  if (OptimisticCartBootstrap.isBootstrap(mergeTxnId)) {
    final pendingId = ref.watch(posCartPendingTransactionIdProvider(isExpense));
    final ghostTxnId = (pendingId != null && pendingId.isNotEmpty)
        ? pendingId
        : mergeTxnId;
    return mergeTransactionItemsWithOptimisticCart(
      streamItems: const [],
      optimistic: optimisticState,
      transactionId: ghostTxnId,
    );
  }

  final streamAsync = ref.watch(
    transactionItemsStreamProvider(
      transactionId: mergeTxnId,
      branchId: ProxyService.box.getBranchId() ?? '0',
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
  ref.watch(posCartDisplayEpochProvider);
  return computePosCartSummary(ref.watch(posCartDisplayItemsProvider));
});

/// Per-variant qty for catalog badges. While optimistic qty is pending, derive
/// from [optimisticCartProvider] only so the product grid does not watch Ditto.
final posCartQtyByVariantIdProvider = Provider<Map<String, int>>((ref) {
  ref.watch(posCartDisplayEpochProvider);
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
  ref.watch(posCartDisplayEpochProvider);

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
  if (txn != null && txn.id.isNotEmpty) {
    writeCachedPendingCartTransaction(ref, isExpense: isExpense, transaction: txn);
    ref.read(optimisticCartProvider.notifier).bindPendingTransaction(txn.id);
  }
}

/// [WidgetRef] variant — not assignable to [Ref] in this Riverpod version.
void warmPosCartPendingTransactionCacheWidget(
  WidgetRef ref, {
  required bool isExpense,
}) {
  final txn = ref.read(pendingTransactionStreamProvider(isExpense: isExpense)).value;
  if (txn != null && txn.id.isNotEmpty) {
    writeCachedPendingCartTransactionWidget(
      ref,
      isExpense: isExpense,
      transaction: txn,
    );
    ref.read(optimisticCartProvider.notifier).bindPendingTransaction(txn.id);
  }
}
