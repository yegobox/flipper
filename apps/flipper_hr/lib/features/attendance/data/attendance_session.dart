/// One stretch of time worked, and the enums around it.
///
/// Plain Dart — no Supabase, http or Flutter imports — so the grouping and
/// duration maths are unit-testable without a backend. Persistence lives in
/// `attendance_row_mapper.dart` and `supabase_attendance_repository.dart`.
///
/// A day is modelled as a LIST of sessions rather than one row with clock-in and
/// clock-out columns. People break for lunch, step out and come back, and a
/// single pair of columns forces that into either a lie or a second table. The
/// per-day view is derived — see `attendance_day.dart`.
library;

/// Who recorded the punch.
///
/// Kept because a corrected or on-behalf entry and a self-service one carry very
/// different weight in a dispute about hours.
enum AttendanceSource {
  /// The person clocked themselves in or out.
  self('self', 'Self'),

  /// Recorded for them by whoever manages the roster.
  manager('manager', 'Recorded by manager');

  const AttendanceSource(this.wire, this.label);

  final String wire;
  final String label;

  static AttendanceSource fromWire(String? raw) {
    if (raw == null) return AttendanceSource.self;
    final needle = raw.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    for (final s in values) {
      if (s.wire == needle) return s;
    }
    return AttendanceSource.self;
  }
}

/// One clock-in, with its clock-out once it happens.
///
/// [id] is empty until Postgres assigns one, matching [LeaveRequest] and
/// [Employee]. [businessId], [branchId] and [workDate] are stamped by a database
/// trigger from the employee's row, so anything sent from here is advisory — the
/// stored row is authoritative and every write reads it back.
class AttendanceSession {
  const AttendanceSession({
    this.id = '',
    required this.employeeId,
    this.businessId = '',
    this.branchId = '',
    required this.workDate,
    required this.startedAt,
    this.endedAt,
    this.minutes,
    this.source = AttendanceSource.self,
    this.note = '',
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String employeeId;
  final String businessId;
  final String branchId;

  /// The shift's day in branch-local terms, assigned server-side. An overnight
  /// shift belongs to the day it STARTED, which is why this is stored rather
  /// than derived from [endedAt].
  final DateTime workDate;

  final DateTime startedAt;

  /// Null while the person is still clocked in. At most one such session per
  /// employee exists — Postgres enforces it with a partial unique index.
  final DateTime? endedAt;

  /// Minutes worked, computed server-side when the session closes.
  ///
  /// Stored rather than derived on read so a corrected timestamp and the figure
  /// payroll reads can never disagree. Null while the session is open — use
  /// [minutesAsOf] for a live figure.
  final int? minutes;

  final AttendanceSource source;
  final String note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isPersisted => id.isNotEmpty;

  /// True while the person is clocked in.
  bool get isOpen => endedAt == null;

  /// Minutes worked, counting an open session up to [asOf].
  ///
  /// Falls back to the timestamps when [minutes] is absent, so a row written by
  /// something that skipped the trigger still reports a duration. Never negative:
  /// a clock that went backwards reads as zero rather than as credit.
  int minutesAsOf(DateTime asOf) {
    final end = endedAt ?? asOf;
    if (endedAt != null && minutes != null) return minutes! < 0 ? 0 : minutes!;
    final elapsed = end.difference(startedAt).inMinutes;
    return elapsed < 0 ? 0 : elapsed;
  }

  /// True when the shift ran past midnight, which the day view labels — an
  /// unlabelled 14-hour Tuesday looks like a data error.
  bool get isOvernight {
    final end = endedAt;
    if (end == null) return false;
    return end.day != startedAt.day ||
        end.month != startedAt.month ||
        end.year != startedAt.year;
  }

  AttendanceSession copyWith({
    String? id,
    String? employeeId,
    String? businessId,
    String? branchId,
    DateTime? workDate,
    DateTime? startedAt,
    DateTime? endedAt,
    bool clearEndedAt = false,
    int? minutes,
    bool clearMinutes = false,
    AttendanceSource? source,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AttendanceSession(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    businessId: businessId ?? this.businessId,
    branchId: branchId ?? this.branchId,
    workDate: workDate ?? this.workDate,
    startedAt: startedAt ?? this.startedAt,
    endedAt: clearEndedAt ? null : (endedAt ?? this.endedAt),
    minutes: clearMinutes ? null : (minutes ?? this.minutes),
    source: source ?? this.source,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  List<Object?> get _props => [
    id,
    employeeId,
    businessId,
    branchId,
    workDate,
    startedAt,
    endedAt,
    minutes,
    source,
    note,
    createdAt,
    updatedAt,
  ];

  @override
  bool operator ==(Object other) {
    if (other is! AttendanceSession) return false;
    final mine = _props;
    final theirs = other._props;
    for (var i = 0; i < mine.length; i++) {
      if (mine[i] != theirs[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_props);

  @override
  String toString() =>
      'AttendanceSession($id, $employeeId, ${isOpen ? 'open' : '$minutes min'})';
}
