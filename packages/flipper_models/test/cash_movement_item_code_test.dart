import 'package:flipper_models/helpers/cash_movement_item_code.dart';
import 'package:test/test.dart';

void main() {
  group('cash movement item code', () {
    test('segment normalizes Cash In / Cash Out', () {
      expect(segmentForCashMovementItemCode('Cash In'), 'CASH-IN');
      expect(segmentForCashMovementItemCode('Cash Out'), 'CASH-OUT');
    });

    test('buildCashMovementItemCode prefixes date', () {
      final code = buildCashMovementItemCode(
        'Cash In',
        DateTime(2026, 4, 30),
      );
      expect(code, 'CASH-IN-2026-04-30');
    });
  });
}
