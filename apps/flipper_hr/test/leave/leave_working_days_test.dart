import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('workingDaysBetween', () {
    test('counts a Monday-to-Friday week as five days', () {
      // 7 Sep 2026 is a Monday.
      expect(
        workingDaysBetween(DateTime(2026, 9, 7), DateTime(2026, 9, 11)),
        5,
      );
    });

    test('skips the weekend inside a two-week span', () {
      expect(
        workingDaysBetween(DateTime(2026, 9, 7), DateTime(2026, 9, 18)),
        10,
      );
    });

    test('counts a single weekday as one day', () {
      expect(
        workingDaysBetween(DateTime(2026, 9, 9), DateTime(2026, 9, 9)),
        1,
      );
    });

    test('a weekend-only span costs nothing', () {
      // Saturday to Sunday.
      expect(
        workingDaysBetween(DateTime(2026, 9, 12), DateTime(2026, 9, 13)),
        0,
      );
    });

    test('an inverted range is zero, never negative', () {
      expect(
        workingDaysBetween(DateTime(2026, 9, 11), DateTime(2026, 9, 7)),
        0,
      );
    });

    test('ignores the time of day on either end', () {
      expect(
        workingDaysBetween(
          DateTime(2026, 9, 7, 23, 59),
          DateTime(2026, 9, 11, 0, 1),
        ),
        5,
      );
    });
  });

  group('calendarDaysBetween', () {
    test('counts weekends too', () {
      expect(
        calendarDaysBetween(DateTime(2026, 9, 7), DateTime(2026, 9, 13)),
        7,
      );
    });

    test('twelve weeks of maternity leave is 84 days', () {
      final start = DateTime(2026, 3, 2);
      final end = start.add(const Duration(days: 83));
      expect(calendarDaysBetween(start, end), 84);
    });

    test('is inclusive of both ends', () {
      expect(
        calendarDaysBetween(DateTime(2026, 9, 7), DateTime(2026, 9, 7)),
        1,
      );
    });

    test('spans a month and a year boundary', () {
      expect(
        calendarDaysBetween(DateTime(2026, 12, 28), DateTime(2027, 1, 3)),
        7,
      );
    });

    test('counts the leap day in a leap year', () {
      expect(
        calendarDaysBetween(DateTime(2028, 2, 27), DateTime(2028, 3, 1)),
        4, // 27, 28, 29 Feb, 1 Mar
      );
    });
  });

  group('leaveDaysFor', () {
    test('annual leave is charged in working days', () {
      expect(
        leaveDaysFor(
          type: LeaveType.annual,
          start: DateTime(2026, 9, 7),
          end: DateTime(2026, 9, 13),
        ),
        5,
      );
    });

    test('maternity leave is charged in calendar days', () {
      expect(
        leaveDaysFor(
          type: LeaveType.maternity,
          start: DateTime(2026, 9, 7),
          end: DateTime(2026, 9, 13),
        ),
        7,
      );
    });
  });

  group('isWeekend', () {
    test('is true only for Saturday and Sunday', () {
      expect(isWeekend(DateTime(2026, 9, 11)), isFalse); // Friday
      expect(isWeekend(DateTime(2026, 9, 12)), isTrue); // Saturday
      expect(isWeekend(DateTime(2026, 9, 13)), isTrue); // Sunday
      expect(isWeekend(DateTime(2026, 9, 14)), isFalse); // Monday
    });
  });

  group('formatLeaveDays', () {
    test('drops the decimal for whole days and singularises one', () {
      expect(formatLeaveDays(1), '1 day');
      expect(formatLeaveDays(3), '3 days');
      expect(formatLeaveDays(0), '0 days');
    });

    test('keeps one decimal for a half day', () {
      expect(formatLeaveDays(1.5), '1.5 days');
    });
  });
}
