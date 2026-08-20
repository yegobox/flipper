import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/leave_approvals_page.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_hr_line_repository.dart';
import '../helpers/fake_hr_session_repository.dart';
import '../helpers/fake_leave_repository.dart';

final _today = DateTime(2026, 8, 18);

/// Pumps the queue as an owner of branch-1 unless told otherwise.
///
/// [session] is what decides which queue the page builds at all: an owner reads
/// the branch, while a line manager reads their team and passes no [branchId].
Future<void> _pumpApprovals(
  WidgetTester tester, {
  FakeLeaveRepository? leave,
  FakeEmployeeRepository? people,
  FakeHrLineRepository? line,
  HrSession? session,
  String? branchId = 'branch-1',
  String? branchName = 'Kigali Main',
  String? deciderUserId = 'user-owner',
}) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        leaveRepositoryProvider.overrideWithValue(
          leave ?? FakeLeaveRepository(),
        ),
        employeeRepositoryProvider.overrideWithValue(
          people ??
              FakeEmployeeRepository(
                seed: [
                  employee(id: 'e-1', firstName: 'Aline', lastName: 'Uwase'),
                ],
              ),
        ),
        hrLineRepositoryProvider.overrideWithValue(
          line ?? FakeHrLineRepository(),
        ),
        hrSessionRepositoryProvider.overrideWithValue(
          FakeHrSessionRepository(session: session ?? ownerSession()),
        ),
        hrClockProvider.overrideWithValue(() => _today),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LeaveApprovalsPage(
            branchId: branchId,
            branchName: branchName,
            deciderUserId: deciderUserId,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('the queue', () {
    testWidgets('lists pending requests against the person\'s name',
        (tester) async {
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'leave-1', reason: 'Family trip')],
        ),
      );

      expect(find.byKey(const Key('approval-leave-1')), findsOneWidget);
      expect(find.text('Aline Uwase'), findsOneWidget);
      expect(find.text('Family trip'), findsOneWidget);
      expect(
        find.text('1 request waiting on you · Kigali Main'),
        findsOneWidget,
      );
    });

    testWidgets('counts more than one request in the plural', (tester) async {
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(id: 'a', startDate: DateTime(2026, 9, 7)),
            leaveRequest(id: 'b', startDate: DateTime(2026, 10, 5)),
          ],
        ),
      );

      expect(
        find.text('2 requests waiting on you · Kigali Main'),
        findsOneWidget,
      );
    });

    testWidgets('puts the soonest start first, not the newest filing',
        (tester) async {
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(id: 'later', startDate: DateTime(2026, 11, 2)),
            leaveRequest(id: 'sooner', startDate: DateTime(2026, 9, 7)),
          ],
        ),
      );

      // Screen position, not widget order: the queue is a sliver list, so "first"
      // means higher up.
      final sooner = tester
          .getTopLeft(find.byKey(const Key('approval-sooner')))
          .dy;
      final later = tester
          .getTopLeft(find.byKey(const Key('approval-later')))
          .dy;
      expect(sooner, lessThan(later));
    });

    testWidgets('separates decided requests from the queue', (tester) async {
      await _pumpApprovals(
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

      expect(find.byKey(const Key('approval-pending')), findsOneWidget);
      expect(find.byKey(const Key('approval-approved')), findsNothing);
      expect(find.text('Decided'), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);
    });

    testWidgets('shows requests from other branches nowhere', (tester) async {
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'elsewhere', branchId: 'branch-2')],
        ),
      );

      expect(find.byKey(const Key('approval-elsewhere')), findsNothing);
      expect(find.text('No leave requests yet'), findsOneWidget);
    });

    testWidgets('a request whose person is not on the roster still lists',
        (tester) async {
      // A row nobody can see is a row nobody will ever decide.
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'leave-1', employeeId: 'e-unknown')],
        ),
        people: FakeEmployeeRepository(),
      );

      expect(find.byKey(const Key('approval-leave-1')), findsOneWidget);
      expect(find.text('Employee e-unknown'), findsOneWidget);
    });

    testWidgets('a failed roster read degrades to ids, not a blocked queue',
        (tester) async {
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(seed: [leaveRequest(id: 'leave-1')]),
        people: FakeEmployeeRepository(failWith: Exception('offline')),
      );

      expect(find.byKey(const Key('approval-leave-1')), findsOneWidget);
      expect(find.text('Employee e-1'), findsOneWidget);
    });

    testWidgets('a failed leave read offers a retry', (tester) async {
      final repository = FakeLeaveRepository(failWith: Exception('offline'));
      await _pumpApprovals(tester, leave: repository);

      expect(find.text('offline'), findsOneWidget);

      repository.failWith = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('No leave requests yet'), findsOneWidget);
    });
  });

  group('deciding', () {
    testWidgets('approving records the decider and the note', (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      await _pumpApprovals(tester, leave: repository);

      await tester.tap(find.byKey(const Key('approve-leave-1')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('leave-decision-note')),
        'Enjoy',
      );
      await tester.tap(find.byKey(const Key('leave-decision-confirm')));
      await tester.pumpAndSettle();

      final saved = repository.requests.single;
      expect(saved.status, LeaveStatus.approved);
      expect(saved.decidedBy, 'user-owner');
      expect(saved.decisionNote, 'Enjoy');
      expect(find.text('Leave approved.'), findsOneWidget);
    });

    testWidgets('rejecting keeps the reason for the person to read',
        (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      await _pumpApprovals(tester, leave: repository);

      await tester.tap(find.byKey(const Key('reject-leave-1')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('leave-decision-note')),
        'Too many people out',
      );
      await tester.tap(find.byKey(const Key('leave-decision-confirm')));
      await tester.pumpAndSettle();

      final saved = repository.requests.single;
      expect(saved.status, LeaveStatus.rejected);
      expect(saved.decisionNote, 'Too many people out');
    });

    testWidgets('an empty note is still a decision', (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      await _pumpApprovals(tester, leave: repository);

      await tester.tap(find.byKey(const Key('approve-leave-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-decision-confirm')));
      await tester.pumpAndSettle();

      expect(repository.requests.single.status, LeaveStatus.approved);
    });

    testWidgets('dismissing the dialog decides nothing', (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      await _pumpApprovals(tester, leave: repository);

      await tester.tap(find.byKey(const Key('approve-leave-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(repository.requests.single.status, LeaveStatus.pending);
    });

    testWidgets('a decided request leaves the queue', (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      await _pumpApprovals(tester, leave: repository);

      await tester.tap(find.byKey(const Key('approve-leave-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-decision-confirm')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('approval-leave-1')), findsNothing);
      expect(
        find.text('Nothing waiting on you · Kigali Main'),
        findsOneWidget,
      );
      expect(find.text('Decided'), findsOneWidget);
    });

    testWidgets('a failed decision reports it and leaves the row alone',
        (tester) async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      await _pumpApprovals(tester, leave: repository);

      await tester.tap(find.byKey(const Key('approve-leave-1')));
      await tester.pumpAndSettle();
      repository.failWith = Exception('row-level security');
      await tester.tap(find.byKey(const Key('leave-decision-confirm')));
      await tester.pumpAndSettle();

      expect(find.text('row-level security'), findsOneWidget);
      expect(repository.requests.single.status, LeaveStatus.pending);
    });

    testWidgets('an approver with no profile id can still decide',
        (tester) async {
      // decided_by is nullable; a missing profile must not block the queue.
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      await _pumpApprovals(tester, leave: repository, deciderUserId: null);

      await tester.tap(find.byKey(const Key('approve-leave-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('leave-decision-confirm')));
      await tester.pumpAndSettle();

      expect(repository.requests.single.status, LeaveStatus.approved);
      expect(repository.requests.single.decidedBy, isNull);
    });

    testWidgets('the dialog names the period being decided', (tester) async {
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(
              id: 'leave-1',
              type: LeaveType.compassionate,
              startDate: DateTime(2026, 9, 7),
              endDate: DateTime(2026, 9, 9),
              days: 3,
            ),
          ],
        ),
      );

      await tester.tap(find.byKey(const Key('approve-leave-1')));
      await tester.pumpAndSettle();

      // The card carries the same summary line, so scope the match to the
      // dialog rather than the whole tree.
      expect(
        find.descendant(
          of: find.byKey(const Key('leave-decision-dialog')),
          matching: find.text(
            'Compassionate leave · 7 Sep 2026 → 9 Sep 2026 · 3 days',
          ),
        ),
        findsOneWidget,
      );
    });
  });

  group('the reporting line', () {
    testWidgets('a line manager sees their team with no branch at all',
        (tester) async {
      // No business scope and no branch selection: the queue is hr_my_report_ids()
      // through teamLeaveProvider, and the row is on a branch this session could
      // not have selected.
      await _pumpApprovals(
        tester,
        branchId: null,
        branchName: null,
        session: lineManagerSession(reportIds: const ['e-1']),
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'leave-1', branchId: 'branch-9')],
        ),
        line: FakeHrLineRepository(
          seed: [
            personRef(id: 'e-1', firstName: 'Aline', managerId: 'e-boss'),
            personRef(id: 'e-boss', firstName: 'Jean', lastName: 'Bosco'),
          ],
        ),
      );

      expect(find.byKey(const Key('approval-leave-1')), findsOneWidget);
      expect(find.text('Aline Uwase'), findsOneWidget);
      expect(find.text('1 request waiting on you · Your team'), findsOneWidget);
      expect(find.byKey(const Key('approve-leave-1')), findsOneWidget);
    });

    testWidgets('an owner sees whose queue a request is really in',
        (tester) async {
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'leave-1', employeeId: 'e-1')],
        ),
        people: FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', firstName: 'Aline', managerId: 'e-boss'),
            employee(id: 'e-boss', firstName: 'Jean', lastName: 'Bosco'),
          ],
        ),
      );

      expect(find.text('With their manager'), findsOneWidget);
      expect(find.text('Reports to Jean Bosco'), findsOneWidget);
      expect(
        find.text(
          'Nothing waiting on you · 1 with another manager · Kigali Main',
        ),
        findsOneWidget,
      );
      // Still decidable: business scope overrides the line, deliberately.
      expect(find.byKey(const Key('approve-leave-1')), findsOneWidget);
    });

    testWidgets('someone with no manager waits on whoever runs the business',
        (tester) async {
      // The pre-0007 fallback, and the reason an owner's queue does not empty out
      // the day reporting lines are switched on.
      await _pumpApprovals(
        tester,
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'leave-1', employeeId: 'e-1')],
        ),
        people: FakeEmployeeRepository(
          seed: [employee(id: 'e-1', firstName: 'Aline')],
        ),
      );

      expect(find.text('With their manager'), findsNothing);
      expect(
        find.text('1 request waiting on you · Kigali Main'),
        findsOneWidget,
      );
    });

    testWidgets('an owner who also runs a team gets their own team first',
        (tester) async {
      await _pumpApprovals(
        tester,
        session: const HrSession(
          businessIds: ['biz-1'],
          employeeIds: ['e-boss'],
          reportIds: ['e-1'],
        ),
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(id: 'mine', employeeId: 'e-1'),
            leaveRequest(id: 'theirs', employeeId: 'e-2'),
          ],
        ),
        people: FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', firstName: 'Aline', managerId: 'e-boss'),
            employee(id: 'e-2', firstName: 'Chantal', managerId: 'e-other'),
            employee(id: 'e-boss', firstName: 'Jean', lastName: 'Bosco'),
            employee(id: 'e-other', firstName: 'Yves', lastName: 'Kamana'),
          ],
        ),
      );

      expect(find.text('Waiting on you'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byKey(const Key('approval-mine'))).dy,
        lessThan(
          tester.getTopLeft(find.byKey(const Key('approval-theirs'))).dy,
        ),
      );
      expect(
        find.text(
          '1 request waiting on you · 1 with another manager · Kigali Main',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a skip-level request stays under its own manager',
        (tester) async {
      // hr_my_report_ids() is recursive, so a manager two levels up may answer —
      // but the request is still the nearer manager's, and the heading says so.
      await _pumpApprovals(
        tester,
        branchId: null,
        branchName: null,
        session: lineManagerSession(
          employeeId: 'e-boss',
          reportIds: const ['e-other', 'e-2'],
        ),
        leave: FakeLeaveRepository(
          seed: [leaveRequest(id: 'leave-2', employeeId: 'e-2')],
        ),
        line: FakeHrLineRepository(
          seed: [
            personRef(id: 'e-2', firstName: 'Chantal', managerId: 'e-other'),
            personRef(
              id: 'e-other',
              firstName: 'Yves',
              lastName: 'Kamana',
              managerId: 'e-boss',
            ),
            personRef(id: 'e-boss', firstName: 'Jean', lastName: 'Bosco'),
          ],
        ),
      );

      expect(find.text('With their manager'), findsOneWidget);
      expect(find.text('Reports to Yves Kamana'), findsOneWidget);
      expect(find.byKey(const Key('approve-leave-2')), findsOneWidget);
      expect(
        find.text('Nothing waiting on you · 1 with another manager · Your team'),
        findsOneWidget,
      );
    });

    testWidgets('an empty team queue says whose requests will land there',
        (tester) async {
      await _pumpApprovals(
        tester,
        branchId: null,
        branchName: null,
        session: lineManagerSession(reportIds: const ['e-1']),
      );

      expect(
        find.textContaining('reports to you will appear here'),
        findsOneWidget,
      );
    });
  });
}
