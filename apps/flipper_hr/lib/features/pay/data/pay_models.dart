/// The pay book's records: payslips, payments, advances and advance requests.
///
/// Plain values mapped from `supabase/migrations/0011_hr_payroll.sql`. Amounts
/// are immutable once stored, so none of these has a `copyWith`: a correction
/// is a void plus a new record, never an edit.
library;

import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_row_mapper.dart';
import 'package:flipper_localize/flipper_localize.dart';

double _amount(Object? v) => EmployeeRowMapper.parseAmount(v);
DateTime _date(Object? v) =>
    EmployeeRowMapper.parseDate(v) ?? DateTime.utc(1970);
DateTime? _ts(Object? v) => EmployeeRowMapper.parseTimestamp(v);
String _str(Object? v) => v?.toString() ?? '';
String? _strOrNull(Object? v) {
  final s = v?.toString().trim();
  return (s == null || s.isEmpty) ? null : s;
}

enum PayslipStatus {
  unpaid('unpaid'),
  partiallyPaid('partially_paid'),
  paid('paid'),
  voided('void');

  const PayslipStatus(this.wire);
  final String wire;

  String get label {
    final l10n = FlipperL10n.current;
    return switch (this) {
      PayslipStatus.unpaid => l10n.hrPayStatusUnpaid,
      PayslipStatus.partiallyPaid => l10n.hrPayStatusPartlyPaid,
      PayslipStatus.paid => l10n.hrPayStatusPaid,
      PayslipStatus.voided => l10n.hrPayStatusVoid,
    };
  }

  static PayslipStatus fromWire(String? raw) => values.firstWhere(
    (v) => v.wire == raw,
    orElse: () => PayslipStatus.unpaid,
  );
}

/// What was earned for one period, and what was withheld from it.
class Payslip {
  const Payslip({
    required this.id,
    required this.employeeId,
    required this.periodStart,
    required this.periodEnd,
    required this.currency,
    required this.basePay,
    required this.allowances,
    required this.extraEarnings,
    required this.gross,
    required this.paye,
    required this.pensionEmployee,
    required this.maternityEmployee,
    required this.cbhi,
    required this.otherDeductions,
    required this.advanceRecovery,
    required this.netPay,
    required this.pensionEmployer,
    required this.maternityEmployer,
    required this.occupationalHazards,
    required this.paidAmount,
    required this.status,
    this.businessId = '',
    this.branchId = '',
    this.ratesVersion,
    this.workedMinutes,
    this.note,
    this.voidReason,
    this.createdAt,
  });

  factory Payslip.fromRow(Map<String, dynamic> row) => Payslip(
    id: _str(row['id']),
    businessId: _str(row['business_id']),
    branchId: _str(row['branch_id']),
    employeeId: _str(row['employee_id']),
    periodStart: _date(row['period_start']),
    periodEnd: _date(row['period_end']),
    currency: _strOrNull(row['currency']) ?? 'RWF',
    basePay: _amount(row['base_pay']),
    allowances: _amount(row['allowances']),
    extraEarnings: _amount(row['extra_earnings']),
    gross: _amount(row['gross']),
    paye: _amount(row['paye']),
    pensionEmployee: _amount(row['pension_employee']),
    maternityEmployee: _amount(row['maternity_employee']),
    cbhi: _amount(row['cbhi']),
    otherDeductions: _amount(row['other_deductions']),
    advanceRecovery: _amount(row['advance_recovery']),
    netPay: _amount(row['net_pay']),
    pensionEmployer: _amount(row['pension_employer']),
    maternityEmployer: _amount(row['maternity_employer']),
    occupationalHazards: _amount(row['occupational_hazards']),
    paidAmount: _amount(row['paid_amount']),
    status: PayslipStatus.fromWire(row['status'] as String?),
    ratesVersion: _strOrNull(row['rates_version']),
    workedMinutes: (row['worked_minutes'] as num?)?.toInt(),
    note: _strOrNull(row['note']),
    voidReason: _strOrNull(row['void_reason']),
    createdAt: _ts(row['created_at']),
  );

