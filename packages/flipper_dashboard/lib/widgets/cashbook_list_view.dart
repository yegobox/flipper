import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/cashbook_form_rules.dart';
import 'package:flipper_dashboard/widgets/cashbook_svgs.dart';
import 'package:flipper_dashboard/widgets/transaction_detail_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// One row of the Cash Book list, already resolved from a transaction so the
/// list stays free of model and service dependencies.
class CashbookListEntry {
  const CashbookListEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.amount,
    required this.at,
    this.detail,
    this.methodBadge,
    this.isMobileMoney = false,
  });

  final String id;
  final CashbookEntryKind kind;
  final String title;

  /// What the entry was for: the category, then the note.
  final String? detail;
  final double amount;
  final DateTime at;

  /// "MoMo" / "Airtel" for non-cash entries.
  final String? methodBadge;
  final bool isMobileMoney;
}

enum CashbookListFilter { all, cashIn, cashOut, sales, momo }

extension on CashbookListFilter {
  String get label => switch (this) {
    CashbookListFilter.all => FlipperL10n.current.cashbookFilterAll,
    CashbookListFilter.cashIn => FlipperL10n.current.cashbookCashIn,
    CashbookListFilter.cashOut => FlipperL10n.current.cashbookCashOut,
    CashbookListFilter.sales => FlipperL10n.current.sales,
    CashbookListFilter.momo => 'MoMo',
  };

  bool matches(CashbookListEntry e) => switch (this) {
    CashbookListFilter.all => true,
    CashbookListFilter.cashIn => e.kind == CashbookEntryKind.cashIn,
    CashbookListFilter.cashOut => e.kind == CashbookEntryKind.cashOut,
    CashbookListFilter.sales => e.kind == CashbookEntryKind.sale,
    CashbookListFilter.momo => e.isMobileMoney,
  };
}

/// Colours for the Cash Book list. Gain/loss match the entry form and the
/// "New category" sheet so the screen reads as one design.
abstract final class CashbookListTokens {
  static const Color page = Color(0xFFF6F7F9);
  static const Color card = Colors.white;
  static const Color ink = Color(0xFF111827);
  static const Color ink2 = Color(0xFF374151);
  static const Color muted = Color(0xFF6B7280);
  static const Color faint = Color(0xFF9CA3AF);
  static const Color line = Color(0xFFE5E7EB);
  static const Color gain = Color(0xFF16A34A);
  static const Color gainTint = Color(0xFFE8F8EF);
  static const Color loss = Color(0xFFDC2626);
  static const Color lossTint = Color(0xFFFDECEC);
  static const Color sale = Color(0xFF2563EB);
  static const Color saleTint = Color(0xFFEAF1FE);
  static const Color hero = Color(0xFF111827);
}

typedef _T = CashbookListTokens;

/// The Cash Book's list: a summary card, filter chips and day-grouped rows.
class CashbookListView extends StatelessWidget {
  const CashbookListView({
    super.key,
    required this.entries,
    required this.filter,
    required this.onFilterChanged,
    required this.currency,
    required this.periodLabel,
    required this.onEntryTap,
    this.onPickPeriod,
    this.onViewAll,
    this.onRefresh,
    this.now,
  });

  /// Entries inside the period, newest first, before the chip filter.
  final List<CashbookListEntry> entries;
  final CashbookListFilter filter;
  final ValueChanged<CashbookListFilter> onFilterChanged;
  final String currency;
  final String periodLabel;
  final ValueChanged<String> onEntryTap;
  final VoidCallback? onPickPeriod;
  final VoidCallback? onViewAll;
  final Future<void> Function()? onRefresh;

  /// Clock for "Today" / "Yesterday" labels; defaults to [DateTime.now].
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final visible = entries.where(filter.matches).toList();
    final totals = cashbookTotals([
      for (final e in visible) (kind: e.kind, amount: e.amount),
    ]);
    final groups = groupCashbookByDay(visible, at: (e) => e.at);
    final clock = now ?? DateTime.now();

    final slivers = <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: _SummaryCard(
            totals: totals,
            count: visible.length,
            currency: currency,
            periodLabel: periodLabel,
            onPickPeriod: onPickPeriod,
            onViewAll: onViewAll,
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: _FilterChips(selected: filter, onChanged: onFilterChanged),
      ),
      if (visible.isEmpty)
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            message: entries.isEmpty
                ? FlipperL10n.current.cashbookListNoMovements
                : FlipperL10n.current.cashbookListNoFilterEntries(
                    filter.label.toLowerCase(),
                  ),
            hint: entries.isEmpty
                ? FlipperL10n.current.cashbookListEmptyHint
                : FlipperL10n.current.cashbookListNothingMatches(periodLabel),
          ),
        )
      else
        for (final g in groups) ...[
          SliverToBoxAdapter(
            child: _DayHeader(
              label: cashbookDayLabel(g.day, clock),
              net: cashbookTotals([
                for (final e in g.items) (kind: e.kind, amount: e.amount),
              ]).net,
              currency: currency,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _DayCard(
                entries: g.items,
                currency: currency,
                onTap: onEntryTap,
              ),
            ),
          ),
        ],
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
    ];

    final scroll = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: slivers,
    );

    return ColoredBox(
      color: _T.page,
      child: onRefresh == null
          ? scroll
          : RefreshIndicator(
              color: _T.ink,
              onRefresh: onRefresh!,
              child: scroll,
            ),
    );
  }
}

String _money(double v) => NumberFormat('#,##0').format(v.abs());

