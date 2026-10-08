import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/supabase_models.dart';

ITransaction _tx({required String? receiptType, String? transactionType}) {
  final now = DateTime(2026, 10, 8, 12);
  return ITransaction(
    id: 't1',
    agentId: 'a1',
    branchId: 'b1',
    status: 'COMPLETE',
    transactionType: transactionType,
    paymentType: 'CASH',
    cashReceived: 0,
    customerChangeDue: 0,
    updatedAt: now,
    createdAt: now,
    isIncome: receiptType != 'Cash Out',
    isExpense: receiptType == 'Cash Out',
    subTotal: 0,
    receiptType: receiptType,
  );
}

void main() {
  group('transactionReportGridTypeLabel', () {
    test('a categorised cash movement shows its category', () {
      expect(
        transactionReportGridTypeLabel(
          _tx(receiptType: 'Cash Out', transactionType: 'Rent'),
        ),
        'Cash Out · Rent',
      );
      expect(
        transactionReportGridTypeLabel(
          _tx(receiptType: 'Cash In', transactionType: 'Owner top-up'),
        ),
        'Cash In · Owner top-up',
      );
    });

    test('an uncategorised cash movement shows only its direction', () {
      for (final type in [null, '', 'Cash Out', 'cash out']) {
        expect(
          transactionReportGridTypeLabel(
            _tx(receiptType: 'Cash Out', transactionType: type),
          ),
          'Cash Out',
          reason: '$type',
        );
      }
    });

    test('a sale keeps its receipt code', () {
      expect(
        transactionReportGridTypeLabel(
          _tx(receiptType: 'NS', transactionType: 'Sale'),
        ),
        'NS',
      );
      expect(transactionReportGridTypeLabel(_tx(receiptType: null)), '-');
    });
  });
}
