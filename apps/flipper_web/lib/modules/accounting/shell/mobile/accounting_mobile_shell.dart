import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_bottom_nav.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/views/mobile/mobile_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingMobileShell extends ConsumerWidget {
  const AccountingMobileShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountingMobileTab tab = ref.watch(accountingMobileTabProvider);
    final business = ref.watch(selectedBusinessProvider);
    final entityName = business?.name ?? demoEntityName;

    return Scaffold(
      backgroundColor: AccountingTokens.workspaceBg,
      body: Column(
        children: [
          const AccountingMobileHeader(),
          if (tab == AccountingMobileTab.snapshot)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AccountingTokens.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AccountingTokens.line),
                ),
                child: Text(
                  '$entityName · $demoFiscalYear · $demoCurrency',
                  style: AccountingTokens.sans(fontSize: 12.5, color: AccountingTokens.ink2, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          Expanded(
            child: switch (tab) {
              AccountingMobileTab.snapshot => const AccountingSnapshotTab(),
              AccountingMobileTab.approvals => const AccountingApprovalsTab(),
              AccountingMobileTab.reports => const AccountingReportsTab(),
              AccountingMobileTab.more => const AccountingMoreTab(),
            },
          ),
          const AccountingBottomNav(),
        ],
      ),
    );
  }
}
