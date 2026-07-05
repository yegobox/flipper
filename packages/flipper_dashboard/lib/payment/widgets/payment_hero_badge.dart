import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum PaymentHeroTone { error, warning }

class PaymentHeroBadge extends StatelessWidget {
  const PaymentHeroBadge({
    super.key,
    this.tone = PaymentHeroTone.error,
    this.icon = FluentIcons.payment_24_regular,
  });

  final PaymentHeroTone tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tint =
        tone == PaymentHeroTone.error ? PaymentTokens.lossTint : PaymentTokens.warnTint;
    final ink =
        tone == PaymentHeroTone.error ? PaymentTokens.loss : PaymentTokens.warnAmber;
    final ring = tone == PaymentHeroTone.error
        ? PaymentTokens.loss.withValues(alpha: 0.24)
        : PaymentTokens.warnAmber.withValues(alpha: 0.24);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: const Cubic(0.2, 1.4, 0.4, 1),
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 102,
            height: 102,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: ring, width: 1.5, style: BorderStyle.solid),
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: ring),
            ),
            child: Icon(icon, size: 38, color: ink),
          ),
        ],
      ),
    );
  }
}
