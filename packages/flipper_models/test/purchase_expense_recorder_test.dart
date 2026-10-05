import 'package:flipper_models/services/purchase_expense_recorder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('purchaseAmountPaidNow', () {
    test('cash, bank, card, MoMo and other pay the whole total now', () {
      for (final code in ['01', '04', '05', '06', '07']) {
        expect(
          purchaseAmountPaidNow(pmtTyCd: code, total: 118000),
          118000,
          reason: code,
        );
      }
    });

    test('credit pays nothing now', () {
      expect(purchaseAmountPaidNow(pmtTyCd: '02', total: 118000), 0);
    });

    test('cash/credit pays its "paid now" part, never more than the total', () {
      expect(
        purchaseAmountPaidNow(pmtTyCd: '03', total: 118000, paidUpfront: 18000),
        18000,
      );
      expect(
        purchaseAmountPaidNow(pmtTyCd: '03', total: 1000, paidUpfront: 5000),
        1000,
      );
      expect(purchaseAmountPaidNow(pmtTyCd: '03', total: 1000), 0);
    });

    test('an empty purchase records nothing', () {
      expect(purchaseAmountPaidNow(pmtTyCd: '01', total: 0), 0);
    });
  });

  test('payment labels map to the ledger accounts cash-outs use', () {
    expect(purchasePaymentTypeLabel('01'), 'CASH');
    expect(purchasePaymentTypeLabel('03'), 'CASH');
    expect(purchasePaymentTypeLabel('04'), 'BANK CHECK');
    expect(purchasePaymentTypeLabel('05'), 'DEBIT&CREDIT CARD');
    expect(purchasePaymentTypeLabel('06'), 'MOBILE MONEY');
    expect(purchasePaymentTypeLabel('07'), 'OTHER');
  });

  test('only cash payments come out of the till', () {
    expect(purchasePaidInCash('01'), isTrue);
    expect(purchasePaidInCash('03'), isTrue);
    expect(purchasePaidInCash('06'), isFalse);
    expect(purchasePaidInCash('02'), isFalse);
  });

  test('one expense row per purchase, never the purchase id itself', () {
    expect(purchaseExpenseTransactionId('p1'), 'purchase_exp_p1');
    expect(purchaseExpenseTransactionId('p1'), isNot('p1'));
  });
}
