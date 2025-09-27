import 'package:test/test.dart';
import 'package:flipper_models/rw_tax.dart' show calculateTaxTotals;

void main() {
  group('TT VAT handling in calculateTaxTotals', () {
    test('ttTaxblAmt present -> ttTaxblAmt aggregated', () {
      final items = [
        {
          'price': 118.0,
          'qty': 1,
          'dcRt': 0.0,
          'taxTyCd': 'TT',
          'ttTaxblAmt': 100.0,
        }
      ];

  final totals = calculateTaxTotals(items);

      expect(totals['ttTaxblAmt'], equals(100.0));
      // For TT, taxType is mapped to 'B' in calculateTaxTotals, so B should include the gross amount
      expect(totals['B'], equals(118.0));
    });

    test('ttTaxblAmt absent -> ttTaxblAmt remains zero', () {
      final items = [
        {
          'price': 118.0,
          'qty': 1,
          'dcRt': 0.0,
          'taxTyCd': 'TT',
          // no ttTaxblAmt field
        }
      ];

  final totals = calculateTaxTotals(items);

      expect(totals['ttTaxblAmt'], equals(0.0));
      expect(totals['B'], equals(118.0));
    });
  });
}
