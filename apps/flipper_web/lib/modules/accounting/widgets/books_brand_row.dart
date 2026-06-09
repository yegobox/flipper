import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/widgets/flipper_logo.dart';
import 'package:flutter/material.dart';

enum BooksBrandVariant { desktop, mobile }

class BooksBrandRow extends StatelessWidget {
  const BooksBrandRow({
    super.key,
    this.logoSize = 30,
    this.variant = BooksBrandVariant.desktop,
  });

  final double logoSize;
  final BooksBrandVariant variant;

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
        _BooksBadge(variant: variant),
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

class _BooksBadge extends StatelessWidget {
  const _BooksBadge({required this.variant});

  final BooksBrandVariant variant;

  @override
  Widget build(BuildContext context) {
    final mobile = variant == BooksBrandVariant.mobile;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 7 : 8, vertical: mobile ? 2 : 3),
      decoration: BoxDecoration(
        color: mobile ? const Color(0xFFF3F4F6) : AccountingTokens.accentTint,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: mobile ? const Color(0xFFE5E7EB) : AccountingTokens.accent.withValues(alpha: 0.2)),
      ),
      child: Text(
        mobile ? 'BOOKS' : 'Books',
        style: AccountingTokens.sans(
          fontSize: mobile ? 10 : 10.5,
          fontWeight: FontWeight.w600,
          color: mobile ? AccountingTokens.ink4 : AccountingTokens.accent,
          letterSpacing: mobile ? 0.06 * 10 : 0.06 * 10.5,
        ),
      ),
    );
  }
}
