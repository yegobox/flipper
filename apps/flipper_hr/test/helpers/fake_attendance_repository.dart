import 'package:flipper_hr/features/attendance/data/attendance_day.dart';
import 'package:flipper_hr/features/attendance/data/attendance_repository.dart';
import 'package:flipper_hr/features/attendance/data/attendance_session.dart';

/// In-memory [AttendanceRepository] for provider and widget tests.
///
/// Mirrors the parts of the real contract that behaviour depends on: the server
/// stamps the times (so [now] stands in for `now()`), ids are assigned on insert,
/// a second open session for one employee is refused the way the unique index
/// refuses it, and closing a session computes minutes.
class FakeAttendanceRepository implements AttendanceRepository {
  FakeAttendanceRepository({
    List<AttendanceSession>? seed,
    required this.now,
    this.failWith,
  }) : _sessions = [...?seed];

  final List<AttendanceSession> _sessions;

  /// Stands in for the database clock.
  DateTime now;

  /// When set, every method throws this instead of doing any work.
  Object? failWith;

  int _nextId = 1;
  int clockInCount = 0;
  int clockOutCount = 0;

  List<AttendanceSession> get sessions => List.unmodifiable(_sessions);

  @override
  Future<List<AttendanceSession>> fetchForBranchDate({
    required String branchId,
    required DateTime date,
  }) async {
    _maybeFail();
    return [
      for (final s in _sessions)
        if (s.branchId == branchId && isSameDate(s.workDate, date)) s,
    ]..sort((a, b) => a.startedAt.compareTo(b.startedAt));
  }

  @override
  Future<List<AttendanceSession>> fetchForEmployee({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    _maybeFail();
    final start = dateOnly(from);
    final end = dateOnly(to);
    return [
      for (final s in _sessions)
        if (s.employeeId == employeeId &&
            !dateOnly(s.workDate).isBefore(start) &&
            !dateOnly(s.workDate).isAfter(end))
          s,
    ]..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  @override
  Future<AttendanceSession?> openSessionFor({required String employeeId}) async {
    _maybeFail();
    for (final s in _sessions) {
      if (s.employeeId == employeeId && s.isOpen) return s;
    }
    return null;
  }

  @override
  Future<AttendanceSession> clockIn({
    required String employeeId,
    AttendanceSource source = AttendanceSource.self,
    String note = '',
  }) async {
    _maybeFail();
    clockInCount++;
    if (_sessions.any((s) => s.employeeId == employeeId && s.isOpen)) {
      // What hr_clock_in raises, so the UI path under test is the real one.
      throw AttendanceRepositoryException('Already clocked in');
    }
    final stored = AttendanceSession(
      id: 'session-${_nextId++}',
      employeeId: employeeId,
      businessId: 'biz-1',
      branchId: 'branch-1',
      workDate: dateOnly(now),
      startedAt: now,
      source: source,
      note: note,
    );
    _sessions.add(stored);
    return stored;
  }

  @override
  Future<AttendanceSession> clockOut({
    required String sessionId,
    String note = '',
  }) async {
    _maybeFail();
    clockOutCount++;
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index < 0 || !_sessions[index].isOpen) {
      throw AttendanceRepositoryException('That session is not open');
    }
    final open = _sessions[index];
    final closed = open.copyWith(
      endedAt: now,
      minutes: now.difference(open.startedAt).inMinutes,
      note: note.isEmpty ? open.note : note,
    );
    _sessions[index] = closed;
    return closed;
  }

  @override
  Future<AttendanceSession> correct(AttendanceSession session) async {
    _maybeFail();
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index < 0) {
      throw AttendanceRepositoryException('No such session: ${session.id}');
    }
    final corrected = session.copyWith(
      workDate: dateOnly(session.startedAt),
      minutes: session.endedAt?.difference(session.startedAt).inMinutes,
      source: AttendanceSource.manager,
    );
    _sessions[index] = corrected;
    return corrected;
  }

  void _maybeFail() {
    final failure = failWith;
    if (failure != null) throw failure;
  }
}

/// Convenience builder — only the fields a test cares about need naming.
AttendanceSession session({
  String id = 's-1',
  String employeeId = 'e-1',
  String branchId = 'branch-1',
  String businessId = 'biz-1',
  DateTime? startedAt,
  DateTime? endedAt,
  int? minutes,
  DateTime? workDate,
  AttendanceSource source = AttendanceSource.self,
  String note = '',
}) {
  final start = startedAt ?? DateTime(2026, 8, 18, 8, 0);
  return AttendanceSession(
    id: id,
    employeeId: employeeId,
    businessId: businessId,
    branchId: branchId,
    workDate: workDate ?? dateOnly(start),
    startedAt: start,
    endedAt: endedAt,
    minutes: minutes ?? endedAt?.difference(start).inMinutes,
    source: source,
    note: note,
  );
}
