/// What the server says about a business's subscription, and what it costs.
///
/// Plain Dart with no Supabase in sight: the rules that decide whether the
/// roster opens are worth testing without a backend, and every one of them is a
/// pure function of the values below.
///
/// The wire shapes come from `supabase/migrations/0008_hr_billing.sql` —
/// `hr_access_state()`, `hr_plan_quote()` and `hr_start_subscription()`.
library;

/// Whether the business may use the paid surface, and why not when it may not.
enum HrAccessStatus {
  /// Still resolving, or nobody is signed in.
  unknown,

  /// Paid and current.
  entitled,

  /// A plan exists and is not paid — never paid, or lapsed.
  needsPayment,

  /// They manage a business, and it has no plan yet.
  needsSetup,

  /// Unpaid, but let in on one of a limited number of payment skips. Never
  /// confused with [entitled] — no money has moved.
  skipped,

  /// The session manages no business at all: an invited employee. There is
  /// nothing here for them to buy, and their own leave and timesheet stay open.
  noBusiness;

  static HrAccessStatus fromWire(String? value) =>
      switch (value?.trim().toLowerCase()) {
        'entitled' => HrAccessStatus.entitled,
        'needs_payment' => HrAccessStatus.needsPayment,
        'needs_setup' => HrAccessStatus.needsSetup,
        'skipped' => HrAccessStatus.skipped,
        'no_business' => HrAccessStatus.noBusiness,
        _ => HrAccessStatus.unknown,
      };
}

/// The seats and branches a tier covers, and what the business is using.
///
/// A null limit is unlimited — every tier that predates the Basic package has
/// no limits recorded, and must not read as "zero allowed".
class HrPlanAllowance {
  const HrPlanAllowance({
    this.maxPosUsers,
    this.maxBranches,
    this.maxHrEmployees,
    this.posUsersUsed = 0,
    this.branchesUsed = 0,
    this.employeesUsed = 0,
  });

  final int? maxPosUsers;
  final int? maxBranches;
  final int? maxHrEmployees;

  final int posUsersUsed;
  final int branchesUsed;
  final int employeesUsed;

  bool get hasLimits =>
      maxPosUsers != null || maxBranches != null || maxHrEmployees != null;

  /// True when the roster is at or past the seats this plan covers, so adding
  /// someone will be refused by `hr_employees_seat_cap`.
  bool get employeesExhausted =>
      maxHrEmployees != null && employeesUsed >= maxHrEmployees!;

  bool get posUsersExhausted =>
      maxPosUsers != null && posUsersUsed >= maxPosUsers!;

  bool get branchesExhausted =>
      maxBranches != null && branchesUsed >= maxBranches!;

  factory HrPlanAllowance.fromJson(Map<String, dynamic> json) {
    return HrPlanAllowance(
      maxPosUsers: _intOrNull(json['max_pos_users']),
      maxBranches: _intOrNull(json['max_branches']),
      maxHrEmployees: _intOrNull(json['max_hr_employees']),
      posUsersUsed: _int(json['pos_users_used']),
      branchesUsed: _int(json['branches_used']),
      employeesUsed: _int(json['employees_used']),
    );
  }
}

/// One answer to "may this business use Flipper HR, and until when?".
class HrAccessState {
  const HrAccessState({
    required this.status,
    this.enforced = true,
    this.schemaMissing = false,
    this.businessId,
    this.planId,
    this.planName,
    this.slug,
    this.isYearly = false,
    this.amountRwf,
    this.paymentStatus,
    this.phoneNumber,
    this.validUntil,
    this.graceDays = 0,
    this.testMode = false,
    this.allowance = const HrPlanAllowance(),
    this.skipsUsed = 0,
    this.maxPaymentSkips = 0,
    this.skipExpiresAt,
  });

  /// Startup and signed-out placeholder. Grants access: the state resolves in
  /// milliseconds and flashing a paywall at a paying customer on every cold
  /// start is worse than a beat of unlocked chrome.
  const HrAccessState.unknown() : this(status: HrAccessStatus.unknown);

