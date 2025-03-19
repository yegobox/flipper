import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PurchaseDataSource extends DataGridSource {
  final List<Variant> variants;
  final Map<String, double> _editedRetailPrices;
  final Map<String, double> _editedSupplyPrices;
  final Talker talker;
  final VoidCallback updateCallback;
  final void Function({
    required List<Variant> variants,
    required String pchsSttsCd,
  }) acceptPurchases;

  List<DataGridRow> _dataGridRows = [];

  PurchaseDataSource(
    this.variants,
    this._editedRetailPrices,
    this._editedSupplyPrices,
    this.talker,
    this.updateCallback,
    this.acceptPurchases,
  ) {
    _buildDataGridRows();
  }

  void _buildDataGridRows() {
    _dataGridRows = variants.map<DataGridRow>((variant) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Name', value: variant.name),
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
          DataGridCell<Widget>(
            columnName: 'Actions',
            value: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _onStatusChange(variant.id, "02"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _onStatusChange(variant.id, "04"),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  void _onStatusChange(String id, String status) {
    final variant = variants.firstWhere((v) => v.id == id);
    variant.pchsSttsCd = status;
    acceptPurchases(variants: [variant], pchsSttsCd: status);
    talker.log('Status updated for variant ${variant.name} to $status');
    updateCallback();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'Actions') {
          return Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            child: dataGridCell.value,
          );
        }

        final value = dataGridCell.value;
        final formattedValue = dataGridCell.columnName.contains('Price')
            ? '\RWF ${value.toStringAsFixed(2)}'
            : value.toString();

        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: dataGridCell.columnName.contains('Price')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            formattedValue,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}
