import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/hr_line_repository.dart';
import 'package:flipper_hr/features/people/data/person_ref.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';

void main() {
  group('SupabaseHrLineRepository.parseRows', () {
    test('reads the hr_my_line() rows', () {
      final line = SupabaseHrLineRepository.parseRows([
        {
          'id': 'e-1',
          'business_id': 'biz-1',
          'branch_id': 'branch-1',
          'first_name': 'Aline',
          'last_name': 'Uwase',
          'job_title': 'Cashier',
          'department': 'Retail',
          'status': 'on_leave',
          'manager_id': 'e-boss',
        },
      ]);

      expect(line.single.fullName, 'Aline Uwase');
      expect(line.single.managerId, 'e-boss');
      expect(line.single.status, EmploymentStatus.onLeave);
      expect(line.single.branchId, 'branch-1');
    });

    test('a blank manager_id is null, not an empty id to look up', () {
      final line = SupabaseHrLineRepository.parseRows([
        {'id': 'e-1', 'first_name': 'Aline', 'manager_id': null},
        {'id': 'e-2', 'first_name': 'Chantal', 'manager_id': '  '},
      ]);

      expect(line[0].managerId, isNull);
      expect(line[1].managerId, isNull);
    });

    test('rows with no id are dropped rather than keyed on an empty string', () {
      final line = SupabaseHrLineRepository.parseRows([
        {'first_name': 'Nobody'},
        {'id': 'e-1', 'first_name': 'Aline'},
      ]);

      expect([for (final p in line) p.id], ['e-1']);
    });

    test('anything that is not a list of rows is an empty line', () {
      // A `returns table` RPC answers with a list; an error shape must not throw
      // here, because the queue degrades to ids and stays usable.
      expect(SupabaseHrLineRepository.parseRows(null), isEmpty);
      expect(SupabaseHrLineRepository.parseRows('nope'), isEmpty);
      expect(SupabaseHrLineRepository.parseRows(const [42]), isEmpty);
    });
  });

  group('PersonRef', () {
    test('projects an employee down to what may be shown', () {
      final person = PersonRef.fromEmployee(
        employee(
          id: 'e-1',
          firstName: 'Aline',
          lastName: 'Uwase',
          managerId: 'e-boss',
          baseSalary: 250000,
        ),
      );

      expect(person.fullName, 'Aline Uwase');
      expect(person.managerId, 'e-boss');
      expect(person.initials, 'AU');
    });

    test('one name still yields initials, and no name yields none', () {
      expect(PersonRef.fromRow(const {'first_name': 'Aline'}).initials, 'AL');
      expect(PersonRef.fromRow(const {}).initials, isEmpty);
    });
  });
}
