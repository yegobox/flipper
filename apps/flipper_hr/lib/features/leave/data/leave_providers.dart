import 'package:flipper_hr/features/leave/data/leave_balance.dart';
import 'package:flipper_hr/features/leave/data/leave_repository.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/data/supabase_leave_repository.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The leave store. Overridden with a fake in tests.
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return SupabaseLeaveRepository(Supabase.instance.client);
});

/// Every request for one person, newest first.
///
/// Family-keyed by employee id so an approver opening someone's history and the
/// person's own page share one cache entry. Retry is off for the same reason as
/// [rosterProvider]: the page offers "Try again" instead of refetching invisibly.
final employeeLeaveProvider =
    FutureProvider.family<List<LeaveRequest>, String>((ref, employeeId) {
      return ref.watch(leaveRepositoryProvider).fetchForEmployee(
        employeeId: employeeId,
      );
    }, retry: (retryCount, error) => null);

/// Every request on a branch — the approvals queue's source.
final branchLeaveProvider =
    FutureProvider.family<List<LeaveRequest>, String>((ref, branchId) {
      return ref.watch(leaveRepositoryProvider).fetchForBranch(
        branchId: branchId,
      );
    }, retry: (retryCount, error) => null);

/// Every request from the signed-in person's team — their reports, and anyone
/// under those (see `hr_my_report_ids()` in migration 0007).
///
/// Empty for someone with nobody reporting to them, which is the common case and
/// not an error. Keyed on nothing: the team is a property of the session, so one
/// cache entry serves the queue however it is reached.
final teamLeaveProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final session = await ref.watch(hrSessionProvider.future);
  if (!session.hasReports) return const [];
  return ref.watch(leaveRepositoryProvider).fetchForEmployees(
    employeeIds: session.reportIds,
  );
}, retry: (retryCount, error) => null);

/// The approvals queue for whoever is signed in.
///
/// Unions the two routes to authority, because both can hold at once and neither
/// contains the other:
///
///   * the open branch, when the session manages the business — unchanged
///     behaviour for an owner or an invited HR manager;
///   * their own team, wherever it sits — a line manager's reports can be on
///     another branch than the one selected, and a team lead has no selection at
///     all.
///
/// Deduped by request id, so someone with both routes sees each request once.
/// [branchId] is nullable because the page is reachable without a branch
/// selection; passing one for a session that manages no business adds nothing,
/// since RLS would return only what the team route already covers.
final approvalsQueueProvider =
    FutureProvider.family<List<LeaveRequest>, String?>((ref, branchId) async {
      final session = await ref.watch(hrSessionProvider.future);

      final byId = <String, LeaveRequest>{};
      if (session.hasReports) {
        for (final r in await ref.watch(teamLeaveProvider.future)) {
          byId[r.id] = r;
        }
      }
      if (branchId != null && session.canManageRoster) {
        for (final r in await ref.watch(branchLeaveProvider(branchId).future)) {
          byId[r.id] = r;
        }
      }

      // Newest first, matching what either fetch returns on its own so a merged
      // queue and a single-source one read the same way.
      return byId.values.toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
    }, retry: (retryCount, error) => null);

/// The signed-in person's own requests. Empty when they have no record, which is
/// not an error — see [myEmployeeProvider].
final myLeaveProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final session = await ref.watch(hrSessionProvider.future);
  final id = session.primaryEmployeeId;
  if (id == null) return const [];
  return ref.watch(employeeLeaveProvider(id).future);
}, retry: (retryCount, error) => null);

/// The signed-in person's balances for the current year, every type, in
/// [LeaveType.values] order.
///
/// Composed from [myEmployeeProvider] and [myLeaveProvider] rather than computed
/// in the widget so the year and the entitlement override are applied in one
/// place — a screen that reached for `DateTime.now()` itself would disagree with
/// the validator on New Year's Eve.
final myLeaveBalancesProvider = FutureProvider<List<LeaveBalance>>((ref) async {
  final employee = await ref.watch(myEmployeeProvider.future);
  final requests = await ref.watch(myLeaveProvider.future);
  final year = ref.watch(hrClockProvider)().year;
  return LeaveBalance.allFor(
    year: year,
    requests: requests,
    annualOverride: employee?.annualLeaveDays,
  );
}, retry: (retryCount, error) => null);

