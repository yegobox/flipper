import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pending_cart_sale_session_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:synchronized/synchronized.dart';

final _persistLock = Lock();

/// When the last cart write released the persist lock.
///
/// The gap between one write finishing and the next starting is the number
/// that separates "the store is slow" from "the main isolate is busy": the
/// writes are serialized, so an idle queue means nothing was competing for the
/// lock, while a long gap with taps outstanding means the isolate was doing
/// something else (rebuilding the cart, converting every row an observer
/// replayed) instead of running the next write.
DateTime? _lastCartWriteFinishedAt;

/// Resolves once every cart write queued before this call has finished.
///
/// [Lock] is FIFO, so taking a turn behind the queued adds is the same thing as
/// waiting for them — no polling, no timeout, no dependency on the item stream
/// having replayed anything back to us.
Future<void> awaitQueuedCartWrites() => _persistLock.synchronized(() async {});

String? readPendingCartTransactionId(
  Ref ref, {
  required bool isExpense,
}) {
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);
  final fromStream = ref.read(pendingProv).value?.id;
  if (fromStream != null && fromStream.isNotEmpty) return fromStream;

  final fromCache = readCachedPendingCartTransaction(ref, isExpense: isExpense)?.id;
  if (fromCache != null && fromCache.isNotEmpty) return fromCache;

  return ref.read(optimisticCartProvider).activeTransactionId;
}

Future<ITransaction?> resolvePendingTransactionForPersist({
  required Ref ref,
  required dynamic pendingProv,
  required bool isOrdering,
}) async {
  var pendingTransaction = readCachedPendingCartTransaction(
    ref,
    isExpense: isOrdering,
  );
  pendingTransaction ??= ref.read(pendingProv).value;
  if (pendingTransaction == null || pendingTransaction.id.isEmpty) {
    pendingTransaction = await ref.read(pendingProv.future);
  }
  if (pendingTransaction != null && pendingTransaction.id.isNotEmpty) {
    writeCachedPendingCartTransaction(
      ref,
      isExpense: isOrdering,
      transaction: pendingTransaction,
    );
    ref
        .read(optimisticCartProvider.notifier)
        .bindPendingTransaction(pendingTransaction.id);
  }
  return pendingTransaction;
}

