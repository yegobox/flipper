import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/shell/desktop/accounting_sidebar.dart';
import 'package:flipper_web/modules/accounting/shell/desktop/accounting_topbar.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/views/desktop/admin_views.dart';
import 'package:flipper_web/modules/accounting/views/desktop/aging_view.dart';
import 'package:flipper_web/modules/accounting/views/desktop/billing_views.dart';
import 'package:flipper_web/modules/accounting/views/desktop/contacts_views.dart';
import 'package:flipper_web/modules/accounting/views/desktop/dashboard_view.dart';
import 'package:flipper_web/modules/accounting/views/desktop/journal_view.dart';
import 'package:flipper_web/modules/accounting/views/desktop/other_desktop_views.dart';
import 'package:flipper_web/modules/accounting/widgets/journal_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingDesktopShell extends ConsumerWidget {
  const AccountingDesktopShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountingView view = ref.watch(accountingViewProvider);
    final composerOpen = ref.watch(composerOpenProvider);
    final openComposer = () => ref.read(composerOpenProvider.notifier).state = true;
    final closeComposer = () => ref.read(composerOpenProvider.notifier).state = false;

    return Scaffold(
      backgroundColor: AccountingTokens.workspaceBg,
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AccountingSidebar(),
              Expanded(
                child: Column(
                  children: [
                    const AccountingTopbar(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AccountingTokens.contentMaxWidth,
                          ),
                          child: _DesktopViewRouter(
                            view: view,
                            onNewEntry: openComposer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (composerOpen)
            JournalComposer(onClose: closeComposer),
        ],
      ),
    );
  }
}

class _DesktopViewRouter extends StatelessWidget {
  const _DesktopViewRouter({required this.view, required this.onNewEntry});

  final AccountingView view;
  final VoidCallback onNewEntry;

  @override
  Widget build(BuildContext context) {
    return switch (view) {
      AccountingView.dashboard => AccountingDashboardView(onNewEntry: onNewEntry),
      AccountingView.invoices => const AccountingInvoicesView(),
      AccountingView.customers => const AccountingCustomersView(),
      AccountingView.ar => AccountingAgingView(kind: 'ar', onNewEntry: onNewEntry),
      AccountingView.bills => const AccountingBillsView(),
      AccountingView.suppliers => const AccountingSuppliersView(),
      AccountingView.ap => AccountingAgingView(kind: 'ap', onNewEntry: onNewEntry),
      AccountingView.journal => AccountingJournalView(onNewEntry: onNewEntry),
      AccountingView.ledger => const AccountingGeneralLedgerView(),
      AccountingView.recurring => AccountingRecurringView(onNewEntry: onNewEntry),
      AccountingView.bankRec => const AccountingBankRecView(),
      AccountingView.statements => const AccountingFinancialStatementsView(),
      AccountingView.trial => const AccountingTrialBalanceView(),
      AccountingView.tax => const AccountingTaxVatView(),
      AccountingView.coa => const AccountingChartOfAccountsView(),
      AccountingView.periodClose => const AccountingPeriodCloseView(),
      AccountingView.audit => const AccountingAuditView(),
      AccountingView.roles => const AccountingRolesView(),
    };
  }
}
