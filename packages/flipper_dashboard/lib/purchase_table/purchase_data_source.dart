import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

const Map<String, String> _statusDisplayMap = {
  '01': 'Waiting',
  '02': 'Approved',
  '04': 'Declined',
};

class PurchaseDataSource extends DataGridSource {
  final List<Variant> variants;
  final Map<String, double> _editedRetailPrices;
  final Map<String, double> _editedSupplyPrices;
  final Talker talker;
  final VoidCallback updateCallback;

  List<DataGridRow> _dataGridRows = [];

  PurchaseDataSource(
    this.variants,
    this._editedRetailPrices,
    this._editedSupplyPrices,
    this.talker,
    this.updateCallback,
  ) {
    _buildDataGridRows();
  }

  void _buildDataGridRows() {
    _dataGridRows = variants.asMap().entries.map<DataGridRow>((entry) {
      final index = entry.key;
      final variant = entry.value;

      return DataGridRow(
        cells: [
          DataGridCell<int>(columnName: 'rowNumber', value: index + 1),
          DataGridCell<String>(columnName: 'Name', value: variant.name),
          DataGridCell<String>(
            columnName: 'Qty',
            value: variant.stock?.currentStock?.toString() ?? '0',
          ),
          DataGridCell<double>(
            columnName: 'Supply Price',
            value:
                _editedSupplyPrices[variant.id] ?? variant.supplyPrice ?? 0.0,
          ),
          DataGridCell<double>(
            columnName: 'Retail Price',
            value:
                _editedRetailPrices[variant.id] ?? variant.retailPrice ?? 0.0,
          ),
          DataGridCell<String>(
            columnName: 'Status',
            value: _statusDisplayMap[variant.pchsSttsCd] ??
                variant.pchsSttsCd ??
                'Unknown',
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'rowNumber') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              dataGridCell.value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else if (dataGridCell.columnName == 'Name') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'Status') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'Qty') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Text(dataGridCell.value.toString()),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerRight,
            child: Text('${dataGridCell.value.toString()}'),
          );
        }
      }).toList(),
    );
  }
}