Future<bool> persistItemToTransaction({
  required Ref ref,
  required BuildContext context,
  required Variant variant,
  required bool isOrdering,
  required Product? productHint,
  required bool isCompositeProduct,
  required dynamic pendingProv,
  required ITransaction pendingTransaction,
  required int sessionAtStart,
  required bool cartOptimismApplied,
}) async {
  final branchId = ProxyService.box.getBranchId()!;
  final businessId = ProxyService.box.getBusinessId()!;
  final capella = ProxyService.getStrategy(Strategy.capella);

  final productFuture = _resolveProductForAdd(
    capella: capella,
    variant: variant,
    branchId: branchId,
    businessId: businessId,
    productHint: productHint,
    isCompositeProduct: isCompositeProduct,
  );
  final stockFuture = _resolveStockForAdd(
    capella: capella,
    variant: variant,
    isOrdering: isOrdering,
  );

  final results = await Future.wait<Object?>([productFuture, stockFuture]);
  final product = results[0] as Product?;
  final cachedStock = results[1] as Stock?;

  if (cartOptimismApplied && product?.isComposite == true) {
    ref
        .read(optimisticCartProvider.notifier)
        .rollbackPending(
          transactionId: pendingTransaction.id,
          variantId: variant.id,
        );
  }

  if (!isOrdering) {
    final currentStock =
        cachedStock?.currentStock ?? variant.stock?.currentStock;
    if (variant.taxTyCd != "D" && variant.itemTyCd != "3") {
      final allowSellingBelowStock =
          await locator<SettingsService>().isAllowSellingBelowStock();
      final inCartQty = ref.read(posCartQtyForVariantProvider(variant.id));
      if (!allowSellingBelowStock &&
          (currentStock == null ||
              currentStock <= 0 ||
              currentStock < inCartQty)) {
        if (cartOptimismApplied) {
          ref
              .read(optimisticCartProvider.notifier)
              .rollbackPending(
                transactionId: pendingTransaction.id,
                variantId: variant.id,
              );
        }
        if (context.mounted) {
          showErrorNotification(context, 'You do not have enough stock');
        }
        return false;
      }
    }
  }

  var itemAddAbortedStale = false;

  void rollbackStaleAddAttempt() {
    if (cartOptimismApplied) {
      ref
          .read(optimisticCartProvider.notifier)
          .rollbackPending(
            transactionId: pendingTransaction.id,
            variantId: variant.id,
          );
    }
  }

  var itemAddCancelled = false;

  final queuedAtLock = DateTime.now();
  await _persistLock.synchronized(() async {
    final lockSw = Stopwatch()..start();
    final grantedAt = DateTime.now();
    // Time this write spent behind the ones ahead of it...
    final lockWaitMs = grantedAt.difference(queuedAtLock).inMilliseconds;
    // ...as against time the queue sat idle with nothing running, which no
    // store call can account for.
    final idleMs = _lastCartWriteFinishedAt == null
        ? -1
        : grantedAt.difference(_lastCartWriteFinishedAt!).inMilliseconds;
    var storeMs = -1;
    // A `-` on the still-unsaved line asked for this add back. It already took
    // the qty out of the optimistic cart, so abort *without* rolling back again
    // — writing the row here is exactly what would re-inflate the qty.
    if (cartOptimismApplied &&
        ref
            .read(optimisticCartProvider.notifier)
            .consumeCancelledAdd(variant.id)) {
      itemAddCancelled = true;
      return;
    }

    if (ref.read(pendingCartSaleSessionProvider) != sessionAtStart) {
      rollbackStaleAddAttempt();
      itemAddAbortedStale = true;
      return;
    }

    final freshPending = ref.read(pendingProv).value;
    final streamMatchesTarget = freshPending != null &&
        freshPending.id == pendingTransaction.id &&
        freshPending.status == PENDING;

    if (!streamMatchesTarget) {
      // After Send-for-Review / Pay the pending stream can briefly still hold
      // the completed ticket (or loading). Rolling back here made the first
      // tap on the new cart appear then vanish. Trust the PENDING cart this
      // add was resolved against when it is still pending.
      if (pendingTransaction.status != PENDING ||
          pendingTransaction.id.isEmpty) {
        rollbackStaleAddAttempt();
        itemAddAbortedStale = true;
        return;
      }
    }

    final stock = cachedStock;

    if (product != null && product.isComposite == true) {
      final composites = await ProxyService.getStrategy(Strategy.capella).composites(
        productId: product.id,
      );
      final variantIds = composites
          .map((c) => c.variantId)
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();
      final variantsMap = variantIds.isEmpty
          ? <String, Variant>{}
          : await capella.batchGetVariantsByIds(variantIds);

      for (final composite in composites) {
        final vid = composite.variantId;
        if (vid == null || vid.isEmpty) continue;
        final compositeVariant = variantsMap[vid];
        if (compositeVariant != null) {
          final storeSw = Stopwatch()..start();
          final okComposite = await capella.saveTransactionItem(
            variation: compositeVariant,
            doneWithTransaction: false,
            ignoreForReport: false,
            amountTotal: compositeVariant.retailPrice!,
            customItem: false,
            currentStock: stock?.currentStock ?? 0,
            pendingTransaction: pendingTransaction,
            partOfComposite: true,
            compositePrice: composite.actualPrice,
          );
          storeMs = (storeMs < 0 ? 0 : storeMs) + storeSw.elapsedMilliseconds;
          if (!okComposite) {
            throw StateError('saveTransactionItem failed (composite line)');
          }
        }
      }
    } else {
      final storeSw = Stopwatch()..start();
      final saved = await capella.saveTransactionItem(
        variation: variant,
        doneWithTransaction: false,
        ignoreForReport: false,
        amountTotal: variant.retailPrice ?? 0,
        customItem: false,
        currentStock: stock?.currentStock ?? 0,
        pendingTransaction: pendingTransaction,
        partOfComposite: false,
      );
      storeMs = storeSw.elapsedMilliseconds;
      if (!saved) {
        // The write did not happen, so the ghost must not survive it. Left
        // standing it is a line the cashier can see, believes is in the cart,
        // and that no row backs — it inflates the on-screen total and the
        // reconciliation that retires ghosts can never fire for it.
        talker.warning(
          'saveTransactionItem returned false for variant=${variant.id} on '
          'txn=${pendingTransaction.id}; rolling the cart line back',
        );
        rollbackStaleAddAttempt();
        return;
      }
    }

    // Ghost clears only when transactionItemsStreamProvider itself reflects
    // the save (via the passive onStreamEmitted reconciliation) — a direct
    // Ditto read here used to confirm-and-clear faster, but that raced ahead
    // of the live stream the cart actually renders from: the ghost would
    // disappear before the real row was visible, flashing the cart empty.
    _lastCartWriteFinishedAt = DateTime.now();
    _logCartWriteTiming(
      ref: ref,
      storeMs: storeMs,
      lockHoldMs: lockSw.elapsedMilliseconds,
      lockWaitMs: lockWaitMs,
      idleMs: idleMs,
    );
  });

  if (itemAddCancelled) return false;
  if (itemAddAbortedStale) return false;
  return true;
}

