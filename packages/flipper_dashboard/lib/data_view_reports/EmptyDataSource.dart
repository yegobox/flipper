import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart'; // Import for Container

class EmptyDataSource extends DynamicDataSource<dynamic> {
  final bool showDetailed;

  EmptyDataSource(this.showDetailed) : super([], 10);

  @override
  List<DataGridRow> get rows {
    // Provide a single empty row with the correct number of cells
    // to satisfy SfDataGrid's assertion during initialization.
    final int numberOfColumns = showDetailed ? 10 : 5; // 10 for detailed, 5 for summary
    return [DataGridRow(cells: List.generate(numberOfColumns, (index) => DataGridCell(columnName: 'empty', value: '')))];
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // This method should ideally not be called for EmptyDataSource's own rows,
    // but if it is, return cells matching the expected column count.
    final int numberOfColumns = showDetailed ? 10 : 5;
    return DataGridRowAdapter(cells: List.generate(numberOfColumns, (index) => Container()));
  }
}