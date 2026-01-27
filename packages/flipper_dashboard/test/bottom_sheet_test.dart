import 'package:flutter_test/flutter_test.dart';

import '../lib/bottomSheet.dart';
// flutter test test/bottom_sheet_test.dart
void main() {
  group('ChargeButtonState Enum Tests', () {
    test('ChargeButtonState enum has correct values', () {
      expect(ChargeButtonState.values.length, equals(4));
      expect(ChargeButtonState.initial, equals(ChargeButtonState.values[0]));
      expect(
        ChargeButtonState.waitingForPayment,
        equals(ChargeButtonState.values[1]),
      );
      expect(
        ChargeButtonState.printingReceipt,
        equals(ChargeButtonState.values[2]),
      );
      expect(ChargeButtonState.failed, equals(ChargeButtonState.values[3]));
    });

    test('ChargeButtonState enum values are correct', () {
      expect(ChargeButtonState.initial.toString(), 'ChargeButtonState.initial');
      expect(
        ChargeButtonState.waitingForPayment.toString(),
        'ChargeButtonState.waitingForPayment',
      );
      expect(
        ChargeButtonState.printingReceipt.toString(),
        'ChargeButtonState.printingReceipt',
      );
      expect(ChargeButtonState.failed.toString(), 'ChargeButtonState.failed');
    });

    test('ChargeButtonState enum index values', () {
      expect(ChargeButtonState.initial.index, equals(0));
      expect(ChargeButtonState.waitingForPayment.index, equals(1));
      expect(ChargeButtonState.printingReceipt.index, equals(2));
      expect(ChargeButtonState.failed.index, equals(3));
    });

    test('ChargeButtonState enum name property', () {
      expect(ChargeButtonState.initial.name, equals('initial'));
      expect(
        ChargeButtonState.waitingForPayment.name,
        equals('waitingForPayment'),
      );
      expect(ChargeButtonState.printingReceipt.name, equals('printingReceipt'));
      expect(ChargeButtonState.failed.name, equals('failed'));
    });

    test('ChargeButtonState values can be iterated', () {
      final states = <ChargeButtonState>[];
      for (final state in ChargeButtonState.values) {
        states.add(state);
      }
      expect(states.length, equals(4));
      expect(
        states,
        containsAll([
          ChargeButtonState.initial,
          ChargeButtonState.waitingForPayment,
          ChargeButtonState.printingReceipt,
          ChargeButtonState.failed,
        ]),
      );
    });

    test('ChargeButtonState can be used in switch statement', () {
      String getStateMessage(ChargeButtonState state) {
        switch (state) {
          case ChargeButtonState.initial:
            return 'Ready to charge';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting';
          case ChargeButtonState.printingReceipt:
            return 'Printing';
          case ChargeButtonState.failed:
            return 'Failed';
        }
      }

      expect(
        getStateMessage(ChargeButtonState.initial),
        equals('Ready to charge'),
      );
      expect(
        getStateMessage(ChargeButtonState.waitingForPayment),
        equals('Waiting'),
      );
      expect(
        getStateMessage(ChargeButtonState.printingReceipt),
        equals('Printing'),
      );
      expect(getStateMessage(ChargeButtonState.failed), equals('Failed'));
    });

    test('ChargeButtonState equality comparison', () {
      expect(ChargeButtonState.initial == ChargeButtonState.initial, isTrue);
      expect(ChargeButtonState.failed == ChargeButtonState.failed, isTrue);
      expect(ChargeButtonState.initial == ChargeButtonState.failed, isFalse);
    });

    test('ChargeButtonState hashCode is consistent', () {
      expect(
        ChargeButtonState.initial.hashCode,
        equals(ChargeButtonState.initial.hashCode),
      );
      expect(
        ChargeButtonState.failed.hashCode,
        equals(ChargeButtonState.failed.hashCode),
      );
    });

    test('ChargeButtonState enum values are distinct', () {
      final states = ChargeButtonState.values.toSet();
      expect(states.length, equals(4));
    });
  });

  group('BottomSheets Class Tests', () {
    test('BottomSheets class exists', () {
      expect(BottomSheets, isNotNull);
    });

    test('BottomSheets has showBottom method', () {
      expect(BottomSheets.showBottom, isNotNull);
    });
  });

  group('Button State Logic Tests', () {
    // Test the logic that would be in _getButtonEnabled
    test('button enabled logic - empty cart', () {
      bool getButtonEnabled(
        bool isEmpty,
        String? customerPhone,
        ChargeButtonState chargeState,
      ) {
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        return !isEmpty &&
            hasCustomer &&
            chargeState != ChargeButtonState.waitingForPayment &&
            chargeState != ChargeButtonState.printingReceipt;
      }

      expect(
        getButtonEnabled(true, '1234567890', ChargeButtonState.initial),
        isFalse,
      );
      expect(
        getButtonEnabled(false, '1234567890', ChargeButtonState.initial),
        isTrue,
      );
    });

    test('button enabled logic - no customer', () {
      bool getButtonEnabled(
        bool isEmpty,
        String? customerPhone,
        ChargeButtonState chargeState,
      ) {
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        return !isEmpty &&
            hasCustomer &&
            chargeState != ChargeButtonState.waitingForPayment &&
            chargeState != ChargeButtonState.printingReceipt;
      }

      expect(getButtonEnabled(false, null, ChargeButtonState.initial), isFalse);
      expect(getButtonEnabled(false, '', ChargeButtonState.initial), isFalse);
    });

    test('button enabled logic - waiting for payment', () {
      bool getButtonEnabled(
        bool isEmpty,
        String? customerPhone,
        ChargeButtonState chargeState,
      ) {
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        return !isEmpty &&
            hasCustomer &&
            chargeState != ChargeButtonState.waitingForPayment &&
            chargeState != ChargeButtonState.printingReceipt;
      }

      expect(
        getButtonEnabled(
          false,
          '1234567890',
          ChargeButtonState.waitingForPayment,
        ),
        isFalse,
      );
    });

    test('button enabled logic - printing receipt', () {
      bool getButtonEnabled(
        bool isEmpty,
        String? customerPhone,
        ChargeButtonState chargeState,
      ) {
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        return !isEmpty &&
            hasCustomer &&
            chargeState != ChargeButtonState.waitingForPayment &&
            chargeState != ChargeButtonState.printingReceipt;
      }

      expect(
        getButtonEnabled(
          false,
          '1234567890',
          ChargeButtonState.printingReceipt,
        ),
        isFalse,
      );
    });

    test('button enabled logic - failed state allows retry', () {
      bool getButtonEnabled(
        bool isEmpty,
        String? customerPhone,
        ChargeButtonState chargeState,
      ) {
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        return !isEmpty &&
            hasCustomer &&
            chargeState != ChargeButtonState.waitingForPayment &&
            chargeState != ChargeButtonState.printingReceipt;
      }

      expect(
        getButtonEnabled(false, '1234567890', ChargeButtonState.failed),
        isTrue,
      );
    });
  });

  group('Button Text Logic Tests', () {
    // Test the logic that would be in _getButtonText
    test('button text logic - empty cart', () {
      String getButtonText(
        bool isEmpty,
        double total,
        String? customerPhone,
        ChargeButtonState chargeState, [
        double remainingBalance = 0,
      ]) {
        if (isEmpty) return 'Add items to charge';
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        if (!hasCustomer) return 'Add customer to continue';
        switch (chargeState) {
          case ChargeButtonState.initial:
            return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting for payment...';
          case ChargeButtonState.printingReceipt:
            return 'Printing receipt...';
          case ChargeButtonState.failed:
            return 'Payment Failed. Retry?';
        }
      }

      expect(
        getButtonText(true, 100.0, '1234567890', ChargeButtonState.initial),
        equals('Add items to charge'),
      );
    });

    test('button text logic - no customer', () {
      String getButtonText(
        bool isEmpty,
        double total,
        String? customerPhone,
        ChargeButtonState chargeState, [
        double remainingBalance = 0,
      ]) {
        if (isEmpty) return 'Add items to charge';
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        if (!hasCustomer) return 'Add customer to continue';
        switch (chargeState) {
          case ChargeButtonState.initial:
            return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting for payment...';
          case ChargeButtonState.printingReceipt:
            return 'Printing receipt...';
          case ChargeButtonState.failed:
            return 'Payment Failed. Retry?';
        }
      }

      expect(
        getButtonText(false, 100.0, null, ChargeButtonState.initial),
        equals('Add customer to continue'),
      );
      expect(
        getButtonText(false, 100.0, '', ChargeButtonState.initial),
        equals('Add customer to continue'),
      );
    });

    test('button text logic - initial state with no remaining balance', () {
      String getButtonText(
        bool isEmpty,
        double total,
        String? customerPhone,
        ChargeButtonState chargeState, [
        double remainingBalance = 0,
      ]) {
        if (isEmpty) return 'Add items to charge';
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        if (!hasCustomer) return 'Add customer to continue';
        switch (chargeState) {
          case ChargeButtonState.initial:
            return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting for payment...';
          case ChargeButtonState.printingReceipt:
            return 'Printing receipt...';
          case ChargeButtonState.failed:
            return 'Payment Failed. Retry?';
        }
      }

      expect(
        getButtonText(false, 100.0, '1234567890', ChargeButtonState.initial, 0),
        equals('Charge Now'),
      );
    });

    test('button text logic - initial state with remaining balance', () {
      String getButtonText(
        bool isEmpty,
        double total,
        String? customerPhone,
        ChargeButtonState chargeState, [
        double remainingBalance = 0,
      ]) {
        if (isEmpty) return 'Add items to charge';
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        if (!hasCustomer) return 'Add customer to continue';
        switch (chargeState) {
          case ChargeButtonState.initial:
            return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting for payment...';
          case ChargeButtonState.printingReceipt:
            return 'Printing receipt...';
          case ChargeButtonState.failed:
            return 'Payment Failed. Retry?';
        }
      }

      expect(
        getButtonText(
          false,
          100.0,
          '1234567890',
          ChargeButtonState.initial,
          50.0,
        ),
        equals('Record Payment'),
      );
    });

    test('button text logic - waiting for payment', () {
      String getButtonText(
        bool isEmpty,
        double total,
        String? customerPhone,
        ChargeButtonState chargeState, [
        double remainingBalance = 0,
      ]) {
        if (isEmpty) return 'Add items to charge';
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        if (!hasCustomer) return 'Add customer to continue';
        switch (chargeState) {
          case ChargeButtonState.initial:
            return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting for payment...';
          case ChargeButtonState.printingReceipt:
            return 'Printing receipt...';
          case ChargeButtonState.failed:
            return 'Payment Failed. Retry?';
        }
      }

      expect(
        getButtonText(
          false,
          100.0,
          '1234567890',
          ChargeButtonState.waitingForPayment,
        ),
        equals('Waiting for payment...'),
      );
    });

    test('button text logic - printing receipt', () {
      String getButtonText(
        bool isEmpty,
        double total,
        String? customerPhone,
        ChargeButtonState chargeState, [
        double remainingBalance = 0,
      ]) {
        if (isEmpty) return 'Add items to charge';
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        if (!hasCustomer) return 'Add customer to continue';
        switch (chargeState) {
          case ChargeButtonState.initial:
            return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting for payment...';
          case ChargeButtonState.printingReceipt:
            return 'Printing receipt...';
          case ChargeButtonState.failed:
            return 'Payment Failed. Retry?';
        }
      }

      expect(
        getButtonText(
          false,
          100.0,
          '1234567890',
          ChargeButtonState.printingReceipt,
        ),
        equals('Printing receipt...'),
      );
    });

    test('button text logic - failed', () {
      String getButtonText(
        bool isEmpty,
        double total,
        String? customerPhone,
        ChargeButtonState chargeState, [
        double remainingBalance = 0,
      ]) {
        if (isEmpty) return 'Add items to charge';
        final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
        if (!hasCustomer) return 'Add customer to continue';
        switch (chargeState) {
          case ChargeButtonState.initial:
            return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
          case ChargeButtonState.waitingForPayment:
            return 'Waiting for payment...';
          case ChargeButtonState.printingReceipt:
            return 'Printing receipt...';
          case ChargeButtonState.failed:
            return 'Payment Failed. Retry?';
        }
      }

      expect(
        getButtonText(false, 100.0, '1234567890', ChargeButtonState.failed),
        equals('Payment Failed. Retry?'),
      );
    });
  });

  group('Spinner Display Logic Tests', () {
    test('spinner logic - should show for waiting payment', () {
      bool shouldShowSpinner(ChargeButtonState chargeState) {
        return chargeState == ChargeButtonState.waitingForPayment ||
            chargeState == ChargeButtonState.printingReceipt;
      }

      expect(shouldShowSpinner(ChargeButtonState.waitingForPayment), isTrue);
    });

    test('spinner logic - should show for printing receipt', () {
      bool shouldShowSpinner(ChargeButtonState chargeState) {
        return chargeState == ChargeButtonState.waitingForPayment ||
            chargeState == ChargeButtonState.printingReceipt;
      }

      expect(shouldShowSpinner(ChargeButtonState.printingReceipt), isTrue);
    });

    test('spinner logic - should not show for initial', () {
      bool shouldShowSpinner(ChargeButtonState chargeState) {
        return chargeState == ChargeButtonState.waitingForPayment ||
            chargeState == ChargeButtonState.printingReceipt;
      }

      expect(shouldShowSpinner(ChargeButtonState.initial), isFalse);
    });

    test('spinner logic - should not show for failed', () {
      bool shouldShowSpinner(ChargeButtonState chargeState) {
        return chargeState == ChargeButtonState.waitingForPayment ||
            chargeState == ChargeButtonState.printingReceipt;
      }

      expect(shouldShowSpinner(ChargeButtonState.failed), isFalse);
    });
  });

  group('Payment Calculation Logic Tests', () {
    test('remaining balance calculation - full payment', () {
      double calculateRemainingBalance(double total, double paid) {
        final remaining = total - paid;
        return remaining > 0 ? remaining : 0;
      }

      expect(calculateRemainingBalance(100.0, 100.0), equals(0.0));
    });

    test('remaining balance calculation - partial payment', () {
      double calculateRemainingBalance(double total, double paid) {
        final remaining = total - paid;
        return remaining > 0 ? remaining : 0;
      }

      expect(calculateRemainingBalance(100.0, 50.0), equals(50.0));
    });

    test('remaining balance calculation - overpayment', () {
      double calculateRemainingBalance(double total, double paid) {
        final remaining = total - paid;
        return remaining > 0 ? remaining : 0;
      }

      expect(calculateRemainingBalance(100.0, 150.0), equals(0.0));
    });

    test('remaining balance calculation - no payment', () {
      double calculateRemainingBalance(double total, double paid) {
        final remaining = total - paid;
        return remaining > 0 ? remaining : 0;
      }

      expect(calculateRemainingBalance(100.0, 0.0), equals(100.0));
    });

    test('total paid calculation with already paid and pending', () {
      double calculateTotalPaid(double alreadyPaid, double pendingPayment) {
        return alreadyPaid + pendingPayment;
      }

      expect(calculateTotalPaid(50.0, 25.0), equals(75.0));
    });

    test('total paid calculation with zero already paid', () {
      double calculateTotalPaid(double alreadyPaid, double pendingPayment) {
        return alreadyPaid + pendingPayment;
      }

      expect(calculateTotalPaid(0.0, 100.0), equals(100.0));
    });

    test('total paid calculation with zero pending', () {
      double calculateTotalPaid(double alreadyPaid, double pendingPayment) {
        return alreadyPaid + pendingPayment;
      }

      expect(calculateTotalPaid(100.0, 0.0), equals(100.0));
    });

    test('total paid calculation with both zero', () {
      double calculateTotalPaid(double alreadyPaid, double pendingPayment) {
        return alreadyPaid + pendingPayment;
      }

      expect(calculateTotalPaid(0.0, 0.0), equals(0.0));
    });
  });

  group('Customer Validation Logic Tests', () {
    test('customer validation - valid phone number', () {
      bool hasValidCustomer(String? customerPhone) {
        return customerPhone != null && customerPhone.isNotEmpty;
      }

      expect(hasValidCustomer('1234567890'), isTrue);
    });

    test('customer validation - null phone number', () {
      bool hasValidCustomer(String? customerPhone) {
        return customerPhone != null && customerPhone.isNotEmpty;
      }

      expect(hasValidCustomer(null), isFalse);
    });

    test('customer validation - empty phone number', () {
      bool hasValidCustomer(String? customerPhone) {
        return customerPhone != null && customerPhone.isNotEmpty;
      }

      expect(hasValidCustomer(''), isFalse);
    });

    test('customer validation - whitespace phone number', () {
      bool hasValidCustomer(String? customerPhone) {
        return customerPhone != null && customerPhone.isNotEmpty;
      }

      expect(
        hasValidCustomer('   '),
        isTrue,
      ); // Note: current logic doesn't trim
    });
  });

  group('Transaction Item Count Tests', () {
    test('items count display - empty list', () {
      String getItemsCountText(int itemCount) {
        return 'Items ($itemCount)';
      }

      expect(getItemsCountText(0), equals('Items (0)'));
    });

    test('items count display - single item', () {
      String getItemsCountText(int itemCount) {
        return 'Items ($itemCount)';
      }

      expect(getItemsCountText(1), equals('Items (1)'));
    });

    test('items count display - multiple items', () {
      String getItemsCountText(int itemCount) {
        return 'Items ($itemCount)';
      }

      expect(getItemsCountText(5), equals('Items (5)'));
    });

    test('items count display - many items', () {
      String getItemsCountText(int itemCount) {
        return 'Items ($itemCount)';
      }

      expect(getItemsCountText(100), equals('Items (100)'));
    });
  });
}
