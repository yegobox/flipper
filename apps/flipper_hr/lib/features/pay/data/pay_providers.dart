import 'package:flipper_hr/features/attendance/data/attendance_providers.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/data/rwanda_payroll.dart';
import 'package:flipper_hr/features/pay/data/supabase_pay_repository.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The pay store. Overridden with a fake in tests.
final payRepositoryProvider = Provider<PayRepository>((ref) {
  return SupabasePayRepository(Supabase.instance.client);
});

/// How far back the branch pay book reads. Long enough for three missed
/// monthly periods and a year-to-date view of the current quarter.
const payBookWindow = Duration(days: 400);

/// The branch's pay book. Retry is off, as for the roster: the page offers
/// "Try again" instead of refetching invisibly.
final branchPayBookProvider = FutureProvider.family<PayBook, String>((
  ref,
  branchId,
) {
  final now = ref.watch(hrClockProvider)();
  return ref
      .watch(payRepositoryProvider)
      .fetchForBranch(branchId: branchId, since: now.subtract(payBookWindow));
}, retry: (retryCount, error) => null);

/// One person's whole pay book — their history page, or their own "My pay".
final employeePayBookProvider = FutureProvider.family<PayBook, String>((
  ref,
  employeeId,
) {
  return ref
      .watch(payRepositoryProvider)
      .fetchForEmployee(employeeId: employeeId);
}, retry: (retryCount, error) => null);

/// The signed-in person's own pay book. Null when they have no record.
final myPayBookProvider = FutureProvider<PayBook?>((ref) async {
  final me = await ref.watch(myEmployeeProvider.future);
  if (me == null) return null;
  return ref.watch(employeePayBookProvider(me.id).future);
}, retry: (retryCount, error) => null);

/// Where everyone on the branch stands: due periods, advances owed, last pay.
///
/// Terminated people are kept only while something is still open between them
/// and the business — an advance not recovered, or a payslip not fully paid.
final branchPayAccountsProvider =
    FutureProvider.family<List<EmployeePayAccount>, String>((
      ref,
      branchId,
    ) async {
      final roster = await ref.watch(rosterProvider(branchId).future);
      final book = await ref.watch(branchPayBookProvider(branchId).future);
      final today = ref.watch(hrClockProvider)();
      final accounts = [
        for (final e in roster)
          EmployeePayAccount(
            employee: e,
            payslips: book.payslips,
            payments: book.payments,
            advances: book.advances,
            today: today,
          ),
      ];
      return [
        for (final a in accounts)
          if (a.employee.status.isEmployed ||
              a.advanceBalance > 0 ||
              a.unpaidOnPayslips > 0)
            a,
      ];
    }, retry: (retryCount, error) => null);

/// Minutes worked by [EmployeePeriod.employeeId] in its period, from the
/// attendance board. Feeds hourly and daily pay.
class EmployeePeriod {
  const EmployeePeriod(this.employeeId, this.period);
  final String employeeId;
  final PayPeriod period;

  @override
  bool operator ==(Object other) =>
      other is EmployeePeriod &&
      other.employeeId == employeeId &&
      other.period == period;

  @override
  int get hashCode => Object.hash(employeeId, period);
}

/// Worked time in a period: total minutes and distinct days with a session.
class WorkedTime {
  const WorkedTime({required this.minutes, required this.days});
  final int minutes;
  final int days;
  double get hours => minutes / 60;
}

final workedTimeProvider = FutureProvider.family<WorkedTime, EmployeePeriod>((
  ref,
  key,
) async {
  final sessions = await ref
      .watch(attendanceRepositoryProvider)
      .fetchForEmployee(
        employeeId: key.employeeId,
        from: key.period.start,
        to: key.period.end,
      );
  final now = ref.watch(hrClockProvider)();
  var minutes = 0;
  final days = <DateTime>{};
  for (final s in sessions) {
    final m = s.minutesAsOf(now);
    if (m <= 0) continue;
    minutes += m;
    days.add(DateTime(s.workDate.year, s.workDate.month, s.workDate.day));
  }
  return WorkedTime(minutes: minutes, days: days.length);
}, retry: (retryCount, error) => null);

/// Totals across a set of payslips — the payroll summary and the monthly
/// statutory returns (PAYE to RRA, contributions to RSSB).
class PayrollTotals {
  PayrollTotals(Iterable<Payslip> payslips) {
    for (final p in payslips) {
      if (p.isVoid) continue;
      count++;
      gross += p.gross;
      net += p.netPay;
      paye += p.paye;
      pensionEmployee += p.pensionEmployee;
      pensionEmployer += p.pensionEmployer;
      maternityEmployee += p.maternityEmployee;
      maternityEmployer += p.maternityEmployer;
      occupationalHazards += p.occupationalHazards;
      cbhi += p.cbhi;
      recovered += p.advanceRecovery;
      paid += p.paidAmount;
    }
  }

  int count = 0;
  double gross = 0;
  double net = 0;
  double paye = 0;
  double pensionEmployee = 0;
  double pensionEmployer = 0;
  double maternityEmployee = 0;
  double maternityEmployer = 0;
  double occupationalHazards = 0;
  double cbhi = 0;
  double recovered = 0;
  double paid = 0;

