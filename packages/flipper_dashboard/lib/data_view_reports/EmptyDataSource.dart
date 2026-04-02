import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart'; // Import for Container

import 'package:flutter/foundation.dart' hide Category;

class EmptyDataSource extends DynamicDataSource<dynamic> {
  final bool showDetailed;

  EmptyDataSource(this.showDetailed) : super([], 11);

  @override
  List<DataGridRow> get rows {
    // Provide a single empty row with the correct number of cells
    // to satisfy SfDataGrid's assertion during initialization.
    final int numberOfColumns = showDetailed
        ? 11
        : kTransactionSummaryColumnCount;
    return [
      DataGridRow(
        cells: List.generate(
          numberOfColumns,
          (index) => DataGridCell(columnName: 'empty', value: ''),
        ),
      ),
    ];
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int numberOfColumns =
        showDetailed ? 11 : kTransactionSummaryColumnCount;
    debugPrint(
      '[EmptyDataSource] buildRow: mode=${showDetailed ? 'detailed' : 'summary'}, cells=$numberOfColumns',
    );
    return DataGridRowAdapter(
      cells: List.generate(numberOfColumns, (index) => Container()),
    );
  }
}
