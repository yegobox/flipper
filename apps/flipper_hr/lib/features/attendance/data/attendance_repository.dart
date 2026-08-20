import 'package:flipper_hr/features/attendance/data/attendance_session.dart';

/// Backend-agnostic contract for attendance.
///
/// Split by audience for the same reason [LeaveRepository] is: the RLS policies
/// behind a branch read and a self read are different, and one filtered method
/// would let an employee ask for the branch and quietly receive only themselves.
abstract class AttendanceRepository {
  /// Every session on a branch for one work date.
  Future<List<AttendanceSession>> fetchForBranchDate({
    required String branchId,
    required DateTime date,
  });

  /// One person's sessions between two work dates, inclusive, newest first.
  Future<List<AttendanceSession>> fetchForEmployee({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  });

  /// The person's still-open session, or null when they are not clocked in.
  ///
  /// Its own call rather than a filter over [fetchForEmployee]: the clock button
  /// needs it before any date range is known, and an open session outlives the
  /// day it started on.
  Future<AttendanceSession?> openSessionFor({required String employeeId});

  /// Clocks [employeeId] in and returns the stored row.
  ///
  /// The start time comes from the database, not the device — a phone with a
  /// wrong clock, or a deliberately wound-back one, must not be able to write
  /// hours. Fails if that person already has an open session.
  Future<AttendanceSession> clockIn({
    required String employeeId,
    AttendanceSource source = AttendanceSource.self,
    String note = '',
  });

  /// Closes an open session, server-stamped for the same reason as [clockIn].
  Future<AttendanceSession> clockOut({
    required String sessionId,
    String note = '',
  });

  /// Rewrites the timestamps on an existing session. Roster managers only — the
  /// RLS update policy for an employee allows nothing but closing their own open
  /// session.
  Future<AttendanceSession> correct(AttendanceSession session);
}

/// Thrown when an attendance call fails, so the UI shows one message instead of
/// a PostgrestException.
class AttendanceRepositoryException implements Exception {
  AttendanceRepositoryException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AttendanceRepositoryException: $message';
}
