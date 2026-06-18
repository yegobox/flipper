import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_bottom_nav.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_header.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/views/mobile/mobile_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingMobileShell extends ConsumerWidget {
  const AccountingMobileShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountingMobileTab tab = ref.watch(accountingMobileTabProvider);

    return Scaffold(
      backgroundColor: AccountingTokens.workspaceBg,
      body: Column(
        children: [
          const AccountingMobileHeader(),
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