  /// The billing schema is not installed on this project — migration 0008 has
  /// not been applied, so `hr_access_state()` does not exist.
  ///
  /// Opens the app up rather than locking every business out of a paywall it
  /// has no way to satisfy, and says so loudly instead: an unapplied migration
  /// used to be indistinguishable from "everybody is entitled", which is the
  /// state where nobody is billed and nothing explains why.
  const HrAccessState.schemaMissing()
    : this(
        status: HrAccessStatus.entitled,
        enforced: false,
        schemaMissing: true,
      );

  final HrAccessStatus status;

  /// False when there is no billing backend to enforce against. Screens use it
  /// to suppress any claim that a business is on a plan.
  final bool enforced;

  final bool schemaMissing;

  final String? businessId;
  final String? planId;
  final String? planName;
  final String? slug;
  final bool isYearly;

  /// What the current plan row is priced at, in RWF.
  final int? amountRwf;

  /// The processor's last word on the plan — `PENDING`, `COMPLETED`, `FAILED`.
  final String? paymentStatus;

  /// The number the last payment was made from, so a renewal does not have to
  /// retype it.
  final String? phoneNumber;

  /// End of the paid period.
  final DateTime? validUntil;

  final int graceDays;

  /// True when the project is quoting reduced amounts for testing.
  final bool testMode;

  final HrPlanAllowance allowance;

  /// Lifetime skips this business has already used.
  final int skipsUsed;

  /// Lifetime skips this business is allowed, from `hr_billing_settings`.
  /// Defaults to `0` — a server that predates migration 0009 does not send
  /// this key, and the safe reading of "no key" is "no skips available",
  /// never "unlimited".
  final int maxPaymentSkips;

  /// End of the current skip's grant, when [status] is [HrAccessStatus.skipped].
  final DateTime? skipExpiresAt;

  /// May the manager surfaces — roster, approvals, attendance — be opened?
  ///
  /// Someone who manages no business is let through: an invited employee has
  /// nothing to pay for, and their self-service pages resolve their own scope.
  /// A skip opens the door exactly like a real payment does — the distinction
  /// lives in [status], not in whether the door is open.
  bool get grantsAccess =>
      !enforced ||
      status == HrAccessStatus.unknown ||
      status == HrAccessStatus.entitled ||
      status == HrAccessStatus.skipped ||
      status == HrAccessStatus.noBusiness;

  /// True when there is a subscription to buy or renew.
  bool get needsPayment =>
      enforced &&
      (status == HrAccessStatus.needsPayment ||
          status == HrAccessStatus.needsSetup);

  /// True when the business is in the app right now on a skip, not a payment.
  bool get isSkipped => status == HrAccessStatus.skipped;

  /// Skips left to spend, floored at zero.
  int get skipsRemaining => (maxPaymentSkips - skipsUsed).clamp(0, maxPaymentSkips);

  /// True when a skip is on offer: payment is due and one is still available.
  bool get canSkipPayment => needsPayment && skipsRemaining > 0;

  /// Whole days left on the current skip, floored at zero. Null when not
  /// skipped or there is nothing to count down.
  int? skipDaysLeft({DateTime? now}) {
    final until = skipExpiresAt;
    if (until == null) return null;
    final hours = until.difference(now ?? DateTime.now()).inHours;
    return hours <= 0 ? 0 : (hours / 24).ceil();
  }

  /// A charge is in flight: the plan is unpaid but the processor has not
  /// finished with it. The paywall says "waiting for MTN" rather than offering
  /// a second debit.
  bool get isAwaitingSettlement =>
      needsPayment && (paymentStatus?.trim().toUpperCase() == 'PENDING');

  /// True when the plan was paid once and the period has run out, as opposed to
  /// never having been paid at all. Only the wording differs, but "your
  /// subscription has lapsed" and "choose a plan" are not the same message.
  bool get hasLapsed =>
      status == HrAccessStatus.needsPayment && validUntil != null;

  /// Whole days left in the paid period, floored at zero. Null when there is no
  /// period to count down.
  int? daysLeft({DateTime? now}) {
    final until = validUntil;
    if (until == null) return null;
    final hours = until.difference(now ?? DateTime.now()).inHours;
    return hours <= 0 ? 0 : (hours / 24).ceil();
  }

