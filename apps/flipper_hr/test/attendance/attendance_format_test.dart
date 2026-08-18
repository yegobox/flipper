import 'package:flipper_hr/features/attendance/data/attendance_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatWorkedMinutes', () {
    test('drops the hours when there are none', () {
      expect(formatWorkedMinutes(45), '45m');
    });

    test('drops the minutes when they are zero', () {
      expect(formatWorkedMinutes(120), '2h');
    });

    test('shows both otherwise', () {
      expect(formatWorkedMinutes(135), '2h 15m');
      expect(formatWorkedMinutes(61), '1h 1m');
    });

    test('nothing worked reads as 0m, not blank', () {
      expect(formatWorkedMinutes(0), '0m');
      expect(formatWorkedMinutes(-5), '0m');
    });

    test('a long shift stays in hours rather than rolling into days', () {
      expect(formatWorkedMinutes(1500), '25h');
    });
  });

  group('formatDecimalHours', () {
    test('keeps a quarter hour, which one decimal place would lose', () {
      expect(formatDecimalHours(135), '2.25');
      expect(formatDecimalHours(105), '1.75');
    });

    test('whole hours still carry two places, so a column lines up', () {
      expect(formatDecimalHours(120), '2.00');
    });

    test('nothing worked is 0.00', () {
      expect(formatDecimalHours(0), '0.00');
      expect(formatDecimalHours(-10), '0.00');
    });
  });

  group('formatClockTime', () {
    test('is 24-hour and zero-padded', () {
      expect(formatClockTime(DateTime(2026, 8, 18, 8, 7)), '08:07');
      expect(formatClockTime(DateTime(2026, 8, 18, 17, 45)), '17:45');
      expect(formatClockTime(DateTime(2026, 8, 18, 0, 5)), '00:05');
    });
  });

  group('formatDayLabel', () {
    test('leads with the weekday, which is what a timesheet is scanned for', () {
      // 18 Aug 2026 is a Tuesday.
      expect(formatDayLabel(DateTime(2026, 8, 18)), 'Tue 18 Aug');
      // 1 Jan 2026 is a Thursday.
      expect(formatDayLabel(DateTime(2026, 1, 1)), 'Thu 1 Jan');
      // 20 Dec 2026 is a Sunday — the last weekday index.
      expect(formatDayLabel(DateTime(2026, 12, 20)), 'Sun 20 Dec');
    });
  });
}
