import 'dart:async';

import 'package:flipper_web/core/ditto/accounting_cloud_sync.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/modules/accounting/data/accounting_balances.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/ledger_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/mapper/accounting_transaction_semantics.dart'
    show
        accountingSubTotal,
        accountingTaxAmount,
        isAccountingExpense,
        isAccountingRecognizedTransaction;
import 'package:flipper_web/modules/accounting/data/mapper/transaction_aging.dart';
import 'package:flipper_web/modules/accounting/data/mapper/transaction_to_accounts.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_ledger_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/ditto_accounting_ledger_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/ditto_accounting_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/supabase_accounting_ledger_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/supabase_accounting_repository.dart';
import 'package:flipper_web/modules/accounting/data/transaction_journal_poster.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

// ─── UI state ────────────────────────────────────────────────────────────────

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

/// Local bank-rec lines (design handoff seed or user edits). Falls back to ledger stream.
final bankRecLocalLinesProvider = StateProvider<List<BankLine>?>((ref) => null);

final bankRecFinishedProvider = StateProvider<bool>((ref) => false);

final coaTypeFilterProvider = StateProvider<AccountType?>((ref) => null);

final journalSourceFilterProvider = StateProvider<String?>((ref) => null);

final notificationsReadProvider = StateProvider<bool>((ref) => false);

// ─── Data layer ───────────────────────────────────────────────────────────────

/// Override in tests; at runtime reads [--dart-define=ACCOUNTING_BACKEND=…].
final accountingBackendStrategyProvider = Provider<AccountingBackendStrategy>(
  (ref) => AccountingBackendConfig.strategy,
);

final accountingUseDittoForTransactionsProvider = Provider<bool>((ref) {
  return AccountingBackendConfig.useDitto(
    strategy: ref.watch(accountingBackendStrategyProvider),
    dittoReady: ref.watch(dittoServiceProvider).isReady(),
    layer: AccountingDataLayer.transactions,
  );
});

final accountingUseDittoForLedgerProvider = Provider<bool>((ref) {
  return AccountingBackendConfig.useDitto(
    strategy: ref.watch(accountingBackendStrategyProvider),
    dittoReady: ref.watch(dittoServiceProvider).isReady(),
    layer: AccountingDataLayer.ledger,
  );
});

/// Branch key for transaction queries.
/// Ditto POS documents use [Branch.id] (UUID); Supabase uses [Branch.serverId].
final accountingBranchIdProvider = Provider<String>((ref) {
  final branch = ref.watch(selectedBranchProvider);
  if (branch == null) return '';
  final useDitto = ref.watch(accountingUseDittoForTransactionsProvider);
  return useDitto ? branch.id : branch.serverId.toString();
});

final accountingBusinessIdProvider = Provider<String>((ref) {
  final business = ref.watch(selectedBusinessProvider);
  return business?.id ?? '';
});

final accountingDateRangeProvider =
    StateProvider<(DateTime, DateTime)>((ref) {
  final now = DateTime.now();
  return (DateTime(now.year, now.month, 1), now);
});

final accountingRepositoryProvider = Provider<AccountingRepository>((ref) {
  final strategy = ref.watch(accountingBackendStrategyProvider);
  if (strategy == AccountingBackendStrategy.ditto) {
    debugPrint('[Accounting] transactions repository → ditto');
    return DittoAccountingRepository(ref.watch(dittoServiceProvider));
  }
  debugPrint('[Accounting] transactions repository → supabase');
  return SupabaseAccountingRepository(ref.watch(supabaseProvider));
});

final accountingLedgerRepositoryProvider =
    Provider<AccountingLedgerRepository>((ref) {
  final strategy = ref.watch(accountingBackendStrategyProvider);
  if (strategy == AccountingBackendStrategy.ditto) {
    debugPrint('[Accounting] ledger repository → ditto');
    return DittoAccountingLedgerRepository(ref.watch(dittoServiceProvider));
  }
  debugPrint('[Accounting] ledger repository → supabase');
  return SupabaseAccountingLedgerRepository(ref.watch(supabaseProvider));
});

