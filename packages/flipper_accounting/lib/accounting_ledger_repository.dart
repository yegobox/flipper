import 'package:flipper_accounting/accounting_models.dart';

/// Backend-agnostic contract for GL data (chart of accounts, journals, bank lines).
abstract class AccountingLedgerRepository {
  /// Ensures default COA, journals, and settings exist for [businessId].
  Future<void> ensureSeeded({required String businessId});

  Stream<List<Account>> watchChartOfAccounts({required String businessId});

  Stream<List<JournalEntry>> watchJournalEntries({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Returns existing entry id when [transactionId] was already posted.
  Future<String?> findEntryIdByTransactionId({
    required String businessId,
    required String transactionId,
  });

  /// True when an entry with backend id [entryId] already exists (used with
  /// deterministic ids for cheap idempotency checks).
  Future<bool> entryExists({
    required String businessId,
    required String entryId,
  });

  /// [entryId] pins the backend document id. Deterministic ids (e.g.
  /// `je_<businessId>_<transactionId>_sale`) let concurrent posters on
  /// different peers converge on the same document instead of duplicating.
  Future<String> createJournalEntry({
    required String businessId,
    required JournalEntry entry,
    String? transactionId,
    String? journalCode,
    String? entryId,
  });

  Future<void> updateJournalEntry({
    required String businessId,
    required String entryId,
    required JournalEntry entry,
  });

  Future<void> postJournalEntry({
    required String businessId,
    required String entryId,
  });

  Stream<List<BankLine>> watchBankLines({
    required String businessId,
    String bankAccountCode = '1020',
  });

  Future<void> upsertBankLine({
    required String businessId,
    required BankLine line,
    String bankAccountCode = '1020',
    String? id,
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  });

  /// Removes all imported bank statement lines for [businessId] (debug / re-import).
  Future<void> clearBankStatementLines({
    required String businessId,
    String bankAccountCode = '1020',
  });

  Future<Map<String, dynamic>?> fetchSettings({required String businessId});

  /// Sum of inventory value (supply_price × current_stock) for a branch.
  Future<int> fetchInventoryValue({required String branchId});
}
