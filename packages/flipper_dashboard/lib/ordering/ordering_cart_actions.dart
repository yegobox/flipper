import 'package:flipper_dashboard/providers/pos_cart_add_service.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Line edits for the purchase-order screen.
///
/// Adds go through [PosCartAddService] — the one gated, idempotent add path
/// shared with the register — and everything else edits the persisted
/// [TransactionItem] rows that [posCartDisplayItemsProvider] renders. Quantity
/// is never written from a screen-side count: each edit is resolved against the
/// rows in the cart at that moment, so a stale render cannot overwrite a line.
final orderingCartActionsProvider = Provider<OrderingCartActions>(
  OrderingCartActions.new,
);

class OrderingCartActions {
  OrderingCartActions(this.ref);

  final Ref ref;

  static const bool _isOrdering = true;

  List<TransactionItem> _linesFor(String variantId) {
    return ref
        .read(posCartDisplayItemsProvider)
        .where((item) => item.active != false && item.variantId == variantId)
        .toList();
  }

  /// Persisted rows only. An optimistic ghost has no document behind it yet, so
  /// it can be rolled back but not updated.
  List<TransactionItem> _persistedLinesFor(String variantId) {
    return _linesFor(variantId)
        .where((item) => !OptimisticCartIds.isOptimistic(item.id))
        .toList();
  }

  void addOne({required BuildContext context, required Variant variant}) {
    ref.read(posCartAddServiceProvider).tapAdd(
      context: context,
      variant: variant,
      isOrdering: _isOrdering,
    );
  }

  /// Drop one unit of [variant] from the order.
  Future<void> decrementOne({required Variant variant}) async {
    final persisted = _persistedLinesFor(variant.id);
    if (persisted.isEmpty) {
      _rollbackGhost(variant.id);
      return;
    }

    // The same variant can sit in the cart as several qty=1 rows, so thin the
    // largest row first and only delete when there is nothing left to thin.
    persisted.sort((a, b) => b.qty.compareTo(a.qty));
    final line = persisted.first;
    try {
      if (line.qty > 1) {
        await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
          qty: line.qty - 1,
          transactionItemId: line.id,
          ignoreForReport: false,
        );
      } else {
        await _delete(line);
      }
    } catch (e) {
      talker.error('Ordering: failed to decrement ${variant.id}: $e');
    }
  }

  /// Set the ordered quantity of [variant] to exactly [qty].
  ///
  /// Collapses the variant onto one row: extra rows for the same variant are
  /// removed rather than left to be summed, so what the operator typed is what
  /// the order carries.
  Future<void> setQty({
    required BuildContext context,
    required Variant variant,
    required int qty,
  }) async {
    final persisted = _persistedLinesFor(variant.id);

    if (qty <= 0) {
      for (final line in persisted) {
        await _delete(line);
      }
      if (persisted.isEmpty) _rollbackGhost(variant.id);
      return;
    }

    if (persisted.isEmpty) {
      // Nothing to edit yet. Add the line; the operator's number lands on the
      // next edit, once the row exists.
      addOne(context: context, variant: variant);
      return;
    }

    persisted.sort((a, b) => b.qty.compareTo(a.qty));
    try {
      await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
        qty: qty.toDouble(),
        transactionItemId: persisted.first.id,
        ignoreForReport: false,
      );
      for (final extra in persisted.skip(1)) {
        await _delete(extra);
      }
    } catch (e) {
      talker.error('Ordering: failed to set qty for ${variant.id}: $e');
    }
  }

  /// Set the unit cost the order is placed at.
  Future<void> setLineCost({
    required TransactionItem line,
    required double cost,
  }) async {
    if (cost < 0) return;
    try {
      await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
        price: cost,
        transactionItemId: line.id,
        ignoreForReport: false,
      );
    } catch (e) {
      talker.error('Ordering: failed to price ${line.id}: $e');
    }
  }

  Future<void> removeLine(TransactionItem line) async {
    if (OptimisticCartIds.isOptimistic(line.id)) {
      _rollbackGhost(line.variantId);
      return;
    }
    await _delete(line);
  }

  Future<void> clearAll() async {
    final lines = ref
        .read(posCartDisplayItemsProvider)
        .where((item) => item.active != false)
        .toList();
    for (final line in lines) {
      await removeLine(line);
    }
  }

  Future<void> _delete(TransactionItem line) async {
    try {
      await ProxyService.getStrategy(Strategy.capella).deleteItemFromCart(
        transactionItemId: line,
        transactionId: line.transactionId,
      );
    } catch (e) {
      talker.error('Ordering: failed to remove ${line.id}: $e');
    }
  }

  void _rollbackGhost(String? variantId) {
    if (variantId == null || variantId.isEmpty) return;
    final txnId = ref.read(posCartMergeTxnIdProvider(_isOrdering));
    if (txnId.isEmpty) return;
    ref
        .read(optimisticCartProvider.notifier)
        .rollbackPending(transactionId: txnId, variantId: variantId);
  }
}
