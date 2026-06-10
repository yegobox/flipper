import 'package:flutter/foundation.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/mapper/ledger_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_ledger_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';

class DittoAccountingLedgerRepository implements AccountingLedgerRepository {
  DittoAccountingLedgerRepository(this._ditto);

  final DittoService _ditto;

  @override
  Future<void> ensureSeeded({required String businessId}) async {
    if (!_ditto.isReady()) {
      debugPrint('[Accounting] Ditto COA seed skipped — not ready');
      return;
    }
    debugPrint(
      '[Accounting] Ditto COA seed upserting ${defaultChartOfAccountsSeed.length} '
      'accounts businessId=$businessId',
    );
    for (final account in defaultChartOfAccountsSeed) {
      await _ditto.upsertChartOfAccount(businessId, account);
    }
    debugPrint('[Accounting] Ditto COA seed completed');
  }

  @override
  Stream<List<Account>> watchChartOfAccounts({required String businessId}) {
    return _ditto
        .watchCollection(
          'chart_of_accounts',
          'SELECT * FROM chart_of_accounts WHERE businessId = :businessId',
          {'businessId': businessId},
        )
        .map((rows) => rows
            .where((r) => r['isActive'] != false && r['is_active'] != false)
            .map((r) => LedgerRowMapper.accountFromRow(
                  r,
                  balance: _int(r['openingBalance'] ?? r['opening_balance']),
                ))
            .toList()
          ..sort((a, b) => a.code.compareTo(b.code)));
  }

  @override
  Stream<List<JournalEntry>> watchJournalEntries({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final args = <String, dynamic>{'businessId': businessId};
    var query = 'SELECT * FROM journal_entries WHERE businessId = :businessId';
    if (startDate != null) {
      query += ' AND entryDate >= :start';
      args['start'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      query += ' AND entryDate <= :end';
      args['end'] = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999)
          .toIso8601String();
    }
    query += ' ORDER BY entryDate DESC';

    return _ditto.watchCollection('journal_entries', query, args).asyncMap((entries) async {
      if (entries.isEmpty) return <JournalEntry>[];

      final result = <JournalEntry>[];
      for (final row in entries) {
        final entryId = (row['id'] ?? row['_id']).toString();
        final lines = await _ditto.queryCollection(
          'journal_lines',
          'SELECT * FROM journal_lines WHERE journalEntryId = :entryId',
          {'entryId': entryId},
        );
        result.add(LedgerRowMapper.entryFromRow(
          row,
          lines.map(LedgerRowMapper.lineFromRow).toList(),
        ));
      }
      return result;
    });
  }

  @override
  Future<String?> findEntryIdByTransactionId({
    required String businessId,
    required String transactionId,
  }) async {
    final rows = await _ditto.queryCollection(
      'journal_entries',
      'SELECT * FROM journal_entries WHERE businessId = :businessId AND transactionId = :txnId',
      {'businessId': businessId, 'txnId': transactionId},
    );
    if (rows.isEmpty) return null;
    return (rows.first['id'] ?? rows.first['_id']).toString();
  }

  @override
  Future<String> createJournalEntry({
    required String businessId,
    required JournalEntry entry,
    String? transactionId,
    String? journalCode,
  }) async {
    final entryId = 'je_${businessId}_${entry.id}_${DateTime.now().microsecondsSinceEpoch}';
    final header = LedgerRowMapper.entryToRow(
      businessId: businessId,
      entry: entry,
      id: entryId,
      transactionId: transactionId,
    );
    await _ditto.upsertJournalEntryHeader(businessId, header, entryId);

    for (final line in entry.lines) {
      await _ditto.upsertJournalLine(businessId, entryId, line);
    }
    return entryId;
  }

  @override
  Future<void> updateJournalEntry({
    required String businessId,
    required String entryId,
    required JournalEntry entry,
  }) async {
    final header = LedgerRowMapper.entryToRow(
      businessId: businessId,
      entry: entry,
      id: entryId,
    );
    await _ditto.upsertJournalEntryHeader(businessId, header, entryId);

    final existing = await _ditto.queryCollection(
      'journal_lines',
      'SELECT * FROM journal_lines WHERE journalEntryId = :entryId',
      {'entryId': entryId},
    );
    for (final row in existing) {
      final id = (row['id'] ?? row['_id']).toString();
      await _ditto.executeUpdate('journal_lines', id, {'debit': 0, 'credit': 0});
    }

    for (final line in entry.lines) {
      await _ditto.upsertJournalLine(businessId, entryId, line);
    }
  }

  @override
  Future<void> postJournalEntry({
    required String businessId,
    required String entryId,
  }) async {
    await _ditto.executeUpdate('journal_entries', entryId, {'status': 'posted'});
  }

  @override
  Stream<List<BankLine>> watchBankLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) {
    return _ditto
        .watchCollection(
          'bank_statement_lines',
          'SELECT * FROM bank_statement_lines WHERE businessId = :businessId AND bankAccountCode = :code',
          {'businessId': businessId, 'code': bankAccountCode},
        )
        .map((rows) => rows.map(LedgerRowMapper.bankLineFromRow).toList());
  }

  @override
  Future<void> upsertBankLine({
    required String businessId,
    required BankLine line,
    String bankAccountCode = '1020',
    String? id,
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  }) async {
    await _ditto.upsertBankStatementLine(
      businessId,
      line,
      id: id,
      bankAccountCode: bankAccountCode,
      matchedJournalEntryId: matchedJournalEntryId,
      matchedEntryNumber: matchedEntryNumber,
    );
  }

  @override
  Future<Map<String, dynamic>?> fetchSettings({required String businessId}) async {
    final rows = await _ditto.queryCollection(
      'accounting_settings',
      'SELECT * FROM accounting_settings WHERE businessId = :businessId',
      {'businessId': businessId},
    );
    return rows.isEmpty ? null : rows.first;
  }

  @override
  Future<int> fetchInventoryValue({required String branchId}) async {
    try {
      final stocks = await _ditto.queryCollection(
        'stocks',
        'SELECT * FROM stocks WHERE branchId = :branchId',
        {'branchId': branchId},
      );
      var total = 0;
      for (final s in stocks) {
        final variantId = s['variantId'] ?? s['variant_id'];
        if (variantId == null) continue;
        final variants = await _ditto.queryCollection(
          'variants',
          'SELECT * FROM variants WHERE id = :id',
          {'id': variantId.toString()},
        );
        if (variants.isEmpty) continue;
        final price = _int(variants.first['supplyPrice'] ?? variants.first['supply_price']);
        final qty = _int(s['currentStock'] ?? s['current_stock']);
        total += price * qty;
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  static int _int(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
