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
  });

  final List<MoneyAccountBalance> balances;
  final MoneyAccountsLayout layout;

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
