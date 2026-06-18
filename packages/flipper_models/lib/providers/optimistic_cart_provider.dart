import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

part 'optimistic_cart_provider.g.dart';

/// Stable client-only ids so the cart table can key rows before Ditto persists.
/// Placeholder txn id so grid taps paint the cart before Ditto returns a pending sale.
abstract final class OptimisticCartBootstrap {
  static const String txnId = '__pos_pending_bootstrap__';

  static bool isBootstrap(String? id) => id == txnId;
}

abstract final class OptimisticCartIds {
  static const String prefix = 'optimistic:';

  static bool isOptimistic(String id) => id.startsWith(prefix);

  /// One placeholder row per transaction + variant until the stream has a real line.
  static String ghostLineId({
    required String transactionId,
    required String variantId,
  }) => '$prefix$transactionId:$variantId';
}

@immutable
class OptimisticCartState {
  final String? activeTransactionId;
  /// Quantity added in-session that has not yet been reflected in [lastStreamQtySumByVariantId].
  final Map<String, double> pendingQtyByVariantId;
  /// Last reconciled per-variant qty sum from [transactionItemsStreamProvider].
  final Map<String, double> lastStreamQtySumByVariantId;
  /// Snapshot from the last tap, used to render ghost rows.
  final Map<String, Variant> variantSnapshotByVariantId;
  /// Ignore stream reconciliation briefly after a tap so ghosts are not cleared early.
  final DateTime? reconcileAfter;

  const OptimisticCartState({
    this.activeTransactionId,
    this.pendingQtyByVariantId = const {},
    this.lastStreamQtySumByVariantId = const {},
    this.variantSnapshotByVariantId = const {},
    this.reconcileAfter,
  });

  OptimisticCartState copyWith({
    String? activeTransactionId,
    Map<String, double>? pendingQtyByVariantId,
    Map<String, double>? lastStreamQtySumByVariantId,
    Map<String, Variant>? variantSnapshotByVariantId,
    DateTime? reconcileAfter,
    bool clearReconcileAfter = false,
    bool clearTransaction = false,
  }) {
    return OptimisticCartState(
      activeTransactionId: clearTransaction
          ? null
          : (activeTransactionId ?? this.activeTransactionId),
      pendingQtyByVariantId:
          pendingQtyByVariantId ?? this.pendingQtyByVariantId,
      lastStreamQtySumByVariantId:
          lastStreamQtySumByVariantId ?? this.lastStreamQtySumByVariantId,
      variantSnapshotByVariantId:
          variantSnapshotByVariantId ?? this.variantSnapshotByVariantId,
      reconcileAfter: clearReconcileAfter
          ? null
          : (reconcileAfter ?? this.reconcileAfter),
    );
  }

  bool hasPendingFor(String transactionId) {
    if (!_appliesToTransaction(transactionId)) return false;
    return pendingQtyByVariantId.values.any((q) => q > 0);
  }

  /// True when [pendingQtyByVariantId] should merge into [transactionId]'s cart.
  bool _appliesToTransaction(String transactionId) {
    if (transactionId.isEmpty) return false;
    final active = activeTransactionId;
    if (active == null || active.isEmpty) return false;
    if (active == transactionId) return true;
    // Bootstrap ghosts apply to the real pending sale until bind runs.
    return OptimisticCartBootstrap.isBootstrap(active) &&
        !OptimisticCartBootstrap.isBootstrap(transactionId) &&
        pendingQtyByVariantId.isNotEmpty;
  }
}

/// Pure optimistic tap (no Riverpod / Capella). Used by [OptimisticCart] and tests.
OptimisticCartState ensureOptimisticCartTransaction(
  OptimisticCartState state,
  String transactionId,
) {
  final current = state.activeTransactionId;
  if (current == transactionId) return state;
  if (current == null ||
      current.isEmpty ||
      OptimisticCartBootstrap.isBootstrap(current)) {
    return state.copyWith(activeTransactionId: transactionId);
  }
  return OptimisticCartState(
    activeTransactionId: transactionId,
    pendingQtyByVariantId: {},
    lastStreamQtySumByVariantId: {},
    variantSnapshotByVariantId: {},
    reconcileAfter: null,
  );
}

