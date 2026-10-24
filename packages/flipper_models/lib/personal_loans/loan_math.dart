/// Loan arithmetic for personal mode: pure, so it is pinned by tests and the
/// same rules can be mirrored in data-connector (Flo).
///
/// Loans are modelled like Rwandan bank loans: a fixed monthly installment on
/// a reducing balance, interest accrued monthly at `annualRate / 12`. A rate
/// of 0 (family, most MoMo-style "fee" loans entered without a rate) is
/// plain subtraction.
library;

import 'dart:math' as math;

import 'package:flipper_models/personal_loans/personal_loan.dart';

/// Longest schedule we simulate: 50 years.
const int kMaxLoanMonths = 600;

/// A typed amount. A comma is a thousands separator only when it groups
/// digits in threes ("1,500,000", "1,500.50"); a single other comma is the
/// decimal mark ("1,5" is 1.5). Null for text that is not a number, never a
/// silently rescaled value.
double? parseLoanAmount(String text) {
  final t = text.replaceAll(' ', '').trim();
  if (RegExp(r'^\d{1,3}(,\d{3})+(\.\d+)?$').hasMatch(t)) {
    return double.tryParse(t.replaceAll(',', ''));
  }
  if (RegExp(r'^\d*,\d+$').hasMatch(t)) {
    return double.tryParse(t.replaceAll(',', '.'));
  }
  return double.tryParse(t);
}

/// A typed annual rate: a comma is always the decimal mark ("16,5" is 16.5).
double? parseLoanRate(String text) =>
    double.tryParse(text.replaceAll(' ', '').trim().replaceAll(',', '.'));

double monthlyRate(double? annualRatePct) =>
    annualRatePct == null || annualRatePct <= 0 ? 0 : annualRatePct / 1200;

/// Whole months from [from] to [to], counting a started month as one; never
/// negative.
int monthsBetween(DateTime from, DateTime to) {
  final months = (to.year - from.year) * 12 + (to.month - from.month);
  final adjusted = to.day > from.day ? months + 1 : months;
  return math.max(0, adjusted);
}

DateTime addMonths(DateTime d, int months) {
  final total = d.year * 12 + (d.month - 1) + months;
  final year = total ~/ 12;
  final month = total % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, math.min(d.day, lastDay));
}

/// The fixed installment that clears [principal] in [months] months.
double installmentFor({
  required double principal,
  required double? annualRatePct,
  required int months,
}) {
  if (months <= 0) return principal;
  final i = monthlyRate(annualRatePct);
  if (i == 0) return principal / months;
  return principal * i / (1 - math.pow(1 + i, -months));
}

/// What [months] installments of [payment] are worth today: the balance a
/// loan has when that many payments are left.
double presentValue({
  required double payment,
  required double? annualRatePct,
  required int months,
}) {
  if (months <= 0) return 0;
  final i = monthlyRate(annualRatePct);
  if (i == 0) return payment * months;
  return payment * (1 - math.pow(1 + i, -months)) / i;
}

/// Where a loan's balance is known from, in order of trust: a balance the
/// user entered, the amount borrowed on its start date, or an estimate from
/// the installment and the expected end ("I pay X until Y"), taken on the day
/// the loan was added. `null` when nothing gives a balance.
({double amount, DateTime at, bool estimated})? loanAnchor(PersonalLoan loan) {
  if (loan.balance != null && loan.balanceAt != null) {
    return (amount: loan.balance!, at: loan.balanceAt!, estimated: false);
  }
  if (loan.principal != null && loan.startDate != null) {
    return (amount: loan.principal!, at: loan.startDate!, estimated: false);
  }
  final payment = effectiveInstallment(loan);
  if (loan.endDate != null && payment != null && payment > 0) {
    final left = monthsBetween(loan.createdAt, loan.endDate!);
    return (
      amount: presentValue(
        payment: payment,
        annualRatePct: loan.annualRatePct,
        months: left,
      ),
      at: loan.createdAt,
      estimated: true,
    );
  }
  if (loan.principal != null) {
    return (amount: loan.principal!, at: loan.createdAt, estimated: false);
  }
  return null;
}

/// The monthly installment: entered, or derived from the amount and term.
double? effectiveInstallment(PersonalLoan loan) {
  final entered = loan.monthlyPayment;
  if (entered != null && entered > 0) return entered;
  final p = loan.principal;
  if (p == null || p <= 0) return null;
  int? months = loan.termMonths;
  if ((months == null || months <= 0) &&
      loan.startDate != null &&
      loan.endDate != null) {
    months = monthsBetween(loan.startDate!, loan.endDate!);
  }
  if (months == null || months <= 0) return null;
  return installmentFor(
    principal: p,
    annualRatePct: loan.annualRatePct,
    months: months,
  );
}

