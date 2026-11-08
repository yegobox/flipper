import 'package:flipper_dashboard/export/export_report_transactions.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/export/export_booking_advance_test.dart

ITransaction _tx(String id, String? type, String receipt) => ITransaction(
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
  subTotal: 1000,
);

void main() {
  test('the Cash In sheet leaves hotel booking advances out', () {
    final rows = exportCashInTransactionsOnly([
      _tx('owner', 'Owner deposit', 'Cash In'),
      _tx('advance', 'Booking advance', 'Cash In'),
      _tx('sale', 'Sale', 'NS'),
    ]);
    expect(rows.map((t) => t.id), ['owner']);
  });

  test('the expense sheet leaves applied and refunded advances out', () {
    final rows = exportExpenseTransactionsOnly([
      _tx('rent', 'Rent', 'Cash Out'),
      _tx('applied', 'Booking advance applied', 'Cash Out'),
      _tx('refunded', 'Booking advance refunded', 'Cash Out'),
    ]);
    expect(rows.map((t) => t.id), ['rent']);
  });
}
