import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/EmptyDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/HeaderTransactionItem.dart';
import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionItemDataSource.dart';
import 'package:flipper_dashboard/export/sale_report.dart';
import 'package:flipper_dashboard/export/report_service.dart';

import 'package:flipper_dashboard/export/utils/plu_excel_formula_builder.dart';
import 'package:flipper_dashboard/exportData.dart';
import 'package:flipper_dashboard/export/models/expense.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flipper_dashboard/data_view_reports/StockRecount.dart';
import 'package:flipper_dashboard/data_view_reports/report_actions_row.dart';

import 'package:flipper_dashboard/export/plu_report.dart';

class DataView extends StatefulHookConsumerWidget {
  const DataView({
    super.key,
    required this.workBookKey,
    this.variants,
    this.transactions,
    required this.startDate,
    required this.endDate,
    required this.showDetailedReport,
    required this.rowsPerPage,
    this.transactionItems,
    required this.showDetailed,
    this.showActionsRow = true,
    this.onTapRowShowRefundModal = true,
    this.onTapRowShowRecountModal = false,
    this.forceEmpty = false,
    this.disablePagination = false,
    this.paymentSumsByTransactionId,
    this.showKpiStrip = true,
    this.contentPadding = const EdgeInsets.all(12.0),
  });

  final List<ITransaction>? transactions;
  /// Per-row payment breakdown for summary reports (from [transactionReportSnapshotProvider]).
  final Map<String, TransactionPaymentSums>? paymentSumsByTransactionId;
  final List<Variant>? variants;
  final DateTime startDate;
  final DateTime endDate;
  final bool showDetailedReport;
  final int rowsPerPage;
  final List<TransactionItem>? transactionItems;
  final bool showDetailed;
  final bool showActionsRow;
  final bool onTapRowShowRefundModal;
  final bool onTapRowShowRecountModal;
  final GlobalKey<SfDataGridState> workBookKey;
  final bool forceEmpty;
  final bool disablePagination;
  /// When false, KPI cards are omitted (e.g. parent hosts [TransactionReportKpiStrip]).
  final bool showKpiStrip;
  final EdgeInsetsGeometry contentPadding;

  @override
  DataViewState createState() => DataViewState();
}

