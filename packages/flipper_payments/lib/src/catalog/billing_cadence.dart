/// How often a subscription is billed.
///
/// The wire values are `plans.rule`, read by data-connector's `Rule::parse`
/// (`src/billing/proration.rs`). Anything it does not recognise bills monthly,
/// so a typo here would quietly bill a daily plan once a month.
enum BillingCadence {
  daily('daily'),
  monthly('monthly'),
  yearly('yearly');

  const BillingCadence(this.wireValue);

  /// The value written to `plans.rule`.
  final String wireValue;

  /// Reads a stored `plans.rule` back. Unknown and null bill monthly, matching
  /// the server's own fallback.
  static BillingCadence fromWire(String? value) =>
      switch (value?.trim().toLowerCase()) {
        'daily' || 'day' => BillingCadence.daily,
        'yearly' || 'annual' || 'annually' => BillingCadence.yearly,
        _ => BillingCadence.monthly,
      };

  /// The older monthly-or-yearly flag, which cannot express [daily].
  ///
  /// Still written to `plans.is_yearly_plan` because released clients read it;
  /// `rule` is what actually decides the cycle.
  bool get isYearly => this == BillingCadence.yearly;

  bool get isDaily => this == BillingCadence.daily;

  String get label => switch (this) {
        BillingCadence.daily => 'Daily',
        BillingCadence.monthly => 'Monthly',
        BillingCadence.yearly => 'Yearly',
      };

  /// Suffix for a price line: `5,000 RWF/month`.
  String get periodSuffix => switch (this) {
        BillingCadence.daily => '/day',
        BillingCadence.monthly => '/month',
        BillingCadence.yearly => '/year',
      };

  /// Days in one period, for the next billing date.
  int get periodDays => switch (this) {
        BillingCadence.daily => 1,
        BillingCadence.monthly => 30,
        BillingCadence.yearly => 365,
      };
}

/// Divisor turning a monthly price into a daily one.
///
/// A flat 30 rather than the length of the current month, so the daily price a
/// customer is quoted does not change between February and March. Must match
/// `DAYS_PER_MONTH_FOR_DAILY_PRICING` in `data-connector/src/billing/catalog.rs`.
const int kDaysPerMonthForDailyPricing = 30;

/// Monthly price → daily price, **rounded up**.
///
/// Rounding down would collect less over thirty daily charges than one monthly
/// charge for the same service — a loss on every daily subscriber. Matches
/// `Template::price_for_cadence` on the server; the two must agree to the franc,
/// because the server charges what it computes and the app only displays it.
int dailyPriceFromMonthly(int monthlyPrice) {
  if (monthlyPrice <= 0) return 0;
  return (monthlyPrice + kDaysPerMonthForDailyPricing - 1) ~/
      kDaysPerMonthForDailyPricing;
}