  final String id;
  final String businessId;
  final String branchId;
  final String employeeId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String currency;
  final double basePay;
  final double allowances;
  final double extraEarnings;
  final double gross;
  final double paye;
  final double pensionEmployee;
  final double maternityEmployee;
  final double cbhi;
  final double otherDeductions;
  final double advanceRecovery;
  final double netPay;
  final double pensionEmployer;
  final double maternityEmployer;
  final double occupationalHazards;
  final double paidAmount;
  final PayslipStatus status;
  final String? ratesVersion;
  final int? workedMinutes;
  final String? note;
  final String? voidReason;
  final DateTime? createdAt;

  bool get isVoid => status == PayslipStatus.voided;
  double get statutoryDeductions =>
      paye + pensionEmployee + maternityEmployee + cbhi;
  double get employerContributions =>
      pensionEmployer + maternityEmployer + occupationalHazards;
  double get outstanding => isVoid ? 0 : (netPay - paidAmount).clamp(0, netPay);
}

enum PaymentKind {
  salary('salary'),
  advance('advance'),
  reimbursement('reimbursement'),
  other('other');

  const PaymentKind(this.wire);
  final String wire;

  String get label {
    final l10n = FlipperL10n.current;
    return switch (this) {
      PaymentKind.salary => l10n.hrPayKindSalary,
      PaymentKind.advance => l10n.hrPayKindAdvance,
      PaymentKind.reimbursement => l10n.hrPayKindReimbursement,
      PaymentKind.other => l10n.hrPayKindOther,
    };
  }

  static PaymentKind fromWire(String? raw) =>
      values.firstWhere((v) => v.wire == raw, orElse: () => PaymentKind.other);
}

/// Money handed to a person.
class PayPayment {
  const PayPayment({
    required this.id,
    required this.employeeId,
    required this.kind,
    required this.amount,
    required this.currency,
    required this.paidOn,
    required this.method,
    this.reference,
    this.note,
    this.payslipId,
    this.advanceId,
    this.voided = false,
    this.voidReason,
    this.createdAt,
  });

  factory PayPayment.fromRow(Map<String, dynamic> row) => PayPayment(
    id: _str(row['id']),
    employeeId: _str(row['employee_id']),
    kind: PaymentKind.fromWire(row['kind'] as String?),
    amount: _amount(row['amount']),
    currency: _strOrNull(row['currency']) ?? 'RWF',
    paidOn: _date(row['paid_on']),
    method: PaymentMethod.fromWire(row['method'] as String?),
    reference: _strOrNull(row['reference']),
    note: _strOrNull(row['note']),
    payslipId: _strOrNull(row['payslip_id']),
    advanceId: _strOrNull(row['advance_id']),
    voided: row['voided_at'] != null,
    voidReason: _strOrNull(row['void_reason']),
    createdAt: _ts(row['created_at']),
  );

  final String id;
  final String employeeId;
  final PaymentKind kind;
  final double amount;
  final String currency;
  final DateTime paidOn;
  final PaymentMethod method;
  final String? reference;
  final String? note;
  final String? payslipId;
  final String? advanceId;
  final bool voided;
  final String? voidReason;
  final DateTime? createdAt;
}

enum AdvanceStatus {
  open('open'),
  recovered('recovered'),
  writtenOff('written_off'),
  voided('void');

  const AdvanceStatus(this.wire);
  final String wire;

  String get label {
    final l10n = FlipperL10n.current;
    return switch (this) {
      AdvanceStatus.open => l10n.hrAdvanceStatusOpen,
      AdvanceStatus.recovered => l10n.hrAdvanceStatusRecovered,
      AdvanceStatus.writtenOff => l10n.hrAdvanceStatusWrittenOff,
      AdvanceStatus.voided => l10n.hrPayStatusVoid,
    };
  }

  static AdvanceStatus fromWire(String? raw) =>
      values.firstWhere((v) => v.wire == raw, orElse: () => AdvanceStatus.open);
}

