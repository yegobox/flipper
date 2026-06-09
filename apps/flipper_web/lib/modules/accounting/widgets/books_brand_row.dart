import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

class BooksBrandRow extends StatelessWidget {
  const BooksBrandRow({super.key, this.logoSize = 30, this.onDark = true});

  final double logoSize;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final wordColor = onDark ? Colors.white : AccountingTokens.ink1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FlipperRingMark(size: logoSize),
        const SizedBox(width: 10),
        Text('Flipper', style: AccountingTokens.sans(fontSize: 18, fontWeight: FontWeight.w700, color: wordColor)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: onDark ? Colors.white.withValues(alpha: 0.12) : AccountingTokens.accentTint,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: onDark ? Colors.white.withValues(alpha: 0.15) : AccountingTokens.accent.withValues(alpha: 0.2)),
          ),
          child: Text(
            'Books',
            style: AccountingTokens.sans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: onDark ? Colors.white.withValues(alpha: 0.9) : AccountingTokens.accent,
              letterSpacing: 0.06 * 10.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _FlipperRingMark extends StatelessWidget {
  const _FlipperRingMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AccountingTokens.brandGradient,
      ),
      child: Center(
        child: Container(
          width: size * 0.42,
          height: size * 0.42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onDarkBackground(size),
          ),
        ),
      ),
    );
  }

  Color onDarkBackground(double s) => s > 26 ? AccountingTokens.sidebarBg : Colors.white;
}
