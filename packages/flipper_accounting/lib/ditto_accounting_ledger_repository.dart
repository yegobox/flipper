import 'package:flutter/foundation.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/ledger_row_mapper.dart';
import 'package:flipper_accounting/accounting_ledger_repository.dart';
import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:intl/intl.dart';

class DittoAccountingLedgerRepository implements AccountingLedgerRepository {
  DittoAccountingLedgerRepository(this._ditto);

  final AccountingDittoStore _ditto;

  @override
  Future<void> ensureSeeded({required String businessId}) async {
    if (!_ditto.isReady()) {
      debugPrint('[Accounting] Ditto COA seed skipped — not ready');
      return;
    }
    if (!_ditto.isCloudReady()) {
      debugPrint(
        '[Accounting] Ditto COA seed proceeding locally — cloud sync not ready',
      );
    }
    final existing = await _ditto.queryCollection(
      'chart_of_accounts',
      'SELECT _id FROM chart_of_accounts WHERE businessId = :businessId LIMIT 1',
      {'businessId': businessId},
    );
    if (existing.isNotEmpty) {
      debugPrint(
        '[Accounting] Ditto COA seed skipped — chart already present '
        'businessId=$businessId',
      );
      return;
    }
    debugPrint(
      '[Accounting] Ditto COA seed upserting ${defaultChartOfAccountsSeed.length} '
      'accounts businessId=$businessId',
    );
    for (final account in defaultChartOfAccountsSeed) {
      await _ditto.upsertChartOfAccount(businessId, account);
    }
    final visible = await _pollChartOfAccounts(businessId);
    debugPrint(
      '[Accounting] Ditto COA seed completed '
      '(${visible.length} rows visible via DQL)',
    );
    if (visible.isEmpty) {
      debugPrint(
        '[Accounting] WARNING: COA seed DQL still empty after upserts — '
        'data may appear after replication (common on dart2wasm)',
      );
    }
  }

  Future<List<Map<String, dynamic>>> _pollChartOfAccounts(
    String businessId, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final rows = await _ditto.queryCollection(
        'chart_of_accounts',
        'SELECT _id FROM chart_of_accounts WHERE businessId = :businessId',
        {'businessId': businessId},
      );
      if (rows.isNotEmpty) return rows;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return _ditto.queryCollection(
      'chart_of_accounts',
      'SELECT _id FROM chart_of_accounts WHERE businessId = :businessId',
      {'businessId': businessId},
    );
  }

  @override
  Future<void> createChartOfAccount({
    required String businessId,
    required Account account,
  }) async {
    final existing = await _ditto.queryCollection(
      'chart_of_accounts',
      'SELECT _id FROM chart_of_accounts WHERE businessId = :businessId AND code = :code',
      {'businessId': businessId, 'code': account.code},
    );
    if (existing.isNotEmpty) {
      throw StateError('Account code ${account.code} already exists');
    }
    await _ditto.upsertChartOfAccount(businessId, account);
  }

