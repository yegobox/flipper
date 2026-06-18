import 'package:flutter/foundation.dart';
import 'package:flipper_accounting/accounting_transaction_semantics.dart';
import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/transaction_to_accounts.dart';
import 'package:flipper_accounting/accounting_ledger_repository.dart';

/// Auto-posts COMPLETE POS transactions as balanced journal entries (idempotent).
class TransactionJournalPoster {
  const TransactionJournalPoster(this._ledger, {AuditTrailRecorder? audit})
      : _audit = audit;

  final AccountingLedgerRepository _ledger;
  final AuditTrailRecorder? _audit;

  Future<void> syncTransactions({
    required String businessId,
    required List<Map<String, dynamic>> transactions,
    required List<Map<String, dynamic>> items,
  }) async {
    if (businessId.isEmpty) return;
    if (transactions.isEmpty) {
      debugPrint(
        '[Accounting] auto-poster: no COMPLETE transactions for this branch/period',
      );
      return;
    }

    await _ledger.ensureSeeded(businessId: businessId);

    // [toJournal] emits one entry per *recognized* transaction, preserving
    // order. Pair each entry with the matching transaction from the SAME
    // filtered+ordered list so the transactionId (used for idempotency and
    // source linkage) is never misattributed when the input contains
    // non-recognized rows.
    final recognized =
        transactions.where(isAccountingRecognizedTransaction).toList();
    final derived = TransactionToAccounts.toJournal(recognized, items);
    var created = 0;
    var skipped = 0;

    for (var i = 0; i < derived.length; i++) {
      final entry = derived[i];
      if (i >= recognized.length) continue;
      final txnId = (recognized[i]['id'] ?? recognized[i]['_id'] ?? '')
          .toString();
      if (txnId.isEmpty) continue;

      // Deterministic id shared with the POS-side poster
      // (PosJournalPoster): concurrent posters on different peers converge
      // on the same document instead of duplicating.
      final saleId = 'je_${businessId}_${txnId}_sale';
      final saleExists = await _ledger.entryExists(
        businessId: businessId,
        entryId: saleId,
      );
      // Legacy fallback covers pre-deterministic random-id entries. It also
      // matches loan-payment entries (same transactionId), which is safe:
      // a payment entry only ever exists after the sale entry was created.
      final existing = saleExists
          ? saleId
          : await _ledger.findEntryIdByTransactionId(
              businessId: businessId,
              transactionId: txnId,
            );
      if (existing != null) {
        skipped++;
        continue;
      }

      final createdId = await _ledger.createJournalEntry(
        businessId: businessId,
        entry: entry,
        transactionId: txnId,
        journalCode: entry.src == 'Expense' ? 'misc' : 'sales',
        entryId: saleId,
      );

      await _ledger.postJournalEntry(
        businessId: businessId,
        entryId: createdId,
      );
      created++;

      // Deterministic audit id keeps the trail idempotent alongside the entry.
      await _audit?.record(
        businessId: businessId,
        id: 'audit_$saleId',
        action: 'Posted',
        target: entry.id,
        detail: entry.memo,
        src: 'Books auto-poster',
      );
    }

    if (created > 0 || skipped > 0) {
      debugPrint(
        '[Accounting] auto-poster businessId=$businessId '
        'txns=${transactions.length} created=$created skipped=$skipped',
      );
    }
  }
}
