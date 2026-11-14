import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

/// One money account and its balance (see `TransactionToAccounts.liquidBalances`).
typedef MoneyAccountBalance = ({String code, int bal});

/// Short name of a money account: Cash (1010), Mobile money (1030), Bank (1020).
String moneyAccountLabel(FlipperAppLocalizations l10n, String code) =>
    switch (code) {
      '1010' => l10n.cash,
      '1030' => l10n.paymentMobileMoney,
      '1020' => l10n.booksBank,
      _ => code,
    };

/// Amount colour: a negative balance is shown as a loss (usually no opening
/// balance was entered), and an empty account is muted so the ones holding
/// money stand out.
Color moneyAccountAmountColor(int bal) => bal < 0
    ? AccountingTokens.lossInk
    : bal == 0
    ? AccountingTokens.ink3
    : AccountingTokens.ink1;

/// Swatch colour of a money account, shared by the composition bar and the
/// dots beside each row so the two read as one legend.
Color moneyAccountColor(String code) => switch (code) {
  '1010' => AccountingTokens.accent,
  '1030' => const Color(0xFFE89A2A),
  '1020' => AccountingTokens.violet,
  _ => AccountingTokens.ink4,
};

enum MoneyAccountsLayout {
  /// Label left, amount right, one account per line (desktop KPI card).
  rows,

  /// One column per account, label above amount (mobile strip).
  columns,
}

/// Cash, Mobile money and Bank shown separately, so "Cash & bank" is never
/// read as a single account. All three always show: their sum is the total
/// next to it, and the layout does not jump when an account first gets money.
class MoneyAccountsBreakdown extends StatelessWidget {
  const MoneyAccountsBreakdown({
    super.key,
    required this.balances,
    this.layout = MoneyAccountsLayout.rows,
    this.showSwatches = false,
  });

  final List<MoneyAccountBalance> balances;
  final MoneyAccountsLayout layout;

  /// Rows layout only: a coloured dot before each label, matching the
  /// account's segment in [CollapsibleMoneyAccounts]' bar.
  final bool showSwatches;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return switch (layout) {
      MoneyAccountsLayout.rows => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, b) in balances.indexed)
            Padding(
              key: Key('money-account-${b.code}'),
              padding: EdgeInsets.only(top: i == 0 ? 0 : 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showSwatches)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 7),
                      child: _Dot(color: moneyAccountColor(b.code), size: 7),
                    ),
                  Expanded(
                    child: Text(
                      moneyAccountLabel(l10n, b.code),
                      // Two lines: "Amafaranga kuri telefoni" (rw) must not
                      // be cut to "Amafaranga ku…".
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AccountingTokens.sans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AccountingTokens.ink3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    money(b.bal),
                    style: AccountingTokens.mono(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: moneyAccountAmountColor(b.bal),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      MoneyAccountsLayout.columns => Row(
        // Bottom-aligned so the amounts stay level when one label wraps.
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (i, b) in balances.indexed) ...[
            if (i > 0) const SizedBox(width: 12),
            Expanded(
              key: Key('money-account-${b.code}'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    moneyAccountLabel(l10n, b.code),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AccountingTokens.sans(
                      fontSize: 11.5,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Scales a long amount down instead of overflowing a
                  // third of a phone's width.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      money(b.bal),
                      maxLines: 1,
                      style: AccountingTokens.mono(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: moneyAccountAmountColor(b.bal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    };
  }
}

/// "Cash & bank" breakdown folded by default: a thin bar shows how the total
/// splits across the accounts, and "3 accounts" opens the exact amounts. A
/// negative account puts a red dot on the toggle so folding never hides it.
class CollapsibleMoneyAccounts extends StatefulWidget {
  const CollapsibleMoneyAccounts({
    super.key,
    required this.balances,
    this.initiallyExpanded = false,
  });

  final List<MoneyAccountBalance> balances;
  final bool initiallyExpanded;

  @override
  State<CollapsibleMoneyAccounts> createState() =>
      _CollapsibleMoneyAccountsState();
}

class _CollapsibleMoneyAccountsState extends State<CollapsibleMoneyAccounts> {
  static const _duration = Duration(milliseconds: 220);
  late bool _open = widget.initiallyExpanded;

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final hasNegative = widget.balances.any((b) => b.bal < 0);
    final label = _open
        ? l10n.booksHideDetails
        : l10n.booksAccountsCount(widget.balances.length);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: _CompositionBar(balances: widget.balances),
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          button: true,
          expanded: _open,
          child: InkWell(
            key: const Key('money-accounts-toggle'),
            onTap: _toggle,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasNegative && !_open) ...[
                    Semantics(
                      label: l10n.booksAccountBelowZero,
                      child: const _Dot(
                        key: Key('money-accounts-negative-dot'),
                        color: AccountingTokens.lossInk,
                        size: 6,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AccountingTokens.sans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AccountingTokens.ink2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: _duration,
                    curve: Curves.easeOutCubic,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: _duration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              alignment: Alignment.topLeft,
              child: child,
            ),
          ),
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.topLeft,
            children: [...previous, ?current],
          ),
          child: _open
              ? Padding(
                  key: const ValueKey('open'),
                  padding: const EdgeInsets.only(top: 8),
                  child: MoneyAccountsBreakdown(
                    balances: widget.balances,
                    showSwatches: true,
                  ),
                )
              : const SizedBox(key: ValueKey('closed'), width: double.infinity),
        ),
      ],
    );
  }
}

/// One segment per account with money, sized by its share of the positive
/// total. Empty and negative accounts get no segment; with none above zero
/// the bar is an empty track.
class _CompositionBar extends StatelessWidget {
  const _CompositionBar({required this.balances});

  final List<MoneyAccountBalance> balances;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final positive = [
      for (final b in balances)
        if (b.bal > 0) b,
    ];
    final total = positive.fold<int>(0, (s, b) => s + b.bal);
    // Flex needs ints that fit; per-mille keeps tiny shares visible.
    int flexOf(int bal) => (bal * 1000 / total).round().clamp(1, 1000);

    return Semantics(
      label: [
        for (final b in balances)
          '${moneyAccountLabel(l10n, b.code)} ${money(b.bal)}',
      ].join(', '),
      child: ClipRRect(
        key: const Key('money-accounts-bar'),
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          height: 6,
          width: double.infinity,
          child: positive.isEmpty
              ? const ColoredBox(color: AccountingTokens.line)
              : Row(
                  // Stretch: a childless ColoredBox is otherwise 0px tall.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, b) in positive.indexed) ...[
                      if (i > 0) const SizedBox(width: 2),
                      Expanded(
                        key: Key('money-accounts-segment-${b.code}'),
                        flex: flexOf(b.bal),
                        child: ColoredBox(color: moneyAccountColor(b.code)),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({super.key, required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