  @override
  Stream<List<Account>> watchChartOfAccounts({required String businessId}) {
    return _ditto
        .watchCollection(
          'chart_of_accounts',
          'SELECT * FROM chart_of_accounts '
          'WHERE businessId = :businessId OR business_id = :businessId',
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
    // Date filter in Dart — Ditto rows may use entryDate ISO or entry_date strings.
    const entriesQuery =
        'SELECT * FROM journal_entries '
        'WHERE businessId = :businessId OR business_id = :businessId';
    final args = <String, dynamic>{'businessId': businessId};

    return _ditto.watchCollection('journal_entries', entriesQuery, args).asyncMap((entries) async {
      final headerById = <String, Map<String, dynamic>>{};
      for (final row in entries) {
        final entryId = (row['id'] ?? row['_id']).toString();
        if (entryId.isNotEmpty) headerById[entryId] = row;
      }

      // Lines replicate globally; headers are business-scoped. Join lines to
      // headers by entry id and heal missing headers (orphan lines after sync).
      final businessLines = await _ditto.queryCollection(
        'journal_lines',
        'SELECT * FROM journal_lines '
        'WHERE businessId = :businessId OR business_id = :businessId',
        args,
      );
      final linesByEntry = <String, List<Map<String, dynamic>>>{};
      for (final line in businessLines) {
        final entryId =
            (line['journalEntryId'] ?? line['journal_entry_id'] ?? '').toString();
        if (entryId.isEmpty) continue;
        linesByEntry.putIfAbsent(entryId, () => []).add(line);
      }

      for (final entryId in linesByEntry.keys) {
        if (headerById.containsKey(entryId)) continue;
        final hdr = await _ditto.queryCollection(
          'journal_entries',
          'SELECT * FROM journal_entries WHERE _id = :id OR id = :id',
          {'id': entryId},
        );
        if (hdr.isNotEmpty) {
          headerById[entryId] = hdr.first;
          continue;
        }
        headerById[entryId] = _syntheticHeaderFromEntryId(entryId, businessId);
      }

      final inRangeHeaders = headerById.values.where((row) {
        return _entryInDateRange(row, startDate: startDate, endDate: endDate);
      }).toList();
      if (inRangeHeaders.isEmpty) return <JournalEntry>[];

      final result = <JournalEntry>[];
      for (final row in inRangeHeaders) {
        final entryId = (row['id'] ?? row['_id']).toString();
        var lines = linesByEntry[entryId] ?? [];
        if (lines.isEmpty) {
          lines = await _ditto.queryCollection(
            'journal_lines',
            'SELECT * FROM journal_lines WHERE journalEntryId = :entryId',
            {'entryId': entryId},
          );
          if (lines.isEmpty) {
            lines = await _ditto.queryCollection(
              'journal_lines',
              'SELECT * FROM journal_lines WHERE journal_entry_id = :entryId',
              {'entryId': entryId},
            );
          }
        }
        result.add(LedgerRowMapper.entryFromRow(
          row,
          lines.map(LedgerRowMapper.lineFromRow).toList(),
        ));
      }
      result.sort((a, b) => b.date.compareTo(a.date));
      return result;
    });
  }

  /// Minimal header when lines replicated but `journal_entries` header is absent
  /// (common when the connector posted lines before GL sync subscriptions existed).
  static Map<String, dynamic> _syntheticHeaderFromEntryId(
    String entryId,
    String businessId,
  ) {
    final parsed = _parseDeterministicEntryId(entryId);
    final txnId = parsed?.$2 ?? '';
    final ref8 = txnId.length >= 8 ? txnId.substring(0, 8).toUpperCase() : txnId;
    final suffix = parsed?.$3 ?? 'sale';
    final humanId = suffix == 'sale' ? 'JE-$ref8' : 'JE-$ref8-P';
    final memo = suffix == 'sale'
        ? 'Sale · $ref8'
        : suffix.startsWith('pay')
            ? 'Loan payment · $ref8'
            : 'Journal · $ref8';
    return {
      'id': entryId,
      '_id': entryId,
      'businessId': businessId,
      'business_id': businessId,
      'entryNumber': humanId,
      'entry_number': humanId,
      'reference': ref8,
      'memo': memo,
      'status': 'posted',
      'source': 'POS',
      if (txnId.isNotEmpty) 'transactionId': txnId,
      if (txnId.isNotEmpty) 'transaction_id': txnId,
    };
  }

  /// `je_<businessUuid>_<txnUuid>_sale` or `je_<biz>_<txn>_pay_<key>`.
  static (String, String, String)? _parseDeterministicEntryId(String entryId) {
    if (!entryId.startsWith('je_')) return null;
    final rest = entryId.substring(3);
    final payIdx = rest.indexOf('_pay_');
    if (payIdx != -1) {
      final before = rest.substring(0, payIdx);
      final key = rest.substring(payIdx + 5);
      final bizTxn = before.split('_');
      if (bizTxn.length < 2) return null;
      final txnId = bizTxn.last;
      final bizId = bizTxn.sublist(0, bizTxn.length - 1).join('_');
      return (bizId, txnId, 'pay_$key');
    }
    if (rest.endsWith('_sale')) {
      final base = rest.substring(0, rest.length - 5);
      final bizTxn = base.split('_');
      if (bizTxn.length < 2) return null;
      final txnId = bizTxn.last;
      final bizId = bizTxn.sublist(0, bizTxn.length - 1).join('_');
      return (bizId, txnId, 'sale');
    }
    return null;
  }

  static bool _entryInDateRange(
    Map<String, dynamic> row, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (startDate == null && endDate == null) return true;
    final parsed = _parseEntryRowDate(row['entry_date'] ?? row['entryDate']);
    if (parsed == null) return true;
    final day = _entryCalendarDay(parsed, startDate: startDate, endDate: endDate);
    if (startDate != null) {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      if (day.isBefore(start)) return false;
    }
    if (endDate != null) {
      final end = DateTime(endDate.year, endDate.month, endDate.day);
      if (day.isAfter(end)) return false;
    }
    return true;
  }

  /// Ditto mis-stores data-connector `YYYY-MM-DDT00:00:00Z` as year 1970; remap
  /// month/day into the active accounting period so POS sales aren't filtered out.
  static DateTime _entryCalendarDay(
    DateTime parsed, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (parsed.year >= 2000) {
      return DateTime(parsed.year, parsed.month, parsed.day);
    }
    final anchorYear = endDate?.year ?? startDate?.year ?? DateTime.now().year;
    return DateTime(anchorYear, parsed.month, parsed.day);
  }

  static DateTime? _parseEntryRowDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    final text = raw.toString().trim();
    if (text.isEmpty) return null;
    final iso = DateTime.tryParse(text);
    if (iso != null) return iso;
    for (final pattern in ['d MMM y', 'MMM d y', 'MMM d', 'd MMM']) {
      try {
        return DateFormat(pattern).parse(text);
      } catch (_) {
        continue;
      }
    }
    return null;
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
  Future<bool> entryExists({
    required String businessId,
    required String entryId,
  }) async {
    final rows = await _ditto.queryCollection(
      'journal_entries',
      'SELECT * FROM journal_entries WHERE _id = :entryId',
      {'entryId': entryId},
    );
    return rows.isNotEmpty;
  }

  @override
  Future<String> createJournalEntry({
    required String businessId,
    required JournalEntry entry,
    String? transactionId,
    String? journalCode,
    String? entryId,
  }) async {
    // Line doc ids are `<entryId>_<accountCode>` (accounting_mixin), so an
    // entry cannot carry two lines on the same account code.
    entryId ??=
        'je_${businessId}_${entry.id}_${DateTime.now().microsecondsSinceEpoch}';
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
  Future<bool> postJournalEntry({
    required String businessId,
    required String entryId,
    bool onlyIfPending = false,
  }) async {
    if (onlyIfPending) {
      return _ditto.executeUpdateWhere(
        'journal_entries',
        entryId,
        {'status': 'posted'},
        extraWhere: 'status = :expectedStatus',
        extraArgs: {'expectedStatus': 'pending'},
      );
    }
    await _ditto.executeUpdate('journal_entries', entryId, {'status': 'posted'});
    return true;
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
  Future<void> clearBankStatementLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) async {
    final rows = await _ditto.queryCollection(
      'bank_statement_lines',
      'SELECT _id FROM bank_statement_lines WHERE businessId = :businessId AND bankAccountCode = :code',
      {'businessId': businessId, 'code': bankAccountCode},
    );
    for (final row in rows) {
      final id = (row['_id'] ?? row['id'])?.toString();
      if (id != null && id.isNotEmpty) {
        await _ditto.deletePartyDoc('bank_statement_lines', id);
      }
    }
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
