import 'dart:math' show min;

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/helpers/transaction_report_plu_filters.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_services/proxy.dart';

/// Full-range Transaction Reports snapshot for export — batched reads (still materializes outputs).
Future<TransactionReportSnapshot> loadTransactionReportSnapshotFullForExport({
  required DateTime startDate,
  required DateTime endDate,
  required String branchId,
  required bool forceRealData,
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;

  final total = await capella.countTransactionsReportPagingWindow(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
  );

  const batchSize = 2000;
  var offset = 0;
  final all = <ITransaction>[];

  while (true) {
    final batch = await capella.pageTransactionsReportPagingWindow(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
      limit: batchSize,
      offset: offset,
    );
    if (batch.isEmpty) break;
    all.addAll(transactionReportScopeFilter(batch));
    offset += batch.length;
  }

  final ids = all.map((t) => t.id.toString()).toList();
  final sums = ids.isEmpty
      ? <String, TransactionPaymentSums>{}
      : await getPaymentSumsByTransactionIdsChunked(ids, branchId: branchId);

  return TransactionReportSnapshot(
    transactions: all,
    paymentSumsByTransactionId: sums,
    totalRowCount: total,
  );
}

/// PLU rows for already-filtered **sales** transactions (same scope as export).
///
/// Avoids a second full date-range scan of `pageTransactionsReportPagingWindow`.
Future<List<TransactionItem>> loadTransactionReportPluLinesForFilteredSales({
  required List<ITransaction> filteredSales,
}) async {
  if (filteredSales.isEmpty) return const [];
  final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;

  const chunk = 400;
  final ids = filteredSales
      .map((t) => t.id.toString())
      .where((s) => s.isNotEmpty)
      .toList();

  final out = <TransactionItem>[];
  for (var i = 0; i < ids.length; i += chunk) {
    final end = min(i + chunk, ids.length);
    final sub = ids.sublist(i, end);
    final grouped = await capella.transactionItemsForIds(sub);
    for (final item in grouped.values.expand((e) => e)) {
      if (transactionReportCashMovementPluLine(item)) continue;
      out.add(item);
    }
  }
  return out;
}

/// Line items across the Transaction Reports SQL window — batched; excludes cash-movement pseudo lines.
Future<List<TransactionItem>> loadTransactionReportPluLinesFullForExport({
  required DateTime startDate,
  required DateTime endDate,
  required String branchId,
  required bool forceRealData,
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;

  const batchTx = 2000;
  var offset = 0;
  final out = <TransactionItem>[];

  while (true) {
    final batch = await capella.pageTransactionsReportPagingWindow(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
      limit: batchTx,
      offset: offset,
    );
    if (batch.isEmpty) break;

    final scoped = transactionReportScopeFilter(batch);
    final salesIds = scoped
        .where((t) => t.isExpense != true)
        .map((t) => t.id.toString())
        .toList();

    for (var i = 0; i < salesIds.length; i += 200) {
      final end = min(i + 200, salesIds.length);
      final sub = salesIds.sublist(i, end);
      final grouped = await capella.transactionItemsForIds(sub);
      for (final item in grouped.values.expand((e) => e)) {
        if (transactionReportCashMovementPluLine(item)) continue;
        out.add(item);
      }
    }
    offset += batch.length;
  }

  return out;
}