/// The balance on [now]: the anchor, plus interest for every month that
/// passed, minus every repayment recorded after the anchor. Never negative.
double? loanBalance(
  PersonalLoan loan,
  Iterable<PersonalLoanPayment> payments,
  DateTime now,
) {
  final anchor = loanAnchor(loan);
  if (anchor == null) return null;
  final i = monthlyRate(loan.annualRatePct);
  final after =
      payments
          .where((p) => p.loanId == loan.id && p.paidAt.isAfter(anchor.at))
          .toList()
        ..sort((a, b) => a.paidAt.compareTo(b.paidAt));
  var balance = anchor.amount;
  var next = 0;
  final months = math.min(monthsBetween(anchor.at, now), kMaxLoanMonths);
  for (var m = 1; m <= months; m++) {
    final accrual = addMonths(anchor.at, m);
    if (accrual.isAfter(now)) break;
    while (next < after.length && !after[next].paidAt.isAfter(accrual)) {
      balance -= after[next++].amount;
    }
    balance = math.max(0, balance);
    balance += balance * i;
  }
  while (next < after.length && !after[next].paidAt.isAfter(now)) {
    balance -= after[next++].amount;
  }
  return math.max(0, balance);
}

/// How the rest of a loan goes if [payment] is paid every month from now.
class LoanOutlook {
  const LoanOutlook({
    required this.balance,
    required this.payment,
    required this.monthsLeft,
    required this.payoffDate,
    required this.interestLeft,
    required this.neverEnds,
  });

  final double balance;
  final double? payment;

  /// Null when there is no installment to project with.
  final int? monthsLeft;
  final DateTime? payoffDate;

  /// Interest still to pay on this schedule.
  final double? interestLeft;

  /// The installment does not even cover the monthly interest.
  final bool neverEnds;

  bool get isCleared => balance <= 0.5;
}

LoanOutlook loanOutlook({
  required double balance,
  required double? payment,
  required double? annualRatePct,
  required DateTime now,
}) {
  if (balance <= 0.5) {
    return LoanOutlook(
      balance: 0,
      payment: payment,
      monthsLeft: 0,
      payoffDate: now,
      interestLeft: 0,
      neverEnds: false,
    );
  }
  if (payment == null || payment <= 0) {
    return LoanOutlook(
      balance: balance,
      payment: payment,
      monthsLeft: null,
      payoffDate: null,
      interestLeft: null,
      neverEnds: false,
    );
  }
  final i = monthlyRate(annualRatePct);
  if (i > 0 && payment <= balance * i) {
    return LoanOutlook(
      balance: balance,
      payment: payment,
      monthsLeft: null,
      payoffDate: null,
      interestLeft: null,
      neverEnds: true,
    );
  }
  var b = balance;
  var months = 0;
  var paid = 0.0;
  while (b > 0.5 && months < kMaxLoanMonths) {
    b += b * i;
    final pay = math.min(payment, b);
    b -= pay;
    paid += pay;
    months++;
  }
  return LoanOutlook(
    balance: balance,
    payment: payment,
    monthsLeft: months,
    payoffDate: addMonths(now, months),
    interestLeft: math.max(0, paid - balance),
    neverEnds: false,
  );
}

/// A loan with everything the screens show about it.
class LoanStatus {
  const LoanStatus({
    required this.loan,
    required this.balance,
    required this.estimated,
    required this.outlook,
    required this.paidThisMonth,
    required this.paidTotal,
  });

  final PersonalLoan loan;

  /// Null when the user gave nothing that yields a balance.
  final double? balance;

  /// The balance comes from "I pay X until Y" rather than real figures.
  final bool estimated;
  final LoanOutlook? outlook;
  final double paidThisMonth;
  final double paidTotal;

  /// A month passed without a recorded repayment on an open loan.
  bool get repaymentDue =>
      loan.isOpen &&
      (balance ?? 1) > 0.5 &&
      (effectiveInstallment(loan) ?? 0) > 0 &&
      paidThisMonth <= 0;
}