/// Registers Ditto cloud pull subscriptions for GL + POS (like catalog sync).
final accountingDittoSyncProvider = Provider<void>((ref) {
  final ditto = ref.watch(dittoServiceProvider);
  if (!ditto.isReady()) return;
  if (ref.watch(accountingBackendStrategyProvider) !=
      AccountingBackendStrategy.ditto) {
    return;
  }

  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return;

  final branchId = ref.watch(accountingBranchIdProvider);
  final instance = ditto.dittoInstance;
  if (instance == null) return;

  unawaited(
    ensureAccountingCloudSubscriptions(
      ditto: instance,
      businessId: businessId,
      branchId: branchId.isEmpty ? null : branchId,
    ),
  );
});

// ─── Raw data streams ────────────────────────────────────────────────────────

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

// ─── Ledger streams ──────────────────────────────────────────────────────────

final chartOfAccountsStreamProvider = StreamProvider<List<Account>>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  final ledger = ref.watch(accountingLedgerRepositoryProvider);
  ledger.ensureSeeded(businessId: businessId);
  return ledger.watchChartOfAccounts(businessId: businessId);
});

final journalEntriesStreamProvider = StreamProvider<List<JournalEntry>>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  final (start, end) = ref.watch(accountingDateRangeProvider);
  return ref.watch(accountingLedgerRepositoryProvider).watchJournalEntries(
        businessId: businessId,
        startDate: start,
        endDate: end,
      );
});

final bankLinesStreamProvider = StreamProvider<List<BankLine>>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  return ref.watch(accountingLedgerRepositoryProvider).watchBankLines(
        businessId: businessId,
      );
});

// ─── Auto-poster (transaction → journal) ─────────────────────────────────────

final accountingAutoPosterProvider = Provider<void>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return;

  Future<void> sync() async {
    final txns = ref.read(rawTransactionStreamProvider).value ?? [];
    if (txns.isEmpty) return;
    final items = await ref.read(rawTransactionItemsProvider.future);
    await TransactionJournalPoster(ref.read(accountingLedgerRepositoryProvider))
        .syncTransactions(
      businessId: businessId,
      transactions: txns,
      items: items,
    );
  }

  ref.listen(rawTransactionStreamProvider, (_, __) => sync());
  ref.listen(rawTransactionItemsProvider, (_, __) => sync());
});

// ─── Derived accounting data ─────────────────────────────────────────────────

final accountingCoaProvider = Provider<List<Account>>((ref) {
  return ref.watch(chartOfAccountsStreamProvider).value ?? [];
});

final accountingJournalProvider = Provider<List<JournalEntry>>((ref) {
  return ref.watch(journalEntriesStreamProvider).value ?? [];
});

final accountingAccountsProvider = Provider<List<Account>>((ref) {
  final coa = ref.watch(accountingCoaProvider);
  final journal = ref.watch(accountingJournalProvider);
  if (coa.isEmpty) return [];
  return accountsWithBalances(coa, journal);
});

final accountingIncomeStatementProvider = Provider<IncomeStatementResult>(
  (ref) => incomeStatement(ref.watch(accountingAccountsProvider)),
);

final accountingPriorIncomeStatementProvider = Provider<IncomeStatementResult>(
  (ref) {
    final accounts = ref.watch(accountingAccountsProvider);
    return incomeStatement(accounts);
  },
);

final accountingTrendProvider = Provider<List<TrendPoint>>((ref) {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  return TransactionToAccounts.toTrend(txns);
});

final accountingCashBankTotalProvider = Provider<int>((ref) {
  return TransactionToAccounts.cashAndBankTotal(
    ref.watch(accountingAccountsProvider),
  );
});

final accountingInventoryValueProvider = FutureProvider<int>((ref) async {
  final branchId = ref.watch(accountingBranchIdProvider);
  if (branchId.isEmpty) return 0;
  return ref.watch(accountingLedgerRepositoryProvider).fetchInventoryValue(
        branchId: branchId,
      );
});

