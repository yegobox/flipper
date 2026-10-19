import 'package:flipper_dashboard/logout/end_of_shift_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('splitNonCashTender', () {
    test('cash stays in the drawer; MoMo, card, bank, credit do not', () {
      final split = splitNonCashTender([
        (method: 'CASH', amount: 5000),
        (method: 'MOBILE MONEY', amount: 3000),
        (method: 'DEBIT&CREDIT CARD', amount: 20000),
        (method: 'BANK CHECK', amount: 7000),
        (method: 'CREDIT', amount: 1000),
      ]);

      expect(split.mobile, 3000);
      expect(split.other, 28000);
    });

    test('a card sale is not mistaken for credit or mobile money', () {
      final split = splitNonCashTender([
        (method: 'DEBIT&CREDIT CARD', amount: 20000),
      ]);

      expect(split.mobile, 0);
      expect(split.other, 20000);
    });

    test('a MoMo exchange return (negative) reduces mobile money', () {
      // Sale of 1,500 on MoMo, its exchange return of 1,000 handed back on
      // MoMo: 500 net went through the wallet, none through the drawer.
      final split = splitNonCashTender([
        (method: 'MOBILE MONEY', amount: 1500),
        (method: 'MOBILE MONEY', amount: -1000),
        (method: 'CASH', amount: -200),
      ]);

      expect(split.mobile, 500);
      expect(split.other, 0);
    });

    test('blank and legacy CASH/CREDIT rows count as cash', () {
      final split = splitNonCashTender([
        (method: null, amount: 100),
        (method: '', amount: 100),
        (method: 'CASH/CREDIT', amount: 100),
        (method: 'cash', amount: 100),
      ]);

      expect(split.mobile, 0);
      expect(split.other, 0);
    });
  });

  group('tenderRowsWithHeadlineFallback', () {
    test('a sale with no payment record falls back to its headline type', () {
      final rows = tenderRowsWithHeadlineFallback(
        recordRows: [(transactionId: 'a', method: 'CASH', amount: 5000)],
        sales: [
          (id: 'a', paymentType: 'CASH', amount: 5000),
          (id: 'b', paymentType: 'DEBIT&CREDIT CARD', amount: 20000),
        ],
      );

      final split = splitNonCashTender(rows);
      expect(split.mobile, 0);
      expect(split.other, 20000);
    });

    test('recorded sales use their rows, not the headline type', () {
      final rows = tenderRowsWithHeadlineFallback(
        recordRows: [
          (transactionId: 'a', method: 'MOBILE MONEY', amount: 3000),
          (transactionId: 'a', method: 'CASH', amount: 2000),
        ],
        sales: [(id: 'a', paymentType: 'BANK CHECK', amount: 5000)],
      );

      final split = splitNonCashTender(rows);
      expect(split.mobile, 3000);
      expect(split.other, 0);
    });
  });
}
