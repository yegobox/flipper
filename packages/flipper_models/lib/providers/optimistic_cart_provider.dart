import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/transaction_item_line_order.dart';
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

  /// Recovers the variant from a [ghostLineId], so UI state keyed by line id can
  /// follow a row across the ghost -> saved-row id change. Returns null for any
  /// id that is not a ghost.
  static String? variantIdOf(String id) {
    if (!isOptimistic(id)) return null;
    final sep = id.lastIndexOf(':');
    if (sep < 0 || sep + 1 >= id.length) return null;
    return id.substring(sep + 1);
  }
}

bool _qtyMapsEqual(Map<String, double> a, Map<String, double> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    final other = b[entry.key];
    if (other == null || other != entry.value) return false;
  }
  return true;
}

/// Snapshots are carried by reference between reconciles, so identity is the
/// right test — [Variant] has no value equality.
bool _snapshotMapsEqual(Map<String, Variant> a, Map<String, Variant> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (!identical(b[entry.key], entry.value)) return false;
  }
  return true;
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
  /// Adds queued by [PosCartAddService] whose Ditto save has not run yet.
  final Map<String, int> inFlightAddsByVariantId;
  /// Queued adds a `-` tap asked to abort before they reach the save.
  final Map<String, int> cancelledAddsByVariantId;

  const OptimisticCartState({
    this.activeTransactionId,
    this.pendingQtyByVariantId = const {},
    this.lastStreamQtySumByVariantId = const {},
    this.variantSnapshotByVariantId = const {},
    this.reconcileAfter,
    this.inFlightAddsByVariantId = const {},
    this.cancelledAddsByVariantId = const {},
  });

  OptimisticCartState copyWith({
    String? activeTransactionId,
    Map<String, double>? pendingQtyByVariantId,
    Map<String, double>? lastStreamQtySumByVariantId,
    Map<String, Variant>? variantSnapshotByVariantId,
    DateTime? reconcileAfter,
    Map<String, int>? inFlightAddsByVariantId,
    Map<String, int>? cancelledAddsByVariantId,
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
      inFlightAddsByVariantId:
          inFlightAddsByVariantId ?? this.inFlightAddsByVariantId,
      cancelledAddsByVariantId:
          cancelledAddsByVariantId ?? this.cancelledAddsByVariantId,
    );
  }

  bool hasPendingFor(String transactionId) {
    if (!_appliesToTransaction(transactionId)) return false;
    return pendingQtyByVariantId.values.any((q) => q > 0);
  }

  /// True when a queued add for [variantId] can still be aborted before its
  /// Ditto save runs. This is what makes `-` on a not-yet-saved line safe: the
  /// qty can only be taken back if the write that would restore it is stopped.
  bool hasCancellableAdd(String variantId) {
    final queued = inFlightAddsByVariantId[variantId] ?? 0;
    final cancelled = cancelledAddsByVariantId[variantId] ?? 0;
    return queued - cancelled > 0;
  }

  /// True when a mutation aimed at [transactionId] targets the active cart.
  ///
  /// Callers resolve the cart id from different providers — some hand over the
  /// real pending id, some [OptimisticCartBootstrap.txnId] (which is only ever
  /// a placeholder for "the cart being built right now") — and bind can land
  /// between the tap and the rollback. Strict equality made those mutations
  /// silently no-op, stranding the ghost line. There is only ever one active
  /// optimistic cart, and a genuine cart switch discards pending qty in
  /// [ensureOptimisticCartTransaction], so treating the sentinel as a wildcard
  /// on either side is safe.
  bool matchesActiveCart(String transactionId) {
    if (transactionId.isEmpty) return false;
    final active = activeTransactionId;
    if (active == null || active.isEmpty) return false;
    if (active == transactionId) return true;
    return OptimisticCartBootstrap.isBootstrap(active) ||
        OptimisticCartBootstrap.isBootstrap(transactionId);
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
  Timer? _graceTimer;
  String? _deferredTransactionId;
  List<TransactionItem>? _deferredItems;

  @override
  OptimisticCartState build() {
    ref.onDispose(_cancelDeferredReconcile);
    return const OptimisticCartState();
  }

  void _cancelDeferredReconcile() {
    _graceTimer?.cancel();
    _graceTimer = null;
    _deferredTransactionId = null;
    _deferredItems = null;
  }

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
    final prev = state;
    final prevActive = prev.activeTransactionId;
    if (prevActive != null &&
        prevActive.isNotEmpty &&
        !OptimisticCartBootstrap.isBootstrap(prevActive) &&
        prevActive != transactionId &&
        prev.pendingQtyByVariantId.isNotEmpty) {
      talker.warning(
        'OptimisticCart: active transaction switched '
        '$prevActive -> $transactionId while '
        '${prev.pendingQtyByVariantId.length} variant(s) were still '
        'unconfirmed (${prev.pendingQtyByVariantId}) — discarding them.',
      );
    }
    state = addOptimisticPendingLine(
      state,
      transactionId: transactionId,
      variant: variant,
    );
  }

  /// Called by [PosCartAddService] when a tap queues a Ditto save.
  void noteAddInFlight(String variantId) {
    if (variantId.isEmpty) return;
    final next = Map<String, int>.from(state.inFlightAddsByVariantId);
    next[variantId] = (next[variantId] ?? 0) + 1;
    state = state.copyWith(inFlightAddsByVariantId: next);
  }

  /// Called when that save finishes, aborts, or throws — always paired with
  /// [noteAddInFlight] so a stuck persist cannot strand a cancellation token.
  void noteAddSettled(String variantId) {
    if (variantId.isEmpty) return;
    final queued = state.inFlightAddsByVariantId[variantId] ?? 0;
    if (queued <= 0) return;
    final next = Map<String, int>.from(state.inFlightAddsByVariantId);
    if (queued - 1 <= 0) {
      next.remove(variantId);
    } else {
      next[variantId] = queued - 1;
    }
    state = state.copyWith(inFlightAddsByVariantId: next);
    _completeIfAllAddsSettled();
  }

  Completer<void>? _addsSettledCompleter;

  /// Completes once every tap that queued a Ditto save has finished writing.
  ///
  /// This is the ledger Pay should wait on. [inFlightAddsByVariantId] is
  /// incremented synchronously inside `PosCartAddService.tapAdd` and always
  /// decremented in the persist's `finally`, so it is an exact count of writes
  /// this session still owes — unlike the item stream, which is a *report* of
  /// what Ditto has replayed back to us and can lag for reasons that have
  /// nothing to do with whether the cart is safe to sell.
  Future<void> whenQueuedAddsSettle() {
    if (state.inFlightAddsByVariantId.isEmpty) return Future<void>.value();
    return (_addsSettledCompleter ??= Completer<void>()).future;
  }

  void _completeIfAllAddsSettled() {
    if (state.inFlightAddsByVariantId.isNotEmpty) return;
    final completer = _addsSettledCompleter;
    _addsSettledCompleter = null;
    if (completer != null && !completer.isCompleted) completer.complete();
  }

  /// Marks one queued add for [variantId] as aborted. Returns false when there
  /// is nothing left to cancel, in which case the caller must not take the qty
  /// back — the save is already past the point of no return and Ditto would
  /// simply restore it.
  bool cancelInFlightAdd(String variantId) {
    if (variantId.isEmpty) return false;
    if (!state.hasCancellableAdd(variantId)) return false;
    final next = Map<String, int>.from(state.cancelledAddsByVariantId);
    next[variantId] = (next[variantId] ?? 0) + 1;
    state = state.copyWith(cancelledAddsByVariantId: next);
    return true;
  }

  /// Consumed by the persist just before it writes. True means this add was
  /// cancelled and must not be saved.
  bool consumeCancelledAdd(String variantId) {
    if (variantId.isEmpty) return false;
    final cancelled = state.cancelledAddsByVariantId[variantId] ?? 0;
    if (cancelled <= 0) return false;
    final next = Map<String, int>.from(state.cancelledAddsByVariantId);
    if (cancelled - 1 <= 0) {
      next.remove(variantId);
    } else {
      next[variantId] = cancelled - 1;
    }
    state = state.copyWith(cancelledAddsByVariantId: next);
    return true;
  }

  void rollbackPending({
    required String transactionId,
    required String variantId,
    double count = 1,
  }) {
    if (!state.matchesActiveCart(transactionId)) return;
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
    final now = DateTime.now();
    if (grace != null && now.isBefore(grace)) {
      // The item INSERT is normally the only thing that fires the Ditto items
      // observer for this cart, so dropping this emission used to strand the
      // ghost line until some unrelated mutation arrived — often the user's
      // next tap, and on a quiet cart never. Buffer it and replay once the
      // grace expires instead. Replaying is safe because these items come from
      // the same [transactionItemsStreamProvider] the cart renders from (not
      // the direct Ditto read removed in 2f81f24a6), and the `inc > 0` guard in
      // [_reconcileStreamItems] still refuses to clear pending qty that the
      // persisted rows have not caught up with yet.
      _deferredTransactionId = transactionId;
      _deferredItems = items;
      _graceTimer?.cancel();
      _graceTimer = Timer(grace.difference(now), _replayDeferredReconcile);
      return;
    }
    _cancelDeferredReconcile();
    _reconcileStreamItems(
      transactionId: transactionId,
      items: items,
      source: 'stream',
    );
  }

  void _replayDeferredReconcile() {
    final transactionId = _deferredTransactionId;
    final items = _deferredItems;
    if (transactionId == null || transactionId.isEmpty || items == null) {
      _cancelDeferredReconcile();
      return;
    }
    // A tap landing after the timer was armed pushes the grace forward; wait
    // it out rather than clearing the fresh window with a stale emission.
    final grace = state.reconcileAfter;
    final now = DateTime.now();
    if (grace != null && now.isBefore(grace)) {
      _graceTimer?.cancel();
      _graceTimer = Timer(grace.difference(now), _replayDeferredReconcile);
      return;
    }
    _cancelDeferredReconcile();
    _reconcileStreamItems(
      transactionId: transactionId,
      items: items,
      source: 'stream-deferred',
    );
  }

  /// Reconcile from a direct Ditto read (Pay path, post-save). Ignores tap grace.
  void reconcileFromPersistedItems({
    required String transactionId,
    required List<TransactionItem> items,
  }) {
    if (transactionId.isEmpty) return;
    _cancelDeferredReconcile();
    _reconcileStreamItems(
      transactionId: transactionId,
      items: items,
      source: 'direct-read',
    );
  }

  void _reconcileStreamItems({
    required String transactionId,
    required List<TransactionItem> items,
    required String source,
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
          // Success, once per line: the saved row has fully accounted for the
          // ghost, so the ghost retires. Logged at warning it fired 60 times on
          // a 60-line cart and read like a fault report.
          talker.debug(
            'OptimisticCart[$source]: ghost settled for variant=$vid '
            'txn=$transactionId (pending=$p, saved qty=$now)',
          );
          nextPending.remove(vid);
        } else {
          nextPending[vid] = remaining;
        }
      }
      nextLast[vid] = now;
    }

    final nextSnaps = Map<String, Variant>.from(state.variantSnapshotByVariantId)
      ..removeWhere((vid, _) => !nextPending.containsKey(vid));

    // [OptimisticCartState] has no value equality, so assigning an identical
    // copy still notifies every listener — and [posCartDisplayItemsProvider]
    // then hands out a fresh List, which rebuilds the whole checkout (see the
    // top-level `ref.watch(posCartDisplayItemsProvider)` in QuickSellingView).
    // The Pay path reconciles on every 100ms poll tick, so a large cart spent
    // its persistence window re-laying out itself instead of draining the Ditto
    // writes it was waiting for. Skipping a no-op write is invisible to state
    // and costs nothing: same maps, same grace window.
    if (state.reconcileAfter == null &&
        _qtyMapsEqual(state.pendingQtyByVariantId, nextPending) &&
        _qtyMapsEqual(state.lastStreamQtySumByVariantId, nextLast) &&
        _snapshotMapsEqual(state.variantSnapshotByVariantId, nextSnaps)) {
      return;
    }

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
    if (!state.matchesActiveCart(transactionId)) return;
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
    // Deliberately keeps in-flight/cancelled counters: their owning persists
    // are still running and will settle them. Dropping them here would let a
    // later add consume a stale cancellation.
    state = OptimisticCartState(
      inFlightAddsByVariantId: state.inFlightAddsByVariantId,
      cancelledAddsByVariantId: state.cancelledAddsByVariantId,
    );
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
    final useComposite = (template.compositePrice ?? 0) != 0;
    final lineUnitPrice =
        (useComposite ? template.compositePrice! : template.price).toDouble();

    if (rows.length == 1 && extra == 0) {
      out.add(template);
      continue;
    }

    final oldQty = sumQty > 0 ? sumQty : template.qty.toDouble();
    var dcRt = template.dcRt?.toDouble();
    if ((dcRt == null || dcRt == 0) &&
        oldQty > 0 &&
        lineUnitPrice > 0 &&
        (template.dcAmt?.toDouble() ?? 0) > 0) {
      dcRt = (template.dcAmt!.toDouble() / (lineUnitPrice * oldQty)) * 100;
    }
    final pricing = SaleLinePricing.compute(
      unitPrice: lineUnitPrice,
      qty: displayQty,
      dcRt: dcRt,
      taxTyCd: template.taxTyCd,
      taxPercentage: (template.taxPercentage ?? 18.0).toDouble(),
    );

    out.add(
      template.copyWith(
        qty: displayQty,
        totAmt: pricing.totAmt,
        dcRt: pricing.dcRt,
        dcAmt: pricing.dcAmt,
        discount: pricing.discount,
        taxAmt: pricing.taxAmt,
        taxblAmt: pricing.taxblAmt,
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
  return sortTransactionItemLinesNewestFirst(items);
}
