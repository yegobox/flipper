import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_row_mapper.dart';
import 'package:flipper_hr/features/people/data/employee_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase-backed roster. Table and columns are defined in
/// `supabase/migrations/0001_hr_employees.sql`.
///
/// Writes use `.select().single()` so the stored row — with the Postgres-owned
/// id and timestamps — is what lands back in the list, rather than the optimistic
/// local copy.
class SupabaseEmployeeRepository implements EmployeeRepository {
  const SupabaseEmployeeRepository(this._client);

  static const table = 'hr_employees';

  final SupabaseClient _client;

  @override
  Future<List<Employee>> fetchEmployees({required String branchId}) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .eq('branch_id', branchId)
          .order('first_name');
      return [
        for (final row in rows) EmployeeRowMapper.fromRow(row),
      ];
    } catch (e) {
      throw EmployeeRepositoryException(
        describeBackendError('Could not load the people on this branch.', e),
        cause: e,
      );
    }
  }

  @override
  Future<Employee> createEmployee(Employee employee) async {
    try {
      final row = await _client
          .from(table)
          .insert(EmployeeRowMapper.toInsertRow(employee))
          .select()
          .single();
      return EmployeeRowMapper.fromRow(row);
    } catch (e) {
      throw EmployeeRepositoryException(
        describeBackendError(
          'Could not add ${_describe(employee)}.',
          e,
          scope: _scopeOf(employee),
        ),
        cause: e,
      );
    }
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    if (!employee.isPersisted) {
      throw EmployeeRepositoryException(
        'Cannot update a person who has not been saved yet.',
      );
    }
    try {
      final row = await _client
          .from(table)
          .update(EmployeeRowMapper.toUpdateRow(employee))
          .eq('id', employee.id)
          .select()
          .single();
      return EmployeeRowMapper.fromRow(row);
    } catch (e) {
      throw EmployeeRepositoryException(
        describeBackendError(
          'Could not save changes to ${_describe(employee)}.',
          e,
          scope: _scopeOf(employee),
        ),
        cause: e,
      );
    }
  }

  @override
  Future<Employee> setStatus({
    required String id,
    required EmploymentStatus status,
    DateTime? endDate,
  }) async {
    try {
      final row = await _client
          .from(table)
          .update({
            'status': status.wire,
            // Cleared for any non-terminal status so a re-hire has no last day.
            'end_date': status == EmploymentStatus.terminated && endDate != null
                ? EmployeeRowMapper.formatDate(endDate)
                : null,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();
      return EmployeeRowMapper.fromRow(row);
    } catch (e) {
      throw EmployeeRepositoryException(
        describeBackendError(
          'Could not change this person to ${status.label.toLowerCase()}.',
          e,
        ),
        cause: e,
      );
    }
  }

  String _describe(Employee e) =>
      e.fullName.isEmpty ? 'this person' : e.fullName;

  /// The ids RLS is judging the row on.
  String _scopeOf(Employee e) =>
      'business ${e.businessId}, branch ${e.branchId}';
}

/// Postgres error code for an RLS rejection (`insufficient_privilege`).
const rlsViolationCode = '42501';

/// Appends what Postgres actually said to a friendly message.
///
/// Without this, an RLS rejection reads as a generic "could not add" and the
/// only clue is a bare 403 in the network tab. HR is an operator-facing tool, so
/// the cause belongs on screen: "new row violates row-level security policy"
/// points straight at the policy instead of at the form.
///
/// [scope] is appended for RLS rejections only. Which business the row was
/// attributed to is the whole question in that case — the policy compares it
/// against `hr_user_business_ids()` — so showing it turns a DevTools dig into a
/// glance. It is noise for every other failure.
String describeBackendError(String friendly, Object? cause, {String? scope}) {
  if (cause is PostgrestException) {
    final code = cause.code == null ? '' : ' [${cause.code}]';
    final where = cause.code == rlsViolationCode && scope != null
        ? ' ($scope)'
        : '';
    return '$friendly$code ${cause.message}$where';
  }
  return friendly;
}
