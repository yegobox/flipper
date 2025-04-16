import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/HeaderTransactionItem.dart';
import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionItemDataSource.dart';

import 'package:flipper_dashboard/exportData.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flipper_dashboard/data_view_reports/StockRecount.dart';

class DataView extends StatefulHookConsumerWidget {
  const DataView({
    super.key,
    this.variants,
    this.transactions,
    required this.startDate,
    required this.endDate,
    required this.showDetailedReport,
    required this.rowsPerPage,
    this.transactionItems,
    this.showDetailed = true,
    this.onTapRowShowRefundModal = true,
    this.onTapRowShowRecountModal = false,
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

  @override
  DataViewState createState() => DataViewState();
}

class DataViewState extends ConsumerState<DataView>
    with ExportMixin, DateCoreWidget, Headers {
  static const double dataPagerHeight = 60;
  late DataGridSource _dataGridSource;
  int pageIndex = 0;
  final talker = TalkerFlutter.init();
  double? _exportAccurateTotal;
  bool _isLoadingTotal = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _initializeDataSource();
    _fetchExportAccurateTotal();
  }

  @override
  void didUpdateWidget(DataView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldUpdateDataSource(oldWidget)) {
      _initializeDataSource();
      _fetchExportAccurateTotal();
    }
  }

  bool _shouldUpdateDataSource(DataView oldWidget) {
    return widget.transactionItems != oldWidget.transactionItems ||
        widget.transactions != oldWidget.transactions ||
        widget.rowsPerPage != oldWidget.rowsPerPage;
  }

  void _initializeDataSource() {
    _dataGridSource = _buildDataGridSource(
      showDetailed: widget.showDetailedReport,
      transactionItems: widget.transactionItems,
      transactions: widget.transactions,
      variants: widget.variants,
      rowsPerPage: widget.rowsPerPage,
    );
  }

