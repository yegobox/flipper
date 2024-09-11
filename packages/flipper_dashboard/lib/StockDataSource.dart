import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StockDataSource extends DataGridSource {
  StockDataSource({required List<Stock> stocks}) {
    dataGridRows = stocks.map<DataGridRow>(_stockToDataGridRow).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      // Alternating yellow background for rows
      color: rows.indexOf(row).isEven ? Colors.yellow[100] : Colors.yellow[200],
      cells: row.getCells().map((cell) {
        return Container(
          alignment: cell.columnName == 'variantName'
              ? Alignment.centerLeft // Align the name column to the left
              : Alignment
                  .centerRight, // Align the current stock column to the right
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey, // Bottom border for every cell
                width: 1.0,
              ),
            ),
          ),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  DataGridRow _stockToDataGridRow(Stock stock) {
    return DataGridRow(cells: [
      DataGridCell<String>(
        columnName: 'variantName',
        value: stock.variant?.productName ?? '',
      ),
      DataGridCell<double>(
        columnName: 'currentStock',
        value: stock.currentStock,
      ),
    ]);
  }
}

class StockDataGrid extends HookConsumerWidget {
  const StockDataGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId();
    // Directly watching stocksProvider returning a List<Stock>
    final stocks = ref.watch(stocksProvider((branchId: branchId!)));

    // Memoizing the data source for performance
    final dataSource =
        useMemoized(() => StockDataSource(stocks: stocks), [stocks]);

    return SfDataGrid(
      source: dataSource,
      columnWidthMode: ColumnWidthMode.fill,
      gridLinesVisibility:
          GridLinesVisibility.horizontal, // Horizontal grid lines
      headerGridLinesVisibility:
          GridLinesVisibility.both, // Prominent header grid lines
      columns: [
        GridColumn(
          columnName: 'variantName',
          label: _ColumnHeader(title: 'Variant Name'),
        ),
        GridColumn(
          columnName: 'currentStock',
          label: _ColumnHeader(title: 'Current Stock'),
        ),
      ],
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  final String title;

  const _ColumnHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
