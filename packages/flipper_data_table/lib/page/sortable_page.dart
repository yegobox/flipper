import 'package:flipper_data_table/widget/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';

class SortablePage extends StatefulWidget {
  const SortablePage({Key? key, required this.columns, required this.data})
      : super(key: key);
  final List<String> columns;
  final List<TransactionItem> data;

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      ScrollableWidget(child: buildDataTable());

  Widget buildDataTable() {
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: DataTable(
        horizontalMargin: 5,
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(widget.columns),
        rows: getRows(widget.data),
        // columnSpacing: 30,
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(column),
          onSort: onSort,
        ),
      )
      .toList();

  List<DataRow> getRows(List<TransactionItem> users) => users.map((TransactionItem user) {
        final cells = [
          user.name,
          user.price,
          user.remainingStock,
          user.discount ?? 0,
        ];

        return DataRow(
          cells: getCells(cells),
        );
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.data.sort((report1, report2) =>
          compareString(ascending, report1.name, report2.name));
    } else if (columnIndex == 1) {
      widget.data.sort((report1, report2) => compareString(
          ascending, report1.price.toString(), report2.price.toString()));
    } else if (columnIndex == 2) {
      widget.data.sort((report1, report2) => compareString(
          ascending, '${report1.remainingStock}', '${report2.remainingStock}'));
    } else if (columnIndex == 3) {
      widget.data.sort((report, report2) => compareString(
          ascending, '${report.discount}', '${report2.discount}'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
