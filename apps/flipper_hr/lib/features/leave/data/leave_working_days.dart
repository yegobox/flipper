/// How many days a leave request consumes.
///
/// The unit differs by leave type: annual leave is spent in working days, while
/// maternity leave runs in calendar days (see [LeaveType.countsCalendarDays]).
/// Both are counted here so `hr_leave_requests.days` is written by one rule, and
/// the balance and the stored figure can never disagree.
///
/// Public holidays are NOT deducted. Rwanda's calendar includes moveable dates
/// (Eid, and the odd one-off national day), so a hardcoded list would be wrong
/// within a year and silently overcharge someone's balance. Until there is a
/// holidays table to read, a holiday inside a leave period counts as a leave day
/// — which is the conservative direction: it can be corrected by shortening the
/// request, whereas an under-count silently grants extra days.
library;

import 'package:flipper_hr/features/leave/data/leave_type.dart';

/// Saturday and Sunday. `DateTime.weekday` is 1 = Monday … 7 = Sunday.
bool isWeekend(DateTime day) =>
    day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

/// Inclusive day count from [start] to [end], weekends included.
///
/// Returns 0 when the range is inverted, rather than a negative count: an
/// inverted range is a validation failure, and validation reports it — this
/// function must not also produce a number that could be stored.
int calendarDaysBetween(DateTime start, DateTime end) {
  final from = _dateOnly(start);
  final to = _dateOnly(end);
  if (to.isBefore(from)) return 0;
  // Not `to.difference(from).inDays`: across a DST boundary that is off by an
  // hour and floors to the wrong day. Stepping by date is exact.
  var count = 0;
  var cursor = from;
  while (!cursor.isAfter(to)) {
    count++;
    cursor = _nextDay(cursor);
  }
  return count;
}

/// Inclusive Monday–Friday count from [start] to [end].
int workingDaysBetween(DateTime start, DateTime end) {
  final from = _dateOnly(start);
  final to = _dateOnly(end);
  if (to.isBefore(from)) return 0;
  var count = 0;
  var cursor = from;
  while (!cursor.isAfter(to)) {
    if (!isWeekend(cursor)) count++;
    cursor = _nextDay(cursor);
  }
  return count;
}

/// The days [type] charges for the period, in that type's own unit.
double leaveDaysFor({
  required LeaveType type,
  required DateTime start,
  required DateTime end,
}) {
  final days = type.countsCalendarDays
      ? calendarDaysBetween(start, end)
      : workingDaysBetween(start, end);
  return days.toDouble();
}

/// `1 day`, `3 days`, `1.5 days` — the trailing `.0` dropped, since whole days
/// are the normal case and `3.0 days` reads like a measurement.
String formatLeaveDays(double value) {
  final text = value == value.roundToDouble()
      ? value.round().toString()
      : value.toStringAsFixed(1);
  return '$text ${value == 1 ? 'day' : 'days'}';
}

/// Adds a day by calendar date, so a DST shift cannot land on the same day twice
/// or skip one.
DateTime _nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
