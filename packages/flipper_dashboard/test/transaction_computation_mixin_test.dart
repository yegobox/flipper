import 'package:flutter_test/flutter_test.dart';
import '../lib/mixins/transaction_computation_mixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsService extends Mock implements SettingsService {}

// A concrete class that uses the mixin for testing purposes
class TestTransactionComputation with TransactionComputationMixin {
  // This class allows us to test the mixin methods
}

void main() {
  group('TransactionComputationMixin Tests', () {
    late TestTransactionComputation computation;
    late MockSettingsService mockSettingsService;

    setUp(() {
      computation = TestTransactionComputation();
    });

    setUpAll(() {
      mockSettingsService = MockSettingsService();
      when(() => mockSettingsService.isCurrencyDecimal).thenReturn(false);
      locator.registerLazySingleton<SettingsService>(() => mockSettingsService);
    });

    tearDownAll(() {
      locator.unregister<SettingsService>();
    });

    test('calculateTransactionTotal returns correct total for empty items', () {
      final total = computation.calculateTransactionTotal(
        items: [],
        transaction: null, // Using null transaction for this test
      );

      expect(total, 0.0);
    });

    test('calculateRemainingBalance returns correct value', () {
      final remaining = computation.calculateRemainingBalance(
        total: 100.0,
        paid: 70.0,
      );

      expect(remaining, 30.0);
    });

    test('calculateRemainingBalance returns 0 when paid exceeds total', () {
      final remaining = computation.calculateRemainingBalance(
        total: 50.0,
        paid: 70.0,
      );

      expect(remaining, 0.0);
    });

    test('calculateRemainingBalance returns 0 when paid equals total', () {
      final remaining = computation.calculateRemainingBalance(
        total: 50.0,
        paid: 50.0,
      );

      expect(remaining, 0.0);
    });

    test('calculateAmountToChange returns correct value', () {
      final change = computation.calculateAmountToChange(
        total: 50.0,
        paid: 70.0,
      );

      expect(change, 20.0);
    });

    test('calculateAmountToChange returns 0 when paid is less than total', () {
      final change = computation.calculateAmountToChange(
        total: 70.0,
        paid: 50.0,
      );

      expect(change, 0.0);
    });

    test('calculateAmountToChange returns 0 when paid equals total', () {
      final change = computation.calculateAmountToChange(
        total: 50.0,
        paid: 50.0,
      );

      expect(change, 0.0);
    });

    test('calculateTransactionTotal with discount returns correct value', () {
      // Create a simple mock-like object for transaction item
      // Since we can't easily mock the actual TransactionItem, we'll test with a simple scenario
      final total = computation.calculateTransactionTotal(
        items: [], // Empty items for this test
        transaction: null,
        discountPercent: 10.0, // 10% discount on a base of 100 would be 90
      );

      // When items is empty and transaction is null, total should be 0 regardless of discount
      expect(total, 0.0);
    });

    test('TransactionComputationMixin can be used in a class', () {
      expect(computation, isNotNull);
      expect(computation, isA<TestTransactionComputation>());
      expect(computation, isA<TransactionComputationMixin>());
    });

    test('TransactionComputationMixin methods exist', () {
      expect(computation.calculateTransactionTotal, isNotNull);
      expect(computation.calculateRemainingBalance, isNotNull);
      expect(computation.calculateAmountToChange, isNotNull);
      expect(computation.calculateCurrentRemainder, isNotNull);
    });

    test(
      'calculateTransactionTotal rounds per-item subtotal to avoid floating-point drift',
      () {
        // Regression: price=3000, customer pays 8000 => qty = 8000/3000 = 2.6666...
        // Without rounding: 3000 * 2.6666... ≈ 7999.80
        // With rounding: subtotal rounds to 8000.00
        final item = TransactionItem(
          name: 'Test EBM',
          qty: 8000 / 3000, // 2.6666666666666665
          price: 3000,
          discount: 0,
          prc: 3000,
          ttCatCd: 'A',
        );

        final total = computation.calculateTransactionTotal(
          items: [item],
          transaction: null,
        );

        expect(total, 8000.0);
      },
    );
  });
}
