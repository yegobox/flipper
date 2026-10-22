import 'package:flutter/foundation.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/ledger_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_ledger_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// The Postgres row id for a caller's deterministic entry key (for example
/// `je_bankrec_bal_1020_<ms>`). `journal_entries.id` is a UUID, so a key that
/// is not one maps to a stable UUIDv5 scoped to the business: the same key
/// always names the same row, and the primary key keeps it unique.
String journalEntryRowId({
  required String businessId,
  required String entryId,
}) => Uuid.isValidUUID(fromString: entryId)
    ? entryId
    : const Uuid().v5(
        Namespace.url.value,
        'flipper:journal-entry:$businessId:$entryId',
      );

class SupabaseAccountingLedgerRepository implements AccountingLedgerRepository {
  const SupabaseAccountingLedgerRepository(this._client);

  final SupabaseClient _client;

  static const _coaTable = 'chart_of_accounts';
  static const _entriesTable = 'journal_entries';
  static const _linesTable = 'journal_lines';

  /// Entry ids per `journal_lines` request (UUIDs keep this well under URL limits).
  static const _linesBatchSize = 150;
  static const _bankTable = 'bank_statement_lines';
  static const _settingsTable = 'accounting_settings';

  /// [LedgerRowMapper] emits Ditto + Postgres keys; PostgREST accepts snake_case only.
  static const _dittoOnlyKeys = {
    'businessId',
    'journalId',
    'transactionId',
    'entryNumber',
    'entryDate',
    'journalEntryId',
    'accountCode',
    'bankAccountCode',
    'lineDate',
    'matchedJournalEntryId',
    'matchedEntryNumber',
  };

  static Map<String, dynamic> _forPostgrest(Map<String, dynamic> row) {
    final out = Map<String, dynamic>.from(row);
    for (final key in _dittoOnlyKeys) {
      out.remove(key);
    }
    return out;
  }

  @override
  Future<void> ensureSeeded({required String businessId}) async {
    debugPrint(
      '[Accounting] Supabase seed_default_chart_of_accounts businessId=$businessId',
    );
    await _client.rpc(
      'seed_default_chart_of_accounts',
      params: {'p_business_id': businessId},
    );
    debugPrint('[Accounting] Supabase COA seed RPC completed');
  }

  @override
  Future<void> createChartOfAccount({
    required String businessId,
    required Account account,
  }) async {
    final existing = await _client
        .from(_coaTable)
        .select('id')
        .eq('business_id', businessId)
        .eq('code', account.code)
        .maybeSingle();
    if (existing != null) {
      throw StateError('Account code ${account.code} already exists');
    }

    final row = _forPostgrest(
      LedgerRowMapper.accountToRow(account, businessId: businessId),
    );
    await _client.from(_coaTable).insert(row);
  }

  @override
  Stream<List<Account>> watchChartOfAccounts({required String businessId}) {
    return _client
        .from(_coaTable)
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
        .map(
          (rows) =>
              rows
                  .where((r) => r['is_active'] != false)
                  .map(
                    (r) => LedgerRowMapper.accountFromRow(
                      r,
                      balance: _int(r['opening_balance']),
                    ),
                  )
                  .toList()
                ..sort((a, b) => a.code.compareTo(b.code)),
        );
  }

  @override
  Stream<List<JournalEntry>> watchJournalEntries({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _client
        .from(_entriesTable)
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
        .asyncMap((rows) async {
          final filtered =
              rows.where((r) {
                  final dt = _parseDate(r['entry_date']);
                  if (dt == null) return true;
                  if (startDate != null && dt.isBefore(startDate)) return false;
                  if (endDate != null && dt.isAfter(_endOfDay(endDate)))
                    return false;
                  return true;
                }).toList()
                // Newest first; sort on raw entry_date (the mapped display date
                // "Jul 7" is not chronologically sortable).
                ..sort((a, b) {
                  final da = _parseDate(a['entry_date']) ?? DateTime(1900);
                  final db = _parseDate(b['entry_date']) ?? DateTime(1900);
                  return db.compareTo(da);
                });

          if (filtered.isEmpty) return <JournalEntry>[];

          final ids = filtered.map((r) => r['id'].toString()).toList();
          // Batched: a range with no start date (opening balances) can hold
          // every entry the business has, and one `in.(...)` with thousands
          // of ids would overflow the request URL.
          final linesRows = <Map<String, dynamic>>[];
          for (var i = 0; i < ids.length; i += _linesBatchSize) {
            final end = i + _linesBatchSize < ids.length
                ? i + _linesBatchSize
                : ids.length;
            linesRows.addAll(
              await _client
                  .from(_linesTable)
                  .select()
                  .inFilter('journal_entry_id', ids.sublist(i, end)),
            );
          }

          final linesByEntry = <String, List<JournalLine>>{};
          for (final row in linesRows) {
            final eid = row['journal_entry_id'].toString();
            linesByEntry
                .putIfAbsent(eid, () => [])
                .add(LedgerRowMapper.lineFromRow(row));
          }

          return filtered
              .map(
                (r) => LedgerRowMapper.entryFromRow(
                  r,
                  linesByEntry[r['id'].toString()] ?? const [],
                ),
              )
              .toList();
        });
  }

  @override
  Future<String?> findEntryIdByTransactionId({
    required String businessId,
    required String transactionId,
  }) async {
    final rows = await _client
        .from(_entriesTable)
        .select('id')
        .eq('business_id', businessId)
        .eq('transaction_id', transactionId)
        .maybeSingle();
    return rows?['id']?.toString();
  }

  @override
  Future<bool> entryExists({
    required String businessId,
    required String entryId,
  }) async {
    try {
      final row = await _client
          .from(_entriesTable)
          .select('id')
          .eq('business_id', businessId)
          .eq('id', entryId)
          .maybeSingle();
      return row != null;
    } catch (_) {
      // Deterministic ids are not valid Postgres UUIDs; callers fall back to
      // findEntryIdByTransactionId for dedupe on this backend.
      return false;
    }
  }

  @override
  Future<String> createJournalEntry({
    required String businessId,
    required JournalEntry entry,
    String? transactionId,
    String? journalCode,
    // A deterministic key from the caller; see [journalEntryRowId].
    String? entryId,
  }) async {
    String? journalId;
    if (journalCode != null) {
      final j = await _client
          .from('accounting_journals')
          .select('id')
          .eq('business_id', businessId)
          .eq('code', journalCode)
          .maybeSingle();
      journalId = j?['id']?.toString();
    }

    if (entryId != null) {
      return _createKeyedJournalEntry(
        businessId: businessId,
        entry: entry,
        rowId: journalEntryRowId(businessId: businessId, entryId: entryId),
        transactionId: transactionId,
        journalId: journalId,
      );
    }

    final header = _forPostgrest(
      LedgerRowMapper.entryToRow(
        businessId: businessId,
        entry: entry,
        transactionId: transactionId,
        journalId: journalId,
      ),
    );

    final inserted = await _client
        .from(_entriesTable)
        .insert(header)
        .select('id')
        .single();
    final id = inserted['id'].toString();

    final lineRows = entry.lines
        .map(
          (l) => _forPostgrest(
            LedgerRowMapper.lineToRow(journalEntryId: id, line: l),
          ),
        )
        .toList();

    if (lineRows.isNotEmpty) {
      await _client.from(_linesTable).insert(lineRows);
    }

    return id;
  }

  /// Keyed create, safe to retry and to overlap without a server transaction:
  ///
  /// 1. An entry already posted under [rowId] is returned untouched.
  /// 2. The header is written unposted, so a failure before step 4 leaves an
  ///    entry that no balance counts, never a posted entry missing lines.
  /// 3. Lines carry ids derived from [rowId] and their index: they are
  ///    upserted, then only this entry's lines outside that set are removed.
  ///    Two attempts write the same rows, so lines never duplicate.
  /// 4. Only then is the requested status set; `posted` is the last write, and
  ///    the database's balance trigger checks the lines at that moment.
  Future<String> _createKeyedJournalEntry({
    required String businessId,
    required JournalEntry entry,
    required String rowId,
    String? transactionId,
    String? journalId,
  }) async {
    final existing = await _client
        .from(_entriesTable)
        .select('id, status')
        .eq('business_id', businessId)
        .eq('id', rowId)
        .maybeSingle();
    if (existing?['status'] == 'posted') return rowId;

    final status = LedgerRowMapper.statusToDb(entry.status);
    final header = _forPostgrest(
      LedgerRowMapper.entryToRow(
        businessId: businessId,
        entry: entry,
        id: rowId,
        transactionId: transactionId,
        journalId: journalId,
      ),
    );
    if (status == 'posted') {
      header['status'] = LedgerRowMapper.statusToDb(JournalStatus.draft);
    }
    await _client.from(_entriesTable).upsert(header);

    final lineIds = [
      for (var i = 0; i < entry.lines.length; i++)
        const Uuid().v5(Namespace.url.value, 'flipper:journal-line:$rowId:$i'),
    ];
    if (lineIds.isNotEmpty) {
      await _client.from(_linesTable).upsert([
        for (var i = 0; i < entry.lines.length; i++)
          _forPostgrest(
            LedgerRowMapper.lineToRow(
              journalEntryId: rowId,
              line: entry.lines[i],
              id: lineIds[i],
            ),
          ),
      ]);
    }
    var stale = _client
        .from(_linesTable)
        .delete()
        .eq('journal_entry_id', rowId);
    if (lineIds.isNotEmpty) stale = stale.not('id', 'in', lineIds);
    await stale;

    if (status == 'posted') {
      await _client
          .from(_entriesTable)
          .update({'status': status})
          .eq('id', rowId)
          .eq('business_id', businessId);
    }
    return rowId;
  }

  @override
  Future<void> updateJournalEntry({
    required String businessId,
    required String entryId,
    required JournalEntry entry,
  }) async {
    final header = _forPostgrest(
      LedgerRowMapper.entryToRow(
        businessId: businessId,
        entry: entry,
        id: entryId,
      ),
    );

    await _client
        .from(_entriesTable)
        .update(header)
        .eq('id', entryId)
        .eq('business_id', businessId);

    await _client.from(_linesTable).delete().eq('journal_entry_id', entryId);

    final lineRows = entry.lines
        .map(
          (l) => _forPostgrest(
            LedgerRowMapper.lineToRow(journalEntryId: entryId, line: l),
          ),
        )
        .toList();

    if (lineRows.isNotEmpty) {
      await _client.from(_linesTable).insert(lineRows);
    }
  }

  @override
  Future<bool> postJournalEntry({
    required String businessId,
    required String entryId,
    bool onlyIfPending = false,
  }) async {
    var query = _client
        .from(_entriesTable)
        .update({'status': 'posted'})
        .eq('id', entryId)
        .eq('business_id', businessId);
    if (onlyIfPending) {
      query = query.eq('status', 'pending');
    }
    final rows = await query.select('id');
    return rows.isNotEmpty;
  }

  @override
  Stream<List<BankLine>> watchBankLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) {
    return _client
        .from(_bankTable)
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
        .map(
          (rows) => rows
              .where(
                (r) =>
                    (r['bank_account_code'] ?? '1020').toString() ==
                    bankAccountCode,
              )
              .map(LedgerRowMapper.bankLineFromRow)
              .toList(),
        );
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
    final row = _forPostgrest(
      LedgerRowMapper.bankLineToRow(
        businessId: businessId,
        line: line,
        bankAccountCode: bankAccountCode,
        id: id,
        matchedJournalEntryId: matchedJournalEntryId,
        matchedEntryNumber: matchedEntryNumber,
      ),
    );

    if (id != null) {
      await _client.from(_bankTable).upsert(row);
    } else {
      await _client.from(_bankTable).insert(row);
    }
  }

  @override
  Future<void> clearBankStatementLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) async {
    await _client
        .from(_bankTable)
        .delete()
        .eq('business_id', businessId)
        .eq('bank_account_code', bankAccountCode);
  }

  @override
  Future<Map<String, dynamic>?> fetchSettings({
    required String businessId,
  }) async {
    return _client
        .from(_settingsTable)
        .select()
        .eq('business_id', businessId)
        .maybeSingle();
  }

  @override
  Future<int> fetchInventoryValue({required String branchId}) async {
    try {
      final stocks = await _client
          .from('stocks')
          .select('current_stock, variant_id')
          .eq('branch_id', int.parse(branchId));

      var total = 0;
      for (final s in stocks) {
        final variantId = s['variant_id'];
        if (variantId == null) continue;
        final variant = await _client
            .from('variants')
            .select('supply_price')
            .eq('id', variantId)
            .maybeSingle();
        final price = _int(variant?['supply_price']);
        final qty = _int(s['current_stock']);
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

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
}