LoanStatus loanStatus(
  PersonalLoan loan,
  Iterable<PersonalLoanPayment> payments,
  DateTime now,
) {
  final mine = payments.where((p) => p.loanId == loan.id).toList();
  final balance = loan.isOpen ? loanBalance(loan, mine, now) : 0.0;
  final monthStart = DateTime(now.year, now.month);
  return LoanStatus(
    loan: loan,
    balance: balance,
    estimated: loanAnchor(loan)?.estimated ?? false,
    outlook: balance == null
        ? null
        : loanOutlook(
            balance: balance,
            payment: effectiveInstallment(loan),
            annualRatePct: loan.annualRatePct,
            now: now,
          ),
    paidThisMonth: mine
        .where((p) => !p.paidAt.isBefore(monthStart) && !p.paidAt.isAfter(now))
        .fold(0, (s, p) => s + p.amount),
    paidTotal: mine.fold(0, (s, p) => s + p.amount),
  );
}

/// All open loans together.
class LoansOverview {
  const LoansOverview({
    required this.totalOwed,
    required this.monthlyPayments,
    required this.lastPayoff,
    required this.loans,
  });

  final double totalOwed;

  /// What open loans take every month.
  final double monthlyPayments;

  /// When the last open loan is projected to be cleared. Null when there is
  /// no open loan, or when any open loan has no projected payoff.
  final DateTime? lastPayoff;
  final List<LoanStatus> loans;
}

LoansOverview loansOverview(Iterable<LoanStatus> statuses) {
  final open = statuses.where((s) => s.loan.isOpen).toList();
  DateTime? last;
  for (final s in open) {
    final d = s.outlook?.payoffDate;
    // An open loan with no projected end (no balance, no installment, or one
    // that never covers the interest): no debt-free date can be promised.
    if (d == null) {
      last = null;
      break;
    }
    if (last == null || d.isAfter(last)) last = d;
  }
  return LoansOverview(
    totalOwed: open.fold(0, (sum, s) => sum + (s.balance ?? 0)),
    monthlyPayments: open
        .where((s) => (s.balance ?? 1) > 0.5)
        .fold(0, (sum, s) => sum + (effectiveInstallment(s.loan) ?? 0)),
    lastPayoff: last,
    loans: statuses.toList(),
  );
}

/// How a new loan would sit next to what the user earns, spends and already
/// repays every month.
enum Affordability { comfortable, tight, risky, notCovered, unknown }

class AffordabilityCheck {
  const AffordabilityCheck({
    required this.newInstallment,
    required this.existingInstallments,
    required this.avgIncome,
    required this.avgSpending,
    required this.leftOver,
    required this.debtShare,
    required this.verdict,
    required this.outlook,
  });

  final double newInstallment;
  final double existingInstallments;

  /// Monthly averages over the months given, loans themselves excluded.
  final double avgIncome;
  final double avgSpending;

  /// What remains each month after spending and every installment.
  final double leftOver;

  /// Share of income going to loan installments, new one included (0..1+).
  final double? debtShare;
  final Affordability verdict;
  final LoanOutlook outlook;
}

/// Thresholds: up to 30% of income on installments is comfortable, up to 40%
/// tight (the usual bank ceiling), above that risky; and nothing left at the
/// end of the month means the plan does not hold whatever the share.
AffordabilityCheck affordability({
  required double amount,
  required double? annualRatePct,
  required int months,
  required double existingInstallments,
  required double avgIncome,
  required double avgSpending,
  required DateTime now,
}) {
  final installment = installmentFor(
    principal: amount,
    annualRatePct: annualRatePct,
    months: months,
  );
  final totalInstallments = existingInstallments + installment;
  final leftOver = avgIncome - avgSpending - totalInstallments;
  final share = avgIncome > 0 ? totalInstallments / avgIncome : null;
  final Affordability verdict;
  if (avgIncome <= 0) {
    verdict = Affordability.unknown;
  } else if (leftOver < 0) {
    verdict = Affordability.notCovered;
  } else if (share! <= 0.30) {
    verdict = Affordability.comfortable;
  } else if (share <= 0.40) {
    verdict = Affordability.tight;
  } else {
    verdict = Affordability.risky;
  }
  return AffordabilityCheck(
    newInstallment: installment,
    existingInstallments: existingInstallments,
    avgIncome: avgIncome,
    avgSpending: avgSpending,
    leftOver: leftOver,
    debtShare: share,
    verdict: verdict,
    outlook: loanOutlook(
      balance: amount,
      payment: installment,
      annualRatePct: annualRatePct,
      now: now,
    ),
  );
}
