import 'dart:async';

import 'package:flipper_web/core/ditto/accounting_cloud_sync.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
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
import 'package:flipper_web/modules/accounting/data/services/bank_statement_service.dart';
import 'package:flipper_accounting/audit_trail_recorder.dart';
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

/// Metadata (bank name, closing balance, period) from the most recently
/// imported statement — drives the statement-balance KPI card.
final bankStatementMetaProvider = StateProvider<ParsedStatement?>((ref) => null);

final bankStatementServiceProvider = Provider<BankStatementService>(
  (ref) => BankStatementService(),
);

final coaTypeFilterProvider = StateProvider<AccountType?>((ref) => null);

final journalSourceFilterProvider = StateProvider<String?>((ref) => null);

final notificationsReadProvider = StateProvider<bool>((ref) => false);

// ─── Data layer ───────────────────────────────────────────────────────────────

/// Override in tests; at runtime reads [--dart-define=ACCOUNTING_BACKEND=…].
final accountingBackendStrategyProvider = Provider<AccountingBackendStrategy>(
  (ref) => AccountingBackendConfig.strategy,
);

final accountingUseDittoForTransactionsProvider = Provider<bool>((ref) {
  ref.watch(dittoReadyProvider);
  return AccountingBackendConfig.useDitto(
    strategy: ref.watch(accountingBackendStrategyProvider),
    dittoReady: ref.watch(dittoReadyProvider),
    layer: AccountingDataLayer.transactions,
  );
});

