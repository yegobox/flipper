import 'package:flutter/foundation.dart';
import 'package:flipper_web/modules/accounting/data/mapper/accounting_transaction_semantics.dart';
import 'package:flipper_web/modules/accounting/data/mapper/transaction_to_accounts.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_ledger_repository.dart';

/// Auto-posts COMPLETE POS transactions as balanced journal entries (idempotent).
class TransactionJournalPoster {
  const TransactionJournalPoster(this._ledger);

  final AccountingLedgerRepository _ledger;

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

      final existing = await _ledger.findEntryIdByTransactionId(
        businessId: businessId,
        transactionId: txnId,
      );
      if (existing != null) {
        skipped++;
        continue;
      }

      await _ledger.createJournalEntry(
        businessId: businessId,
        entry: entry,
        transactionId: txnId,
        journalCode: entry.src == 'Expense' ? 'misc' : 'sales',
      );

      final createdId = await _ledger.findEntryIdByTransactionId(
        businessId: businessId,
        transactionId: txnId,
      );
      if (createdId != null) {
        await _ledger.postJournalEntry(
          businessId: businessId,
          entryId: createdId,
        );
        created++;
      }
    }

    if (created > 0 || skipped > 0) {
      debugPrint(
        '[Accounting] auto-poster businessId=$businessId '
        'txns=${transactions.length} created=$created skipped=$skipped',
      );
    }
  }
}
