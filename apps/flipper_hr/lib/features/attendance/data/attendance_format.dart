/// Clock and duration formatting for the attendance screens.
///
/// Hand-rolled for the same reason as `money_format.dart`: `intl` is not a
/// declared dependency of this app, only a transitive one.
library;

/// `135` → `2h 15m`, `45` → `45m`, `0` → `0m`, `120` → `2h`.
String formatWorkedMinutes(int minutes) {
  if (minutes <= 0) return '0m';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  if (hours == 0) return '${rest}m';
  if (rest == 0) return '${hours}h';
  return '${hours}h ${rest}m';
}

/// Decimal hours for a payroll column: `135` → `2.25`.
///
/// Two decimal places, because a quarter hour is not expressible in one and
/// rounding it away would lose money over a month.
String formatDecimalHours(int minutes) =>
    (minutes <= 0 ? 0 : minutes / 60).toStringAsFixed(2);

/// Local wall-clock time, 24-hour: `08:07`.
///
/// 24-hour because a timesheet is read in columns, where am/pm suffixes make
/// times of different widths and stop lining up.
String formatClockTime(DateTime at) {
  final local = at.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// `Mon 17 Aug` — weekday included because a timesheet is scanned for weekends.
String formatDayLabel(DateTime date) {
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${_weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
}
