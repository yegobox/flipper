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
}
