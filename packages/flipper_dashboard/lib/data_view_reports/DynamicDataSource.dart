import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/transaction_report_cashier_profile.dart';
import 'package:flipper_dashboard/transaction_report_cashier_utils.dart';
import 'package:flipper_dashboard/transaction_report_mock_cashiers.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

/// Column count for transaction summary grid (non-PLU): receipt, cashier, …, actions.
const int kTransactionSummaryColumnCount = 10;

String transactionReportReceiptLabel(ITransaction t) {
  final inv = t.invoiceNumber;
  final rec = t.receiptNumber;
  if (inv != null) return '#$inv';
  if (rec != null) return '#$rec';
  return '#${t.id}';
}

String _transactionReportStatusLabel(ITransaction tx) {
  final s = (tx.status ?? '').toLowerCase();
  if (s == PARKED) return 'Parked';
  if (s == COMPLETE || s.contains('complete')) return 'Completed';
  if (s.contains('cancel')) return 'Cancelled';
  if (s == PENDING || s.contains('pending')) return 'Pending';
  return tx.status ?? '—';
}

/// Grid + export Type column: Cash In / Cash Out for cash book; else receipt code (NS, …).
String transactionReportGridTypeLabel(ITransaction t) {
  final rt = t.receiptType;
  if (rt != null &&
      (rt == TransactionType.cashIn || rt == TransactionType.cashOut)) {
    return rt;
  }
  return rt ?? '-';
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

/// Display amount: expenses (cash out, etc.) show as negative in Transaction Reports.
double _signedReportMoney(double raw, ITransaction tx) {
  if (tx.isExpense == true) return -raw.abs();
  return raw;
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
  TransactionPaymentSums? sums, {
  Map<String, TransactionReportCashierProfile>? cashierDirectory,
}) {
  return {
    'Name': transactionReportReceiptLabel(transaction),
    'Cashier': transactionReportCashierDisplayLabel(
      transaction,
      directory: cashierDirectory,
    ),
    'Type': transactionReportGridTypeLabel(transaction),
    'Status': _transactionReportStatusLabel(transaction),
    'SaleTotal': _signedReportMoney(transaction.subTotal ?? 0.0, transaction),
    'ByHand': _signedReportMoney(_reportByHand(transaction, sums), transaction),
    'Credit': _signedReportMoney(_reportCredit(transaction, sums), transaction),
    'Tax': TransactionSummaryTax.taxColumn(transaction),
    'BalanceDue': _reportBalanceDue(transaction),
    'Actions': '',
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

  /// Supabase-backed staff directory for cashier column labels / avatars.
  Map<String, TransactionReportCashierProfile>? cashierDirectory;

  DynamicDataSource(
    List<T> initialData,
    int rowsPerPage, {
    this.showPluReport = false,
    this.paymentSumsByTransactionId,
    this.cashierDirectory,
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
    Map<String, TransactionReportCashierProfile>? newCashierDirectory,
  }) {
    data = newData;
    showPluReport = newShowPluReport;
    if (newPaymentSumsByTransactionId != null) {
      paymentSumsByTransactionId = newPaymentSumsByTransactionId;
    }
    if (newCashierDirectory != null) {
      cashierDirectory = newCashierDirectory;
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
          value: transactionReportReceiptLabel(trans),
        ),
        DataGridCell<String>(
          columnName: 'Cashier',
          value: transactionReportCashierDisplayLabel(
            trans,
            directory: cashierDirectory,
          ),
        ),
        DataGridCell<String>(
          columnName: 'Type',
          value: transactionReportGridTypeLabel(trans),
        ),
        DataGridCell<String>(
          columnName: 'Status',
          value: _transactionReportStatusLabel(trans),
        ),
        DataGridCell<double>(
          columnName: 'SaleTotal',
          value: _signedReportMoney(trans.subTotal ?? 0.0, trans),
        ),
        DataGridCell<double>(
          columnName: 'ByHand',
          value: _signedReportMoney(_reportByHand(trans, sums), trans),
        ),
        DataGridCell<double>(
          columnName: 'Credit',
          value: _signedReportMoney(_reportCredit(trans, sums), trans),
        ),
        DataGridCell<double>(columnName: 'Tax', value: taxValue),
        DataGridCell<double>(
          columnName: 'BalanceDue',
          value: _reportBalanceDue(trans),
        ),
        DataGridCell<String>(
          columnName: 'Actions',
          value: trans.id.toString(),
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

  ITransaction? _transactionForZReportRow(DataGridRow row) {
    for (final c in row.getCells()) {
      if (c.columnName == 'Actions') {
        final id = c.value?.toString();
        if (id == null || id.isEmpty) return null;
        for (final item in data) {
          if (item is ITransaction && item.id.toString() == id) {
            return item;
          }
        }
        return null;
      }
    }
    return null;
  }

  (Color bg, Color fg) _statusBadgeColors(String label) {
    final l = label.toLowerCase();
    if (l.contains('completed')) {
      return (const Color(0xFFDCFCE7), const Color(0xFF15803D));
    }
    if (l.contains('cancel')) {
      return (const Color(0xFFFEE2E2), const Color(0xFFB91C1C));
    }
    if (l.contains('pending') || l.contains('parked')) {
      return (const Color(0xFFFEF3C7), const Color(0xFFB45309));
    }
    return (Colors.grey.shade100, Colors.grey.shade800);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    if (data.isEmpty) {
      return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((_) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const SizedBox.shrink(),
          );
        }).toList(),
      );
    }

    if (!showPluReport && data.isNotEmpty && data.first is ITransaction) {
      return _buildZReportStyledRow(row);
    }

    final ix = _dataGridRows.indexOf(row);
    final isParked =
        ix >= 0 &&
        ix < data.length &&
        data[ix] is ITransaction &&
        ((data[ix] as ITransaction).status ?? '').toLowerCase() == PARKED;
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

  DataGridRowAdapter _buildZReportStyledRow(DataGridRow row) {
    final tx = _transactionForZReportRow(row);
    final isParked =
        tx != null && (tx.status ?? '').toLowerCase() == PARKED;
    final rowBg = isParked ? Colors.amber.withValues(alpha: 0.06) : null;
    final sym = ProxyService.box.defaultCurrency();

    Widget actionPillButton({
      required IconData icon,
      required VoidCallback onTap,
      required String tooltip,
    }) {
      const radius = BorderRadius.all(Radius.circular(8));
      return Tooltip(
        message: tooltip,
        child: Material(
          color: const Color(0xFFF3F4F6),
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
            ),
          ),
        ),
      );
    }

    Widget cellFor(DataGridCell e) {
      final name = e.columnName;
      if (name == 'Name') {
        return Container(
          alignment: Alignment.centerLeft,
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            e.value?.toString() ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF111827),
            ),
          ),
        );
      }
      if (name == 'Cashier') {
        final label = tx != null
            ? transactionReportCashierDisplayLabel(
                tx,
                directory: cashierDirectory,
              )
            : (e.value?.toString() ?? '');
        final tint = tx != null
            ? transactionReportCashierAvatarColor(
                tx,
                directory: cashierDirectory,
              )
            : const Color(0xFF2563EB);
        final initials = tx != null
            ? transactionReportCashierInitials(
                tx,
                directory: cashierDirectory,
              )
            : initialsFromLabel(label);
        return Container(
          color: rowBg,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: tint,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (name == 'Type') {
        return Container(
          alignment: Alignment.centerLeft,
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            e.value?.toString() ?? '',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        );
      }
      if (name == 'Status') {
        final label = e.value?.toString() ?? '';
        final (badgeBg, badgeFg) = _statusBadgeColors(label);
        return Container(
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: badgeFg,
              ),
            ),
          ),
        );
      }
      if (name == 'SaleTotal') {
        final v = (e.value is num) ? (e.value as num).toDouble() : 0.0;
        final red = v < -0.0001;
        return Container(
          alignment: Alignment.centerLeft,
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '$sym ${v.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: red ? const Color(0xFFDC2626) : const Color(0xFF111827),
            ),
          ),
        );
      }
      if (name == 'ByHand' || name == 'Tax') {
        return Container(
          alignment: Alignment.centerLeft,
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            _displayCellValue(e.value),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        );
      }
      if (name == 'Credit') {
        final v = (e.value is num) ? (e.value as num).toDouble() : 0.0;
        final tint = v > 0.0001 ? const Color(0xFFD97706) : const Color(0xFF374151);
        return Container(
          alignment: Alignment.centerLeft,
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            _displayCellValue(e.value),
            style: TextStyle(
              fontSize: 13,
              fontWeight: v > 0.0001 ? FontWeight.w700 : FontWeight.w600,
              color: tint,
            ),
          ),
        );
      }
      if (name == 'BalanceDue') {
        final v = (e.value is num) ? (e.value as num).toDouble() : 0.0;
        final due = v > 0.01;
        return Container(
          alignment: Alignment.centerLeft,
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            _displayCellValue(e.value),
            style: TextStyle(
              fontWeight: due ? FontWeight.w700 : FontWeight.w600,
              fontSize: 13,
              color: due ? const Color(0xFFDC2626) : const Color(0xFF374151),
            ),
          ),
        );
      }
      if (name == 'Actions' && tx != null) {
        return Container(
          color: rowBg,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          alignment: Alignment.center,
          child: Builder(
            builder: (ctx) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  actionPillButton(
                    icon: Icons.visibility_outlined,
                    tooltip: 'View',
                    onTap: () {
                      showDialog<void>(
                        barrierDismissible: true,
                        context: ctx,
                        builder: (context) => OptionModal(
                          child: Refund(
                            refundAmount: tx.subTotal ?? 0,
                            transactionId: tx.id.toString(),
                            currency: sym,
                            transaction: tx,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  actionPillButton(
                    icon: Icons.print_outlined,
                    tooltip: 'Print',
                    onTap: () {
                      ScaffoldMessenger.maybeOf(ctx)?.showSnackBar(
                        const SnackBar(
                          content: Text('Print is not available yet.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      }
      return Container(
        alignment: Alignment.centerLeft,
        color: rowBg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          _displayCellValue(e.value),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );
    }

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) => cellFor(e)).toList(),
    );
  }
}
