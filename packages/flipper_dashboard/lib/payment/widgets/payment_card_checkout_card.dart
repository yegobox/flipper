import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flipper_dashboard/payment/widgets/payment_input.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// The card rail's counterpart to [PaymentMobileMoneyCard].
///
/// Says the two things a customer needs to know before they tap, both of which
/// are consequences of Dodo owning the checkout rather than us:
///
/// * they are about to leave the app for Dodo's payment page, and
/// * a Flipper discount code does not reduce a card charge, because Dodo bills
///   the price fixed on its product. Showing a discount and then charging full
///   price would be the worse kind of surprise, so the notice is not optional
///   when a code is applied.
class PaymentCardCheckoutCard extends StatelessWidget {
  const PaymentCardCheckoutCard({
    super.key,
    required this.emailController,
    this.onEmailChanged,
    this.emailError,
    this.discountApplied = false,
    this.isTestMode = false,
    this.pendingCheckoutLink,
    this.onOpenPendingLink,
    this.flat = false,
  });

  final TextEditingController emailController;
  final ValueChanged<String>? onEmailChanged;
  final String? emailError;

  /// True when a Flipper discount code is applied, which this rail cannot honour.
  final bool discountApplied;

  /// True when the connector is pointed at Dodo's test account. Debug-visible
  /// only, but worth showing: a test subscription can never settle a live plan,
  /// so a tester who does not know which world they are in reads the resulting
  /// "still pending" as a bug.
  final bool isTestMode;

  /// A checkout link that was created but could not be opened here.
  final String? pendingCheckoutLink;
  final VoidCallback? onOpenPendingLink;

  /// Drop the card's own background, border and padding, for a screen that has
  /// already put this inside one of its own cards.
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: flat ? EdgeInsets.zero : const EdgeInsets.all(18),
      decoration: flat
          ? null
          : BoxDecoration(
              color: PaymentTokens.surface,
              borderRadius: BorderRadius.circular(PaymentTokens.rLg),
              border: Border.all(color: PaymentTokens.line),
              boxShadow: PaymentTokens.sh1,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PaymentTokens.blueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  FluentIcons.credit_card_person_20_regular,
                  size: 20,
                  color: PaymentTokens.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Card Payment',
                  style: PaymentTypography.cardTitle(color: PaymentTokens.ink1),
                ),
              ),
              if (isTestMode)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: PaymentTokens.warnTint,
                    borderRadius: BorderRadius.circular(PaymentTokens.rSm),
                  ),
                  child: Text(
                    'TEST MODE',
                    style: PaymentTypography.hint(
                      color: PaymentTokens.warnAmber,
                    ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'You will be taken to a secure payment page to enter your Visa or '
            'Mastercard details. Come back here once you are done — the plan '
            'activates on its own.',
            style: PaymentTypography.body().copyWith(fontSize: 13.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Email for the receipt',
            style: PaymentTypography.inlineLabel().copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          PaymentInput(
            controller: emailController,
            hintText: 'owner@business.rw',
            leadingIcon: FluentIcons.mail_20_regular,
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
          ),
          PaymentInputHint(
            text: emailError ?? 'Invoices and card receipts are sent here.',
          ),
          if (discountApplied) ...[
            const SizedBox(height: 14),
            _Notice(
              icon: FluentIcons.info_20_regular,
              tint: PaymentTokens.warnTint,
              ink: PaymentTokens.warnAmber,
              text: 'Discount codes apply to Mobile Money payments only. '
                  'Paying by card charges the full plan price.',
            ),
          ],
          if (pendingCheckoutLink != null) ...[
            const SizedBox(height: 14),
            _Notice(
              icon: FluentIcons.link_20_regular,
              tint: PaymentTokens.blueTint,
              ink: PaymentTokens.blue700,
              text: 'A payment page is already waiting for this plan. Open it '
                  'to finish — a new one would not replace it.',
              action: onOpenPendingLink == null
                  ? null
                  : TextButton(
                      onPressed: onOpenPendingLink,
                      child: const Text('Open payment page'),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.tint,
    required this.ink,
    required this.text,
    this.action,
  });

  final IconData icon;
  final Color tint;
  final Color ink;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(PaymentTokens.rMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 17, color: ink),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
                  style: PaymentTypography.body(color: ink).copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (action != null)
            Align(alignment: Alignment.centerRight, child: action!),
        ],
      ),
    );
  }
}