final accountingUseDittoForLedgerProvider = Provider<bool>((ref) {
  ref.watch(dittoReadyProvider);
  return AccountingBackendConfig.useDitto(
    strategy: ref.watch(accountingBackendStrategyProvider),
    dittoReady: ref.watch(dittoReadyProvider),
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

Completer<void>? _accountingBootstrapInFlight;
String _accountingBootstrapScopeKey = '';

String _accountingBootstrapScope(String businessId, String branchId) =>
    '$businessId|$branchId';

void _ensureAccountingBootstrapScope(String businessId, String branchId) {
  final scope = _accountingBootstrapScope(businessId, branchId);
  if (scope == _accountingBootstrapScopeKey) return;
  _accountingBootstrapScopeKey = scope;
  resetAccountingCloudSubscriptionKeys();
  debugPrint(
    '[Accounting] bootstrap scope changed → businessId=$businessId branchId=$branchId',
  );
}

/// Re-invalidates Books streams after slow web replication (dart2wasm DQL lag).
void _scheduleAccountingReplicationRefresh(Ref ref) {
  for (final delay in const [15, 45, 90]) {
    unawaited(
      Future<void>.delayed(Duration(seconds: delay), () {
        if (!ref.mounted) return;
        debugPrint(
          '[Accounting] delayed stream refresh after replication wait (+${delay}s)',
        );
        invalidateAccountingDataStreams(ref);
      }),
    );
  }
}

/// Blocks until [dittoReadyProvider] is true (or times out).
Future<bool> waitForAccountingDittoReady(
  Ref ref, {
  Duration timeout = const Duration(seconds: 90),
}) async {
  if (ref.read(dittoReadyProvider)) return true;
  final deadline = DateTime.now().add(timeout);
  while (!ref.read(dittoReadyProvider)) {
    if (!ref.mounted || DateTime.now().isAfter(deadline)) {
      return false;
    }
    await Future.delayed(const Duration(milliseconds: 100));
  }
  return true;
}

/// Ditto replication + COA seed. Uses [ref.read] only — safe to call from
/// providers without triggering same-frame rebuild loops.
Future<void> runAccountingPostSyncBootstrap(Ref ref) async {
  if (ref.read(accountingBackendStrategyProvider) !=
      AccountingBackendStrategy.ditto) {
    return;
  }

  if (_accountingBootstrapInFlight != null) {
    return _accountingBootstrapInFlight!.future;
  }

  final completer = Completer<void>();
  _accountingBootstrapInFlight = completer;

  try {
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;

    final branchId = ref.read(accountingBranchIdProvider);
    _ensureAccountingBootstrapScope(businessId, branchId);
    final instance = ref.read(dittoServiceProvider).dittoInstance;
    if (instance == null) return;

    await ensureAccountingCloudSubscriptions(
      ditto: instance,
      businessId: businessId,
      branchId: branchId.isEmpty ? null : branchId,
    );

    final replicated = await waitForAccountingReplication(
      ditto: instance,
      businessId: businessId,
      branchId: branchId.isEmpty ? null : branchId,
    );

    final cloudSyncUp =
        instance.sync.isActive && instance.auth.status.isAuthenticated;
    if (!replicated && kIsWeb && cloudSyncUp) {
      debugPrint(
        '[Accounting] web replication slow — skipping COA seed while cloud sync '
        'is active (avoids empty defaults on dart2wasm / slow DQL)',
      );
      _scheduleAccountingReplicationRefresh(ref);
    } else {
      await ref.read(accountingLedgerRepositoryProvider).ensureSeeded(
            businessId: businessId,
          );
    }

    invalidateAccountingDataStreams(ref);
    debugPrint('[Accounting] post-sync bootstrap complete');
  } catch (e, st) {
    if (!completer.isCompleted) completer.completeError(e, st);
    rethrow;
  } finally {
    if (!completer.isCompleted) completer.complete();
    if (identical(_accountingBootstrapInFlight, completer)) {
      _accountingBootstrapInFlight = null;
    }
  }
}

/// Registers Ditto subscriptions, waits for replication, seeds COA if empty,
/// logs diagnostics, then refreshes data streams.
final accountingPostSyncBootstrapProvider = FutureProvider<void>((ref) async {
  // Wait for restore/login choices before reading branch for cloud subscriptions.
  await ref.watch(selectedBusinessRestoreProvider.future);

  ref.watch(dittoReadyProvider);
  final businessId = ref.watch(accountingBusinessIdProvider);
  final branchId = ref.watch(accountingBranchIdProvider);
  if (businessId.isEmpty) return;

  debugPrint(
    '[Accounting] post-sync bootstrap scheduled '
    'businessId=$businessId branchId=${branchId.isEmpty ? "(none)" : branchId} '
    'branch=${ref.read(selectedBranchProvider)?.name ?? "(none)"}',
  );

  final strategy = ref.read(accountingBackendStrategyProvider);
  if (strategy == AccountingBackendStrategy.ditto) {
    if (!ref.read(dittoReadyProvider)) {
      if (!await waitForAccountingDittoReady(ref)) {
        debugPrint('[Accounting] post-sync bootstrap aborted — Ditto not ready');
        return;
      }
    }
    try {
      await runAccountingPostSyncBootstrap(ref);
      debugPrint(
        '[Accounting] post-sync bootstrap OK (businessId=$businessId)',
      );
    } catch (e, st) {
      debugPrint('[Accounting] post-sync bootstrap FAILED: $e\n$st');
      rethrow;
    }
  } else {
    try {
      await ref.read(accountingLedgerRepositoryProvider).ensureSeeded(
            businessId: businessId,
          );
      debugPrint(
        '[Accounting] ensureSeeded OK (businessId=$businessId via supabase)',
      );
    } catch (e, st) {
      debugPrint('[Accounting] ensureSeeded FAILED: $e\n$st');
      rethrow;
    }
  }

  // Yield so stream invalidations from bootstrap can settle before we read them.
  await Future<void>.delayed(Duration.zero);
  if (!ref.mounted) return;

  await logAccountingStartupDiagnostics(ref);
});

/// @deprecated Use [accountingPostSyncBootstrapProvider].
final accountingDittoSyncProvider = Provider<void>((ref) {
  ref.watch(accountingPostSyncBootstrapProvider);
});

// ─── Raw data streams ────────────────────────────────────────────────────────

final rawTransactionStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  if (ref.watch(accountingBackendStrategyProvider) ==
          AccountingBackendStrategy.ditto &&
      !ref.watch(dittoReadyProvider)) {
    return const Stream.empty();
  }
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
  if (ref.watch(accountingBackendStrategyProvider) ==
          AccountingBackendStrategy.ditto &&
      !ref.watch(dittoReadyProvider)) {
    return const Stream.empty();
  }
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  return ref
      .watch(accountingLedgerRepositoryProvider)
      .watchChartOfAccounts(businessId: businessId);
});

final journalEntriesStreamProvider = StreamProvider<List<JournalEntry>>((ref) {
  if (ref.watch(accountingBackendStrategyProvider) ==
          AccountingBackendStrategy.ditto &&
      !ref.watch(dittoReadyProvider)) {
    return const Stream.empty();
  }
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
    final ditto = ref.read(dittoServiceProvider);
    await TransactionJournalPoster(
      ref.read(accountingLedgerRepositoryProvider),
      audit: AuditTrailRecorder(ditto),
    ).syncTransactions(
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
  if (ref.watch(accountingBackendStrategyProvider) ==
          AccountingBackendStrategy.ditto &&
      !ref.watch(dittoReadyProvider)) {
    return 0;
  }
  final branchId = ref.watch(accountingBranchIdProvider);
  if (branchId.isEmpty) return 0;
  return ref.watch(accountingLedgerRepositoryProvider).fetchInventoryValue(
        branchId: branchId,
      );
});

/// Open receivables/payables are balances, not period flows: a loan from a
/// prior month is still owed today. Aging therefore reads ALL finalized
/// transactions for the branch, ignoring the selected accounting period.
final rawAllTransactionsStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  if (ref.watch(accountingBackendStrategyProvider) ==
          AccountingBackendStrategy.ditto &&
      !ref.watch(dittoReadyProvider)) {
    return const Stream.empty();
  }
  final repo = ref.watch(accountingRepositoryProvider);
  final branchId = ref.watch(accountingBranchIdProvider);
  return repo.watchTransactions(branchId: branchId);
});

