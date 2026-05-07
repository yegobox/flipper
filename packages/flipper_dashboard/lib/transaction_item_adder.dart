// ignore_for_file: unused_result

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';

class TransactionItemAdder {
  final BuildContext context;
  final WidgetRef ref;

  // Shared lock to prevent concurrent addItemToTransaction operations
  static final _lock = Lock();

  TransactionItemAdder(this.context, this.ref);

  /// Returns `true` when the item was saved to the pending transaction.
  Future<bool> addItemToTransaction({
    required Variant variant,
    required bool isOrdering,
    Product? productHint,
    bool isCompositeProduct = false,
  }) async {
    final flipperWatch? w = kDebugMode
        ? flipperWatch("addItemToTransaction")
        : null;
    w?.start();

    ITransaction? pendingTransactionForRollback;
    var cartOptimismApplied = false;

    try {
      // Increment optimistic count IMMEDIATELY for instant UI feedback
      ref.read(optimisticOrderCountProvider.notifier).increment();

      final branchId = ProxyService.box.getBranchId()!;
      final businessId = ProxyService.box.getBusinessId()!;

      final pendingProv = pendingTransactionStreamProvider(
        isExpense: isOrdering,
      );

      Future<ITransaction> resolvePendingTransaction() async {
        final cached = ref.read(pendingProv).value;
        if (cached != null && cached.id.isNotEmpty) return cached;
        return ref.read(pendingProv.future);
      }

      w?.log("Pre-PendingTransaction");
      final pendingTransaction = await resolvePendingTransaction();
      pendingTransactionForRollback = pendingTransaction;

      if (!isOrdering && !isCompositeProduct) {
        ref
            .read(optimisticCartProvider.notifier)
            .addPendingLine(
              transactionId: pendingTransaction.id,
              variant: variant,
            );
        cartOptimismApplied = true;
      }

      w?.log("Pre-ParallelFetch");
      final capella = ProxyService.getStrategy(Strategy.capella);
      final stockFuture =
          !isOrdering && variant.id.isNotEmpty && variant.stockId != null
          ? capella.getStockById(id: variant.stockId!)
          : Future<Stock?>.value(null);

      final productFuture = productHint != null
          ? Future<Product?>.value(productHint)
          : (variant.productId != null
                ? capella.getProduct(
                    businessId: businessId,
                    id: variant.productId!,
                    branchId: branchId,
                  )
                : Future<Product?>.value(null));

      final results = await Future.wait<Object?>([
        Future<ITransaction>.value(pendingTransaction),
        productFuture,
        stockFuture,
      ]);
      w?.log("Post-ParallelFetch");

      final product = results[1] as Product?;
      final Stock? cachedStock = results[2] as Stock?;

      if (cartOptimismApplied && product?.isComposite == true) {
        ref
            .read(optimisticCartProvider.notifier)
            .rollbackPending(
              transactionId: pendingTransaction.id,
              variantId: variant.id,
            );
        cartOptimismApplied = false;
      }

      // Stock validation (only when not ordering)
      if (!isOrdering) {
        final currentStock =
            cachedStock?.currentStock ?? variant.stock?.currentStock;

        if (variant.taxTyCd != "D" && variant.itemTyCd != "3") {
          if (currentStock == null || currentStock <= 0) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
            ref.read(optimisticOrderCountProvider.notifier).decrement();
            if (cartOptimismApplied) {
              ref
                  .read(optimisticCartProvider.notifier)
                  .rollbackPending(
                    transactionId: pendingTransaction.id,
                    variantId: variant.id,
                  );
            }
            showErrorNotification(context, "You do not have enough stock");
            return false;
          }
        }
      }

      w?.log("Pre-Lock");
      var saveReturnedFalseTreatAsSuccess = false;
      await _lock.synchronized(() async {
        w?.log("Post-Lock");
        // Reuse stock from parallel fetch
        final stock = cachedStock;

        if (product != null && product.isComposite == true) {
          final composites = await ProxyService.strategy.composites(
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
              if (!okComposite) {
                throw StateError('saveTransactionItem failed (composite line)');
              }
            }
          }
        } else {
          w?.log("Pre-SaveItem");
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
          w?.log("Post-SaveItem");
          // Capella returns false from an internal catch even when the write
          // still lands; do not throw — treat like success for this path.
          if (!saved) {
            saveReturnedFalseTreatAsSuccess = true;
            return;
          }
        }
      });
      w?.log("Post-Lock-Release");

      // Rely on Ditto store observers to push [transactionItemsStreamProvider]
      // updates. Invalidating here tears down subscriptions and can race with
      // a second add path (e.g. delayed auto-add), producing spurious failures.

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      if (saveReturnedFalseTreatAsSuccess) {
        w?.log("ItemAddSaveReturnedFalseTreatedAsSuccess");
      } else {
        w?.log("ItemAddedToTransactionSuccess");
      }
      return true;
    } catch (e, s) {
      final txn = pendingTransactionForRollback;
      final branchIdStr = ProxyService.box.getBranchId();

      // A parallel add (e.g. auto-add + tap) may have already persisted this
      // line. Don't scare the cashier with a failure toast in that case.
      var persistedForVariant = false;
      if (txn != null &&
          txn.id.isNotEmpty &&
          branchIdStr != null &&
          variant.id.isNotEmpty) {
        try {
          final rows = await ProxyService.getStrategy(Strategy.capella)
              .transactionItems(
                transactionId: txn.id,
                variantId: variant.id,
                branchId: branchIdStr,
                doneWithTransaction: false,
                active: true,
              );
          persistedForVariant = rows.any(
            (i) => i.active != false && i.variantId == variant.id && i.qty > 0,
          );
        } catch (_) {}
      }

      if (context.mounted) {
        ref.read(optimisticOrderCountProvider.notifier).decrement();
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
        w?.log("ItemAddFailureSuppressedLineAlreadyInTransaction");
        return true;
      }

      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      GlobalErrorHandler.logError(
        s,
        type: "ITEM-ADD-EXCEPTION",
        context: {
          'resultCode': e.toString(),
          'businessId': ProxyService.box.getBusinessId(),
          'variantId': variant.id,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      showErrorNotification(context, "Failed to add item to cart");
      if (context.mounted) {
        w?.log("ItemAddedToTransactionFailed");
      }
      return false;
    }
  }
}
