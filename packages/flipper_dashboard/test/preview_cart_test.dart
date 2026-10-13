import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter_test/flutter_test.dart';

// Import the file to ensure it compiles correctly
import '../lib/mixins/previewCart.dart';

void main() {
  group('PreviewCartMixin Tests', () {
    test('PreviewCartMixin can be imported without errors', () {
      // This test simply verifies that the file can be imported without compilation errors
      expect(PreviewCartMixin, isNotNull);
    });

    test('PreviewCartMixin class exists', () {
      // Verify that the mixin class exists
      expect(() => PreviewCartMixin, returnsNormally);
    });

    test('PreviewCartMixin can be referenced', () {
      // Verify that we can reference the mixin
      var mixinRef = PreviewCartMixin;
      expect(mixinRef, isNotNull);
    });
  });

  group('primaryPaymentMethodForSaleCompletion', () {
    test('records the method being charged, not a stale earlier pick', () {
      // The rows reset to CASH per cart while the box keeps e.g. MOBILE MONEY;
      // the sale must be stamped from the rows.
      expect(
        primaryPaymentMethodForSaleCompletion([
          Payment(amount: 5000, method: 'BANK CHECK'),
        ]),
        'BANK CHECK',
      );
      expect(
        primaryPaymentMethodForSaleCompletion([
          Payment(amount: 5000, method: 'CASH'),
        ]),
        'CASH',
      );
    });

    test('a padded method is trimmed so it maps to its RRA code', () {
      expect(
        primaryPaymentMethodForSaleCompletion([
          Payment(amount: 5000, method: ' CASH '),
        ]),
        'CASH',
      );
    });

    test('a split takes the first line that carries money', () {
      expect(
        primaryPaymentMethodForSaleCompletion([
          Payment(amount: 0, method: 'CASH'),
          Payment(amount: 3000, method: 'DEBIT&CREDIT CARD'),
          Payment(amount: 2000, method: 'MOBILE MONEY'),
        ]),
        'DEBIT&CREDIT CARD',
      );
    });

    test('reads the typed amount when the line amount is unset', () {
      final typed = Payment(amount: 0, method: 'BANK CHECK')
        ..controller.text = '4000';
      expect(
        primaryPaymentMethodForSaleCompletion([
          Payment(amount: 0, method: 'CASH'),
          typed,
        ]),
        'BANK CHECK',
      );
    });

    test('falls back to the first line, and null with no lines', () {
      expect(
        primaryPaymentMethodForSaleCompletion([
          Payment(amount: 0, method: 'MOBILE MONEY'),
        ]),
        'MOBILE MONEY',
      );
      expect(primaryPaymentMethodForSaleCompletion([]), isNull);
    });
  });
}
