import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/HeaderTransactionItem.dart';
import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/RowsPerPageInput.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionDataSource.dart';
import 'package:flipper_dashboard/data_view_reports/TransactionItemDataSource.dart';

import 'package:flipper_dashboard/exportData.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/views/home/home_viewmodel.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeDataSource();
  }

  @override
  void didUpdateWidget(DataView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldUpdateDataSource(oldWidget)) {
      _initializeDataSource();
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
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => LayoutBuilder(
        builder: (context, constraint) => Column(
          children: [
            _buildHeader(),
            SizedBox(
              height: 10,
            ),
            Expanded(child: _buildDataGrid(constraint)),
            _buildDataPager(constraint),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (widget.showDetailed) _buildReportTypeSwitch(),
        _buildRowsPerPageInput(),
        if (widget.showDetailedReport) datePicker(),
        _buildExportButton(),
        datePicker(),
      ],
    );
  }

  Widget _buildReportTypeSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ref.read(toggleBooleanValueProvider) ? 'Detailed' : 'Summarized',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Switch.adaptive(
            activeColor: Colors.blue,
            value: ref.watch(toggleBooleanValueProvider),
            onChanged: (value) {
              ref.read(toggleBooleanValueProvider.notifier).toggleReport();
              if (ref.read(toggleBooleanValueProvider)) {
                ref.read(rowsPerPageProvider.notifier).state = 1000;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRowsPerPageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: RowsPerPageInput(rowsPerPageProvider: rowsPerPageProvider),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      height: 40.0,
      width: 150.0,
      child: FlipperButton(
        onPressed: _export,
        height: 80,
        text: 'Export',
        textColor: Colors.black,
        busy: ref.watch(isProcessingProvider),
      ),
    );
  }

  Widget _buildDataGrid(BoxConstraints constraint) {
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
        // Remove the Expanded widget here
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
        footer: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:"),
              Text(widget.transactions
                      ?.fold<double>(0,
                          (sum, transaction) => sum + transaction.cashReceived!)
                      .toRwf() ??
                  ""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataPager(BoxConstraints constraint) {
    return SizedBox(
      height: dataPagerHeight,
      child: SfDataPager(
        delegate: _dataGridSource,
        pageCount:
            (_dataGridSource.rows.length / widget.rowsPerPage).ceilToDouble(),
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
      config.grossProfit = _calculateGrossProfit();
      config.netProfit = _calculateNetProfit();
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

  double _calculateGrossProfit() {
    if (widget.transactionItems == null) return 0;
    return widget.transactionItems!.fold<double>(
      0.0,
      (sum, item) => sum + ((item.qty * item.price) - (item.qty * item.price)),
    );
  }

  double _calculateNetProfit() {
    if (widget.transactionItems == null) return 0;
    final grossProfit = _calculateGrossProfit();
    final taxAmount = widget.transactionItems!.fold<double>(
      0.0,
      (sum, item) =>
          sum +
          (((item.qty * item.price) - (item.qty * item.price)) * 18 / 118),
    );
    return grossProfit - taxAmount;
  }
}
