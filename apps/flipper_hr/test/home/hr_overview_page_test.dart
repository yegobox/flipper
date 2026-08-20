import 'package:flipper_hr/features/home/hr_overview_page.dart';
import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_account_repository.dart';
import 'package:flipper_hr/features/session/data/hr_identity_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_hr_account_repository.dart';
import '../helpers/fake_hr_session_repository.dart';
import '../helpers/fake_leave_repository.dart';

/// A fixed morning, so the greeting and the "this month" counts never move.
final _today = DateTime(2026, 8, 17, 9, 30);

Future<void> _pumpOverview(
  WidgetTester tester, {
  List<Employee> people = const [],
  List<LeaveRequest> leave = const [],
  String? accountName = 'Aline Uwase',
  Size size = const Size(1400, 1400),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        employeeRepositoryProvider.overrideWithValue(
          FakeEmployeeRepository(seed: people),
        ),
        leaveRepositoryProvider.overrideWithValue(
          FakeLeaveRepository(seed: leave),
        ),
        hrClockProvider.overrideWithValue(() => _today),
        // Without these the chrome's identity lookup reaches for a Supabase
        // client that no widget test has, and every render logs the assertion.
        hrSessionRepositoryProvider.overrideWithValue(
          FakeHrSessionRepository(session: ownerSession()),
        ),
        // The login profile is flipper_web's, and it reaches for Supabase too.
        currentUserProfileProvider.overrideWith((ref) async => null),
        hrAccountRepositoryProvider.overrideWithValue(
          FakeHrAccountRepository(
            row: accountName == null
                ? null
                : HrAccountRow(name: accountName),
          ),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: HrOverviewPage(
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
  group('the dashboard', () {
    testWidgets('greets by name and names the branch and the day',
        (tester) async {
      await _pumpOverview(tester, people: [employee(id: 'e-1')]);

      expect(find.text('Good morning, Aline'), findsOneWidget);
      expect(find.text('Monday, 17 August · Kigali Main'), findsOneWidget);
    });

    testWidgets('counts the branch, not the filtered roster', (tester) async {
      await _pumpOverview(
        tester,
        people: [
          employee(id: 'e-1'),
          employee(id: 'e-2', firstName: 'Bosco'),
          employee(
            id: 'e-3',
            firstName: 'Claude',
            status: EmploymentStatus.onLeave,
          ),
          employee(
            id: 'e-4',
            firstName: 'Diane',
            status: EmploymentStatus.terminated,
            endDate: DateTime(2026, 3, 1),
          ),
        ],
      );

      final headcount = find.descendant(
        of: find.byKey(const Key('hr-overview-headcount')),
        matching: find.text('3'),
      );
      expect(headcount, findsOneWidget, reason: 'terminated is not headcount');
    });

    testWidgets('leads with the leave nobody has decided', (tester) async {
      await _pumpOverview(
        tester,
        people: [employee(id: 'e-1', firstName: 'Aline', lastName: 'Uwase')],
        leave: [
          leaveRequest(
            id: 'l-1',
            employeeId: 'e-1',
            startDate: DateTime(2026, 8, 19),
            endDate: DateTime(2026, 8, 21),
            days: 3,
          ),
        ],
      );

      final panel = find.byKey(const Key('hr-overview-needs-you'));
      expect(panel, findsOneWidget);
      expect(
        find.descendant(of: panel, matching: find.text('Aline Uwase')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: panel,
          matching: find.text('Annual leave · 19 Aug – 21 Aug · 3 days'),
        ),
        findsOneWidget,
      );
      // And the quick action carries the same count.
      expect(find.text('Review 1 request'), findsOneWidget);
    });

    testWidgets('an empty queue is good news, not an empty list',
        (tester) async {
      await _pumpOverview(tester, people: [employee(id: 'e-1')]);

      expect(
        find.text('Nothing is waiting on you. Every request has been decided.'),
        findsOneWidget,
      );
      expect(find.text('Approvals'), findsOneWidget);
    });

    testWidgets('a decided request is not waiting on anybody', (tester) async {
      await _pumpOverview(
        tester,
        people: [employee(id: 'e-1')],
        leave: [
          leaveRequest(id: 'l-1', status: LeaveStatus.approved),
        ],
      );

      expect(
        find.text('Nothing is waiting on you. Every request has been decided.'),
        findsOneWidget,
      );
    });

    testWidgets('says who is out and who has just joined', (tester) async {
      await _pumpOverview(
        tester,
        people: [
          employee(
            id: 'e-1',
            firstName: 'Aline',
            status: EmploymentStatus.onLeave,
            hireDate: DateTime(2024, 1, 9),
          ),
          employee(
            id: 'e-2',
            firstName: 'Bosco',
            hireDate: DateTime(2026, 8, 3),
          ),
        ],
      );

      expect(
        find.descendant(
          of: find.byKey(const Key('hr-overview-out-today')),
          matching: find.text('Aline Uwase'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('hr-overview-joiners')),
          matching: find.text('Bosco Uwase'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('an empty branch says so in both panels', (tester) async {
      await _pumpOverview(tester);

      expect(find.text('Everyone is in today.'), findsOneWidget);
      expect(find.text('Nobody new this month.'), findsOneWidget);
    });
  });

  group('greetingFor', () {
    test('changes with the hour', () {
      expect(greetingFor(DateTime(2026, 8, 17, 5)), 'Good morning');
      expect(greetingFor(DateTime(2026, 8, 17, 11, 59)), 'Good morning');
      expect(greetingFor(DateTime(2026, 8, 17, 12)), 'Good afternoon');
      expect(greetingFor(DateTime(2026, 8, 17, 17, 59)), 'Good afternoon');
      expect(greetingFor(DateTime(2026, 8, 17, 18)), 'Good evening');
    });
  });

  group('firstNameOf', () {
    test('greets with the first word', () {
      expect(firstNameOf('Aline Uwase Mukamana'), 'Aline');
      expect(firstNameOf('Aline'), 'Aline');
      expect(firstNameOf('  '), '  ');
    });
  });

  group('formatShortRange', () {
    test('collapses a single day', () {
      expect(formatShortRange(DateTime(2026, 8, 19), DateTime(2026, 8, 19)),
          '19 Aug');
    });

    test('spans two dates', () {
      expect(formatShortRange(DateTime(2026, 8, 19), DateTime(2026, 9, 2)),
          '19 Aug – 2 Sep');
    });
  });
}
