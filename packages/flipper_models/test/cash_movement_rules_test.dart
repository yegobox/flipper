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

  group('cashMovementClassification', () {
    Map<String, Object?> classify({
      String? categoryName,
      String? categoryId,
      String movementName = 'Cash Out',
    }) => cashMovementClassification(
      categoryName: categoryName,
      movementName: movementName,
      categoryId: categoryId,
      paymentType: 'MTN MOMO',
      receiptType: movementName,
    );

    test('a chosen category is stored as the transaction type', () {
      expect(classify(categoryName: 'Rent', categoryId: 'cat-1'), {
        'transactionType': 'Rent',
        'categoryId': 'cat-1',
        'paymentType': 'MTN MOMO',
        'receiptType': 'Cash Out',
      });
    });

    test('no category stores the movement name, never "Sale" or blank', () {
      for (final name in [null, '', '  ', 'Sale']) {
        final fields = classify(
          categoryName: name,
          categoryId: '',
          movementName: 'Cash In',
        );
        expect(fields['transactionType'], 'Cash In', reason: '$name');
        expect(fields['categoryId'], isNull, reason: '$name');
      }
    });

    test('names are trimmed', () {
      expect(classify(categoryName: ' Rent ')['transactionType'], 'Rent');
    });
  });

  group('isBookingAdvanceMovement', () {
    bool adv(String? type, String? receipt, {String? categoryId}) =>
        isBookingAdvanceMovement(
          transactionType: type,
          receiptType: receipt,
          categoryId: categoryId,
        );

    test('matches the three hotel advance movements, any case', () {
      expect(adv(kBookingAdvance, 'Cash In'), isTrue);
      expect(adv(kBookingAdvanceApplied, 'Cash Out'), isTrue);
      expect(adv(' booking advance refunded ', 'Cash Out'), isTrue);
      // Padded receipt types still match, in both directions.
      expect(adv(kBookingAdvance, ' Cash In '), isTrue);
      expect(adv(kBookingAdvanceApplied, ' Cash Out '), isTrue);
      // An empty category id is no category at all.
      expect(adv(kBookingAdvance, 'Cash In', categoryId: ' '), isTrue);
    });

    test("an owner's category of the same name is ordinary money", () {
      expect(adv(kBookingAdvance, 'Cash In', categoryId: 'cat-1'), isFalse);
      expect(
        adv(kBookingAdvanceRefunded, 'Cash Out', categoryId: 'cat-2'),
        isFalse,
      );
    });

    test('ignores the wrong direction, other categories and sales', () {
      expect(adv(kBookingAdvance, 'Cash Out'), isFalse);
      expect(adv(kBookingAdvanceApplied, 'Cash In'), isFalse);
      expect(adv('Owner deposit', 'Cash In'), isFalse);
      expect(adv('Rent', 'Cash Out'), isFalse);
      expect(adv(kBookingAdvance, 'NS'), isFalse);
      expect(adv(null, null), isFalse);
    });
  });
}
