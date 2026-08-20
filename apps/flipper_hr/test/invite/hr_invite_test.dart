import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HrRole', () {
    test('maps onto Flipper access levels', () {
      expect(HrRole.staff.accessLevel, 'read');
      expect(HrRole.manager.accessLevel, 'admin');
    });

    test('grants one feature, so an invite cannot widen POS permissions', () {
      expect(HrRole.featureName, 'HR');
    });
  });

  group('HrInvite', () {
    HrInvite invite({String pin = '246810'}) => HrInvite(
      userId: 'user-1',
      tenantId: 'tenant-1',
      pin: pin,
      phoneNumber: '+250788123456',
      role: HrRole.staff,
    );

    test('builds the synthetic login key the PIN resolves through', () {
      // Matches api_login_key.dart and the hop hr_identity_keys() takes.
      expect(invite().loginKey, '246810@flipper.rw');
    });

    test('a leading zero survives into the login key', () {
      expect(invite(pin: '012345').loginKey, '012345@flipper.rw');
    });
  });

  group('hrInviteDefaultApp', () {
    test('is the business app, not the social one', () {
      expect(hrInviteDefaultApp, 1);
    });
  });

  group('HrInviteException', () {
    test('names the failing step, which is the first debugging question', () {
      final e = HrInviteException('nope', step: HrInviteStep.issuePin);

      expect(e.step, HrInviteStep.issuePin);
      expect(e.toString(), contains('issuePin'));
      expect(e.toString(), contains('nope'));
    });
  });
}
