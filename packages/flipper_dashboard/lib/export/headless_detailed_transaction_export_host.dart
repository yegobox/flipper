import 'dart:math' as math;

import 'package:flipper_dashboard/export/export_report_transactions.dart';
import 'package:flipper_dashboard/export/models/expense.dart';
import 'package:flipper_dashboard/export/transaction_report_full_export_loader.dart';
import 'package:flipper_dashboard/export/utils/plu_detailed_report_row.dart';
import 'package:flipper_dashboard/exportData.dart';
import 'package:flipper_dashboard/providers/transaction_report_filters_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/transaction_report_kpi_totals.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Column names for detailed PLU manual export — same order as [pluReportTableHeader].
const int _kTransactionItemsIdChunk = 400;

/// Fallback when batched loaders return no line rows but filtered sales remain.
Future<List<TransactionItem>> _loadLineItemsFromSaleIds(
  List<ITransaction> sales,
) async {
  final ids = sales
      .map((t) => t.id.toString())
      .where((s) => s.isNotEmpty)
      .toSet()
      .toList();
  if (ids.isEmpty) return [];

  final capella = ProxyService.getStrategy(Strategy.capella);
  final merged = <TransactionItem>[];
  for (var i = 0; i < ids.length; i += _kTransactionItemsIdChunk) {
    final end = math.min(i + _kTransactionItemsIdChunk, ids.length);
    final chunk = ids.sublist(i, end);
    final grouped = await capella.transactionItemsForIds(chunk);
    merged.addAll(grouped.values.expand((e) => e));
  }

  final allowed = ids.toSet();
  return merged.where((item) {
    final tid = item.transactionId?.toString();
    return tid != null && allowed.contains(tid);
  }).toList();
}

/// Same row mapping as [DataView._buildManualDataForExport] for [TransactionItemDataSource].
Future<({List<dynamic> manualData, List<String> columnNames})>
buildPluManualExportRows(List<TransactionItem> items) async {
  if (items.isEmpty) {
    return (
      manualData: <dynamic>[],
      columnNames: kPluDetailedExportColumnNames,
    );
  }

  final uniqueTaxTypes = items.map((i) => i.taxTyCd ?? 'B').toSet().toList();
  final taxRateByType = <String, double>{};
  for (final taxType in uniqueTaxTypes) {
    try {
      final config = await ProxyService.getStrategy(
        Strategy.capella,
      ).getByTaxType(taxtype: taxType);
      taxRateByType[taxType] = config?.taxPercentage ?? 18.0;
    } catch (_) {
      taxRateByType[taxType] = 18.0;
    }
  }

  final preparedData = <Map<String, dynamic>>[];
  for (final item in items) {
    final taxType = item.taxTyCd ?? 'B';
    final fromItem = item.taxPercentage?.toDouble();
    // Per-line configured rate: item rate, else the tax type's configured
    // rate, else the 18% default. Honors any configured rate per tax type.
    final taxPercentage = (fromItem != null && fromItem > 0)
        ? fromItem
        : (taxRateByType[taxType] ?? 18.0);
    preparedData.add(
      pluDetailedReportRow(item, taxRatePercent: taxPercentage),
    );
  }
  return (manualData: preparedData, columnNames: kPluDetailedExportColumnNames);
}

/// Invisible [ConsumerStatefulWidget] that runs the same detailed Excel export as
/// [DataView.triggerExport] without mounting [DataView] or [SfDataGrid].
///
/// Sales and PLU lines use [loadTransactionReportSnapshotFullForExport] plus
/// [loadTransactionReportPluLinesForFilteredSales] on the filtered export set;
/// [applyTransactionFiltersToSnapshot] keeps the file aligned with the grid.
///
/// PDF export is not supported here (requires a live grid); callers should catch
/// and show a message when [ProxyService.box.exportAsPdf] is true.
class DetailedTransactionReportExportHost extends ConsumerStatefulWidget {
  const DetailedTransactionReportExportHost({super.key});

  @override
  DetailedTransactionReportExportHostState createState() =>
      DetailedTransactionReportExportHostState();
}

class DetailedTransactionReportExportHostState
    extends ConsumerState<DetailedTransactionReportExportHost>
    with ExportMixin<DetailedTransactionReportExportHost> {
  final GlobalKey<SfDataGridState> _dummyWorkBookKey =
      GlobalKey<SfDataGridState>();

  /// Detailed line-item report for the current [dateRangeProvider] range.
  Future<void> exportDetailedReport({String headerTitle = 'Report'}) async {
    if (ProxyService.box.exportAsPdf()) {
      throw UnsupportedError(
        'PDF export needs the full report screen with a data grid. '
        'Disable PDF export in settings to export Excel from here, or use Reports on desktop.',
      );
    }

    final dateRange = ref.read(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;
    if (startDate == null || endDate == null) {
      throw StateError('missing_date_range');
    }

    final forceRealData = !(ProxyService.box.enableDebug() ?? false);
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      throw StateError('missing_branch');
    }

    final filters = ref.read(transactionReportFiltersProvider);

    final expenseFut = ProxyService.getStrategy(Strategy.capella).transactions(
      startDate: startDate,
      endDate: endDate,
      isExpense: true,
      skipOriginalTransactionCheck: false,
      branchId: branchId,
    );
    final snapFut = loadTransactionReportSnapshotFullForExport(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    );
    final kpiFut = ref.read(transactionReportKpiTotalsProvider.future);

    final batch = await Future.wait([expenseFut, snapFut, kpiFut]);
    final expenseTransactions = batch[0] as List<ITransaction>;
    final fullSnap = batch[1] as TransactionReportSnapshot;
    final kpiTotals = batch[2] as TransactionReportKpiTotals;

    final reportSnap = applyTransactionFiltersToSnapshot(fullSnap, filters);

    final exportSales = exportSalesTransactionsOnly(reportSnap.transactions);

    var items = await loadTransactionReportPluLinesForFilteredSales(
      filteredSales: exportSales,
    );
    items = exportPluItemsSalesOnly(items, exportSales);
    if (items.isEmpty && exportSales.isNotEmpty) {
      items = await _loadLineItemsFromSaleIds(exportSales);
    }

    final expenses = await Expense.fromTransactions(
      expenseTransactions,
      sales: exportSales,
    );
    if (items.isEmpty) {
      throw StateError('no_line_items');
    }

    final (:manualData, :columnNames) = await buildPluManualExportRows(items);

    final config = ExportConfig(
      transactions: exportSales,
      endDate: endDate,
      startDate: startDate,
    );

    final expenseSum = expenseTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );
    config.grossProfit = kpiTotals.pluGrossProfit;
    config.netProfit =
        kpiTotals.pluGrossProfit - kpiTotals.pluLineTax - expenseSum;

    final path = await exportDataGrid(
      workBookKey: _dummyWorkBookKey,
      isStockRecount: false,
      config: config,
      headerTitle: headerTitle,
      expenses: expenses,
      bottomEndOfRowTitle: 'Total Gross Profit',
      showProfitCalculations: true,
      manualData: manualData.isNotEmpty ? manualData : null,
      columnNames: manualData.isNotEmpty ? columnNames : null,
      staticPluLineValues: true,
    );
    if (path == null || path.isEmpty) {
      throw StateError('export_failed');
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
