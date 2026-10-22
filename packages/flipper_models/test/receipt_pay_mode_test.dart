import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/receipt_pay_mode_test.dart

ITransaction _sale(String? paymentType) => ITransaction(
  branchId: 'b1',
  agentId: 'a1',
  status: COMPLETE,
  transactionType: 'Sale',
  paymentType: paymentType,
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.now(),
  isIncome: true,
  isExpense: false,
);

void main() {
  group('toPaymentType', () {
    test('stored upper-case tenders map to their receipt labels', () {
      expect('DEBIT&CREDIT CARD'.toPaymentType(), 'CARD');
      expect('CREDIT'.toPaymentType(), 'CREDIT');
      expect('BANK CHECK'.toPaymentType(), 'BANK');
      expect('MOBILE MONEY'.toPaymentType(), 'MOMO');
      expect('Cash'.toPaymentType(), 'CASH');
    });
  });

  group('receiptPayMode', () {
    test('prints the latest payment row when there is one', () {
      final rows = [
        for (final method in ['CASH', 'MOBILE MONEY'])
          TransactionPaymentRecord(
            transactionId: 't',
            amount: 1,
            paymentMethod: method,
            createdAt: DateTime.now(),
          ),
      ];
      expect(receiptPayMode(rows, _sale('CASH')), 'MOMO');
    });

    test('falls back to the sale tender before any row is written', () {
      expect(receiptPayMode(const [], _sale('MOBILE MONEY')), 'MOMO');
      expect(receiptPayMode(const [], _sale('DEBIT&CREDIT CARD')), 'CARD');
      expect(receiptPayMode(const [], _sale(null)), 'CASH');
    });
  });
}
