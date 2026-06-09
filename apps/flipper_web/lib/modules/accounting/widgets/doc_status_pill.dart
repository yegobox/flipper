import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

class DocStatusPill extends StatelessWidget {
  const DocStatusPill({super.key, required this.status});

  final DocStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      DocStatus.draft => (AccountingTokens.surface2, AccountingTokens.ink3),
      DocStatus.sent => (AccountingTokens.accentTint, AccountingTokens.accent),
      DocStatus.paid => (AccountingTokens.gainTint, AccountingTokens.gainInk),
      DocStatus.overdue => (AccountingTokens.lossTint, AccountingTokens.lossInk),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              docStatusLabel(status),
              style: AccountingTokens.sans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
