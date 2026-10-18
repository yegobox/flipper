import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/sale_exchange.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _line({
  String? id,
  required String variantId,
  required num qty,
  required num price,
  num? totAmt,
  num? taxAmt,
  num? splyAmt,
}) => TransactionItem(
  id: id,
  name: variantId,
  variantId: variantId,
  qty: qty,
  price: price,
  prc: price,
  discount: 0,
  ttCatCd: '1',
  itemTyCd: '2',
  itemCd: variantId,
  totAmt: totAmt,
  taxAmt: taxAmt,
  splyAmt: splyAmt,
);

ITransaction _txn({String? receiptType, String? exchangeId}) => ITransaction(
  branchId: 'b1',
  status: 'completed',
  transactionType: 'sale',
  paymentType: 'Cash',
  subTotal: 4000,
  cashReceived: 4000,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 1, 1),
  isIncome: true,
  isExpense: false,
  receiptType: receiptType,
  exchangeId: exchangeId,
  agentId: 'c1',
);

void main() {
  group('isExchangeReturn', () {
    test('only refund receipt types carrying an exchangeId', () {
      expect(isExchangeReturn(_txn(receiptType: 'NR', exchangeId: 'x')), true);
      expect(isExchangeReturn(_txn(receiptType: 'nr', exchangeId: 'x')), true);
      expect(isExchangeReturn(_txn(receiptType: 'TR', exchangeId: 'x')), true);
    });

    test('plain refunds and ordinary sales are untouched', () {
      // Zero-regression guard: an NR refund without exchangeId keeps its
      // pre-exchange meaning everywhere.
      expect(isExchangeReturn(_txn(receiptType: 'NR')), false);
      expect(isExchangeReturn(_txn(receiptType: 'NR', exchangeId: '')), false);
      expect(isExchangeReturn(_txn(receiptType: 'NS')), false);
      // The new-sale leg of an exchange is an ordinary sale.
      expect(isExchangeReturn(_txn(receiptType: 'NS', exchangeId: 'x')), false);
      expect(exchangeSign(_txn(receiptType: 'NR')), 1);
      expect(signedSubTotal(_txn(receiptType: 'NR')), 4000);
    });

    test('exchange return counts negative', () {
      final r = _txn(receiptType: 'NR', exchangeId: 'x');
      expect(exchangeSign(r), -1);
      expect(signedSubTotal(r), -4000);
    });
  });

  group('markExchangeReturnSigned', () {
    test('records RRA acceptance on an exchange return', () {
      final r = _txn(receiptType: 'NR', exchangeId: 'x')
        ..invoiceNumber = 7
        ..ebmSynced = false;
      expect(exchangeReturnSignedByRra(r), false);

      markExchangeReturnSigned(r, 42);

      expect(exchangeReturnSignedByRra(r), true);
      expect(r.invoiceNumber, 42);
      expect(r.receiptNumber, 42);
      expect(r.totalReceiptNumber, 42);
    });

    test('leaves every other transaction alone', () {
      final refund = _txn(receiptType: 'NR')..ebmSynced = false;
      final sale = _txn(receiptType: 'NS', exchangeId: 'x')..ebmSynced = false;
      markExchangeReturnSigned(refund, 42);
      markExchangeReturnSigned(sale, 42);
      expect(refund.ebmSynced, false);
      expect(refund.receiptNumber, isNull);
      expect(sale.ebmSynced, false);
      expect(sale.receiptNumber, isNull);
      expect(exchangeReturnSignedByRra(sale..ebmSynced = true), false);
    });
  });

  group('proRataShare', () {
    test('one unit at a time adds up to the line exactly', () {
      // 1000 over 3 units does not split evenly.
      var sum = 0.0;
      for (var prev = 0; prev < 3; prev++) {
        sum += proRataShare(
          total: 1000,
          qty: 3,
          alreadyReturned: prev,
          returning: 1,
        );
      }
      expect(sum, closeTo(1000, 1e-9));
    });

    test('never exceeds the line', () {
      expect(
        proRataShare(total: 900, qty: 3, alreadyReturned: 2, returning: 5),
        300,
      );
      expect(
        proRataShare(total: 900, qty: 3, alreadyReturned: 0, returning: 0),
        0,
      );
    });
  });

  test('buildReturnLine copies the sale\'s own amounts pro-rata', () {
    final original = _line(
      id: 'l1',
      variantId: 'v1',
      qty: 2,
      price: 4000,
      totAmt: 8000,
      taxAmt: 1220.34,
      splyAmt: 5000,
    );
    final r = buildReturnLine(
      original: original,
      alreadyReturned: 0,
      qty: 1,
      returnTransactionId: 'r1',
      id: 'rl1',
    );
    expect(r.id, 'rl1');
    expect(r.transactionId, 'r1');
    expect(r.qty, 1);
    expect(r.price, 4000);
    expect(r.totAmt, 4000);
    expect(r.taxAmt, closeTo(610.17, 1e-9));
    expect(r.splyAmt, 2500);
    expect(r.ignoreForReport, true);
    expect(r.variantId, 'v1');
    // The original is not modified.
    expect(original.qty, 2);
    expect(original.transactionId, isNull);
  });

  test('returnedQtyByOriginalLine caps across lines of one variant', () {
    final lines = [
      _line(id: 'a', variantId: 'v1', qty: 2, price: 10),
      _line(id: 'b', variantId: 'v1', qty: 1, price: 10),
      _line(id: 'c', variantId: 'v2', qty: 1, price: 10),
    ];
    final prior = [
      _line(variantId: 'v1', qty: 1, price: 10),
      _line(variantId: 'v1', qty: 1, price: 10),
      _line(variantId: 'v1', qty: 1, price: 10),
    ];
    final returned = returnedQtyByOriginalLine(
      originalLines: lines,
      priorReturnLines: prior,
    );
    expect(returned, {'a': 2, 'b': 1, 'c': 0});
  });

  test('ExchangeTotals reads like the screen', () {
    expect(const ExchangeTotals(returned: 4000, taken: 5500).difference, 1500);
    expect(
      const ExchangeTotals(returned: 4000, taken: 5500).customerPays,
      true,
    );
    expect(const ExchangeTotals(returned: 4000, taken: 3000).giveBack, true);
    expect(const ExchangeTotals(returned: 4000, taken: 4000).difference, 0);
  });
}