final accountingArAgingProvider = Provider<List<AgingRow>>((ref) {
  final txns = ref.watch(rawAllTransactionsStreamProvider).value ?? [];
  return deriveArAging(txns);
});

final accountingApAgingProvider = Provider<List<AgingRow>>((ref) {
  final txns = ref.watch(rawAllTransactionsStreamProvider).value ?? [];
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
  if (ref.watch(accountingBackendStrategyProvider) ==
          AccountingBackendStrategy.ditto &&
      !ref.watch(dittoReadyProvider)) {
    return null;
  }
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

/// Refreshes Ditto-backed accounting streams after replication / COA seed.
void invalidateAccountingDataStreams(Ref ref) {
  ref.invalidate(rawTransactionStreamProvider);
  ref.invalidate(rawTransactionItemsProvider);
  ref.invalidate(rawAllTransactionsStreamProvider);
  ref.invalidate(chartOfAccountsStreamProvider);
  ref.invalidate(journalEntriesStreamProvider);
  ref.invalidate(bankLinesStreamProvider);
  ref.invalidate(accountingSettingsProvider);
  ref.invalidate(accountingInventoryValueProvider);
}

/// Logs GL/POS counts after bootstrap — plain function, not a FutureProvider.
Future<void> logAccountingStartupDiagnostics(Ref ref) async {
  final backend = ref.read(accountingBackendLabelProvider);
  final dittoReady = ref.read(dittoReadyProvider);
  final businessId = ref.read(accountingBusinessIdProvider);
  final branchId = ref.read(accountingBranchIdProvider);
  final period = ref.read(accountingPeriodLabelProvider);

  final branch = ref.read(selectedBranchProvider);
  final txDitto = ref.read(accountingUseDittoForTransactionsProvider);
  final branchKeyKind = txDitto ? 'dittoUuid' : 'supabaseServerId';
  debugPrint(
    '[Accounting] ── startup ── $backend dittoReady=$dittoReady '
    'businessId=${businessId.isEmpty ? "(none)" : businessId} '
    'branchId=${branchId.isEmpty ? "(none)" : branchId} ($branchKeyKind'
    '${branch != null ? ', branch=${branch.name}' : ''}) period=$period',
  );

  if (businessId.isEmpty) {
    debugPrint('[Accounting] waiting for business selection — no seed yet');
    return;
  }

  try {
    if (ref.read(accountingBackendStrategyProvider) ==
            AccountingBackendStrategy.ditto &&
        ref.read(dittoReadyProvider)) {
      final directRows = await ref.read(dittoServiceProvider).queryCollection(
            'chart_of_accounts',
            'SELECT * FROM chart_of_accounts WHERE businessId = :businessId',
            {'businessId': businessId},
          );
      debugPrint(
        '[Accounting] chart_of_accounts (DQL): ${directRows.length} rows',
      );
    }
    final coa = await ref.read(chartOfAccountsStreamProvider.future);
    debugPrint('[Accounting] chart_of_accounts: ${coa.length} accounts');
    if (coa.isNotEmpty) {
      debugPrint(
        '[Accounting]   sample codes: ${coa.take(5).map((a) => a.code).join(", ")}',
      );
    }
  } catch (e) {
    debugPrint('[Accounting] COA stream error: $e');
  }

  try {
    final journal = await ref.read(journalEntriesStreamProvider.future);
    final pending =
        journal.where((e) => e.status == JournalStatus.pending).length;
    final posted =
        journal.where((e) => e.status == JournalStatus.posted).length;
    debugPrint(
      '[Accounting] journal_entries: ${journal.length} total '
      '($posted posted, $pending pending)',
    );
  } catch (e) {
    debugPrint('[Accounting] journal stream error: $e');
  }

  try {
    final txns = await ref.read(rawTransactionStreamProvider.future);
    debugPrint(
      '[Accounting] transactions (period): ${txns.length} COMPLETE rows',
    );
  } catch (e) {
    debugPrint('[Accounting] transaction stream error: $e');
  }

  debugPrint('[Accounting] ── startup complete ──');
}

/// Debug label for startup logs ([logAccountingStartupDiagnostics]).
final accountingBackendLabelProvider = Provider<String>((ref) {
  final strategy = ref.read(accountingBackendStrategyProvider);
  final txDitto = ref.read(accountingUseDittoForTransactionsProvider);
  final glDitto = ref.read(accountingUseDittoForLedgerProvider);
  return 'strategy=${strategy.name} tx=${txDitto ? "ditto" : "supabase"} '
      'ledger=${glDitto ? "ditto" : "supabase"}';
});