/// Pure optimistic tap (no Riverpod / Capella). Used by [OptimisticCart] and tests.
OptimisticCartState addOptimisticPendingLine(
  OptimisticCartState state, {
  required String transactionId,
  required Variant variant,
}) {
  final vid = variant.id;
  if (vid.isEmpty) return state;
  final withTxn = ensureOptimisticCartTransaction(state, transactionId);
  final nextPending = Map<String, double>.from(withTxn.pendingQtyByVariantId);
  nextPending[vid] = (nextPending[vid] ?? 0) + 1;
  final nextSnap = Map<String, Variant>.from(withTxn.variantSnapshotByVariantId);
  nextSnap[vid] = variant;
  return withTxn.copyWith(
    pendingQtyByVariantId: nextPending,
    variantSnapshotByVariantId: nextSnap,
    reconcileAfter: DateTime.now().add(const Duration(milliseconds: 250)),
  );
}

@Riverpod(keepAlive: true)
class OptimisticCart extends _$OptimisticCart {
  @override
  OptimisticCartState build() => const OptimisticCartState();

  void _ensureTransaction(String transactionId) {
    state = ensureOptimisticCartTransaction(state, transactionId);
  }

  /// Replaces [OptimisticCartBootstrap.txnId] when the real pending sale is known.
  void bindPendingTransaction(String transactionId) {
    if (transactionId.isEmpty) return;
    final current = state.activeTransactionId;
    if (current == transactionId) return;
    if (current == null ||
        current.isEmpty ||
        OptimisticCartBootstrap.isBootstrap(current)) {
      state = state.copyWith(activeTransactionId: transactionId);
    }
  }

  /// Call right after the pending transaction is known, before the Ditto save lock.
  void addPendingLine({required String transactionId, required Variant variant}) {
    state = addOptimisticPendingLine(
      state,
      transactionId: transactionId,
      variant: variant,
    );
  }

  void rollbackPending({
    required String transactionId,
    required String variantId,
    double count = 1,
  }) {
    if (state.activeTransactionId != transactionId) return;
    final next = Map<String, double>.from(state.pendingQtyByVariantId);
    final cur = next[variantId] ?? 0;
    final nextVal = cur - count;
    if (nextVal <= 0) {
      next.remove(variantId);
      final snaps = Map<String, Variant>.from(state.variantSnapshotByVariantId);
      snaps.remove(variantId);
      state = state.copyWith(
        pendingQtyByVariantId: next,
        variantSnapshotByVariantId: snaps,
      );
    } else {
      next[variantId] = nextVal;
      state = state.copyWith(pendingQtyByVariantId: next);
    }
  }

  /// When the items stream emits, reduce pending by how much the persisted qty increased.
  void onStreamEmitted({
    required String transactionId,
    required List<TransactionItem> items,
  }) {
    if (transactionId.isEmpty) return;
    final grace = state.reconcileAfter;
    if (grace != null && DateTime.now().isBefore(grace)) {
      return;
    }
    _reconcileStreamItems(transactionId: transactionId, items: items);
  }

  /// Reconcile from a direct Ditto read (Pay path, post-save). Ignores tap grace.
  void reconcileFromPersistedItems({
    required String transactionId,
    required List<TransactionItem> items,
  }) {
    if (transactionId.isEmpty) return;
    _reconcileStreamItems(transactionId: transactionId, items: items);
  }

  void _reconcileStreamItems({
    required String transactionId,
    required List<TransactionItem> items,
  }) {
    final active = state.activeTransactionId;
    if (active != null && active != transactionId) {
      if (OptimisticCartBootstrap.isBootstrap(active)) {
        bindPendingTransaction(transactionId);
      } else {
        return;
      }
    }

    final streamSum = _sumQtyByVariant(items);
    if (state.activeTransactionId == null && streamSum.isEmpty) {
      return;
    }
    _ensureTransaction(transactionId);

    final nextPending = Map<String, double>.from(state.pendingQtyByVariantId);
    final nextLast = Map<String, double>.from(state.lastStreamQtySumByVariantId);

    final allVariants = <String>{
      ...nextPending.keys,
      ...streamSum.keys,
      ...nextLast.keys,
    };

    for (final vid in allVariants) {
      final last = nextLast[vid] ?? 0;
      final now = streamSum[vid] ?? 0;
      final inc = now - last;
      if (inc > 0) {
        final p = nextPending[vid] ?? 0;
        final remaining = p - inc;
        if (remaining <= 0) {
          nextPending.remove(vid);
        } else {
          nextPending[vid] = remaining;
        }
      }
      nextLast[vid] = now;
    }

    final nextSnaps = Map<String, Variant>.from(state.variantSnapshotByVariantId)
      ..removeWhere((vid, _) => !nextPending.containsKey(vid));

    state = state.copyWith(
      pendingQtyByVariantId: nextPending,
      lastStreamQtySumByVariantId: nextLast,
      variantSnapshotByVariantId: nextSnaps,
      clearReconcileAfter: true,
    );
  }

