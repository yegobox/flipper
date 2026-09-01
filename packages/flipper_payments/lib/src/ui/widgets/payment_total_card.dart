import 'package:flipper_payments/src/catalog/billing_cadence.dart';
import 'package:flipper_payments/src/ui/payment_format.dart';
import 'package:flipper_payments/src/ui/payment_tokens.dart';
import 'package:flipper_payments/src/ui/payment_typography.dart';
import 'package:flutter/material.dart';

class PaymentTotalCard extends StatelessWidget {
  const PaymentTotalCard({
    super.key,
    required this.total,
    required this.subtitle,
    this.isYearly = false,
    this.cadence,
    this.label = 'Total',
    this.plain = false,
  });

  final num total;
  final String subtitle;

  /// Legacy monthly-or-yearly flag, used only when [cadence] is null. It cannot
  /// express a daily plan, which would then read "/month" under a daily price.
  final bool isYearly;

  /// The billing cadence. Prefer this over [isYearly].
  final BillingCadence? cadence;
  final String label;
  final bool plain;

  @override
  Widget build(BuildContext context) {
    final period = (cadence ??
            (isYearly ? BillingCadence.yearly : BillingCadence.monthly))
        .periodSuffix;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      decoration: BoxDecoration(
        gradient: plain ? null : PaymentTokens.gradBrandSoft,
        color: plain ? PaymentTokens.surface : null,
        borderRadius: BorderRadius.circular(PaymentTokens.rLg),
        border: Border.all(
          color: plain ? PaymentTokens.line : PaymentTokens.blueTint2,
        ),
        boxShadow: plain ? PaymentTokens.sh1 : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: PaymentTypography.totalLabel(),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: PaymentTypography.hint().copyWith(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: formatPaymentTotal(total),
                    style: PaymentTypography.totalValue(),
                  ),
                  TextSpan(
                    text: ' $period',
                    style: PaymentTypography.totalPeriod(),
                  ),
                ],
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
