import 'package:flipper_hr/features/leave/data/leave_type.dart';

/// Where a request stands. One decision per request, recorded on the request
/// itself — see the table comment in `0004_hr_leave.sql`.
enum LeaveStatus {
  pending('pending', 'Pending'),
  approved('approved', 'Approved'),
  rejected('rejected', 'Rejected'),

  /// Withdrawn by the person who asked, before anyone decided.
  cancelled('cancelled', 'Cancelled');

  const LeaveStatus(this.wire, this.label);

  final String wire;
  final String label;

  /// True once someone has approved or rejected it. A decided request is
  /// read-only for everybody.
  bool get isDecided =>
      this == LeaveStatus.approved || this == LeaveStatus.rejected;

  /// Days that are still committed against the balance: approved days are spent,
  /// and pending days are reserved so two overlapping requests cannot both look
  /// affordable. Rejected and cancelled days cost nothing.
  bool get holdsBalance =>
      this == LeaveStatus.approved || this == LeaveStatus.pending;

  static LeaveStatus fromWire(String? raw) {
    if (raw == null) return LeaveStatus.pending;
    final needle = raw.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    for (final s in values) {
      if (s.wire == needle) return s;
    }
    return LeaveStatus.pending;
  }
}

/// One leave request.
///
/// [id] is empty until Postgres assigns one, matching how [Employee] works.
/// [businessId] and [branchId] are set by a database trigger from the employee's
/// row, so a value sent from here is advisory — the stored row is authoritative
/// and every write reads it back.
class LeaveRequest {
  const LeaveRequest({
    this.id = '',
    required this.employeeId,
    this.businessId = '',
    this.branchId = '',
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.days,
    this.reason = '',
    this.status = LeaveStatus.pending,
    this.requestedBy,
    this.decidedBy,
    this.decidedAt,
    this.decisionNote = '',
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String employeeId;
  final String businessId;
  final String branchId;
  final LeaveType type;

  /// First and last day off, both inclusive.
  final DateTime startDate;
  final DateTime endDate;

  /// Days charged, in [type]'s unit. Computed by `leaveDaysFor`, stored so the
  /// figure the request was approved on cannot be re-derived differently later.
  final double days;

  final String reason;
  final LeaveStatus status;

  /// `public.users.id` of whoever filed it — the employee, or the manager who
  /// filed on their behalf.
  final String? requestedBy;
  final String? decidedBy;
  final DateTime? decidedAt;
  final String decisionNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isPersisted => id.isNotEmpty;

  /// True when the period has not started yet, as of [asOf]. Upcoming leave is
  /// what a person actually wants to see on their own page.
  bool isUpcoming({required DateTime asOf}) =>
      startDate.isAfter(DateTime(asOf.year, asOf.month, asOf.day));

  /// The year a request is counted against: its start date's. A request that
  /// straddles New Year is charged wholly to the year it began in, which is the
  /// simple rule and the one that matches how the request was approved.
  int get accrualYear => startDate.year;

  LeaveRequest copyWith({
    String? id,
    String? employeeId,
    String? businessId,
    String? branchId,
    LeaveType? type,
    DateTime? startDate,
    DateTime? endDate,
    double? days,
    String? reason,
    LeaveStatus? status,
    String? requestedBy,
    String? decidedBy,
    DateTime? decidedAt,
    bool clearDecision = false,
    String? decisionNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LeaveRequest(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    businessId: businessId ?? this.businessId,
    branchId: branchId ?? this.branchId,
    type: type ?? this.type,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    days: days ?? this.days,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    requestedBy: requestedBy ?? this.requestedBy,
    decidedBy: clearDecision ? null : (decidedBy ?? this.decidedBy),
    decidedAt: clearDecision ? null : (decidedAt ?? this.decidedAt),
    decisionNote: clearDecision ? '' : (decisionNote ?? this.decisionNote),
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  List<Object?> get _props => [
    id,
    employeeId,
    businessId,
    branchId,
    type,
    startDate,
    endDate,
    days,
    reason,
    status,
    requestedBy,
    decidedBy,
    decidedAt,
    decisionNote,
    createdAt,
    updatedAt,
  ];

  @override
  bool operator ==(Object other) {
    if (other is! LeaveRequest) return false;
    final mine = _props;
    final theirs = other._props;
    for (var i = 0; i < mine.length; i++) {
      if (mine[i] != theirs[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_props);

  @override
  String toString() =>
      'LeaveRequest($id, ${type.wire}, $days d, ${status.wire})';
}
