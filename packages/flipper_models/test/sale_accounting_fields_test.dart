import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/sale_accounting_fields.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _line({
  required String name,
  required num qty,
  required num price,
  num? taxAmt,
  num? dcAmt,
  num? dcRt,
}) => TransactionItem(
  name: name,
  qty: qty,
  price: price,
  prc: price,
  discount: 0,
  ttCatCd: '1',
  itemTyCd: '2',
  itemCd: name,
  taxAmt: taxAmt,
  dcAmt: dcAmt,
  dcRt: dcRt,
);

ITransaction _txn({required double subTotal, bool isExpense = false}) =>
    ITransaction(
      branchId: 'b1',
      status: 'completed',
      transactionType: isExpense ? 'expense' : 'sale',
      paymentType: 'Cash',
      subTotal: subTotal,
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime.utc(2026, 1, 1),
      isIncome: !isExpense,
      isExpense: isExpense,
      agentId: 'c1',
    );

void main() {
  group('saleAccountingTotals', () {
    test('sums each line\'s own tax rather than assuming one rate', () {
      // A folio mixes 3% tourism tax on the night with 18% VAT on the bar
      // item. Any single inclusive rate is wrong for both.
      final lines = [
        _line(name: 'Night', qty: 2, price: 50000, taxAmt: 2912.62),
        _line(name: 'Beer', qty: 3, price: 2400, taxAmt: 1098.31),
      ];

      final totals = saleAccountingTotals(lines);

      expect(totals.tax, closeTo(4010.93, 0.01));
      expect(totals.itemCount, 2);
      expect(totals.discount, 0);
    });

    test('falls back to inclusive 18% when no line carries a tax amount', () {
      final lines = [_line(name: 'A', qty: 1, price: 1180)];

      final totals = saleAccountingTotals(lines);

      expect(totals.tax, closeTo(180, 0.01));
    });

    test('caps tax at the ticket total', () {
      final lines = [_line(name: 'A', qty: 1, price: 100, taxAmt: 500)];

      expect(saleAccountingTotals(lines).tax, 100);
    });

    test('sums line discounts', () {
      final lines = [
        _line(name: 'A', qty: 1, price: 1000, taxAmt: 100, dcAmt: 150),
        _line(name: 'B', qty: 1, price: 2000, taxAmt: 200, dcAmt: 50),
      ];

      expect(saleAccountingTotals(lines).discount, 200);
    });

    test('an empty ticket totals to zero', () {
      final totals = saleAccountingTotals(const <TransactionItem>[]);

      expect(totals.tax, 0);
      expect(totals.netSubTotal, 0);
      expect(totals.itemCount, 0);
    });
  });

  group('applySaleAccountingFields', () {
    test('stamps the fields the server-side poster splits revenue by', () {
      // Without taxAmount the poster books subTotal - 0 to revenue 4010 and
      // nothing to VAT payable 2100 — the bug this helper exists to prevent.
      final txn = _txn(subTotal: 107200);

      applySaleAccountingFields(
        transaction: txn,
        lines: [
          _line(name: 'Night', qty: 2, price: 50000, taxAmt: 2912.62),
          _line(name: 'Beer', qty: 3, price: 2400, taxAmt: 1098.31),
        ],
      );

      expect(txn.taxAmount, closeTo(4010.93, 0.01));
      expect(txn.numberOfItems, 2);
    });

    test('leaves subTotal alone unless asked', () {
      // Bar and hotel settle screens total a ticket gross of discount and
      // charge the guest that; recomputing here would change the amount taken
      // at the till, not just how it is booked.
      final txn = _txn(subTotal: 1000);
      final lines = [
        _line(
          name: 'A',
          qty: 1,
          price: 1000,
          taxAmt: 100,
          dcAmt: 200,
          dcRt: 20,
        ),
      ];

      applySaleAccountingFields(transaction: txn, lines: lines);
      expect(txn.subTotal, 1000);

      applySaleAccountingFields(
        transaction: txn,
        lines: lines,
        updateSubTotal: true,
      );
      expect(txn.subTotal, 800);
    });

    test('does not reclassify an expense as income', () {
      final txn = _txn(subTotal: 500, isExpense: true);

      applySaleAccountingFields(
        transaction: txn,
        lines: [_line(name: 'A', qty: 1, price: 500, taxAmt: 50)],
      );

      expect(txn.isExpense, isTrue);
      expect(txn.isIncome, isFalse);
    });
  });
}
