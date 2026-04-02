import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

/// Column count for transaction summary grid (non-PLU).
const int kTransactionSummaryColumnCount = 8;

String _transactionReportStatusLabel(ITransaction tx) {
  if (tx.status == PARKED) return 'Parked';
  if (tx.status == COMPLETE) return 'Completed';
  return tx.status ?? '—';
}

double _reportByHand(ITransaction tx, TransactionPaymentSums? sums) {
  if (sums == null || !sums.hasAnyRecord) {
    return tx.cashReceived ?? 0.0;
  }
  return sums.byHand;
}

double _reportCredit(ITransaction tx, TransactionPaymentSums? sums) {
  if (sums == null || !sums.hasAnyRecord) return 0.0;
  return sums.credit;
}

double _reportBalanceDue(ITransaction tx) {
  final rb = tx.remainingBalance;
  if (rb != null && rb > 0.01) return rb.toDouble();
  if (tx.isLoan == true) return (rb ?? 0.0).toDouble();
  return 0.0;
}

/// Public wrappers for DataView export and period totals.
double transactionReportByHandForTotals(
  ITransaction tx,
  TransactionPaymentSums? sums,
) =>
    _reportByHand(tx, sums);

double transactionReportCreditForTotals(
  ITransaction tx,
  TransactionPaymentSums? sums,
) =>
    _reportCredit(tx, sums);

/// Row map for CSV/Excel summary export (keys match grid column names).
Map<String, Object?> transactionSummaryExportRow(
  ITransaction transaction,
  TransactionPaymentSums? sums,
) {
  return {
    'Name': transaction.invoiceNumber?.toString() ?? transaction.id.toString(),
    'Type': transaction.receiptType ?? 'Sale',
    'Status': _transactionReportStatusLabel(transaction),
    'SaleTotal': transaction.subTotal ?? 0.0,
    'ByHand': _reportByHand(transaction, sums),
    'Credit': _reportCredit(transaction, sums),
    'Tax': TransactionSummaryTax.taxColumn(transaction),
    'BalanceDue': _reportBalanceDue(transaction),
  };
}

/// Summarized report: Tax column matches stored totals or VAT-included extraction from [subTotal].
class TransactionSummaryTax {
  TransactionSummaryTax._();

  static double taxColumn(ITransaction tx) {
    final stored = tx.taxAmount;
    if (stored != null && stored > 0) return stored.toDouble();
    if (tx.isExpense == true) return 0.0;
    final sub = tx.subTotal ?? 0.0;
    if (sub <= 0) return 0.0;
    if (!ProxyService.box.vatEnabled()) return 0.0;
    return double.parse((sub * 18 / 118).toStringAsFixed(2));
  }
}

abstract class DynamicDataSource<T> extends DataGridSource {
  List<T> data = [];
  bool showPluReport = false;
  List<DataGridRow> _dataGridRows = [];
  int _rowsPerPage = 10;

  /// Per-transaction payment breakdown for summary reports (optional).
  Map<String, TransactionPaymentSums>? paymentSumsByTransactionId;

  DynamicDataSource(
    List<T> initialData,
    int rowsPerPage, {
    this.showPluReport = false,
    this.paymentSumsByTransactionId,
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

  void updateDataSource(
    List<T> newData,
    bool newShowPluReport, {
    Map<String, TransactionPaymentSums>? newPaymentSumsByTransactionId,
  }) {
    data = newData;
    showPluReport = newShowPluReport;
    if (newPaymentSumsByTransactionId != null) {
      paymentSumsByTransactionId = newPaymentSumsByTransactionId;
    }
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
        final int numberOfColumns =
            showPluReport ? 10 : kTransactionSummaryColumnCount;
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
          final int numberOfColumns =
              showPluReport ? 10 : kTransactionSummaryColumnCount;
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
        final int numberOfColumns =
            showPluReport ? 10 : kTransactionSummaryColumnCount;
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
        final int numberOfColumns =
            showPluReport ? 10 : kTransactionSummaryColumnCount;
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
          value: TransactionItemPluMetrics.barcodeForReport(transactionItem),
        ),
        DataGridCell<double>(
          columnName: 'Price',
          value: transactionItem.price.toDouble(),
        ),
        DataGridCell<double>(
          columnName: 'TaxRate',
          value: TransactionItemPluMetrics.taxRatePercent(transactionItem),
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
          columnName: 'SupplyAmount',
          value: transactionItem.splyAmt?.toDouble() ?? 0.0,
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
    final taxValue = TransactionSummaryTax.taxColumn(trans);
    final sums = paymentSumsByTransactionId?[trans.id.toString()];

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
        DataGridCell<String>(
          columnName: 'Status',
          value: _transactionReportStatusLabel(trans),
        ),
        DataGridCell<double>(
          columnName: 'SaleTotal',
          value: trans.subTotal ?? 0.0,
        ),
        DataGridCell<double>(
          columnName: 'ByHand',
          value: _reportByHand(trans, sums),
        ),
        DataGridCell<double>(
          columnName: 'Credit',
          value: _reportCredit(trans, sums),
        ),
        DataGridCell<double>(columnName: 'Tax', value: taxValue),
        DataGridCell<double>(
          columnName: 'BalanceDue',
          value: _reportBalanceDue(trans),
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

  /// Two decimal places for numeric cells (currency / PLU metrics); ints unchanged.
  static String _displayCellValue(dynamic value) {
    if (value == null) return '';
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(2);
    if (value is num) return value.toDouble().toStringAsFixed(2);
    return value.toString();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final ix = _dataGridRows.indexOf(row);
    final isParked =
        ix >= 0 &&
        ix < data.length &&
        data[ix] is ITransaction &&
        (data[ix] as ITransaction).status == PARKED;
    final bg = isParked
        ? Colors.amber.withValues(alpha: 0.08)
        : null;

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          color: bg,
          padding: const EdgeInsets.all(8.0),
          child: Text(_displayCellValue(e.value)),
        );
      }).toList(),
    );
  }
}
