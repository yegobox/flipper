import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_models/sync/utils/staff_roster_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

void main() {
  group('staff_roster_cache', () {
    final ecobe = Tenant(
      id: 't-ecobe',
      name: 'ECOBE',
      userId: 'u-ecobe',
      businessId: 'biz-1',
      pin: 123456,
      type: 'Manager',
      allowBusinessLogin: true,
    );
    final agent = Tenant(
      id: 't-agent',
      name: 'Agent',
      userId: 'u-agent',
      businessId: 'biz-1',
      pin: 654321,
    );
    final noPin = Tenant(id: 't-nopin', name: 'No Pin', userId: 'u-nopin');

    test('round-trips staff without writing plain PINs', () {
      final raw = encodeStaffRoster([ecobe, agent, noPin]);
      expect(raw, isNot(contains('123456')));
      expect(raw, isNot(contains('654321')));

      final restored = decodeStaffRoster(raw);
      expect(restored.map((t) => t.id), ['t-ecobe', 't-agent', 't-nopin']);
      final e = restored.first;
      expect(e.pin, isNull);
      expect(e.name, 'ECOBE');
      expect(e.userId, 'u-ecobe');
      expect(e.type, 'Manager');
      expect(e.allowBusinessLogin, isTrue);
    });

    test('restored tenants verify their own PIN only', () {
      final restored = decodeStaffRoster(
        encodeStaffRoster([ecobe, agent, noPin]),
      );
      final e = restored[0];
      final a = restored[1];
      final n = restored[2];

      expect(barPinMatchesTenant(e, '123456'), isTrue);
      expect(barPinMatchesTenant(e, '654321'), isFalse);
      expect(barPinMatchesTenant(a, '654321'), isTrue);
      expect(barPinMatchesTenant(a, '123456'), isFalse);
      expect(barPinMatchesTenant(n, '000000'), isFalse);
      expect(staffRosterHasCachedPin(n), isFalse);
    });

    test('leading zeros match the int compare', () {
      final t = Tenant(id: 't-zero', userId: 'u-zero', pin: 1234);
      final restored = decodeStaffRoster(encodeStaffRoster([t]));
      expect(barPinMatchesTenant(restored.single, '001234'), isTrue);
      expect(barPinMatchesTenant(restored.single, '1234'), isTrue);
    });

    test('salt changes per write', () {
      expect(encodeStaffRoster([ecobe]), isNot(encodeStaffRoster([ecobe])));
    });

    test('missing or corrupt data yields empty roster', () {
      expect(decodeStaffRoster(null), isEmpty);
      expect(decodeStaffRoster(''), isEmpty);
      expect(decodeStaffRoster('{not json'), isEmpty);
      expect(decodeStaffRoster('{"v":99,"salt":"x","staff":[]}'), isEmpty);
    });

    test('cache key is per business', () {
      expect(staffRosterCacheKey('biz-1'), 'staff_roster_biz-1');
    });
  });
}
