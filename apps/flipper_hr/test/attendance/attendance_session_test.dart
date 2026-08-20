import 'package:flipper_hr/features/attendance/data/attendance_session.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_attendance_repository.dart';

void main() {
  group('isOpen', () {
    test('a session with no clock-out is open', () {
      expect(session(endedAt: null).isOpen, isTrue);
      expect(
        session(
          startedAt: DateTime(2026, 8, 18, 8),
          endedAt: DateTime(2026, 8, 18, 17),
        ).isOpen,
        isFalse,
      );
    });
  });

  group('minutesAsOf', () {
    test('a closed session reports its stored minutes', () {
      final s = session(
        startedAt: DateTime(2026, 8, 18, 8),
        endedAt: DateTime(2026, 8, 18, 16, 30),
      );
      expect(s.minutesAsOf(DateTime(2026, 8, 19)), 510);
    });

    test('an open session counts up to the reference time', () {
      final s = session(startedAt: DateTime(2026, 8, 18, 8), endedAt: null);
      expect(s.minutesAsOf(DateTime(2026, 8, 18, 10, 15)), 135);
    });

    test('the stored figure wins over recomputing, so a correction holds', () {
      // A manager corrected the duration without moving the timestamps; payroll
      // reads the stored number, so this must too.
      final s = session(
        startedAt: DateTime(2026, 8, 18, 8),
        endedAt: DateTime(2026, 8, 18, 16),
        minutes: 420,
      );
      expect(s.minutesAsOf(DateTime(2026, 8, 19)), 420);
    });

    test('falls back to the timestamps when minutes is missing', () {
      final s = AttendanceSession(
        employeeId: 'e-1',
        workDate: DateTime(2026, 8, 18),
        startedAt: DateTime(2026, 8, 18, 8),
        endedAt: DateTime(2026, 8, 18, 12),
      );
      expect(s.minutesAsOf(DateTime(2026, 8, 19)), 240);
    });

    test('a clock that went backwards reads as zero, never as credit', () {
      final s = session(startedAt: DateTime(2026, 8, 18, 10), endedAt: null);
      expect(s.minutesAsOf(DateTime(2026, 8, 18, 9)), 0);

      final negative = session(
        startedAt: DateTime(2026, 8, 18, 10),
        endedAt: DateTime(2026, 8, 18, 12),
        minutes: -30,
      );
      expect(negative.minutesAsOf(DateTime(2026, 8, 19)), 0);
    });
  });

  group('isOvernight', () {
    test('true when the clock-out lands on another date', () {
      expect(
        session(
          startedAt: DateTime(2026, 8, 18, 22),
          endedAt: DateTime(2026, 8, 19, 6),
        ).isOvernight,
        isTrue,
      );
    });

    test('false for a same-day shift, and for one still open', () {
      expect(
        session(
          startedAt: DateTime(2026, 8, 18, 8),
          endedAt: DateTime(2026, 8, 18, 17),
        ).isOvernight,
        isFalse,
      );
      expect(session(endedAt: null).isOvernight, isFalse);
    });
  });

  group('AttendanceSource', () {
    test('round-trips its wire value', () {
      for (final s in AttendanceSource.values) {
        expect(AttendanceSource.fromWire(s.wire), s);
      }
    });

    test('unknown and null fall back to self', () {
      expect(AttendanceSource.fromWire('kiosk'), AttendanceSource.self);
      expect(AttendanceSource.fromWire(null), AttendanceSource.self);
    });
  });

  group('copyWith', () {
    test('clear flags remove values a plain null would keep', () {
      final closed = session(
        startedAt: DateTime(2026, 8, 18, 8),
        endedAt: DateTime(2026, 8, 18, 17),
      );

      expect(closed.copyWith(endedAt: null).endedAt, isNotNull);
      expect(closed.copyWith(clearEndedAt: true).endedAt, isNull);
      expect(closed.copyWith(clearMinutes: true).minutes, isNull);
    });
  });

  group('equality', () {
    test('compares by value', () {
      expect(session(), session());
      expect(session().hashCode, session().hashCode);
      expect(session(id: 'a') == session(id: 'b'), isFalse);
    });
  });
}
