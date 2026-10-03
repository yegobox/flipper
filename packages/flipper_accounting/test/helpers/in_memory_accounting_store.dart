import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/ledger_row_mapper.dart';

/// In-memory [AccountingDittoStore] that keeps every collection as a map of
/// documents. Queries support the `field = :arg` conditions (joined by AND)
/// the posters use; that is all these tests need.
class InMemoryAccountingStore implements AccountingDittoStore {
  InMemoryAccountingStore({bool seedChart = true}) {
    if (seedChart) {
      // A non-empty chart makes ensureSeeded() return without polling.
      collections['chart_of_accounts'] = {
        'seed': {'_id': 'seed', 'businessId': 'biz'},
      };
    }
  }

  final Map<String, Map<String, Map<String, dynamic>>> collections = {};

  Map<String, Map<String, dynamic>> _col(String name) =>
      collections.putIfAbsent(name, () => {});

  Map<String, dynamic>? doc(String collection, String id) =>
      collections[collection]?[id];

  List<Map<String, dynamic>> all(String collection) =>
      collections[collection]?.values.toList() ?? const [];

  /// Journal lines of [entryId] as (account, debit, credit).
  List<(String, int, int)> linesOf(String entryId) => [
    for (final l in all('journal_lines'))
      if (l['journalEntryId'] == entryId)
        (
          l['accountCode'] as String,
          (l['debit'] as num).round(),
          (l['credit'] as num).round(),
        ),
  ];

  /// Net credit balance of [account] across all journal lines.
  int creditBalance(String account) {
    var total = 0;
    for (final l in all('journal_lines')) {
      if (l['accountCode'] != account) continue;
      total += (l['credit'] as num).round() - (l['debit'] as num).round();
    }
    return total;
  }

  void _upsert(String collection, String id, Map<String, dynamic> data) {
    final col = _col(collection);
    col[id] = {...?col[id], ...data, '_id': id, 'id': id};
  }

  @override
  bool isReady() => true;

  @override
  bool isCloudReady() => true;

  @override
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) async {
    final conditions = RegExp(r'(\w+) = :(\w+)').allMatches(query);
    return _col(collection).values
        .where((row) {
          for (final c in conditions) {
            if (row[c.group(1)!] != args[c.group(2)!]) return false;
          }
          return true;
        })
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
  }

  @override
  Stream<List<Map<String, dynamic>>> watchCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) => Stream.fromFuture(queryCollection(collection, query, args));

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
  ) async => _upsert('journal_entries', docId, header);

  @override
  Future<void> upsertJournalLine(
    String businessId,
    String journalEntryId,
    JournalLine line, {
    String? id,
  }) async {
    final docId = id ?? '${journalEntryId}_${line.ac}';
    _upsert(
      'journal_lines',
      docId,
      LedgerRowMapper.lineToRow(
        journalEntryId: journalEntryId,
        line: line,
        id: docId,
      ),
    );
  }

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
  Future<void> deletePartyDoc(String collection, String docId) async =>
      _col(collection).remove(docId);

  @override
  Future<void> upsertAccountingAuditLog(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async => _upsert('accounting_audit_logs', docId, data);

  @override
  Future<void> executeUpdate(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    if (_col(collection).containsKey(docId)) _upsert(collection, docId, data);
  }

  @override
  Future<bool> executeUpdateWhere(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    required String extraWhere,
    Map<String, dynamic> extraArgs = const {},
  }) async {
    if (!_col(collection).containsKey(docId)) return false;
    _upsert(collection, docId, data);
    return true;
  }

  @override
  Future<void> upsertAccountingDocument(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async => _upsert('accounting_documents', docId, {
    ...data,
    'businessId': businessId,
  });

  @override
  Future<void> upsertAccountingContact(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async => _upsert('accounting_contacts', docId, data);

  @override
  Future<void> upsertPartyDoc(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async => _upsert(collection, docId, data);
}
