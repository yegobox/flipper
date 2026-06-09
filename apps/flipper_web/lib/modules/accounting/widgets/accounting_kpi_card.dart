import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flutter/material.dart';

enum KpiTone { green, blue, amber, red }

class AccountingKpiCard extends StatelessWidget {
  const AccountingKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
    this.footnote,
    this.delta,
    this.deltaPositive,
  });

  final String label;
  final int value;
  final IconData icon;
  final KpiTone tone;
  final String? footnote;
  final int? delta;
  final bool? deltaPositive;

  @override
  Widget build(BuildContext context) {
    final (icBg, icFg) = switch (tone) {
      KpiTone.green => (AccountingTokens.gainTint, AccountingTokens.gain),
      KpiTone.blue => (AccountingTokens.accentTint, AccountingTokens.accent),
      KpiTone.amber => (AccountingTokens.warnTint, AccountingTokens.warnAmber),
      KpiTone.red => (AccountingTokens.lossTint, AccountingTokens.loss),
    };

    return AccountingCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: icBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 20, color: icFg),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3))),
            ],
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              style: AccountingTokens.kpiValue,
              children: [
                TextSpan(text: 'RWF ', style: AccountingTokens.mono(fontSize: 14, fontWeight: FontWeight.w500, color: AccountingTokens.ink3)),
                TextSpan(text: money(value)),
              ],
            ),
          ),
          if (footnote != null || delta != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (delta != null)
                  _DeltaChip(value: delta!, positive: deltaPositive ?? delta! >= 0),
                if (delta != null && footnote != null) const SizedBox(width: 8),
                if (footnote != null)
                  Expanded(child: Text(footnote!, style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.ink3))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DeltaChip extends StatelessWidget {
  const _DeltaChip({required this.value, required this.positive});

  final int value;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: positive ? AccountingTokens.gainTint : AccountingTokens.lossTint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(positive ? Icons.arrow_upward : Icons.arrow_downward, size: 11, color: positive ? AccountingTokens.gainInk : AccountingTokens.lossInk),
          Text('$value%', style: AccountingTokens.mono(fontSize: 11, color: positive ? AccountingTokens.gainInk : AccountingTokens.lossInk)),
        ],
      ),
    );
  }
}
