import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class DynamicDataSource<T> extends DataGridSource {
  List<T> data = []; // Store the data
  bool showPluReport = false; // Add this property

  // Update the rows getter to dynamically check showPluReport
  @override
  List<DataGridRow> get rows {
    if (showPluReport) {
      return data.map((item) {
        if (item is TransactionItem) {
          String name = item.name!.split('(')[0];
          String number = ''; // Initialize number to an empty string

          // Only try to split and get the number if the name has a '('
          if (item.name!.contains('(')) {
            number = item.name!.split('(')[1].split(')')[0];
          }
          name = name.toUpperCase();

          Configurations configurations =
              ProxyService.realm.getByTaxType(taxtype: item.taxTyCd ?? "B");

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
                columnName: 'ProfitMade',
                value: ((item.qty * item.price) - (item.qty * item.splyAmt))),
            DataGridCell<double>(
                columnName: 'CurrentStock', value: item.remainingStock),
            DataGridCell<double>(
                columnName: 'GrossProfit',
                value: ((item.qty * item.price) - (item.qty * item.splyAmt))),
          ]);
        } else {
          // Handle the case where item is not a TransactionItem
          return DataGridRow(cells: []);
        }
      }).toList();
    } else {
      return data.map((item) {
        if (item is ITransaction) {
          return DataGridRow(cells: [
            DataGridCell<String>(columnName: 'Name', value: item.id.toString()),
            DataGridCell<String>(
                columnName: 'Type', value: item.receiptType ?? "-"),
            DataGridCell<double>(columnName: 'Amount', value: item.subTotal),
            DataGridCell<double>(
                columnName: 'CashReceived', value: item.cashReceived),
          ]);
        } else {
          // Handle the case where item is not an ITransaction
          return DataGridRow(cells: []);
        }
      }).toList();
    }
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
