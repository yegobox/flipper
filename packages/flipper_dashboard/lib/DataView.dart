import 'dart:developer';
import 'dart:io';

import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_socials/ui/views/home/home_viewmodel.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:talker_flutter/talker_flutter.dart';

class DataView extends StatefulWidget {
  const DataView({super.key, required this.transactions});

  final List<ITransaction> transactions;

  @override
  _DataViewState createState() => _DataViewState();
}

final int rowsPerPage = 10;
List<ITransaction> paginatedDataSource = [];
List<ITransaction> transactions = [];

class _DataViewState extends State<DataView> {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  bool isProcessing = false;
  static const double dataPagerHeight = 60;
  late TransactionDataSource _transactionDataSource;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    transactions = widget.transactions;
    _transactionDataSource = TransactionDataSource();
    _transactionDataSource.addListener(updateWidget);
  }

  @override
  void dispose() {
    _transactionDataSource.removeListener(updateWidget);
    super.dispose();
  }

  updateWidget() {
    setState(() {});
  }

  Future<void> requestPermissions() async {
    await [
      permission.Permission.storage,
      permission.Permission.manageExternalStorage,
    ].request();

    if (await permission.Permission.notification.isDenied) {
      await permission.Permission.notification.request();
    }
  }

  Future<void> exportDataGridToExcel() async {
    await requestPermissions();
    setState(() {
      isProcessing = true;
    });
    final excel.Workbook workbook = _key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();

    final Directory tempDir = await getApplicationDocumentsDirectory();
    final File file = File('${tempDir.path}/Report.xlsx');

    await file.writeAsBytes(bytes);

    workbook.dispose();
    setState(() {
      isProcessing = false;
    });

    var now = DateTime.now();
    var formattedDate = DateFormat('yyyy-MM-dd').format(now);

    await Share.shareXFiles([XFile(file.path)],
        subject: "Report Download - $formattedDate");
  }

  final talker = TalkerFlutter.init();

  void handleCellTap(DataGridCellTapDetails details) {
    final rowIndex = details.rowColumnIndex.rowIndex;
    if (rowIndex < 1 || rowIndex > transactions.length) return;

    final transaction =
        transactions[pageIndex == 0 ? rowIndex - 1 : rowIndex - 1];

    talker.warning(
        'Tapped row: ID = ${transaction.id}, Name = ${transaction.subTotal}');
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: Refund(
          refundAmount: transaction.subTotal,
          transactionId: transaction.id.toString(),
          currency: "RWF",
          transaction: transaction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets headerPadding =
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 20, 0, 20),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 40.0,
                          width: 150.0,
                          child: BoxButton(
                            onTap: exportDataGridToExcel,
                            borderRadius: 1,
                            title: 'Export to Excel',
                            busy: isProcessing,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(20)),
                      ],
                    ),
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
                          rowsPerPage: rowsPerPage,
                          allowFiltering: true,
                          highlightRowOnHover: true,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          key: _key,
                          source: _transactionDataSource,
                          columnWidthMode: ColumnWidthMode.fill,
                          onCellTap: handleCellTap,
                          columns: <GridColumn>[
                            GridColumn(
                              columnName: 'id',
                              label: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                padding: headerPadding,
                                alignment: Alignment.center,
                                child: const Text('ID',
                                    overflow: TextOverflow.ellipsis),
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
                                child: const Text('Type',
                                    overflow: TextOverflow.ellipsis),
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
                                child: const Text('Amount',
                                    overflow: TextOverflow.ellipsis),
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
                                child: const Text('Cash Received',
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: dataPagerHeight,
                    child: SfDataPager(
                      lastPageItemVisible: false,
                      nextPageItemVisible: false,
                      delegate: _transactionDataSource,
                      pageCount: (widget.transactions.length / rowsPerPage)
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
}

class TransactionDataSource extends DataGridSource {
  TransactionDataSource() {
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

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
    final int startRowIndex = newPageIndex * rowsPerPage;
    final int endIndex = startRowIndex + rowsPerPage;

    if (startRowIndex < transactions.length) {
      paginatedDataSource = transactions.sublist(
        startRowIndex,
        endIndex > transactions.length ? transactions.length : endIndex,
      );
      buildPaginatedDataGridRows();
      notifyListeners();
    }
    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedDataSource.map<DataGridRow>((transaction) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'id', value: transaction.id!.toString()),
        DataGridCell<String>(
            columnName: 'Type', value: transaction.receiptType ?? "-"),
        DataGridCell<double>(columnName: 'Amount', value: transaction.subTotal),
        DataGridCell<double>(
            columnName: 'CashReceived', value: transaction.cashReceived),
      ]);
    }).toList();
  }
}
