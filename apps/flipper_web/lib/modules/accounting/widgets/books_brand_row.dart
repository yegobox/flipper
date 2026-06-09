import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/widgets/flipper_logo.dart';
import 'package:flutter/material.dart';

class BooksBrandRow extends StatelessWidget {
  const BooksBrandRow({super.key, this.logoSize = 30});

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final labelRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Flipper',
          style: AccountingTokens.sans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AccountingTokens.ink1,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AccountingTokens.accentTint,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AccountingTokens.accent.withValues(alpha: 0.2)),
          ),
          child: Text(
            'Books',
            style: AccountingTokens.sans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AccountingTokens.accent,
              letterSpacing: 0.06 * 10.5,
            ),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final logo = FlipperLogo(size: logoSize);
        if (!constraints.hasBoundedWidth) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [logo, const SizedBox(width: 8), labelRow],
          );
        }

        return Row(
          children: [
            logo,
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: labelRow,
              ),
            ),
          ],
        );
      },
    );
  }
}
