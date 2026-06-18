import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flutter/material.dart';

enum KpiTone { green, blue, amber, red }

/// Responsive KPI row/grid without fixed [GridView] aspect ratios (avoids vertical clip).
class AccountingKpiGrid extends StatelessWidget {
  const AccountingKpiGrid({
    super.key,
    required this.children,
    this.spacing = 12,
    this.maxColumns = 4,
  });

  final List<Widget> children;
  final double spacing;
  final int maxColumns;

  static int columnCount(double maxWidth, {int maxColumns = 4}) {
    if (maxWidth > 900) return maxColumns;
    if (maxWidth > 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = columnCount(constraints.maxWidth, maxColumns: maxColumns).clamp(1, children.length);
        final itemWidth = (constraints.maxWidth - spacing * (cols - 1)) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

class AccountingKpiCard extends StatelessWidget {
  const AccountingKpiCard({
    super.key,
    required this.label,
    required this.icon,
    required this.tone,
    this.value,
    this.textValue,
    this.currencyPrefix,
    this.footnote,
    this.note,
    this.delta,
    this.deltaPositive,
    this.valueFontSize,
    this.highlightGradient,
  });

  final String label;
  final AccIcon icon;
  final KpiTone tone;

  /// Monetary or numeric KPI (renders with optional RWF prefix).
  final int? value;

  /// Non-numeric KPI (e.g. next run date). When set, [value] is ignored.
  final String? textValue;

  /// When true (default for [value]), shows "RWF" before amount.
  final bool? currencyPrefix;

  final String? footnote;

  /// Handoff `.acc-kpi-note` line below the value (e.g. VAT due date).
  final String? note;
  final int? delta;
  final bool? deltaPositive;
  final double? valueFontSize;

  /// Handoff amber gradient on net-VAT KPI card.
  final Gradient? highlightGradient;

  @override
  Widget build(BuildContext context) {
    final (icBg, icFg) = switch (tone) {
      KpiTone.green => (AccountingTokens.gainTint, AccountingTokens.gain),
      KpiTone.blue => (AccountingTokens.accentTint, AccountingTokens.accent),
      KpiTone.amber => (AccountingTokens.warnTint, AccountingTokens.warnAmber),
      KpiTone.red => (AccountingTokens.lossTint, AccountingTokens.loss),
    };

    final showCurrency = currencyPrefix ?? (value != null && textValue == null);

    Widget valueWidget;
    if (textValue != null) {
      valueWidget = Text(
        textValue!,
        style: AccountingTokens.sans(
          fontSize: valueFontSize ?? 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02 * 20,
        ),
      );
    } else {
      valueWidget = RichText(
        text: TextSpan(
          style: AccountingTokens.kpiValue,
          children: [
            if (showCurrency)
              TextSpan(
                text: 'RWF ',
                style: AccountingTokens.mono(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AccountingTokens.ink3,
                ),
              ),
            TextSpan(text: money(value ?? 0)),
            if (footnote != null && !showCurrency)
              TextSpan(
                text: ' $footnote',
                style: AccountingTokens.sans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AccountingTokens.ink3,
                ),
              ),
          ],
        ),
      );
    }

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: icBg,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: AccountingIcon(icon: icon, size: 20, color: icFg),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AccountingTokens.sans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AccountingTokens.ink3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        valueWidget,
        if (footnote != null && (showCurrency || textValue != null)) ...[
          const SizedBox(height: 4),
          Text(
            footnote!,
            style: AccountingTokens.sans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AccountingTokens.ink3,
            ),
          ),
        ],
        if (note != null) ...[
          const SizedBox(height: 9),
          Text(
            note!,
            style: AccountingTokens.sans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AccountingTokens.ink3,
            ),
          ),
        ],
        if (delta != null) ...[
          const SizedBox(height: 10),
          _DeltaChip(value: delta!, positive: deltaPositive ?? delta! >= 0),
        ],
      ],
    );

    if (highlightGradient != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: highlightGradient,
          borderRadius: BorderRadius.circular(AccountingTokens.radiusLg),
          border: Border.all(color: AccountingTokens.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0B1220),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: content,
      );
    }

    return AccountingCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: content,
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
          AccountingIcon(
            icon: positive ? AccIcon.arrowUpRight : AccIcon.arrowDown,
            size: 11,
            color: positive ? AccountingTokens.gainInk : AccountingTokens.lossInk,
          ),
          Text(
            '$value%',
            style: AccountingTokens.mono(
              fontSize: 11,
              color: positive ? AccountingTokens.gainInk : AccountingTokens.lossInk,
            ),
          ),
        ],
      ),
    );
  }
}
