import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';

enum AccountingView {
  dashboard,
  invoices,
  customers,
  ar,
  bills,
  suppliers,
  ap,
  journal,
  ledger,
  recurring,
  bankRec,
  statements,
  trial,
  tax,
  coa,
  periodClose,
  audit,
  roles,
}

extension AccountingViewX on AccountingView {
  String get key {
    switch (this) {
      case AccountingView.dashboard:
        return 'dashboard';
      case AccountingView.invoices:
        return 'invoices';
      case AccountingView.customers:
        return 'customers';
      case AccountingView.ar:
        return 'ar';
      case AccountingView.bills:
        return 'bills';
      case AccountingView.suppliers:
        return 'suppliers';
      case AccountingView.ap:
        return 'ap';
      case AccountingView.journal:
        return 'journal';
      case AccountingView.ledger:
        return 'ledger';
      case AccountingView.recurring:
        return 'recurring';
      case AccountingView.bankRec:
        return 'bankrec';
      case AccountingView.statements:
        return 'statements';
      case AccountingView.trial:
        return 'trial';
      case AccountingView.tax:
        return 'tax';
      case AccountingView.coa:
        return 'coa';
      case AccountingView.periodClose:
        return 'periodclose';
      case AccountingView.audit:
        return 'audit';
      case AccountingView.roles:
        return 'roles';
    }
  }

  String get label {
    switch (this) {
      case AccountingView.dashboard:
        return 'Dashboard';
      case AccountingView.invoices:
        return 'Invoices';
      case AccountingView.customers:
        return 'Customers';
      case AccountingView.ar:
        return 'Receivables';
      case AccountingView.bills:
        return 'Bills';
      case AccountingView.suppliers:
        return 'Suppliers';
      case AccountingView.ap:
        return 'Payables';
      case AccountingView.journal:
        return 'Journal entries';
      case AccountingView.ledger:
        return 'General ledger';
      case AccountingView.recurring:
        return 'Recurring';
      case AccountingView.bankRec:
        return 'Bank reconciliation';
      case AccountingView.statements:
        return 'Financial statements';
      case AccountingView.trial:
        return 'Trial balance';
      case AccountingView.tax:
        return 'Tax & VAT';
      case AccountingView.coa:
        return 'Chart of accounts';
      case AccountingView.periodClose:
        return 'Period close';
      case AccountingView.audit:
        return 'Audit trail';
      case AccountingView.roles:
        return 'Users & roles';
    }
  }

  String get section {
    switch (this) {
      case AccountingView.dashboard:
        return 'Overview';
      case AccountingView.invoices:
      case AccountingView.customers:
      case AccountingView.ar:
        return 'Sales';
      case AccountingView.bills:
      case AccountingView.suppliers:
      case AccountingView.ap:
        return 'Purchases';
      case AccountingView.journal:
      case AccountingView.ledger:
      case AccountingView.recurring:
      case AccountingView.bankRec:
        return 'Daybook';
      case AccountingView.statements:
      case AccountingView.trial:
      case AccountingView.tax:
        return 'Reports';
      case AccountingView.coa:
      case AccountingView.periodClose:
      case AccountingView.audit:
      case AccountingView.roles:
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
  final AccIcon icon;
  final int? badge;
}

/// Nav icons from handoff `accounting/app.jsx` NAV config.
const accountingNavGroups = <({String section, List<AccountingNavItem> items})>[
  (
    section: 'Overview',
    items: [AccountingNavItem(view: AccountingView.dashboard, icon: AccIcon.home)],
  ),
  (
    section: 'Sales',
    items: [
      AccountingNavItem(view: AccountingView.invoices, icon: AccIcon.receipt),
      AccountingNavItem(view: AccountingView.customers, icon: AccIcon.users),
      AccountingNavItem(view: AccountingView.ar, icon: AccIcon.arrowUpRight),
    ],
  ),
  (
    section: 'Purchases',
    items: [
      AccountingNavItem(view: AccountingView.bills, icon: AccIcon.receipt),
      AccountingNavItem(view: AccountingView.suppliers, icon: AccIcon.truck),
      AccountingNavItem(view: AccountingView.ap, icon: AccIcon.arrowDown),
    ],
  ),
  (
    section: 'Daybook',
    items: [
      AccountingNavItem(view: AccountingView.journal, icon: AccIcon.stack),
      AccountingNavItem(view: AccountingView.ledger, icon: AccIcon.group),
      AccountingNavItem(view: AccountingView.recurring, icon: AccIcon.refresh),
      AccountingNavItem(view: AccountingView.bankRec, icon: AccIcon.wallet),
    ],
  ),
  (
    section: 'Reports',
    items: [
      AccountingNavItem(view: AccountingView.statements, icon: AccIcon.chart),
      AccountingNavItem(view: AccountingView.trial, icon: AccIcon.group),
      AccountingNavItem(view: AccountingView.tax, icon: AccIcon.shieldCheck),
    ],
  ),
  (
    section: 'Setup',
    items: [
      AccountingNavItem(view: AccountingView.coa, icon: AccIcon.building),
      AccountingNavItem(view: AccountingView.periodClose, icon: AccIcon.clock),
      AccountingNavItem(view: AccountingView.audit, icon: AccIcon.eye),
      AccountingNavItem(view: AccountingView.roles, icon: AccIcon.user),
    ],
  ),
];
