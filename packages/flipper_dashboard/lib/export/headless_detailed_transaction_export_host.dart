import 'dart:math' as math;

import 'package:flipper_dashboard/export/models/expense.dart';
import 'package:flipper_dashboard/exportData.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Column names for detailed PLU manual export — same order as [pluReportTableHeader].
const List<String> kPluDetailedExportColumnNames = [
  'ItemCode',
  'Name',
  'Barcode',
  'Price',
  'TaxRate',
  'Qty',
  'TotalSales',
  'SupplyAmount',
  'CurrentStock',
  'TaxPayable',
  'NetProfit',
];

/// Matches [transactionList] after [coreTransactionsStream] (non-expense COMPLETE, no adjustments).
bool _isReportSaleTransaction(ITransaction tx) {
  if (tx.status != COMPLETE || tx.isExpense == true) return false;
  final tt = tx.transactionType?.toString();
  if (tt == null) return true;
  return tt != 'Adjustment' && !tt.endsWith('.Adjustment');
}

/// One-shot load: same data as [transactionListProvider] without waiting on Ditto streams
/// (streams can fail to emit on mobile while the list UI uses [dashboardTransactionsProvider]).
Future<List<ITransaction>> _loadSalesForDetailedExport({
  required DateTime startDate,
  required DateTime endDate,
  required String branchId,
  required bool forceRealData,
}) async {
  final raw = await ProxyService.getStrategy(Strategy.capella).transactions(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    status: COMPLETE,
    isExpense: false,
    skipOriginalTransactionCheck: true,
    forceRealData: forceRealData,
  );
  return raw.where(_isReportSaleTransaction).toList();
}

const int _kTransactionItemsIdChunk = 400;

Future<List<TransactionItem>> _loadLineItemsForSales(
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

double _sumExpenseSubtotals(List<ITransaction> expenseTransactions) {
  return expenseTransactions.fold<double>(
    0.0,
    (sum, tx) => sum + (tx.subTotal ?? 0.0),
  );
}

double _pluGrossProfitFromItemList(List<TransactionItem> items) {
  if (items.isEmpty) return 0.0;
  return items.fold<double>(
    0.0,
    (sum, item) => sum + TransactionItemPluMetrics.profitMade(item),
  );
}

double _pluTotalLineTaxFromList(List<TransactionItem> items) {
  if (items.isEmpty) return 0.0;
  return items.fold<double>(
    0.0,
    (sum, item) => sum + TransactionItemPluMetrics.taxPayable(item),
  );
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
    final taxPercentage = (fromItem != null && fromItem > 0)
        ? fromItem
        : (taxRateByType[taxType] ?? 18.0);
    preparedData.add({
      'ItemCode': item.itemCd,
      'Name': (() {
        final nameParts = item.name.split('(');
        final name = nameParts[0].trim().toUpperCase();
        final number = nameParts.length > 1 ? nameParts[1].split(')')[0] : '';
        return number.isEmpty ? name : '$name-$number';
      })(),
      'Barcode': TransactionItemPluMetrics.barcodeForReport(item),
      'Price': item.price,
      'TaxRate': taxPercentage,
      'Qty': item.qty,
      'TotalSales': TransactionItemPluMetrics.profitMade(item),
      'SupplyAmount': item.splyAmt?.toDouble() ?? 0.0,
      'CurrentStock': TransactionItemPluMetrics.currentStockDisplay(item),
      'TaxPayable': TransactionItemPluMetrics.taxPayable(item),
      'NetProfit': TransactionItemPluMetrics.netProfitColumn(item),
      '__excelRowTaxTyCd': item.taxTyCd,
      '__excelRowDiscount': item.discount.toDouble(),
      '__excelRowSplyAmt': item.splyAmt?.toDouble() ?? 0.0,
      '__excelRowTaxAmt': item.taxAmt,
      '__excelRowTotAmt': item.totAmt,
      '__excelRowTaxblAmt': item.taxblAmt,
    });
  }
  return (manualData: preparedData, columnNames: kPluDetailedExportColumnNames);
}

Future<double> _calculateNetProfitForItems(
  List<TransactionItem> items,
  DateTime startDate,
  DateTime endDate,
) async {
  final gross = _pluGrossProfitFromItemList(items);
  final tax = _pluTotalLineTaxFromList(items);
  final bid = ProxyService.box.getBranchId();
  if (bid == null) return gross - tax;
  try {
    final expenseTxs = await ProxyService.getStrategy(Strategy.capella)
        .transactions(
          startDate: startDate,
          endDate: endDate,
          isExpense: true,
          skipOriginalTransactionCheck: false,
          branchId: bid,
        );
    return gross - tax - _sumExpenseSubtotals(expenseTxs);
  } catch (_) {
    return gross - tax;
  }
}

/// Invisible [ConsumerStatefulWidget] that runs the same detailed Excel export as
/// [DataView.triggerExport] without mounting [DataView] or [SfDataGrid].
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

    final sales = await _loadSalesForDetailedExport(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
    );

    final expenseTransactions = await ProxyService.getStrategy(Strategy.capella)
        .transactions(
          startDate: startDate,
          endDate: endDate,
          isExpense: true,
          skipOriginalTransactionCheck: false,
          branchId: branchId,
        );
    final expenses = await Expense.fromTransactions(
      expenseTransactions,
      sales: sales,
    );

    final items = await _loadLineItemsForSales(sales);
    if (items.isEmpty) {
      throw StateError('no_line_items');
    }

    final (:manualData, :columnNames) = await buildPluManualExportRows(items);

    final config = ExportConfig(
      transactions: sales,
      endDate: endDate,
      startDate: startDate,
    );
    config.grossProfit = _pluGrossProfitFromItemList(items);
    config.netProfit = await _calculateNetProfitForItems(
      items,
      startDate,
      endDate,
    );

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
      // Google Sheets often fails to parse nested PLU formulas in XlsIO .xlsx;
      // static values match the app and keep footer SUMs working.
      staticPluLineValues: true,
    );
    if (path == null || path.isEmpty) {
      throw StateError('export_failed');
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
