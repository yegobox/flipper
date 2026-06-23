import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';

/// Payment method keys used by [ExpenseEntryPanel].
enum ExpensePaymentMethod { cash, bank, momo }

/// Builds a balanced Dr expense / Cr funding journal for a cash-out expense.
List<JournalLine> buildExpenseJournalLines({
  required String expenseCode,
  required String fundingCode,
  required int amount,
}) {
  return [
    JournalLine(ac: expenseCode, dr: amount),
    JournalLine(ac: fundingCode, cr: amount),
  ];
}

/// Maps UI payment method to a liquid account code via [roles].
String fundingCodeForPaymentMethod(
  ChartAccountResolver roles,
  ExpensePaymentMethod method,
) {
  return switch (method) {
    ExpensePaymentMethod.bank => roles.bank ?? '1020',
    ExpensePaymentMethod.momo => roles.mobileMoney ?? '1030',
    ExpensePaymentMethod.cash => roles.cashOnHand ?? '1010',
  };
}

/// Suggests the next unused expense code in the 60xx range.
String suggestNextExpenseCode(List<Account> accounts) {
  final used = accounts
      .where((a) => a.type == AccountType.expense)
      .map((a) => int.tryParse(a.code) ?? 0)
      .where((c) => c >= 6010 && c <= 6999)
      .toSet();

  for (var code = 6060; code <= 6999; code += 10) {
    if (!used.contains(code)) return code.toString();
  }
  for (var code = 6010; code <= 6999; code++) {
    if (!used.contains(code)) return code.toString().padLeft(4, '0');
  }
  return '6999';
}

/// Default subcategory label for new operating expense accounts.
const defaultExpenseSubcategory = 'Operating expenses';
