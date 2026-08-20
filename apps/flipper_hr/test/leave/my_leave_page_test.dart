import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/my_leave_page.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_hr_session_repository.dart';
import '../helpers/fake_leave_repository.dart';

/// A Tuesday, so the form's "next working day" default is the same day.
final _today = DateTime(2026, 8, 18);

Future<void> _pumpMyLeave(
  WidgetTester tester, {
  FakeLeaveRepository? leave,
  FakeEmployeeRepository? people,
  FakeHrSessionRepository? session,
  Size size = const Size(1400, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        leaveRepositoryProvider.overrideWithValue(
          leave ?? FakeLeaveRepository(),
        ),
        employeeRepositoryProvider.overrideWithValue(
          people ?? FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        ),
        hrSessionRepositoryProvider.overrideWithValue(
          session ?? FakeHrSessionRepository(session: staffSession()),
        ),
        hrClockProvider.overrideWithValue(() => _today),
      ],
      child: const MaterialApp(home: Scaffold(body: MyLeavePage())),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('the balances', () {
    testWidgets('shows every leave type with the statutory entitlement',
        (tester) async {
      await _pumpMyLeave(tester);

      for (final type in LeaveType.values) {
        expect(
          find.byKey(Key('leave-balance-${type.wire}')),
          findsOneWidget,
          reason: '${type.wire} has no card',
        );
      }
      expect(find.text('left of 18 days'), findsOneWidget);
    });

    testWidgets('deducts approved leave from what is left', (tester) async {
      await _pumpMyLeave(
        tester,
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(
              id: 'spent',
              startDate: DateTime(2026, 3, 2),
              endDate: DateTime(2026, 3, 6),
              days: 5,
              status: LeaveStatus.approved,
            ),
          ],
        ),
      );

      expect(find.text('13 days'), findsOneWidget);
    });

    testWidgets('flags days that are still awaiting approval', (tester) async {
      await _pumpMyLeave(
        tester,
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'awaiting', days: 3)],
        ),
      );

      expect(find.text('3 days awaiting approval'), findsOneWidget);
    });

    testWidgets('honours a contract entitlement on the record', (tester) async {
      await _pumpMyLeave(
        tester,
        people: FakeEmployeeRepository(
          seed: [employee(id: 'e-1', annualLeaveDays: 25)],
        ),
      );

      expect(find.text('left of 25 days'), findsOneWidget);
    });

    testWidgets('unpaid leave shows what was taken, with no limit',
        (tester) async {
      await _pumpMyLeave(tester);

      expect(find.text('taken · no yearly limit'), findsOneWidget);
    });
  });

  group('the request list', () {
    testWidgets('lists the person\'s own requests with their status',
        (tester) async {
      await _pumpMyLeave(
        tester,
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(
              id: 'mine',
              type: LeaveType.sick,
              reason: 'Flu',
              status: LeaveStatus.approved,
              decisionNote: 'Get well',
            ),
            leaveRequest(id: 'theirs', employeeId: 'e-2'),
          ],
        ),
      );

      expect(find.byKey(const Key('leave-request-mine')), findsOneWidget);
      expect(find.byKey(const Key('leave-request-theirs')), findsNothing);
      expect(find.text('Sick leave'), findsWidgets);
      expect(find.text('Approved'), findsOneWidget);
      expect(find.text('Flu'), findsOneWidget);
      expect(find.text('“Get well”'), findsOneWidget);
    });

    testWidgets('offers a withdrawal only for a pending request',
        (tester) async {
      await _pumpMyLeave(
        tester,
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(id: 'pending', startDate: DateTime(2026, 10, 5)),
            leaveRequest(
              id: 'approved',
              startDate: DateTime(2026, 9, 7),
              status: LeaveStatus.approved,
            ),
          ],
        ),
      );

      expect(find.byKey(const Key('withdraw-pending')), findsOneWidget);
      expect(find.byKey(const Key('withdraw-approved')), findsNothing);
    });

    testWidgets('withdrawing asks first, then frees the days', (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'pending', days: 5)],
      );
      await _pumpMyLeave(tester, leave: repository);
      expect(find.text('13 days'), findsOneWidget);

      await tester.tap(find.byKey(const Key('withdraw-pending')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-withdraw')));
      await tester.pumpAndSettle();

      expect(repository.requests.single.status, LeaveStatus.cancelled);
      expect(find.text('18 days'), findsOneWidget);
    });

    testWidgets('backing out of the confirmation changes nothing',
        (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'pending')],
      );
      await _pumpMyLeave(tester, leave: repository);

      await tester.tap(find.byKey(const Key('withdraw-pending')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep it'));
      await tester.pumpAndSettle();

      expect(repository.requests.single.status, LeaveStatus.pending);
    });

    testWidgets('an empty history says what the balances mean', (tester) async {
      await _pumpMyLeave(tester);

      expect(find.textContaining('No leave booked yet'), findsOneWidget);
    });
  });

  group('booking leave', () {
    testWidgets('sends a request and shows it as pending', (tester) async {
      final repository = FakeLeaveRepository();
      await _pumpMyLeave(tester, leave: repository);

      await tester.tap(find.byKey(const Key('request-leave-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-submit')));
      await tester.pumpAndSettle();

      expect(repository.submitCount, 1);
      final saved = repository.requests.single;
      expect(saved.employeeId, 'e-1');
      expect(saved.type, LeaveType.annual);
      expect(saved.status, LeaveStatus.pending);
      // Defaulted to a single working day, today.
      expect(saved.days, 1);
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('the form previews the cost before it is sent', (tester) async {
      await _pumpMyLeave(tester);

      await tester.tap(find.byKey(const Key('request-leave-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('leave-cost-preview')), findsOneWidget);
      expect(
        find.textContaining('1 day (working days) · 17 days left after this'),
        findsOneWidget,
      );
    });

    testWidgets('a type that needs a reason blocks the send until there is one',
        (tester) async {
      final repository = FakeLeaveRepository();
      await _pumpMyLeave(tester, leave: repository);

      await tester.tap(find.byKey(const Key('request-leave-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-type-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sick leave').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-submit')));
      await tester.pumpAndSettle();

      expect(repository.submitCount, 0);
      expect(find.byKey(const Key('leave-problems')), findsOneWidget);
      expect(find.textContaining('Say briefly why'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('leave-reason-field')), 'Flu');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-submit')));
      await tester.pumpAndSettle();

      expect(repository.submitCount, 1);
      expect(repository.requests.single.type, LeaveType.sick);
      expect(repository.requests.single.reason, 'Flu');
    });

    testWidgets('an exhausted balance is refused in the form, not by the server',
        (tester) async {
      final repository = FakeLeaveRepository(
        seed: [
          leaveRequest(
            id: 'spent',
            startDate: DateTime(2026, 3, 2),
            endDate: DateTime(2026, 3, 27),
            days: 18,
            status: LeaveStatus.approved,
          ),
        ],
      );
      await _pumpMyLeave(tester, leave: repository);

      await tester.tap(find.byKey(const Key('request-leave-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-submit')));
      await tester.pumpAndSettle();

      expect(repository.submitCount, 0);
      expect(
        find.textContaining('No annual leave left for 2026'),
        findsOneWidget,
      );
    });

    testWidgets('a clash with existing leave is refused', (tester) async {
      final repository = FakeLeaveRepository(
        seed: [
          leaveRequest(
            id: 'existing',
            startDate: _today,
            endDate: _today,
            days: 1,
            status: LeaveStatus.approved,
          ),
        ],
      );
      await _pumpMyLeave(tester, leave: repository);

      await tester.tap(find.byKey(const Key('request-leave-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-submit')));
      await tester.pumpAndSettle();

      expect(repository.submitCount, 0);
      expect(find.textContaining('overlaps leave you already have'),
          findsOneWidget);
    });

    testWidgets('a backend failure keeps the form open with the message',
        (tester) async {
      final repository = FakeLeaveRepository();
      await _pumpMyLeave(tester, leave: repository);

      await tester.tap(find.byKey(const Key('request-leave-button')));
      await tester.pumpAndSettle();
      repository.failWith = Exception('new row violates row-level security');
      await tester.tap(find.byKey(const Key('leave-submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('leave-submit')), findsOneWidget);
      expect(
        find.textContaining('violates row-level security'),
        findsOneWidget,
      );
    });

    testWidgets('cancelling the form sends nothing', (tester) async {
      final repository = FakeLeaveRepository();
      await _pumpMyLeave(tester, leave: repository);

      await tester.tap(find.byKey(const Key('request-leave-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(repository.submitCount, 0);
    });

    testWidgets('someone who has left cannot book more', (tester) async {
      await _pumpMyLeave(
        tester,
        people: FakeEmployeeRepository(
          seed: [
            employee(
              id: 'e-1',
              status: EmploymentStatus.terminated,
              endDate: DateTime(2026, 7, 1),
            ),
          ],
        ),
      );

      expect(
        tester
            .widget<FilledButton>(
              find.ancestor(
                of: find.text('Request leave'),
                matching: find.byKey(const Key('request-leave-button')),
              ),
            )
            .onPressed,
        isNull,
      );
      expect(find.textContaining('Your employment has ended'), findsOneWidget);
    });
  });

  group('sessions with nothing to show', () {
    testWidgets('an account with no record explains how to get one',
        (tester) async {
      await _pumpMyLeave(
        tester,
        session: FakeHrSessionRepository(session: ownerSession()),
      );

      expect(
        find.text('No employee record for this account'),
        findsOneWidget,
      );
      expect(find.textContaining('invite you from the People page'),
          findsOneWidget);
    });

    testWidgets('a record the session points at but cannot read is the same state',
        (tester) async {
      await _pumpMyLeave(
        tester,
        session: FakeHrSessionRepository(
          session: const HrSession(employeeIds: ['e-missing']),
        ),
        people: FakeEmployeeRepository(),
      );

      expect(
        find.text('No employee record for this account'),
        findsOneWidget,
      );
    });

    testWidgets('a failed session resolve offers a retry', (tester) async {
      final session = FakeHrSessionRepository(
        failWith: HrSessionException('hr_whoami_employee() is missing'),
      );
      await _pumpMyLeave(tester, session: session);

      expect(find.text('Could not load your record'), findsOneWidget);
      expect(
        find.textContaining('hr_whoami_employee() is missing'),
        findsOneWidget,
      );

      session.failWith = null;
      session.session = staffSession();
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('My leave'), findsOneWidget);
    });
  });
}
