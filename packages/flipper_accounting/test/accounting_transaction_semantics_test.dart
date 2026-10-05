import 'package:flipper_accounting/accounting_transaction_semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isAccountingRecognizedTransaction — Ticket Review + Handover', () {
    test('recognizes pendingReview as a settled sale (revenue recognized at payment time)', () {
      final txn = {
        'subTotal': 100.0,
        'status': 'pendingReview',
      };
      expect(isAccountingRecognizedTransaction(txn), isTrue);
    });

    test('recognizes awaitingHandover as a settled sale', () {
      final txn = {
        'subTotal': 100.0,
        'status': 'awaitingHandover',
      };
      expect(isAccountingRecognizedTransaction(txn), isTrue);
    });

    test('still recognizes completed sales (unchanged behavior)', () {
      final txn = {
        'subTotal': 100.0,
        'status': 'completed',
      };
      expect(isAccountingRecognizedTransaction(txn), isTrue);
    });

    test('a bare parked (non-loan) ticket is still not recognized', () {
      final txn = {
        'subTotal': 100.0,
        'status': 'parked',
      };
      expect(isAccountingRecognizedTransaction(txn), isFalse);
    });
  });

  group('purchase expense mirror', () {
    final mirror = {
      'subTotal': 50000,
      'status': 'completed',
      'isExpense': true,
      'receiptType': 'Purchase',
      'paymentType': 'CASH',
    };

    test('is never posted: the purchase has its own journal entry', () {
      expect(isPurchaseExpenseMirror(mirror), isTrue);
      expect(isAccountingRecognizedTransaction(mirror), isFalse);
      expect(
        isAccountingRecognizedTransaction({
          ...mirror,
          'receiptType': null,
          'receipt_type': ' purchase ',
        }),
        isFalse,
      );
    });

    test('a normal cash-out is still posted', () {
      final cashOut = {...mirror, 'receiptType': 'Cash Out'};
      expect(isPurchaseExpenseMirror(cashOut), isFalse);
      expect(isAccountingRecognizedTransaction(cashOut), isTrue);
    });
  });
}
