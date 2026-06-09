import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/transaction_to_accounts.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/supabase_accounting_repository.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// ─── UI state (unchanged) ────────────────────────────────────────────────────

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

// ─── Data layer ───────────────────────────────────────────────────────────────

/// Active branch ID. Override in tests via ProviderContainer.override.
final accountingBranchIdProvider = Provider<String>((ref) {
  return ProxyService.box.getBranchId() ?? '';
});

/// Active date range (start, end). Defaults to current calendar month.
final accountingDateRangeProvider =
    StateProvider<(DateTime, DateTime)>((ref) {
  final now = DateTime.now();
  return (DateTime(now.year, now.month, 1), now);
});

/// Backend selector. Swap the return value to switch from Supabase to Ditto:
///
///   return DittoAccountingRepository(DittoService.instance);
///
/// Override in tests via ProviderContainer.override to inject a fake.
final accountingRepositoryProvider = Provider<AccountingRepository>((ref) {
  final client = ref.watch(supabaseProvider);
  return SupabaseAccountingRepository(client);
});

// ─── Raw data streams ────────────────────────────────────────────────────────

/// Real-time stream of completed transaction rows for the active branch/range.
/// Backed by [AccountingRepository.watchTransactions]; backend-agnostic.
final rawTransactionStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(accountingRepositoryProvider);
  final branchId = ref.watch(accountingBranchIdProvider);
  final (start, end) = ref.watch(accountingDateRangeProvider);
  return repo.watchTransactions(
    branchId: branchId,
    startDate: start,
    endDate: end,
  );
});

/// Transaction items for all currently streamed transactions.
/// Re-fetched whenever [rawTransactionStreamProvider] emits a new list.
final rawTransactionItemsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  final ids = txns
      .map((t) => (t['id'] ?? t['_id'] ?? '').toString())
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (ids.isEmpty) return [];
  return ref.watch(accountingRepositoryProvider).fetchTransactionItems(
        transactionIds: ids,
      );
});

// ─── Derived accounting data ──────────────────────────────────────────────────

/// Chart of accounts derived from live transactions, merged with [demoAccounts]
/// for balance-sheet lines that cannot be computed from POS data alone
/// (equity, fixed assets, long-term liabilities).
///
/// Income and expense codes are intentionally excluded from the static merge:
/// the income statement must only reflect live transactions.
/// Derived accounts win on code collision — demo entries only fill gaps.
final accountingAccountsProvider = Provider<List<Account>>((ref) {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  final items = ref.watch(rawTransactionItemsProvider).value ?? [];
  final balanceSheetStatics = demoAccounts
      .where((a) => a.type != AccountType.income && a.type != AccountType.expense)
      .toList();
  return TransactionToAccounts.deriveAccounts(
    txns,
    items,
    staticAccounts: balanceSheetStatics,
  );
});

/// Double-entry journal derived from live transactions.
final accountingJournalProvider = Provider<List<JournalEntry>>((ref) {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  final items = ref.watch(rawTransactionItemsProvider).value ?? [];
  return TransactionToAccounts.toJournal(txns, items);
});

/// Income statement computed from real derived accounts.
final accountingIncomeStatementProvider = Provider<IncomeStatementResult>(
  (ref) {
    final accounts = ref.watch(accountingAccountsProvider);
    return incomeStatement(accounts);
  },
);

/// Monthly revenue vs expenses trend (last ≤6 months, oldest-first).
final accountingTrendProvider = Provider<List<TrendPoint>>((ref) {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  final derived = TransactionToAccounts.toTrend(txns);
  // Fall back to demo trend when no live data is available yet
  return derived.isEmpty ? demoTrend : derived;
});

/// Sum of cash, bank, and MoMo account balances.
final accountingCashBankTotalProvider = Provider<int>((ref) {
  return TransactionToAccounts.cashAndBankTotal(
    ref.watch(accountingAccountsProvider),
  );
});

/// Count of pending journal entries from the live journal.
final pendingCountProvider = Provider<int>((ref) {
  final journal = ref.watch(accountingJournalProvider);
  // Live journal entries are always posted (derived from COMPLETE transactions).
  // Manual/approval entries will be added when the journal-entry write path is built.
  if (journal.isEmpty) return pendingJournalCount(); // demo fallback
  return journal.where((e) => e.status == JournalStatus.pending).length;
});

/// True while the transaction stream has not yet emitted its first value.
final accountingLoadingProvider = Provider<bool>(
  (ref) => ref.watch(rawTransactionStreamProvider).isLoading,
);
