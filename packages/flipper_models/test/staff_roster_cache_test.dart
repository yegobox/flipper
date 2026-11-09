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

    test('removing someone keeps everyone else and their PINs', () {
      final raw = encodeStaffRoster([ecobe, agent, noPin], iterations: 2);
      final byUser = removeFromStaffRoster(
        raw,
        Tenant(id: 'u-agent', userId: 'u-agent'),
      );
      final left = decodeStaffRoster(byUser);
      expect(left.map((t) => t.id), ['t-ecobe', 't-nopin']);
      expect(staffRosterPinMatches(left.first, '123456'), isTrue);

      final byId = decodeStaffRoster(
        removeFromStaffRoster(raw, Tenant(id: 't-nopin')),
      );
      expect(byId.map((t) => t.id), ['t-ecobe', 't-agent']);

      // Nobody to remove, or nothing readable: nothing to write.
      expect(removeFromStaffRoster(raw, Tenant(id: 't-x')), isNull);
      expect(removeFromStaffRoster('not json', agent), isNull);
      expect(removeFromStaffRoster(null, agent), isNull);
    });

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

    group('staffRosterChanged', () {
      final a = Tenant(id: 't1', name: 'Aline', userId: 'u1', pin: 111111);
      final b = Tenant(id: 't2', name: 'Bosco', userId: 'u2', pin: 222222);
      final aCached = Tenant(id: 't1', name: 'Aline', userId: 'u1');

      test('the same people read live after the offline copy is no change', () {
        expect(staffRosterChanged([aCached], [a]), isFalse);
        expect(staffRosterChanged([a, b], [b, a]), isFalse);
      });

      test('someone joining, leaving or being replaced is a change', () {
        expect(staffRosterChanged([a], [a, b]), isTrue);
        expect(staffRosterChanged([a, b], [a]), isTrue);
        expect(staffRosterChanged([a], [b]), isTrue);
      });

      test('a new name, role, user or login right is a change', () {
        Tenant edit({
          String? name,
          String? type,
          String? userId,
          bool? login,
        }) => Tenant(
          id: 't1',
          name: name ?? 'Aline',
          userId: userId ?? 'u1',
          pin: 111111,
          type: type ?? 'Agent',
          allowBusinessLogin: login ?? false,
        );
        final base = edit();
        expect(staffRosterChanged([base], [edit(name: 'Aline M')]), isTrue);
        expect(staffRosterChanged([base], [edit(type: 'Admin')]), isTrue);
        expect(staffRosterChanged([base], [edit(userId: 'u9')]), isTrue);
        expect(staffRosterChanged([base], [edit(login: true)]), isTrue);
      });

      test('a PIN both copies know changing is a change', () {
        final newPin = Tenant(id: 't1', name: 'Aline', userId: 'u1', pin: 9);
        expect(staffRosterChanged([a], [newPin]), isTrue);
      });

      test('a removed PIN counts only between two live reads', () {
        expect(staffRosterChanged([a], [aCached]), isFalse);
        expect(staffRosterChanged([a], [aCached], bothLive: true), isTrue);
      });
    });

    group('staffRosterCachedPinsChanged', () {
      Tenant aline({int? pin}) =>
          Tenant(id: 't1', name: 'Aline', userId: 'u1', pin: pin);
      final bosco = Tenant(id: 't2', name: 'Bosco', userId: 'u2');
      // One round, so the checks stay inline.
      List<Tenant> cached(List<Tenant> live) =>
          decodeStaffRoster(encodeStaffRoster(live, iterations: 1));

      test('the PIN the copy was saved with is no change', () async {
        final shown = cached([aline(pin: 111111), bosco]);
        expect(
          await staffRosterCachedPinsChanged(shown, [
            aline(pin: 111111),
            bosco,
          ]),
          isFalse,
        );
      });

      test('a PIN rotated or removed since the copy is a change', () async {
        final shown = cached([aline(pin: 111111)]);
        expect(
          await staffRosterCachedPinsChanged(shown, [aline(pin: 222222)]),
          isTrue,
        );
        expect(await staffRosterCachedPinsChanged(shown, [aline()]), isTrue);
        expect(
          await staffRosterCachedPinsChanged(shown, [aline(pin: 0)]),
          isTrue,
        );
      });

      test(
        'a newer offline copy counts only when its verifier differs',
        () async {
          final raw = encodeStaffRoster([aline(pin: 111111)], iterations: 1);
          final shown = decodeStaffRoster(raw);
          expect(
            await staffRosterCachedPinsChanged(shown, decodeStaffRoster(raw)),
            isFalse,
          );
          expect(
            await staffRosterCachedPinsChanged(
              shown,
              cached([aline(pin: 111111)]),
            ),
            isTrue,
            reason: 'rewritten with a new salt',
          );
        },
      );

      test('no cached verifier unlocks nothing, so only verifiers count; '
          'newcomers and live rows are left to staffRosterChanged', () async {
        expect(
          await staffRosterCachedPinsChanged(cached([aline()]), [
            aline(pin: 111111),
          ]),
          isFalse,
          reason: 'a PIN set since: the server check covers it',
        );
        expect(
          await staffRosterCachedPinsChanged(
            cached([aline()]),
            cached([aline(pin: 111111)]),
          ),
          isFalse,
        );
        expect(
          await staffRosterCachedPinsChanged(cached([aline()]), [bosco]),
          isFalse,
        );
        expect(
          await staffRosterCachedPinsChanged(
            [aline(pin: 111111)],
            [aline(pin: 222222)],
          ),
          isFalse,
        );
      });

      test('full-strength verifiers are checked off the UI isolate', () async {
        final shown = decodeStaffRoster(
          encodeStaffRoster([aline(pin: 111111)]),
        );
        expect(
          await staffRosterCachedPinsChanged(shown, [aline(pin: 111111)]),
          isFalse,
        );
        expect(
          await staffRosterCachedPinsChanged(shown, [aline(pin: 222222)]),
          isTrue,
        );
      });
    });
  });
}
