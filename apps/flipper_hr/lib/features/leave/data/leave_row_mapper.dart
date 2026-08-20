import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/people/data/employee_row_mapper.dart';

/// Maps `hr_leave_requests` rows to and from [LeaveRequest].
///
/// Date and number coercion is reused from [EmployeeRowMapper] rather than
/// rewritten — PostgREST's looseness about `numeric` and `date` is the same on
/// this table, and two copies of that logic would drift.
///
/// Column names must match `supabase/migrations/0004_hr_leave.sql`.
class LeaveRowMapper {
  LeaveRowMapper._();

  static LeaveRequest fromRow(Map<String, dynamic> row) {
    return LeaveRequest(
      id: _str(row['id']),
      employeeId: _str(row['employee_id']),
      businessId: _str(row['business_id']),
      branchId: _str(row['branch_id']),
      type: LeaveType.fromWire(row['leave_type'] as String?),
      // A row with no dates should still list rather than break the page; the
      // epoch reads as obviously-unset.
      startDate: EmployeeRowMapper.parseDate(row['start_date']) ??
          DateTime.utc(1970),
      endDate: EmployeeRowMapper.parseDate(row['end_date']) ??
          DateTime.utc(1970),
      days: EmployeeRowMapper.parseAmount(row['days']),
      reason: _str(row['reason']),
      status: LeaveStatus.fromWire(row['status'] as String?),
      requestedBy: _strOrNull(row['requested_by']),
      decidedBy: _strOrNull(row['decided_by']),
      decidedAt: EmployeeRowMapper.parseTimestamp(row['decided_at']),
      decisionNote: _str(row['decision_note']),
      createdAt: EmployeeRowMapper.parseTimestamp(row['created_at']),
      updatedAt: EmployeeRowMapper.parseTimestamp(row['updated_at']),
    );
  }

  /// Row for an INSERT.
  ///
  /// `business_id` and `branch_id` are sent even though the database trigger
  /// overwrites them from the employee's row: they are NOT NULL, so the insert
  /// has to carry something, and sending the client's best guess keeps the
  /// failure legible if the trigger is ever missing. `status` is always
  /// `pending` — the RLS insert policy requires it, and a client that could
  /// choose would be able to file pre-approved leave.
  static Map<String, dynamic> toInsertRow(LeaveRequest r) => {
    'employee_id': r.employeeId,
    'business_id': r.businessId,
    'branch_id': r.branchId,
    'leave_type': r.type.wire,
    'start_date': EmployeeRowMapper.formatDate(r.startDate),
    'end_date': EmployeeRowMapper.formatDate(r.endDate),
    'days': r.days,
    'reason': r.reason.trim(),
    'status': LeaveStatus.pending.wire,
    'requested_by': _nullIfBlank(r.requestedBy ?? ''),
  };

  /// Patch for a decision. `decided_at` is set for approve/reject and left null
  /// for a cancellation, which the `hr_leave_decision_is_complete` constraint
  /// requires.
  static Map<String, dynamic> toDecisionRow({
    required LeaveStatus status,
    String? decidedBy,
    String note = '',
    DateTime? decidedAt,
  }) {
    final now = (decidedAt ?? DateTime.now()).toUtc();
    return {
      'status': status.wire,
      'decided_by': status.isDecided ? _nullIfBlank(decidedBy ?? '') : null,
      'decided_at': status.isDecided ? now.toIso8601String() : null,
      'decision_note': status.isDecided ? note.trim() : '',
      'updated_at': now.toIso8601String(),
    };
  }

  static String _str(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final s = value.toString();
    return s.isEmpty ? fallback : s;
  }

  static String? _strOrNull(Object? value) {
    final s = value?.toString().trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  static String? _nullIfBlank(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
