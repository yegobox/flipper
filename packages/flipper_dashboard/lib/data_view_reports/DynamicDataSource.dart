import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

abstract class DynamicDataSource<T> extends DataGridSource {
  List<T> data = [];
  bool showPluReport = false;
  List<DataGridRow> _dataGridRows = [];
  int _rowsPerPage = 10;

  DynamicDataSource(List<T> initialData, int rowsPerPage) {
    data = initialData;
    _rowsPerPage = rowsPerPage;
    _dataGridRows = buildPaginatedDataGridRows();
    talker.info('DynamicDataSource: Constructor - initialData.length: ${initialData.length}, _rowsPerPage: $_rowsPerPage, _dataGridRows.length: ${_dataGridRows.length}');
  }

  void updateData(List<T> newData) {
    data = newData;
    _dataGridRows = buildPaginatedDataGridRows();
    talker.info('DynamicDataSource: updateData - newData.length: ${newData.length}, _dataGridRows.length: ${_dataGridRows.length}');
    notifyListeners();
  }

  void updateDataSource(List<T> newData, bool newShowPluReport) {
    data = newData;
    showPluReport = newShowPluReport;
    _dataGridRows = buildPaginatedDataGridRows();
    talker.info('DynamicDataSource: updateDataSource - newData.length: ${newData.length}, newShowPluReport: $newShowPluReport, _dataGridRows.length: ${_dataGridRows.length}');
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    talker.info('DynamicDataSource: handlePageChange - oldPageIndex: $oldPageIndex, newPageIndex: $newPageIndex');
    int startIndex = newPageIndex * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (endIndex > data.length) {
      endIndex = data.length;
    }
    _dataGridRows = data.getRange(startIndex, endIndex).map((item) {
      if (item is TransactionItem && showPluReport) {
        return _buildTransactionItemRow(item);
      } else if (item is ITransaction && !showPluReport) {
        return _buildITransactionRow(item);
      } else if (item is Variant) {
        return _buildStockRow(item);
      } else {
        final int numberOfColumns = showPluReport ? 10 : 5; // 10 for detailed, 5 for summary
        return DataGridRow(cells: List.generate(numberOfColumns, (index) => DataGridCell(columnName: 'empty', value: '')));
      }
    }).toList();
    talker.info('DynamicDataSource: handlePageChange - _dataGridRows.length: ${_dataGridRows.length}');
    notifyListeners();
    return true;
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  List<DataGridRow> buildPaginatedDataGridRows() {
    return data.take(_rowsPerPage).map((item) {
      DataGridRow row;
      if (item is TransactionItem && showPluReport) {
        row = _buildTransactionItemRow(item);
      } else if (item is ITransaction && !showPluReport) {
        row = _buildITransactionRow(item);
      } else if (item is Variant) {
        row = _buildStockRow(item);
      } else {
        final int numberOfColumns = showPluReport ? 10 : 5;
        row = DataGridRow(cells: List.generate(numberOfColumns, (index) => DataGridCell(columnName: 'empty', value: '')));
      }
      debugPrint('[DynamicDataSource] buildPaginatedDataGridRows: mode=${showPluReport ? 'detailed' : 'summary'}, cells=${row.getCells().length}');
      return row;
    }).toList();
  }

  DataGridRow _buildStockRow(Variant variant) {
    return DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'Name', value: variant.productName ?? ''),
      DataGridCell<double>(
          columnName: 'CurrentStock',
          value: variant.stock?.currentStock ?? 0.0),
      DataGridCell<double>(
          columnName: 'Price', value: variant.retailPrice ?? 0.0),
    ]);
  }

  DataGridRow _buildTransactionItemRow(TransactionItem transactionItem) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: 'ItemCode',
          value: transactionItem.itemClsCd?.toString() ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Name',
          value: (() {
            final nameParts = (transactionItem.name).split('(');
            final name = nameParts[0].trim().toUpperCase();
            final number =
                nameParts.length > 1 ? nameParts[1].split(')')[0] : '';
            return number.isEmpty ? name : '$name-$number';
          })(),
        ),
        DataGridCell<String>(
          columnName: 'Barcode',
          value: transactionItem.bcd ?? '',
        ),
        DataGridCell<double>(
          columnName: 'Price',
          value: transactionItem.price.toDouble(),
        ),
        DataGridCell<double>(
          columnName: 'TaxRate',
          value: transactionItem.taxTyCd != null
              ? double.tryParse(transactionItem.taxTyCd!) ?? 18.0
              : 18.0,
        ),
        DataGridCell<double>(
          columnName: 'Qty',
          value: transactionItem.qty.toDouble(),
        ),
        DataGridCell<double>(
          columnName: 'TotalSales',
          value: (transactionItem.price.toDouble()) *
                  (transactionItem.qty.toDouble()) -
              (transactionItem.splyAmt?.toDouble() ?? 0.0),
        ),
        DataGridCell<double>(
          columnName: 'CurrentStock',
          value: transactionItem.remainingStock?.toDouble() ?? 0.0,
        ),
        DataGridCell<double>(
          columnName: 'TaxPayable',
          value: transactionItem.taxAmt?.toDouble() ?? 0.0,
        ),
        DataGridCell<double>(
          columnName: 'GrossProfit',
          value: (transactionItem.price.toDouble()) *
                  (transactionItem.qty.toDouble()) -
              (transactionItem.splyAmt ?? 0.0),
        ),
      ],
    );
  }

  DataGridRow _buildITransactionRow(ITransaction trans) {
    // Calculate tax as 18% of subtotal (same estimation as in DataView.dart)

    // Debug logging for tax amount issues
    // print(
    //     'DEBUG: Transaction #${trans.id} - taxAmount: ${trans.taxAmount}, runtimeType: ${trans.taxAmount?.runtimeType}');

    // Convert taxAmount to double explicitly with debug info
    final taxValue = (trans.taxAmount ?? 0.0).toDouble();
    // print(
    //     'DEBUG: After conversion - taxValue: $taxValue, runtimeType: ${taxValue.runtimeType}');

    return DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'Name', value: trans.invoiceNumber?.toString() ?? "-"),
      DataGridCell<String>(columnName: 'Type', value: trans.receiptType ?? "-"),
      DataGridCell<double>(columnName: 'Amount', value: trans.subTotal ?? 0.0),
      DataGridCell<double>(columnName: 'Tax', value: taxValue),
      DataGridCell<double>(
          columnName: 'Cash', value: trans.cashReceived ?? 0.0),
    ]);
  }

  T? getItemAt(int index) {
    if (index >= 0 && index < data.length) {
      return data[index];
    }
    return null;
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
