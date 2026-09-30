/// How often a Personal Goal restarts. Periods are calendar-based in device
/// local time: weeks start Monday (ISO), months on the 1st, quarters on
/// Jan/Apr/Jul/Oct 1, years on Jan 1.
///
/// Pure Dart (no Flutter / services) so models and widgets can share it.
enum GoalRecurrence {
  none('none'),
  weekly('weekly'),
  monthly('monthly'),
  quarterly('quarterly'),
  yearly('yearly');

  const GoalRecurrence(this.wire);

  /// Value stored on the Ditto `personal_goals` document.
  final String wire;

  /// Unknown or missing values map to [none] so legacy documents keep working.
  static GoalRecurrence fromWire(Object? value) {
    final s = value?.toString().toLowerCase();
    for (final r in values) {
      if (r.wire == s) return r;
    }
    return none;
  }

  bool get isRecurring => this != none;

  /// "Monthly", "Weekly", ...; empty for [none].
  String get shortLabel => switch (this) {
    none => '',
    weekly => 'Weekly',
    monthly => 'Monthly',
    quarterly => 'Quarterly',
    yearly => 'Yearly',
  };

  /// Editor option label.
  String get optionLabel => switch (this) {
    none => "Doesn't repeat",
    weekly => 'Every week',
    monthly => 'Every month',
    quarterly => 'Every quarter',
    yearly => 'Every year',
  };

  /// Editor helper line explaining when progress restarts.
  String get restartExplanation => switch (this) {
    none => '',
    weekly =>
      'Progress restarts at 0 every Monday. Past weeks are kept in history.',
    monthly =>
      'Progress restarts at 0 on the 1st of each month. Past months are kept in history.',
    quarterly =>
      'Progress restarts at 0 at the start of each quarter. Past quarters are kept in history.',
    yearly =>
      'Progress restarts at 0 on 1 January. Past years are kept in history.',
  };

  /// Key of the period containing [now]: `2026-W40`, `2026-09`, `2026-Q3`,
  /// `2026`. Null for [none].
  String? periodKey(DateTime now) {
    switch (this) {
      case none:
        return null;
      case weekly:
        final (year, week) = _isoWeek(now);
        return '$year-W${week.toString().padLeft(2, '0')}';
      case monthly:
        return '${now.year}-${now.month.toString().padLeft(2, '0')}';
      case quarterly:
        return '${now.year}-Q${(now.month - 1) ~/ 3 + 1}';
      case yearly:
        return '${now.year}';
    }
  }

  /// Local midnight at which the period containing [now] ends. Null for [none].
  DateTime? nextResetAt(DateTime now) {
    switch (this) {
      case none:
        return null;
      case weekly:
        return DateTime(now.year, now.month, now.day - (now.weekday - 1) + 7);
      case monthly:
        return DateTime(now.year, now.month + 1, 1);
      case quarterly:
        return DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 4, 1);
      case yearly:
        return DateTime(now.year + 1, 1, 1);
    }
  }

  /// "restarts tomorrow", "restarts in 12 days", "restarts 1 Oct".
  String restartLabel(DateTime now) {
    final reset = nextResetAt(now);
    if (reset == null) return '';
    final today = DateTime.utc(now.year, now.month, now.day);
    final days = DateTime.utc(
      reset.year,
      reset.month,
      reset.day,
    ).difference(today).inDays;
    if (days <= 1) return 'restarts tomorrow';
    if (days <= 14) return 'restarts in $days days';
    return 'restarts ${_dayMonth(reset)}';
  }

  /// "restarts 1 Oct".
  String restartDateLabel(DateTime now) {
    final reset = nextResetAt(now);
    if (reset == null) return '';
    return 'restarts ${_dayMonth(reset)}';
  }
}

/// Short human name for a period key, used in "Reached for …" and history:
/// `2026-09` → "September", `2026-W40` → "week of 28 Sep",
/// `2026-Q3` → "Q3 2026", `2026` → "2026". Unknown keys are returned as-is.
///
/// Parses the key itself (not the goal's current recurrence) because history
/// entries outlive a change of frequency.
String goalPeriodName(String key) {
  final week = RegExp(r'^(\d{4})-W(\d{2})$').firstMatch(key);
  if (week != null) {
    final monday = _isoWeekMonday(
      int.parse(week.group(1)!),
      int.parse(week.group(2)!),
    );
    return 'week of ${_dayMonth(monday)}';
  }
  final month = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(key);
  if (month != null) {
    final m = int.parse(month.group(2)!);
    if (m >= 1 && m <= 12) return _monthNames[m - 1];
  }
  final quarter = RegExp(r'^(\d{4})-Q([1-4])$').firstMatch(key);
  if (quarter != null) return 'Q${quarter.group(2)} ${quarter.group(1)}';
  return key;
}

// Hand-rolled rather than intl's DateFormat: the copy around these labels is
// English, and DateFormat throws for app locales without initialised date
// data.
const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June', //
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// "1 Oct".
String _dayMonth(DateTime d) =>
    '${d.day} ${_monthNames[d.month - 1].substring(0, 3)}';

/// ISO-8601 (year, week) for [d]; the year can differ from [d.year] around
/// New Year.
(int, int) _isoWeek(DateTime d) {
  // Thursday of this ISO week decides the ISO year. UTC avoids DST drift.
  final date = DateTime.utc(d.year, d.month, d.day);
  final thursday = date.add(Duration(days: 4 - d.weekday));
  final jan1 = DateTime.utc(thursday.year, 1, 1);
  final week = thursday.difference(jan1).inDays ~/ 7 + 1;
  return (thursday.year, week);
}

/// Local Monday starting ISO [week] of [year] (week 1 contains 4 January).
DateTime _isoWeekMonday(int year, int week) {
  final jan4 = DateTime(year, 1, 4);
  return DateTime(year, 1, 4 - (jan4.weekday - 1) + (week - 1) * 7);
}
