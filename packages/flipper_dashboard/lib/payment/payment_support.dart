import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:flipper_payments/flipper_payments.dart' show BillingCadence;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// The support WhatsApp number.
const _supportWhatsApp = '250788360058';

/// What the payment screen shows, sent with each support message so the
/// support team need not ask. Empty values are left out.
Map<String, String> paymentSupportContext(Plan? plan, {String? amount}) {
  if (plan == null) return const {};
  final values = {
    'planId': plan.id,
    'plan': plan.selectedPlan,
    'amount': amount,
    'billing': plan.rule == null
        ? null
        : BillingCadence.fromWire(plan.rule).label,
    'paymentStatus': plan.paymentStatus,
    'lastError': plan.lastError,
  };
  return {
    for (final e in values.entries)
      if (e.value != null && e.value!.trim().isNotEmpty) e.key: e.value!.trim(),
  };
}

/// WhatsApp support, for when the in-app chat can't be reached.
Uri paymentSupportWhatsAppUri(Plan? plan) => Uri.parse(
  'https://wa.me/$_supportWhatsApp?text=${Uri.encodeComponent('I need help with my Flipper payment. Business: ${plan?.businessId ?? ''}')}',
);

/// "Need Help?" on the payment screens: chat with Flipper Support, whose
/// team answers from their Flo Team board.
Future<void> openPaymentSupport(
  BuildContext context, {
  Plan? plan,
  String? amount,
}) {
  return showFloSupportSheet(
    context,
    topic: 'payment',
    screenContext: paymentSupportContext(plan, amount: amount),
    onFallback: () => launchUrl(
      paymentSupportWhatsAppUri(plan),
      mode: LaunchMode.externalApplication,
    ),
  );
}
