import 'package:flipper_hr/features/attendance/attendance_page.dart';
import 'package:flipper_hr/features/attendance/data/attendance_providers.dart';
import 'package:flipper_hr/features/attendance/data/attendance_repository.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_attendance_repository.dart';
import '../helpers/fake_employee_repository.dart';

/// Tuesday 18 Aug 2026, 09:30 — a fixed clock, so elapsed figures are stable.
final _now = DateTime(2026, 8, 18, 9, 30);

Future<void> _pumpBoard(
  WidgetTester tester, {
  FakeAttendanceRepository? attendance,
  FakeEmployeeRepository? people,
  Size size = const Size(1400, 1000),
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
          people ??
              FakeEmployeeRepository(
                seed: [employee(id: 'e-1', firstName: 'Aline')],
              ),
        ),
        hrClockProvider.overrideWithValue(() => _now),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: AttendancePage(
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
  group('the board', () {
    testWidgets('lists everyone on the roster, including those not in',
        (tester) async {
      // The point of driving rows from the roster: "who is missing?" is the
      // question a manager opens this for.
      await _pumpBoard(
        tester,
        people: FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1', firstName: 'Aline'),
            employee(id: 'e-2', firstName: 'Bosco'),
          ],
        ),
      );

      expect(find.byKey(const Key('attendance-row-e-1')), findsOneWidget);
      expect(find.byKey(const Key('attendance-row-e-2')), findsOneWidget);
      expect(find.text('Not in'), findsNWidgets(2));
      expect(find.text('Tue 18 Aug · Kigali Main'), findsOneWidget);
    });

    testWidgets('leaves terminated people off, they have no hours to record',
        (tester) async {
      await _pumpBoard(
        tester,
        people: FakeEmployeeRepository(
          seed: [
            employee(id: 'e-1'),
            employee(
              id: 'e-2',
              status: EmploymentStatus.terminated,
              endDate: DateTime(2026, 7, 1),
            ),
          ],
        ),
      );

      expect(find.byKey(const Key('attendance-row-e-1')), findsOneWidget);
      expect(find.byKey(const Key('attendance-row-e-2')), findsNothing);
    });

    testWidgets('shows an open session as clocked in, with the running total',
        (tester) async {
      await _pumpBoard(
        tester,
        attendance: FakeAttendanceRepository(
          now: _now,
          seed: [session(startedAt: DateTime(2026, 8, 18, 8), endedAt: null)],
        ),
      );

      expect(find.text('Clocked in'), findsOneWidget);
      // 08:00 to 09:30.
      expect(find.textContaining('1h 30m'), findsWidgets);
      expect(find.byKey(const Key('clock-out-e-1')), findsOneWidget);
      expect(find.byKey(const Key('clock-in-e-1')), findsNothing);
    });

    testWidgets('shows a finished day with both punches', (tester) async {
      await _pumpBoard(
        tester,
        attendance: FakeAttendanceRepository(
          now: _now,
          seed: [
            session(
              startedAt: DateTime(2026, 8, 18, 8),
              endedAt: DateTime(2026, 8, 18, 9),
            ),
          ],
        ),
      );

      expect(find.text('Clocked out'), findsOneWidget);
      expect(find.textContaining('In 08:00'), findsOneWidget);
      expect(find.textContaining('out 09:00'), findsOneWidget);
      expect(find.byKey(const Key('clock-in-e-1')), findsOneWidget);
    });

    testWidgets('an empty roster explains what to do first', (tester) async {
      await _pumpBoard(tester, people: FakeEmployeeRepository());

      expect(find.textContaining('No one is on this branch yet'), findsOneWidget);
    });
  });

  group('recording hours', () {
    testWidgets('clocking someone in marks them present', (tester) async {
      final attendance = FakeAttendanceRepository(now: _now);
      await _pumpBoard(tester, attendance: attendance);

      await tester.tap(find.byKey(const Key('clock-in-e-1')));
      await tester.pumpAndSettle();

      expect(attendance.sessions.single.employeeId, 'e-1');
      expect(attendance.sessions.single.isOpen, isTrue);
      expect(find.text('Clocked in'), findsOneWidget);
      expect(find.text('Aline Uwase is clocked in.'), findsOneWidget);
    });

    testWidgets('a manager entry is recorded as such, not as self-service',
        (tester) async {
      final attendance = FakeAttendanceRepository(now: _now);
      await _pumpBoard(tester, attendance: attendance);

      await tester.tap(find.byKey(const Key('clock-in-e-1')));
      await tester.pumpAndSettle();

      expect(attendance.sessions.single.source.wire, 'manager');
    });

    testWidgets('clocking someone out closes their session', (tester) async {
      final attendance = FakeAttendanceRepository(
        now: _now,
        seed: [session(startedAt: DateTime(2026, 8, 18, 8), endedAt: null)],
      );
      await _pumpBoard(tester, attendance: attendance);

      await tester.tap(find.byKey(const Key('clock-out-e-1')));
      await tester.pumpAndSettle();

      expect(attendance.sessions.single.isOpen, isFalse);
      expect(attendance.sessions.single.minutes, 90);
      expect(find.text('Clocked out'), findsOneWidget);
    });

    testWidgets('a refused clock-in reports why and records nothing',
        (tester) async {
      final attendance = FakeAttendanceRepository(now: _now);
      await _pumpBoard(tester, attendance: attendance);
      attendance.failWith = AttendanceRepositoryException('Already clocked in');

      await tester.tap(find.byKey(const Key('clock-in-e-1')));
      await tester.pumpAndSettle();

      expect(find.text('Already clocked in'), findsOneWidget);
      expect(attendance.sessions, isEmpty);
    });
  });

  group('other days', () {
    testWidgets('a load failure offers a retry', (tester) async {
      final attendance = FakeAttendanceRepository(
        now: _now,
        failWith: AttendanceRepositoryException('Could not load attendance.'),
      );
      await _pumpBoard(tester, attendance: attendance);

      expect(find.text('Could not load attendance.'), findsOneWidget);

      attendance.failWith = null;
      await tester.tap(find.byKey(const Key('attendance-retry')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('attendance-row-e-1')), findsOneWidget);
    });

    testWidgets('today shows no "Today" shortcut, since it is already today',
        (tester) async {
      await _pumpBoard(tester);
      expect(find.byKey(const Key('attendance-today')), findsNothing);
      expect(find.byKey(const Key('attendance-pick-date')), findsOneWidget);
    });
  });
}
