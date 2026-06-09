import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final accountingViewProvider = StateProvider<AccountingView>(
  (ref) => AccountingView.dashboard,
);

final accountingMobileTabProvider = StateProvider<AccountingMobileTab>(
  (ref) => AccountingMobileTab.snapshot,
);

final composerOpenProvider = StateProvider<bool>((ref) => false);

final journalFilterProvider = StateProvider<JournalFilter>(
  (ref) => JournalFilter.all,
);

final ledgerAccountCodeProvider = StateProvider<String>((ref) => '1020');

final statementsTabProvider = StateProvider<StatementsTab>(
  (ref) => StatementsTab.income,
);

final mobileReportProvider = StateProvider<MobileReportKey?>((ref) => null);

enum ApprovalAction { approve, reject }

final approvalActionsProvider =
    StateProvider<Map<String, ApprovalAction>>((ref) => {});

final pendingCountProvider = Provider<int>((ref) => pendingJournalCount());
