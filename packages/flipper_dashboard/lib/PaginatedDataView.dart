import 'dart:io';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;

/// Render data pager
class PaginatedDataView extends StatefulWidget {
  /// Create data pager
  const PaginatedDataView({Key? key, required this.transactions})
      : super(key: key);
  final List<ITransaction> transactions;

  @override
  _PaginatedDataGrid createState() => _PaginatedDataGrid();
}

List<ITransaction> transactions = [];
List<ITransaction> paginatedDataSource = [];
final int rowsPerPage = 20;

class _PaginatedDataGrid extends State<PaginatedDataView> {
  static const double dataPagerHeight = 60;

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  late TransactionDataSource _transactionDataSource;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    transactions = widget.transactions;
    _transactionDataSource = TransactionDataSource(transactions: transactions);
    _transactionDataSource..addListener(updateWidget);
  }

  updateWidget() {
    setState(() {});
  }

  Future<void> requestPermissions() async {
    // Request storage permissions
    await [
      permission.Permission.storage,
      permission.Permission.manageExternalStorage,
    ].request();

    // Request notification permission (if needed)
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

    // Get the directory for temporary files
    final Directory tempDir = await getApplicationDocumentsDirectory();
    final File file = File('${tempDir.path}/Report.xlsx');

    // Write the file
    await file.writeAsBytes(bytes);

    workbook.dispose();
    setState(() {
      isProcessing = false;
    });

    var now = DateTime.now();
    var formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // When sharing report
    await Share.shareXFiles([XFile(file.path)],
        subject: "Report Download - $formattedDate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraint) {
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
            SizedBox(
                height: constraint.maxHeight - dataPagerHeight,
                width: constraint.maxWidth,
                child: SfDataGrid(
                    key: _key,
                    source: _transactionDataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: <GridColumn>[
                      GridColumn(
                          columnName: 'id',
                          label: Container(
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Id',
                              ))),
                      GridColumn(
                          columnName: 'Type',
                          label: Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text('Type'))),
                      GridColumn(
                          columnName: 'Amount',
                          label: Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Amount',
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridColumn(
                          columnName: 'CashReceived',
                          label: Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text('Cash Received'))),
                    ])),
            Container(
              height: dataPagerHeight,
              color: Colors.white,
              child: SfDataPager(
                pageCount: (transactions.length / rowsPerPage).ceilToDouble(),
                delegate: _transactionDataSource,
                direction: Axis.horizontal,
              ),
            )
          ],
        );
      }),
    );
  }
}

class TransactionDataSource extends DataGridSource {
  TransactionDataSource({required List<ITransaction> transactions}) {
    paginatedDataSource = transactions.take(rowsPerPage).toList();
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startRowIndex = newPageIndex * rowsPerPage;
    int endIndex = startRowIndex + rowsPerPage;

    if (transactions.length > 0) {
      endIndex = transactions.length - 1;
    } else {
      endIndex = 0; // or some default
    }

    paginatedDataSource = List.from(
        transactions.getRange(startRowIndex, endIndex).toList(growable: false));
    buildPaginatedDataGridRows();
    notifyListeners();
    return true;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedDataSource.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'id', value: dataGridRow.id),
        DataGridCell(columnName: 'Type', value: dataGridRow.receiptType),
        DataGridCell(columnName: 'Amount', value: dataGridRow.subTotal),
        DataGridCell(
            columnName: 'CashReceived', value: dataGridRow.cashReceived),
      ]);
    }).toList(growable: false);
  }
}
