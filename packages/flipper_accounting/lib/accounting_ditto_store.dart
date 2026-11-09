import 'package:flipper_accounting/accounting_models.dart';

/// Minimal Ditto-store contract the accounting ledger needs.
///
/// flipper_web's `DittoService` implements this (via its accounting mixin),
/// which lets the ledger repository live in this shared package without
/// depending on the web app. Signatures must stay in sync with
/// `AccountingMixin` / `DittoCore` in flipper_web.
abstract class AccountingDittoStore {
  bool isReady();

  /// Authenticated + syncing — writes replicate to Ditto Cloud.
  bool isCloudReady();

  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  );

  Stream<List<Map<String, dynamic>>> watchCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  );

  /// Fires whenever the result of [query] may have changed, without the rows.
  ///
  /// Use it when the listener re-reads anyway: no row is decoded on the
  /// calling isolate, so a burst of changes to a large collection costs the
  /// UI thread nothing until the listener decides to read.
  Stream<void> watchChanges(
    String collection,
    String query,
    Map<String, dynamic> args,
  );

  Future<void> upsertChartOfAccount(
    String businessId,
    Account account, {
    String? id,
    int openingBalance = 0,
  });

  Future<void> upsertJournalEntryHeader(
    String businessId,
    Map<String, dynamic> header,
    String docId,
  );

  Future<void> upsertJournalLine(
    String businessId,
    String journalEntryId,
    JournalLine line, {
    String? id,
  });

  Future<void> upsertBankStatementLine(
    String businessId,
    BankLine line, {
    String? id,
    String bankAccountCode = '1020',
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  });

  Future<void> deletePartyDoc(String collection, String docId);

  Future<void> upsertAccountingAuditLog(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  );

  Future<void> executeUpdate(
    String collection,
    String docId,
    Map<String, dynamic> data,
  );

  /// Like [executeUpdate] but only when [extraWhere] matches (without `WHERE`).
  /// Returns true when at least one document was updated.
  Future<bool> executeUpdateWhere(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    required String extraWhere,
    Map<String, dynamic> extraArgs = const {},
  });

  Future<void> upsertAccountingDocument(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  );

  Future<void> upsertAccountingContact(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  );

  Future<void> upsertPartyDoc(
    String collection,
    String docId,
    Map<String, dynamic> data,
  );
}
