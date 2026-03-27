import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

/// PLU / detailed-report row values shared by [DynamicDataSource] and Excel export
/// so on-screen totals match exported columns.
class TransactionItemPluMetrics {
  TransactionItemPluMetrics._();

  /// Same as the on-screen "profit Made" ([TotalSales]) column.
  static double profitMade(TransactionItem item) {
    return item.price.toDouble() * item.qty.toDouble() -
        (item.splyAmt?.toDouble() ?? 0.0);
  }

  /// Last column ("Net Profit"); kept aligned with [profitMade] like the current grid.
  static double netProfitColumn(TransactionItem item) => profitMade(item);

  static double currentStockDisplay(TransactionItem item) {
    return item.remainingStock?.toDouble() ??
        item.stock?.currentStock?.toDouble() ??
        0.0;
  }

  /// Uses persisted [TransactionItem.taxAmt] when positive; otherwise derives VAT
  /// from line total and [taxTyCd] (same rules as sale line creation).
  static double taxPayable(TransactionItem item) {
    final existing = item.taxAmt?.toDouble();
    if (existing != null && existing > 0) return existing;

    final ty = item.taxTyCd ?? 'B';
    if (ty == 'D') return 0.0;

    final lineGross = item.price.toDouble() * item.qty.toDouble();
    final base = lineGross - item.discount.toDouble();
    if (base <= 0) return 0.0;

    final pct = item.taxPercentage?.toDouble() ?? 18.0;
    if (ty == 'B' || ty == 'C') {
      return double.parse((base * pct / (100 + pct)).toStringAsFixed(2));
    }
    return double.parse((base * pct / 100).toStringAsFixed(2));
  }
}

abstract class DynamicDataSource<T> extends DataGridSource {
  List<T> data = [];
  bool showPluReport = false;
  List<DataGridRow> _dataGridRows = [];
  int _rowsPerPage = 10;

  DynamicDataSource(
    List<T> initialData,
    int rowsPerPage, {
    this.showPluReport = false,
  }) {
    data = initialData;
    _rowsPerPage = rowsPerPage;
    _dataGridRows = buildPaginatedDataGridRows();
    talker.info(
      'DynamicDataSource: Constructor - initialData.length: ${initialData.length}, _rowsPerPage: $_rowsPerPage, _dataGridRows.length: ${_dataGridRows.length}',
    );
  }

  void updateData(List<T> newData) {
    data = newData;
    _dataGridRows = buildPaginatedDataGridRows();
    talker.info(
      'DynamicDataSource: updateData - newData.length: ${newData.length}, _dataGridRows.length: ${_dataGridRows.length}',
    );
    notifyListeners();
  }

  void updateDataSource(List<T> newData, bool newShowPluReport) {
    data = newData;
    showPluReport = newShowPluReport;
    _dataGridRows = buildPaginatedDataGridRows();
    talker.info(
      'DynamicDataSource: updateDataSource - newData.length: ${newData.length}, newShowPluReport: $newShowPluReport, _dataGridRows.length: ${_dataGridRows.length}',
    );
    notifyListeners();
  }

  /// Loads ALL rows into the grid (bypassing rowsPerPage) so that
  /// SfDataGrid.exportToExcelWorkbook() can export every row, not just the current page.
  void loadAllRowsForExport() {
    _dataGridRows = data.map((item) {
      if (item is TransactionItem && showPluReport) {
        return _buildTransactionItemRow(item);
      } else if (item is ITransaction && !showPluReport) {
        return _buildITransactionRow(item);
      } else if (item is Variant) {
        return _buildStockRow(item);
      } else {
        final int numberOfColumns = showPluReport ? 10 : 5;
        return DataGridRow(
          cells: List.generate(
            numberOfColumns,
            (index) => DataGridCell(columnName: 'empty', value: ''),
          ),
        );
      }
    }).toList();
    talker.info(
      'DynamicDataSource: loadAllRowsForExport - total rows: ${_dataGridRows.length}',
    );
    notifyListeners();
  }

  /// Restores paginated rows after export is done.
  void restorePagedRowsAfterExport(int pageIndex) {
    final startIndex = pageIndex * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage > data.length)
        ? data.length
        : startIndex + _rowsPerPage;
    if (startIndex < data.length) {
      _dataGridRows = data.getRange(startIndex, endIndex).map((item) {
        if (item is TransactionItem && showPluReport) {
          return _buildTransactionItemRow(item);
        } else if (item is ITransaction && !showPluReport) {
          return _buildITransactionRow(item);
        } else if (item is Variant) {
          return _buildStockRow(item);
        } else {
          final int numberOfColumns = showPluReport ? 10 : 5;
          return DataGridRow(
            cells: List.generate(
              numberOfColumns,
              (index) => DataGridCell(columnName: 'empty', value: ''),
            ),
          );
        }
      }).toList();
    } else {
      _dataGridRows = buildPaginatedDataGridRows();
    }
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    talker.info(
      'DynamicDataSource: handlePageChange - oldPageIndex: $oldPageIndex, newPageIndex: $newPageIndex',
    );
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
        final int numberOfColumns = showPluReport
            ? 10
            : 5; // 10 for detailed, 5 for summary
        return DataGridRow(
          cells: List.generate(
            numberOfColumns,
            (index) => DataGridCell(columnName: 'empty', value: ''),
          ),
        );
      }
    }).toList();
    talker.info(
      'DynamicDataSource: handlePageChange - _dataGridRows.length: ${_dataGridRows.length}',
    );
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
        row = DataGridRow(
          cells: List.generate(
            numberOfColumns,
            (index) => DataGridCell(columnName: 'empty', value: ''),
          ),
        );
      }
      debugPrint(
        '[DynamicDataSource] buildPaginatedDataGridRows: mode=${showPluReport ? 'detailed' : 'summary'}, cells=${row.getCells().length}',
      );
      return row;
    }).toList();
  }

  DataGridRow _buildStockRow(Variant variant) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: 'Name',
          value: variant.productName ?? '',
        ),
        DataGridCell<double>(
          columnName: 'CurrentStock',
          value: variant.stock?.currentStock ?? 0.0,
        ),
        DataGridCell<double>(
          columnName: 'Price',
          value: variant.retailPrice ?? 0.0,
        ),
      ],
    );
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
            final number = nameParts.length > 1
                ? nameParts[1].split(')')[0]
                : '';
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
          value: TransactionItemPluMetrics.profitMade(transactionItem),
        ),
        DataGridCell<double>(
          columnName: 'CurrentStock',
          value: TransactionItemPluMetrics.currentStockDisplay(transactionItem),
        ),
        DataGridCell<double>(
          columnName: 'TaxPayable',
          value: TransactionItemPluMetrics.taxPayable(transactionItem),
        ),
        DataGridCell<double>(
          columnName: 'NetProfit',
          value: TransactionItemPluMetrics.netProfitColumn(transactionItem),
        ),
      ],
    );
  }

  DataGridRow _buildITransactionRow(ITransaction trans) {
    final taxValue = (trans.taxAmount ?? 0.0).toDouble();

    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: 'Name',
          value: trans.invoiceNumber?.toString() ?? "-",
        ),
        DataGridCell<String>(
          columnName: 'Type',
          value: trans.receiptType ?? "-",
        ),
        DataGridCell<double>(
          columnName: 'Amount',
          value: trans.subTotal ?? 0.0,
        ),
        DataGridCell<double>(columnName: 'Tax', value: taxValue),
        DataGridCell<double>(
          columnName: 'Cash',
          value: trans.cashReceived ?? 0.0,
        ),
      ],
    );
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
