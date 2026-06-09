import 'package:flutter/foundation.dart';
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

    final derived = TransactionToAccounts.toJournal(transactions, items);
    var created = 0;
    var skipped = 0;

    for (var i = 0; i < derived.length; i++) {
      final entry = derived[i];
      if (i >= transactions.length) continue;
      final txnId = (transactions[i]['id'] ?? transactions[i]['_id'] ?? '')
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
