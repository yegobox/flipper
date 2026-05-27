import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';
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
      if (!allowSellingBelowStock &&
          (currentStock == null || currentStock <= 0)) {
        ref.read(optimisticOrderCountProvider.notifier).decrement();
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
    ref.read(optimisticOrderCountProvider.notifier).decrement();
    if (cartOptimismApplied) {
      ref
          .read(optimisticCartProvider.notifier)
          .rollbackPending(
            transactionId: pendingTransaction.id,
            variantId: variant.id,
          );
    }
  }

  await _persistLock.synchronized(() async {
    if (ref.read(pendingCartSaleSessionProvider) != sessionAtStart) {
      rollbackStaleAddAttempt();
      itemAddAbortedStale = true;
      return;
    }

    final freshPending = ref.read(pendingProv).value;
    if (freshPending == null ||
        freshPending.id != pendingTransaction.id ||
        freshPending.status != PENDING) {
      rollbackStaleAddAttempt();
      itemAddAbortedStale = true;
      return;
    }

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
      if (!saved) {
        return;
      }
    }
  });

  if (itemAddAbortedStale) return false;
  return true;
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
