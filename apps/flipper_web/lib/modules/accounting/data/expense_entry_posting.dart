import 'package:flipper_accounting/statutory_accounts.dart';
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

/// A payment to RRA or RSSB. These settle what the business owes, so they
/// are not ordinary expenses.
enum StatutoryPayment { vat, paye, rssb }

/// The liability a [StatutoryPayment] settles.
String statutoryLiabilityCode(ChartAccountResolver roles, StatutoryPayment p) {
  return switch (p) {
    StatutoryPayment.vat => roles.vatPayable ?? '2100',
    StatutoryPayment.paye => roles.payePayable ?? payePayableCode,
    StatutoryPayment.rssb => roles.rssbPayable ?? rssbPayableCode,
  };
}

/// Where a PAYE or RSSB payment goes when the ledger shows less owed than was
/// paid: the business never ran payroll through Books, so the payment is the
/// cost itself.
String statutoryExpenseCode(ChartAccountResolver roles, StatutoryPayment p) {
  return switch (p) {
    StatutoryPayment.paye => roles.salaries ?? salariesCode,
    StatutoryPayment.rssb => roles.employerRssb ?? employerRssbCode,
    StatutoryPayment.vat => roles.vatPayable ?? '2100',
  };
}

/// What is still owed on [liabilityCode] once payments that wait for approval
/// are counted.
///
/// [Account.bal] counts posted entries only, so a payment saved as pending has
/// not lowered it yet. Without this, a second payment made before the first
/// is approved would see the whole debt again, and approving both (each posts
/// its saved split unchanged) would clear it twice. Each pending debit to the
/// liability is therefore taken off the posted balance.
int statutoryOwed({
  required List<Account> accounts,
  required List<JournalEntry> journal,
  required String liabilityCode,
}) {
  var owed = 0;
  for (final a in accounts) {
    if (a.code == liabilityCode) {
      owed = a.bal;
      break;
    }
  }
  for (final e in journal) {
    if (e.status != JournalStatus.pending) continue;
    for (final l in e.lines) {
      if (l.ac == liabilityCode) owed -= l.dr;
    }
  }
  return owed;
}

/// Builds the journal for a payment to RRA or RSSB.
///
/// VAT always clears 2100 VAT Payable: it is a debt, never a cost, and the
/// dashboard's "VAT payable" must drop by what was paid.
///
/// PAYE and RSSB clear their liability up to [owed] (the liability's credit
/// balance; HR payroll accrues it). Anything paid above that goes to the
/// matching expense, so a business that does payroll outside Flipper still
/// books the cost and never shows a negative debt.
List<JournalLine> buildStatutoryPaymentLines({
  required StatutoryPayment payment,
  required ChartAccountResolver roles,
  required String fundingCode,
  required int amount,
  required int owed,
}) {
  final liability = statutoryLiabilityCode(roles, payment);
  if (payment == StatutoryPayment.vat) {
    return [
      JournalLine(ac: liability, dr: amount),
      JournalLine(ac: fundingCode, cr: amount),
    ];
  }
  final toLiability = owed <= 0 ? 0 : (owed < amount ? owed : amount);
  final toExpense = amount - toLiability;
  return [
    if (toLiability > 0) JournalLine(ac: liability, dr: toLiability),
    if (toExpense > 0)
      JournalLine(ac: statutoryExpenseCode(roles, payment), dr: toExpense),
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
