import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/leave_approvals_page.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_leave_repository.dart';

final _today = DateTime(2026, 8, 18);

Future<void> _pumpApprovals(
  WidgetTester tester, {
  FakeLeaveRepository? leave,
  FakeEmployeeRepository? people,
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
        hrClockProvider.overrideWithValue(() => _today),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LeaveApprovalsPage(
            branchId: 'branch-1',
            branchName: 'Kigali Main',
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
}
