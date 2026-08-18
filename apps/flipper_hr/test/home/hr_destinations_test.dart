import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flutter_test/flutter_test.dart';

List<String> _paths(HrSession session) =>
    [for (final d in hrDestinationsFor(session)) d.path];

void main() {
  group('hrDestinationsFor', () {
    test('an owner gets the roster, the board and the approvals queue', () {
      expect(
        _paths(const HrSession(businessIds: ['biz-1'])),
        ['/people', '/attendance', '/approvals'],
      );
    });

    test('an invited employee gets only their own time and leave', () {
      // The point of deriving this from the session: an employee cannot read the
      // roster, so a People tab would only ever fail for them. The branch board
      // is likewise absent — they may see their own hours, not the branch's.
      expect(
        _paths(const HrSession(employeeIds: ['e-1'])),
        ['/my-time', '/leave'],
      );
    });

    test('an owner on their own payroll gets both sets, management first', () {
      expect(
        _paths(
          const HrSession(businessIds: ['biz-1'], employeeIds: ['e-1']),
        ),
        ['/people', '/attendance', '/approvals', '/my-time', '/leave'],
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