String _signed(double v, String currency, {bool forceSign = false}) {
  final sign = v < 0 ? '−' : (forceSign && v > 0 ? '+' : '');
  return '$sign${_money(v)} $currency';
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totals,
    required this.count,
    required this.currency,
    required this.periodLabel,
    this.onPickPeriod,
    this.onViewAll,
  });

  final ({double moneyIn, double moneyOut, double net}) totals;
  final int count;
  final String currency;
  final String periodLabel;
  final VoidCallback? onPickPeriod;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: BoxDecoration(
        color: _T.hero,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _T.hero.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PeriodPill(label: periodLabel, onTap: onPickPeriod),
              const Spacer(),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: 0.85),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        FlipperL10n.current.cashbookViewAll,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      TransactionDetailSvgs.icon(
                        TransactionDetailSvgs.chevronRight(),
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Net cash flow · $count ${count == 1 ? 'entry' : 'entries'}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.65),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _signed(totals.net, currency, forceSign: true),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.6,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FlowTile(
                  label: FlipperL10n.current.cashbookMoneyInLabel,
                  amount: totals.moneyIn,
                  currency: currency,
                  glyph: CashbookSvgs.arrowDownLeft(strokeWidth: 2),
                  accent: const Color(0xFF4ADE80),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FlowTile(
                  label: FlipperL10n.current.cashbookMoneyOutLabel,
                  amount: totals.moneyOut,
                  currency: currency,
                  glyph: CashbookSvgs.arrowUpRight(strokeWidth: 2),
                  accent: const Color(0xFFF87171),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodPill extends StatelessWidget {
  const _PeriodPill({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = Colors.white.withValues(alpha: 0.9);
    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                TransactionDetailSvgs.icon(
                  TransactionDetailSvgs.chevronDown(),
                  size: 16,
                  color: fg,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowTile extends StatelessWidget {
  const _FlowTile({
    required this.label,
    required this.amount,
    required this.currency,
    required this.glyph,
    required this.accent,
  });

  final String label;
  final double amount;
  final String currency;
  final String glyph;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: CashbookSvgs.icon(glyph, size: 16, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_money(amount)} $currency',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onChanged});

  final CashbookListFilter selected;
  final ValueChanged<CashbookListFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        itemCount: CashbookListFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = CashbookListFilter.values[i];
          final isSelected = f == selected;
          return ChoiceChip(
            label: Text(f.label),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) {
              HapticFeedback.selectionClick();
              onChanged(f);
            },
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isSelected ? Colors.white : _T.ink2,
            ),
            backgroundColor: Colors.white,
            selectedColor: _T.ink,
            side: BorderSide(color: isSelected ? _T.ink : _T.line),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.label,
    required this.net,
    required this.currency,
  });

  final String label;
  final double net;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _T.muted,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Text(
            _signed(net, currency, forceSign: true),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: net < 0 ? _T.loss : _T.muted,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.entries,
    required this.currency,
    required this.onTap,
  });

  final List<CashbookListEntry> entries;
  final String currency;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _T.card,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            CashbookEntryRow(
              entry: entries[i],
              currency: currency,
              onTap: () => onTap(entries[i].id),
            ),
            if (i < entries.length - 1)
              const Divider(height: 1, indent: 68, color: _T.line),
          ],
        ],
      ),
    );
  }
}

/// A single list row: kind icon, title with the category beneath, signed
/// amount and time.
class CashbookEntryRow extends StatelessWidget {
  const CashbookEntryRow({
    super.key,
    required this.entry,
    required this.currency,
    required this.onTap,
  });

  final CashbookListEntry entry;
  final String currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color tint, String glyph) = switch (entry.kind) {
      CashbookEntryKind.cashIn => (
        _T.gain,
        _T.gainTint,
        CashbookSvgs.arrowDownLeft(strokeWidth: 2),
      ),
      CashbookEntryKind.cashOut => (
        _T.loss,
        _T.lossTint,
        CashbookSvgs.arrowUpRight(strokeWidth: 2),
      ),
      CashbookEntryKind.sale => (
        _T.sale,
        _T.saleTint,
        TransactionDetailSvgs.receipt(),
      ),
    };
    final isOut = entry.kind == CashbookEntryKind.cashOut;
    final amountText = '${isOut ? '−' : '+'}${_money(entry.amount)} $currency';

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 68),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: CashbookSvgs.icon(glyph, size: 20, color: fg),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _T.ink,
                      ),
                    ),
                    if (entry.detail != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (entry.kind != CashbookEntryKind.sale) ...[
                            CashbookSvgs.icon(
                              CashbookSvgs.tag(),
                              size: 13,
                              color: _T.faint,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            child: Text(
                              entry.detail!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: _T.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amountText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isOut ? _T.loss : _T.gain,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (entry.methodBadge != null) ...[
                        _MethodBadge(label: entry.methodBadge!),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        DateFormat('HH:mm').format(entry.at),
                        style: const TextStyle(fontSize: 12, color: _T.faint),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodBadge extends StatelessWidget {
  const _MethodBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF92400E),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.hint});

  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: TransactionDetailSvgs.icon(
              TransactionDetailSvgs.wallet(),
              size: 30,
              color: _T.faint,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _T.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: _T.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// Sticky bottom bar with the two primary actions, inset above the home
/// indicator.
class CashbookActionBar extends StatelessWidget {
  const CashbookActionBar({
    super.key,
    required this.onCashIn,
    required this.onCashOut,
  });

  final VoidCallback onCashIn;
  final VoidCallback onCashOut;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _T.line)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          12 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: FlipperL10n.current.cashbookCashIn,
                glyph: CashbookSvgs.arrowDownLeft(strokeWidth: 2.2),
                color: _T.gain,
                onPressed: onCashIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: FlipperL10n.current.cashbookCashOut,
                glyph: CashbookSvgs.arrowUpRight(strokeWidth: 2.2),
                color: _T.loss,
                onPressed: onCashOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.glyph,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final String glyph;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: CashbookSvgs.icon(glyph, size: 15, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
