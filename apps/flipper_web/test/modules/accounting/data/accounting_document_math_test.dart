import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('docTotals', () {
    test('sums VAT-exclusive lines at 18%', () {
      final totals = docTotals([
        const DocLine(desc: 'Oil', qty: 8, price: 52000),
        const DocLine(desc: 'Delivery', qty: 1, price: 24000),
      ]);

      expect(totals.subtotal, 440000);
      expect(totals.vat, 79200);
      expect(totals.total, 519200);
    });

    test('handles empty lines', () {
      final totals = docTotals([]);
      expect(totals.subtotal, 0);
      expect(totals.vat, 0);
      expect(totals.total, 0);
    });
  });
}
