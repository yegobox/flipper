import 'package:flutter_test/flutter_test.dart';

import '../lib/bottomSheet.dart';

void main() {
  group('BottomSheets Tests', () {
    test('ChargeButtonState enum has correct values', () {
      expect(ChargeButtonState.values.length, equals(4));
      expect(ChargeButtonState.initial, equals(ChargeButtonState.values[0]));
      expect(ChargeButtonState.waitingForPayment, equals(ChargeButtonState.values[1]));
      expect(ChargeButtonState.printingReceipt, equals(ChargeButtonState.values[2]));
      expect(ChargeButtonState.failed, equals(ChargeButtonState.values[3]));
    });

    test('ChargeButtonState enum values are correct', () {
      expect(ChargeButtonState.initial.toString(), 'ChargeButtonState.initial');
      expect(ChargeButtonState.waitingForPayment.toString(), 'ChargeButtonState.waitingForPayment');
      expect(ChargeButtonState.printingReceipt.toString(), 'ChargeButtonState.printingReceipt');
      expect(ChargeButtonState.failed.toString(), 'ChargeButtonState.failed');
    });

    test('BottomSheets class exists', () {
      expect(BottomSheets, isNotNull);
    });
  });
}