/// Money given ahead of pay: a debt the person owes until recovered.
class Advance {
  const Advance({
    required this.id,
    required this.employeeId,
    required this.amount,
    required this.currency,
    required this.givenOn,
    required this.method,
    required this.recovered,
    required this.status,
    this.reference,
    this.reason,
    this.installmentAmount,
    this.writeOffReason,
    this.voidReason,
    this.createdAt,
  });

  factory Advance.fromRow(Map<String, dynamic> row) => Advance(
    id: _str(row['id']),
    employeeId: _str(row['employee_id']),
    amount: _amount(row['amount']),
    currency: _strOrNull(row['currency']) ?? 'RWF',
    givenOn: _date(row['given_on']),
    method: PaymentMethod.fromWire(row['method'] as String?),
    recovered: _amount(row['recovered']),
    status: AdvanceStatus.fromWire(row['status'] as String?),
    reference: _strOrNull(row['reference']),
    reason: _strOrNull(row['reason']),
    installmentAmount: EmployeeRowMapper.parseOptionalAmount(
      row['installment_amount'],
    ),
    writeOffReason: _strOrNull(row['write_off_reason']),
    voidReason: _strOrNull(row['void_reason']),
    createdAt: _ts(row['created_at']),
  );

  final String id;
  final String employeeId;
  final double amount;
  final String currency;
  final DateTime givenOn;
  final PaymentMethod method;
  final double recovered;
  final AdvanceStatus status;
  final String? reference;
  final String? reason;

  /// At most this much is taken back per payslip. Null: all of it, next pay.
  final double? installmentAmount;
  final String? writeOffReason;
  final String? voidReason;
  final DateTime? createdAt;

  bool get isOpen => status == AdvanceStatus.open;

  /// Still owed. Zero once recovered, written off or voided.
  double get outstanding => isOpen ? (amount - recovered).clamp(0, amount) : 0;

  /// What the next payslip should take back, before the half-of-pay cap.
  double get suggestedRecovery {
    final owed = outstanding;
    final step = installmentAmount;
    return step == null ? owed : (step < owed ? step : owed);
  }
}

enum AdvanceRequestStatus {
  pending('pending'),
  approved('approved'),
  declined('declined'),
  cancelled('cancelled');

  const AdvanceRequestStatus(this.wire);
  final String wire;

  String get label {
    final l10n = FlipperL10n.current;
    return switch (this) {
      AdvanceRequestStatus.pending => l10n.hrLeaveStatusPending,
      AdvanceRequestStatus.approved => l10n.approved,
      AdvanceRequestStatus.declined => l10n.hrLeaveStatusRejected,
      AdvanceRequestStatus.cancelled => l10n.hrLeaveStatusCancelled,
    };
  }

  static AdvanceRequestStatus fromWire(String? raw) => values.firstWhere(
    (v) => v.wire == raw,
    orElse: () => AdvanceRequestStatus.pending,
  );
}

/// An employee asking for an advance.
class AdvanceRequest {
  const AdvanceRequest({
    required this.id,
    required this.employeeId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.reason,
    this.decisionNote,
    this.decidedAt,
    this.advanceId,
  });

  factory AdvanceRequest.fromRow(Map<String, dynamic> row) => AdvanceRequest(
    id: _str(row['id']),
    employeeId: _str(row['employee_id']),
    amount: _amount(row['amount']),
    status: AdvanceRequestStatus.fromWire(row['status'] as String?),
    createdAt: _ts(row['created_at']) ?? DateTime.utc(1970),
    reason: _strOrNull(row['reason']),
    decisionNote: _strOrNull(row['decision_note']),
    decidedAt: _ts(row['decided_at']),
    advanceId: _strOrNull(row['advance_id']),
  );

  final String id;
  final String employeeId;
  final double amount;
  final AdvanceRequestStatus status;
  final DateTime createdAt;
  final String? reason;
  final String? decisionNote;
  final DateTime? decidedAt;
  final String? advanceId;

  bool get isPending => status == AdvanceRequestStatus.pending;
}