  void clearPendingForVariant({
    required String transactionId,
    required String variantId,
  }) {
    if (state.activeTransactionId != transactionId) return;
    final next = Map<String, double>.from(state.pendingQtyByVariantId);
    next.remove(variantId);
    final snaps = Map<String, Variant>.from(state.variantSnapshotByVariantId);
    snaps.remove(variantId);
    state = state.copyWith(
      pendingQtyByVariantId: next,
      variantSnapshotByVariantId: snaps,
    );
  }

  void clearForTransaction(String transactionId) {
    if (state.activeTransactionId != transactionId) return;
    state = const OptimisticCartState();
  }

  bool hasPendingFor(String transactionId) => state.hasPendingFor(transactionId);

  static Map<String, double> _sumQtyByVariant(List<TransactionItem> items) {
    final out = <String, double>{};
    for (final it in items) {
      if (it.active == false) continue;
      final vid = it.variantId;
      if (vid == null || vid.isEmpty) continue;
      out[vid] = (out[vid] ?? 0) + it.qty.toDouble();
    }
    return out;
  }
}

/// Pending cart transaction id for merging stream rows with optimistic ghosts.
String cartTransactionIdForMerge({
  required String? pendingTransactionId,
  required OptimisticCartState optimistic,
}) {
  return cartTransactionIdForMergeIds(
    pendingTransactionId: pendingTransactionId,
    optimisticTransactionId: optimistic.activeTransactionId,
  );
}

String cartTransactionIdForMergeIds({
  required String? pendingTransactionId,
  required String? optimisticTransactionId,
  bool preferBootstrapWhilePending = false,
}) {
  // Fast cart paint: skip [transactionItemsStreamProvider] while taps are in flight.
  if (preferBootstrapWhilePending) {
    return OptimisticCartBootstrap.txnId;
  }
  if (pendingTransactionId != null && pendingTransactionId.isNotEmpty) {
    return pendingTransactionId;
  }
  return optimisticTransactionId ?? '';
}

/// Pure merge used by the checkout UI: persisted rows + unresolved optimistic qty.
List<TransactionItem> mergeTransactionItemsWithOptimisticCart({
  required List<TransactionItem> streamItems,
  required OptimisticCartState optimistic,
  required String transactionId,
}) {
  if (!optimistic._appliesToTransaction(transactionId)) {
    return _sortNewestFirst(streamItems);
  }

  final pending = optimistic.pendingQtyByVariantId;
  if (pending.isEmpty) {
    return _sortNewestFirst(streamItems);
  }

  final byVariant = <String, List<TransactionItem>>{};
  for (final it in streamItems) {
    if (it.active == false) continue;
    final vid = it.variantId;
    if (vid == null || vid.isEmpty) continue;
    byVariant.putIfAbsent(vid, () => []).add(it);
  }

  final usedVariants = <String>{};
  final out = <TransactionItem>[];

  for (final entry in byVariant.entries) {
    final vid = entry.key;
    final rows = entry.value;
    usedVariants.add(vid);
    final sumQty = rows.fold<double>(0, (s, r) => s + r.qty.toDouble());
    final extra = pending[vid] ?? 0;
    final displayQty = sumQty + extra;
    if (displayQty <= 0) continue;

    final template = rows.first;
    final unitPrice = template.price;
    final useComposite = (template.compositePrice ?? 0) != 0;
    final linePrice = useComposite ? template.compositePrice! : unitPrice;

    if (rows.length == 1 && extra == 0) {
      out.add(template);
      continue;
    }

    out.add(
      template.copyWith(
        qty: displayQty,
        totAmt: linePrice * displayQty,
      ),
    );
  }

  for (final vid in pending.keys) {
    if (usedVariants.contains(vid)) continue;
    final extra = pending[vid] ?? 0;
    if (extra <= 0) continue;
    final snap = optimistic.variantSnapshotByVariantId[vid];
    if (snap == null) continue;
    out.add(
      _ghostTransactionItem(
        transactionId: transactionId,
        variation: snap,
        qty: extra,
      ),
    );
  }

  return _sortNewestFirst(out);
}

