import 'package:flipper_payments/src/ui/payment_tokens.dart';
import 'package:flipper_payments/src/ui/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

class PaymentHelpCard extends StatelessWidget {
  const PaymentHelpCard({super.key, this.onTap, this.title, this.subtitle});

  final VoidCallback? onTap;

  /// Defaults to the localized "Need Help?".
  final String? title;

  /// Defaults to the localized "Chat with support about this payment".
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PaymentTokens.rLg),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: PaymentTokens.gradBrandSoft,
            borderRadius: BorderRadius.circular(PaymentTokens.rLg),
            border: Border.all(color: PaymentTokens.blueTint2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  FluentIcons.question_circle_20_regular,
                  size: 20,
                  color: PaymentTokens.blue700,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? context.flipperL10n.paywallNeedHelp,
                      style: PaymentTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle ?? context.flipperL10n.paywallChatWithSupport,
                      style: PaymentTypography.hint(),
                    ),
                  ],
                ),
              ),
              const Icon(
                FluentIcons.chevron_right_20_regular,
                size: 20,
                color: PaymentTokens.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
