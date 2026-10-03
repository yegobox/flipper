import 'package:flipper_models/helpers/cash_movement_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cashMovementCashReceived', () {
    test('a cash book movement records only its own amount', () {
      // A reused, interrupted pending movement still holds 3000.
      expect(
        cashMovementCashReceived(
          previous: 3000,
          received: 500,
          isUtilityCashbookMovement: true,
        ),
        500,
      );
    });

    test('sales still accumulate partial collections', () {
      expect(
        cashMovementCashReceived(
          previous: 3000,
          received: 500,
          isUtilityCashbookMovement: false,
        ),
        3500,
      );
      expect(
        cashMovementCashReceived(
          previous: null,
          received: 500,
          isUtilityCashbookMovement: false,
        ),
        500,
      );
    });
  });

  group('resolveCollectPaymentType', () {
    test('the cash book method wins over the POS box value', () {
      expect(
        resolveCollectPaymentType(
          requested: 'AIRTEL MONEY',
          boxPaymentType: 'CASH',
          isUtilityCashbookMovement: true,
        ),
        'AIRTEL MONEY',
      );
    });

    test('sales keep the box value set at checkout', () {
      expect(
        resolveCollectPaymentType(
          requested: 'CASH',
          boxPaymentType: 'MTN MOMO',
          isUtilityCashbookMovement: false,
        ),
        'MTN MOMO',
      );
      expect(
        resolveCollectPaymentType(
          requested: 'CASH',
          boxPaymentType: null,
          isUtilityCashbookMovement: false,
        ),
        'CASH',
      );
    });
  });
}
