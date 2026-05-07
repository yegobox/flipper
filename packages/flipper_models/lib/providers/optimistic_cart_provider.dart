import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimistic_cart_provider.g.dart';

/// Stable client-only ids so the cart table can key rows before Ditto persists.
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

  const OptimisticCartState({
    this.activeTransactionId,
    this.pendingQtyByVariantId = const {},
    this.lastStreamQtySumByVariantId = const {},
    this.variantSnapshotByVariantId = const {},
  });

  OptimisticCartState copyWith({
    String? activeTransactionId,
    Map<String, double>? pendingQtyByVariantId,
    Map<String, double>? lastStreamQtySumByVariantId,
    Map<String, Variant>? variantSnapshotByVariantId,
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
    );
  }

  bool hasPendingFor(String transactionId) {
    if (activeTransactionId != transactionId) return false;
    return pendingQtyByVariantId.values.any((q) => q > 0);
  }
}

@Riverpod(keepAlive: true)
class OptimisticCart extends _$OptimisticCart {
  @override
  OptimisticCartState build() => const OptimisticCartState();

  void _ensureTransaction(String transactionId) {
    if (state.activeTransactionId != transactionId) {
      state = OptimisticCartState(
        activeTransactionId: transactionId,
        pendingQtyByVariantId: {},
        lastStreamQtySumByVariantId: {},
        variantSnapshotByVariantId: {},
      );
    }
  }

  /// Call right after the pending transaction is known, before the Ditto save lock.
  void addPendingLine({required String transactionId, required Variant variant}) {
    final vid = variant.id;
    if (vid.isEmpty) return;
    _ensureTransaction(transactionId);
    final nextPending = Map<String, double>.from(state.pendingQtyByVariantId);
    nextPending[vid] = (nextPending[vid] ?? 0) + 1;
    final nextSnap = Map<String, Variant>.from(state.variantSnapshotByVariantId);
    nextSnap[vid] = variant;
    state = state.copyWith(
      pendingQtyByVariantId: nextPending,
      variantSnapshotByVariantId: nextSnap,
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
    if (state.activeTransactionId != null &&
        state.activeTransactionId != transactionId) {
      return;
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

/// Pure merge used by the checkout UI: persisted rows + unresolved optimistic qty.
List<TransactionItem> mergeTransactionItemsWithOptimisticCart({
  required List<TransactionItem> streamItems,
  required OptimisticCartState optimistic,
  required String transactionId,
}) {
  if (optimistic.activeTransactionId != transactionId) {
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

TransactionItem _ghostTransactionItem({
  required String transactionId,
  required Variant variation,
  required double qty,
}) {
  final amountTotal = variation.retailPrice ?? 0;
  final itemTotal = amountTotal * qty;
  final unitSupply = variation.supplyPrice ?? 0;
  final lineSupplyAmt = unitSupply * qty;
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
    totAmt: itemTotal,
    discount: 0.0,
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
