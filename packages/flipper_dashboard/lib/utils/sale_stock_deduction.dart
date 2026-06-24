import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_services/proxy.dart';

/// Reads on-hand qty per [Stock] id for non-service sale lines (before RRA sign).
Future<Map<String, double>> loadPreSaleStockLevelsForLines(
  List<TransactionItem> transactionItems,
) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final candidates = transactionItems.where((item) {
    if (item.itemTyCd == '3') return false;
    final vid = item.variantId;
    return vid != null && vid.isNotEmpty;
  }).toList();
  if (candidates.isEmpty) return {};

  final variantIds = candidates.map((e) => e.variantId!).toSet().toList();
  final variantsMap = await capella.batchGetVariantsByIds(variantIds);

  final stockIds = <String>{};
  for (final item in candidates) {
    final sid = variantsMap[item.variantId!]?.stockId;
    if (sid != null && sid.isNotEmpty) stockIds.add(sid);
  }
  if (stockIds.isEmpty) return {};

  final stocksMap = await capella.batchGetStocksByIds(stockIds.toList());
  for (final sid in stockIds) {
    if (!stocksMap.containsKey(sid)) {
      stocksMap[sid] = await capella.getStockById(id: sid);
    }
  }

  final out = <String, double>{};
  for (final sid in stockIds) {
    final current = stocksMap[sid]?.currentStock;
    if (current != null) out[sid] = current;
  }
  return out;
}

/// Persists pre-sale on-hand levels before `saveSales` so deferred deduction and
/// RRA oversell capping use qty at Pay time (not after sign).
Future<void> persistPreSaleStockSnapshot({
  required List<TransactionItem> transactionItems,
  required String transactionId,
}) async {
  final levels = await loadPreSaleStockLevelsForLines(transactionItems);
  final key = rraSaleStockSnapshotBoxKey(transactionId);
  if (levels.isEmpty) {
    ProxyService.box.remove(key: key);
    return;
  }
  await ProxyService.box.writeString(key: key, value: jsonEncode(levels));
}

/// Applies Ditto stock decrements after RRA sign / sale success (not on Pay hot path).
Future<Map<String, double>> applyDeferredSaleStockDeduction({
  required List<TransactionItem> transactionItems,
  required bool allowSellingBelowStock,
  required bool isProformaOrTraining,
  required String transactionId,
}) async {
  final sw = Stopwatch()..start();
  final originalStockQuantities = <String, double>{};
  final capella = ProxyService.getStrategy(Strategy.capella);
  final rraSaleSnapshotKey = rraSaleStockSnapshotBoxKey(transactionId);
  final preSaleSnapshot = decodeRraSaleStockSnapshot(
    ProxyService.box.readString(key: rraSaleSnapshotKey),
  );

  final candidateItems = transactionItems.where((item) {
    if (item.itemTyCd == "3") return false;
    final vid = item.variantId;
    return vid != null && vid.isNotEmpty;
  }).toList();

  if (isProformaOrTraining || candidateItems.isEmpty) {
    talker.debug(
      '[sale_completion_timing] deferred_stock_deduction_ms=${sw.elapsedMilliseconds} '
      'skipped=${isProformaOrTraining ? "proforma_training" : "no_stock_lines"}',
    );
    return originalStockQuantities;
  }

  final variantIds = candidateItems.map((e) => e.variantId!).toSet().toList();
  final variantsMap = await capella.batchGetVariantsByIds(variantIds);

  final stockIds = <String>{};
  for (final item in candidateItems) {
    final v = variantsMap[item.variantId!];
    final sid = v?.stockId;
    if (sid != null && sid.isNotEmpty) stockIds.add(sid);
  }

  final stocksMap = await capella.batchGetStocksByIds(stockIds.toList());
  for (final sid in stockIds) {
    if (!stocksMap.containsKey(sid)) {
      stocksMap[sid] = await capella.getStockById(id: sid);
    }
  }

  final itemsNeedingDeduction = candidateItems.where((item) {
    return !saleLineAlreadyStockDeducted(
      item: item,
      variantsByVariantId: variantsMap,
      stocksByStockId: stocksMap,
      preSaleStockByStockId: preSaleSnapshot,
    );
  }).toList();

  if (itemsNeedingDeduction.isEmpty) {
    talker.debug(
      '[sale_completion_timing] deferred_stock_deduction_ms=${sw.elapsedMilliseconds} '
      'skipped=already_deducted',
    );
    return originalStockQuantities;
  }

  final qtyDeltaPerStock = <String, double>{};
  for (final item in itemsNeedingDeduction) {
    final v = variantsMap[item.variantId!];
    final sid = v?.stockId;
    if (sid == null || sid.isEmpty) continue;
    qtyDeltaPerStock[sid] = (qtyDeltaPerStock[sid] ?? 0) + item.qty.toDouble();
  }

  final stockUpdatesById = <String, ({double currentStock, double rsdQty})>{};
  final deductedStockIds = <String>{};
  for (final e in qtyDeltaPerStock.entries) {
    final sid = e.key;
    final delta = e.value;
    final stock = stocksMap[sid];
    final current = stock?.currentStock;
    if (current == null) continue;

    originalStockQuantities[sid] = current;
    deductedStockIds.add(sid);

    var newStock = (current - delta).roundToTwoDecimalPlaces();
    if (allowSellingBelowStock && newStock < 0) {
      newStock = 0;
    }
    stockUpdatesById[sid] = (currentStock: newStock, rsdQty: newStock);
  }

  if (stockUpdatesById.isEmpty) {
    talker.warning(
      'Deferred stock deduction: no stock rows updated for $transactionId '
      '(lines=${itemsNeedingDeduction.length})',
    );
  } else {
    await capella.batchUpdateStocks(stockUpdatesById);
    unawaited(
      _deferMarkItemsQuantityShipped(
        capella: capella,
        items: itemsNeedingDeduction,
        deductedStockIds: deductedStockIds,
        variantsMap: variantsMap,
      ),
    );
  }

  // Keep pre-sale snapshot for RRA oversell cap until sync finishes (rw_tax finally).
  if (!allowSellingBelowStock || originalStockQuantities.isEmpty) {
    if (preSaleSnapshot == null || preSaleSnapshot.isEmpty) {
      ProxyService.box.remove(key: rraSaleSnapshotKey);
    }
  } else if (preSaleSnapshot == null || preSaleSnapshot.isEmpty) {
    await ProxyService.box.writeString(
      key: rraSaleSnapshotKey,
      value: jsonEncode(originalStockQuantities),
    );
  }

  talker.debug(
    '[sale_completion_timing] deferred_stock_deduction_ms=${sw.elapsedMilliseconds} '
    'lines=${itemsNeedingDeduction.length} stocks=${stockUpdatesById.length}',
  );
  return originalStockQuantities;
}

