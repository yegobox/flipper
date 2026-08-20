import 'package:flipper_hr/features/leave/data/leave_repository.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_row_mapper.dart';
import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart'
    show describeBackendError;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase-backed leave. Table and policies live in
/// `supabase/migrations/0004_hr_leave.sql`.
///
/// Writes use `.select().single()` so what lands back in the list is the stored
/// row. That matters more here than on the roster: a database trigger rewrites
/// `business_id` and `branch_id` from the employee's record, so the row that was
/// sent is not the row that exists.
class SupabaseLeaveRepository implements LeaveRepository {
  const SupabaseLeaveRepository(this._client);

  static const table = 'hr_leave_requests';

  final SupabaseClient _client;

  @override
  Future<List<LeaveRequest>> fetchForEmployee({
    required String employeeId,
  }) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .eq('employee_id', employeeId)
          .order('start_date', ascending: false);
      return [for (final row in rows) LeaveRowMapper.fromRow(row)];
    } catch (e) {
      throw LeaveRepositoryException(
        describeBackendError('Could not load your leave.', e),
        cause: e,
      );
    }
  }

  @override
  Future<List<LeaveRequest>> fetchForBranch({required String branchId}) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .eq('branch_id', branchId)
          .order('start_date', ascending: false);
      return [for (final row in rows) LeaveRowMapper.fromRow(row)];
    } catch (e) {
      throw LeaveRepositoryException(
        describeBackendError('Could not load leave for this branch.', e),
        cause: e,
      );
    }
  }

  @override
  Future<List<LeaveRequest>> fetchForEmployees({
    required List<String> employeeIds,
  }) async {
    // No ids is no query. PostgREST would happily send `in.()` and the RLS
    // policies would then decide the result, which for an owner is the whole
    // business — the opposite of "nobody reports to me".
    if (employeeIds.isEmpty) return const [];
    try {
      final rows = await _client
          .from(table)
          .select()
          .inFilter('employee_id', employeeIds)
          .order('start_date', ascending: false);
      return [for (final row in rows) LeaveRowMapper.fromRow(row)];
    } catch (e) {
      throw LeaveRepositoryException(
        describeBackendError('Could not load leave for your team.', e),
        cause: e,
      );
    }
  }

  @override
  Future<LeaveRequest> submit(LeaveRequest request) async {
    try {
      final row = await _client
          .from(table)
          .insert(LeaveRowMapper.toInsertRow(request))
          .select()
          .single();
      return LeaveRowMapper.fromRow(row);
    } catch (e) {
      throw LeaveRepositoryException(
        describeBackendError(
          'Could not send this leave request.',
          e,
          scope: _selfScope(request.employeeId),
        ),
        cause: e,
      );
    }
  }

  @override
  Future<LeaveRequest> decide({
    required String id,
    required LeaveStatus status,
    required String? decidedBy,
    String note = '',
  }) async {
    if (!status.isDecided) {
      throw LeaveRepositoryException(
        'decide() records an approval or a rejection; use cancel() to withdraw.',
      );
    }
    try {
      final row = await _client
          .from(table)
          .update(
            LeaveRowMapper.toDecisionRow(
              status: status,
              decidedBy: decidedBy,
              note: note,
            ),
          )
          .eq('id', id)
          // Only a request nobody has decided yet: without this, two approvers
          // acting at once would have the second silently overwrite the first.
          .eq('status', LeaveStatus.pending.wire)
          .select()
          .single();
      return LeaveRowMapper.fromRow(row);
    } catch (e) {
      throw LeaveRepositoryException(
        describeBackendError(
          _decisionFailure(status, e),
          e,
          scope: 'request $id',
        ),
        cause: e,
      );
    }
  }

  @override
  Future<LeaveRequest> cancel({required String id}) async {
    try {
      final row = await _client
          .from(table)
          .update(LeaveRowMapper.toDecisionRow(status: LeaveStatus.cancelled))
          .eq('id', id)
          .eq('status', LeaveStatus.pending.wire)
          .select()
          .single();
      return LeaveRowMapper.fromRow(row);
    } catch (e) {
      throw LeaveRepositoryException(
        describeBackendError(
          'Could not withdraw this request. It may already have been decided.',
          e,
          scope: 'request $id',
        ),
        cause: e,
      );
    }
  }

  /// `.single()` on an update that matched nothing raises PGRST116, not an empty
  /// list. Here that means the `status = pending` guard failed — somebody else
  /// got there first — which is worth saying plainly instead of "no rows".
  static String _decisionFailure(LeaveStatus status, Object? cause) {
    final verb = status == LeaveStatus.approved ? 'approve' : 'reject';
    if (cause is PostgrestException && cause.code == 'PGRST116') {
      return 'Could not $verb this request: it has already been decided or '
          'withdrawn. Refresh to see where it stands.';
    }
    return 'Could not $verb this request.';
  }

  /// What RLS is judging an insert on. Unlike the roster, the deciding fact is
  /// not a business id but whether the caller *is* this employee — so that is
  /// what the message names.
  static String _selfScope(String employeeId) =>
      'employee $employeeId; the policy checks hr_my_employee_ids()';
}
