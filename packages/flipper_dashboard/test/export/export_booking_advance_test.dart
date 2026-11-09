import 'package:flipper_dashboard/export/export_report_transactions.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/export/export_booking_advance_test.dart

ITransaction _tx(
  String id,
  String? type,
  String receipt, {
  double subTotal = 1000,
  String? categoryId,
}) => ITransaction(
  id: id,
  agentId: 'a',
  branchId: 'b',
  status: 'completed',
  transactionType: type,
  receiptType: receipt,
  paymentType: 'Cash',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime(2026),
  isIncome: receipt == 'Cash In',
  isExpense: receipt == 'Cash Out',
  subTotal: subTotal,
  categoryId: categoryId,
);

void main() {
  test('the Cash In sheet leaves hotel booking advances out', () {
    final rows = exportCashInTransactionsOnly([
      _tx('owner', 'Owner deposit', 'Cash In'),
      _tx('advance', 'Booking advance', 'Cash In'),
      _tx('sale', 'Sale', 'NS'),
      // The owner's own category of that name is ordinary money in.
      _tx('mine', 'Booking advance', 'Cash In', categoryId: 'cat-1'),
    ]);
    expect(rows.map((t) => t.id), ['owner', 'mine']);
  });

  test('the expense sheet leaves applied and refunded advances out', () {
    final rows = exportExpenseTransactionsOnly([
      _tx('rent', 'Rent', 'Cash Out'),
      _tx('applied', 'Booking advance applied', 'Cash Out'),
      _tx('refunded', 'Booking advance refunded', 'Cash Out'),
    ]);
    expect(rows.map((t) => t.id), ['rent']);
  });

  test('the summary footer keeps advance rows out of its total', () {
    final rows = [
      _tx('sale', 'Sale', 'NS', subTotal: 100000),
      _tx('advance', 'Booking advance', 'Cash In', subTotal: 30000),
      _tx('applied', 'Booking advance applied', 'Cash Out', subTotal: 30000),
      _tx('rent', 'Rent', 'Cash Out', subTotal: 5000),
      _tx('owner', 'Owner deposit', 'Cash In', subTotal: 2000),
    ];
    // Sale + Cash In − expense, as before; the advances add nothing.
    expect(reportSummaryFooterTotal(rows), 97000);
    // A page holding only an advance totals zero, as the Total Sales card.
    expect(reportSummaryFooterTotal([rows[1]]), 0);
  });
}
