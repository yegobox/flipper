import 'dart:io';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_socials/ui/views/home/home_viewmodel.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:share_plus/share_plus.dart';

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class DataView extends StatefulWidget {
  /// Creates the home page.
  const DataView({super.key, required this.transactions});
  final List<ITransaction> transactions;
  @override
  _DataViewState createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  late TransactionDataSource transactionDataSource;
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  bool isProcessing = false;
  static const double dataPagerHeight = 10;

  @override
  void initState() {
    super.initState();

    transactionDataSource =
        TransactionDataSource(transactions: widget.transactions);
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
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (model) {},
        builder: (a, b, c) {
          return Scaffold(
            body: Column(
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
                  child: SfDataGrid(
                    key: _key,
                    source: transactionDataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'id',
                        label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'ID',
                          ),
                        ),
                      ),
                      GridColumn(
                          columnName: 'Type',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Type'))),
                      GridColumn(
                        columnName: 'Amount',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Amount',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'CashReceived',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Cash Received'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: dataPagerHeight,
                  color: Colors.black,
                  child: SfDataPager(
                    delegate: transactionDataSource,
                    pageCount: 10,
                    direction: Axis.horizontal,
                  ),
                )
              ],
            ),
          );
        });
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class TransactionDataSource extends DataGridSource {
  TransactionDataSource({required this.transactions}) {
    buildPaginatedDataGridRows(transactions);
  }
  final int rowsPerPage = 4;

  final List<ITransaction> transactions;
  List<ITransaction> paginatedDataSource = [];

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
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startRowIndex = newPageIndex * rowsPerPage;
    int endIndex = startRowIndex + rowsPerPage;

    if (endIndex > transactions.length) {
      endIndex = transactions.length - 1;
    }

    paginatedDataSource = List.from(
        transactions.getRange(startRowIndex, endIndex).toList(growable: false));
    buildPaginatedDataGridRows(paginatedDataSource);
    notifyListeners();
    return true;
  }

  void buildPaginatedDataGridRows(List<ITransaction> paginatedTransactions) {
    dataGridRows = paginatedTransactions.map<DataGridRow>((transaction) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: transaction.id),
        DataGridCell<String>(
            columnName: 'Type', value: transaction.receiptType ?? "-"),
        DataGridCell<double>(columnName: 'Amount', value: transaction.subTotal),
        DataGridCell<double>(
            columnName: 'CashReceived', value: transaction.cashReceived),
      ]);
    }).toList(growable: false);
  }
}