  void _handleCellTap(DataGridCellTapDetails details) {
    try {
      final rowIndex = details.rowColumnIndex.rowIndex;
      if (rowIndex < 1) return;

      final dataSource = _dataGridSource as DynamicDataSource;
      final data =
          dataSource.data[pageIndex * widget.rowsPerPage + rowIndex - 1];

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
          onRecount: (value) {
            final parsedValue = double.tryParse(value);
            if (parsedValue != null && parsedValue != 0) {
              ProxyService.strategy
                  .updateStock(stockId: data.id, qty: parsedValue);
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
          currency: "RWF",
          transaction: data is ITransaction ? data : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showDetailed = ref.watch(toggleBooleanValueProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildReportTypeSwitch(showDetailed),
                  Spacer(),
                  Tooltip(
                    message: 'Export as CSV',
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: _isExporting
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: Icon(Icons.download_rounded),
                              onPressed: () async {
                                setState(() => _isExporting = true);
                                await _export(headerTitle: "Report");
                                setState(() => _isExporting = false);
                              },
                            ),
                    ),
                  ),
                  Tooltip(
                    message: 'Print',
                    child: IconButton(
                      icon: Icon(Icons.print),
                      onPressed: () {
                        // TODO: Implement print
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  FutureBuilder<double>(
                    future: Future.value(_exportAccurateTotal ?? 0.0),
                    builder: (context, snapshot) {
                      final safeValue = snapshot.data ?? 0.0;
                      return _buildSummaryCard(
                          'Total', safeValue, _isLoadingTotal, Colors.blue);
                    },
                  ),
                  const SizedBox(width: 12),
                  Consumer(
                    builder: (context, ref, _) {
                      final grossProfitAsync =
                          ref.watch(grossProfitStreamProvider(
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                        branchId: ProxyService.box.getBranchId(),
                      ));
                      return _buildSummaryCard(
                        'Gross Profit',
                        grossProfitAsync.value ?? 0.0,
                        grossProfitAsync.isLoading,
                        Colors.green,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Consumer(
                    builder: (context, ref, _) {
                      final netProfitAsync = ref.watch(netProfitStreamProvider(
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                        branchId: ProxyService.box.getBranchId(),
                      ));
                      return _buildSummaryCard(
                        'Net Profit',
                        netProfitAsync.value ?? 0.0,
                        netProfitAsync.isLoading,
                        Colors.purple,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _buildDataGrid(constraints),
              ),
              _buildDataPager(constraints),
              _buildStickyFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      String label, double? value, bool isLoading, Color color) {
    final displayTotal = value ?? 0.0;
    return Expanded(
      child: Card(
        color: color.withOpacity(0.07),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 6),
              isLoading
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: color),
                    )
                  : Text(
                      displayTotal.toRwf(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataGrid(BoxConstraints constraints) {
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
        selectionMode: SelectionMode.multiple,
        allowSorting: true,
        allowColumnsResizing: true,
        key: workBookKey,
        source: _dataGridSource,
        allowFiltering: true,
        highlightRowOnHover: true,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.fill,
        onCellTap: _handleCellTap,
        columns: _getTableHeaders(),
        rowsPerPage: widget.rowsPerPage,
      ),
    );
  }

  Widget _buildStickyFooter() {
    final displayTotal = _exportAccurateTotal;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
              "Total:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            _isLoadingTotal
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    (displayTotal ?? 0.0).toRwf(),
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
    final rowCount = _dataGridSource.rows.length;
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
    if (widget.variants != null && widget.variants!.isNotEmpty) {
      return stockTableHeader(headerPadding);
    } else if (widget.showDetailedReport) {
      return pluReportTableHeader(headerPadding);
    } else {
      return zReportTableHeader(headerPadding);
    }
  }

  /// build an adapter of different view of the data, e.g transactions vs transactionItems and more to be
  /// supported
  DataGridSource _buildDataGridSource({
    required bool showDetailed,
    List<TransactionItem>? transactionItems,
    List<ITransaction>? transactions,
    List<Variant>? variants,
    required int rowsPerPage,
  }) {
    if (transactionItems != null && transactionItems.isNotEmpty) {
      return TransactionItemDataSource(
          transactionItems, rowsPerPage, showDetailed);
    } else if (transactions != null && transactions.isNotEmpty) {
      return TransactionDataSource(transactions, rowsPerPage, showDetailed);
    } else if (variants != null && variants.isNotEmpty) {
      return StockDataSource(variants: variants, rowsPerPage: rowsPerPage);
    }
    throw Exception('No valid data source available');
  }

  Future<void> _fetchExportAccurateTotal() async {
    setState(() {
      _isLoadingTotal = true;
    });
    try {
      final transactions = await ProxyService.strategy.transactions(
        startDate: widget.startDate,
        endDate: widget.endDate,
        isExpense: false,
        branchId: ProxyService.box.getBranchId(),
      );
      final total = transactions.fold<double>(
        0,
        (sum, transaction) => sum + (transaction.subTotal ?? 0),
      );
      setState(() {
        _exportAccurateTotal = total;
        _isLoadingTotal = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTotal = false;
      });
      talker.error('Failed to fetch export-accurate total: $e');
    }
  }

  Future<void> _export({String headerTitle = "Report"}) async {
    if (workBookKey.currentState == null) {
      toast("Error: Workbook is null");
      return;
    }

    /// Expenses these incudes purchases,import and any other type of expenses.
    final expenses = await ProxyService.strategy.transactions(
      startDate: widget.startDate,
      endDate: widget.endDate,
      isExpense: true,
      branchId: ProxyService.box.getBranchId(),
    );

    final sales = await ProxyService.strategy.transactions(
      startDate: widget.startDate,
      endDate: widget.endDate,
      isExpense: false,
      branchId: ProxyService.box.getBranchId(),
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
        isStockRecount: isStockRecount,
        config: config,
        headerTitle: isStockRecount ? "Stock Recount" : headerTitle,
        expenses: expenses,
        bottomEndOfRowTitle: widget.showDetailed == true
            ? "Total Gross Profit"
            : "Closing balance");
  }

  Future<double> _calculateGrossProfit() async {
    if (widget.transactionItems == null) return 0;
    double grossProfit = 0.0;
    for (final item in widget.transactionItems!) {
      // Fetch the associated variant to get the supply price
      final variant =
          await ProxyService.strategy.getVariant(id: item.variantId.toString());
      final supplyPrice = variant?.supplyPrice ?? 0.0;
      grossProfit += (item.price - supplyPrice) * item.qty;
    }
    return grossProfit;
  }

  Future<double> _calculateNetProfit() async {
    if (widget.transactionItems == null) return 0;
    final grossProfit = await _calculateGrossProfit();
    // Example: Subtract total tax if you have tax calculation logic
    double totalTax = 0.0;
    for (final item in widget.transactionItems!) {
      // If you have a tax field, use it here
      // totalTax += item.taxAmount ?? 0.0;
    }
    return grossProfit - totalTax;
  }

  Widget _buildReportTypeSwitch(bool showDetailed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: showDetailed
                ? () {
                    ref
                        .read(toggleBooleanValueProvider.notifier)
                        .toggleReport();
                  }
                : null,
            style: TextButton.styleFrom(
              backgroundColor: !showDetailed ? Colors.blue : Colors.transparent,
              foregroundColor: !showDetailed ? Colors.white : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('Summarized'),
          ),
          TextButton(
            onPressed: !showDetailed
                ? () {
                    ref
                        .read(toggleBooleanValueProvider.notifier)
                        .toggleReport();
                  }
                : null,
            style: TextButton.styleFrom(
              backgroundColor: showDetailed ? Colors.blue : Colors.transparent,
              foregroundColor: showDetailed ? Colors.white : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('Detailed'),
          ),
        ],
      ),
    );
  }
}
