import 'package:flipper_dashboard/payment/payment_format.dart';
import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flutter/material.dart';

class PaymentTotalCard extends StatelessWidget {
  const PaymentTotalCard({
    super.key,
    required this.total,
    required this.subtitle,
    required this.isYearly,
    this.label = 'Total',
    this.plain = false,
  });

  final num total;
  final String subtitle;
  final bool isYearly;
  final String label;
  final bool plain;

  @override
  Widget build(BuildContext context) {
    final period = isYearly ? '/year' : '/month';

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