/// Reports what one cart write cost, and what happened between writes.
///
/// A backlog that will not drain is either slow writes or a busy isolate, and
/// the two want opposite fixes. `store_ms` is the write itself, `wait_ms` is
/// time queued behind earlier writes, and `idle_ms` is dead time with nothing
/// running at all — which no store call can account for.
void _logCartWriteTiming({
  required Ref ref,
  required int storeMs,
  required int lockHoldMs,
  required int lockWaitMs,
  required int idleMs,
}) {
  final queued = ref.read(optimisticCartProvider.notifier).queuedAddCount;
  final lines = ref.read(posCartDisplayItemsProvider).length;
  final message =
      '[cart_write] store_ms=$storeMs lock_hold_ms=$lockHoldMs '
      'wait_ms=$lockWaitMs idle_ms=$idleMs queued=$queued lines=$lines';
  // A cart write is a handful of local store calls; a second is not a slow
  // write, it is a symptom, and it is what stalls Pay on a large cart.
  if (storeMs >= 1000 || idleMs >= 1000) {
    talker.warning(message);
  } else {
    talker.debug(message);
  }
}

Future<bool> handlePersistFailure({
  required Ref ref,
  required BuildContext context,
  required Object e,
  required StackTrace s,
  required Variant variant,
  required ITransaction? txn,
  required bool cartOptimismApplied,
}) async {
  var persistedForVariant = false;
  if (txn != null && txn.id.isNotEmpty && variant.id.isNotEmpty) {
    try {
      final existing = await ProxyService.getStrategy(Strategy.capella)
          .getTransactionItem(
            transactionId: txn.id,
            variantId: variant.id,
          );
      persistedForVariant =
          existing != null &&
          existing.active != false &&
          existing.qty > 0;
    } catch (_) {}
  }

  if (context.mounted) {
    if (txn != null && cartOptimismApplied) {
      ref
          .read(optimisticCartProvider.notifier)
          .rollbackPending(transactionId: txn.id, variantId: variant.id);
    }
  }

  if (persistedForVariant) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    return true;
  }

  if (!context.mounted) return false;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  GlobalErrorHandler.logError(
    s,
    type: 'ITEM-ADD-EXCEPTION',
    context: {
      'resultCode': e.toString(),
      'businessId': ProxyService.box.getBusinessId(),
      'variantId': variant.id,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
  showErrorNotification(context, 'Failed to add item to cart');
  return false;
}

Future<Product?> _resolveProductForAdd({
  required dynamic capella,
  required Variant variant,
  required String branchId,
  required String businessId,
  Product? productHint,
  required bool isCompositeProduct,
}) {
  if (productHint != null) return Future<Product?>.value(productHint);

  if (isCompositeProduct) {
    final productId = variant.productId;
    if (productId == null || productId.isEmpty) {
      return Future<Product?>.value(null);
    }
    return Future<Product?>.value(
      Product(
        id: productId,
        name: variant.productName ?? variant.name,
        color: '',
        businessId: businessId,
        branchId: branchId,
        isComposite: true,
      ),
    );
  }

  final productId = variant.productId;
  if (productId == null || productId.isEmpty) {
    return Future<Product?>.value(null);
  }

  return capella.getProduct(
    businessId: businessId,
    id: productId,
    branchId: branchId,
  );
}

Future<Stock?> _resolveStockForAdd({
  required dynamic capella,
  required Variant variant,
  required bool isOrdering,
}) {
  if (isOrdering || variant.id.isEmpty || variant.stockId == null) {
    return Future<Stock?>.value(null);
  }
  return capella.getStockById(id: variant.stockId!);
}
