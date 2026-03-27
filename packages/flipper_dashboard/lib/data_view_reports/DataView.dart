import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/EmptyDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/HeaderTransactionItem.dart';
import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionItemDataSource.dart';
import 'package:flipper_dashboard/export/sale_report.dart';
import 'package:flipper_dashboard/export/report_service.dart';

import 'package:flipper_dashboard/exportData.dart';
import 'package:flipper_dashboard/export/models/expense.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
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
    this.onTapRowShowRefundModal = true,
    this.onTapRowShowRecountModal = false,
    this.forceEmpty = false,
    this.disablePagination = false,
  });

  final List<ITransaction>? transactions;
  final List<Variant>? variants;
  final DateTime startDate;
  final DateTime endDate;
  final bool showDetailedReport;
  final int rowsPerPage;
  final List<TransactionItem>? transactionItems;
  final bool showDetailed;
  final bool onTapRowShowRefundModal;
  final bool onTapRowShowRecountModal;
  final GlobalKey<SfDataGridState> workBookKey;
  final bool forceEmpty;
  final bool disablePagination;

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
    final n = widget.transactionItems?.length ??
        widget.transactions?.length ??
        widget.variants?.length ??
        0;
    if (n <= 0) return widget.rowsPerPage;
    return n;
  }

  /// Same income rule as [grossProfitStream], applied to the loaded transaction list.
  double _footerTotalFromTransactions(List<ITransaction> list) {
    final income = list.where(
      (tx) => !(tx.isExpense ?? false) && !(tx.isRefunded ?? false),
    );
    return income.fold<double>(
      0.0,
      (sum, tx) =>
          sum +
          (tx.status == COMPLETE
              ? (tx.subTotal ?? 0.0)
              : (tx.cashReceived ?? 0.0)),
    );
  }

  /// Sum of the PLU "profit Made" column — matches grid, footer, and export line totals.
  double _pluGrossProfitFromItems() {
    final items = widget.transactionItems;
    if (items == null || items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + TransactionItemPluMetrics.profitMade(item),
    );
  }

  double _pluTotalLineTax() {
    final items = widget.transactionItems;
    if (items == null || items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + TransactionItemPluMetrics.taxPayable(item),
    );
  }

  double _sumExpenseSubtotals(List<ITransaction> expenseTransactions) {
    return expenseTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );
  }

  /// PLU net after line tax and period expenses ([expensesStream] / Capella expense txs).
  double _pluNetAfterTaxAndExpenses(double expenseTotal) {
    return _pluGrossProfitFromItems() - _pluTotalLineTax() - expenseTotal;
  }

  Widget _buildSummaryCardsRow() {
    if (widget.showDetailedReport && widget.transactionItems != null) {
      return Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Gross Profit',
              _pluGrossProfitFromItems(),
              false,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final bid = ProxyService.box.getBranchId();
                final gross = _pluGrossProfitFromItems();
                final tax = _pluTotalLineTax();
                if (bid == null) {
                  return _buildSummaryCard(
                    'Net Profit',
                    gross - tax,
                    false,
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
                    _pluNetAfterTaxAndExpenses(
                      _sumExpenseSubtotals(expenseTxs),
                    ),
                    false,
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
                    false,
                    Colors.purple,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        const SizedBox(width: 12),
        Consumer(
          builder: (context, ref, _) {
            final grossProfitAsync = ref.watch(
              grossProfitStreamProvider(
                startDate: widget.startDate,
                endDate: widget.endDate,
                branchId: ProxyService.box.getBranchId(),
              ),
            );
            return Expanded(
              child: _buildSummaryCard(
                'Gross Profit',
                grossProfitAsync.value ?? 0.0,
                grossProfitAsync.isLoading,
                Colors.green,
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        Consumer(
          builder: (context, ref, _) {
            final netProfitAsync = ref.watch(
              netProfitStreamProvider(
                startDate: widget.startDate,
                endDate: widget.endDate,
                branchId: ProxyService.box.getBranchId(),
              ),
            );
            return Expanded(
              child: _buildSummaryCard(
                'Net Profit',
                netProfitAsync.value ?? 0.0,
                netProfitAsync.isLoading,
                Colors.purple,
              ),
            );
          },
        ),
      ],
    );
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
                await ProxyService.getStrategy(Strategy.capella).updateStock(
                  stockId: data.id,
                  qty: parsedValue,
                );

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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              _buildSummaryCardsRow(),
              const SizedBox(height: 10),
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
    final displayTotal = value ?? 0.0;
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.07),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
            ],
          ),
        ),
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
        headerHoverColor: Colors.yellow,
        gridLineColor: Colors.amber,
        gridLineStrokeWidth: 1.0,
        rowHoverColor: Colors.yellow,
        selectionColor: Colors.yellow,
        rowHoverTextStyle: TextStyle(color: Colors.red, fontSize: 14),
      ),
      child: SfDataGrid(
        key: UniqueKey(), // Always force full rebuild on every render
        selectionMode: SelectionMode.multiple,
        allowSorting: true,
        allowColumnsResizing: true,
        source: _dataGridSource,
        allowFiltering: true,
        highlightRowOnHover: true,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.fill,
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
        headerHoverColor: Colors.yellow,
        gridLineColor: Colors.amber,
        gridLineStrokeWidth: 1.0,
        rowHoverColor: Colors.yellow,
        selectionColor: Colors.yellow,
        rowHoverTextStyle: TextStyle(color: Colors.red, fontSize: 14),
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

  Widget _buildStickyFooter() {
    // Detailed PLU: same total as Gross Profit card / "profit Made" column / export.
    if (widget.showDetailedReport && widget.transactionItems != null) {
      return _stickyFooterRow(
        context,
        label: 'Total profit made:',
        amount: _pluGrossProfitFromItems(),
        isLoading: false,
      );
    }

    // Summary: sum the same amounts as the "Total Amount" column for loaded rows
    // (matches export rows and respects search filtering from the parent).
    if (!widget.showDetailedReport &&
        widget.transactions != null &&
        widget.transactions!.isNotEmpty) {
      final total = _footerTotalFromTransactions(widget.transactions!);
      return _stickyFooterRow(
        context,
        label: 'Total:',
        amount: total,
        isLoading: false,
      );
    }

    return Consumer(
      builder: (context, ref, _) {
        final totalIncomeAsync = ref.watch(
          grossProfitStreamProvider(
            startDate: widget.startDate,
            endDate: widget.endDate,
            branchId: ProxyService.box.getBranchId(),
          ),
        );
        return _stickyFooterRow(
          context,
          label: 'Total:',
          amount: totalIncomeAsync.value ?? 0.0,
          isLoading: totalIncomeAsync.isLoading,
        );
      },
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    amount.toCurrencyFormatted(
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
        columns = pluReportTableHeader(headerPadding); // 10 columns
      } else {
        columns = zReportTableHeader(headerPadding); // 5 columns
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
    List<Variant>? variants,
    required int rowsPerPage,
    int currentPageIndex = 0, // Add currentPageIndex parameter
  }) {
    if (transactionItems != null && transactionItems.isNotEmpty) {
      return TransactionItemDataSource(
        transactionItems,
        rowsPerPage,
        showDetailed,
      );
    } else if (transactions != null && transactions.isNotEmpty) {
      return TransactionDataSource(transactions, rowsPerPage, showDetailed);
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
      final transactions = await ProxyService.getStrategy(Strategy.capella).transactions(
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

  /// Builds manual export data from the full data source (all pages) without using the grid.
  /// This avoids exportToExcelWorkbook() hanging on large datasets and ensures all rows are exported.
  Future<({List<dynamic> manualData, List<String> columnNames})> _buildManualDataForExport() async {
    final columns = _getTableHeaders();
    final columnNames = columns.map((c) => c.columnName).toList();

    if (_dataGridSource is TransactionItemDataSource) {
      final items = _dataGridSource.data.cast<TransactionItem>();
      if (items.isEmpty) return (manualData: [], columnNames: columnNames);

      // Batch tax rate lookups: one DB call per unique tax type instead of per item
      final uniqueTaxTypes = items.map((i) => i.taxTyCd ?? 'B').toSet().toList();
      final taxRateByType = <String, double>{};
      for (final taxType in uniqueTaxTypes) {
        try {
          final config = await ProxyService.getStrategy(Strategy.capella).getByTaxType(taxtype: taxType);
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
          'Barcode': item.bcd ?? '',
          'Price': item.price,
          'TaxRate': taxPercentage,
          'Qty': item.qty,
          'TotalSales': TransactionItemPluMetrics.profitMade(item),
          'CurrentStock': TransactionItemPluMetrics.currentStockDisplay(item),
          'TaxPayable': TransactionItemPluMetrics.taxPayable(item),
          'NetProfit': TransactionItemPluMetrics.netProfitColumn(item),
        });
      }
      return (manualData: preparedData, columnNames: columnNames);
    }

    if (_dataGridSource is TransactionDataSource) {
      final transactions = _dataGridSource.data.cast<ITransaction>();
      if (transactions.isEmpty) return (manualData: [], columnNames: columnNames);

      final preparedData = <Map<String, dynamic>>[];
      for (final transaction in transactions) {
        preparedData.add({
          'Name': transaction.invoiceNumber?.toString() ?? transaction.id.toString(),
          'Type': transaction.receiptType ?? 'Sale',
          'Amount': transaction.subTotal ?? 0.0,
          'Tax': (transaction.taxAmount ?? 0.0).toDouble(),
          'Cash': transaction.cashReceived ?? 0.0,
        });
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

  /// Public method to trigger export from parent widgets.
  /// Exports ALL data in the selected date range (all pages) using manual data path to avoid grid hang.
  Future<void> triggerExport({String headerTitle = "Report"}) async {
    talker.info('triggerExport: headerTitle=$headerTitle, showDetailedReport=${widget.showDetailedReport}');
    try {
      final expenseTransactions = await ProxyService.getStrategy(Strategy.capella).transactions(
        startDate: widget.startDate,
        endDate: widget.endDate,
        isExpense: true,
        skipOriginalTransactionCheck: false,
        branchId: ProxyService.box.getBranchId(),
      );
      final sales = await ProxyService.getStrategy(Strategy.capella).transactions(
        startDate: widget.startDate,
        endDate: widget.endDate,
        isExpense: false,
        skipOriginalTransactionCheck: true,
        branchId: ProxyService.box.getBranchId(),
      );
      final expenses = await Expense.fromTransactions(expenseTransactions, sales: sales);

      final isStockRecount = widget.variants != null && widget.variants!.isNotEmpty;
      final config = ExportConfig(
        transactions: sales,
        endDate: widget.endDate,
        startDate: widget.startDate,
      );
      if (!isStockRecount) {
        config.grossProfit = await _calculateGrossProfit();
        config.netProfit = await _calculateNetProfit();
      }

      final (:manualData, :columnNames) = await _buildManualDataForExport();

      await exportDataGrid(
        workBookKey: widget.workBookKey,
        isStockRecount: isStockRecount,
        config: config,
        headerTitle: isStockRecount ? "Stock Recount" : headerTitle,
        expenses: expenses,
        bottomEndOfRowTitle: widget.showDetailedReport ? "Total Gross Profit" : "Closing balance",
        showProfitCalculations: widget.showDetailedReport,
        manualData: manualData.isNotEmpty ? manualData : null,
        columnNames: manualData.isNotEmpty ? columnNames : null,
      );

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
    final expenseTransactions = await ProxyService.getStrategy(Strategy.capella).transactions(
      startDate: widget.startDate,
      endDate: widget.endDate,
      isExpense: true,
      skipOriginalTransactionCheck: false,
      branchId: ProxyService.box.getBranchId(),
    );
    final sales = await ProxyService.getStrategy(Strategy.capella).transactions(
      startDate: widget.startDate,
      endDate: widget.endDate,
      isExpense: false,
      skipOriginalTransactionCheck: true,
      branchId: ProxyService.box.getBranchId(),
    );
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

    exportDataGrid(
      workBookKey: workBookKey,
      isStockRecount: isStockRecount,
      config: config,
      headerTitle: isStockRecount ? "Stock Recount" : headerTitle,
      expenses: expenses,
      showProfitCalculations: widget.showDetailedReport,
      bottomEndOfRowTitle: widget.showDetailed == true
          ? "Total Gross Profit"
          : "Closing balance",
    );
  }

  /// Same total as the PLU grid "profit Made" / footer / summary Gross Profit card.
  Future<double> _calculateGrossProfit() async => _pluGrossProfitFromItems();

  /// Matches detailed Net Profit card: gross − line tax − expense [subTotal]s in range.
  Future<double> _calculateNetProfit() async {
    final gross = _pluGrossProfitFromItems();
    final tax = _pluTotalLineTax();
    final bid = ProxyService.box.getBranchId();
    if (bid == null) return gross - tax;
    try {
      final expenseTxs = await ProxyService.getStrategy(Strategy.capella).transactions(
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
    talker.info('Export params: startDate=${widget.startDate}, endDate=${widget.endDate}, showDetailed=${widget.showDetailedReport}');
    
    try {
      // Use Capella strategy to avoid database locks
      // Fetch expense transactions for the report
      print('📦 EXPORT: Fetching expense transactions...');
      final expenseTransactions = await ProxyService.getStrategy(Strategy.capella).transactions(
        startDate: widget.startDate,
        endDate: widget.endDate,
        isExpense: true,
        skipOriginalTransactionCheck: false,
        branchId: ProxyService.box.getBranchId(),
      );
      talker.info('Fetched ${expenseTransactions.length} expense transactions');
      print('📦 EXPORT: Fetched ${expenseTransactions.length} expense transactions');

    final sales = await ProxyService.getStrategy(Strategy.capella).transactions(
      startDate: widget.startDate,
      endDate: widget.endDate,
      isExpense: false,

      /// this include NR,CR etc.. in the list needed for full report X,Z report.
      skipOriginalTransactionCheck: true,
      branchId: ProxyService.box.getBranchId(),
    );

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
          rowData['Barcode'] = item.bcd ?? '';
          rowData['Price'] = item.price;

          final taxType = item.taxTyCd ?? 'B';
          final fromItem = item.taxPercentage?.toDouble();
          double taxPercentage;
          if (fromItem != null && fromItem > 0) {
            taxPercentage = fromItem;
          } else {
            final taxConfig = await ProxyService.getStrategy(Strategy.capella)
                .getByTaxType(taxtype: taxType);
            taxPercentage = taxConfig?.taxPercentage ?? 18.0;
          }

          rowData['TaxRate'] = taxPercentage;
          rowData['Qty'] = item.qty;
          rowData['TotalSales'] = TransactionItemPluMetrics.profitMade(item);
          rowData['CurrentStock'] =
              TransactionItemPluMetrics.currentStockDisplay(item);
          rowData['TaxPayable'] = TransactionItemPluMetrics.taxPayable(item);
          rowData['NetProfit'] =
              TransactionItemPluMetrics.netProfitColumn(item);

          preparedData.add(rowData);
        }
      }

      talker.info(
        'Prepared ${preparedData.length} transaction items for export with ${columnNames.length} columns',
      );
      manualData = preparedData;
    } else if (_dataGridSource is TransactionDataSource) {
      // Use transactions directly from widget
      final transactions = widget.transactions ?? [];

      // Prepare data with explicit mapping to ensure all columns are included
      List<Map<String, dynamic>> preparedData = [];

      for (final transaction in transactions) {
        final Map<String, dynamic> rowData = {};

        // Map all the columns explicitly based on the actual Transaction properties
        rowData['Name'] =
            transaction.invoiceNumber?.toString() ?? transaction.id.toString();
        rowData['Type'] = transaction.receiptType ?? 'Sale';
        rowData['Amount'] = transaction.subTotal ?? 0.0;

        // Get tax amount directly from the transaction
        // The taxAmount property has been added to ITransaction and is populated with the sum of all transaction items' tax amounts
        double totalTax = (transaction.taxAmount ?? 0.0).toDouble();

        rowData['Tax'] = totalTax;
        rowData['Cash'] = transaction.cashReceived ?? 0.0;

        preparedData.add(rowData);
      }

      // Get column names from the headers
      columnNames = _getTableHeaders().map((col) => col.columnName).toList();
      talker.info(
        'Prepared ${preparedData.length} transactions for export with ${columnNames.length} columns',
      );
      manualData = preparedData;
    }

    talker.info('Calling exportDataGrid with manualData=${manualData.length} rows');
    
    // Use the exportDataGrid method with our config and manual data
    print('📦 EXPORT: Calling exportDataGrid...');
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
