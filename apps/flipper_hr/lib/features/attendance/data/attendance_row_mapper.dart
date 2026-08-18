import 'package:flipper_hr/features/attendance/data/attendance_session.dart';

/// Maps `hr_attendance_sessions` rows to and from [AttendanceSession].
///
/// Same defensive reading as `employee_row_mapper.dart`: PostgREST returns
/// `integer` as int but `numeric` as int, double or String depending on the
/// value, and `date` as `YYYY-MM-DD` while `timestamptz` is a full ISO string.
///
/// Column names must match `supabase/migrations/0005_hr_attendance.sql`.
class AttendanceRowMapper {
  AttendanceRowMapper._();

  static AttendanceSession fromRow(Map<String, dynamic> row) {
    return AttendanceSession(
      id: _str(row['id']),
      employeeId: _str(row['employee_id']),
      businessId: _str(row['business_id']),
      branchId: _str(row['branch_id']),
      // A row with no work_date should still render; the epoch reads as
      // obviously-unset rather than hiding the whole day.
      workDate: parseDate(row['work_date']) ?? DateTime.utc(1970),
      startedAt: parseTimestamp(row['started_at']) ?? DateTime.utc(1970),
      endedAt: parseTimestamp(row['ended_at']),
      minutes: parseMinutes(row['minutes']),
      source: AttendanceSource.fromWire(row['source'] as String?),
      note: _str(row['note']),
      createdAt: parseTimestamp(row['created_at']),
      updatedAt: parseTimestamp(row['updated_at']),
    );
  }

  /// Row for an INSERT.
  ///
  /// Omits `id`, `business_id`, `branch_id`, `work_date` and `minutes`: Postgres
  /// owns the id, and the trigger derives the rest from the employee's record so
  /// a client cannot attribute time to a branch it does not manage. `started_at`
  /// is omitted too when [session] has no explicit start — the column defaults to
  /// `now()`, which keeps a wrong device clock out of the timesheet.
  static Map<String, dynamic> toInsertRow(
    AttendanceSession session, {
    bool useServerStart = true,
  }) {
    return {
      'employee_id': session.employeeId,
      if (!useServerStart) 'started_at': session.startedAt.toUtc().toIso8601String(),
      if (session.endedAt != null)
        'ended_at': session.endedAt!.toUtc().toIso8601String(),
      'source': session.source.wire,
      'note': session.note.trim(),
    };
  }

  /// Row for a correction by whoever manages the roster: the timestamps and the
  /// note, nothing derived. `minutes` is left to the trigger to recompute, so a
  /// corrected time cannot disagree with the stored duration.
  static Map<String, dynamic> toCorrectionRow(AttendanceSession session) {
    return {
      'started_at': session.startedAt.toUtc().toIso8601String(),
      'ended_at': session.endedAt?.toUtc().toIso8601String(),
      'source': AttendanceSource.manager.wire,
      'note': session.note.trim(),
    };
  }

  static DateTime? parseDate(Object? value) {
    final parsed = _parseAny(value);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  static DateTime? parseTimestamp(Object? value) => _parseAny(value)?.toUtc();

  static DateTime? _parseAny(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  /// Null stays null — an open session has no duration yet, and 0 would read as
  /// "worked nothing".
  static int? parseMinutes(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.round();
    final parsed = num.tryParse(value.toString().trim());
    return parsed?.round();
  }

  static String _str(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final s = value.toString();
    return s.isEmpty ? fallback : s;
  }
}
