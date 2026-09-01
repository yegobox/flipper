import 'dart:math' as math;

import 'package:flipper_payments/src/catalog/billing_cadence.dart';
import 'package:flipper_payments/src/catalog/subscription_plan_template.dart';
import 'package:intl/intl.dart';

final _nf = NumberFormat.decimalPattern('en_US');

/// Grouped thousands for RWF display (e.g. 1,152,000).
String formatPaymentRwf(num value, {bool withDecimals = false}) {
  final rounded = value.round();
  if (withDecimals) {
    return '${_nf.format(rounded)}.00';
  }
  return _nf.format(rounded);
}

/// Total card value: `RWF 5,000.00`
String formatPaymentTotal(num value) => 'RWF ${formatPaymentRwf(value, withDecimals: true)}';

/// Per-installment hint amount (ceil division per handover).
int perInstallmentAmount(num total, int installments) {
  if (installments <= 1) return total.round();
  return (total / installments).ceil();
}

/// Installment hint copy for split payments section.
String installmentHint({
  required int installments,
  required num total,
}) {
  final formatted = formatPaymentRwf(total);
  if (installments <= 1) {
    return 'Paid in full — one charge of RWF $formatted.';
  }
  final per = formatPaymentRwf(perInstallmentAmount(total, installments));
  return '$installments payments of RWF $per each.';
}

/// Plan tile price line per handover §09.
String formatPaymentTilePrice(
  SubscriptionPlanTemplate template, {
  required bool isYearly,
}) {
  return formatPaymentTilePriceFor(
    template,
    cadence: isYearly ? BillingCadence.yearly : BillingCadence.monthly,
  );
}

/// Plan tile price line at an explicit cadence.
///
/// Yearly shows the monthly equivalent — the number a customer compares against
/// the monthly plan — while daily and monthly show what is actually charged per
/// period, since those are already the smallest unit.
String formatPaymentTilePriceFor(
  SubscriptionPlanTemplate template, {
  required BillingCadence cadence,
}) {
  final suffix = template.isEnterprise ? '+' : '';
  switch (cadence) {
    case BillingCadence.yearly:
      final discountMultiplier = 1 - (template.yearlyDiscountPercent / 100);
      final monthlyEquiv = (template.monthlyPrice * discountMultiplier).round();
      return '${formatPaymentRwf(monthlyEquiv)}$suffix RWF/mo · billed yearly';
    case BillingCadence.daily:
      final daily = template.calculateTotalFor(cadence: BillingCadence.daily);
      return '${formatPaymentRwf(daily)}$suffix RWF/day';
    case BillingCadence.monthly:
      return '${formatPaymentRwf(template.monthlyPrice)}$suffix RWF/month';
  }
}

/// Add-on price line for payment tiles.
String formatPaymentAddonPrice(
  SubscriptionPlanTemplate template,
  SubscriptionPlanAddonTemplate addon, {
  required bool isYearly,
}) {
  return formatPaymentAddonPriceFor(
    template,
    addon,
    cadence: isYearly ? BillingCadence.yearly : BillingCadence.monthly,
  );
}

/// Add-on price line at an explicit cadence.
String formatPaymentAddonPriceFor(
  SubscriptionPlanTemplate template,
  SubscriptionPlanAddonTemplate addon, {
  required BillingCadence cadence,
}) {
  switch (cadence) {
    case BillingCadence.yearly:
      final discountMultiplier = 1 - (template.yearlyDiscountPercent / 100);
      final monthlyEquiv = (addon.monthlyPrice * discountMultiplier).round();
      return '${formatPaymentRwf(monthlyEquiv)} RWF/mo · billed yearly';
    case BillingCadence.daily:
      // Same divisor the total uses, so the lines add up on screen.
      return '${formatPaymentRwf(dailyPriceFromMonthly(addon.monthlyPrice))} RWF/day';
    case BillingCadence.monthly:
      return '${formatPaymentRwf(addon.monthlyPrice)} RWF/month';
  }
}

/// Selection summary under total card.
String paymentSelectionSubtitle({
  required String planName,
  Iterable<String> addonNames = const [],
}) {
  if (addonNames.isEmpty) return planName;
  return '$planName + ${addonNames.join(', ')}';
}

const paymentInstallmentOptions = [1, 3, 6, 12];

int installmentIndex(int count) {
  final idx = paymentInstallmentOptions.indexOf(count);
  return math.max(0, idx);
}
