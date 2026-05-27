import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_services/proxy.dart';

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

  final itemsNeedingDeduction = transactionItems.where((item) {
    if (item.itemTyCd == "3") return false;
    if (item.quantityShipped == item.qty.toInt()) return false;
    final vid = item.variantId;
    return vid != null && vid.isNotEmpty;
  }).toList();

  if (isProformaOrTraining || itemsNeedingDeduction.isEmpty) {
    talker.debug(
      '[sale_completion_timing] deferred_stock_deduction_ms=${sw.elapsedMilliseconds} skipped',
    );
    return originalStockQuantities;
  }

  final variantIds = itemsNeedingDeduction.map((e) => e.variantId!).toSet().toList();
  final variantsMap = await capella.batchGetVariantsByIds(variantIds);

  final stockIds = <String>{};
  for (final item in itemsNeedingDeduction) {
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

  await capella.batchUpdateStocks(stockUpdatesById);

  unawaited(
    _deferMarkItemsQuantityShipped(
      capella: capella,
      items: itemsNeedingDeduction,
      deductedStockIds: deductedStockIds,
      variantsMap: variantsMap,
    ),
  );

  final rraSaleSnapshotKey = rraSaleStockSnapshotBoxKey(transactionId);
  ProxyService.box.remove(key: rraSaleSnapshotKey);
  if (allowSellingBelowStock && originalStockQuantities.isNotEmpty) {
    await ProxyService.box.writeString(
      key: rraSaleSnapshotKey,
      value: jsonEncode(originalStockQuantities),
    );
  }

  talker.debug(
    '[sale_completion_timing] deferred_stock_deduction_ms=${sw.elapsedMilliseconds}',
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
