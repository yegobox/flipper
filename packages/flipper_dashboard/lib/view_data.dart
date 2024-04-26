import 'dart:io';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_socials/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:share_plus/share_plus.dart';

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class ViewData extends StatefulWidget {
  /// Creates the home page.
  const ViewData({super.key, required this.employees});
  final List<ITransaction> employees;
  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  late EmployeeDataSource employeeDataSource;
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    super.initState();

    employeeDataSource =
        EmployeeDataSource.DataSource(employeeData: widget.employees);
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
    final excel.Workbook workbook = _key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();

    // Get the directory for temporary files
    final Directory tempDir = await getApplicationDocumentsDirectory();
    final File file = File('${tempDir.path}/DataGrid.xlsx');

    // Write the file
    await file.writeAsBytes(bytes);

    workbook.dispose();

    // Share the file
    await Share.shareXFiles([XFile(file.path)], subject: "Report Download");
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
                  margin: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        width: 150.0,
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: exportDataGridToExcel,
                          child: const Center(
                            child: Text(
                              'Export to Excel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(20)),
                    ],
                  ),
                ),
                Expanded(
                  child: SfDataGrid(
                    key: _key,
                    source: employeeDataSource,
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
                        columnName: 'Cash Received',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Cash Received'),
                        ),
                      ),
                    ],
                  ),
                ),
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
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource.DataSource({required List<ITransaction> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'type', value: e.receiptType),
              DataGridCell<double>(columnName: 'amount', value: e.subTotal),
              DataGridCell<double>(
                  columnName: 'Cash Received', value: e.cashReceived),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

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
}
