import 'package:flipper_payments/src/ui/payment_tokens.dart';
import 'package:flipper_payments/src/ui/payment_typography.dart';
import 'package:flutter/material.dart';

/// A payer in a search result list: initials avatar, name, and a mono
/// secondary line (phone, email or id).
///
/// The mono line is deliberate — it is what the operator reads back to the
/// customer to confirm they picked the right account, and proportional digits
/// make two similar numbers hard to tell apart at a glance.
class PaymentPayerTile extends StatelessWidget {
  const PaymentPayerTile({
    super.key,
    required this.name,
    required this.subtitle,
    this.onTap,
    this.selected = false,
    this.trailing,
  });

  final String name;
  final String subtitle;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? trailing;

  /// First letters of the first two words, e.g. "Manzi Eric" → "ME". Falls
  /// back to the first character so a one-word or empty name still renders a
  /// filled avatar rather than an empty box.
  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .toList();
    if (words.isEmpty) return '?';
    return words.map((w) => w[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PaymentTokens.surface,
      borderRadius: BorderRadius.circular(PaymentTokens.rMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PaymentTokens.rMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PaymentTokens.rMd),
            border: Border.all(
              color: selected ? PaymentTokens.blue : PaymentTokens.line,
            ),
            boxShadow: PaymentTokens.sh1,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PaymentTokens.blueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  initialsOf(name),
                  style: TextStyle(
                    fontFamily: PaymentTypography.sans,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: PaymentTokens.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PaymentTypography.inlineLabel().copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PaymentTypography.monoPrice(
                        color: PaymentTokens.ink3,
                        size: 12.5,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
