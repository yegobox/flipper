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
  final Future<void> Function({
    required List<Variant> variants,
    required String pchsSttsCd,
    required Purchase purchase,
  }) acceptPurchases;
  final Purchase purchase;

  List<DataGridRow> _dataGridRows = [];
  // Track loading state for each variant
  final Map<String, (bool approve, bool decline)> _loadingStates = {};

  PurchaseDataSource(
    this.variants,
    this._editedRetailPrices,
    this._editedSupplyPrices,
    this.talker,
    this.updateCallback,
    this.acceptPurchases,
    this.purchase,
  ) {
    _buildDataGridRows();
  }

  void _buildDataGridRows() {
    _dataGridRows = variants.map<DataGridRow>((variant) {
      final loadingStates = _loadingStates[variant.id] ?? (false, false);
      final isLoadingApprove = loadingStates.$1;
      final isLoadingDecline = loadingStates.$2;

      return DataGridRow(
        cells: [
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
          DataGridCell<_ActionButtons>(
            columnName: 'Actions',
            value: _ActionButtons(
              variantId: variant.id,
              isLoadingApprove: isLoadingApprove,
              isLoadingDecline: isLoadingDecline,
              onApprove: () =>
                  _onStatusChange(variant.id, "02", isApprove: true),
              onDecline: () =>
                  _onStatusChange(variant.id, "04", isApprove: false),
            ),
          ),
        ],
      );
    }).toList();
  }

  Future<void> _onStatusChange(String id, String status,
      {required bool isApprove}) async {
    try {
      // Set loading state
      _setLoading(id,
          isLoadingApprove: isApprove, isLoadingDecline: !isApprove);

      final variant = variants.firstWhere((v) => v.id == id);
      variant.pchsSttsCd = status;

      // Update the variant's status
      await acceptPurchases(
        variants: [variant],
        pchsSttsCd: status,
        purchase: purchase,
      );

      // Remove the variant from the list and rebuild rows
      //variants.removeWhere((v) => v.id == id);  // DO NOT REMOVE HERE, IT'S DONE ON THE UI.
      _setLoading(id,
          isLoadingApprove: false,
          isLoadingDecline: false); // Clean up loading state
      _buildDataGridRows();

      talker.log('Status updated for variant ${variant.name} to $status');
      updateCallback();
    } catch (e) {
      // Reset loading state on error
      _setLoading(id, isLoadingApprove: false, isLoadingDecline: false);
      talker.error('Error updating status: $e');
    }
  }

  void _setLoading(String id,
      {required bool isLoadingApprove, required bool isLoadingDecline}) {
    _loadingStates[id] = (isLoadingApprove, isLoadingDecline);
    _buildDataGridRows();
    notifyListeners();
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
              child: value as _ActionButtons,
            );
          case 'Name':
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(value.toString()),
            );
          case 'Qty':
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Text(value.toString()),
            );
          default:
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text('${value.toString()}'),
            );
        }
      }).toList(),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String variantId;
  final bool isLoadingApprove;
  final bool isLoadingDecline;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  const _ActionButtons({
    required this.variantId,
    required this.isLoadingApprove,
    required this.isLoadingDecline,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: isLoadingApprove
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
              : const Icon(Icons.check, color: Colors.green),
          onPressed: isLoadingApprove ? null : onApprove,
        ),
        IconButton(
          icon: isLoadingDecline
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                )
              : const Icon(Icons.close, color: Colors.red),
          onPressed: isLoadingDecline ? null : onDecline,
        ),
      ],
    );
  }
}
