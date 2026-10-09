/// Rwanda's statutory payroll arithmetic: PAYE, RSSB pension, maternity,
/// occupational hazards and CBHI.
///
/// Pure and dated. Every figure comes from a [RwandaRates] chosen by the
/// period's end date, so a payslip for December 2026 and one for January 2027
/// use the rates in force for each, and the rate set's [RwandaRates.version] is
/// stored on the payslip (`hr_payslips.rates_version`).
///
/// Sources (checked October 2026):
///   * PAYE bands — Income Tax Law 027/2022, in full from 1 Nov 2023:
///     0–60,000 at 0%, 60,001–100,000 at 10%, 100,001–200,000 at 20%, above at
///     30%; casual labourers 15% above 60,000; a second employer 30% flat.
///     Pension contributions are NOT deducted before PAYE (PwC worked example).
///   * RSSB pension — Presidential Order 086/01 of 12/12/2024: 6% + 6% from
///     2025, then +1 point each side every January to 10% + 10% in 2030, on
///     total gross (transport allowance included since 2025).
///   * Maternity 0.3% + 0.3% on gross excluding transport/compensatory
///     allowances; occupational hazards 2% employer on gross; CBHI 0.5% of the
///     employee's net (Prime Minister's Order 034/01 of 13/01/2020).
///   * Law 66/2018 art. 73: at most half the salary may be withheld to repay an
///     advance or a loan.
///
/// The database re-checks that every stored payslip adds up and that recovery
/// stays within that half (migration 0011), so this file decides the figures
/// but cannot store a payslip that does not balance.
library;

import 'dart:math' as math;

import 'package:flipper_hr/features/people/data/employee.dart';

/// One PAYE band: income up to [upTo] (inclusive, monthly) taxed at [rate].
/// The last band has a null [upTo].
class PayeBand {
  const PayeBand(this.upTo, this.rate);
  final double? upTo;
  final double rate;
}

/// The statutory rates in force from [effectiveFrom].
class RwandaRates {
  const RwandaRates({
    required this.version,
    required this.effectiveFrom,
    required this.pensionEmployee,
    required this.pensionEmployer,
    this.payeBands = standardPayeBands,
    this.casualThreshold = 60000,
    this.casualRate = 0.15,
    this.secondaryRate = 0.30,
    this.maternityEmployee = 0.003,
    this.maternityEmployer = 0.003,
    this.occupationalHazards = 0.02,
    this.cbhi = 0.005,
    this.maxRecoveryShare = 0.5,
  });

  final String version;
  final DateTime effectiveFrom;
  final List<PayeBand> payeBands;
  final double casualThreshold;
  final double casualRate;
  final double secondaryRate;
  final double pensionEmployee;
  final double pensionEmployer;
  final double maternityEmployee;
  final double maternityEmployer;
  final double occupationalHazards;
  final double cbhi;
  final double maxRecoveryShare;

  static const standardPayeBands = [
    PayeBand(60000, 0),
    PayeBand(100000, 0.10),
    PayeBand(200000, 0.20),
    PayeBand(null, 0.30),
  ];

  /// Every rate set, oldest first. Add a new entry when the law changes;
  /// never edit one that payslips have already been computed with.
  static final List<RwandaRates> schedule = [
    RwandaRates(
      version: 'RW-2025-01',
      effectiveFrom: DateTime(2025),
      pensionEmployee: 0.06,
      pensionEmployer: 0.06,
    ),
    RwandaRates(
      version: 'RW-2027-01',
      effectiveFrom: DateTime(2027),
      pensionEmployee: 0.07,
      pensionEmployer: 0.07,
    ),
    RwandaRates(
      version: 'RW-2028-01',
      effectiveFrom: DateTime(2028),
      pensionEmployee: 0.08,
      pensionEmployer: 0.08,
    ),
    RwandaRates(
      version: 'RW-2029-01',
      effectiveFrom: DateTime(2029),
      pensionEmployee: 0.09,
      pensionEmployer: 0.09,
    ),
    RwandaRates(
      version: 'RW-2030-01',
      effectiveFrom: DateTime(2030),
      pensionEmployee: 0.10,
      pensionEmployer: 0.10,
    ),
  ];

  /// The rates for a period ending on [periodEnd]. Periods before 2025 use the
  /// earliest set — HR did not exist then, so there is nothing to recompute.
  static RwandaRates forDate(DateTime periodEnd) {
    var chosen = schedule.first;
    for (final rates in schedule) {
      if (!periodEnd.isBefore(rates.effectiveFrom)) chosen = rates;
    }
    return chosen;
  }
}

/// What goes into one payslip.
class PayslipInput {
  const PayslipInput({
    required this.basePay,
    required this.periodStart,
    required this.periodEnd,
    this.allowances = 0,
    this.extraEarnings = 0,
    this.otherDeductions = 0,
    this.taxCategory = TaxCategory.primary,
    this.rssbEnrolled = true,
  });

  /// Earned for the period itself: the monthly salary, or rate × days/hours.
  final double basePay;

  /// Fixed allowances for the period. Taxable and pensionable; excluded from
  /// the maternity base.
  final double allowances;

  /// One-off earnings: bonus, overtime, commission. Fully taxable.
  final double extraEarnings;

  /// Non-statutory deductions other than advance recovery (a loan, a fine the
  /// contract allows). Counted against the half-of-pay limit.
  final double otherDeductions;

