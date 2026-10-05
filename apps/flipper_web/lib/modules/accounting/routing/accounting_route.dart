import 'package:flipper_localize/flipper_localize.dart';
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

  /// Localized page / nav label in the last-loaded locale. Prefer
  /// [localizedLabel] with `context.flipperL10n` inside widgets.
  String get label => localizedLabel(FlipperL10n.current);

  /// Localized page / nav label.
  String localizedLabel(FlipperAppLocalizations l10n) {
    switch (this) {
      case AccountingView.dashboard:
        return l10n.dashboard;
      case AccountingView.invoices:
        return l10n.invoices;
      case AccountingView.customers:
        return l10n.customers;
      case AccountingView.ar:
        return l10n.booksReceivables;
      case AccountingView.bills:
        return l10n.booksBills;
      case AccountingView.suppliers:
        return l10n.booksSuppliers;
      case AccountingView.ap:
        return l10n.booksPayables;
      case AccountingView.journal:
        return l10n.booksJournalEntries;
      case AccountingView.ledger:
        return l10n.booksGeneralLedger;
      case AccountingView.recurring:
        return l10n.booksRecurring;
      case AccountingView.bankRec:
        return l10n.booksBankReconciliation;
      case AccountingView.statements:
        return l10n.booksFinancialStatements;
      case AccountingView.trial:
        return l10n.booksTrialBalance;
      case AccountingView.tax:
        return l10n.booksTaxVat;
      case AccountingView.coa:
        return l10n.booksChartOfAccounts;
      case AccountingView.periodClose:
        return l10n.booksPeriodClose;
      case AccountingView.audit:
        return l10n.booksAuditTrail;
      case AccountingView.roles:
        return l10n.booksUsersRoles;
    }
  }

  /// Localized nav-section label (see [accountingSectionLabel]).
  String sectionLabel(FlipperAppLocalizations l10n) =>
      accountingSectionLabel(section, l10n);

  /// Stable nav-section id (`Overview`, `Sales`, …) — not shown to users;
  /// render it through [accountingSectionLabel].
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

/// Display text for a nav-section id from [AccountingViewX.section] /
/// [accountingNavGroups].
String accountingSectionLabel(String section, FlipperAppLocalizations l10n) {
  switch (section) {
    case 'Overview':
      return l10n.booksOverview;
    case 'Sales':
      return l10n.sales;
    case 'Purchases':
      return l10n.purchases;
    case 'Daybook':
      return l10n.booksDaybook;
    case 'Reports':
      return l10n.reports;
    case 'Setup':
      return l10n.booksSetup;
    default:
      return section;
  }
}

enum AccountingMobileTab { snapshot, approvals, reports, more }

enum JournalFilter { all, posted, pending, draft }

enum StatementsTab { income, balance, cashFlow }

enum MobileReportKey { pl, bs, tb, vat }

class AccountingNavItem {
  const AccountingNavItem({required this.view, required this.icon, this.badge});

  final AccountingView view;
  final AccIcon icon;
  final int? badge;
}

/// Nav icons from handoff `accounting/app.jsx` NAV config.
const accountingNavGroups = <({String section, List<AccountingNavItem> items})>[
  (
    section: 'Overview',
    items: [
      AccountingNavItem(view: AccountingView.dashboard, icon: AccIcon.home),
    ],
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
