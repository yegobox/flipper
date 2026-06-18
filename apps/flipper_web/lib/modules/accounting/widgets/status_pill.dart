import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});

  final JournalStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      JournalStatus.posted => (AccountingTokens.gainTint, AccountingTokens.gainInk, 'posted'),
      JournalStatus.pending => (AccountingTokens.warnTint, AccountingTokens.warnAmber, 'pending'),
      JournalStatus.draft => (AccountingTokens.surface2, AccountingTokens.ink3, 'draft'),
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
            Text(label, style: AccountingTokens.sans(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
          ],
        ),
      ),
    );
  }
}

class MatchedPill extends StatelessWidget {
  const MatchedPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AccountingTokens.gainTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AccountingTokens.gainInk, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text('Matched', style: AccountingTokens.sans(fontSize: 12, fontWeight: FontWeight.w600, color: AccountingTokens.gainInk)),
          ],
        ),
      ),
    );
  }
}
