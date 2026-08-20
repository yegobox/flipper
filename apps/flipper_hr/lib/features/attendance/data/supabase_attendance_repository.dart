import 'package:flipper_hr/features/attendance/data/attendance_repository.dart';
import 'package:flipper_hr/features/attendance/data/attendance_row_mapper.dart';
import 'package:flipper_hr/features/attendance/data/attendance_session.dart';
import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart'
    show describeBackendError, rlsViolationCode;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase-backed attendance. Table, trigger and RPCs are defined in
/// `supabase/migrations/0005_hr_attendance.sql`.
///
/// Clock in and clock out go through RPCs rather than table writes, because the
/// timestamp has to come from the server: `now()` cannot be expressed in a
/// PostgREST insert payload, and letting the client send the time makes the
/// timesheet only as trustworthy as the device clock. Everything else is a plain
/// table call under RLS.
class SupabaseAttendanceRepository implements AttendanceRepository {
  const SupabaseAttendanceRepository(this._client);

  static const table = 'hr_attendance_sessions';
  static const clockInRpc = 'hr_clock_in';
  static const clockOutRpc = 'hr_clock_out';

  final SupabaseClient _client;

  @override
  Future<List<AttendanceSession>> fetchForBranchDate({
    required String branchId,
    required DateTime date,
  }) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .eq('branch_id', branchId)
          .eq('work_date', _dateParam(date))
          .order('started_at');
      return [for (final row in rows) AttendanceRowMapper.fromRow(row)];
    } catch (e) {
      throw AttendanceRepositoryException(
        describeBackendError(
          'Could not load attendance for this day.',
          e,
          scope: 'branch $branchId',
        ),
        cause: e,
      );
    }
  }

  @override
  Future<List<AttendanceSession>> fetchForEmployee({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .eq('employee_id', employeeId)
          .gte('work_date', _dateParam(from))
          .lte('work_date', _dateParam(to))
          .order('started_at', ascending: false);
      return [for (final row in rows) AttendanceRowMapper.fromRow(row)];
    } catch (e) {
      throw AttendanceRepositoryException(
        describeBackendError('Could not load this timesheet.', e),
        cause: e,
      );
    }
  }

  @override
  Future<AttendanceSession?> openSessionFor({required String employeeId}) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .eq('employee_id', employeeId)
          .isFilter('ended_at', null)
          .order('started_at', ascending: false)
          .limit(1);
      if (rows.isEmpty) return null;
      return AttendanceRowMapper.fromRow(rows.first);
    } catch (e) {
      throw AttendanceRepositoryException(
        describeBackendError('Could not check whether you are clocked in.', e),
        cause: e,
      );
    }
  }

  @override
  Future<AttendanceSession> clockIn({
    required String employeeId,
    AttendanceSource source = AttendanceSource.self,
    String note = '',
  }) async {
    try {
      final raw = await _client.rpc(
        clockInRpc,
        params: {
          'p_employee_id': employeeId,
          'p_source': source.wire,
          'p_note': note.trim(),
        },
      );
      return _rowOf(raw, 'clock in');
    } catch (e) {
      throw AttendanceRepositoryException(_clockMessage(e, 'in'), cause: e);
    }
  }

  @override
  Future<AttendanceSession> clockOut({
    required String sessionId,
    String note = '',
  }) async {
    try {
      final raw = await _client.rpc(
        clockOutRpc,
        params: {'p_session_id': sessionId, 'p_note': note.trim()},
      );
      return _rowOf(raw, 'clock out');
    } catch (e) {
      throw AttendanceRepositoryException(_clockMessage(e, 'out'), cause: e);
    }
  }

  @override
  Future<AttendanceSession> correct(AttendanceSession session) async {
    if (!session.isPersisted) {
      throw AttendanceRepositoryException(
        'Cannot correct a session that has not been saved yet.',
      );
    }
    try {
      final row = await _client
          .from(table)
          .update(AttendanceRowMapper.toCorrectionRow(session))
          .eq('id', session.id)
          .select()
          .single();
      return AttendanceRowMapper.fromRow(row);
    } catch (e) {
      throw AttendanceRepositoryException(
        describeBackendError(
          'Could not correct this entry.',
          e,
          scope: 'branch ${session.branchId}',
        ),
        cause: e,
      );
    }
  }

  /// The RPCs return the stored row as jsonb.
  AttendanceSession _rowOf(Object? raw, String what) {
    if (raw is Map) {
      return AttendanceRowMapper.fromRow(Map<String, dynamic>.from(raw));
    }
    // A list comes back if the function is ever redefined as SETOF; take the
    // first rather than failing, since the write already happened.
    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return AttendanceRowMapper.fromRow(
        Map<String, dynamic>.from(raw.first as Map),
      );
    }
    throw AttendanceRepositoryException(
      'The server accepted the $what but returned nothing to show.',
    );
  }

  /// The two failures worth naming distinctly: the migration is missing, and the
  /// database refused because the person is already in the state they asked for.
  String _clockMessage(Object e, String direction) {
    if (e is PostgrestException) {
      if (e.code == 'PGRST202') {
        return 'This Supabase project is missing hr_clock_$direction(). Apply '
            'apps/flipper_hr/supabase/migrations/0005_hr_attendance.sql.';
      }
      // The RPCs raise these with a readable message, so pass it through rather
      // than wrapping it in something vaguer.
      if (e.code == 'P0001') return e.message;
      if (e.code == rlsViolationCode) {
        return 'You are not allowed to clock $direction for this person. '
            '[${e.code}] ${e.message}';
      }
    }
    return describeBackendError('Could not clock $direction.', e);
  }

  /// `date` columns compare as `YYYY-MM-DD`; sending a full timestamp makes
  /// PostgREST cast it and shifts the day across a timezone boundary.
  static String _dateParam(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-$m-$d';
  }
}
