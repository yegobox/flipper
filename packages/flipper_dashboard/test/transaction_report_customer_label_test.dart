import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/supabase_models.dart';

ITransaction _tx({
  String? customerName,
  String? customerPhone,
  String? currentSaleCustomerPhoneNumber,
}) {
  final now = DateTime(2026, 4, 25, 12);
  return ITransaction(
    id: 't1',
    agentId: 'a1',
    branchId: 'b1',
    status: 'COMPLETE',
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: 0,
    customerChangeDue: 0,
    updatedAt: now,
    createdAt: now,
    isIncome: true,
    isExpense: false,
    subTotal: 0,
    customerName: customerName,
    customerPhone: customerPhone,
    currentSaleCustomerPhoneNumber: currentSaleCustomerPhoneNumber,
  );
}

void main() {
  group('transactionReportCustomerLabel', () {
    test('prefers the stored customer name', () {
      expect(
        transactionReportCustomerLabel(
          _tx(customerName: 'Jane Doe', customerPhone: '0788000000'),
        ),
        'Jane Doe',
      );
    });

    test('falls back to the customer phone when unnamed', () {
      expect(
        transactionReportCustomerLabel(_tx(customerPhone: '0788000000')),
        '0788000000',
      );
    });

    test('falls back past a blank customerPhone to the sale-time phone', () {
      // `??` would stop at the empty string and lose the number entirely.
      expect(
        transactionReportCustomerLabel(
          _tx(customerPhone: '  ', currentSaleCustomerPhoneNumber: '0788111111'),
        ),
        '0788111111',
      );
      expect(
        transactionReportCustomerLabel(
          _tx(customerPhone: '', currentSaleCustomerPhoneNumber: '0788111111'),
        ),
        '0788111111',
      );
    });

    test('falls back past a blank name to a phone', () {
      expect(
        transactionReportCustomerLabel(
          _tx(customerName: '   ', customerPhone: '0788222222'),
        ),
        '0788222222',
      );
    });

    test('shows a dash for a walk-in with nothing captured', () {
      expect(transactionReportCustomerLabel(_tx()), '—');
      expect(
        transactionReportCustomerLabel(
          _tx(customerName: '', customerPhone: '', currentSaleCustomerPhoneNumber: ' '),
        ),
        '—',
      );
    });
  });
}
