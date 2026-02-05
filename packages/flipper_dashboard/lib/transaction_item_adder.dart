// ignore_for_file: unused_result

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
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

  Future<void> addItemToTransaction({
    required Variant variant,
    required bool isOrdering,
  }) async {
    final flipperWatch? w = kDebugMode
        ? flipperWatch("addItemToTransaction")
        : null;
    w?.start();

    try {
      // Increment optimistic count IMMEDIATELY for instant UI feedback
      // This happens before any async operations
      ref.read(optimisticOrderCountProvider.notifier).increment();

      // Show immediate visual feedback to indicate the item is being processed
      if (context.mounted) {
        // showCustomSnackBarUtil(context, 'Adding item to cart...');
      }

      final branchId = ProxyService.box.getBranchId()!;
      final businessId = ProxyService.box.getBusinessId()!;

      // Manage transaction
      w?.log("Pre-PendingTransaction");
      final pendingTransaction = await ref.read(
        pendingTransactionStreamProvider(isExpense: isOrdering).future,
      );
      w?.log("Post-PendingTransaction");

      w?.log("Pre-GetProduct");
      // Fetch product details
      final product = await ProxyService.getStrategy(Strategy.capella)
          .getProduct(
            businessId: businessId,
            id: variant.productId!,
            branchId: branchId,
          );
      w?.log("Post-GetProduct");

      // Get the latest stock from cache
      Stock? cachedStock;
      // Only check stock if we're not in ordering mode
      if (!isOrdering) {
        if (variant.id.isNotEmpty) {
          w?.log("Pre-CacheStock");
          cachedStock = await ProxyService.getStrategy(
            Strategy.capella,
          ).getStockById(id: variant.stockId!);
          w?.log("Post-CacheStock");
        }

        // Use cached stock if available, otherwise fall back to variant.stock
        final currentStock =
            cachedStock?.currentStock ?? variant.stock?.currentStock;

        /// because item of tax type D are not supposed to have stock so it can be sold without stock.
        if (variant.taxTyCd != "D" &&
            currentStock == null &&
            variant.itemTyCd != "3") {
          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          showErrorNotification(context, "You do not have enough stock");
          return;
        }
        if (variant.taxTyCd != "D" &&
            (currentStock ?? 0) <= 0 &&
            variant.itemTyCd != "3") {
          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          showErrorNotification(context, "You do not have enough stock");
          return;
        }
      }

      w?.log("Pre-Lock");
      // Use a lock to prevent multiple simultaneous operations
      await _lock.synchronized(() async {
        w?.log("Post-Lock");
        // Use the stock we already fetched above if available
        // If not, fetch it now (only if we didn't fetch it before)
        Stock? stock;
        if (!isOrdering && cachedStock != null) {
          stock = cachedStock;
        } else {
          w?.log("Pre-FetchStock-InLock");
          stock = await ProxyService.getStrategy(
            Strategy.capella,
          ).getStockById(id: variant.stockId!);
          w?.log("Post-FetchStock-InLock");
        }

        if (product != null && product.isComposite == true) {
          // Handle composite product
          final composites = await ProxyService.strategy.composites(
            productId: product.id,
          );

          for (final composite in composites) {
            final compositeVariant = await ProxyService.strategy.getVariant(
              id: composite.variantId!,
            );
            if (compositeVariant != null) {
              await ProxyService.strategy.saveTransactionItem(
                variation: compositeVariant,
                doneWithTransaction: false,
                ignoreForReport: false,
                amountTotal: compositeVariant.retailPrice!,
                customItem: false,
                currentStock: stock.currentStock ?? 0,
                pendingTransaction: pendingTransaction,
                partOfComposite: true,
                compositePrice: composite.actualPrice,
              );
            }
          }
        } else {
          // Handle non-composite product
          w?.log("Pre-SaveItem");
          await ProxyService.strategy.saveTransactionItem(
            variation: variant,
            doneWithTransaction: false,
            ignoreForReport: false,
            amountTotal: variant.retailPrice ?? 0,
            customItem: false,
            currentStock: stock.currentStock ?? 0,
            pendingTransaction: pendingTransaction,
            partOfComposite: false,
          );
          w?.log("Post-SaveItem");
        }
      });
      w?.log("Post-Lock-Release");

      // Hide the loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Show success message
      // showCustomSnackBarUtil(context, 'Item added to cart!');

      // Force refresh the transaction items with a small delay to ensure DB operations complete
      //await Future.delayed(const Duration(milliseconds: 100));

      // Immediately refresh the transaction items

      w?.log("Pre-Refresh");
      if (context.mounted) {
        ref.refresh(
          transactionItemsStreamProvider(
            transactionId: pendingTransaction.id,
            branchId: (await ProxyService.strategy.activeBranch(
              branchId: ProxyService.box.getBranchId()!,
            )).id,
          ),
        );
      }
      w?.log("Post-Refresh");

      w?.log("ItemAddedToTransactionSuccess"); // Log success
    } catch (e, s) {
      // Rollback optimistic increment on failure
      if (context.mounted) {
        ref.read(optimisticOrderCountProvider.notifier).decrement();
      }

      if (!context.mounted) return;

      // Hide the loading indicator if there was an error
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      GlobalErrorHandler.logError(
        s,
        type: "ITEM-ADD-EXCEPTION",
        context: {
          'resultCode': e.toString(),
          'businessId': ProxyService.box.getBusinessId(),
          'variantId': variant.id,
          // 'transactionId': pendingTransaction?.id,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      showErrorNotification(context, "Failed to add item to cart");
      if (context.mounted) {
        w?.log("ItemAddedToTransactionFailed"); // Log failure
      }
    }
  }
}
