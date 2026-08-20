import 'package:flipper_hr/features/people/data/employee.dart';

/// Backend-agnostic contract for the HR roster.
///
/// Supabase is the only store — unlike POS entities, HR records are never read
/// offline through Ditto, so there is no dual-write here. The interface exists
/// so the page and providers can be tested against a fake.
abstract class EmployeeRepository {
  /// Every employee on a branch, terminated ones included. Filtering by status
  /// happens client-side so the status tabs never re-query.
  Future<List<Employee>> fetchEmployees({required String branchId});

  /// One person by id, or null when no row is readable.
  ///
  /// Null covers both "no such row" and "RLS hid it", which the client cannot
  /// tell apart and does not need to: either way there is nothing to show.
  /// Self-service reads through here — an employee's own row is visible to them
  /// under `hr_employees_select_self` even though the branch roster is not.
  Future<Employee?> fetchEmployee({required String id});

  /// Inserts and returns the stored row (id and `created_at` come from Postgres).
  Future<Employee> createEmployee(Employee employee);

  /// Updates by id and returns the stored row.
  Future<Employee> updateEmployee(Employee employee);

  /// Records the Flipper account an invited person signs in with.
  ///
  /// A one-column write rather than a full [updateEmployee]: the invite runs
  /// against the record as it was loaded, and rewriting salary and job title
  /// from a possibly-stale copy to store one id would be a needless clobber.
  Future<Employee> linkAccount({required String id, required String userId});

  /// Status-only change for the row menu (mark on leave, reactivate, terminate).
  ///
  /// [endDate] is written when terminating and cleared when [status] is anything
  /// else, so a re-hire does not keep a stale last day.
  Future<Employee> setStatus({
    required String id,
    required EmploymentStatus status,
    DateTime? endDate,
  });
}

/// Thrown when a write fails, so the UI can show one message for any backend
/// error instead of leaking PostgrestException details.
class EmployeeRepositoryException implements Exception {
  EmployeeRepositoryException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'EmployeeRepositoryException: $message';
}
