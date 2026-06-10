import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

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

  Future<String> createJournalEntry({
    required String businessId,
    required JournalEntry entry,
    String? transactionId,
    String? journalCode,
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

  Future<Map<String, dynamic>?> fetchSettings({required String businessId});

  /// Sum of inventory value (supply_price × current_stock) for a branch.
  Future<int> fetchInventoryValue({required String branchId});
}