Future<void> _deferMarkItemsQuantityShipped({
  required dynamic capella,
  required List<TransactionItem> items,
  required Set<String> deductedStockIds,
  required Map<String, Variant> variantsMap,
}) async {
  try {
    for (final item in items) {
      final v = variantsMap[item.variantId!];
      final sid = v?.stockId;
      if (sid == null || !deductedStockIds.contains(sid)) continue;

      item.quantityShipped = item.qty.toInt();
      await capella.updateTransactionItem(
        transactionItemId: item.id,
        quantityShipped: item.quantityShipped,
        ignoreForReport: false,
        skipParentSaleSubtotalRecalc: true,
      );
    }
  } catch (e, s) {
    talker.warning('Deferred quantityShipped update failed: $e\n$s');
  }
}

void scheduleDeferredSaleStockDeduction({
  required List<TransactionItem> transactionItems,
  required bool allowSellingBelowStock,
  required bool isProformaOrTraining,
  required String transactionId,
}) {
  unawaited(
    applyDeferredSaleStockDeduction(
      transactionItems: transactionItems,
      allowSellingBelowStock: allowSellingBelowStock,
      isProformaOrTraining: isProformaOrTraining,
      transactionId: transactionId,
    ).catchError((e, s) {
      talker.error('Deferred stock deduction failed: $e', s);
      return <String, double>{};
    }),
  );
}

/// Local stock decrement, then RRA `saveStockItems` → `saveStockMaster` (after saveSales).
Future<void> runPostSaleStockDeductionAndRraSync({
  required List<TransactionItem> transactionItems,
  required bool allowSellingBelowStock,
  required bool isProformaOrTraining,
  required String transactionId,
  required ITransaction transaction,
  required String receiptType,
  String? sarTyCd,
}) async {
  await applyDeferredSaleStockDeduction(
    transactionItems: transactionItems,
    allowSellingBelowStock: allowSellingBelowStock,
    isProformaOrTraining: isProformaOrTraining,
    transactionId: transactionId,
  );

  if (isProformaOrTraining) return;

  final highestInvcNo = resolvePostSaleInvoiceNo(
    invoiceNumber: transaction.invoiceNumber,
    receiptNumber: transaction.receiptNumber,
    totalReceiptNumber: transaction.totalReceiptNumber,
  );
  if (highestInvcNo == null) {
    talker.warning(
      'Skipping post-sale RRA stock sync: missing invoice/receipt number on ${transaction.id}',
    );
    return;
  }

  final stockIoSarTyCd = resolveRraStockIoSarTyCd(
    sarTyCd: sarTyCd,
    receiptType: receiptType,
    transactionSarTyCd: transaction.sarTyCd,
  );

  talker.info(
    'Post-sale RRA stock sync: txn=${transaction.id} invc=$highestInvcNo '
    'sarTyCd=$stockIoSarTyCd lines=${transactionItems.length}',
  );

  await ProxyService.tax.syncStockAfterSuccessfulSaveSales(
    receiptType: receiptType,
    items: transactionItems,
    transaction: transaction,
    highestInvcNo: highestInvcNo,
    sarTyCd: stockIoSarTyCd,
  );
}

void schedulePostSaleStockDeductionAndRraSync({
  required List<TransactionItem> transactionItems,
  required bool allowSellingBelowStock,
  required bool isProformaOrTraining,
  required String transactionId,
  required ITransaction transaction,
  required String receiptType,
  String? sarTyCd,
}) {
  unawaited(
    runPostSaleStockDeductionAndRraSync(
      transactionItems: transactionItems,
      allowSellingBelowStock: allowSellingBelowStock,
      isProformaOrTraining: isProformaOrTraining,
      transactionId: transactionId,
      transaction: transaction,
      receiptType: receiptType,
      sarTyCd: sarTyCd,
    ).catchError((e, s) {
      talker.error('Post-sale stock deduction / RRA sync failed: $e', s);
    }),
  );
}
