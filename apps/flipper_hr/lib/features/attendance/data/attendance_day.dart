/// One person's day, derived from their sessions.
///
/// The table stores punches; every screen wants "who is in, and how long have
/// they worked?". That reduction lives here as a pure function so the totals the
/// board shows and the totals payroll will read come from one rule.
library;

import 'package:flipper_hr/features/attendance/data/attendance_session.dart';

/// Where someone stands right now.
enum AttendanceState {
  /// No session today.
  absent('Not in'),

  /// Clocked in and still working.
  clockedIn('Clocked in'),

  /// Worked today and clocked out.
  clockedOut('Clocked out');

  const AttendanceState(this.label);

  final String label;
}

/// One employee's sessions for one work date, with the day's totals.
class AttendanceDay {
  /// Sorting happens here rather than at each call site: `sessions.first` being
  /// the day's opening punch is an invariant the whole class reads from
  /// ([firstIn], the session list a timesheet renders), and a caller that fed in
  /// a newest-first list — which is how the timesheet query returns rows — would
  /// otherwise silently print the day backwards.
  AttendanceDay({
    required this.employeeId,
    required this.workDate,
    required List<AttendanceSession> sessions,
    required this.asOf,
  }) : sessions = List.unmodifiable(
         [...sessions]..sort((a, b) => a.startedAt.compareTo(b.startedAt)),
       );

  /// Groups [sessions] by employee for a single day.
  ///
  /// [asOf] is injected rather than read from the clock so an open session's
  /// running total is stable within a build and testable. Ordering is the
  /// constructor's job.
  static Map<String, AttendanceDay> groupByEmployee({
    required List<AttendanceSession> sessions,
    required DateTime workDate,
    required DateTime asOf,
  }) {
    final byEmployee = <String, List<AttendanceSession>>{};
    for (final s in sessions) {
      if (!isSameDate(s.workDate, workDate)) continue;
      byEmployee.putIfAbsent(s.employeeId, () => []).add(s);
    }
    return {
      for (final entry in byEmployee.entries)
        entry.key: AttendanceDay(
          employeeId: entry.key,
          workDate: workDate,
          sessions: entry.value,
          asOf: asOf,
        ),
    };
  }

  /// Every distinct work date present in [sessions], newest first. Drives the
  /// timesheet's day grouping.
  static List<DateTime> datesOf(List<AttendanceSession> sessions) {
    final seen = <String, DateTime>{};
    for (final s in sessions) {
      final d = dateOnly(s.workDate);
      seen['${d.year}-${d.month}-${d.day}'] = d;
    }
    final dates = seen.values.toList()..sort((a, b) => b.compareTo(a));
    return dates;
  }

  final String employeeId;
  final DateTime workDate;
  final List<AttendanceSession> sessions;

  /// The moment the running totals were taken.
  final DateTime asOf;

  /// The still-open session, if the person is clocked in.
  AttendanceSession? get openSession {
    for (final s in sessions) {
      if (s.isOpen) return s;
    }
    return null;
  }

  bool get isClockedIn => openSession != null;

  AttendanceState get state {
    if (sessions.isEmpty) return AttendanceState.absent;
    return isClockedIn ? AttendanceState.clockedIn : AttendanceState.clockedOut;
  }

  /// First clock-in of the day.
  DateTime? get firstIn => sessions.isEmpty ? null : sessions.first.startedAt;

  /// Last clock-out, or null while a session is still open.
  DateTime? get lastOut {
    if (sessions.isEmpty || isClockedIn) return null;
    DateTime? latest;
    for (final s in sessions) {
      final end = s.endedAt;
      if (end == null) continue;
      if (latest == null || end.isAfter(latest)) latest = end;
    }
    return latest;
  }

  /// Minutes worked today, counting an open session up to [asOf].
  int get workedMinutes {
    var total = 0;
    for (final s in sessions) {
      total += s.minutesAsOf(asOf);
    }
    return total;
  }

  /// Time between the first punch and the last, minus time worked — the gaps
  /// someone was clocked out mid-day. Null when the day is still open, since the
  /// span has no end yet.
  int? get breakMinutes {
    final start = firstIn;
    final end = lastOut;
    if (start == null || end == null) return null;
    final span = end.difference(start).inMinutes;
    final gap = span - workedMinutes;
    return gap < 0 ? 0 : gap;
  }

  bool get hasOvernightSession => sessions.any((s) => s.isOvernight);
}

/// Total minutes across every session, open ones counted up to [asOf].
int totalMinutes({
  required List<AttendanceSession> sessions,
  required DateTime asOf,
}) {
  var total = 0;
  for (final s in sessions) {
    total += s.minutesAsOf(asOf);
  }
  return total;
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool isSameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
