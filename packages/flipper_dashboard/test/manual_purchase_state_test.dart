import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ManualPurchaseLine', () {
    test('computes line total as qty * unitPrice', () {
      const line = ManualPurchaseLine(
        uid: 0,
        name: 'Fanta',
        qty: 24,
        unitPrice: 450,
      );
      expect(line.total, 10800);
    });

    test('bracket B carries tax-inclusive 18% VAT', () {
      const line = ManualPurchaseLine(
        uid: 0,
        name: 'Fanta',
        qty: 1,
        unitPrice: 118,
        taxTyCd: 'B',
      );
      expect(line.taxAmt, closeTo(18, 0.0001));
    });

    test('brackets A, C and D carry no VAT', () {
      for (final code in ['A', 'C', 'D']) {
        final line = ManualPurchaseLine(
          uid: 0,
          name: 'Rice',
          qty: 4,
          unitPrice: 32000,
          taxTyCd: code,
        );
        expect(line.taxAmt, 0, reason: 'bracket $code should be untaxed');
      }
    });
  });

  group('ManualPurchaseState totals', () {
    final state = ManualPurchaseState(
      supplierName: 'Kigali Wholesale Ltd',
      invoiceNo: '4521',
      lines: const [
        ManualPurchaseLine(uid: 0, name: 'Fanta', qty: 24, unitPrice: 450),
        ManualPurchaseLine(
          uid: 1,
          name: 'Rice',
          qty: 4,
          unitPrice: 32000,
          taxTyCd: 'A',
        ),
      ],
    );

    test('groups taxable amounts by bracket', () {
      expect(state.taxblAmt('B'), 10800);
      expect(state.taxblAmt('A'), 128000);
      expect(state.taxblAmt('C'), 0);
      expect(state.taxblAmt('D'), 0);
    });

    test('computes grand totals across brackets', () {
      expect(state.totTaxblAmt, 138800);
      expect(state.totAmt, 138800);
      expect(state.totTaxAmt, closeTo(10800 * 18 / 118, 0.0001));
    });

    test('tax per bracket only counts matching lines', () {
      expect(state.taxAmt('B'), closeTo(10800 * 18 / 118, 0.0001));
      expect(state.taxAmt('A'), 0);
    });
  });

  group('ManualPurchaseState validation', () {
    ManualPurchaseState base() => ManualPurchaseState(
          supplierName: 'Supplier',
          invoiceNo: '100',
          lines: const [
            ManualPurchaseLine(uid: 0, name: 'Item', qty: 1, unitPrice: 10),
          ],
        );

    test('valid with supplier, numeric invoice and one positive line', () {
      expect(base().isValid, isTrue);
    });

    test('invalid without supplier name', () {
      expect(base().copyWith(supplierName: '  ').isValid, isFalse);
    });

    test('invalid with non-numeric invoice number', () {
      expect(base().copyWith(invoiceNo: 'INV-1').isValid, isFalse);
    });

    test('invalid with no lines', () {
      expect(base().copyWith(lines: const []).isValid, isFalse);
    });

    test('invalid with a zero-quantity line', () {
      final state = base().copyWith(
        lines: const [
          ManualPurchaseLine(uid: 0, name: 'Item', qty: 0, unitPrice: 10),
        ],
      );
      expect(state.isValid, isFalse);
    });

    test('invalid with a future purchase date', () {
      final state = base().copyWith(
        purchaseDate: DateTime.now().add(const Duration(days: 2)),
      );
      expect(state.isValid, isFalse);
    });

    test('unnamed line blocks validity', () {
      final state = base().copyWith(
        lines: const [
          ManualPurchaseLine(uid: 0, name: ' ', qty: 1, unitPrice: 10),
        ],
      );
      expect(state.isValid, isFalse);
    });
  });
}
