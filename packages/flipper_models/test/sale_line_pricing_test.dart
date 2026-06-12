import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SaleLinePricing', () {
    test('applies variant dcRt to line and RRA fields', () {
      final p = SaleLinePricing.compute(
        unitPrice: 1000,
        qty: 2,
        dcRt: 10,
        taxTyCd: 'B',
        taxPercentage: 18,
      );

      expect(p.dcAmt, 200);
      expect(p.subtotalNet, 1800);
      expect(p.totAmt, 1800);
      expect(p.dcRt, 10);
    });

    test('subtotalNetForItem prefers persisted dcAmt', () {
      expect(
        SaleLinePricing.subtotalNetForItem(
          unitPrice: 100,
          qty: 1,
          dcRt: 0,
          dcAmt: 15,
        ),
        85,
      );
    });

    test('zero dcRt leaves line at gross', () {
      final p = SaleLinePricing.compute(
        unitPrice: 500,
        qty: 1,
        dcRt: 0,
      );
      expect(p.dcAmt, 0);
      expect(p.subtotalNet, 500);
    });
  });
}
