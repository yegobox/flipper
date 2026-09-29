import 'dart:convert';

import 'package:crypto/crypto.dart';
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

    test('a live tenant with the same id never inherits a cached PIN', () {
      final restored = decodeStaffRoster(encodeStaffRoster([ecobe]));
      expect(barPinMatchesTenant(restored.single, '123456'), isTrue);

      // Same tenant fetched live after an admin removed the PIN.
      final live = Tenant(id: 't-ecobe', name: 'ECOBE', userId: 'u-ecobe');
      expect(staffRosterHasCachedPin(live), isFalse);
      expect(barPinMatchesTenant(live, '123456'), isFalse);
      final unset = Tenant(id: 't-ecobe', userId: 'u-ecobe', pin: 0);
      expect(barPinMatchesTenant(unset, '123456'), isFalse);
    });

    test('verifiers use PBKDF2 with the stored iteration count', () {
      final raw = encodeStaffRoster([ecobe], salt: 'fixed-salt');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      expect(json['v'], 2);
      expect(json['iterations'], staffRosterPinIterations);
      final row = (json['staff'] as List).single as Map<String, dynamic>;
      expect(row.containsKey('pin'), isFalse);
      expect(row['pin_hash'], hashStaffPin('fixed-salt', '123456'));
      expect(
        row['pin_hash'],
        isNot(sha256.convert(utf8.encode('fixed-salt:123456')).toString()),
      );

      final cheap = decodeStaffRoster(
        encodeStaffRoster([agent], iterations: 3),
      );
      expect(barPinMatchesTenant(cheap.single, '654321'), isTrue);
      expect(barPinMatchesTenant(cheap.single, '123456'), isFalse);
    });

    test('background encode round-trips', () async {
      final raw = await encodeStaffRosterInBackground([ecobe, noPin]);
      final restored = decodeStaffRoster(raw);
      expect(barPinMatchesTenant(restored.first, '123456'), isTrue);
      expect(staffRosterHasCachedPin(restored.last), isFalse);
    });

    test('fingerprint tracks roster contents, including PINs', () {
      expect(
        staffRosterFingerprint([ecobe, agent]),
        staffRosterFingerprint([ecobe, agent]),
      );
      final changedPin = Tenant(id: 't-agent', userId: 'u-agent', pin: 111111);
      expect(
        staffRosterFingerprint([ecobe, agent]),
        isNot(staffRosterFingerprint([ecobe, changedPin])),
      );
    });

    test('salt changes per write', () {
      expect(encodeStaffRoster([ecobe]), isNot(encodeStaffRoster([ecobe])));
    });

    test('missing or corrupt data yields empty roster', () {
      expect(decodeStaffRoster(null), isEmpty);
      expect(decodeStaffRoster(''), isEmpty);
      expect(decodeStaffRoster('{not json'), isEmpty);
      expect(decodeStaffRoster('{"v":99,"salt":"x","staff":[]}'), isEmpty);
      // v1 (single SHA-256) caches are ignored, not trusted.
      expect(
        decodeStaffRoster('{"v":1,"salt":"x","staff":[{"id":"a"}]}'),
        isEmpty,
      );
      expect(
        decodeStaffRoster(
          '{"v":2,"salt":"x","iterations":0,"staff":[{"id":"a"}]}',
        ),
        isEmpty,
      );
    });

    test('cache key is per business', () {
      expect(staffRosterCacheKey('biz-1'), 'staff_roster_biz-1');
    });
  });
}
