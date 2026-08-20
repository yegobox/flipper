import 'package:flipper_hr/features/leave/data/leave_repository.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';

/// In-memory [LeaveRepository] for provider and widget tests.
///
/// Mirrors the real one where it matters: ids are assigned on insert, submissions
/// are forced to `pending`, the trigger's business/branch derivation is imitated
/// from [scopeOf], and a decision only lands on a request that is still pending —
/// which is the `.eq('status', 'pending')` guard Supabase applies.
class FakeLeaveRepository implements LeaveRepository {
  FakeLeaveRepository({
    List<LeaveRequest>? seed,
    this.failWith,
    Map<String, ({String businessId, String branchId})>? scopeOf,
  }) : _requests = [...?seed],
       _scopeOf = scopeOf ?? const {};

  final List<LeaveRequest> _requests;

  /// employee id → the business/branch the database trigger would stamp on.
  final Map<String, ({String businessId, String branchId})> _scopeOf;

  /// When set, every method throws this instead of doing any work.
  Object? failWith;

  int submitCount = 0;
  int _nextId = 1;

  List<LeaveRequest> get requests => List.unmodifiable(_requests);

  @override
  Future<List<LeaveRequest>> fetchForEmployee({
    required String employeeId,
  }) async {
    _maybeFail();
    return _sorted(_requests.where((r) => r.employeeId == employeeId));
  }

  @override
  Future<List<LeaveRequest>> fetchForBranch({required String branchId}) async {
    _maybeFail();
    return _sorted(_requests.where((r) => r.branchId == branchId));
  }

  @override
  Future<List<LeaveRequest>> fetchForEmployees({
    required List<String> employeeIds,
  }) async {
    _maybeFail();
    // No ids means nobody's queue, not everybody's — the same short-circuit the
    // Supabase repository makes so an empty team cannot read as the whole table.
    if (employeeIds.isEmpty) return const [];
    final wanted = employeeIds.toSet();
    return _sorted(_requests.where((r) => wanted.contains(r.employeeId)));
  }

  @override
  Future<LeaveRequest> submit(LeaveRequest request) async {
    _maybeFail();
    submitCount++;
    final scope = _scopeOf[request.employeeId];
    final stored = request.copyWith(
      id: 'leave-${_nextId++}',
      status: LeaveStatus.pending,
      businessId: scope?.businessId ?? request.businessId,
      branchId: scope?.branchId ?? request.branchId,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
    _requests.add(stored);
    return stored;
  }

  @override
  Future<LeaveRequest> decide({
    required String id,
    required LeaveStatus status,
    required String? decidedBy,
    String note = '',
  }) async {
    _maybeFail();
    if (!status.isDecided) {
      throw LeaveRepositoryException('decide() takes approved or rejected.');
    }
    final index = _pendingIndexOf(id, status == LeaveStatus.approved
        ? 'approve'
        : 'reject');
    final updated = _requests[index].copyWith(
      status: status,
      decidedBy: decidedBy,
      decidedAt: DateTime.utc(2026, 8, 18),
      decisionNote: note,
    );
    _requests[index] = updated;
    return updated;
  }

  @override
  Future<LeaveRequest> cancel({required String id}) async {
    _maybeFail();
    final index = _pendingIndexOf(id, 'withdraw');
    final updated = _requests[index].copyWith(
      status: LeaveStatus.cancelled,
      clearDecision: true,
    );
    _requests[index] = updated;
    return updated;
  }

  /// The `status = pending` guard, so tests can exercise the "somebody got there
  /// first" path the same way the database produces it.
  int _pendingIndexOf(String id, String verb) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index < 0) {
      throw LeaveRepositoryException('No such request: $id');
    }
    if (_requests[index].status != LeaveStatus.pending) {
      throw LeaveRepositoryException(
        'Could not $verb this request: it has already been decided or '
        'withdrawn.',
      );
    }
    return index;
  }

  List<LeaveRequest> _sorted(Iterable<LeaveRequest> rows) =>
      rows.toList()..sort((a, b) => b.startDate.compareTo(a.startDate));

  void _maybeFail() {
    final failure = failWith;
    if (failure != null) throw failure;
  }
}

/// Convenience builder — only the fields a test cares about need naming.
LeaveRequest leaveRequest({
  String id = 'leave-1',
  String employeeId = 'e-1',
  String businessId = 'biz-1',
  String branchId = 'branch-1',
  LeaveType type = LeaveType.annual,
  DateTime? startDate,
  DateTime? endDate,
  double? days,
  String reason = '',
  LeaveStatus status = LeaveStatus.pending,
  String? requestedBy,
  String? decidedBy,
  DateTime? decidedAt,
  String decisionNote = '',
}) {
  final start = startDate ?? DateTime(2026, 9, 7);
  final end = endDate ?? DateTime(2026, 9, 11);
  return LeaveRequest(
    id: id,
    employeeId: employeeId,
    businessId: businessId,
    branchId: branchId,
    type: type,
    startDate: start,
    endDate: end,
    days: days ?? 5,
    reason: reason,
    status: status,
    requestedBy: requestedBy,
    decidedBy: decidedBy,
    // Kept consistent with the constraint: a decided row must carry a timestamp.
    decidedAt: decidedAt ??
        (status.isDecided ? DateTime.utc(2026, 8, 1) : null),
    decisionNote: decisionNote,
  );
}