  /// Everything owed to RSSB for these payslips.
  double get rssb =>
      pensionEmployee +
      pensionEmployer +
      maternityEmployee +
      maternityEmployer +
      occupationalHazards +
      cbhi;

  /// What the business pays out in total: gross plus employer contributions.
  double get employerCost =>
      gross + pensionEmployer + occupationalHazards + maternityEmployer;
}

/// Writes to the pay book. Every mutation invalidates the reads it affects, so
/// lists always show what Postgres stored.
final payActionsProvider = Provider<PayActions>(PayActions.new);

class PayActions {
  PayActions(this._ref);

  final Ref _ref;

  PayRepository get _repo => _ref.read(payRepositoryProvider);

  void _refresh(Employee e) {
    _ref.invalidate(branchPayBookProvider(e.branchId));
    _ref.invalidate(employeePayBookProvider(e.id));
    _ref.invalidate(myPayBookProvider);
  }

  Future<Payslip> pay({
    required Employee employee,
    required PayPeriod period,
    required PayslipFigures figures,
    List<AdvanceRecovery> recoveries = const [],
    PaymentDraft? payment,
    int? workedMinutes,
    String? note,
  }) async {
    try {
      return await _repo.createPayslip(
        employeeId: employee.id,
        periodStart: period.start,
        periodEnd: period.end,
        figures: figures,
        recoveries: recoveries,
        payment: payment,
        workedMinutes: workedMinutes,
        note: note,
      );
    } finally {
      _refresh(employee);
    }
  }

  Future<PayPayment> payBalance({
    required Employee employee,
    required Payslip payslip,
    required PaymentDraft payment,
  }) async {
    try {
      return await _repo.recordPayment(
        employeeId: employee.id,
        kind: PaymentKind.salary,
        amount: payment.amount,
        method: payment.method,
        paidOn: payment.paidOn,
        payslipId: payslip.id,
        reference: payment.reference,
      );
    } finally {
      _refresh(employee);
    }
  }

  Future<PayPayment> recordOther({
    required Employee employee,
    required PaymentKind kind,
    required PaymentDraft payment,
    String? note,
  }) async {
    try {
      return await _repo.recordPayment(
        employeeId: employee.id,
        kind: kind,
        amount: payment.amount,
        method: payment.method,
        paidOn: payment.paidOn,
        reference: payment.reference,
        note: note,
      );
    } finally {
      _refresh(employee);
    }
  }

  Future<Advance> giveAdvance({
    required Employee employee,
    required double amount,
    required PaymentMethod method,
    required DateTime givenOn,
    String? reference,
    String? reason,
    double? installmentAmount,
  }) async {
    try {
      return await _repo.giveAdvance(
        employeeId: employee.id,
        amount: amount,
        method: method,
        givenOn: givenOn,
        reference: reference,
        reason: reason,
        installmentAmount: installmentAmount,
      );
    } finally {
      _refresh(employee);
    }
  }

  Future<void> voidPayslip(Employee e, Payslip p, String reason) async {
    try {
      await _repo.voidPayslip(id: p.id, reason: reason);
    } finally {
      _refresh(e);
    }
  }

  Future<void> voidPayment(Employee e, PayPayment p, String reason) async {
    try {
      await _repo.voidPayment(id: p.id, reason: reason);
    } finally {
      _refresh(e);
    }
  }

  Future<void> voidAdvance(Employee e, Advance a, String reason) async {
    try {
      await _repo.voidAdvance(id: a.id, reason: reason);
    } finally {
      _refresh(e);
    }
  }

  Future<void> writeOffAdvance(Employee e, Advance a, String reason) async {
    try {
      await _repo.writeOffAdvance(id: a.id, reason: reason);
    } finally {
      _refresh(e);
    }
  }

  Future<void> requestAdvance(
    Employee me, {
    required double amount,
    String? reason,
  }) async {
    try {
      await _repo.requestAdvance(
        employeeId: me.id,
        amount: amount,
        reason: reason,
      );
    } finally {
      _refresh(me);
    }
  }

  Future<void> cancelRequest(Employee me, AdvanceRequest r) async {
    try {
      await _repo.cancelAdvanceRequest(id: r.id);
    } finally {
      _refresh(me);
    }
  }

  Future<void> approveRequest(
    Employee e,
    AdvanceRequest r, {
    required PaymentMethod method,
    String? decidedBy,
    String? reference,
    double? installmentAmount,
  }) async {
    try {
      await _repo.approveAdvanceRequest(
        id: r.id,
        method: method,
        decidedBy: decidedBy,
        reference: reference,
        installmentAmount: installmentAmount,
      );
    } finally {
      _refresh(e);
    }
  }

  Future<void> declineRequest(
    Employee e,
    AdvanceRequest r, {
    String? decidedBy,
    String? note,
  }) async {
    try {
      await _repo.declineAdvanceRequest(
        id: r.id,
        decidedBy: decidedBy,
        note: note,
      );
    } finally {
      _refresh(e);
    }
  }
}
