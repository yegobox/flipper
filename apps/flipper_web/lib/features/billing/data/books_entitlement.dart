import 'package:flipper_payments/flipper_payments.dart';

/// Where a business stands with its Flipper subscription.
///
/// The verdict is read off the shared Supabase `plans` row — the same row the
/// mobile and desktop apps read — so a payment made on any one app opens all of
/// them. There is deliberately no web-only state here: anything Books decided
/// on its own would not be honoured by a phone reading the same row.
enum BooksAccessStatus {
  /// Not evaluated yet (no business chosen, or the read has not returned).
  unknown,

  /// Paid and inside the paid period.
  entitled,

  /// The business has never had a plan row. A fresh signup.
  noPlan,

  /// A plan exists but nothing has been paid on it.
  needsPayment,

  /// A payment was started and the gateway has not settled it yet.
  awaitingSettlement,

  /// The paid period ended.
  expired,
}

class BooksAccessState {
  const BooksAccessState({
    required this.status,
    this.plan,
    this.validUntil,
    this.waived = false,
  });

  const BooksAccessState.unknown() : this(status: BooksAccessStatus.unknown);

  final BooksAccessStatus status;

  /// The row the verdict was read from, when there was one.
  final Plan? plan;

  /// End of the paid period, when known.
  final DateTime? validUntil;

  /// True when access was granted without a paid row — the same waiver the
  /// mobile app applies to a default "Individual" business.
  final bool waived;

  /// Whether Books should open.
  ///
  /// `unknown` grants on purpose, mirroring `flipper_hr`: the gate shows a
  /// spinner while the read is in flight, and if the read *fails* the user is
  /// let in rather than locked out by an outage. The paywall is for businesses
  /// that have not paid, not for businesses we could not check.
  bool get grantsAccess =>
      status == BooksAccessStatus.unknown ||
      status == BooksAccessStatus.entitled;

  bool get needsPayment => !grantsAccess;

  bool get hasLapsed => status == BooksAccessStatus.expired;

  bool get isAwaitingSettlement =>
      status == BooksAccessStatus.awaitingSettlement;

  /// The number that paid last time, for pre-filling a renewal.
  String? get phoneNumber => plan?.phoneNumber;

  /// Whole days of paid service left; null when there is no paid period.
  int? daysLeft({DateTime? now}) {
    final until = validUntil;
    if (until == null) return null;
    final diff = until.difference(now ?? DateTime.now());
    return diff.isNegative ? 0 : diff.inDays;
  }

  @override
  String toString() =>
      'BooksAccessState(${status.name}, until=$validUntil, waived=$waived)';
}

/// Applies the mobile app's subscription rule to a plan row.
///
/// Mirrors `AuthMixin.hasActiveSubscription` in `flipper_models` — including
/// the waiver for a default Individual business — so the web and the phone
/// never disagree about whether the same business has paid:
///
/// * a business with `businessTypeId == 2` that is the user's default one is
///   never gated;
/// * no row → the business has never subscribed;
/// * paid means `payment_completed_by_user` **or** `payment_status = COMPLETED`;
/// * paid and `next_billing_date` still ahead → entitled;
/// * `next_billing_date` behind → expired, paid or not;
/// * otherwise unpaid: `PENDING` means a charge is in flight, anything else
///   means nothing has been collected.
BooksAccessState evaluateBooksEntitlement(
  Plan? plan, {
  required DateTime now,
  int? businessTypeId,
  bool isDefault = false,
}) {
  if (businessTypeId == 2 && isDefault) {
    return BooksAccessState(
      status: BooksAccessStatus.entitled,
      plan: plan,
      validUntil: plan?.nextBillingDate,
      waived: true,
    );
  }

  if (plan == null) {
    return const BooksAccessState(status: BooksAccessStatus.noPlan);
  }

  final paymentStatus = plan.paymentStatus?.trim().toUpperCase();
  final complete =
      plan.paymentCompletedByUser == true || paymentStatus == 'COMPLETED';
  final nextBillingDate = plan.nextBillingDate;

  if (nextBillingDate != null) {
    if (now.isBefore(nextBillingDate) && complete) {
      return BooksAccessState(
        status: BooksAccessStatus.entitled,
        plan: plan,
        validUntil: nextBillingDate,
      );
    }
    if (now.isAfter(nextBillingDate)) {
      return BooksAccessState(
        status: BooksAccessStatus.expired,
        plan: plan,
        validUntil: nextBillingDate,
      );
    }
  }

  return BooksAccessState(
    status: paymentStatus == 'PENDING'
        ? BooksAccessStatus.awaitingSettlement
        : BooksAccessStatus.needsPayment,
    plan: plan,
    validUntil: nextBillingDate,
  );
}
