import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flipper_dashboard/payment/widgets/payment_hero_badge.dart';
import 'package:flipper_dashboard/payment/widgets/payment_input.dart';
import 'package:flipper_dashboard/payment/widgets/payment_toggle_switch.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentMobileMoneyCard extends StatelessWidget {
  const PaymentMobileMoneyCard({
    super.key,
    required this.useDifferentNumber,
    required this.onUseDifferentChanged,
    required this.phoneController,
    this.onPhoneChanged,
    this.phoneError,
  });

  final bool useDifferentNumber;
  final ValueChanged<bool> onUseDifferentChanged;
  final TextEditingController phoneController;
  final ValueChanged<String>? onPhoneChanged;
  final String? phoneError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
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
                  FluentIcons.phone_20_regular,
                  size: 20,
                  color: PaymentTokens.blue,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Mobile Money Payment',
                style: PaymentTypography.cardTitle(color: PaymentTokens.ink1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: PaymentTypography.body().copyWith(fontSize: 13.5),
              children: [
                const TextSpan(text: 'Payment will be processed using '),
                TextSpan(
                  text: 'MTN Mobile Money',
                  style: PaymentTypography.inlineLabel().copyWith(fontSize: 13.5),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: useDifferentNumber
                  ? PaymentTokens.blueTint
                  : PaymentTokens.surface2,
              borderRadius: BorderRadius.circular(PaymentTokens.rMd),
              border: Border.all(
                color: useDifferentNumber
                    ? PaymentTokens.blueTint2
                    : PaymentTokens.line,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use different phone number',
                        style: PaymentTypography.inlineLabel().copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Try another MTN number if the current one failed',
                        style: PaymentTypography.hint().copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                PaymentToggleSwitch(
                  value: useDifferentNumber,
                  onChanged: onUseDifferentChanged,
                ),
              ],
            ),
          ),
          if (useDifferentNumber) ...[
            const SizedBox(height: 12),
            PaymentInput(
              controller: phoneController,
              hintText: '250 78X XXX XXX',
              leadingIcon: FluentIcons.phone_20_regular,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onPhoneChanged,
            ),
            PaymentInputHint(
              text: phoneError ?? 'Must start with 250 78 or 250 79.',
            ),
          ],
        ],
      ),
    );
  }
}

class PaymentIntroBlock extends StatelessWidget {
  const PaymentIntroBlock({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: PaymentTypography.introTitle()),
          const SizedBox(height: 8),
          Text(subtitle, style: PaymentTypography.introSubtitle()),
        ],
      ),
    );
  }
}

class PaymentHeroBlock extends StatelessWidget {
  const PaymentHeroBlock({
    super.key,
    required this.headline,
    required this.body,
    this.tone = PaymentHeroTone.error,
  });

  final String headline;
  final String body;
  final PaymentHeroTone tone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentHeroBadge(tone: tone),
        const SizedBox(height: 20),
        Text(
          headline,
          style: PaymentTypography.heroHeadline(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          body,
          style: PaymentTypography.body(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
