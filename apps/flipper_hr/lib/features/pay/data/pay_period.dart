/// Pay periods, and the per-person pay picture built from the pay book.
///
/// This is the "remember how much I paid" answer: for each person, what the
/// current period owes them, what has already been handed over, what they
/// still owe back in advances, and when they were last paid.
library;

import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/people/data/employee.dart';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// A span of days a payslip covers, both ends inclusive.
class PayPeriod {
  const PayPeriod(this.start, this.end);

  final DateTime start;
  final DateTime end;

  int get days => _day(end).difference(_day(start)).inDays + 1;

  bool contains(DateTime d) {
    final x = _day(d);
    return !x.isBefore(_day(start)) && !x.isAfter(_day(end));
  }

  bool sameAs(DateTime s, DateTime e) =>
      _day(s) == _day(start) && _day(e) == _day(end);

  /// The period a person on [frequency] is in on [on].
  ///
  /// Monthly and hourly pay run by calendar month (hours are summed over the
  /// month); weekly and daily pay run Monday to Sunday (days are summed over
  /// the week, which is how casual workers are usually paid).
  factory PayPeriod.containing(PayFrequency frequency, DateTime on) {
    final d = _day(on);
    switch (frequency) {
      case PayFrequency.monthly:
      case PayFrequency.hourly:
        return PayPeriod(
          DateTime(d.year, d.month, 1),
          DateTime(d.year, d.month + 1, 0),
        );
      case PayFrequency.weekly:
      case PayFrequency.daily:
        final monday = d.subtract(Duration(days: d.weekday - DateTime.monday));
        return PayPeriod(monday, monday.add(const Duration(days: 6)));
    }
  }

  /// The period before this one, for the same [frequency].
  PayPeriod previous(PayFrequency frequency) =>
      PayPeriod.containing(frequency, start.subtract(const Duration(days: 1)));

  /// The period after this one, for the same [frequency].
  PayPeriod next(PayFrequency frequency) =>
      PayPeriod.containing(frequency, end.add(const Duration(days: 1)));

  /// The day this period is paid. Monthly pay honours the person's pay day
  /// (clamped to the month); every other period is paid on its last day.
  DateTime payDate(PayFrequency frequency, int? payDay) {
    if (frequency != PayFrequency.monthly || payDay == null) return _day(end);
    final last = DateTime(end.year, end.month + 1, 0).day;
    return DateTime(end.year, end.month, payDay > last ? last : payDay);
  }

  @override
  bool operator ==(Object other) =>
      other is PayPeriod && sameAs(other.start, other.end);

  @override
  int get hashCode => Object.hash(_day(start), _day(end));
}

/// The base pay a period earns, before allowances and statutory deductions.
///
/// [units] is days worked for daily pay and hours for hourly pay; ignored for
/// monthly and weekly pay, which earn the agreed salary for the period.
double basePayFor(Employee e, {double? units}) {
  return switch (e.payFrequency) {
    PayFrequency.monthly || PayFrequency.weekly => e.baseSalary,
    PayFrequency.daily || PayFrequency.hourly => e.baseSalary * (units ?? 0),
  };
}

/// Allowances for the period. They are stated monthly, so a weekly period
/// gets its share of the month.
double allowancesFor(Employee e, PayPeriod period) {
  if (e.allowances <= 0) return 0;
  return switch (e.payFrequency) {
    PayFrequency.monthly || PayFrequency.hourly => e.allowances,
    PayFrequency.weekly ||
    PayFrequency.daily => (e.allowances * 12 / 52).roundToDouble(),
  };
}

/// Where one person stands in the pay book.
class EmployeePayAccount {
  EmployeePayAccount({
    required this.employee,
    required List<Payslip> payslips,
    required List<PayPayment> payments,
    required List<Advance> advances,
    required DateTime today,
  }) : payslips = [
         for (final p in payslips)
           if (p.employeeId == employee.id) p,
       ]..sort((a, b) => b.periodEnd.compareTo(a.periodEnd)),
       payments = [
         for (final p in payments)
           if (p.employeeId == employee.id) p,
       ]..sort((a, b) => b.paidOn.compareTo(a.paidOn)),
       advances = [
         for (final a in advances)
           if (a.employeeId == employee.id) a,
       ]..sort((a, b) => b.givenOn.compareTo(a.givenOn)),
       today = _day(today);

  final Employee employee;
  final List<Payslip> payslips;
  final List<PayPayment> payments;
  final List<Advance> advances;
  final DateTime today;

  Iterable<Payslip> get livePayslips => payslips.where((p) => !p.isVoid);
  Iterable<PayPayment> get livePayments => payments.where((p) => !p.voided);
  Iterable<Advance> get openAdvances => advances.where((a) => a.isOpen);

  /// Everything still owed back in advances.
  double get advanceBalance =>
      openAdvances.fold(0.0, (sum, a) => sum + a.outstanding);

  /// Net pay on payslips not yet fully handed over.
  double get unpaidOnPayslips =>
      livePayslips.fold(0.0, (sum, p) => sum + p.outstanding);

  PayPayment? get lastPayment =>
      livePayments.isEmpty ? null : livePayments.first;

  /// Money handed over in [period]: salary, advances, anything else.
  double paidDuring(PayPeriod period) => livePayments
      .where((p) => period.contains(p.paidOn))
      .fold(0.0, (sum, p) => sum + p.amount);

  Payslip? payslipFor(PayPeriod period) {
    for (final p in livePayslips) {
      if (period.sameAs(p.periodStart, p.periodEnd)) return p;
    }
    return null;
  }

  /// The earliest period whose pay day has come without a payslip, or null
  /// when the person is up to date.
  ///
  /// The pay book's own history decides how far back to look. After the first
  /// payslip, every later period counts (up to [lookBack] periods ago), so a
  /// skipped month is never forgotten. Before it, only the most recent pay day
  /// does: an owner who starts using payroll today has already paid July by
  /// hand, and must not open the app to three months of "overdue".
  PayPeriod? firstUnpaidPeriod({int lookBack = 3}) {
    final freq = employee.payFrequency;
    final hired = _day(employee.hireDate);
    DateTime? lastSlipEnd;
    for (final s in livePayslips) {
      if (lastSlipEnd == null || s.periodEnd.isAfter(lastSlipEnd)) {
        lastSlipEnd = _day(s.periodEnd);
      }
    }

    final candidates = <PayPeriod>[];
    var p = PayPeriod.containing(freq, today);
    for (var i = 0; i <= lookBack; i++) {
      candidates.add(p);
      p = p.previous(freq);
    }

    final due = [
      for (final period in candidates.reversed)
        if (!period.end.isBefore(hired) &&
            !today.isBefore(period.payDate(freq, employee.payDay)) &&
            (lastSlipEnd == null || period.end.isAfter(lastSlipEnd)) &&
            payslipFor(period) == null)
          period,
    ];
    if (due.isEmpty) return null;
    return lastSlipEnd == null ? due.last : due.first;
  }

  /// The period the next payslip should cover: the oldest one that is due,
  /// else the current one.
  PayPeriod get nextPeriod =>
      firstUnpaidPeriod() ?? PayPeriod.containing(employee.payFrequency, today);

  /// The day the next payslip falls due.
  DateTime get nextPayDate =>
      nextPeriod.payDate(employee.payFrequency, employee.payDay);

  bool get isDue => employee.isActive && firstUnpaidPeriod() != null;

  /// Days until [nextPayDate]; negative when overdue.
  int get daysToPay => nextPayDate.difference(today).inDays;
}
