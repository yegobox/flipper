/// Pure rules behind the personal money app: which transactions are personal
/// income or spending, how they group, and the category lists. No widgets, so
/// they stay unit-testable.
library;

import 'package:flipper_dashboard/cashbook_form_rules.dart'
    show cashbookCategoryName;
import 'package:flipper_models/db_model_export.dart' show ITransaction;
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';

/// What personal money comes from. Category names are shared data (the
/// branch's categories), so they are stored in English like the seeded ones.
const kPersonalIncomeCategories = [
  'Salary',
  'Business income',
  'Gift',
  'Loan received',
  'Other income',
];

/// What personal money goes on.
const kPersonalExpenseCategories = [
  'Food',
  'Transport',
  'Rent',
  'Utilities',
  'Airtime & data',
  'School fees',
  'Health',
  'Family support',
  'Savings',
  'Loan repayment',
  'Shopping',
  'Other',
];

IconData personalCategoryIcon(String? category) {
  switch (category?.trim().toLowerCase()) {
    case 'salary':
    case 'business income':
      return Icons.payments_outlined;
    case 'gift':
      return Icons.card_giftcard_outlined;
    case 'loan received':
    case 'loan repayment':
      return Icons.handshake_outlined;
    case 'food':
      return Icons.restaurant_outlined;
    case 'transport':
      return Icons.directions_bus_outlined;
    case 'rent':
      return Icons.home_outlined;
    case 'utilities':
      return Icons.bolt_outlined;
    case 'airtime & data':
    case 'airtime':
      return Icons.phone_android_outlined;
    case 'school fees':
      return Icons.school_outlined;
    case 'health':
      return Icons.local_hospital_outlined;
    case 'family support':
      return Icons.family_restroom_outlined;
    case 'savings':
      return Icons.savings_outlined;
    case 'shopping':
      return Icons.shopping_bag_outlined;
    case 'bank charges':
      return Icons.account_balance_outlined;
    default:
      return Icons.category_outlined;
  }
}

/// Where money sits, as Books groups it (1010 / 1020 / 1030).
enum PersonalMoneyAccount { cash, bank, mobileMoney }

PersonalMoneyAccount personalAccountFor(String? paymentType) {
  if (isMobileMoneyTender(paymentType)) return PersonalMoneyAccount.mobileMoney;
  final p = paymentType?.toUpperCase() ?? '';
  if (p.contains('BANK') || p.contains('CARD') || p.contains('TRANSFER')) {
    return PersonalMoneyAccount.bank;
  }
  return PersonalMoneyAccount.cash;
}

/// `transaction.paymentType` values the add form offers.
const String kPersonalMethodCash = 'CASH';
const String kPersonalMethodBank = 'BANK TRANSFER';
const List<String> kPersonalPaymentMethods = [
  kPersonalMethodCash,
  kMobileMoney,
  kAirtelMoney,
  kPersonalMethodBank,
];

/// One Cash In or Cash Out, as the personal app shows it.
class PersonalMovement {
  const PersonalMovement({
    required this.id,
    required this.isIncome,
    required this.amount,
    required this.category,
    required this.account,
    required this.at,
    this.note,
  });

  final String id;
  final bool isIncome;
  final double amount;

  /// `null` when the movement has none.
  final String? category;
  final PersonalMoneyAccount account;
  final DateTime at;
  final String? note;
}

/// The movement [t] is, or `null` for anything that is not a completed Cash
/// In / Cash Out (sales, refunds, purchase mirrors, order carts). Same rule as
/// `isAccountingCashIn` and data-connector `semantics::cash_movement`.
PersonalMovement? personalMovementFrom(ITransaction t) {
  if (t.id.startsWith('purchase_exp_') || t.id.startsWith('bill_pay_')) {
    return null;
  }
  final amount = t.subTotal ?? 0;
  if (amount <= 0) return null;
  final receipt = t.receiptType?.trim();
  final bool isIncome;
  if (receipt == 'Cash In') {
    isIncome = true;
  } else if (receipt == 'Cash Out') {
    isIncome = false;
  } else if (receipt == null || receipt.isEmpty || receipt == 'NS') {
    final type = t.transactionType?.trim();
    if (type == 'Cash In' && t.isExpense != true) {
      isIncome = true;
    } else if (type == 'Cash Out' && t.isExpense == true) {
      isIncome = false;
    } else {
      return null;
    }
  } else {
    return null;
  }
  return PersonalMovement(
    id: t.id,
    isIncome: isIncome,
    amount: amount,
    category: cashbookCategoryName(t.transactionType),
    account: personalAccountFor(t.paymentType),
    at: (t.createdAt ?? t.lastTouched ?? DateTime.now()).toLocal(),
    note: t.note?.trim().isEmpty ?? true ? null : t.note!.trim(),
  );
}

/// Totals for one month.
class PersonalMonthSummary {
  const PersonalMonthSummary({
    required this.income,
    required this.spent,
    required this.spentByCategory,
    required this.netByAccount,
    required this.movements,
  });

  static const empty = PersonalMonthSummary(
    income: 0,
    spent: 0,
    spentByCategory: [],
    netByAccount: {},
    movements: [],
  );

  final double income;
  final double spent;
  double get leftOver => income - spent;

  /// Biggest first. `null` category = uncategorised.
  final List<({String? category, double amount})> spentByCategory;

  /// In minus out per account this month.
  final Map<PersonalMoneyAccount, double> netByAccount;

  /// Newest first.
  final List<PersonalMovement> movements;

  bool get isEmpty => movements.isEmpty;
}

PersonalMonthSummary summarizePersonalMonth(
  Iterable<PersonalMovement> movements,
) {
  var income = 0.0;
  var spent = 0.0;
  final byCategory = <String?, double>{};
  final byAccount = <PersonalMoneyAccount, double>{};
  final seen = <String>{};
  final list = <PersonalMovement>[];
  for (final m in movements) {
    if (!seen.add(m.id)) continue;
    list.add(m);
    if (m.isIncome) {
      income += m.amount;
      byAccount[m.account] = (byAccount[m.account] ?? 0) + m.amount;
    } else {
      spent += m.amount;
      byAccount[m.account] = (byAccount[m.account] ?? 0) - m.amount;
      byCategory[m.category] = (byCategory[m.category] ?? 0) + m.amount;
    }
  }
  list.sort((a, b) => b.at.compareTo(a.at));
  final cats =
      [for (final e in byCategory.entries) (category: e.key, amount: e.value)]
        ..sort((a, b) {
          final byAmount = b.amount.compareTo(a.amount);
          if (byAmount != 0) return byAmount;
          return (a.category ?? '~').compareTo(b.category ?? '~');
        });
  return PersonalMonthSummary(
    income: income,
    spent: spent,
    spentByCategory: cats,
    netByAccount: byAccount,
    movements: list,
  );
}

DateTime personalMonthStart(DateTime month) =>
    DateTime(month.year, month.month);

/// Last moment of [month].
DateTime personalMonthEnd(DateTime month) => DateTime(
  month.year,
  month.month + 1,
).subtract(const Duration(milliseconds: 1));
