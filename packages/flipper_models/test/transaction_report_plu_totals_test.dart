import 'package:flipper_models/helpers/transaction_report_plu_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

TransactionItem _line({
  required String id,
  required String transactionId,
  double price = 1000,
  double qty = 1,
  double? splyAmt,
  String name = 'Item',
  String? itemCd,
}) {
  return TransactionItem(
    id: id,
    transactionId: transactionId,
    name: name,
    itemCd: itemCd,
    price: price,
    qty: qty,
    discount: 0,
    prc: price,
    ttCatCd: 'B',
    splyAmt: splyAmt,
    taxPercentage: 18,
  );
}

void main() {
  group('sumReportScopedPluLines', () {
    test('item-exchange return lines count negative', () {
      // Sale of 1180 (cost 800) then the item came back on an exchange
      // return; the replacement sold for 2360 (cost 1500).
      final totals = sumReportScopedPluLines(
        lines: [
          _line(id: 'l1', transactionId: 'sale-1', price: 1180, splyAmt: 800),
          _line(id: 'r1', transactionId: 'ret-1', price: 1180, splyAmt: 800),
          _line(id: 's1', transactionId: 'sale-2', price: 2360, splyAmt: 1500),
        ],
        saleIds: {'sale-1', 'ret-1', 'sale-2'},
        negativeSaleIds: {'ret-1'},
      );

      expect(totals.lineSales, 2360);
      expect(totals.grossProfit, closeTo(860, 0.01));
      expect(totals.lineTax, closeTo(360, 0.01));
    });

    test('sums only lines whose sale is in report scope', () {
      final totals = sumReportScopedPluLines(
        lines: [
          _line(id: 'l1', transactionId: 'sale-1', price: 1180, splyAmt: 800),
          _line(id: 'l2', transactionId: 'not-in-report', price: 5000),
        ],
        saleIds: {'sale-1'},
      );

      expect(totals.lineSales, 1180);
      expect(totals.grossProfit, 380);
      expect(totals.lineTax, closeTo(180, 0.01));
    });

    test(
      'an out-of-scope purchase line cannot drive gross profit negative',
      () {
        // The bug: a purchase / pending-cart line carries a supply cost and no
        // sale price, so profitMade is negative. It must not reach the KPI.
        final totals = sumReportScopedPluLines(
          lines: [
            _line(
              id: 'purchase',
              transactionId: 'purchase-tx',
              price: 0,
              splyAmt: 32684.83,
            ),
          ],
          saleIds: {'sale-1'},
        );

        expect(totals.grossProfit, 0);
        expect(totals.lineSales, 0);
        expect(totals.lineTax, 0);
      },
    );

    test('empty report scope yields zeros, never a stray total', () {
      final totals = sumReportScopedPluLines(
        lines: [
          _line(id: 'l1', transactionId: 'sale-1', price: 0, splyAmt: 9000),
        ],
        saleIds: const <String>{},
      );

      expect(totals.grossProfit, 0);
      expect(totals.lineSales, 0);
      expect(totals.lineTax, 0);
    });

    test('cash-book movement lines stay excluded', () {
      final totals = sumReportScopedPluLines(
        lines: [
          _line(
            id: 'l1',
            transactionId: 'sale-1',
            price: 5000,
            itemCd: 'CASH-OUT-01',
          ),
        ],
        saleIds: {'sale-1'},
      );

      expect(totals.lineSales, 0);
    });

    test('matches uuid-string variants of the same sale id', () {
      final totals = sumReportScopedPluLines(
        lines: [
          _line(
            id: 'l1',
            transactionId: 'AABBCCDD11223344',
            price: 1180,
            splyAmt: 0,
          ),
        ],
        saleIds: {'aabbccdd-1122-3344'},
      );

      expect(totals.lineSales, 1180);
    });
  });
}
