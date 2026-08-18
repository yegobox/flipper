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