/// In-memory cart lines after a grid tap (no Capella/Ditto stream subscription).
///
/// When [optimistic] has pending qty, uses the bootstrap fast path so display
/// never waits on [transactionItemsStreamProvider].
List<TransactionItem> mergePosCartDisplayAfterTap({
  required OptimisticCartState optimistic,
  required String? pendingTransactionId,
  List<TransactionItem> streamItems = const [],
}) {
  final preferBootstrap =
      optimistic.pendingQtyByVariantId.values.any((q) => q > 0);
  final mergeTxnId = cartTransactionIdForMergeIds(
    pendingTransactionId: pendingTransactionId,
    optimisticTransactionId: optimistic.activeTransactionId,
    preferBootstrapWhilePending: preferBootstrap,
  );
  if (mergeTxnId.isEmpty) return const [];

  if (OptimisticCartBootstrap.isBootstrap(mergeTxnId)) {
    final ghostTxnId =
        (pendingTransactionId != null && pendingTransactionId.isNotEmpty)
        ? pendingTransactionId
        : mergeTxnId;
    return mergeTransactionItemsWithOptimisticCart(
      streamItems: streamItems,
      optimistic: optimistic,
      transactionId: ghostTxnId,
    );
  }

  return mergeTransactionItemsWithOptimisticCart(
    streamItems: streamItems,
    optimistic: optimistic,
    transactionId: mergeTxnId,
  );
}

/// Simulates synchronous tap → cart line (used by perf regression tests).
List<TransactionItem> simulatePosCartTapDisplaySync({
  required Variant variant,
  required String? pendingTransactionId,
}) {
  final txnId = (pendingTransactionId != null && pendingTransactionId.isNotEmpty)
      ? pendingTransactionId
      : OptimisticCartBootstrap.txnId;
  final optimistic = addOptimisticPendingLine(
    const OptimisticCartState(),
    transactionId: txnId,
    variant: variant,
  );
  return mergePosCartDisplayAfterTap(
    optimistic: optimistic,
    pendingTransactionId: pendingTransactionId,
  );
}

TransactionItem _ghostTransactionItem({
  required String transactionId,
  required Variant variation,
  required double qty,
}) {
  final amountTotal = (variation.retailPrice ?? 0).toDouble();
  final unitSupply = variation.supplyPrice ?? 0;
  final lineSupplyAmt = unitSupply * qty;
  final pricing = SaleLinePricing.compute(
    unitPrice: amountTotal,
    qty: qty.toDouble(),
    dcRt: variation.dcRt?.toDouble(),
    taxTyCd: variation.taxTyCd,
    taxPercentage: (variation.taxPercentage ?? 18.0).toDouble(),
  );
  final id = OptimisticCartIds.ghostLineId(
    transactionId: transactionId,
    variantId: variation.id,
  );

  return TransactionItem(
    id: id,
    name: variation.name,
    transactionId: transactionId,
    variantId: variation.id,
    qty: qty,
    remainingStock: null,
    price: amountTotal,
    totAmt: pricing.totAmt,
    discount: pricing.discount,
    dcRt: pricing.dcRt,
    dcAmt: pricing.dcAmt,
    taxblAmt: pricing.taxblAmt,
    taxAmt: pricing.taxAmt,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
    isRefunded: false,
    doneWithTransaction: false,
    active: true,
    branchId: variation.branchId,
    prc: variation.retailPrice ?? 0.0,
    ttCatCd: variation.ttCatCd ?? 'TT',
    itemSeq: variation.itemSeq,
    isrccCd: variation.isrccCd,
    isrccNm: variation.isrccNm,
    isrcRt: variation.isrcRt,
    isrcAmt: variation.isrcAmt,
    taxTyCd: variation.taxTyCd,
    bcd: variation.bcd,
    sku: variation.sku,
    taxPercentage: variation.taxPercentage,
    supplyPrice: variation.supplyPrice,
    supplyPriceAtSale: variation.supplyPrice,
    itemClsCd: variation.itemClsCd,
    itemTyCd: variation.itemTyCd,
    itemStdNm: variation.itemStdNm,
    orgnNatCd: variation.orgnNatCd,
    pkg: variation.pkg,
    itemCd: variation.itemCd,
    pkgUnitCd: variation.pkgUnitCd,
    qtyUnitCd: variation.qtyUnitCd,
    itemNm: variation.itemNm ?? variation.name,
    splyAmt: lineSupplyAmt,
    tin: variation.tin,
    bhfId: variation.bhfId,
    dftPrc: variation.dftPrc,
    addInfo: variation.addInfo,
    isrcAplcbYn: variation.isrcAplcbYn,
    useYn: variation.useYn,
    regrId: variation.regrId,
    regrNm: variation.regrNm,
    modrId: variation.modrId,
    modrNm: variation.modrNm,
    partOfComposite: false,
    productId: variation.productId,
    productName: variation.productName,
    retailPrice: variation.retailPrice,
    ignoreForReport: false,
  );
}

List<TransactionItem> _sortNewestFirst(List<TransactionItem> items) {
  final sorted = List<TransactionItem>.from(items)
    ..sort((a, b) {
      final aDate = a.createdAt ?? DateTime(2000);
      final bDate = b.createdAt ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
  return sorted;
}
