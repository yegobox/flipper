import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HrSession', () {
    test('owning a business means the roster is yours to manage', () {
      const session = HrSession(businessIds: ['biz-1']);

      expect(session.canManageRoster, isTrue);
      expect(session.hasOwnRecord, isFalse);
      expect(session.landing, HrLanding.roster);
    });

    test('an invited employee lands on their own leave', () {
      const session = HrSession(employeeIds: ['e-1']);

      expect(session.canManageRoster, isFalse);
      expect(session.hasOwnRecord, isTrue);
      expect(session.landing, HrLanding.myLeave);
      expect(session.primaryEmployeeId, 'e-1');
    });

    test('an owner who is also on the payroll manages first', () {
      // Both proofs hold. Managing is why they signed in; their own leave is a
      // tab away.
      const session = HrSession(businessIds: ['biz-1'], employeeIds: ['e-1']);

      expect(session.landing, HrLanding.roster);
      expect(session.hasOwnRecord, isTrue);
    });

    test('a session the database cannot place is unresolved, not empty', () {
      expect(HrSession.none.landing, HrLanding.unresolved);
      expect(HrSession.none.primaryEmployeeId, isNull);
    });

    test('multi-branch staff read self-service against the first record', () {
      const session = HrSession(employeeIds: ['e-1', 'e-2']);

      expect(session.primaryEmployeeId, 'e-1');
    });
  });

  group('SupabaseHrSessionRepository.parseSession', () {
    test('reads the hr_whoami_employee jsonb', () {
      final session = SupabaseHrSessionRepository.parseSession({
        'auth_uid': 'auth-1',
        'identity_keys': ['user-1', 'user-2'],
        'phones': ['+250788123456'],
        'employee_ids': ['e-1'],
        'business_ids': ['biz-1'],
      });

      expect(session.identityKeys, ['user-1', 'user-2']);
      expect(session.employeeIds, ['e-1']);
      expect(session.businessIds, ['biz-1']);
    });

    test('empty arrays are an unresolved session, not a malformed one', () {
      final session = SupabaseHrSessionRepository.parseSession({
        'identity_keys': <String>[],
        'employee_ids': <String>[],
        'business_ids': <String>[],
      });

      expect(session.landing, HrLanding.unresolved);
    });

    test('drops nulls and blanks that jsonb_agg can produce', () {
      final session = SupabaseHrSessionRepository.parseSession({
        'business_ids': ['biz-1', null, '', '  '],
      });

      expect(session.businessIds, ['biz-1']);
    });

    test('coerces non-string ids, since uuid columns may arrive either way', () {
      final session = SupabaseHrSessionRepository.parseSession({
        'employee_ids': [42],
      });

      expect(session.employeeIds, ['42']);
    });

    test('a non-object answer degrades to none rather than throwing', () {
      expect(SupabaseHrSessionRepository.parseSession(null), HrSession.none);
      expect(
        SupabaseHrSessionRepository.parseSession('nope').landing,
        HrLanding.unresolved,
      );
    });

    test('a missing key is treated as an empty list', () {
      final session = SupabaseHrSessionRepository.parseSession(
        const <String, dynamic>{},
      );

      expect(session.businessIds, isEmpty);
      expect(session.employeeIds, isEmpty);
    });
  });
}