  factory HrAccessState.fromJson(Map<String, dynamic> json) {
    return HrAccessState(
      status: HrAccessStatus.fromWire(json['status'] as String?),
      businessId: _string(json['business_id']),
      planId: _string(json['plan_id']),
      planName: _string(json['plan_name']),
      slug: _string(json['slug']),
      isYearly: json['is_yearly'] == true,
      amountRwf: _intOrNull(json['amount_rwf']),
      paymentStatus: _string(json['payment_status']),
      phoneNumber: _string(json['phone_number']),
      validUntil: _dateTime(json['valid_until']),
      graceDays: _int(json['grace_days']),
      testMode: json['test_mode'] == true,
      allowance: HrPlanAllowance.fromJson(json),
      skipsUsed: _int(json['skips_used']),
      maxPaymentSkips: _int(json['max_payment_skips']),
      skipExpiresAt: _dateTime(json['skip_expires_at']),
    );
  }
}

/// What a subscription costs, priced by the server.
///
/// The app never proposes an amount. It asks for a quote, shows exactly that,
/// and `hr_start_subscription()` writes the same figure onto the plan row that
/// data-connector will charge — so a modified build cannot buy the Basic
/// package for 1 RWF.
class HrPlanQuote {
  const HrPlanQuote({
    required this.businessId,
    required this.templateId,
    required this.slug,
    required this.name,
    required this.amountRwf,
    required this.monthlyPrice,
    this.description,
    this.features = const [],
    this.isYearly = false,
    this.fullAmountRwf,
    this.testMode = false,
    this.periodDays = 30,
    this.allowance = const HrPlanAllowance(),
  });

  final String businessId;
  final String templateId;
  final String slug;
  final String name;
  final String? description;
  final List<String> features;

  final int monthlyPrice;
  final bool isYearly;

  /// What will actually be collected. Equals [fullAmountRwf] unless test
  /// pricing is on.
  final int amountRwf;

  /// What the plan really costs, kept so a test charge can be shown next to the
  /// figure it stands in for.
  final int? fullAmountRwf;

  final bool testMode;
  final int periodDays;
  final HrPlanAllowance allowance;

  String get periodLabel => isYearly ? 'per year' : 'per month';

  factory HrPlanQuote.fromJson(Map<String, dynamic> json) {
    return HrPlanQuote(
      businessId: _string(json['business_id']) ?? '',
      templateId: _string(json['template_id']) ?? '',
      slug: _string(json['slug']) ?? '',
      name: _string(json['name']) ?? '',
      description: _string(json['description']),
      features: [
        for (final f in (json['features'] as List?) ?? const []) f.toString(),
      ],
      monthlyPrice: _int(json['monthly_price']),
      isYearly: json['is_yearly'] == true,
      amountRwf: _int(json['amount_rwf']),
      fullAmountRwf: _intOrNull(json['full_amount_rwf']),
      testMode: json['test_mode'] == true,
      periodDays: _int(json['period_days']),
      allowance: HrPlanAllowance.fromJson(json),
    );
  }
}

/// The plan row `hr_start_subscription()` created or re-pointed, and the amount
/// it was written at — which is what `payNow` will collect.
class HrSubscriptionStart {
  const HrSubscriptionStart({
    required this.planId,
    required this.amountRwf,
    this.alreadyActive = false,
    this.quote,
  });

  final String planId;
  final int amountRwf;

  /// True when the business was already paid up, so nothing was changed. The
  /// caller shows the roster instead of charging again.
  final bool alreadyActive;

  final HrPlanQuote? quote;

  factory HrSubscriptionStart.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'];
    return HrSubscriptionStart(
      planId: _string(json['plan_id']) ?? '',
      amountRwf: _int(json['amount_rwf']),
      alreadyActive: json['already_active'] == true,
      quote: quote is Map
          ? HrPlanQuote.fromJson(Map<String, dynamic>.from(quote))
          : null,
    );
  }
}

/// `350000` → `350,000`. Money with no separators is money nobody can read at a
/// glance, and this figure is the one a business is about to approve on their
/// handset.
String formatRwf(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer(amount < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String? _string(Object? value) {
  final text = value?.toString().trim();
  return (text == null || text.isEmpty) ? null : text;
}

int _int(Object? value) => switch (value) {
  final num n => n.round(),
  final String s => int.tryParse(s.trim()) ?? 0,
  _ => 0,
};

int? _intOrNull(Object? value) => switch (value) {
  final num n => n.round(),
  final String s => int.tryParse(s.trim()),
  _ => null,
};

DateTime? _dateTime(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString())?.toLocal();
}
