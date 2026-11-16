import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

/// Rows a Books table builds at first, and adds per "Show more" tap.
///
/// Books tables lay out every row they are given (`Table` / `DataTable`
/// measure every cell), so a book with thousands of customers or invoices
/// used to freeze on open and on every search keystroke.
const int kAccountingTablePageSize = 100;

/// "Show N more" under a paged Books table.
class AccountingShowMore extends StatelessWidget {
  const AccountingShowMore({
    super.key,
    required this.remaining,
    required this.onPressed,
  });

  final int remaining;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final next = remaining < kAccountingTablePageSize
        ? remaining
        : kAccountingTablePageSize;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: TextButton(
          key: const Key('accountingShowMore'),
          onPressed: onPressed,
          child: Text(
            context.flipperL10n.booksShowMoreRows('$next'),
            style: AccountingTokens.sans(
              fontWeight: FontWeight.w600,
              color: AccountingTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }
}
