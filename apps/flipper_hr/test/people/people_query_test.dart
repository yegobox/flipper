import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_query.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';

void main() {
  final aline = employee(
    id: 'e-1',
    firstName: 'Aline',
    lastName: 'Uwase',
    jobTitle: 'Cashier',
    department: 'Retail',
    phone: '0788123456',
    hireDate: DateTime(2024, 2, 1),
    baseSalary: 200000,
  );
  final bosco = employee(
    id: 'e-2',
    firstName: 'Bosco',
    lastName: 'Habimana',
    jobTitle: 'Store keeper',
    department: 'Warehouse',
    phone: '+250789000111',
    hireDate: DateTime(2026, 1, 10),
    baseSalary: 450000,
    status: EmploymentStatus.onLeave,
  );
  final claude = employee(
    id: 'e-3',
    firstName: 'Claude',
    lastName: 'Nkusi',
    jobTitle: 'Driver',
    department: 'retail',
    phone: '0722555444',
    hireDate: DateTime(2020, 6, 1),
    baseSalary: 150000,
    status: EmploymentStatus.terminated,
    endDate: DateTime(2026, 3, 1),
  );
  final roster = [aline, bosco, claude];

  List<String> idsOf(List<Employee> people) => [for (final e in people) e.id];

  group('status filtering', () {
    test('no status filter hides terminated people', () {
      final result = applyPeopleQuery(roster, const PeopleQuery());
      expect(idsOf(result), ['e-1', 'e-2']);
    });

    test('selecting terminated brings them back', () {
      final result = applyPeopleQuery(
        roster,
        const PeopleQuery(status: EmploymentStatus.terminated),
      );
      expect(idsOf(result), ['e-3']);
    });

    test('selecting a status excludes every other status', () {
      final result = applyPeopleQuery(
        roster,
        const PeopleQuery(status: EmploymentStatus.onLeave),
      );
      expect(idsOf(result), ['e-2']);
    });
  });

  group('search', () {
    test('matches name, job title and department', () {
      expect(idsOf(applyPeopleQuery(roster, const PeopleQuery(search: 'uwase'))),
          ['e-1']);
      expect(
        idsOf(applyPeopleQuery(roster, const PeopleQuery(search: 'store'))),
        ['e-2'],
      );
      expect(
        idsOf(applyPeopleQuery(roster, const PeopleQuery(search: 'warehouse'))),
        ['e-2'],
      );
    });

    test('is case insensitive and ignores surrounding whitespace', () {
      expect(
        idsOf(applyPeopleQuery(roster, const PeopleQuery(search: '  ALINE '))),
        ['e-1'],
      );
    });

    test('multiple terms must all match', () {
      expect(
        idsOf(applyPeopleQuery(roster, const PeopleQuery(search: 'aline retail'))),
        ['e-1'],
      );
      expect(
        applyPeopleQuery(roster, const PeopleQuery(search: 'aline warehouse')),
        isEmpty,
      );
    });

    test('phone search ignores formatting and country code', () {
      // Stored as +250789000111, searched without the prefix.
      expect(
        idsOf(applyPeopleQuery(roster, const PeopleQuery(search: '789000111'))),
        ['e-2'],
      );
      // Stored as 0788123456, searched with spaces.
      expect(
        idsOf(
          applyPeopleQuery(roster, const PeopleQuery(search: '0788 123 456')),
        ),
        ['e-1'],
      );
    });

    test('searches the mobile money number too', () {
      final withMomo = employee(id: 'e-4', momoPhone: '0733222111');
      expect(
        idsOf(
          applyPeopleQuery(
            [withMomo],
            const PeopleQuery(search: '0733222111'),
          ),
        ),
        ['e-4'],
      );
    });

    test('a term that matches nothing returns an empty list', () {
      expect(
        applyPeopleQuery(roster, const PeopleQuery(search: 'accountant')),
        isEmpty,
      );
    });
  });

  group('department filtering', () {
    test('matches case-insensitively', () {
      final result = applyPeopleQuery(
        roster,
        const PeopleQuery(
          department: 'Retail',
          status: EmploymentStatus.terminated,
        ),
      );
      // Claude's department is stored lowercase.
      expect(idsOf(result), ['e-3']);
    });

    test('combines with search', () {
      final result = applyPeopleQuery(
        roster,
        const PeopleQuery(department: 'Warehouse', search: 'bosco'),
      );
      expect(idsOf(result), ['e-2']);
    });
  });

  group('sorting', () {
    test('name ascending and descending', () {
      expect(
        idsOf(applyPeopleQuery(roster, const PeopleQuery())),
        ['e-1', 'e-2'],
      );
      expect(
        idsOf(applyPeopleQuery(roster, const PeopleQuery(sort: PeopleSort.nameDesc))),
        ['e-2', 'e-1'],
      );
    });

    test('newest hire first', () {
      expect(
        idsOf(
          applyPeopleQuery(
            roster,
            const PeopleQuery(sort: PeopleSort.newestHire),
          ),
        ),
        ['e-2', 'e-1'],
      );
    });

    test('longest serving first', () {
      expect(
        idsOf(
          applyPeopleQuery(
            roster,
            const PeopleQuery(sort: PeopleSort.longestServing),
          ),
        ),
        ['e-1', 'e-2'],
      );
    });

    test('highest paid first, comparing monthly equivalents', () {
      final hourly = employee(
        id: 'e-5',
        firstName: 'Zoe',
        baseSalary: 5000,
        payFrequency: PayFrequency.hourly,
      );
      final result = applyPeopleQuery(
        [aline, bosco, hourly],
        const PeopleQuery(sort: PeopleSort.highestPaid),
      );
      // 5000/hr = 880,000/month, ahead of Bosco's 450,000.
      expect(idsOf(result), ['e-5', 'e-2', 'e-1']);
    });

    test('ties break on name so the order never flickers', () {
      final a = employee(id: 'x', firstName: 'Zara', baseSalary: 100000);
      final b = employee(id: 'y', firstName: 'Alpha', baseSalary: 100000);
      expect(
        idsOf(
          applyPeopleQuery(
            [a, b],
            const PeopleQuery(sort: PeopleSort.highestPaid),
          ),
        ),
        ['y', 'x'],
      );
    });
  });

  group('isFiltering', () {
    test('is false only for an untouched query', () {
      expect(const PeopleQuery().isFiltering, isFalse);
      expect(const PeopleQuery(search: 'a').isFiltering, isTrue);
      expect(const PeopleQuery(search: '   ').isFiltering, isFalse);
      expect(
        const PeopleQuery(status: EmploymentStatus.active).isFiltering,
        isTrue,
      );
      expect(const PeopleQuery(sort: PeopleSort.nameDesc).isFiltering, isFalse);
    });
  });

  group('copyWith', () {
    test('clear flags reset a filter that a plain null would keep', () {
      const query = PeopleQuery(
        status: EmploymentStatus.onLeave,
        department: 'Retail',
      );

      expect(query.copyWith(status: null).status, EmploymentStatus.onLeave);
      expect(query.copyWith(clearStatus: true).status, isNull);
      expect(query.copyWith(clearDepartment: true).department, isNull);
    });
  });

  group('departmentsOf', () {
    test('is distinct, case-insensitive and sorted, dropping blanks', () {
      final people = [
        employee(id: '1', department: 'Retail'),
        employee(id: '2', department: 'retail'),
        employee(id: '3', department: 'Warehouse'),
        employee(id: '4', department: ''),
        employee(id: '5', department: '  '),
        employee(id: '6', department: 'Admin'),
      ];

      expect(departmentsOf(people), ['Admin', 'Retail', 'Warehouse']);
    });
  });

  group('PeopleSummary', () {
    final asOf = DateTime(2026, 1, 20);

    test('headcount counts everyone still employed', () {
      final summary = PeopleSummary.from(roster, asOf: asOf);
      expect(summary.headcount, 2);
      expect(summary.active, 1);
      expect(summary.onLeave, 1);
    });

    test('suspended people count toward headcount but not active', () {
      final summary = PeopleSummary.from(
        [employee(status: EmploymentStatus.suspended)],
        asOf: asOf,
      );
      expect(summary.headcount, 1);
      expect(summary.active, 0);
    });

    test('new this month uses the month of the reference date', () {
      final summary = PeopleSummary.from(roster, asOf: asOf);
      expect(summary.newThisMonth, 1); // Bosco, hired 10 Jan 2026.

      final nextMonth = PeopleSummary.from(roster, asOf: DateTime(2026, 2, 20));
      expect(nextMonth.newThisMonth, 0);
    });

    test('monthly payroll excludes terminated people', () {
      final summary = PeopleSummary.from(roster, asOf: asOf);
      expect(summary.monthlyPayroll, 650000); // 200k + 450k, not Claude's 150k.
    });

    test('an empty roster reports zeroes and a default currency', () {
      final summary = PeopleSummary.from(const [], asOf: asOf);
      expect(summary.headcount, 0);
      expect(summary.monthlyPayroll, 0);
      expect(summary.currency, 'RWF');
    });
  });
}
