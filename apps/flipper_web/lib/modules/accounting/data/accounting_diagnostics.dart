import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Human-readable backend summary for logs and debug UI.
final accountingBackendLabelProvider = Provider<String>((ref) {
  final strategy = ref.watch(accountingBackendStrategyProvider);
  final txDitto = ref.watch(accountingUseDittoForTransactionsProvider);
  final glDitto = ref.watch(accountingUseDittoForLedgerProvider);
  return 'strategy=${strategy.name} tx=${txDitto ? "ditto" : "supabase"} '
      'ledger=${glDitto ? "ditto" : "supabase"}';
});

/// Runs once when Books opens: logs backend, ids, seed result, COA/journal counts.
final accountingStartupDiagnosticsProvider = FutureProvider<void>((ref) async {
  final backend = ref.read(accountingBackendLabelProvider);
  final dittoReady = ref.read(dittoServiceProvider).isReady();
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

  final ledger = ref.read(accountingLedgerRepositoryProvider);
  try {
    await ledger.ensureSeeded(businessId: businessId);
    debugPrint(
      '[Accounting] ensureSeeded OK (businessId=$businessId via $backend)',
    );
  } catch (e, st) {
    debugPrint('[Accounting] ensureSeeded FAILED: $e\n$st');
    rethrow;
  }

  try {
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
    debugPrint('[Accounting] transactions (period): ${txns.length} COMPLETE rows');
  } catch (e) {
    debugPrint('[Accounting] transaction stream error: $e');
  }

  debugPrint('[Accounting] ── startup complete ──');
});
