import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flutter_test/flutter_test.dart';

List<String> _paths(HrSession session) =>
    [for (final d in hrDestinationsFor(session)) d.path];

void main() {
  group('hrDestinationsFor', () {
    test('an owner gets the roster and the approvals queue', () {
      expect(
        _paths(const HrSession(businessIds: ['biz-1'])),
        ['/people', '/approvals'],
      );
    });

    test('an invited employee gets their leave and nothing else', () {
      // The point of deriving this from the session: an employee cannot read the
      // roster, so a People tab would only ever fail for them.
      expect(_paths(const HrSession(employeeIds: ['e-1'])), ['/leave']);
    });

    test('an owner on their own payroll gets all three, roster first', () {
      expect(
        _paths(
          const HrSession(businessIds: ['biz-1'], employeeIds: ['e-1']),
        ),
        ['/people', '/approvals', '/leave'],
      );
    });

    test('an unresolved session still reaches People, which explains why', () {
      // The access diagnostic lives on the People page; a blank shell would hide
      // the one screen that can say what went wrong.
      expect(_paths(HrSession.none), ['/people']);
    });

    test('every destination has a label and an icon', () {
      final all = hrDestinationsFor(
        const HrSession(businessIds: ['biz-1'], employeeIds: ['e-1']),
      );

      for (final d in all) {
        expect(d.label, isNotEmpty);
        expect(d.path, startsWith('/'));
      }
    });
  });
}
