import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:supabase_models/cache/cache_export.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flutter/foundation.dart';

class TransactionItemAdder {
  final BuildContext context;
  final WidgetRef ref;
  final CacheManager _cacheManager;

  // Shared lock to prevent concurrent addItemToTransaction operations
  static final _lock = Lock();

  TransactionItemAdder(this.context, this.ref, {CacheManager? cacheManager})
      : _cacheManager = cacheManager ?? CacheManager();

  Future<void> addItemToTransaction({
    required Variant variant,
    required bool isOrdering,
  }) async {
    final flipperWatch? w =
        kDebugMode ? flipperWatch("addItemToTransaction") : null;
    w?.start();

    try {
      // Show immediate visual feedback to indicate the item is being processed
      if (context.mounted) {
        showCustomSnackBarUtil(context, 'Adding item to cart...');
      }

      final branchId = ProxyService.box.getBranchId()!;
      final businessId = ProxyService.box.getBusinessId()!;

      // Manage transaction
      final pendingTransaction = await ref
          .read(pendingTransactionStreamProvider(isExpense: isOrdering).future);

      // Fetch product details
      final product = await ProxyService.strategy.getProduct(
        businessId: businessId,
        id: variant.productId!,
        branchId: branchId,
      );

      // Only check stock if we're not in ordering mode
      if (!isOrdering) {
        // Get the latest stock from cache
        Stock? cachedStock;
        if (variant.id.isNotEmpty) {
          cachedStock = await _cacheManager.getStockByVariantId(variant.id);
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
          showCustomSnackBarUtil(context, "You do not have enough stock",
              backgroundColor: Colors.red);
          return;
        }
        if (variant.taxTyCd != "D" &&
            (currentStock ?? 0) <= 0 &&
            variant.itemTyCd != "3") {
          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          showCustomSnackBarUtil(context, "You do not have enough stock",
              backgroundColor: Colors.red);
          return;
        }
      }

      // Use a lock to prevent multiple simultaneous operations
      await _lock.synchronized(() async {
        if (product != null && product.isComposite == true) {
          // Handle composite product
          final composites =
              await ProxyService.strategy.composites(productId: product.id);

          for (final composite in composites) {
            final compositeVariant = await ProxyService.strategy
                .getVariant(id: composite.variantId!);
            if (compositeVariant != null) {
              await ProxyService.strategy.saveTransactionItem(
                variation: compositeVariant,
                doneWithTransaction: false,
                ignoreForReport: false,
                amountTotal: compositeVariant.retailPrice!,
                customItem: false,
                currentStock: compositeVariant.stock?.currentStock ?? 0,
                pendingTransaction: pendingTransaction,
                partOfComposite: true,
                compositePrice: composite.actualPrice,
              );
            }
          }
        } else {
          // Handle non-composite product
          await ProxyService.strategy.saveTransactionItem(
            variation: variant,
            doneWithTransaction: false,
            ignoreForReport: false,
            amountTotal: variant.retailPrice ?? 0,
            customItem: false,
            currentStock: variant.stock?.currentStock ?? 0,
            pendingTransaction: pendingTransaction,
            partOfComposite: false,
          );
        }
      });

      // Hide the loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Show success message
      showCustomSnackBarUtil(context, 'Item added to cart!');

      // Force refresh the transaction items with a small delay to ensure DB operations complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Immediately refresh the transaction items
      ref.invalidate(transactionItemsStreamProvider(
          transactionId: pendingTransaction.id,
          branchId: (await ProxyService.strategy.activeBranch()).id));

      w?.log("ItemAddedToTransactionSuccess"); // Log success
    } catch (e, s) {
      // Hide the loading indicator if there was an error
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      GlobalErrorHandler.logError(
        s,
        type: "ITEM-ADD-EXCEPTION",
        context: {
          'resultCode': e.toString(),
          'businessId': ProxyService.box.getBusinessId(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      showCustomSnackBarUtil(context, "Failed to add item to cart",
          backgroundColor: Colors.red);
      w?.log("ItemAddedToTransactionFailed"); // Log failure
      rethrow;
    }
  }
}
