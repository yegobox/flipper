import 'package:flipper_payments/src/ui/payment_tokens.dart';
import 'package:flipper_payments/src/ui/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PaymentPrimaryButton extends StatelessWidget {
  const PaymentPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.loadingLabel,
    this.icon = FluentIcons.shield_checkmark_20_regular,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final String? loadingLabel;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: disabled && !loading
              ? LinearGradient(
                  colors: [
                    PaymentTokens.gradBtn.colors.first
                        .withValues(alpha: 0.75),
                    PaymentTokens.gradBtn.colors.last.withValues(alpha: 0.75),
                  ],
                )
              : PaymentTokens.gradBtn,
          borderRadius: BorderRadius.circular(PaymentTokens.rMd),
          boxShadow: disabled && !loading ? null : PaymentTokens.shBlue,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled ? null : onPressed,
            borderRadius: BorderRadius.circular(PaymentTokens.rMd),
            // The label ellipsises rather than overflowing: this button sits
            // in a 286–380px rail, and a label like "Charge 1,250,000 RWF by
            // Mobile Money" is wider than that. The handover does the same
            // (`overflow: hidden; text-overflow: ellipsis`).
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loading) ...[
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      loading ? (loadingLabel ?? 'Processing…') : label,
                      style: PaymentTypography.primaryButton(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentSecondaryButton extends StatelessWidget {
  const PaymentSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: PaymentTokens.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PaymentTokens.rMd),
          side: const BorderSide(color: PaymentTokens.lineStrong, width: 1.5),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(PaymentTokens.rMd),
          child: Center(
            child: Text(
              label,
              style: PaymentTypography.inlineLabel().copyWith(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentCtaNote extends StatelessWidget {
  const PaymentCtaNote({super.key, this.provider = 'MTN Mobile Money'});

  final String provider;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: PaymentTypography.hint().copyWith(fontSize: 12),
        children: [
          const TextSpan(text: 'Secure payment via '),
          TextSpan(
            text: provider,
            style: PaymentTypography.inlineLabel().copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: PaymentTokens.ink2,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
