import 'package:flipper_hr/features/session/data/hr_identity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveHrIdentity', () {
    test('the account name wins over everything else', () {
      final identity = resolveHrIdentity(
        accountName: 'Aline Uwase',
        employeeName: 'A. Uwase',
        tenantName: 'Demo Shop',
        businessName: 'Demo Shop',
        phone: '+250783054874',
      );

      expect(identity.name, 'Aline Uwase');
      expect(identity.initials, 'AU');
      // The number moves under the name rather than being it.
      expect(identity.secondary, '+250783054874');
    });

    test('an unnamed account falls back to the roster record', () {
      final identity = resolveHrIdentity(
        accountName: '  ',
        employeeName: 'Jean Bosco',
        phone: '0783054874',
      );

      expect(identity.name, 'Jean Bosco');
      expect(identity.initials, 'JB');
    });

    test('a tenant named after the business is not treated as a person', () {
      // UserProfile.fromApiResponse sets the tenant name to the business name,
      // so trusting it would label the account menu "Demo Shop".
      final identity = resolveHrIdentity(
        tenantName: 'Demo Shop',
        businessName: 'Demo Shop',
        phone: '+250783054874',
      );

      expect(identity.name, '+250783054874');
      expect(identity.initials, isEmpty);
    });

    test('a tenant that is not the business is a name', () {
      final identity = resolveHrIdentity(
        tenantName: 'Aline Uwase',
        businessName: 'Demo Shop',
        phone: '+250783054874',
      );

      expect(identity.name, 'Aline Uwase');
    });

    test('a uuid is an identifier, never a name', () {
      final identity = resolveHrIdentity(
        accountName: '3f2a1c7e-1b4d-4f9a-9c2e-8d7b6a5f4e3d',
        phone: '0783054874',
      );

      expect(identity.name, '0783054874');
    });

    test('a synthetic <pin>@flipper.rw login key is never a name', () {
      // Migration 0003: those keys are PINs, and there is a users row whose
      // email literally is one.
      final identity = resolveHrIdentity(
        accountName: '123456@flipper.rw',
        email: '123456@flipper.rw',
        phone: '0783054874',
      );

      expect(identity.name, '0783054874');
      expect(identity.initials, isEmpty);
    });

    test('a real email is a last-resort name, cleaned up', () {
      final identity = resolveHrIdentity(
        email: 'aline.uwase@example.com',
        phone: '0783054874',
      );

      expect(identity.name, 'aline uwase');
      expect(identity.initials, 'AU');
    });

    test('a name that is only the login number is skipped', () {
      // Some rows store the phone in `name`. Promoting it would put the number
      // back in the avatar by another route.
      final identity = resolveHrIdentity(
        accountName: '+250783054874',
        phone: '0783054874',
      );

      expect(identity.name, '0783054874');
      expect(identity.initials, isEmpty);
    });

    test('nothing at all still labels the menu', () {
      expect(resolveHrIdentity().name, 'Account');
      expect(resolveHrIdentity().initials, 'AC');
    });

    test('the contact line never repeats the name', () {
      final identity = resolveHrIdentity(
        accountName: 'Aline Uwase',
        email: 'aline@example.com',
      );

      expect(identity.secondary, 'aline@example.com');
      expect(
        resolveHrIdentity(accountName: 'Aline', phone: null, email: null)
            .secondary,
        isNull,
      );
    });
  });

  group('hrInitials', () {
    test('takes the first letter of the first two words', () {
      expect(hrInitials('Aline Uwase Mukamana'), 'AU');
    });

    test('takes two letters from a single word', () {
      expect(hrInitials('Aline'), 'AL');
      expect(hrInitials('A'), 'A');
    });

    test('splits on the separators a machine-made name uses', () {
      expect(hrInitials('aline.uwase'), 'AU');
      expect(hrInitials('aline_uwase'), 'AU');
      expect(hrInitials('aline-uwase'), 'AU');
    });

    test('a phone number has no initials', () {
      // The whole point: `+2` is not who anybody is, so the avatar draws a
      // person instead.
      expect(hrInitials('+250783054874'), isEmpty);
      expect(hrInitials('0783054874'), isEmpty);
    });
  });
}
