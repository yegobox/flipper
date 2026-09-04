import 'package:flipper_models/helpers/sale_completion_trace.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flipper_dashboard/utils/bounded_concurrency.dart';
import 'package:flipper_dashboard/utils/ebm_receipt_gate.dart';
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
  // Batch misses were re-read one await at a time; on a large cart that is a
  // second sequential pass over the whole line set.
  await forEachBounded(
    stockIds.where((sid) => !stocksMap.containsKey(sid)),
    (sid) async {
      final loaded = await capella.getStockById(id: sid);
      if (loaded != null && loaded.branchId.isNotEmpty) {
        stocksMap[sid] = loaded;
      }
    },
  );

  final out = <String, double>{};
  for (final sid in stockIds) {
    final stock = stocksMap[sid];
    if (stock == null || stock.branchId.isEmpty) continue;
    final current = stock.currentStock;
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
    logSaleCompletionStage(
      'deferred_stock_deduction',
      sw.elapsedMilliseconds,
      extra:
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
  // Batch misses were re-read one await at a time; on a large cart that is a
  // second sequential pass over the whole line set.
  await forEachBounded(
    stockIds.where((sid) => !stocksMap.containsKey(sid)),
    (sid) async {
      final loaded = await capella.getStockById(id: sid);
      if (loaded != null && loaded.branchId.isNotEmpty) {
        stocksMap[sid] = loaded;
      }
    },
  );

  final itemsNeedingDeduction = candidateItems.where((item) {
    return !saleLineAlreadyStockDeducted(
      item: item,
      variantsByVariantId: variantsMap,
      stocksByStockId: stocksMap,
      preSaleStockByStockId: preSaleSnapshot,
    );
  }).toList();

  if (itemsNeedingDeduction.isEmpty) {
    logSaleCompletionStage(
      'deferred_stock_deduction',
      sw.elapsedMilliseconds,
      extra: 'skipped=already_deducted',
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

  final deductByStockId = <String, double>{};
  final deductedStockIds = <String>{};
  final clampToZeroStockIds = <String>{};
  for (final e in qtyDeltaPerStock.entries) {
    final sid = e.key;
    final delta = e.value;
    final stock = stocksMap[sid];
    if (stock == null || stock.branchId.isEmpty) continue;
    final current = stock.currentStock;
    if (current == null) continue;

    originalStockQuantities[sid] = current;
    deductedStockIds.add(sid);

    var applyDelta = delta;
    if (allowSellingBelowStock && current - delta < 0) {
      // Clamp at zero: deduct only what is on hand, then force absolute 0.
      applyDelta = current > 0 ? current : 0;
      clampToZeroStockIds.add(sid);
    }
    if (applyDelta > 0) {
      deductByStockId[sid] = applyDelta;
    }
  }

  if (deductByStockId.isEmpty && clampToZeroStockIds.isEmpty) {
    talker.warning(
      'Deferred stock deduction: no stock rows updated for $transactionId '
      '(lines=${itemsNeedingDeduction.length})',
    );
  } else {
    if (deductByStockId.isNotEmpty) {
      await capella.batchDeductStocks(deductByStockId);
    }
    if (clampToZeroStockIds.isNotEmpty) {
      await capella.batchUpdateStocks({
        for (final sid in clampToZeroStockIds)
          sid: (currentStock: 0.0, rsdQty: 0.0),
      });
    }
    await _deferMarkItemsQuantityShipped(
      capella: capella,
      items: itemsNeedingDeduction,
      deductedStockIds: deductedStockIds,
      variantsMap: variantsMap,
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

  logSaleCompletionStage(
    'deferred_stock_deduction',
    sw.elapsedMilliseconds,
    extra:
        'lines=${itemsNeedingDeduction.length} stocks=${deductByStockId.length}',
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
    // One Ditto round trip per line, awaited before the till says "Payment
    // Successful" — the single biggest per-item cost on the Pay path. The work
    // is independent and idempotent per line, so a bounded window is safe and
    // turns 100 sequential trips into ~13.
    final shippable = items.where((item) {
      final sid = variantsMap[item.variantId!]?.stockId;
      return sid != null && deductedStockIds.contains(sid);
    }).toList();

    await forEachBounded(shippable, (item) async {
      item.quantityShipped = item.qty.toInt();
      await capella.updateTransactionItem(
        transactionItemId: item.id,
        quantityShipped: item.quantityShipped,
        ignoreForReport: false,
        skipParentSaleSubtotalRecalc: true,
      );
    });
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

/// Awaits local stock deduction, then schedules RRA I/O without blocking the till.
Future<void> runLocalStockDeductionThenScheduleRra({
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

  // A branch with no EBM registration has no RRA to report stock to. Without
  // this the till spent the wait on a call that could only fail, on a sale
  // that was never going to be signed (`branch=no_tax_receipt`).
  if (!await ebmWillSignReceipt()) {
    talker.debug(
      'Skipping post-sale RRA stock sync: branch is not EBM-registered '
      '(txn=$transactionId)',
    );
    return;
  }

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

  unawaited(
    ProxyService.tax
        .syncStockAfterSuccessfulSaveSales(
          receiptType: receiptType,
          items: transactionItems,
          transaction: transaction,
          highestInvcNo: highestInvcNo,
          sarTyCd: stockIoSarTyCd,
        )
        .catchError((Object e, StackTrace s) {
          talker.error('Post-sale RRA stock sync failed: $e', s);
        }),
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
    runLocalStockDeductionThenScheduleRra(
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
