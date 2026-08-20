import 'package:flipper_hr/features/attendance/data/attendance_repository.dart';
import 'package:flipper_hr/features/attendance/data/attendance_session.dart';
import 'package:flipper_hr/features/attendance/data/attendance_day.dart';
import 'package:flipper_hr/features/attendance/data/supabase_attendance_repository.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The attendance store. Overridden with a fake in tests.
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return SupabaseAttendanceRepository(Supabase.instance.client);
});

/// How far back the personal timesheet reads. Two weeks covers "did I forget to
/// clock out on Friday?" without pulling a year of history into a phone.
const timesheetWindowDays = 14;

/// One branch on one day — the board's family key.
///
/// A value class rather than a record because Riverpod families key on equality,
/// and a `DateTime` with a time component would silently create a new cache entry
/// (and a new request) on every rebuild. The constructor normalises it away.
class BranchDay {
  BranchDay({required this.branchId, required DateTime date})
    : date = dateOnly(date);

  final String branchId;
  final DateTime date;

  @override
  bool operator ==(Object other) =>
      other is BranchDay && other.branchId == branchId && other.date == date;

  @override
  int get hashCode => Object.hash(branchId, date);

  @override
  String toString() => 'BranchDay($branchId, ${date.toIso8601String()})';
}

/// Every session on a branch for one day. Retry is off for the same reason as
/// [rosterProvider]: the page offers "Try again" rather than refetching invisibly.
final branchAttendanceProvider =
    FutureProvider.family<List<AttendanceSession>, BranchDay>((ref, key) {
      return ref.watch(attendanceRepositoryProvider).fetchForBranchDate(
        branchId: key.branchId,
        date: key.date,
      );
    }, retry: (retryCount, error) => null);

/// The signed-in person's open session, or null when they are not clocked in.
///
/// Null also when they have no employee record at all, which is not an error —
/// the page shows why.
final myOpenSessionProvider = FutureProvider<AttendanceSession?>((ref) async {
  final session = await ref.watch(hrSessionProvider.future);
  final id = session.primaryEmployeeId;
  if (id == null) return null;
  return ref.watch(attendanceRepositoryProvider).openSessionFor(employeeId: id);
}, retry: (retryCount, error) => null);

/// The signed-in person's last [timesheetWindowDays] of sessions, newest first.
final myTimesheetProvider = FutureProvider<List<AttendanceSession>>((ref) async {
  final session = await ref.watch(hrSessionProvider.future);
  final id = session.primaryEmployeeId;
  if (id == null) return const [];

  final today = dateOnly(ref.watch(hrClockProvider)());
  return ref.watch(attendanceRepositoryProvider).fetchForEmployee(
    employeeId: id,
    from: today.subtract(const Duration(days: timesheetWindowDays - 1)),
    to: today,
  );
}, retry: (retryCount, error) => null);

/// Writes. Every mutation invalidates the views it could have made stale: the
/// person's own, and the branch board for the day the session belongs to.
final attendanceActionsProvider = Provider<AttendanceActions>(
  AttendanceActions.new,
);

class AttendanceActions {
  AttendanceActions(this._ref);

  final Ref _ref;

  /// Clocks someone in. [source] records whether they did it themselves or a
  /// manager did it for them.
  Future<AttendanceSession> clockIn({
    required String employeeId,
    AttendanceSource source = AttendanceSource.self,
    String note = '',
  }) async {
    final saved = await _ref.read(attendanceRepositoryProvider).clockIn(
      employeeId: employeeId,
      source: source,
      note: note,
    );
    _invalidate(saved);
    return saved;
  }

  Future<AttendanceSession> clockOut({
    required AttendanceSession session,
    String note = '',
  }) async {
    final saved = await _ref.read(attendanceRepositoryProvider).clockOut(
      sessionId: session.id,
      note: note,
    );
    _invalidate(saved, previous: session);
    return saved;
  }

  /// Rewrites an entry's times. Managers only — RLS refuses it for anyone else.
  Future<AttendanceSession> correct(AttendanceSession session) async {
    final saved = await _ref
        .read(attendanceRepositoryProvider)
        .correct(session);
    _invalidate(saved, previous: session);
    return saved;
  }

  void _invalidate(AttendanceSession saved, {AttendanceSession? previous}) {
    _ref.invalidate(myOpenSessionProvider);
    _ref.invalidate(myTimesheetProvider);
    _ref.invalidate(
      branchAttendanceProvider(
        BranchDay(branchId: saved.branchId, date: saved.workDate),
      ),
    );
    // A correction can move a session to another day, which leaves the day it
    // came from stale too.
    if (previous != null && !isSameDate(previous.workDate, saved.workDate)) {
      _ref.invalidate(
        branchAttendanceProvider(
          BranchDay(branchId: previous.branchId, date: previous.workDate),
        ),
      );
    }
  }
}