/// Requests still waiting on a decision, soonest start first.
///
/// Sorted by start date rather than by when they were filed: what an approver
/// needs to act on first is the leave that begins soonest.
final pendingLeaveProvider =
    FutureProvider.family<List<LeaveRequest>, String>((ref, branchId) async {
      final all = await ref.watch(branchLeaveProvider(branchId).future);
      final pending = [
        for (final r in all)
          if (r.status == LeaveStatus.pending) r,
      ];
      pending.sort((a, b) => a.startDate.compareTo(b.startDate));
      return pending;
    }, retry: (retryCount, error) => null);

/// Writes. Every mutation invalidates the lists that could now be stale — both
/// the person's own and the branch queue, since an approval changes both.
final leaveActionsProvider = Provider<LeaveActions>(LeaveActions.new);

class LeaveActions {
  LeaveActions(this._ref);

  final Ref _ref;

  /// Books leave for [employeeId].
  ///
  /// [days] is computed here from the type and the dates rather than taken from
  /// the caller, so the stored figure and the balance can never be derived by two
  /// different rules. The row is always filed pending — the RLS insert policy
  /// requires it.
  Future<LeaveRequest> submit({
    required String employeeId,
    required String businessId,
    required String branchId,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    String reason = '',
    String? requestedBy,
  }) async {
    final saved = await _ref.read(leaveRepositoryProvider).submit(
      LeaveRequest(
        employeeId: employeeId,
        businessId: businessId,
        branchId: branchId,
        type: type,
        startDate: startDate,
        endDate: endDate,
        days: leaveDaysFor(type: type, start: startDate, end: endDate),
        reason: reason,
        requestedBy: requestedBy,
      ),
    );
    _invalidate(saved);
    return saved;
  }

  Future<LeaveRequest> approve({
    required LeaveRequest request,
    required String? decidedBy,
    String note = '',
  }) => _decide(request, LeaveStatus.approved, decidedBy, note);

  Future<LeaveRequest> reject({
    required LeaveRequest request,
    required String? decidedBy,
    String note = '',
  }) => _decide(request, LeaveStatus.rejected, decidedBy, note);

  Future<LeaveRequest> _decide(
    LeaveRequest request,
    LeaveStatus status,
    String? decidedBy,
    String note,
  ) async {
    final saved = await _ref.read(leaveRepositoryProvider).decide(
      id: request.id,
      status: status,
      decidedBy: decidedBy,
      note: note,
    );
    _invalidate(saved, previous: request);
    return saved;
  }

  /// Withdraws the caller's own pending request.
  Future<LeaveRequest> cancel(LeaveRequest request) async {
    final saved = await _ref.read(leaveRepositoryProvider).cancel(
      id: request.id,
    );
    _invalidate(saved, previous: request);
    return saved;
  }

  /// Refreshes both views a write can affect.
  ///
  /// [previous] matters when a decision moves the row's scope: the stored row is
  /// authoritative, but the copy the UI was holding is what the stale list keys
  /// were built from, so both branches are invalidated.
  void _invalidate(LeaveRequest saved, {LeaveRequest? previous}) {
    _ref.invalidate(employeeLeaveProvider(saved.employeeId));
    _ref.invalidate(branchLeaveProvider(saved.branchId));
    // The team queue is not keyed by branch, so it needs saying separately;
    // approvalsQueueProvider watches both and recomputes off them.
    _ref.invalidate(teamLeaveProvider);
    if (previous != null && previous.branchId != saved.branchId) {
      _ref.invalidate(branchLeaveProvider(previous.branchId));
    }
    _ref.invalidate(myLeaveProvider);
  }
}
