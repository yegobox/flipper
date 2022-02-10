import 'package:flipper_data_table/data/users.dart';
import 'package:flipper_data_table/model/user.dart';
import 'package:flipper_data_table/widget/scrollable_widget.dart';
import 'package:flutter/material.dart';
// import 'package:fluent_ui/fluent_ui.dart' as FluentUI;

const double splitButtonHeight = 25.0;

class SortablePage extends StatefulWidget {
  const SortablePage({Key? key}) : super(key: key);

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  late List<User> users;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();

    users = List.of(allUsers);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    final columns = ['First Name', 'Last Name', 'Age'];
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: DataTable(
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(users),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<User> users) => users.map((User user) {
        final cells = [user.firstName, user.lastName, user.age];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      users.sort((user1, user2) =>
          compareString(ascending, user1.firstName, user2.firstName));
    } else if (columnIndex == 1) {
      users.sort((user1, user2) =>
          compareString(ascending, user1.lastName, user2.lastName));
    } else if (columnIndex == 2) {
      users.sort((user1, user2) =>
          compareString(ascending, '${user1.age}', '${user2.age}'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
