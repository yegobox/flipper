import 'package:flutter/material.dart';

enum AccountingView {
  dashboard,
  journal,
  ledger,
  bankRec,
  ar,
  ap,
  tax,
  statements,
  trial,
  coa,
}

extension AccountingViewX on AccountingView {
  String get key {
    switch (this) {
      case AccountingView.dashboard:
        return 'dashboard';
      case AccountingView.journal:
        return 'journal';
      case AccountingView.ledger:
        return 'ledger';
      case AccountingView.bankRec:
        return 'bankrec';
      case AccountingView.ar:
        return 'ar';
      case AccountingView.ap:
        return 'ap';
      case AccountingView.tax:
        return 'tax';
      case AccountingView.statements:
        return 'statements';
      case AccountingView.trial:
        return 'trial';
      case AccountingView.coa:
        return 'coa';
    }
  }

  String get label {
    switch (this) {
      case AccountingView.dashboard:
        return 'Dashboard';
      case AccountingView.journal:
        return 'Journal entries';
      case AccountingView.ledger:
        return 'General ledger';
      case AccountingView.bankRec:
        return 'Bank reconciliation';
      case AccountingView.ar:
        return 'Receivables';
      case AccountingView.ap:
        return 'Payables';
      case AccountingView.tax:
        return 'Tax & VAT';
      case AccountingView.statements:
        return 'Financial statements';
      case AccountingView.trial:
        return 'Trial balance';
      case AccountingView.coa:
        return 'Chart of accounts';
    }
  }

  String get section {
    switch (this) {
      case AccountingView.dashboard:
        return 'Overview';
      case AccountingView.journal:
      case AccountingView.ledger:
      case AccountingView.bankRec:
        return 'Daybook';
      case AccountingView.ar:
      case AccountingView.ap:
      case AccountingView.tax:
        return 'Money';
      case AccountingView.statements:
      case AccountingView.trial:
        return 'Reports';
      case AccountingView.coa:
        return 'Setup';
    }
  }

  static AccountingView? fromKey(String? key) {
    if (key == null) return null;
    for (final v in AccountingView.values) {
      if (v.key == key) return v;
    }
    return null;
  }
}

enum AccountingMobileTab { snapshot, approvals, reports, more }

enum JournalFilter { all, posted, pending, draft }

enum StatementsTab { income, balance, cashFlow }

enum MobileReportKey { pl, bs, tb, vat }

class AccountingNavItem {
  const AccountingNavItem({
    required this.view,
    required this.icon,
    this.badge,
  });

  final AccountingView view;
  final IconData icon;
  final int? badge;
}

const accountingNavGroups = <({String section, List<AccountingNavItem> items})>[
  (
    section: 'Overview',
    items: [AccountingNavItem(view: AccountingView.dashboard, icon: Icons.home_outlined)],
  ),
  (
    section: 'Daybook',
    items: [
      AccountingNavItem(view: AccountingView.journal, icon: Icons.receipt_long_outlined),
      AccountingNavItem(view: AccountingView.ledger, icon: Icons.layers_outlined),
      AccountingNavItem(view: AccountingView.bankRec, icon: Icons.sync_outlined),
    ],
  ),
  (
    section: 'Money',
    items: [
      AccountingNavItem(view: AccountingView.ar, icon: Icons.north_east),
      AccountingNavItem(view: AccountingView.ap, icon: Icons.south_west),
      AccountingNavItem(view: AccountingView.tax, icon: Icons.verified_user_outlined),
    ],
  ),
  (
    section: 'Reports',
    items: [
      AccountingNavItem(view: AccountingView.statements, icon: Icons.bar_chart_outlined),
      AccountingNavItem(view: AccountingView.trial, icon: Icons.grid_view_outlined),
    ],
  ),
  (
    section: 'Setup',
    items: [AccountingNavItem(view: AccountingView.coa, icon: Icons.account_balance_outlined)],
  ),
];
