import 'dart:async';
import 'dart:math' as math;

import 'package:flipper_dashboard/export/models/expense.dart';
import 'package:flipper_dashboard/export/utils/plu_excel_formula_builder.dart';
import 'package:flipper_dashboard/exportData.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Column names for detailed PLU manual export — same order as [pluReportTableHeader].
const int _kTransactionItemsIdChunk = 400;

/// [transactionItemList] uses Rx [.startWith] empty lists, so the stream's first
/// emission is always [] and [ProviderBase.future] can complete before Capella
/// delivers rows (common when nothing else has subscribed yet, e.g. mobile
/// Transactions screen). Listen until we see non-empty data or an empty list
/// that has stayed empty for [debounce].
Future<List<TransactionItem>> _awaitPluLineItems(
  WidgetRef ref, {
  Duration debounce = const Duration(seconds: 5),
}) async {
  final completer = Completer<List<TransactionItem>>();
  Timer? emptyDebounce;
  void onNext(AsyncValue<List<TransactionItem>> next) {
    next.when(
      data: (list) {
        if (list.isNotEmpty) {
          emptyDebounce?.cancel();
          if (!completer.isCompleted) {
            completer.complete(list);
          }
        } else {
          emptyDebounce?.cancel();
          emptyDebounce = Timer(debounce, () {
            final v = ref.read(transactionItemListProvider).value;
            if (!completer.isCompleted) {
              completer.complete(v ?? const []);
            }
          });
        }
      },
      error: (e, st) {
        emptyDebounce?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(e, st);
        }
      },
      loading: () {
        emptyDebounce?.cancel();
      },
    );
  }

  final sub = ref.listenManual(transactionItemListProvider, (prev, next) {
    onNext(next);
  });
  onNext(ref.read(transactionItemListProvider));

  try {
    return await completer.future.timeout(
      const Duration(seconds: 90),
      onTimeout: () {
        emptyDebounce?.cancel();
        return ref.read(transactionItemListProvider).value ?? [];
      },
    );
  } finally {
    emptyDebounce?.cancel();
    sub.close();
  }
}

/// [transactionListProvider] is autoDispose. Awaiting [.future] while nothing
/// else listens lets Riverpod dispose the provider mid-load ("disposed during
/// loading state"). [listenManual] keeps a listener until the first data/error.
Future<List<ITransaction>> _awaitPluSales(
  WidgetRef ref, {
  required bool forceRealData,
}) async {
  final completer = Completer<List<ITransaction>>();
  final provider = transactionListProvider(forceRealData: forceRealData);

  void onNext(AsyncValue<List<ITransaction>> next) {
    next.when(
      data: (list) {
        if (!completer.isCompleted) {
          completer.complete(list);
        }
      },
      error: (e, st) {
        if (!completer.isCompleted) {
          completer.completeError(e, st);
        }
      },
      loading: () {},
    );
  }

  final sub = ref.listenManual(provider, (prev, next) => onNext(next));
  onNext(ref.read(provider));

  try {
    return await completer.future.timeout(
      const Duration(seconds: 90),
      onTimeout: () {
        final v = ref.read(provider);
        if (v.hasValue) {
          return v.requireValue;
        }
        throw TimeoutException(
          'transactionListProvider',
          const Duration(seconds: 90),
        );
      },
    );
  } finally {
    sub.close();
  }
}

/// Fallback when the live item stream stayed empty but we have sale IDs (e.g.
/// some clients still populate items via id lookup reliably).
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
      // Line gross (price × qty); matches Excel formula path and footer SUM(TotalSales).
      'TotalSales': (item.price.toDouble() * item.qty.toDouble())
          .roundToTwoDecimalPlaces(),
      'SupplyAmount': item.splyAmt?.toDouble() ?? 0.0,
      'CurrentStock': TransactionItemPluMetrics.currentStockDisplay(item),
      'TaxPayable': TransactionItemPluMetrics.taxPayable(item),
      'NetProfit': TransactionItemPluMetrics.netProfitColumn(item),
      PluExcelRowKeys.taxTyCd: item.taxTyCd,
      PluExcelRowKeys.discount: item.discount.toDouble(),
      PluExcelRowKeys.splyAmt: item.splyAmt?.toDouble() ?? 0.0,
      PluExcelRowKeys.taxAmt: item.taxAmt,
      PluExcelRowKeys.totAmt: item.totAmt,
      PluExcelRowKeys.taxblAmt: item.taxblAmt,
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
/// Line items and sales are read from [transactionItemListProvider] and
/// [transactionListProvider] so the file matches the Transaction Reports grid
/// (Capella streams). Both providers are autoDispose: we use [Ref.listenManual]
/// instead of awaiting [.future] so they are not disposed mid-load on mobile.
/// A separate [transactions] + [transactionItemsForIds] path
/// often returned no rows on mobile while the grid had data.
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

    final salesSnap = ref.read(
      transactionListProvider(forceRealData: forceRealData),
    );
    final List<ITransaction> sales = salesSnap.hasValue
        ? salesSnap.requireValue
        : await _awaitPluSales(ref, forceRealData: forceRealData);

    var items = await _awaitPluLineItems(ref);
    if (items.isEmpty && sales.isNotEmpty) {
      items = await _loadLineItemsFromSaleIds(sales);
    }

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
      // Line formulas use Sheets-compatible syntax in exportData; set true if a client still errors.
      staticPluLineValues: false,
    );
    if (path == null || path.isEmpty) {
      throw StateError('export_failed');
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
