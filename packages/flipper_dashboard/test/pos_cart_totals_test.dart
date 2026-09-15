// The checkout summary breakdown is display-only, but its Grand Total must be
// the exact figure TransactionItemTable.grandTotal produces (same per-line
// net, same per-line rounding), or the dominant number would disagree with
// what Pay charges.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/pos_cart_totals_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/utils/pos_cart_totals.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

TransactionItem _line(
  String id, {
  required num price,
  required num qty,
  num? dcRt,
  num? dcAmt,
  num? compositePrice,
  String? taxTyCd,
  num? taxPercentage,
}) => TransactionItem(
  id: id,
  name: 'Item $id',
  qty: qty,
  price: price,
  discount: 0,
  prc: price,
  ttCatCd: 'B',
  active: true,
  dcRt: dcRt,
  dcAmt: dcAmt,
  compositePrice: compositePrice,
  taxTyCd: taxTyCd,
  taxPercentage: taxPercentage,
);

/// Mirror of `TransactionItemTable.grandTotal` so a drift in either shows up.
num _legacyGrandTotal(
  List<TransactionItem> lines, {
  required bool currencyDecimal,
}) {
  num total = 0;
  for (final item in lines) {
    final price = (item.compositePrice ?? 0) != 0
        ? item.compositePrice!
        : item.price;
    final lineNet = SaleLinePricing.subtotalNetForItem(
      unitPrice: price.toDouble(),
      qty: item.qty.toDouble(),
      dcRt: item.dcRt?.toDouble() ?? 0.0,
      dcAmt: item.dcAmt?.toDouble(),
    );
    total += currencyDecimal
        ? double.parse(lineNet.toStringAsFixed(2))
        : lineNet.roundToDouble();
  }
  return total;
}

void main() {
  double qtyOf(TransactionItem i) => i.qty.toDouble();

  group('PosCartTotals.compute', () {
    test('empty cart is all zeros', () {
      final t = PosCartTotals.compute(
        const [],
        displayQty: qtyOf,
        currencyDecimal: false,
        vatEnabled: true,
      );
      expect(t.subtotalGross, 0);
      expect(t.discount, 0);
      expect(t.vatIncluded, 0);
      expect(t.grandTotal, 0);
      expect(t.hasDiscount, isFalse);
    });

    test('grand total matches legacy getter (whole-unit currency)', () {
      final lines = [
        _line('a', price: 1200, qty: 2),
        _line('b', price: 333.33, qty: 3, dcRt: 10),
        _line('c', price: 999, qty: 1, dcAmt: 99),
        _line('d', price: 50, qty: 4, compositePrice: 45),
      ];
      final t = PosCartTotals.compute(
        lines,
        displayQty: qtyOf,
        currencyDecimal: false,
        vatEnabled: false,
      );
      expect(t.grandTotal, _legacyGrandTotal(lines, currencyDecimal: false));
      // 2400 + 999.99 + 999 + 180
      expect(t.subtotalGross, closeTo(4578.99, 0.001));
      // 10% of 999.99 = 100.0 (money-rounded) + 99
      expect(t.discount, closeTo(199.0, 0.001));
      expect(t.hasDiscount, isTrue);
      expect(t.vatIncluded, 0);
    });

    test('grand total matches legacy getter (decimal currency)', () {
      final lines = [
        _line('a', price: 10.005, qty: 3),
        _line('b', price: 7.77, qty: 1.5, dcRt: 12.5),
      ];
      final t = PosCartTotals.compute(
        lines,
        displayQty: qtyOf,
        currencyDecimal: true,
        vatEnabled: false,
      );
      expect(t.grandTotal, _legacyGrandTotal(lines, currencyDecimal: true));
    });

    test('uses the supplied display quantity, not item.qty', () {
      final lines = [_line('a', price: 100, qty: 1)];
      final t = PosCartTotals.compute(
        lines,
        displayQty: (_) => 5,
        currencyDecimal: false,
        vatEnabled: false,
      );
      expect(t.subtotalGross, 500);
      expect(t.grandTotal, 500);
    });

    test('VAT included is derived per line from taxTyCd and rate', () {
      final lines = [
        // Type B: price is VAT-inclusive at 18% → tax = 1180 * 18/118 = 180.
        _line('b', price: 1180, qty: 1, taxTyCd: 'B', taxPercentage: 18),
        // Type A (exempt-style): tax computed on top → 100 * 18% = 18.
        _line('a', price: 100, qty: 1, taxTyCd: 'A', taxPercentage: 18),
      ];
      final t = PosCartTotals.compute(
        lines,
        displayQty: qtyOf,
        currencyDecimal: false,
        vatEnabled: true,
      );
      expect(t.vatIncluded, closeTo(198, 0.001));
      // Grand total is unaffected by the informational VAT line.
      expect(t.grandTotal, _legacyGrandTotal(lines, currencyDecimal: false));
    });

    test('VAT line stays zero when the branch is not VAT-enabled', () {
      final lines = [
        _line('b', price: 1180, qty: 1, taxTyCd: 'B', taxPercentage: 18),
      ];
      final t = PosCartTotals.compute(
        lines,
        displayQty: qtyOf,
        currencyDecimal: false,
        vatEnabled: false,
      );
      expect(t.vatIncluded, 0);
    });
  });
}