  final DateTime periodStart;
  final DateTime periodEnd;
  final TaxCategory taxCategory;
  final bool rssbEnrolled;
}

/// Every figure on a payslip except the advance recovery, which the person
/// paying chooses within [maxRecovery].
class PayslipFigures {
  const PayslipFigures({
    required this.rates,
    required this.basePay,
    required this.allowances,
    required this.extraEarnings,
    required this.paye,
    required this.pensionEmployee,
    required this.maternityEmployee,
    required this.cbhi,
    required this.otherDeductions,
    required this.pensionEmployer,
    required this.maternityEmployer,
    required this.occupationalHazards,
  });

  final RwandaRates rates;
  final double basePay;
  final double allowances;
  final double extraEarnings;
  final double paye;
  final double pensionEmployee;
  final double maternityEmployee;
  final double cbhi;
  final double otherDeductions;
  final double pensionEmployer;
  final double maternityEmployer;
  final double occupationalHazards;

  double get gross => basePay + allowances + extraEarnings;

  /// What the law takes from the employee.
  double get statutoryDeductions =>
      paye + pensionEmployee + maternityEmployee + cbhi;

  /// Take-home before any advance is recovered.
  double get netBeforeRecovery => gross - statutoryDeductions - otherDeductions;

  /// What the employer pays on top of gross.
  double get employerContributions =>
      pensionEmployer + maternityEmployer + occupationalHazards;

  /// What this person costs the business for the period.
  double get employerCost => gross + employerContributions;

  /// The most that may be withheld to repay advances (Law 66/2018 art. 73):
  /// half of pay after compulsory deductions, less any other deduction.
  /// Rounded down, so the database's check can never be off by a franc.
  double get maxRecovery => math.max(
    0,
    (rates.maxRecoveryShare * (gross - statutoryDeductions)).floorToDouble() -
        otherDeductions,
  );

  /// Net pay once [recovery] has been taken back.
  double netAfter(double recovery) => netBeforeRecovery - recovery;
}

/// Computes a payslip's statutory figures.
///
/// Amounts are whole francs: RWF has no minor unit in practice, and rounding
/// each line the way it is printed is what makes the payslip add up on paper.
PayslipFigures computeRwandaPayslip(PayslipInput input) {
  final rates = RwandaRates.forDate(input.periodEnd);
  final base = _whole(input.basePay);
  final allowances = _whole(input.allowances);
  final extra = _whole(input.extraEarnings);
  final gross = base + allowances + extra;

  // PAYE bands are monthly. A shorter period (a week, a day) has its bands
  // shrunk in proportion, so a casual paid weekly is not taxed as if each
  // week were a month.
  final factor = periodBandFactor(input.periodStart, input.periodEnd);
  final paye = _whole(switch (input.taxCategory) {
    TaxCategory.primary => _bandedTax(gross, rates.payeBands, factor),
    TaxCategory.casual =>
      math.max(0, gross - rates.casualThreshold * factor) * rates.casualRate,
    TaxCategory.secondary => gross * rates.secondaryRate,
  });

  final enrolled = input.rssbEnrolled;
  final maternityBase = base + extra;
  final pensionEe = enrolled ? _whole(gross * rates.pensionEmployee) : 0.0;
  final pensionEr = enrolled ? _whole(gross * rates.pensionEmployer) : 0.0;
  final maternityEe = enrolled
      ? _whole(maternityBase * rates.maternityEmployee)
      : 0.0;
  final maternityEr = enrolled
      ? _whole(maternityBase * rates.maternityEmployer)
      : 0.0;
  final hazards = enrolled ? _whole(gross * rates.occupationalHazards) : 0.0;

  // CBHI is 0.5% of what is left after the other compulsory deductions.
  final cbhi = _whole(
    math.max(0, gross - paye - pensionEe - maternityEe) * rates.cbhi,
  );

  return PayslipFigures(
    rates: rates,
    basePay: base,
    allowances: allowances,
    extraEarnings: extra,
    paye: paye,
    pensionEmployee: pensionEe,
    maternityEmployee: maternityEe,
    cbhi: cbhi,
    otherDeductions: _whole(input.otherDeductions),
    pensionEmployer: pensionEr,
    maternityEmployer: maternityEr,
    occupationalHazards: hazards,
  );
}

/// 1 for a whole calendar month (or longer); otherwise the period's share of a
/// 30-day month.
double periodBandFactor(DateTime start, DateTime end) {
  final s = DateTime(start.year, start.month, start.day);
  final e = DateTime(end.year, end.month, end.day);
  final days = e.difference(s).inDays + 1;
  final lastOfMonth = DateTime(s.year, s.month + 1, 0).day;
  final wholeMonth =
      s.day == 1 &&
      e.year == s.year &&
      e.month == s.month &&
      e.day == lastOfMonth;
  if (wholeMonth || days >= 28) return 1;
  return days / 30;
}

double _bandedTax(double income, List<PayeBand> bands, double factor) {
  var tax = 0.0;
  var lower = 0.0;
  for (final band in bands) {
    final upper = band.upTo == null ? double.infinity : band.upTo! * factor;
    if (income > lower) {
      tax += (math.min(income, upper) - lower) * band.rate;
    }
    lower = upper;
  }
  return tax;
}

double _whole(num value) => value.toDouble().roundToDouble();
