import 'package:flipper_hr/features/attendance/data/attendance_day.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_attendance_repository.dart';

void main() {
  final today = DateTime(2026, 8, 18);
  final noon = DateTime(2026, 8, 18, 12);

  group('groupByEmployee', () {
    test('keys by employee and keeps only the requested day', () {
      final days = AttendanceDay.groupByEmployee(
        sessions: [
          session(id: 'a', employeeId: 'e-1'),
          session(id: 'b', employeeId: 'e-2'),
          session(
            id: 'c',
            employeeId: 'e-1',
            startedAt: DateTime(2026, 8, 17, 8),
          ),
        ],
        workDate: today,
        asOf: noon,
      );

      expect(days.keys.toSet(), {'e-1', 'e-2'});
      expect(days['e-1']!.sessions.length, 1, reason: 'yesterday excluded');
    });

    test('orders a day\'s sessions oldest first', () {
      final days = AttendanceDay.groupByEmployee(
        sessions: [
          session(
            id: 'afternoon',
            startedAt: DateTime(2026, 8, 18, 13),
            endedAt: DateTime(2026, 8, 18, 17),
          ),
          session(
            id: 'morning',
            startedAt: DateTime(2026, 8, 18, 8),
            endedAt: DateTime(2026, 8, 18, 12),
          ),
        ],
        workDate: today,
        asOf: DateTime(2026, 8, 18, 18),
      );

      expect(
        [for (final s in days['e-1']!.sessions) s.id],
        ['morning', 'afternoon'],
      );
    });

    test('an employee with no sessions is simply absent from the map', () {
      final days = AttendanceDay.groupByEmployee(
        sessions: const [],
        workDate: today,
        asOf: noon,
      );
      expect(days, isEmpty);
    });
  });

  group('state', () {
    AttendanceDay dayOf(List<dynamic> sessions, {DateTime? asOf}) =>
        AttendanceDay(
          employeeId: 'e-1',
          workDate: today,
          sessions: [...sessions.cast()],
          asOf: asOf ?? noon,
        );

    test('no sessions reads as absent', () {
      expect(dayOf(const []).state, AttendanceState.absent);
    });

    test('an open session reads as clocked in', () {
      final day = dayOf([session(startedAt: DateTime(2026, 8, 18, 8))]);
      expect(day.state, AttendanceState.clockedIn);
      expect(day.isClockedIn, isTrue);
      expect(day.openSession, isNotNull);
    });

    test('only closed sessions read as clocked out', () {
      final day = dayOf([
        session(
          startedAt: DateTime(2026, 8, 18, 8),
          endedAt: DateTime(2026, 8, 18, 11),
        ),
      ]);
      expect(day.state, AttendanceState.clockedOut);
      expect(day.openSession, isNull);
    });
  });

  group('the day\'s figures', () {
    test('sums several sessions, and counts the open one live', () {
      final day = AttendanceDay(
        employeeId: 'e-1',
        workDate: today,
        sessions: [
          session(
            id: 'morning',
            startedAt: DateTime(2026, 8, 18, 8),
            endedAt: DateTime(2026, 8, 18, 12),
          ),
          session(id: 'afternoon', startedAt: DateTime(2026, 8, 18, 13)),
        ],
        asOf: DateTime(2026, 8, 18, 14, 30),
      );

      // 4h closed + 1h30 still running.
      expect(day.workedMinutes, 330);
      expect(day.firstIn, DateTime(2026, 8, 18, 8));
      expect(day.lastOut, isNull, reason: 'still clocked in');
    });

    test('lastOut is the latest clock-out once the day is closed', () {
      final day = AttendanceDay(
        employeeId: 'e-1',
        workDate: today,
        sessions: [
          session(
            id: 'afternoon',
            startedAt: DateTime(2026, 8, 18, 13),
            endedAt: DateTime(2026, 8, 18, 17),
          ),
          session(
            id: 'morning',
            startedAt: DateTime(2026, 8, 18, 8),
            endedAt: DateTime(2026, 8, 18, 12),
          ),
        ],
        asOf: DateTime(2026, 8, 18, 18),
      );

      expect(day.lastOut, DateTime(2026, 8, 18, 17));
      expect(day.workedMinutes, 480);
    });

    test('break time is the gap between the first punch and the last', () {
      final day = AttendanceDay(
        employeeId: 'e-1',
        workDate: today,
        sessions: [
          session(
            id: 'morning',
            startedAt: DateTime(2026, 8, 18, 8),
            endedAt: DateTime(2026, 8, 18, 12),
          ),
          session(
            id: 'afternoon',
            startedAt: DateTime(2026, 8, 18, 13),
            endedAt: DateTime(2026, 8, 18, 17),
          ),
        ],
        asOf: DateTime(2026, 8, 18, 18),
      );

      expect(day.breakMinutes, 60);
    });

    test('break time is null while a session is open', () {
      final day = AttendanceDay(
        employeeId: 'e-1',
        workDate: today,
        sessions: [session(startedAt: DateTime(2026, 8, 18, 8))],
        asOf: noon,
      );
      expect(day.breakMinutes, isNull);
    });

    test('an overnight session is flagged, since a 14-hour day looks wrong', () {
      final day = AttendanceDay(
        employeeId: 'e-1',
        workDate: today,
        sessions: [
          session(
            startedAt: DateTime(2026, 8, 18, 22),
            endedAt: DateTime(2026, 8, 19, 6),
          ),
        ],
        asOf: DateTime(2026, 8, 19, 7),
      );

      expect(day.hasOvernightSession, isTrue);
      expect(day.workedMinutes, 480);
    });
  });

  group('datesOf', () {
    test('is distinct and newest first', () {
      final dates = AttendanceDay.datesOf([
        session(id: 'a', startedAt: DateTime(2026, 8, 16, 8)),
        session(id: 'b', startedAt: DateTime(2026, 8, 18, 8)),
        session(id: 'c', startedAt: DateTime(2026, 8, 18, 13)),
        session(id: 'd', startedAt: DateTime(2026, 8, 17, 8)),
      ]);

      expect(dates, [
        DateTime(2026, 8, 18),
        DateTime(2026, 8, 17),
        DateTime(2026, 8, 16),
      ]);
    });
  });

  group('totalMinutes', () {
    test('spans days and counts open sessions to the reference time', () {
      final total = totalMinutes(
        sessions: [
          session(
            id: 'mon',
            startedAt: DateTime(2026, 8, 17, 8),
            endedAt: DateTime(2026, 8, 17, 16),
          ),
          session(id: 'tue', startedAt: DateTime(2026, 8, 18, 8)),
        ],
        asOf: DateTime(2026, 8, 18, 9, 30),
      );

      expect(total, 480 + 90);
    });

    test('no sessions is zero, not an error', () {
      expect(totalMinutes(sessions: const [], asOf: noon), 0);
    });
  });
}
