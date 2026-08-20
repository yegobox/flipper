import 'package:flipper_hr/features/leave/data/leave_request.dart';

/// Backend-agnostic contract for leave.
///
/// Two audiences read through this: an employee reading their own requests, and
/// an approver reading a branch's. They are separate methods rather than one
/// filtered call because the RLS policies behind them are separate — an employee
/// asking for the branch would get their own rows and no error, which is exactly
/// the kind of quiet mismatch a shared method invites.
abstract class LeaveRepository {
  /// Every request for one person, newest first. Not filtered by year: the
  /// balance maths needs the whole history and filters by
  /// [LeaveRequest.accrualYear] itself.
  Future<List<LeaveRequest>> fetchForEmployee({required String employeeId});

  /// Every request on a branch, newest first — the approvals queue.
  Future<List<LeaveRequest>> fetchForBranch({required String branchId});

  /// Every request belonging to any of [employeeIds], newest first.
  ///
  /// The queue of a line manager, who has no branch to ask for: their team is a
  /// set of employee ids (`hr_my_report_ids()`), and it may span branches. A third
  /// method rather than a filter argument for the same reason the first two are
  /// separate — the RLS policy behind it is its own (`hr_leave_select_reports`),
  /// and an empty [employeeIds] must not silently mean "everything".
  Future<List<LeaveRequest>> fetchForEmployees({
    required List<String> employeeIds,
  });

  /// Files a request. Always stored pending; the returned row is what Postgres
  /// kept, including the trigger-assigned business and branch.
  Future<LeaveRequest> submit(LeaveRequest request);

  /// Approves or rejects. [decidedBy] is a `public.users.id`.
  Future<LeaveRequest> decide({
    required String id,
    required LeaveStatus status,
    required String? decidedBy,
    String note = '',
  });

  /// Withdraws a request that has not been decided. Separate from [decide]
  /// because it runs under a different RLS policy — the employee's own — and
  /// records no decider.
  Future<LeaveRequest> cancel({required String id});
}

/// Thrown when a leave call fails, so the UI shows one message rather than a
/// PostgrestException.
class LeaveRepositoryException implements Exception {
  LeaveRepositoryException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'LeaveRepositoryException: $message';
}
