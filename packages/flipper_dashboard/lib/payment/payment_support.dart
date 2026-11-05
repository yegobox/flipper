import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:flipper_payments/flipper_payments.dart' show BillingCadence;
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// The support WhatsApp number.
const paymentSupportWhatsAppNumber = '250788360058';

/// What the payment screen shows, sent with each support message so the
/// support team need not ask. Empty values are left out.
///
/// [error] is the failure the screen shows; it wins over [Plan.lastError],
/// which only the server's own failures fill in.
Map<String, String> paymentSupportContext(
  Plan? plan, {
  String? amount,
  String? error,
}) {
  if (plan == null) return const {};
  final values = {
    'planId': plan.id,
    'plan': plan.selectedPlan,
    'amount': amount,
    'billing': plan.rule == null
        ? null
        : BillingCadence.fromWire(plan.rule).label,
    'paymentStatus': plan.paymentStatus,
    'lastError': (error?.trim().isNotEmpty ?? false) ? error : plan.lastError,
  };
  return {
    for (final e in values.entries)
      if (e.value != null && e.value!.trim().isNotEmpty) e.key: e.value!.trim(),
  };
}

/// WhatsApp support, for when the in-app chat can't be reached.
Uri paymentSupportWhatsAppUri(Plan? plan) => Uri.parse(
  'https://wa.me/$paymentSupportWhatsAppNumber?text=${Uri.encodeComponent('I need help with my Flipper payment. Business: ${plan?.businessId ?? ''}')}',
);

/// Opens a URL outside the app; replaceable in tests.
@visibleForTesting
Future<bool> Function(Uri uri) paymentSupportLaunch = (uri) =>
    launchUrl(uri, mode: LaunchMode.externalApplication);

/// Opens WhatsApp support. When it can't open, says so and gives the number,
/// the only other way to reach support. A dialog, not a snack bar: it is
/// called from inside the support chat, which would cover a snack bar.
Future<void> openPaymentSupportWhatsApp(
  BuildContext context,
  Plan? plan,
) async {
  var opened = false;
  try {
    opened = await paymentSupportLaunch(paymentSupportWhatsAppUri(plan));
  } catch (_) {
    opened = false;
  }
  if (opened || !context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      key: const Key('payment-support-whatsapp-failed'),
      content: SelectableText(
        context.flipperL10n.paymentSupportWhatsAppFailed(
          paymentSupportWhatsAppNumber,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    ),
  );
}

/// "Need Help?" on the payment screens: chat with Flipper Support, whose
/// team answers from their Flo Team board. [plan] is the plan being paid
/// for and [error] the failure on screen.
///
/// In Local Mode nothing may reach the connector, so it goes straight to
/// WhatsApp.
Future<void> openPaymentSupport(
  BuildContext context, {
  Plan? plan,
  String? amount,
  String? error,
}) {
  if (LocalMode.isOn) return openPaymentSupportWhatsApp(context, plan);
  return showFloSupportSheet(
    context,
    topic: 'payment',
    screenContext: paymentSupportContext(plan, amount: amount, error: error),
    onFallback: () => openPaymentSupportWhatsApp(context, plan),
  );
}
