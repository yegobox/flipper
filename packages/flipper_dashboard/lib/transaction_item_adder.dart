// ignore_for_file: unused_result

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
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
  }) async {
    final flipperWatch? w = kDebugMode
        ? flipperWatch("addItemToTransaction")
        : null;
    w?.start();

    try {
      // Increment optimistic count IMMEDIATELY for instant UI feedback
      ref.read(optimisticOrderCountProvider.notifier).increment();

      final branchId = ProxyService.box.getBranchId()!;
      final businessId = ProxyService.box.getBusinessId()!;

      final pendingProv =
          pendingTransactionStreamProvider(isExpense: isOrdering);

      Future<ITransaction> resolvePendingTransaction() async {
        final cached = ref.read(pendingProv).value;
        if (cached != null && cached.id.isNotEmpty) return cached;
        return ref.read(pendingProv.future);
      }

      w?.log("Pre-ParallelFetch");
      final capella = ProxyService.getStrategy(Strategy.capella);
      final stockFuture =
          !isOrdering && variant.id.isNotEmpty && variant.stockId != null
              ? capella.getStockById(id: variant.stockId!)
              : Future<Stock?>.value(null);

      final results = await Future.wait<Object?>([
        resolvePendingTransaction(),
        capella.getProduct(
          businessId: businessId,
          id: variant.productId!,
          branchId: branchId,
        ),
        stockFuture,
      ]);
      w?.log("Post-ParallelFetch");

      final pendingTransaction = results[0]! as ITransaction;
      final product = results[1] as Product?;
      final Stock? cachedStock = results[2] as Stock?;

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
            showErrorNotification(context, "You do not have enough stock");
            return false;
          }
        }
      }

      w?.log("Pre-Lock");
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
              await capella.saveTransactionItem(
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
            }
          }
        } else {
          w?.log("Pre-SaveItem");
          await capella.saveTransactionItem(
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
        }
      });
      w?.log("Post-Lock-Release");

      scheduleMicrotask(() {
        ref.invalidate(
          transactionItemsStreamProvider(
            transactionId: pendingTransaction.id,
            branchId: ProxyService.box.getBranchId() ?? '0',
          ),
        );
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Ditto observer fires on writes; invalidate speeds Riverpod reconciliation vs Cart UI.
      w?.log("ItemAddedToTransactionSuccess");
      return true;
    } catch (e, s) {
      if (context.mounted) {
        ref.read(optimisticOrderCountProvider.notifier).decrement();
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
