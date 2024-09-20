import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class DynamicDataSource<T> extends DataGridSource {
  List<T> data = [];
  bool showPluReport = false;

  // Update the rows getter to dynamically check showPluReport
  @override
  List<DataGridRow> get rows {
    return data.map((item) {
      if (item is TransactionItem && showPluReport) {
        return _buildTransactionItemRow(item);
      } else if (item is ITransaction && !showPluReport) {
        return _buildITransactionRow(item);
      } else if (item is Stock) {
        return _buildStockRow(item);
      } else {
        // Handle other types of items or return an empty row
        return DataGridRow(cells: []);
      }
    }).toList();
  }

  DataGridRow _buildTransactionItemRow(TransactionItem item) {
    var taxConfig =
        ProxyService.local.getByTaxType(taxtype: item.taxTyCd ?? "B");
    double taxPercentage = taxConfig.taxPercentage ?? 0;
    double adjustedTaxPercentage = taxPercentage == 0 ? 1 : taxPercentage;

    String name = item.name!.split('(')[0];
    String number = '';
    if (item.name!.contains('(')) {
      number = item.name!.split('(')[1].split(')')[0];
    }
    name = name.toUpperCase();

    Configurations configurations =
        ProxyService.local.getByTaxType(taxtype: item.taxTyCd ?? "B");

    String formattedName = '$name-$number';
    return DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'ItemCode', value: item.itemClsCd.toString()),
      DataGridCell<String>(columnName: 'Name', value: formattedName),
      DataGridCell<double>(columnName: 'Price', value: item.price),
      DataGridCell<double>(
          columnName: 'TaxRate', value: configurations.taxPercentage),
      DataGridCell<double>(columnName: 'Qty', value: item.qty),
      DataGridCell<double>(
          columnName: 'TotalSales', value: (item.qty * item.price)),
      DataGridCell<double>(
          columnName: 'CurrentStock', value: item.remainingStock),

      ///taxTyCd
      DataGridCell<double>(
        columnName: 'TaxPayable',
        value: taxPercentage == 0
            ? 0
            : (((item.qty * item.price) - (item.qty * item.splyAmt)) *
                    adjustedTaxPercentage /
                    (100 + adjustedTaxPercentage))
                .toPrecision(2),
      ),
      DataGridCell<double>(
          columnName: 'GrossProfit',
          value: ((((item.qty * item.price) - (item.qty * item.splyAmt)))
                  .toPrecision(2)) -
              (((item.qty * item.price) - (item.qty * item.splyAmt)) * 18 / 118)
                  .toPrecision(2)),
    ]);
  }

  DataGridRow _buildITransactionRow(ITransaction item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Name', value: item.id.toString()),
      DataGridCell<String>(columnName: 'Type', value: item.receiptType ?? "-"),
      DataGridCell<double>(columnName: 'Amount', value: item.subTotal),
      DataGridCell<double>(
          columnName: 'CashReceived', value: item.cashReceived),
    ]);
  }

  DataGridRow _buildStockRow(Stock item) {
    return DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'Name', value: item.variant?.productName ?? ''),
      DataGridCell<double>(
          columnName: 'CurrentStock', value: item.currentStock),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // Handle page change logic here
    return true;
  }

  void buildPaginatedDataGridRows() {
    // Build data grid rows for the current page
  }
}
