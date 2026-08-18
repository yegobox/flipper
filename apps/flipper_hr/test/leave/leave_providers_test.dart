import 'package:flipper_hr/features/leave/data/leave_providers.dart';
import 'package:flipper_hr/features/leave/data/leave_repository.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_hr_session_repository.dart';
import '../helpers/fake_leave_repository.dart';

final _today = DateTime(2026, 8, 18);

ProviderContainer _container({
  FakeLeaveRepository? leave,
  FakeEmployeeRepository? people,
  FakeHrSessionRepository? session,
}) {
  final container = ProviderContainer(
    overrides: [
      leaveRepositoryProvider.overrideWithValue(
        leave ?? FakeLeaveRepository(),
      ),
      employeeRepositoryProvider.overrideWithValue(
        people ?? FakeEmployeeRepository(),
      ),
      hrSessionRepositoryProvider.overrideWithValue(
        session ?? FakeHrSessionRepository(),
      ),
      hrClockProvider.overrideWithValue(() => _today),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('employeeLeaveProvider', () {
    test('loads one person\'s requests, newest first', () async {
      final container = _container(
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(id: 'old', startDate: DateTime(2026, 3, 2)),
            leaveRequest(id: 'new', startDate: DateTime(2026, 9, 7)),
            leaveRequest(id: 'someone-else', employeeId: 'e-2'),
          ],
        ),
      );

      final requests = await container.read(
        employeeLeaveProvider('e-1').future,
      );

      expect([for (final r in requests) r.id], ['new', 'old']);
    });

    test('a failure stays failed instead of retrying invisibly', () async {
      final container = _container(
        leave: FakeLeaveRepository(failWith: Exception('offline')),
      );
      final subscription = container.listen(
        employeeLeaveProvider('e-1'),
        (_, __) {},
        onError: (_, __) {},
      );
      addTearDown(subscription.close);

      await expectLater(
        container.read(employeeLeaveProvider('e-1').future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(employeeLeaveProvider('e-1')).hasError, isTrue);
    });
  });

  group('pendingLeaveProvider', () {
    test('keeps only pending requests, soonest start first', () async {
      final container = _container(
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(id: 'later', startDate: DateTime(2026, 11, 2)),
            leaveRequest(
              id: 'decided',
              startDate: DateTime(2026, 9, 1),
              status: LeaveStatus.approved,
            ),
            leaveRequest(id: 'sooner', startDate: DateTime(2026, 9, 7)),
          ],
        ),
      );

      final pending = await container.read(
        pendingLeaveProvider('branch-1').future,
      );

      expect([for (final r in pending) r.id], ['sooner', 'later']);
    });
  });

  group('myLeaveProvider', () {
    test('reads the record the session resolves to', () async {
      final container = _container(
        session: FakeHrSessionRepository(session: staffSession()),
        leave: FakeLeaveRepository(
          seed: [
            leaveRequest(id: 'mine', employeeId: 'e-1'),
            leaveRequest(id: 'theirs', employeeId: 'e-2'),
          ],
        ),
      );

      final requests = await container.read(myLeaveProvider.future);

      expect([for (final r in requests) r.id], ['mine']);
    });

    test('is empty — not an error — for a session with no record', () async {
      final container = _container(
        session: FakeHrSessionRepository(session: ownerSession()),
        leave: FakeLeaveRepository(seed: [leaveRequest(id: 'someone')]),
      );

      expect(await container.read(myLeaveProvider.future), isEmpty);
    });
  });

  group('myLeaveBalancesProvider', () {
    test('computes this year\'s balances from the record and its requests',
        () async {
      final container = _container(
        session: FakeHrSessionRepository(session: staffSession()),
        people: FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
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

      final balances = await container.read(myLeaveBalancesProvider.future);
      final annual = balances.firstWhere((b) => b.type == LeaveType.annual);

      expect(annual.year, 2026);
      expect(annual.remaining, 13);
    });

    test('honours the contract override on the person\'s record', () async {
      final container = _container(
        session: FakeHrSessionRepository(session: staffSession()),
        people: FakeEmployeeRepository(
          seed: [employee(id: 'e-1', annualLeaveDays: 25)],
        ),
      );

      final balances = await container.read(myLeaveBalancesProvider.future);
      final annual = balances.firstWhere((b) => b.type == LeaveType.annual);

      expect(annual.entitlement, 25);
    });

    test('falls back to the statutory default with no record at all', () async {
      final container = _container(
        session: FakeHrSessionRepository(session: ownerSession()),
      );

      final balances = await container.read(myLeaveBalancesProvider.future);
      final annual = balances.firstWhere((b) => b.type == LeaveType.annual);

      expect(annual.entitlement, 18);
    });
  });

  group('LeaveActions.submit', () {
    test('computes the day count itself, in the type\'s own unit', () async {
      final repository = FakeLeaveRepository();
      final container = _container(leave: repository);

      final saved = await container.read(leaveActionsProvider).submit(
        employeeId: 'e-1',
        businessId: 'biz-1',
        branchId: 'branch-1',
        type: LeaveType.annual,
        // Monday to Sunday: five working days, not seven.
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 13),
      );

      expect(saved.days, 5);
    });

    test('maternity leave is charged in calendar days', () async {
      final container = _container();

      final saved = await container.read(leaveActionsProvider).submit(
        employeeId: 'e-1',
        businessId: 'biz-1',
        branchId: 'branch-1',
        type: LeaveType.maternity,
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 13),
        reason: 'Baby due',
      );

      expect(saved.days, 7);
    });

    test('files as pending even though the caller cannot say otherwise',
        () async {
      final container = _container();

      final saved = await container.read(leaveActionsProvider).submit(
        employeeId: 'e-1',
        businessId: 'biz-1',
        branchId: 'branch-1',
        type: LeaveType.annual,
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 7),
      );

      expect(saved.status, LeaveStatus.pending);
    });

    test('refreshes the person\'s list and the branch queue', () async {
      final repository = FakeLeaveRepository();
      final container = _container(leave: repository);
      // Prime both so the invalidation is observable.
      await container.read(employeeLeaveProvider('e-1').future);
      await container.read(branchLeaveProvider('branch-1').future);

      await container.read(leaveActionsProvider).submit(
        employeeId: 'e-1',
        businessId: 'biz-1',
        branchId: 'branch-1',
        type: LeaveType.annual,
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 7),
      );

      expect(
        await container.read(employeeLeaveProvider('e-1').future),
        hasLength(1),
      );
      expect(
        await container.read(branchLeaveProvider('branch-1').future),
        hasLength(1),
      );
    });

    test('the stored scope wins over what was sent', () async {
      // The database trigger derives business_id/branch_id from the employee's
      // row, so a client that sends the wrong one must not end up believing it.
      final repository = FakeLeaveRepository(
        scopeOf: const {
          'e-1': (businessId: 'biz-real', branchId: 'branch-real'),
        },
      );
      final container = _container(leave: repository);

      final saved = await container.read(leaveActionsProvider).submit(
        employeeId: 'e-1',
        businessId: 'biz-wrong',
        branchId: 'branch-wrong',
        type: LeaveType.annual,
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 7),
      );

      expect(saved.businessId, 'biz-real');
      expect(saved.branchId, 'branch-real');
    });
  });

  group('LeaveActions decisions', () {
    test('approving records the decider', () async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      final container = _container(leave: repository);

      final saved = await container.read(leaveActionsProvider).approve(
        request: repository.requests.single,
        decidedBy: 'user-owner',
        note: 'Enjoy',
      );

      expect(saved.status, LeaveStatus.approved);
      expect(saved.decidedBy, 'user-owner');
      expect(saved.decidedAt, isNotNull);
      expect(saved.decisionNote, 'Enjoy');
    });

    test('rejecting keeps the note the person will read', () async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      final container = _container(leave: repository);

      final saved = await container.read(leaveActionsProvider).reject(
        request: repository.requests.single,
        decidedBy: 'user-owner',
        note: 'Too many people out',
      );

      expect(saved.status, LeaveStatus.rejected);
      expect(saved.decisionNote, 'Too many people out');
    });

    test('deciding a request twice fails rather than overwriting', () async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      final container = _container(leave: repository);
      final request = repository.requests.single;

      await container.read(leaveActionsProvider).approve(
        request: request,
        decidedBy: 'user-a',
      );

      await expectLater(
        container.read(leaveActionsProvider).reject(
          // The stale copy a second approver would still be holding.
          request: request,
          decidedBy: 'user-b',
        ),
        throwsA(isA<LeaveRepositoryException>()),
      );
      expect(repository.requests.single.decidedBy, 'user-a');
    });

    test('withdrawing clears the decision and frees the days', () async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1', days: 5)],
      );
      final container = _container(leave: repository);

      final saved = await container
          .read(leaveActionsProvider)
          .cancel(repository.requests.single);

      expect(saved.status, LeaveStatus.cancelled);
      expect(saved.decidedBy, isNull);
      expect(saved.decidedAt, isNull);
      expect(saved.status.holdsBalance, isFalse);
    });

    test('withdrawing something already approved fails', () async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1', status: LeaveStatus.approved)],
      );
      final container = _container(leave: repository);

      await expectLater(
        container
            .read(leaveActionsProvider)
            .cancel(repository.requests.single),
        throwsA(isA<LeaveRepositoryException>()),
      );
    });

    test('a decision refreshes the branch queue', () async {
      final repository = FakeLeaveRepository(
        seed: [leaveRequest(id: 'leave-1')],
      );
      final container = _container(leave: repository);
      final before = await container.read(
        branchLeaveProvider('branch-1').future,
      );
      expect(before.single.status, LeaveStatus.pending);

      await container.read(leaveActionsProvider).approve(
        request: before.single,
        decidedBy: 'user-owner',
      );

      final after = await container.read(
        branchLeaveProvider('branch-1').future,
      );
      expect(after.single.status, LeaveStatus.approved);
    });
  });
}
