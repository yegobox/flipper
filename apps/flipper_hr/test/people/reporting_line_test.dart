import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/reporting_line.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';

/// A three-level roster: Jean runs the branch, Yves reports to Jean, and Aline
/// and Chantal report to Yves.
List<Employee> _org() => [
  employee(id: 'jean', firstName: 'Jean', lastName: 'Bosco'),
  employee(id: 'yves', firstName: 'Yves', lastName: 'Kamana', managerId: 'jean'),
  employee(id: 'aline', firstName: 'Aline', lastName: 'Uwase', managerId: 'yves'),
  employee(
    id: 'chantal',
    firstName: 'Chantal',
    lastName: 'Mukamana',
    managerId: 'yves',
  ),
];

List<String> _ids(List<Employee> people) => [for (final e in people) e.id];

void main() {
  group('directReportsOf', () {
    test('names only the people one level below', () {
      expect(_ids(directReportsOf(_org(), 'yves')), ['aline', 'chantal']);
      expect(_ids(directReportsOf(_org(), 'jean')), ['yves']);
    });

    test('nobody reports to a leaf, or to an empty id', () {
      expect(directReportsOf(_org(), 'aline'), isEmpty);
      expect(directReportsOf(_org(), ''), isEmpty);
    });
  });

  group('descendantIdsOf', () {
    test('reaches the whole team below, not just the first level', () {
      expect(descendantIdsOf(_org(), 'jean'), {'yves', 'aline', 'chantal'});
    });

    test('excludes the person asked about', () {
      expect(descendantIdsOf(_org(), 'yves'), {'aline', 'chantal'});
    });

    test('a cycle terminates instead of hanging the page', () {
      // Not reachable through the database — the trigger in 0007 refuses it — but
      // a roster read mid-write or pre-trigger data could still produce one, and
      // a walk that spun would take the whole page down with it.
      final looped = [
        employee(id: 'a', managerId: 'b'),
        employee(id: 'b', managerId: 'a'),
      ];

      expect(descendantIdsOf(looped, 'a'), {'b'});
    });
  });

  group('managerChainOf', () {
    test('walks upward, nearest manager first', () {
      expect(_ids(managerChainOf(_org(), 'aline')), ['yves', 'jean']);
    });

    test('stops at someone with no manager', () {
      expect(managerChainOf(_org(), 'jean'), isEmpty);
    });

    test('stops at a manager the roster does not hold', () {
      // A manager on another branch: the branch-scoped read cannot see them, so
      // the chain ends rather than inventing a link.
      final crossBranch = [employee(id: 'aline', managerId: 'elsewhere')];

      expect(managerChainOf(crossBranch, 'aline'), isEmpty);
    });
  });

  group('managerCandidatesFor', () {
    test('offers everyone except the person and their own team', () {
      final roster = _org();
      final yves = roster.firstWhere((e) => e.id == 'yves');

      // Aline and Chantal are below Yves; picking either would be the loop the
      // cycle trigger refuses.
      expect(
        _ids(managerCandidatesFor(roster: roster, employee: yves)),
        ['jean'],
      );
    });

    test('leaves out people who have left', () {
      final roster = [
        ..._org(),
        employee(
          id: 'gone',
          firstName: 'Gone',
          status: EmploymentStatus.terminated,
          endDate: DateTime(2026, 1, 31),
        ),
      ];
      final aline = roster.firstWhere((e) => e.id == 'aline');

      expect(
        _ids(managerCandidatesFor(roster: roster, employee: aline)),
        ['jean', 'yves', 'chantal'],
      );
    });

    test('keeps people who are away, since it is temporary', () {
      final roster = [
        employee(id: 'aline'),
        employee(
          id: 'away',
          firstName: 'Away',
          status: EmploymentStatus.onLeave,
        ),
      ];
      final aline = roster.first;

      expect(_ids(managerCandidatesFor(roster: roster, employee: aline)), [
        'away',
      ]);
    });

    test('a new hire may report to anyone, since nobody reports to them', () {
      final roster = _org();
      final draft = Employee.blank(
        businessId: 'biz-1',
        branchId: 'branch-1',
        hireDate: DateTime(2026, 8, 18),
      );

      expect(
        _ids(managerCandidatesFor(roster: roster, employee: draft)),
        ['jean', 'yves', 'aline', 'chantal'],
      );
    });

    test('an unsaved manager is never offered, having no id to point at', () {
      final roster = [
        employee(id: 'jean'),
        Employee.blank(
          businessId: 'biz-1',
          branchId: 'branch-1',
          hireDate: DateTime(2026, 8, 18),
        ),
      ];
      final aline = employee(id: 'aline');

      expect(_ids(managerCandidatesFor(roster: roster, employee: aline)), [
        'jean',
      ]);
    });
  });

  group('approverFor', () {
    test('resolves the manager who will decide their leave', () {
      final roster = _org();
      final aline = roster.firstWhere((e) => e.id == 'aline');

      expect(approverFor(roster: roster, employee: aline)?.id, 'yves');
    });

    test('null when the line says nothing — the business decides then', () {
      final roster = _org();
      final jean = roster.firstWhere((e) => e.id == 'jean');

      expect(approverFor(roster: roster, employee: jean), isNull);
    });

    test('null when the named manager is not on this roster', () {
      expect(
        approverFor(
          roster: [employee(id: 'aline', managerId: 'elsewhere')],
          employee: employee(id: 'aline', managerId: 'elsewhere'),
        ),
        isNull,
      );
    });
  });
}
