import 'package:flipper_models/helpers/pos_payment_role.dart';
import 'package:test/test.dart';

void main() {
  group('tenantTypeCanCollectPosPayment', () {
    test('Owner can collect', () {
      expect(tenantTypeCanCollectPosPayment('Owner'), isTrue);
    });

    test('Admin can collect', () {
      expect(tenantTypeCanCollectPosPayment('Admin'), isTrue);
    });

    test('Manager substring can collect', () {
      expect(tenantTypeCanCollectPosPayment('StoreManager'), isTrue);
    });

    test('Cashier cannot collect', () {
      expect(tenantTypeCanCollectPosPayment('Cashier'), isFalse);
    });

    test('Agent cannot collect', () {
      expect(tenantTypeCanCollectPosPayment('Agent'), isFalse);
    });

    test('Driver cannot collect', () {
      expect(tenantTypeCanCollectPosPayment('Driver'), isFalse);
    });

    test('null cannot collect (fail closed)', () {
      expect(tenantTypeCanCollectPosPayment(null), isFalse);
    });

    test('empty cannot collect', () {
      expect(tenantTypeCanCollectPosPayment(''), isFalse);
    });
  });

  group('userOwnsBusinessForPosPayment', () {
    test('matching ids → owner', () {
      expect(
        userOwnsBusinessForPosPayment(
          userId: 'u-1',
          businessOwnerUserId: 'u-1',
        ),
        isTrue,
      );
    });

    test('mismatch → not owner', () {
      expect(
        userOwnsBusinessForPosPayment(
          userId: 'u-1',
          businessOwnerUserId: 'u-2',
        ),
        isFalse,
      );
    });

    test('empty → not owner', () {
      expect(
        userOwnsBusinessForPosPayment(userId: '', businessOwnerUserId: 'u-1'),
        isFalse,
      );
      expect(
        userOwnsBusinessForPosPayment(userId: 'u-1', businessOwnerUserId: null),
        isFalse,
      );
    });
  });

  group('till ticket filter counts', () {
    test('staff count is own PARKED rows', () {
      final tickets = [
        {'agentId': 'staff-1', 'status': 'parked'},
        {'agentId': 'staff-2', 'status': 'parked'},
        {'agentId': 'staff-1', 'status': 'parked'},
        {'agentId': 'staff-1', 'status': 'waiting'},
      ];
      const currentUser = 'staff-1';
      final count = tickets
          .where(
            (t) =>
                (t['status'] as String).toLowerCase() == 'parked' &&
                t['agentId'] == currentUser,
          )
          .length;
      expect(count, 2);
    });

    test('till count is all PARKED', () {
      final tickets = [
        {'agentId': 'staff-1', 'status': 'parked'},
        {'agentId': 'staff-2', 'status': 'parked'},
      ];
      final count = tickets
          .where((t) => (t['status'] as String).toLowerCase() == 'parked')
          .length;
      expect(count, 2);
    });
  });
}
