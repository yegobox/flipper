import 'package:flipper_models/realm_model_export.dart';
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

  DataGridRow _buildStockRow(Stock stock) {
    return DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'Name', value: stock.variant?.productName ?? ''),
      DataGridCell<double>(
          columnName: 'CurrentStock', value: stock.currentStock),
      DataGridCell<double>(
          columnName: 'Price', value: stock.variant?.retailPrice),
    ]);
  }

  DataGridRow _buildTransactionItemRow(TransactionItem transactionItem) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: 'ItemCode',
          value: transactionItem.itemClsCd.toString(),
        ),
        DataGridCell<String>(
          columnName: 'Name',
          value: (() {
            final nameParts = transactionItem.name.split('(');
            final name = nameParts[0].trim().toUpperCase();
            final number =
                nameParts.length > 1 ? nameParts[1].split(')')[0] : '';
            return number.isEmpty ? name : '$name-$number';
          })(),
        ),
        DataGridCell<double>(
          columnName: 'Price',
          value: transactionItem.price,
        ),
        DataGridCell<double>(
          columnName: 'TaxRate',
          value: 0.0,
        ),
        DataGridCell<double>(
          columnName: 'Qty',
          value: transactionItem.qty,
        ),
        DataGridCell<double>(
          columnName: 'TotalSales',
          value: transactionItem.qty * transactionItem.price,
        ),
        DataGridCell<double>(
          columnName: 'CurrentStock',
          value: transactionItem.remainingStock,
        ),
        DataGridCell<double>(
          columnName: 'TaxPayable',
          value: 0.0,
        ),
        DataGridCell<double>(
          columnName: 'GrossProfit',
          value: 0.0,
        ),
      ],
    );
  }

  DataGridRow _buildITransactionRow(ITransaction item) {
    return DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'Name', value: item.invoiceNumber?.toString() ?? "-"),
      DataGridCell<String>(columnName: 'Type', value: item.receiptType ?? "-"),
      DataGridCell<double>(columnName: 'Amount', value: item.subTotal),
      DataGridCell<double>(columnName: 'Cash', value: item.cashReceived),
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
}
