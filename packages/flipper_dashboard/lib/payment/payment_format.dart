import 'dart:math' as math;

import 'package:flipper_models/models/subscription_plan_template.dart';
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
  if (isYearly) {
    final discountMultiplier = 1 - (template.yearlyDiscountPercent / 100);
    final monthlyEquiv =
        (template.monthlyPrice * discountMultiplier).round();
    final formatted = formatPaymentRwf(monthlyEquiv);
    final suffix = template.isEnterprise ? '+' : '';
    return '$formatted$suffix RWF/mo · billed yearly';
  }
  final formatted = formatPaymentRwf(template.monthlyPrice);
  final suffix = template.isEnterprise ? '+' : '';
  return '$formatted$suffix RWF/month';
}

/// Add-on price line for payment tiles.
String formatPaymentAddonPrice(
  SubscriptionPlanTemplate template,
  SubscriptionPlanAddonTemplate addon, {
  required bool isYearly,
}) {
  if (isYearly) {
    final discountMultiplier = 1 - (template.yearlyDiscountPercent / 100);
    final monthlyEquiv =
        (addon.monthlyPrice * discountMultiplier).round();
    return '${formatPaymentRwf(monthlyEquiv)} RWF/mo · billed yearly';
  }
  return '${formatPaymentRwf(addon.monthlyPrice)} RWF/month';
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
