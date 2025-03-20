import 'package:flipper_services/proxy.dart';
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
          DataGridCell<String>(columnName: 'Name', value: variant.name ?? ''),
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
          DataGridCell<Widget>(
            columnName: 'Actions',
            value: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
        ],
      );
    }).toList();
  }

  Future<void> _onStatusChange(String id, String status) async {
    final variant = variants.firstWhere((v) => v.id == id);
    variant.pchsSttsCd = status;

    // Update the variant's status
    acceptPurchases(variants: [variant], pchsSttsCd: status);

    // Remove the variant from the list and rebuild rows
    variants.removeWhere((v) => v.id == id);
    _buildDataGridRows();
    
    talker.log('Status updated for variant ${variant.name} to $status');
    notifyListeners(); // Notify the grid to rebuild
    updateCallback();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        final value = dataGridCell.value;

        switch (dataGridCell.columnName) {
          case 'Actions':
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: value as Widget,
            );

          case 'Qty':
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                value.toString(),
                style: const TextStyle(fontSize: 13),
              ),
            );

          case 'Supply Price':
          case 'Retail Price':
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                '\RWF ${(value as double).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14),
              ),
            );

          default: // Name
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                value.toString(),
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
        }
      }).toList(),
    );
  }
}