final accountingArAgingProvider = Provider<List<AgingRow>>((ref) {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  return deriveArAging(txns);
});

final accountingApAgingProvider = Provider<List<AgingRow>>((ref) {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  return deriveApAging(txns);
});

final accountingVatProvider = Provider<VatInfo?>((ref) {
  final txns = ref.watch(rawTransactionStreamProvider).value ?? [];
  final settings = ref.watch(accountingSettingsProvider).value;

  var outputVat = 0;
  var inputVat = 0;
  var totalSalesVatInclusive = 0;
  for (final t in txns) {
    if (!isAccountingRecognizedTransaction(t)) continue;
    final tax = accountingTaxAmount(t);
    final isExpense = isAccountingExpense(t);
    if (isExpense) {
      inputVat += tax;
    } else {
      outputVat += tax;
      totalSalesVatInclusive += accountingSubTotal(t) + tax;
    }
  }

  if (outputVat == 0 && inputVat == 0) return null;

  final (_, end) = ref.watch(accountingDateRangeProvider);
  final dueDay = _rawInt(settings?['vat_due_day'] ?? settings?['vatDueDay']) == 0
      ? 15
      : _rawInt(settings?['vat_due_day'] ?? settings?['vatDueDay']);
  final dueMonth = DateTime(end.year, end.month + 1, dueDay);
  final dueLabel = DateFormat('d MMM yyyy').format(dueMonth);

  return LedgerRowMapper.settingsToVat(
    settings,
    outputVat: outputVat,
    inputVat: inputVat,
    totalSalesVatInclusive: totalSalesVatInclusive,
    dueDateLabel: dueLabel,
  );
});

final accountingBankLinesProvider = Provider<List<BankLine>>((ref) {
  final local = ref.watch(bankRecLocalLinesProvider);
  if (local != null) return local;
  return ref.watch(bankLinesStreamProvider).value ?? [];
});

final accountingSettingsProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return null;
  return ref.watch(accountingLedgerRepositoryProvider).fetchSettings(
        businessId: businessId,
      );
});

// ─── Context metadata ────────────────────────────────────────────────────────

final accountingFiscalYearLabelProvider = Provider<String>((ref) {
  final (_, end) = ref.watch(accountingDateRangeProvider);
  return 'FY ${end.year}';
});

final accountingPeriodLabelProvider = Provider<String>((ref) {
  final (_, end) = ref.watch(accountingDateRangeProvider);
  return DateFormat('MMM yyyy').format(end);
});

final accountingCurrencyProvider = Provider<String>((ref) {
  final business = ref.watch(selectedBusinessProvider);
  final c = business?.currency ?? '';
  return c.isNotEmpty ? c : 'RWF';
});

final accountingUserNameProvider = Provider<String>((ref) {
  final profile = ref.watch(userProfileCacheProvider);
  if (profile == null) return '';
  if (profile.tenants.isNotEmpty &&
      profile.tenants.first.businesses.isNotEmpty) {
    final fn = profile.tenants.first.businesses.first.fullName;
    if (fn.isNotEmpty) return fn;
  }
  return profile.phoneNumber;
});

final accountingUserRoleProvider = Provider<String>((ref) {
  final profile = ref.watch(userProfileCacheProvider);
  if (profile != null && profile.tenants.isNotEmpty) {
    return profile.tenants.first.type;
  }
  return '';
});

final pendingCountProvider = Provider<int>((ref) {
  final journal = ref.watch(accountingJournalProvider);
  return pendingJournalCount(journal);
});

final accountingLoadingProvider = Provider<bool>((ref) {
  return ref.watch(rawTransactionStreamProvider).isLoading ||
      ref.watch(chartOfAccountsStreamProvider).isLoading;
});

int _rawInt(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.round();
  return int.tryParse(v.toString()) ?? 0;
}
