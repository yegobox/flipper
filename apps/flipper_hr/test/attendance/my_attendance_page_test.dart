import 'package:flipper_hr/features/attendance/data/attendance_providers.dart';
import 'package:flipper_hr/features/attendance/data/attendance_repository.dart';
import 'package:flipper_hr/features/attendance/my_attendance_page.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_attendance_repository.dart';
import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_hr_session_repository.dart';

final _now = DateTime(2026, 8, 18, 9, 30);

Future<void> _pumpMyTime(
  WidgetTester tester, {
  FakeAttendanceRepository? attendance,
  FakeEmployeeRepository? people,
  FakeHrSessionRepository? session,
  Size size = const Size(1200, 1400),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        attendanceRepositoryProvider.overrideWithValue(
          attendance ?? FakeAttendanceRepository(now: _now),
        ),
        employeeRepositoryProvider.overrideWithValue(
          people ?? FakeEmployeeRepository(seed: [employee(id: 'e-1')]),
        ),
        hrSessionRepositoryProvider.overrideWithValue(
          session ?? FakeHrSessionRepository(session: staffSession()),
        ),
        hrClockProvider.overrideWithValue(() => _now),
      ],
      child: const MaterialApp(home: Scaffold(body: MyAttendancePage())),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('the clock card', () {
    testWidgets('offers clock in when the day has not started', (tester) async {
      await _pumpMyTime(tester);

      expect(find.byKey(const Key('my-attendance-clock-in')), findsOneWidget);
      expect(find.byKey(const Key('my-attendance-clock-out')), findsNothing);
      expect(find.text('Not clocked in today'), findsOneWidget);
      expect(find.byKey(const Key('my-attendance-today-total')), findsOneWidget);
    });

    testWidgets('shows the running total while clocked in', (tester) async {
      await _pumpMyTime(
        tester,
        attendance: FakeAttendanceRepository(
          now: _now,
          seed: [session(startedAt: DateTime(2026, 8, 18, 8), endedAt: null)],
        ),
      );

      expect(find.byKey(const Key('my-attendance-clock-out')), findsOneWidget);
      expect(find.text('Clocked in at 08:00'), findsOneWidget);
      // 08:00 to 09:30 on the fixed clock.
      expect(
        tester.widget<Text>(
          find.byKey(const Key('my-attendance-today-total')),
        ).data,
        '1h 30m',
      );
    });

    testWidgets('clocking in flips the card without a reload', (tester) async {
      final attendance = FakeAttendanceRepository(now: _now);
      await _pumpMyTime(tester, attendance: attendance);

      await tester.tap(find.byKey(const Key('my-attendance-clock-in')));
      await tester.pumpAndSettle();

      expect(attendance.sessions.single.isOpen, isTrue);
      expect(
        attendance.sessions.single.source.wire,
        'self',
        reason: 'this is the person clocking themselves in',
      );
      expect(find.byKey(const Key('my-attendance-clock-out')), findsOneWidget);
    });

    testWidgets('clocking out reports the day\'s total', (tester) async {
      final attendance = FakeAttendanceRepository(
        now: _now,
        seed: [session(startedAt: DateTime(2026, 8, 18, 8), endedAt: null)],
      );
      await _pumpMyTime(tester, attendance: attendance);

      await tester.tap(find.byKey(const Key('my-attendance-clock-out')));
      await tester.pumpAndSettle();

      expect(attendance.sessions.single.minutes, 90);
      expect(find.text('Clocked out — 1h 30m today.'), findsOneWidget);
    });

    testWidgets('a refused clock-in surfaces the reason', (tester) async {
      final attendance = FakeAttendanceRepository(now: _now);
      await _pumpMyTime(tester, attendance: attendance);
      attendance.failWith = AttendanceRepositoryException('Already clocked in');

      await tester.tap(find.byKey(const Key('my-attendance-clock-in')));
      await tester.pumpAndSettle();

      expect(find.text('Already clocked in'), findsOneWidget);
    });
  });

  group('the timesheet', () {
    testWidgets('lists recent days newest first, with today always present',
        (tester) async {
      await _pumpMyTime(
        tester,
        attendance: FakeAttendanceRepository(
          now: _now,
          seed: [
            session(
              id: 'mon',
              startedAt: DateTime(2026, 8, 17, 8),
              endedAt: DateTime(2026, 8, 17, 16),
            ),
          ],
        ),
      );

      expect(
        find.byKey(Key('timesheet-day-${DateTime(2026, 8, 18).toIso8601String()}')),
        findsOneWidget,
        reason: 'today shows even with no hours yet',
      );
      expect(
        find.byKey(Key('timesheet-day-${DateTime(2026, 8, 17).toIso8601String()}')),
        findsOneWidget,
      );
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('8h'), findsOneWidget);
    });

    testWidgets('shows each session and the break between them', (tester) async {
      await _pumpMyTime(
        tester,
        attendance: FakeAttendanceRepository(
          now: _now,
          seed: [
            session(
              id: 'morning',
              startedAt: DateTime(2026, 8, 17, 8),
              endedAt: DateTime(2026, 8, 17, 12),
            ),
            session(
              id: 'afternoon',
              startedAt: DateTime(2026, 8, 17, 13),
              endedAt: DateTime(2026, 8, 17, 17),
            ),
          ],
        ),
      );

      expect(
        find.textContaining('08:00 – 12:00 · 13:00 – 17:00'),
        findsOneWidget,
      );
      expect(find.textContaining('1h break'), findsOneWidget);
    });

    testWidgets('an overnight shift is labelled', (tester) async {
      await _pumpMyTime(
        tester,
        attendance: FakeAttendanceRepository(
          now: _now,
          seed: [
            session(
              startedAt: DateTime(2026, 8, 17, 22),
              endedAt: DateTime(2026, 8, 18, 6),
            ),
          ],
        ),
      );

      expect(find.text('overnight'), findsOneWidget);
    });
  });

  group('someone with no record', () {
    testWidgets('is told what to do instead of seeing an empty clock',
        (tester) async {
      await _pumpMyTime(
        tester,
        people: FakeEmployeeRepository(),
        session: FakeHrSessionRepository(session: ownerSession()),
      );

      expect(
        find.textContaining('do not have an employee record'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('my-attendance-clock-in')), findsNothing);
    });
  });

  group('failures', () {
    testWidgets('a load failure offers a retry', (tester) async {
      final attendance = FakeAttendanceRepository(
        now: _now,
        failWith: AttendanceRepositoryException('Could not load this timesheet.'),
      );
      await _pumpMyTime(tester, attendance: attendance);

      expect(find.text('Could not load this timesheet.'), findsOneWidget);

      attendance.failWith = null;
      await tester.tap(find.byKey(const Key('my-attendance-retry')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('my-attendance-clock-in')), findsOneWidget);
    });
  });
}
