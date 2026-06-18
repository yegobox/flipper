import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';

/// In-memory [AccountingDittoStore] for unit tests; records audit upserts.
class FakeAccountingDittoStore implements AccountingDittoStore {
  FakeAccountingDittoStore({this.ready = true});

  final bool ready;

  /// docId -> row, in insertion order (re-upserts overwrite).
  final Map<String, Map<String, dynamic>> auditLogs = {};

  @override
  bool isReady() => ready;

  @override
  Future<void> upsertAccountingAuditLog(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async {
    auditLogs[docId] = {...data, 'businessId': businessId, '_id': docId};
  }

  @override
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) async =>
      [];

  @override
  Stream<List<Map<String, dynamic>>> watchCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) =>
      const Stream.empty();

  @override
  Future<void> upsertChartOfAccount(
    String businessId,
    Account account, {
    String? id,
    int openingBalance = 0,
  }) async {}

  @override
  Future<void> upsertJournalEntryHeader(
    String businessId,
    Map<String, dynamic> header,
    String docId,
  ) async {}

  @override
  Future<void> upsertJournalLine(
    String businessId,
    String journalEntryId,
    JournalLine line, {
    String? id,
  }) async {}

  @override
  Future<void> upsertBankStatementLine(
    String businessId,
    BankLine line, {
    String? id,
    String bankAccountCode = '1020',
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  }) async {}

  @override
  Future<void> deletePartyDoc(String collection, String docId) async {}

  @override
  Future<void> executeUpdate(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {}

  @override
  Future<void> upsertAccountingDocument(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async {}

  @override
  Future<void> upsertAccountingContact(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async {}

  @override
  Future<void> upsertPartyDoc(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {}
}
