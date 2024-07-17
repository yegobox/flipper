import 'dart:developer';

import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/RowsPerPageInput.dart';
import 'package:flipper_dashboard/exportExcel.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/realm/schemas.dart';
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

class DataView extends StatefulHookConsumerWidget {
  const DataView({
    super.key,
    this.transactions,
    required this.startDate,
    required this.endDate,
    required this.showPluReport,
    required this.rowsPerPage,
    this.transactionItems,
  });

  final List<ITransaction>? transactions;
  final DateTime startDate;
  final DateTime endDate;
  final bool showPluReport;
  final int rowsPerPage;
  final List<TransactionItem>? transactionItems;

  @override
  DataViewState createState() => DataViewState();
}

class DataViewState extends ConsumerState<DataView>
    with BaseCoreWidgetMixin, DateCoreWidget {
  static const double dataPagerHeight = 60;
  DataGridSource? _dataGridSource;
  int pageIndex = 0;

  final rowsPerPageController = TextEditingController(text: 1000.toString());

  @override
  void initState() {
    super.initState();
    _dataGridSource = _buildDataGridSource(widget.showPluReport,
        widget.transactionItems, widget.transactions, widget.rowsPerPage);
  }

  @override
  void didUpdateWidget(covariant DataView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transactionItems != oldWidget.transactionItems ||
        widget.transactions != oldWidget.transactions ||
        widget.rowsPerPage != oldWidget.rowsPerPage) {
      _dataGridSource = _buildDataGridSource(widget.showPluReport,
          widget.transactionItems, widget.transactions, widget.rowsPerPage);
    }
  }

  @override
  void dispose() {
    rowsPerPageController.dispose();
    super.dispose();
  }

  final talker = TalkerFlutter.init();

  void handleCellTap(DataGridCellTapDetails details) {
    final rowIndex = details.rowColumnIndex.rowIndex;
    if (rowIndex < 1) return;

    final dataSource = _dataGridSource as DynamicDataSource;
    final data = dataSource.data[pageIndex * widget.rowsPerPage + rowIndex - 1];

    talker.warning('Tapped row: ID = ${data.id}, Name = ${data.subTotal}');
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
    const EdgeInsets headerPadding =
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    talker.info("Given data size: ${widget.transactionItems?.length}");

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            widget.showPluReport
                                ? // Toggle Button for PluReport/ZReport
                                Switch(
                                    value: ref.watch(showAiReport),
                                    onChanged: (value) {
                                      ref
                                          .read(showAiReport.notifier)
                                          .toggleReport();
                                      if (ref.read(showAiReport)) {
                                        ref
                                            .read(rowsPerPageProvider.notifier)
                                            .state = 1000;
                                      }
                                    })
                                : const SizedBox.shrink(),
                            widget.showPluReport
                                ? Text(ref.read(showAiReport)
                                    ? 'PLU Report'
                                    : 'ZReport')
                                : SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: RowsPerPageInput(
                                  rowsPerPageProvider: rowsPerPageProvider),
                            ),
                            widget.showPluReport
                                ? datePicker()
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        width: 150.0,
                        child: BoxButton(
                          onTap: () async {
                            talker.info("Exporting data to Excel");
                            if (workBookKey.currentState == null) {
                              toast("Error: Workbook is null");
                            } else {
                              ///
                              final report =
                                  await ProxyService.realm.getReportData();

                              exportDataGridToExcel(
                                endDate: widget.endDate,
                                startDate: widget.startDate,
                                grossProfit: report.grossProfit,
                                netProfit: report.netProfit,
                              );
                            }
                          },
                          borderRadius: 1,
                          title: 'Export to Excel',
                          busy: ref.watch(isProcessingProvider),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerHoverColor: Colors.yellow,
                        gridLineColor: Colors.amber,
                        gridLineStrokeWidth: 1.0,
                        rowHoverColor: Colors.yellow,
                        selectionColor: Colors.yellow,
                        rowHoverTextStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      child: SizedBox(
                        height: constraint.maxHeight - dataPagerHeight,
                        width: constraint.maxWidth,
                        child: SfDataGrid(
                          rowsPerPage: widget.rowsPerPage,
                          allowFiltering: true,
                          highlightRowOnHover: true,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          key: workBookKey,
                          source: _dataGridSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          onCellTap: handleCellTap,
                          columns: widget.showPluReport
                              ? pluReportTableHeader(headerPadding)
                              : zReportTableHeader(headerPadding),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: dataPagerHeight,
                    child: SfDataPager(
                      lastPageItemVisible: false,
                      nextPageItemVisible: false,
                      delegate: _dataGridSource!,
                      pageCount:
                          (_dataGridSource!.rows.length / widget.rowsPerPage)
                              .ceilToDouble(),
                      direction: Axis.horizontal,
                      onPageNavigationEnd: (index) {
                        log("Page Index ${index}");
                        setState(() {
                          pageIndex = index;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<GridColumn> pluReportTableHeader(EdgeInsets headerPadding) {
    return <GridColumn>[
      GridColumn(
        columnName: 'ItemCode',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Item Code', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Name',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Price',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'TaxRate',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Tax Rate', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Qty',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Qty', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'ProfitMade',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('profit made on the sale',
              overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'CurrentStock',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Current stock', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'GrossProfit',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Gross profit made on the sale',
              overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  List<GridColumn> zReportTableHeader(EdgeInsets headerPadding) {
    return <GridColumn>[
      GridColumn(
        columnName: 'Name',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Transaction ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Type',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Receipt Type', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Amount',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Total Amount', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'CashReceived',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Cash Received', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  DataGridSource _buildDataGridSource(
      bool showPluReport,
      List<TransactionItem>? transactionItems,
      List<ITransaction>? transactions,
      int rowsPerPage) {
    if (showPluReport) {
      return TransactionItemDataSource(
          transactionItems!, rowsPerPage, showPluReport);
    } else {
      return TransactionDataSource(transactions!, rowsPerPage, showPluReport);
    }
  }
}

abstract class DynamicDataSource<T> extends DataGridSource {
  List<T> data = []; // Store the data
  bool showPluReport = false; // Add this property

  // Update the rows getter to dynamically check showPluReport
  @override
  List<DataGridRow> get rows {
    if (showPluReport) {
      return data.map((item) {
        if (item is TransactionItem) {
          String name = item.name!.split('(')[0];
          String number = ''; // Initialize number to an empty string

          // Only try to split and get the number if the name has a '('
          if (item.name!.contains('(')) {
            number = item.name!.split('(')[1].split(')')[0];
          }
          name = name.toUpperCase();

          Configurations configurations =
              ProxyService.realm.getByTaxType(taxtype: item.taxTyCd ?? "B");

          String formattedName = '$name-$number';
          return DataGridRow(cells: [
            DataGridCell<String>(
                columnName: 'ItemCode', value: item.itemClsCd.toString()),
            DataGridCell<String>(columnName: 'Name', value: formattedName),
            DataGridCell<double>(columnName: 'Price', value: item.price),
            DataGridCell<double>(
                columnName: 'TaxRate', value: configurations.taxPercentage),
            DataGridCell<double>(columnName: 'Qty', value: item.qty),
            DataGridCell<double>(
                columnName: 'ProfitMade',
                value: ((item.qty * item.price) - (item.qty * item.splyAmt))),
            DataGridCell<double>(
                columnName: 'CurrentStock', value: item.remainingStock),
            DataGridCell<double>(
                columnName: 'GrossProfit',
                value: ((item.qty * item.price) - (item.qty * item.splyAmt))),
          ]);
        } else {
          // Handle the case where item is not a TransactionItem
          return DataGridRow(cells: []);
        }
      }).toList();
    } else {
      return data.map((item) {
        if (item is ITransaction) {
          return DataGridRow(cells: [
            DataGridCell<String>(columnName: 'Name', value: item.id.toString()),
            DataGridCell<String>(
                columnName: 'Type', value: item.receiptType ?? "-"),
            DataGridCell<double>(columnName: 'Amount', value: item.subTotal),
            DataGridCell<double>(
                columnName: 'CashReceived', value: item.cashReceived),
          ]);
        } else {
          // Handle the case where item is not an ITransaction
          return DataGridRow(cells: []);
        }
      }).toList();
    }
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // Handle page change logic here
    return true;
  }

  void buildPaginatedDataGridRows() {
    // Build data grid rows for the current page
  }
}

class TransactionDataSource extends DynamicDataSource<ITransaction> {
  TransactionDataSource(
      List<ITransaction> transactions, this.rowsPerPage, this.showPluReport) {
    data = transactions;
    buildPaginatedDataGridRows();
  }

  final int rowsPerPage;
  bool showPluReport;
  @override
  void buildPaginatedDataGridRows() {
    data = data.sublist(
      0,
      data.length > rowsPerPage ? rowsPerPage : data.length,
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startRowIndex = newPageIndex * rowsPerPage;
    final int endIndex = startRowIndex + rowsPerPage;

    if (startRowIndex < data.length) {
      data = data.sublist(
        startRowIndex,
        endIndex > data.length ? data.length : endIndex,
      );
      notifyListeners();
      return true;
    } else {
      return false; // Prevent page change
    }
  }
}

class TransactionItemDataSource extends DynamicDataSource<TransactionItem> {
  final int rowsPerPage;
  final List<TransactionItem> _allTransactionItems;

  TransactionItemDataSource(
      this._allTransactionItems, this.rowsPerPage, this.showPluReport) {
    buildPaginatedDataGridRows();
  }

  List<TransactionItem> transactionItems = []; // Only visible items
  bool showPluReport;

  @override
  void buildPaginatedDataGridRows() {
    if (_allTransactionItems.isNotEmpty) {
      // Set data to the initial set of items for the first page
      data = _allTransactionItems.sublist(
        0,
        _allTransactionItems.length > rowsPerPage
            ? rowsPerPage
            : _allTransactionItems.length,
      );
      transactionItems.addAll(data);
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startRowIndex = newPageIndex * rowsPerPage;
    final int endIndex = startRowIndex + rowsPerPage;

    if (startRowIndex < _allTransactionItems.length) {
      // Fetch more data if needed
      if (endIndex > _allTransactionItems.length) {
        transactionItems.addAll(_allTransactionItems.sublist(
            transactionItems.length, _allTransactionItems.length));
      }

      // Update data to reflect the new transactionItems
      data = transactionItems.sublist(
        startRowIndex,
        endIndex > transactionItems.length ? transactionItems.length : endIndex,
      );
      notifyListeners();
      return true;
    } else {
      return false; // Prevent page change
    }
  }
}
