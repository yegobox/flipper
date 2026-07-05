import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PaymentSummaryRow {
  const PaymentSummaryRow({
    required this.label,
    required this.value,
    this.mono = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool mono;
  final bool highlight;
}

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({
    super.key,
    required this.rows,
    this.title = 'Payment Summary',
    this.plain = false,
  });

  final String title;
  final List<PaymentSummaryRow> rows;
  final bool plain;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: plain ? null : PaymentTokens.gradBrandSoft,
        color: plain ? PaymentTokens.surface : null,
        borderRadius: BorderRadius.circular(PaymentTokens.rLg),
        border: Border.all(
          color: plain ? PaymentTokens.line : PaymentTokens.blueTint2,
        ),
        boxShadow: plain ? PaymentTokens.sh1 : null,
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
                  FluentIcons.receipt_20_regular,
                  size: 20,
                  color: PaymentTokens.blue,
                ),
              ),
              const SizedBox(width: 12),
              Text(title, style: PaymentTypography.cardTitle()),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                color: PaymentTokens.blue.withValues(alpha: 0.1),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      rows[i].label,
                      style: PaymentTypography.inlineLabel(
                        color: rows[i].highlight
                            ? PaymentTokens.gain
                            : PaymentTokens.ink2,
                      ).copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    flex: 3,
                    child: Text(
                      rows[i].value,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (rows[i].mono
                              ? PaymentTypography.monoPrice(
                                  size: 14.5,
                                  weight: FontWeight.w700,
                                )
                              : PaymentTypography.inlineLabel().copyWith(
                                  fontSize: 14.5,
                                ))
                          .copyWith(
                        color: rows[i].highlight
                            ? PaymentTokens.gain
                            : PaymentTokens.ink1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
