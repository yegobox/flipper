import 'package:flipper_hr/features/attendance/data/attendance_providers.dart';
import 'package:flipper_hr/features/attendance/data/attendance_session.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_attendance_repository.dart';
import '../helpers/fake_hr_session_repository.dart';

void main() {
  final now = DateTime(2026, 8, 18, 9, 30);

  ProviderContainer containerWith(
    FakeAttendanceRepository attendance, {
    FakeHrSessionRepository? session,
  }) {
    final container = ProviderContainer(
      overrides: [
        attendanceRepositoryProvider.overrideWithValue(attendance),
        hrSessionRepositoryProvider.overrideWithValue(
          session ?? FakeHrSessionRepository(session: staffSession()),
        ),
        hrClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('BranchDay', () {
    test('normalises the time away, so a rebuild reuses the cache entry', () {
      final morning = BranchDay(
        branchId: 'branch-1',
        date: DateTime(2026, 8, 18, 8, 15),
      );
      final evening = BranchDay(
        branchId: 'branch-1',
        date: DateTime(2026, 8, 18, 20, 45),
      );

      expect(morning, evening);
      expect(morning.hashCode, evening.hashCode);
    });

    test('differs by branch and by day', () {
      final a = BranchDay(branchId: 'branch-1', date: DateTime(2026, 8, 18));
      expect(
        a == BranchDay(branchId: 'branch-2', date: DateTime(2026, 8, 18)),
        isFalse,
      );
      expect(
        a == BranchDay(branchId: 'branch-1', date: DateTime(2026, 8, 19)),
        isFalse,
      );
    });
  });

  group('branchAttendanceProvider', () {
    test('loads one branch and one day', () async {
      final repository = FakeAttendanceRepository(
        now: now,
        seed: [
          session(id: 'today', startedAt: DateTime(2026, 8, 18, 8)),
          session(id: 'yesterday', startedAt: DateTime(2026, 8, 17, 8)),
          session(id: 'elsewhere', branchId: 'branch-2'),
        ],
      );
      final container = containerWith(repository);

      final sessions = await container.read(
        branchAttendanceProvider(
          BranchDay(branchId: 'branch-1', date: DateTime(2026, 8, 18)),
        ).future,
      );

      expect([for (final s in sessions) s.id], ['today']);
    });

    test('surfaces a failure as an error state', () async {
      final container = containerWith(
        FakeAttendanceRepository(now: now, failWith: Exception('offline')),
      );
      final key = BranchDay(branchId: 'branch-1', date: DateTime(2026, 8, 18));
      final sub = container.listen(
        branchAttendanceProvider(key),
        (_, __) {},
        onError: (_, __) {},
      );
      addTearDown(sub.close);

      await expectLater(
        container.read(branchAttendanceProvider(key).future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('myOpenSessionProvider', () {
    test('finds the open session for the session\'s employee', () async {
      final repository = FakeAttendanceRepository(
        now: now,
        seed: [session(id: 'open', endedAt: null)],
      );
      final container = containerWith(repository);

      final open = await container.read(myOpenSessionProvider.future);
      expect(open?.id, 'open');
    });

    test('is null when nothing is open', () async {
      final repository = FakeAttendanceRepository(
        now: now,
        seed: [
          session(
            startedAt: DateTime(2026, 8, 18, 8),
            endedAt: DateTime(2026, 8, 18, 9),
          ),
        ],
      );
      expect(
        await containerWith(repository).read(myOpenSessionProvider.future),
        isNull,
      );
    });

    test('is null, not an error, for someone with no employee record', () async {
      final container = containerWith(
        FakeAttendanceRepository(now: now),
        session: FakeHrSessionRepository(session: ownerSession()),
      );
      expect(await container.read(myOpenSessionProvider.future), isNull);
    });
  });

  group('myTimesheetProvider', () {
    test('reads the window ending today', () async {
      final repository = FakeAttendanceRepository(
        now: now,
        seed: [
          session(id: 'today', startedAt: DateTime(2026, 8, 18, 8)),
          session(id: 'inWindow', startedAt: DateTime(2026, 8, 10, 8)),
          // 14-day window starting 5 Aug, so 1 Aug falls outside it.
          session(id: 'tooOld', startedAt: DateTime(2026, 8, 1, 8)),
        ],
      );
      final container = containerWith(repository);

      final sessions = await container.read(myTimesheetProvider.future);
      expect([for (final s in sessions) s.id], ['today', 'inWindow']);
    });

    test('is empty for someone with no record', () async {
      final container = containerWith(
        FakeAttendanceRepository(now: now),
        session: FakeHrSessionRepository(session: ownerSession()),
      );
      expect(await container.read(myTimesheetProvider.future), isEmpty);
    });
  });

  group('AttendanceActions.clockIn', () {
    test('opens a session and refreshes the views it affects', () async {
      final repository = FakeAttendanceRepository(now: now);
      final container = containerWith(repository);
      await container.read(myOpenSessionProvider.future);

      final saved = await container
          .read(attendanceActionsProvider)
          .clockIn(employeeId: 'e-1');

      expect(saved.isOpen, isTrue);
      expect(saved.startedAt, now, reason: 'the server stamps the time');
      expect(await container.read(myOpenSessionProvider.future), isNotNull);
    });

    test('records who did it, so an on-behalf entry is distinguishable', () async {
      final repository = FakeAttendanceRepository(now: now);
      final container = containerWith(repository);

      final saved = await container.read(attendanceActionsProvider).clockIn(
        employeeId: 'e-1',
        source: AttendanceSource.manager,
      );

      expect(saved.source, AttendanceSource.manager);
    });

    test('a second clock-in is refused rather than double-counting the day',
        () async {
      final repository = FakeAttendanceRepository(now: now);
      final container = containerWith(repository);
      await container.read(attendanceActionsProvider).clockIn(employeeId: 'e-1');

      await expectLater(
        container.read(attendanceActionsProvider).clockIn(employeeId: 'e-1'),
        throwsA(isA<Exception>()),
      );
      expect(repository.sessions.length, 1);
    });
  });

  group('AttendanceActions.clockOut', () {
    test('closes the session and computes its minutes', () async {
      final repository = FakeAttendanceRepository(
        now: DateTime(2026, 8, 18, 8),
      );
      final container = containerWith(repository);
      final open = await container
          .read(attendanceActionsProvider)
          .clockIn(employeeId: 'e-1');

      repository.now = DateTime(2026, 8, 18, 16, 30);
      final closed = await container
          .read(attendanceActionsProvider)
          .clockOut(session: open);

      expect(closed.isOpen, isFalse);
      expect(closed.minutes, 510);
      expect(await container.read(myOpenSessionProvider.future), isNull);
    });

    test('closing an already-closed session fails rather than silently passing',
        () async {
      final repository = FakeAttendanceRepository(
        now: now,
        seed: [
          session(
            id: 'closed',
            startedAt: DateTime(2026, 8, 18, 8),
            endedAt: DateTime(2026, 8, 18, 9),
          ),
        ],
      );
      final container = containerWith(repository);

      await expectLater(
        container.read(attendanceActionsProvider).clockOut(
          session: repository.sessions.single,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('AttendanceActions.correct', () {
    test('rewrites the times and recomputes the duration', () async {
      final repository = FakeAttendanceRepository(
        now: now,
        seed: [
          session(
            id: 's-1',
            startedAt: DateTime(2026, 8, 18, 9),
            endedAt: DateTime(2026, 8, 18, 17),
          ),
        ],
      );
      final container = containerWith(repository);

      final corrected = await container.read(attendanceActionsProvider).correct(
        repository.sessions.single.copyWith(
          startedAt: DateTime(2026, 8, 18, 8),
        ),
      );

      expect(corrected.minutes, 540);
      expect(
        corrected.source,
        AttendanceSource.manager,
        reason: 'a corrected entry is not a self-service one',
      );
    });

    test('moving a session to another day refreshes both days', () async {
      // Both BranchDay entries must be invalidated, or the day it left keeps
      // showing it.
      final repository = FakeAttendanceRepository(
        now: now,
        seed: [
          session(
            id: 's-1',
            startedAt: DateTime(2026, 8, 18, 8),
            endedAt: DateTime(2026, 8, 18, 12),
          ),
        ],
      );
      final container = containerWith(repository);
      final from = BranchDay(branchId: 'branch-1', date: DateTime(2026, 8, 18));
      final to = BranchDay(branchId: 'branch-1', date: DateTime(2026, 8, 17));
      expect((await container.read(branchAttendanceProvider(from).future)).length, 1);
      expect(await container.read(branchAttendanceProvider(to).future), isEmpty);

      await container.read(attendanceActionsProvider).correct(
        repository.sessions.single.copyWith(
          startedAt: DateTime(2026, 8, 17, 8),
          endedAt: DateTime(2026, 8, 17, 12),
        ),
      );

      expect(await container.read(branchAttendanceProvider(from).future), isEmpty);
      expect((await container.read(branchAttendanceProvider(to).future)).length, 1);
    });
  });
}