class DataViewState extends ConsumerState<DataView>
    with ExportMixin, DateCoreWidget, Headers {
  bool _isTransitioning = false;
  bool _showGrid = true;

  Future<void> _handleToggleReport() async {
    setState(() {
      _isTransitioning = true;
      _showGrid = false;
    });
    ref.read(toggleBooleanValueProvider.notifier).toggleReport();
    // Wait for provider and widget rebuilds
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      _updateDataGridSource();
      setState(() {
        _isTransitioning = false;
        _showGrid = true;
      });
    }
  }

  static const double dataPagerHeight = 60;
  int pageIndex = 0; // Keep pageIndex here
  final talker = TalkerFlutter.init();
  // Track loading states for different export operations
  bool _isExportingExcel = false;
  bool _isExportingXReport = false;
  bool _isExportingZReport = false;
  bool _isExportingSaleReport = false;
  bool _isExportingPLUReport = false;

  late DynamicDataSource _dataGridSource;

  @override
  void initState() {
    super.initState();
    talker.info('DataView: initState called.');
    // If forceEmpty, always use EmptyDataSource
    _dataGridSource = widget.forceEmpty
        ? EmptyDataSource(widget.showDetailedReport)
        : _buildDataGridSource(
            showDetailed: widget.showDetailedReport,
            transactionItems: widget.transactionItems,
            transactions: widget.transactions,
            paymentSumsByTransactionId: widget.paymentSumsByTransactionId,
            variants: widget.variants,
            rowsPerPage: _effectiveRowsPerPage(),
            currentPageIndex: pageIndex,
          );
    _fetchExportAccurateTotal();
  }

  @override
  void didUpdateWidget(DataView oldWidget) {
    super.didUpdateWidget(oldWidget);
    talker.info('DataView: didUpdateWidget called.');
    if (_shouldUpdateDataSource(oldWidget)) {
      talker.info('DataView: Data source needs update.');
      setState(() {
        _updateDataGridSource();
      });
      _fetchExportAccurateTotal();
    } else {
      talker.info('DataView: Data source does not need update.');
    }
    debugPrint(
      '[DataView] didUpdateWidget: _isTransitioning=$_isTransitioning',
    );
  }

  @override
  void dispose() {
    // Clean up resources to prevent memory leaks
    _dataGridSource.dispose();
    super.dispose();
  }

  bool _shouldUpdateDataSource(DataView oldWidget) {
    final bool changed =
        widget.transactionItems != oldWidget.transactionItems ||
        widget.transactions != oldWidget.transactions ||
        widget.paymentSumsByTransactionId !=
            oldWidget.paymentSumsByTransactionId ||
        widget.variants != oldWidget.variants ||
        widget.rowsPerPage != oldWidget.rowsPerPage ||
        widget.showDetailedReport != oldWidget.showDetailedReport ||
        widget.disablePagination != oldWidget.disablePagination;
    talker.info('DataView: _shouldUpdateDataSource - changed: $changed');
    return changed;
  }

  /// When pagination is disabled, show every row so totals match export and the footer.
  int _effectiveRowsPerPage() {
    if (!widget.disablePagination) return widget.rowsPerPage;
    final n =
        widget.transactionItems?.length ??
        widget.transactions?.length ??
        widget.variants?.length ??
        0;
    if (n <= 0) return widget.rowsPerPage;
    return n;
  }

  double _pluGrossProfitFromItemList(List<TransactionItem> items) {
    if (items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + TransactionItemPluMetrics.profitMade(item),
    );
  }

  /// Sum of line revenue (price × qty); matches Excel exported [TotalSales] column (P×Q per row).
  double _pluLineRevenueFromItemList(List<TransactionItem> items) {
    if (items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + item.price.toDouble() * item.qty.toDouble(),
    );
  }

  double _pluTotalLineTaxFromList(List<TransactionItem> items) {
    if (items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + TransactionItemPluMetrics.taxPayable(item),
    );
  }

  /// Sum of PLU "profit Made" from parent grid items only (footer / export when detailed).
  double _pluGrossProfitFromItems() {
    final items = widget.transactionItems;
    if (items == null || items.isEmpty) return 0.0;
    return _pluGrossProfitFromItemList(items);
  }

  double _pluTotalLineTax() {
    final items = widget.transactionItems;
    if (items == null || items.isEmpty) return 0.0;
    return _pluTotalLineTaxFromList(items);
  }

  double _sumExpenseSubtotals(List<ITransaction> expenseTransactions) {
    return expenseTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );
  }

  /// Line items for cards: grid payload when present, else full range from [transactionItemListProvider].
  List<TransactionItem> _profitCardItems(
    AsyncValue<List<TransactionItem>> itemsAsync,
  ) {
    return widget.transactionItems ?? itemsAsync.value ?? [];
  }

  bool _profitCardItemsLoading(AsyncValue<List<TransactionItem>> itemsAsync) {
    return widget.transactionItems == null && itemsAsync.isLoading;
  }

  /// Summary + detailed use the same PLU totals as the detailed grid (full-period line items).
  Widget _buildSummaryCardsRow() {
    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final loading = _profitCardItemsLoading(itemsAsync);
              final lineSales = _pluLineRevenueFromItemList(items);
              return _buildSummaryCard(
                'Total Sales',
                lineSales,
                loading,
                Colors.green,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final itemsLoading = _profitCardItemsLoading(itemsAsync);
              final gross = _pluGrossProfitFromItemList(items);
              final tax = _pluTotalLineTaxFromList(items);
              final bid = ProxyService.box.getBranchId();

              if (bid == null) {
                return _buildSummaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                );
              }

              final expAsync = ref.watch(
                expensesStreamProvider(
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                  branchId: bid,
                ),
              );

              return expAsync.when(
                data: (expenseTxs) => _buildSummaryCard(
                  'Net Profit',
                  gross - tax - _sumExpenseSubtotals(expenseTxs),
                  itemsLoading,
                  Colors.purple,
                ),
                loading: () => _buildSummaryCard(
                  'Net Profit',
                  gross - tax,
                  true,
                  Colors.purple,
                ),
                error: (_, __) => _buildSummaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Transaction z-report: four KPI cards in one row (matches design mock).
  Widget _buildFourSummaryKpiRow() {
    final txs = widget.transactions ?? const <ITransaction>[];
    final sumsMap =
        widget.paymentSumsByTransactionId ?? <String, TransactionPaymentSums>{};
    var byHand = 0.0;
    var credit = 0.0;
    for (final tx in txs) {
      final s = sumsMap[tx.id.toString()];
      byHand += transactionReportByHandForTotals(tx, s);
      credit += transactionReportCreditForTotals(tx, s);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final loading = _profitCardItemsLoading(itemsAsync);
              final lineSales = _pluLineRevenueFromItemList(items);
              return _buildSummaryCard(
                'Total Sales',
                lineSales,
                loading,
                Colors.green,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final itemsLoading = _profitCardItemsLoading(itemsAsync);
              final gross = _pluGrossProfitFromItemList(items);
              final tax = _pluTotalLineTaxFromList(items);
              final bid = ProxyService.box.getBranchId();

              if (bid == null) {
                return _buildSummaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                );
              }

              final expAsync = ref.watch(
                expensesStreamProvider(
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                  branchId: bid,
                ),
              );

              return expAsync.when(
                data: (expenseTxs) => _buildSummaryCard(
                  'Net Profit',
                  gross - tax - _sumExpenseSubtotals(expenseTxs),
                  itemsLoading,
                  Colors.purple,
                ),
                loading: () => _buildSummaryCard(
                  'Net Profit',
                  gross - tax,
                  true,
                  Colors.purple,
                ),
                error: (_, __) => _buildSummaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Period \u2014 By Hand',
            byHand,
            false,
            Colors.teal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Period \u2014 Credit',
            credit,
            false,
            Colors.deepOrange,
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildKpiStrip() {
    if (widget.variants != null) {
      return _buildSummaryCardsRow();
    }
    if (widget.showDetailedReport) {
      return _buildSummaryCardsRow();
    }
    return _buildFourSummaryKpiRow();
  }

  void _updateDataGridSource() {
    // If forceEmpty, always use EmptyDataSource
    if (widget.forceEmpty) {
      _dataGridSource = EmptyDataSource(widget.showDetailedReport);
    } else {
      _dataGridSource = _buildDataGridSource(
        showDetailed: widget.showDetailedReport,
        transactionItems: widget.transactionItems,
        transactions: widget.transactions,
        paymentSumsByTransactionId: widget.paymentSumsByTransactionId,
        variants: widget.variants,
        rowsPerPage: _effectiveRowsPerPage(),
        currentPageIndex: pageIndex, // Pass the current page index
      );
    }
    final columns = _getTableHeaders();
    final rows = _dataGridSource.rows;
    debugPrint(
      '[DataView] _updateDataGridSource: showDetailedReport=${widget.showDetailedReport}, columns=${columns.length}, dataGridRows=${rows.length}',
    );
    if (rows.isNotEmpty) {
      final firstRowCells = rows.first.getCells().length;
      if (firstRowCells != columns.length) {
        debugPrint(
          '[DataView][ERROR][updateDataGridSource] Column/cell mismatch: columns=${columns.length}, firstRowCells=$firstRowCells',
        );
      } else {
        debugPrint(
          '[DataView][SYNC][updateDataGridSource] Columns and cells are aligned: ${columns.length}',
        );
      }
    }
    _dataGridSource.notifyListeners(); // Notify listeners of data change
  }

  void _handleCellTap(DataGridCellTapDetails details) {
    final showDetailed = ref.read(toggleBooleanValueProvider);
    if (showDetailed) {
      // Do nothing in detailed view
      return;
    }
    if (details.column.columnName == 'Actions') {
      return;
    }
    try {
      final rowIndex = details.rowColumnIndex.rowIndex;
      if (rowIndex < 1) return;

      final dataSource = _dataGridSource;
      // Calculate the actual index in the full data list based on current page and row index
      final actualIndex = pageIndex * widget.rowsPerPage + rowIndex - 1;
      final data = dataSource.getItemAt(actualIndex);

      if (widget.onTapRowShowRefundModal) {
        _showRefundModal(data);
      }
      if (widget.onTapRowShowRecountModal) {
        _showRecountModal(data);
      }
    } catch (e, s) {
      talker.error(s);
    }
  }

  void _showRecountModal(dynamic data) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: StockRecount(
          itemName: data.productName,
          stockId: data.id,
          onRecount: (value) async {
            final parsedValue = double.tryParse(value);
            if (parsedValue != null && parsedValue != 0) {
              try {
                // Await the updateStock call to catch any errors
                // Use Capella strategy to avoid database locks
                await ProxyService.getStrategy(
                  Strategy.capella,
                ).updateStock(stockId: data.id, qty: parsedValue);

                // Log success for diagnostics
                talker.info(
                  'Stock updated successfully: stockId=${data.id}, qty=$parsedValue',
                );

                // Show success feedback to user
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Stock count updated successfully for ${data.productName}',
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e, s) {
                // Log error for diagnostics
                talker.error(
                  'Failed to update stock: stockId=${data.id}, qty=$parsedValue, error=$e',
                );
                talker.error(s);

                // Show error feedback to user
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to update stock count: ${e.toString()}',
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }

  void _showRefundModal(dynamic data) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: Refund(
          refundAmount: data.subTotal,
          transactionId: data.id.toString(),
          currency: ProxyService.box.defaultCurrency(),
          transaction: data is ITransaction ? data : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[DataView] build: _isTransitioning=$_isTransitioning');
    final showDetailed = ref.watch(toggleBooleanValueProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: widget.contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showActionsRow) ...[
                ReportActionsRow(
                  showDetailed: showDetailed,
                  isExporting: _isExportingExcel,
                  isXReportLoading: _isExportingXReport,
                  isZReportLoading: _isExportingZReport,
                  isSaleReportLoading: _isExportingSaleReport,
                  isPLUReportLoading: _isExportingPLUReport,
                  onExportPressed: () async {
                    setState(() => _isExportingExcel = true);
                    try {
                      await _export(
                        headerTitle: "Report",
                        workBookKey: widget.workBookKey,
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isExportingExcel = false);
                      }
                    }
                  },
                  workBookKey: widget.workBookKey,
                  onPrintPressed: () {
                    // TODO: Implement print
                  },
                  onToggleReport: _handleToggleReport,
                  onXReportPressed: () async {
                    setState(() => _isExportingXReport = true);
                    try {
                      await ReportService().generateReport(reportType: 'X');
                    } finally {
                      if (mounted) {
                        setState(() => _isExportingXReport = false);
                      }
                    }
                  },
                  onZReportPressed: () async {
                    setState(() => _isExportingZReport = true);
                    try {
                      await ReportService().generateReport(
                        reportType: 'Z',
                        endDate: widget.endDate,
                        startDate: widget.startDate,
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isExportingZReport = false);
                      }
                    }
                  },
                  onSaleReportPressed: () async {
                    setState(() => _isExportingSaleReport = true);
                    try {
                      await SaleReport().generateSaleReport(
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isExportingSaleReport = false);
                      }
                    }
                  },
                  onPluReportPressed: () async {
                    setState(() => _isExportingPLUReport = true);
                    try {
                      await PLUReport().generatePLUReport(
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isExportingPLUReport = false);
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
              if (widget.showKpiStrip) ...[
                _buildKpiStrip(),
                const SizedBox(height: 10),
              ],
              Expanded(
                child: (!(_showGrid && !_isTransitioning) || widget.forceEmpty)
                    ? _buildTransitioningGrid(constraints)
                    : Builder(
                        builder: (context) {
                          final columns = _getTableHeaders();
                          final rows = _dataGridSource.rows;
                          final firstRowCells = rows.isNotEmpty
                              ? rows.first.getCells().length
                              : columns.length;
                          if (rows.isNotEmpty &&
                              firstRowCells != columns.length) {
                            debugPrint(
                              '[DataView][WAITING] Waiting for sync: columns=${columns.length}, firstRowCells=$firstRowCells',
                            );
                            return Center(child: CircularProgressIndicator());
                          }
                          return _buildDataGridWithKey(
                            constraints,
                            columns,
                            rows,
                          );
                        },
                      ),
              ),
              if (!widget.disablePagination) _buildDataPager(constraints),
              _buildStickyFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String label,
    double? value,
    bool isLoading,
    Color color,
  ) {
    final raw = value ?? 0.0;
    final displayTotal = double.parse(raw.toStringAsFixed(2));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
        child: Row(
        children: [
          Container(
            width: 6,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  isLoading
                      ? SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color,
                          ),
                        )
                      : Text(
                          displayTotal.toCurrencyFormatted(
                            symbol: ProxyService.box.defaultCurrency(),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataGridWithKey(
    BoxConstraints constraints,
    List<GridColumn> columns,
    List<DataGridRow> rows,
  ) {
    debugPrint(
      '[DataView] _buildDataGridWithKey: columns=${columns.length}, rows=${rows.length}',
    );
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: const Color(0xFFEEF2F7),
        gridLineColor: const Color(0xFFF1F5F9),
        gridLineStrokeWidth: 1.0,
        rowHoverColor: const Color(0xFFF8FAFC),
        selectionColor: const Color(0xFF2563EB).withValues(alpha: 0.06),
      ),
      child: SfDataGrid(
        key: UniqueKey(), // Always force full rebuild on every render
        selectionMode: SelectionMode.multiple,
        allowSorting: true,
        allowColumnsResizing: true,
        source: _dataGridSource,
        allowFiltering: widget.showDetailedReport,
        highlightRowOnHover: true,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columnWidthMode: ColumnWidthMode.fill,
        rowHeight: 56,
        headerRowHeight: 44,
        onCellTap: _handleCellTap,
        columns: columns,
        // Only set rowsPerPage if pagination is not disabled
        rowsPerPage: widget.disablePagination ? null : widget.rowsPerPage,
      ),
    );
  }

  Widget _buildTransitioningGrid(BoxConstraints constraints) {
    // Use the upcoming mode to determine column count
    final columns = widget.showDetailedReport
        ? pluReportTableHeader(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          )
        : zReportTableHeader(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          );
    debugPrint('[DataView] _buildTransitioningGrid: columns=${columns.length}');
    final tempSource = EmptyDataSource(widget.showDetailedReport);
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: const Color(0xFFE8EEF4),
        gridLineColor: Colors.grey.shade200,
        gridLineStrokeWidth: 1.0,
      ),
      child: SfDataGrid(
        key: ObjectKey(
          'transitioning_${widget.showDetailedReport}_${columns.length}',
        ),
        selectionMode: SelectionMode.none,
        allowSorting: false,
        allowColumnsResizing: false,
        source: tempSource,
        allowFiltering: false,
        highlightRowOnHover: false,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.fill,
        columns: columns,
        rowsPerPage: 1,
      ),
    );
  }

  /// PLU detailed: total line revenue (price×qty), same as summing Excel [TotalSales]; stock view sums units.
  Widget _buildStickyFooter() {
    if (widget.variants != null && widget.variants!.isNotEmpty) {
      final totalUnits = widget.variants!.fold<double>(
        0.0,
        (sum, v) => sum + (v.stock?.currentStock?.toDouble() ?? 0.0),
      );
      return _stickyFooterRow(
        context,
        label: 'Total stock (units):',
        amount: totalUnits,
        isLoading: false,
      );
    }

    if (!widget.showDetailedReport &&
        widget.variants == null &&
        widget.transactions != null) {
      return _buildZReportStickyFooter(context, widget.transactions!);
    }

    return Consumer(
      builder: (context, ref, _) {
        final itemsAsync = ref.watch(transactionItemListProvider);
        final items = _profitCardItems(itemsAsync);
        final loading = _profitCardItemsLoading(itemsAsync);
        final total = _pluLineRevenueFromItemList(items);
        return _stickyFooterRow(
          context,
          label: 'Total sales (lines):',
          amount: total,
          isLoading: loading,
        );
      },
    );
  }

  Widget _buildZReportStickyFooter(
    BuildContext context,
    List<ITransaction> txs,
  ) {
    final total = txs.fold<double>(
      0.0,
      (sum, t) => sum + (t.subTotal ?? 0.0),
    );
    final n = txs.length;
    final sym = ProxyService.box.defaultCurrency();
    final amt = double.parse(total.toStringAsFixed(2)).toCurrencyFormatted(
      symbol: sym,
    );
    final pageCount = widget.disablePagination
        ? 1
        : (txs.length / widget.rowsPerPage).ceil().clamp(1, 9999);
    final pagerInteractive = !widget.disablePagination && pageCount > 1;

    void goTo(int target) {
      setState(() {
        pageIndex = target.clamp(0, pageCount - 1);
        _updateDataGridSource();
      });
    }

    Widget pagerIcon(IconData icon, {required bool enabled, required VoidCallback? onTap}) {
      return SizedBox(
        width: 28,
        height: 28,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          splashRadius: 16,
          onPressed: enabled ? onTap : null,
          icon: Icon(
            icon,
            size: 16,
            color: enabled ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Total sales: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: amt,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2563EB),
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: '   $n transactions',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Page ${pageIndex + 1} of $pageCount',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 8),
                pagerIcon(
                  Icons.first_page,
                  enabled: pagerInteractive && pageIndex > 0,
                  onTap: () => goTo(0),
                ),
                pagerIcon(
                  Icons.chevron_left,
                  enabled: pagerInteractive && pageIndex > 0,
                  onTap: () => goTo(pageIndex - 1),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${pageIndex + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                pagerIcon(
                  Icons.chevron_right,
                  enabled: pagerInteractive && pageIndex < pageCount - 1,
                  onTap: () => goTo(pageIndex + 1),
                ),
                pagerIcon(
                  Icons.last_page,
                  enabled: pagerInteractive && pageIndex < pageCount - 1,
                  onTap: () => goTo(pageCount - 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stickyFooterRow(
    BuildContext context, {
    required String label,
    required double amount,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    double.parse(amount.toStringAsFixed(2)).toCurrencyFormatted(
                      symbol: ProxyService.box.defaultCurrency(),
                    ),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataPager(BoxConstraints constraints) {
    // Safely calculate page count to avoid null errors
    final rowCount = _dataGridSource.data.length;
    final pageCount = rowCount > 0
        ? (rowCount / widget.rowsPerPage).ceilToDouble()
        : 1.0; // Default to at least 1 page

    return SizedBox(
      height: dataPagerHeight,
      child: SfDataPager(
        delegate: _dataGridSource,
        pageCount: pageCount,
        direction: Axis.horizontal,
        onPageNavigationEnd: (index) => setState(() => pageIndex = index),
      ),
    );
  }

  List<GridColumn> _getTableHeaders() {
    const headerPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    List<GridColumn> columns;

    // If no specific data is provided, return headers for EmptyDataSource based on showDetailedReport
    if ((widget.variants == null || widget.variants!.isEmpty) &&
        (widget.transactions == null || widget.transactions!.isEmpty) &&
        (widget.transactionItems == null || widget.transactionItems!.isEmpty)) {
      if (widget.showDetailedReport) {
        columns = pluReportTableHeader(headerPadding); // 11 columns
      } else {
        columns = zReportTableHeader(headerPadding); // summary + cashier + actions
      }
    } else if (widget.variants != null && widget.variants!.isNotEmpty) {
      columns = stockTableHeader(headerPadding);
    } else if (widget.showDetailedReport) {
      columns = pluReportTableHeader(headerPadding);
    } else {
      columns = zReportTableHeader(headerPadding);
    }
    // Debug log for column count
    debugPrint(
      '[DataView] _getTableHeaders: mode=${widget.showDetailedReport ? 'detailed' : 'summary'}, columns=${columns.length}',
    );
    return columns;
  }

  /// build an adapter of different view of the data, e.g transactions vs transactionItems and more to be
  /// supported
  DynamicDataSource _buildDataGridSource({
    required bool showDetailed,
    List<TransactionItem>? transactionItems,
    List<ITransaction>? transactions,
    Map<String, TransactionPaymentSums>? paymentSumsByTransactionId,
    List<Variant>? variants,
    required int rowsPerPage,
    int currentPageIndex = 0, // Add currentPageIndex parameter
  }) {
    // PLU line-item grid only when the report toggle is Detailed. In Summary mode we must
    // render [transactions] even if line items are loaded, otherwise [DynamicDataSource]
    // sees TransactionItem + showPluReport false and emits placeholder rows (no column match).
    if (showDetailed &&
        transactionItems != null &&
        transactionItems.isNotEmpty) {
      return TransactionItemDataSource(
        transactionItems,
        rowsPerPage,
        showDetailed,
      );
    } else if (transactions != null && transactions.isNotEmpty) {
      return TransactionDataSource(
        transactions,
        rowsPerPage,
        showDetailed,
        paymentSumsByTransactionId: paymentSumsByTransactionId,
      );
    } else if (variants != null && variants.isNotEmpty) {
      return StockDataSource(variants: variants, rowsPerPage: rowsPerPage);
    }
    return EmptyDataSource(
      showDetailed,
    ); // Pass showDetailed to EmptyDataSource
  }

  Future<void> _fetchExportAccurateTotal() async {
    if (!mounted) return;

    try {
      // Use Capella strategy to avoid database locks
      final transactions = await ProxyService.getStrategy(Strategy.capella)
          .transactions(
            startDate: widget.startDate,
            endDate: widget.endDate,
            isExpense: false,
            skipOriginalTransactionCheck: false,
            branchId: ProxyService.box.getBranchId(),
          );

      if (!mounted) return;

      transactions.fold<double>(
        0,
        (sum, transaction) => sum + (transaction.subTotal ?? 0),
      );
    } catch (e) {
      if (!mounted) return;
      talker.error('Failed to fetch export-accurate total: $e');
    }
  }

  /// Builds manual export data without using the grid.
  ///
  /// [fullSummaryTransactions]: when non-null (summary mode), every row in range — same as Capella
  /// `transactions()` used for [ExportConfig], not the filtered/paginated grid list.
  ///
  /// [fullDetailTransactionItems]: when non-null (detailed / PLU export), use this full list instead
  /// of [_dataGridSource]. Otherwise Excel/PDF fall back to the grid (often **one page ≈ 10 rows**).
  Future<({List<dynamic> manualData, List<String> columnNames})>
  _buildManualDataForExport({
    List<ITransaction>? fullSummaryTransactions,
    Map<String, TransactionPaymentSums>? fullPaymentSumsByTransactionId,
    List<TransactionItem>? fullDetailTransactionItems,
  }) async {
    final columns = _getTableHeaders();
    final columnNames = columns.map((c) => c.columnName).toList();

    // Summary range from Capella — do not depend on [_dataGridSource] type. If this were
    // skipped, [manualData] stays empty and Excel falls back to exportToExcelWorkbook()
    // (current grid page only).
    if (fullSummaryTransactions != null && fullSummaryTransactions.isNotEmpty) {
      final preparedData = <Map<String, dynamic>>[];
      for (final transaction in fullSummaryTransactions) {
        final sums =
            fullPaymentSumsByTransactionId?[transaction.id.toString()];
        preparedData.add(
          Map<String, dynamic>.from(
            transactionSummaryExportRow(transaction, sums),
          ),
        );
      }
      return (manualData: preparedData, columnNames: columnNames);
    }

    final List<TransactionItem>? pluItems =
        (fullDetailTransactionItems != null &&
                fullDetailTransactionItems.isNotEmpty)
            ? fullDetailTransactionItems
            : (_dataGridSource is TransactionItemDataSource
                ? _dataGridSource.data.cast<TransactionItem>()
                : null);

    if (pluItems != null && pluItems.isNotEmpty) {
      final items = pluItems;

      // Batch tax rate lookups: one DB call per unique tax type instead of per item
      final uniqueTaxTypes = items
          .map((i) => i.taxTyCd ?? 'B')
          .toSet()
          .toList();
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
            final number = nameParts.length > 1
                ? nameParts[1].split(')')[0]
                : '';
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
          // Not DataGrid columns — used only by Excel manual export formulas
          PluExcelRowKeys.taxTyCd: item.taxTyCd,
          PluExcelRowKeys.discount: item.discount.toDouble(),
          PluExcelRowKeys.splyAmt: item.splyAmt?.toDouble() ?? 0.0,
          PluExcelRowKeys.taxAmt: item.taxAmt,
          PluExcelRowKeys.totAmt: item.totAmt,
          PluExcelRowKeys.taxblAmt: item.taxblAmt,
        });
      }
      return (manualData: preparedData, columnNames: columnNames);
    }

    if (_dataGridSource is TransactionDataSource) {
      final transactions = _dataGridSource.data.cast<ITransaction>();
      if (transactions.isEmpty)
        return (manualData: [], columnNames: columnNames);

      final preparedData = <Map<String, dynamic>>[];
      for (final transaction in transactions) {
        final sums = widget.paymentSumsByTransactionId?[transaction.id.toString()];
        preparedData.add(
          Map<String, dynamic>.from(
            transactionSummaryExportRow(transaction, sums),
          ),
        );
      }
      return (manualData: preparedData, columnNames: columnNames);
    }

    if (_dataGridSource is StockDataSource) {
      final variants = _dataGridSource.data.cast<Variant>();
      if (variants.isEmpty) return (manualData: [], columnNames: columnNames);

      final preparedData = <Map<String, dynamic>>[];
      for (final v in variants) {
        preparedData.add({
          'Name': v.productName ?? '',
          'CurrentStock': v.stock?.currentStock ?? 0.0,
          'Price': v.retailPrice ?? 0.0,
        });
      }
      return (manualData: preparedData, columnNames: columnNames);
    }

    return (manualData: [], columnNames: columnNames);
  }

  /// PDF export uses the live grid only; expand to all rows first so export is not one page.
  Future<void> _withSummaryPdfFullGridRows(
    Future<void> Function() runExport,
  ) async {
    final expandForPdfSummary =
        ProxyService.box.exportAsPdf() &&
        !widget.showDetailedReport &&
        _dataGridSource is TransactionDataSource;
    final expandForPdfDetailed =
        ProxyService.box.exportAsPdf() &&
        widget.showDetailedReport &&
        _dataGridSource is TransactionItemDataSource;

    final expandForPdf = expandForPdfSummary || expandForPdfDetailed;

    if (expandForPdf) {
      _dataGridSource.loadAllRowsForExport();
    }
    try {
      await runExport();
    } finally {
      if (expandForPdf) {
        _dataGridSource.restorePagedRowsAfterExport(pageIndex);
      }
    }
  }

  /// Public method to trigger export from parent widgets.
  /// Exports ALL data in the selected date range (all pages) using manual data path to avoid grid hang.
  Future<void> triggerExport({
    String headerTitle = "Report",

    /// When provided, export only these summary transactions (filters applied upstream).
    List<ITransaction>? filteredSummaryTransactions,

    /// Optional per-transaction payment sums aligned with [filteredSummaryTransactions].
    Map<String, TransactionPaymentSums>? filteredPaymentSumsByTransactionId,

    /// When provided, detailed export will be restricted to these transaction IDs.
    Set<String>? allowedTransactionIds,
  }) async {
    talker.info(
      'triggerExport: headerTitle=$headerTitle, showDetailedReport=${widget.showDetailedReport}',
    );
    try {
      final expenseTransactions =
          await ProxyService.getStrategy(Strategy.capella).transactions(
            startDate: widget.startDate,
            endDate: widget.endDate,
            isExpense: true,
            skipOriginalTransactionCheck: false,
            branchId: ProxyService.box.getBranchId(),
          );
      final forceRealData = !(ProxyService.box.enableDebug() ?? false);
      final reportSnap = await ref.read(
        transactionReportSnapshotProvider(forceRealData: forceRealData).future,
      );
      final sales = filteredSummaryTransactions ?? reportSnap.transactions;
      final expenses = await Expense.fromTransactions(
        expenseTransactions,
        sales: sales,
      );

      final isStockRecount =
          widget.variants != null && widget.variants!.isNotEmpty;
      final config = ExportConfig(
        transactions: sales,
        endDate: widget.endDate,
        startDate: widget.startDate,
      );
      if (!isStockRecount) {
        config.grossProfit = await _calculateGrossProfit();
        config.netProfit = await _calculateNetProfit();
      }

      List<TransactionItem>? detailLines;
      if (widget.showDetailedReport) {
        final lines = await ref.read(transactionItemListProvider.future);
        if (allowedTransactionIds != null && allowedTransactionIds.isNotEmpty) {
          detailLines = lines
              .where((i) {
                final tid = i.transactionId?.toString();
                return tid != null && allowedTransactionIds.contains(tid);
              })
              .toList();
        } else {
          detailLines = lines;
        }
        talker.info(
          'triggerExport: detailed mode, ${detailLines.length} line items (filtered=${allowedTransactionIds != null})',
        );
      }

      final (:manualData, :columnNames) = await _buildManualDataForExport(
        fullSummaryTransactions: widget.showDetailedReport ? null : sales,
        fullPaymentSumsByTransactionId: widget.showDetailedReport
            ? null
            : (filteredPaymentSumsByTransactionId ??
                reportSnap.paymentSumsByTransactionId),
        fullDetailTransactionItems: detailLines,
      );

      await _withSummaryPdfFullGridRows(() async {
        await exportDataGrid(
          workBookKey: widget.workBookKey,
          isStockRecount: isStockRecount,
          config: config,
          headerTitle: isStockRecount ? "Stock Recount" : headerTitle,
          expenses: expenses,
          bottomEndOfRowTitle: widget.showDetailedReport
              ? "Total Gross Profit"
              : "Closing balance",
          showProfitCalculations: widget.showDetailedReport,
          manualData: manualData.isNotEmpty ? manualData : null,
          columnNames: manualData.isNotEmpty ? columnNames : null,
        );
      });

      talker.info('Export completed successfully');
    } catch (e, s) {
      talker.error('Export failed: $e');
      talker.error(s);
      rethrow;
    }
  }

  Future<void> _export({
    String headerTitle = "Report",
    required GlobalKey<SfDataGridState> workBookKey,
  }) async {
    // Check if we're in detailed view mode
    final showDetailed = widget.showDetailedReport;

    // For detailed view, we'll use a direct export approach instead of relying on the DataGrid state
    if (showDetailed) {
      talker.info('Using direct export for detailed view');
      await _exportDirectly(headerTitle: headerTitle);
      return;
    }

    // For summarized view, try to use the DataGrid state
    if (workBookKey.currentState == null) {
      talker.warning('DataGrid state is null, waiting for initialization...');

      // Force a rebuild of the UI and wait for it to complete
      if (mounted) {
        // Give the UI time to rebuild
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    // Check again after waiting
    if (workBookKey.currentState == null) {
      talker.warning(
        'DataGrid state still null after waiting, using direct export',
      );
      await _exportDirectly(headerTitle: headerTitle);
      return;
    }

    /// Expenses these incudes purchases,import and any other type of expenses.
    final expenseTransactions = await ProxyService.getStrategy(Strategy.capella)
        .transactions(
          startDate: widget.startDate,
          endDate: widget.endDate,
          isExpense: true,
          skipOriginalTransactionCheck: false,
          branchId: ProxyService.box.getBranchId(),
        );
    final forceRealData = !(ProxyService.box.enableDebug() ?? false);
    final reportSnap = await ref.read(
      transactionReportSnapshotProvider(forceRealData: forceRealData).future,
    );
    final sales = reportSnap.transactions;
    // Convert transactions to Expense model
    final expenses = await Expense.fromTransactions(
      expenseTransactions,
      sales: sales,
    );

    final isStockRecount =
        widget.variants != null && widget.variants!.isNotEmpty;
    final config = ExportConfig(
      transactions: sales,
      endDate: widget.endDate,
      startDate: widget.startDate,
    );

    if (!isStockRecount) {
      config.grossProfit = await _calculateGrossProfit();
      config.netProfit = await _calculateNetProfit();
    }

    final (:manualData, :columnNames) = await _buildManualDataForExport(
      fullSummaryTransactions: sales,
      fullPaymentSumsByTransactionId: reportSnap.paymentSumsByTransactionId,
    );

    await _withSummaryPdfFullGridRows(() async {
      await exportDataGrid(
        workBookKey: workBookKey,
        isStockRecount: isStockRecount,
        config: config,
        headerTitle: isStockRecount ? "Stock Recount" : headerTitle,
        expenses: expenses,
        showProfitCalculations: widget.showDetailedReport,
        bottomEndOfRowTitle: widget.showDetailed == true
            ? "Total Gross Profit"
            : "Closing balance",
        manualData: manualData.isNotEmpty ? manualData : null,
        columnNames: manualData.isNotEmpty ? columnNames : null,
      );
    });
  }

  /// Sum of [TransactionItemPluMetrics.profitMade] (margin before tax); used for export [ExportConfig] / net-profit math, not the green "Gross Profit" card (that uses line revenue like Excel TotalSales).
  Future<double> _calculateGrossProfit() async => _pluGrossProfitFromItems();

  /// Matches detailed Net Profit card: gross − line tax − expense [subTotal]s in range.
  Future<double> _calculateNetProfit() async {
    final gross = _pluGrossProfitFromItems();
    final tax = _pluTotalLineTax();
    final bid = ProxyService.box.getBranchId();
    if (bid == null) return gross - tax;
    try {
      final expenseTxs = await ProxyService.getStrategy(Strategy.capella)
          .transactions(
            startDate: widget.startDate,
            endDate: widget.endDate,
            isExpense: true,
            skipOriginalTransactionCheck: false,
            branchId: bid,
          );
      return gross - tax - _sumExpenseSubtotals(expenseTxs);
    } catch (e) {
      talker.error('Net profit (export): expense fetch failed: $e');
      return gross - tax;
    }
  }

  /// Direct export method that doesn't rely on the DataGrid state
  /// This is used as a fallback when the DataGrid state is null
  Future<void> _exportDirectly({required String headerTitle}) async {
    print('📦 EXPORT: Starting direct export process');
    talker.info('Starting direct export process');
    talker.info(
      'Export params: startDate=${widget.startDate}, endDate=${widget.endDate}, showDetailed=${widget.showDetailedReport}',
    );

    try {
      // Use Capella strategy to avoid database locks
      // Fetch expense transactions for the report
      print('📦 EXPORT: Fetching expense transactions...');
      final expenseTransactions =
          await ProxyService.getStrategy(Strategy.capella).transactions(
            startDate: widget.startDate,
            endDate: widget.endDate,
            isExpense: true,
            skipOriginalTransactionCheck: false,
            branchId: ProxyService.box.getBranchId(),
          );
      talker.info('Fetched ${expenseTransactions.length} expense transactions');
      print(
        '📦 EXPORT: Fetched ${expenseTransactions.length} expense transactions',
      );

      final forceRealData = !(ProxyService.box.enableDebug() ?? false);
      final reportSnap = await ref.read(
        transactionReportSnapshotProvider(forceRealData: forceRealData).future,
      );
      final sales = reportSnap.transactions;

      // Convert transactions to Expense model
      final expenses = await Expense.fromTransactions(
        expenseTransactions,
        sales: sales,
      );

      final isStockRecount =
          widget.variants != null && widget.variants!.isNotEmpty;

      // Create export config
      final config = ExportConfig(
        transactions: sales,
        endDate: widget.endDate,
        startDate: widget.startDate,
      );

      if (!isStockRecount) {
        config.grossProfit = await _calculateGrossProfit();
        config.netProfit = await _calculateNetProfit();
      }

      // Extract data and column names from the data source for manual export
      List<dynamic> manualData = [];
      List<String> columnNames = [];
      List<Map<String, dynamic>> preparedData = [];

      // Get data from the appropriate data source based on view type
      if (_dataGridSource is TransactionItemDataSource) {
        // Use transaction items directly from widget
        manualData = widget.transactionItems ?? [];

        // Get column names from the headers
        final headers = _getTableHeaders();
        columnNames = headers.map((col) => col.columnName).toList();

        // Prepare data with explicit mapping to ensure all columns are included
        for (final item in manualData) {
          if (item is TransactionItem) {
            final Map<String, dynamic> rowData = {};

            // Map all the columns explicitly based on the actual TransactionItem properties
            rowData['ItemCode'] = item.itemCd;
            rowData['Name'] = item.name;
            final barcode = TransactionItemPluMetrics.barcodeForReport(item);
            rowData['Barcode'] = barcode.isEmpty ? '-' : barcode;
            rowData['Price'] = item.price;

            final taxType = item.taxTyCd ?? 'B';
            final fromItem = item.taxPercentage?.toDouble();
            double taxPercentage;
            if (fromItem != null && fromItem > 0) {
              taxPercentage = fromItem;
            } else {
              final taxConfig = await ProxyService.getStrategy(
                Strategy.capella,
              ).getByTaxType(taxtype: taxType);
              taxPercentage = taxConfig?.taxPercentage ?? 18.0;
            }

            rowData['TaxRate'] = taxPercentage;
            rowData['Qty'] = item.qty;
            rowData['TotalSales'] =
                (item.price.toDouble() * item.qty.toDouble())
                    .roundToTwoDecimalPlaces();
            rowData['SupplyAmount'] = item.splyAmt?.toDouble() ?? 0.0;
            rowData['CurrentStock'] =
                TransactionItemPluMetrics.currentStockDisplay(item);
            rowData['TaxPayable'] = TransactionItemPluMetrics.taxPayable(item);
            rowData['NetProfit'] = TransactionItemPluMetrics.netProfitColumn(
              item,
            );
            rowData[PluExcelRowKeys.taxTyCd] = item.taxTyCd;
            rowData[PluExcelRowKeys.discount] = item.discount.toDouble();
            rowData[PluExcelRowKeys.splyAmt] = item.splyAmt?.toDouble() ?? 0.0;
            rowData[PluExcelRowKeys.taxAmt] = item.taxAmt;
            rowData[PluExcelRowKeys.totAmt] = item.totAmt;
            rowData[PluExcelRowKeys.taxblAmt] = item.taxblAmt;

            preparedData.add(rowData);
          }
        }

        talker.info(
          'Prepared ${preparedData.length} transaction items for export with ${columnNames.length} columns',
        );
        manualData = preparedData;
      } else if (_dataGridSource is TransactionDataSource) {
        // Full date-range list (same as [ExportConfig.transactions]), not grid/widget subset.
        final transactions = sales;
        final sumsMap = reportSnap.paymentSumsByTransactionId;

        // Prepare data with explicit mapping to ensure all columns are included
        List<Map<String, dynamic>> preparedData = [];

        for (final transaction in transactions) {
          final sums = sumsMap[transaction.id.toString()];
          preparedData.add(
            Map<String, dynamic>.from(
              transactionSummaryExportRow(transaction, sums),
            ),
          );
        }

        // Get column names from the headers
        columnNames = _getTableHeaders().map((col) => col.columnName).toList();
        talker.info(
          'Prepared ${preparedData.length} transactions for export with ${columnNames.length} columns',
        );
        manualData = preparedData;
      }

      talker.info(
        'Calling exportDataGrid with manualData=${manualData.length} rows',
      );

      // Use the exportDataGrid method with our config and manual data
      print('📦 EXPORT: Calling exportDataGrid...');
      await _withSummaryPdfFullGridRows(() async {
        await exportDataGrid(
          workBookKey: widget.workBookKey, // Use the widget's key
          isStockRecount: isStockRecount,
          config: config,
          headerTitle: isStockRecount ? "Stock Recount" : headerTitle,
          expenses: expenses,
          bottomEndOfRowTitle: widget.showDetailedReport
              ? "Total Gross Profit"
              : "Closing balance",
          manualData: manualData,
          columnNames: columnNames,
          // Only show profit calculations in detailed report mode
          showProfitCalculations: widget.showDetailedReport,
        );
      });

      talker.info('Export completed successfully');
      print('✅ EXPORT: File saved successfully');
    } catch (e, s) {
      print('❌ EXPORT: Failed with error: $e');
      talker.error('Export failed with error: $e');
      talker.error(s);
      rethrow;
    }
  }
}
