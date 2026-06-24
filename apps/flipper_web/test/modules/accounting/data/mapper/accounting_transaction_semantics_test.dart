import 'package:flipper_web/modules/accounting/data/mapper/accounting_transaction_semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('accounting transaction semantics', () {
    test('recognizes completed sales and parked loans, not held tickets', () {
      expect(
        isAccountingRecognizedTransaction({
          'status': 'completed',
          'subTotal': 100,
        }),
        isTrue,
      );
      // Parked loan = credit sale → recognized.
      expect(
        isAccountingRecognizedTransaction({
          'status': 'parked',
          'subTotal': 100,
          'isLoan': true,
        }),
        isTrue,
      );
      // Parked WITHOUT loan = held ticket (cart saved for later) → not a
      // sale; recognizing it would post revenue/cash never earned.
      expect(
        isAccountingRecognizedTransaction({
          'status': 'parked',
          'subTotal': 100,
        }),
        isFalse,
      );
      expect(
        isAccountingRecognizedTransaction({
          'status': 'COMPLETE',
          'sub_total': 100,
        }),
        isTrue,
      );
      expect(
        isAccountingRecognizedTransaction({
          'status': 'pending',
          'subTotal': 100,
        }),
        isFalse,
      );
    });

    test('open receivable requires loan with remaining balance', () {
      expect(
        isOpenReceivable({
          'status': 'parked',
          'subTotal': 100000,
          'isLoan': true,
          'remainingBalance': 40000,
        }),
        isTrue,
      );
      expect(
        isOpenReceivable({
          'status': 'completed',
          'subTotal': 100000,
          'isLoan': false,
          'remainingBalance': 0,
        }),
        isFalse,
      );
    });

    test('collected amount splits loan sale correctly', () {
      expect(
        accountingCollectedAmount({
          'subTotal': 118000,
          'isLoan': true,
          'remainingBalance': 50000,
        }),
        68000,
      );
      expect(
        accountingCollectedAmount({
          'subTotal': 118000,
          'isLoan': false,
        }),
        118000,
      );
      expect(
        accountingCollectedAmount({
          'subTotal': 100000,
          'isLoan': true,
          'remainingBalance': 100000,
        }),
        0,
      );
    });
  });
}
