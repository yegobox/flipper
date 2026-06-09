import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Human-readable backend label for logs and debug UI.
final accountingBackendLabelProvider = Provider<String>((ref) {
  final dittoReady = ref.watch(dittoServiceProvider).isReady();
  return dittoReady ? 'ditto' : 'supabase';
});

/// Runs once when Books opens: logs backend, ids, seed result, COA/journal counts.
final accountingStartupDiagnosticsProvider = FutureProvider<void>((ref) async {
  final backend = ref.read(accountingBackendLabelProvider);
  final dittoReady = ref.read(dittoServiceProvider).isReady();
  final businessId = ref.read(accountingBusinessIdProvider);
  final branchId = ref.read(accountingBranchIdProvider);
  final period = ref.read(accountingPeriodLabelProvider);

  debugPrint(
    '[Accounting] ── startup ── backend=$backend dittoReady=$dittoReady '
    'businessId=${businessId.isEmpty ? "(none)" : businessId} '
    'branchId=${branchId.isEmpty ? "(none)" : branchId} period=$period',
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
