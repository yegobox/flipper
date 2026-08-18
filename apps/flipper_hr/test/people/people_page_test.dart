import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_repository.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/people/people_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';

/// Fixed "today" so tenure text and date defaults never move.
final _today = DateTime(2026, 8, 17);

Future<void> _pumpPeople(
  WidgetTester tester,
  FakeEmployeeRepository repository, {
  Size size = const Size(1400, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        employeeRepositoryProvider.overrideWithValue(repository),
        hrClockProvider.overrideWithValue(() => _today),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: PeoplePage(
            businessId: 'biz-1',
            branchId: 'branch-1',
            branchName: 'Kigali Main',
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('roster', () {
    testWidgets('lists the people on the branch', (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', firstName: 'Aline', lastName: 'Uwase'),
            employee(
              id: 'e-2',
              firstName: 'Bosco',
              lastName: 'Habimana',
              jobTitle: 'Store keeper',
            ),
          ],
        ),
      );

      expect(find.byKey(const Key('employee-row-e-1')), findsOneWidget);
      expect(find.byKey(const Key('employee-row-e-2')), findsOneWidget);
      expect(find.text('Aline Uwase'), findsOneWidget);
      expect(find.text('Store keeper'), findsOneWidget);
      expect(find.text('Everyone at Kigali Main'), findsOneWidget);
    });

    testWidgets('hides terminated people until their status is picked',
        (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', firstName: 'Aline'),
            employee(
              id: 'e-2',
              firstName: 'Claude',
              status: EmploymentStatus.terminated,
              endDate: DateTime(2026, 3, 1),
            ),
          ],
        ),
      );

      expect(find.byKey(const Key('employee-row-e-1')), findsOneWidget);
      expect(find.byKey(const Key('employee-row-e-2')), findsNothing);
    });

    testWidgets('shows the branch headcount and payroll tiles', (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', baseSalary: 200000),
            employee(
              id: 'e-2',
              firstName: 'Bosco',
              baseSalary: 450000,
              status: EmploymentStatus.onLeave,
            ),
          ],
        ),
      );

      expect(find.text('HEADCOUNT'), findsOneWidget);
      expect(find.text('RWF 650K'), findsOneWidget);
    });

    testWidgets('renders cards instead of a table on a narrow window',
        (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        size: const Size(600, 1200),
      );

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('NAME'), findsNothing);
    });
  });

  group('empty and error states', () {
    testWidgets('an empty branch offers to add the first person',
        (tester) async {
      await _pumpPeople(tester, FakeEmployeeRepository());

      expect(find.text('No one on this branch yet'), findsOneWidget);
      expect(find.byKey(const Key('people-empty-add')), findsOneWidget);
    });

    testWidgets('a load failure shows the message and retries', (tester) async {
      final repository = FakeEmployeeRepository(
        failWith: EmployeeRepositoryException('Could not load the people.'),
      );
      await _pumpPeople(tester, repository);

      expect(find.text('Could not load the people.'), findsOneWidget);

      repository.failWith = null;
      await tester.tap(find.byKey(const Key('people-retry')));
      await tester.pumpAndSettle();

      expect(find.text('No one on this branch yet'), findsOneWidget);
    });
  });

  group('search', () {
    testWidgets('filters the roster as you type', (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', firstName: 'Aline', department: 'Retail'),
            employee(id: 'e-2', firstName: 'Bosco', department: 'Warehouse'),
          ],
        ),
      );

      await tester.enterText(find.byKey(const Key('people-search')), 'bosco');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('employee-row-e-1')), findsNothing);
      expect(find.byKey(const Key('employee-row-e-2')), findsOneWidget);
    });

    testWidgets('a search matching no one offers to clear the filters',
        (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
      );

      await tester.enterText(
        find.byKey(const Key('people-search')),
        'accountant',
      );
      await tester.pumpAndSettle();
      expect(find.text('No one matches these filters'), findsOneWidget);

      await tester.tap(find.byKey(const Key('people-clear-filters')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('employee-row-e-1')), findsOneWidget);
    });
  });

  group('adding someone', () {
    testWidgets('saves a valid person and shows them on the roster',
        (tester) async {
      final repository = FakeEmployeeRepository();
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('people-empty-add')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('employee-firstName')),
        'Aline',
      );
      await tester.enterText(
        find.byKey(const Key('employee-lastName')),
        'Uwase',
      );
      await tester.enterText(
        find.byKey(const Key('employee-phone')),
        '0788123456',
      );
      await tester.enterText(
        find.byKey(const Key('employee-jobTitle')),
        'Cashier',
      );
      await tester.tap(find.byKey(const Key('employee-form-save')));
      await tester.pumpAndSettle();

      expect(repository.people.single.fullName, 'Aline Uwase');
      expect(repository.people.single.branchId, 'branch-1');
      // The new hire starts today by default.
      expect(repository.people.single.hireDate, _today);
      expect(find.byKey(const Key('employee-form-save')), findsNothing);
      expect(find.text('Aline Uwase was added to the roster.'), findsOneWidget);
    });

    testWidgets('a missing name blocks the save and reports why',
        (tester) async {
      final repository = FakeEmployeeRepository();
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('people-empty-add')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('employee-form-save')));
      await tester.pumpAndSettle();

      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
      expect(repository.people, isEmpty);
      // The form stays open so the input is not lost.
      expect(find.byKey(const Key('employee-form-save')), findsOneWidget);
    });

    testWidgets('a failed write keeps the form open with the message',
        (tester) async {
      final repository = FakeEmployeeRepository();
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('people-empty-add')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('employee-firstName')),
        'Aline',
      );
      await tester.enterText(
        find.byKey(const Key('employee-lastName')),
        'Uwase',
      );
      await tester.enterText(
        find.byKey(const Key('employee-phone')),
        '0788123456',
      );
      await tester.enterText(
        find.byKey(const Key('employee-jobTitle')),
        'Cashier',
      );

      repository.failWith = EmployeeRepositoryException('Row level security.');
      await tester.tap(find.byKey(const Key('employee-form-save')));
      await tester.pumpAndSettle();

      expect(find.text('Row level security.'), findsOneWidget);
      expect(find.byKey(const Key('employee-form-save')), findsOneWidget);
    });
  });

  group('editing', () {
    testWidgets('tapping a row opens that person with their details',
        (tester) async {
      final repository = FakeEmployeeRepository(
        seed: [employee(id: 'e-1', jobTitle: 'Cashier')],
      );
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('employee-row-e-1')));
      await tester.pumpAndSettle();

      expect(find.text('Edit person'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('employee-jobTitle')),
        'Supervisor',
      );
      await tester.tap(find.byKey(const Key('employee-form-save')));
      await tester.pumpAndSettle();

      expect(repository.people.single.jobTitle, 'Supervisor');
      expect(repository.people.length, 1);
    });
  });

  group('status changes', () {
    testWidgets('marking on leave updates the row', (tester) async {
      final repository = FakeEmployeeRepository(
        seed: [employee(id: 'e-1', firstName: 'Aline')],
      );
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark on leave'));
      await tester.pumpAndSettle();

      expect(repository.people.single.status, EmploymentStatus.onLeave);
      expect(find.text('On leave'), findsOneWidget);
    });

    testWidgets('terminating asks first and records the last day',
        (tester) async {
      final repository = FakeEmployeeRepository(
        seed: [employee(id: 'e-1', firstName: 'Aline')],
      );
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terminate'));
      await tester.pumpAndSettle();

      expect(find.text('Terminate Aline Uwase?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirm-terminate')));
      await tester.pumpAndSettle();

      expect(repository.people.single.status, EmploymentStatus.terminated);
      expect(repository.people.single.endDate, _today);
      // Terminated people leave the default roster view.
      expect(find.byKey(const Key('employee-row-e-1')), findsNothing);
    });

    testWidgets('cancelling the confirmation changes nothing', (tester) async {
      final repository = FakeEmployeeRepository(
        seed: [employee(id: 'e-1', firstName: 'Aline')],
      );
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terminate'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(repository.people.single.status, EmploymentStatus.active);
    });

    testWidgets('the menu only offers transitions that make sense',
        (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', status: EmploymentStatus.onLeave),
          ],
        ),
      );

      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();

      expect(find.text('Mark active'), findsOneWidget);
      expect(find.text('Mark on leave'), findsNothing);
      expect(find.text('Suspend'), findsOneWidget);
      expect(find.text('Terminate'), findsOneWidget);
    });

    testWidgets('a failed status change reports the error', (tester) async {
      final repository = FakeEmployeeRepository(
        seed: [employee(id: 'e-1', firstName: 'Aline')],
      );
      await _pumpPeople(tester, repository);

      repository.failWith = EmployeeRepositoryException('Network is down.');
      await tester.tap(find.byKey(const Key('people-menu-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark on leave'));
      await tester.pumpAndSettle();

      expect(find.text('Network is down.'), findsOneWidget);
    });
  });

  group('reporting line', () {
    testWidgets('the roster shows who each person reports to', (tester) async {
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(
          seed: [
            employee(
              id: 'e-1',
              firstName: 'Aline',
              lastName: 'Uwase',
              managerId: 'e-boss',
            ),
            employee(id: 'e-boss', firstName: 'Jean', lastName: 'Bosco'),
          ],
        ),
      );

      expect(find.text('REPORTS TO'), findsOneWidget);
      expect(
        tester
            .widget<Text>(find.byKey(const Key('employee-manager-e-1')))
            .data,
        'Jean Bosco',
      );
      // Nobody above Jean, so his leave falls to whoever runs the business.
      expect(
        tester
            .widget<Text>(find.byKey(const Key('employee-manager-e-boss')))
            .data,
        '—',
      );
    });

    testWidgets('a new hire can be pointed at their manager on the way in',
        (tester) async {
      final repository = FakeEmployeeRepository(
        seed: [employee(id: 'e-boss', firstName: 'Jean', lastName: 'Bosco')],
      );
      await _pumpPeople(tester, repository);

      await tester.tap(find.byKey(const Key('people-add')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('employee-firstName')),
        'Aline',
      );
      await tester.enterText(
        find.byKey(const Key('employee-lastName')),
        'Uwase',
      );
      await tester.enterText(
        find.byKey(const Key('employee-phone')),
        '0788123456',
      );
      await tester.enterText(
        find.byKey(const Key('employee-jobTitle')),
        'Cashier',
      );
      await tester.tap(find.byKey(const Key('employee-manager')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Jean Bosco · Cashier').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('employee-form-save')));
      await tester.pumpAndSettle();

      final saved = repository.people.firstWhere((e) => e.firstName == 'Aline');
      expect(saved.managerId, 'e-boss');
    });

    testWidgets('the form never offers a loop back down the line',
        (tester) async {
      // Jean manages Yves, who manages Aline. Editing Yves may only offer Jean:
      // pointing him at Aline is the cycle the database trigger refuses.
      await _pumpPeople(
        tester,
        FakeEmployeeRepository(
          seed: [
            employee(id: 'jean', firstName: 'Jean', lastName: 'Bosco'),
            employee(
              id: 'yves',
              firstName: 'Yves',
              lastName: 'Kamana',
              managerId: 'jean',
            ),
            employee(
              id: 'aline',
              firstName: 'Aline',
              lastName: 'Uwase',
              managerId: 'yves',
            ),
          ],
        ),
      );

      await tester.tap(find.byKey(const Key('employee-row-yves')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('employee-manager')));
      await tester.pumpAndSettle();

      expect(find.text('Jean Bosco · Cashier'), findsWidgets);
      expect(find.text('Aline Uwase · Cashier'), findsNothing);
      expect(find.text('No manager'), findsWidgets);
    });
  });
}
