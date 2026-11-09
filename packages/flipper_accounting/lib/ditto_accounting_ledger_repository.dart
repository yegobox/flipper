import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/ledger_row_mapper.dart';
import 'package:flipper_accounting/accounting_ledger_repository.dart';
import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/journal_entry_id.dart';
import 'package:flipper_accounting/liquid_accounts.dart';
import 'package:flipper_models/perf/perf_track.dart';
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
    // A provider account (the connector adds one when that bank's first SMS
    // lands) does not count: a chart holding only "Bank · BK" still needs
    // the seed.
    final existing = await _ditto.queryCollection(
      'chart_of_accounts',
      'SELECT _id FROM chart_of_accounts WHERE businessId = :businessId '
          'AND NOT (code IN :providerCodes) LIMIT 1',
      {
        'businessId': businessId,
        'providerCodes': [for (final a in providerAccounts) a.code],
      },
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
        .map(
          (rows) =>
              dedupeChartOfAccountRows(
                    rows.where(
                      (r) => r['isActive'] != false && r['is_active'] != false,
                    ),
                  )
                  .map(
                    (r) => LedgerRowMapper.accountFromRow(
                      r,
                      balance: _int(
                        r['openingBalance'] ?? r['opening_balance'],
                      ),
                    ),
                  )
                  .toList()
                ..sort((a, b) => a.code.compareTo(b.code)),
        );
  }

  /// One row per account code.
  ///
  /// The client used to seed `<biz>_<code>` while the data-connector seeds
  /// `coa_<biz>_<code>`, so many businesses hold two documents per account.
  /// Balances are keyed by code, so every copy showed the full balance and
  /// every report that sums the chart counted it twice. Keeps the `coa_`
  /// document and carries over an opening balance only the other copy has.
  @visibleForTesting
  static List<Map<String, dynamic>> dedupeChartOfAccountRows(
    Iterable<Map<String, dynamic>> rows,
  ) {
    final byCode = <String, Map<String, dynamic>>{};
    for (final row in rows) {
      final code = (row['code'] ?? '').toString();
      final kept = byCode[code];
      if (kept == null) {
        byCode[code] = row;
        continue;
      }
      final rowWins = _isCanonicalCoaRow(row) && !_isCanonicalCoaRow(kept);
      final winner = rowWins ? row : kept;
      final loser = rowWins ? kept : row;
      final winnerOpening = _int(
        winner['openingBalance'] ?? winner['opening_balance'],
      );
      final loserOpening = _int(
        loser['openingBalance'] ?? loser['opening_balance'],
      );
      byCode[code] = winnerOpening == 0 && loserOpening != 0
          ? {...winner, 'openingBalance': loserOpening}
          : winner;
    }
    return byCode.values.toList();
  }

  static bool _isCanonicalCoaRow(Map<String, dynamic> row) =>
      (row['_id'] ?? row['id'] ?? '').toString().startsWith('coa_');

  /// One ledger source per business, shared by every [watchJournalEntries]
  /// caller: the period and the through-period-end streams read the same
  /// rows once and differ only in the date filter applied to them.
  final Map<String, _JournalLedgerSource> _ledgerSources = {};

  /// Live ledger sources, one per watched business.
  @visibleForTesting
  int get ledgerSourceCount => _ledgerSources.length;

  /// How long a failed ledger change feed waits before it is registered
  /// again.
  @visibleForTesting
  static Duration changeFeedRetry = const Duration(seconds: 5);

  /// How long a failed ledger read waits before it is tried again.
  @visibleForTesting
  static Duration readRetry = const Duration(seconds: 5);

  @override
  Stream<List<JournalEntry>> watchJournalEntries({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _JournalLedgerSource? source;
    StreamSubscription<_JournalLedgerSnapshot>? sub;
    late final StreamController<List<JournalEntry>> out;
    out = StreamController<List<JournalEntry>>(
      onListen: () {
        final s = source = _ledgerSources.putIfAbsent(
          businessId,
          () => _JournalLedgerSource(_ditto, businessId),
        );
        s.listeners++;
        List<JournalEntry> pick(_JournalLedgerSnapshot snap) =>
            snap.entriesIn(startDate: startDate, endDate: endDate);
        sub = s.snapshots.listen(
          (snap) => out.add(pick(snap)),
          onError: out.addError,
        );
        final latest = s.latest;
        if (latest != null) out.add(pick(latest));
        s.start();
        // A listener that attaches after a failed read would otherwise wait
        // for the next change with neither data nor an error.
        s.retryIfFailed();
      },
      onCancel: () async {
        await sub?.cancel();
        final s = source;
        source = null;
        if (s != null && --s.listeners == 0) {
          if (identical(_ledgerSources[businessId], s)) {
            _ledgerSources.remove(businessId);
          }
          await s.dispose();
        }
      },
    );
    return out.stream;
  }

  /// Minimal header when lines replicated but `journal_entries` header is absent
  /// (common when the connector posted lines before GL sync subscriptions existed).
  static Map<String, dynamic> _syntheticHeaderFromEntryId(
    String entryId,
    String businessId,
  ) {
    final parsed = _parseDeterministicEntryId(entryId);
    final txnId = parsed?.$2 ?? '';
    final ref8 = txnId.length >= 8
        ? txnId.substring(0, 8).toUpperCase()
        : txnId;
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

  /// Whether an entry dated [parsed] falls in the range. Undated entries
  /// always do.
  static bool _dateInRange(
    DateTime? parsed, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (startDate == null && endDate == null) return true;
    if (parsed == null) return true;
    final day = _entryCalendarDay(
      parsed,
      startDate: startDate,
      endDate: endDate,
    );
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
    // entry cannot carry two lines on the same account code. entry.id is the
    // human reference ('Auto · JE-9536'), so it is slugified first: ids outside
    // [A-Za-z0-9_-] are rejected by data-connector when approving the entry.
    entryId ??= generateJournalEntryId(
      businessId: businessId,
      entryRef: entry.id,
      microsecondsSinceEpoch: DateTime.now().microsecondsSinceEpoch,
    );
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
      await _ditto.executeUpdate('journal_lines', id, {
        'debit': 0,
        'credit': 0,
      });
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
    await _ditto.executeUpdate('journal_entries', entryId, {
      'status': 'posted',
    });
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
  Future<Map<String, dynamic>?> fetchSettings({
    required String businessId,
  }) async {
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
        final price = _int(
          variants.first['supplyPrice'] ?? variants.first['supply_price'],
        );
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

/// A business's journal (headers joined to lines), refreshed at most once per
/// burst of changes and shared by every caller watching that business.
///
/// Before this, every caller ran its own observer. Each observer change
/// decoded every header, re-read every line and ran one more query per orphan
/// line group and per header with no lines; `asyncMap` then queued one such
/// rebuild per change. On a busy till that froze Books.
class _JournalLedgerSource {
  _JournalLedgerSource(this._ditto, this.businessId);

  /// How long changes are gathered before one refresh reads them all.
  static const coalesce = Duration(milliseconds: 250);

  /// Ids per `IN :ids` query.
  static const idsPerQuery = 1000;

  static const _entriesQuery =
      'SELECT * FROM journal_entries '
      'WHERE businessId = :businessId OR business_id = :businessId';
  static const _linesQuery =
      'SELECT * FROM journal_lines '
      'WHERE businessId = :businessId OR business_id = :businessId';

  final AccountingDittoStore _ditto;
  final String businessId;

  /// Callers currently listening; maintained by the repository.
  int listeners = 0;

  _JournalLedgerSnapshot? latest;

  final _out = StreamController<_JournalLedgerSnapshot>.broadcast();
  final _changes = <StreamSubscription<void>>[];
  final _feedRetries = <Timer>[];
  Timer? _timer;
  Timer? _readRetry;
  var _started = false;
  var _disposed = false;
  var _loading = false;
  var _dirty = false;
  var _failed = false;

  Stream<_JournalLedgerSnapshot> get snapshots => _out.stream;

  void start() {
    if (_started) return;
    _started = true;
    // Lines can land after their header: watch both, so an entry's lines
    // show up without waiting for the next header change.
    _watch('journal_entries', _entriesQuery);
    _watch('journal_lines', _linesQuery);
    unawaited(_refresh());
  }

  /// Reads again if the last read failed.
  void retryIfFailed() {
    if (_failed) _schedule();
  }

  void _watch(String collection, String query) {
    StreamSubscription<void>? sub;
    sub = _ditto
        .watchChanges(collection, query, {'businessId': businessId})
        .listen(
          (_) => _schedule(),
          onError: (Object e, StackTrace st) {
            debugPrint('[Accounting] ledger change feed error: $e');
            if (_disposed) return;
            // The feed may be dead (a failed observer registration sends
            // nothing more): tell the listeners, then register it again and
            // re-read what it may have missed. The other feed is untouched.
            _out.addError(e, st);
            _changes.remove(sub);
            unawaited(sub?.cancel());
            late final Timer retry;
            retry = Timer(DittoAccountingLedgerRepository.changeFeedRetry, () {
              _feedRetries.remove(retry);
              if (_disposed) return;
              _watch(collection, query);
              _schedule();
            });
            _feedRetries.add(retry);
          },
        );
    _changes.add(sub);
  }

  /// Gathers changes for [coalesce], then refreshes once. Never pushed back
  /// by later changes, so a steady stream of them cannot starve the ledger.
  void _schedule() {
    if (_disposed) return;
    if (_loading) {
      _dirty = true;
      return;
    }
    _timer ??= Timer(coalesce, () {
      _timer = null;
      unawaited(_refresh());
    });
  }

  Future<void> _refresh() async {
    if (_disposed || _loading) return;
    _loading = true;
    _dirty = false;
    try {
      final snap = await PerfTrack.track(
        'books.ledger_refresh',
        () => _load(_ditto, businessId),
      );
      if (_disposed) return;
      latest = snap;
      _failed = false;
      _out.add(snap);
    } catch (e, st) {
      _failed = true;
      if (!_disposed) {
        _out.addError(e, st);
        // Recovery alone fires no change: read again while anyone listens
        // (the source is disposed with its last listener).
        _readRetry?.cancel();
        _readRetry = Timer(DittoAccountingLedgerRepository.readRetry, () {
          _readRetry = null;
          retryIfFailed();
        });
      }
    } finally {
      _loading = false;
      if (_dirty) _schedule();
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    _readRetry?.cancel();
    _readRetry = null;
    for (final t in _feedRetries) {
      t.cancel();
    }
    _feedRetries.clear();
    for (final c in List.of(_changes)) {
      await c.cancel();
    }
    _changes.clear();
    await _out.close();
  }

  /// Reads the business's ledger with a fixed number of queries per refresh
  /// (plus one per [idsPerQuery] ids when healing).
  static Future<_JournalLedgerSnapshot> _load(
    AccountingDittoStore ditto,
    String businessId,
  ) async {
    final args = <String, dynamic>{'businessId': businessId};
    final entries = await ditto.queryCollection(
      'journal_entries',
      _entriesQuery,
      args,
    );
    final headerById = <String, Map<String, dynamic>>{};
    for (final row in entries) {
      final entryId = (row['id'] ?? row['_id']).toString();
      if (entryId.isNotEmpty) headerById[entryId] = row;
    }

    // Lines are joined to headers by entry id.
    final businessLines = await ditto.queryCollection(
      'journal_lines',
      _linesQuery,
      args,
    );
    final linesByEntry = <String, List<Map<String, dynamic>>>{};
    for (final line in businessLines) {
      final entryId = (line['journalEntryId'] ?? line['journal_entry_id'] ?? '')
          .toString();
      if (entryId.isEmpty) continue;
      linesByEntry.putIfAbsent(entryId, () => []).add(line);
    }

    // Orphan lines (header not under this business yet): find the header by
    // id, else make a minimal one from the deterministic entry id.
    final orphanIds = [
      for (final id in linesByEntry.keys)
        if (!headerById.containsKey(id)) id,
    ];
    if (orphanIds.isNotEmpty) {
      final found = <String, Map<String, dynamic>>{};
      for (final chunk in _chunks(orphanIds)) {
        final rows = await ditto.queryCollection(
          'journal_entries',
          'SELECT * FROM journal_entries WHERE _id IN :ids OR id IN :ids',
          {'ids': chunk},
        );
        for (final row in rows) {
          for (final key in [row['_id'], row['id']]) {
            if (key != null) found.putIfAbsent(key.toString(), () => row);
          }
        }
      }
      for (final id in orphanIds) {
        headerById[id] =
            found[id] ??
            DittoAccountingLedgerRepository._syntheticHeaderFromEntryId(
              id,
              businessId,
            );
      }
    }

    // Headers whose lines carry no business id: look the lines up by entry,
    // camelCase first, then snake_case for the ones still empty.
    final noLines = [
      for (final id in headerById.keys)
        if (linesByEntry[id]?.isNotEmpty != true) id,
    ];
    for (final field in ['journalEntryId', 'journal_entry_id']) {
      final still = [
        for (final id in noLines)
          if (linesByEntry[id]?.isNotEmpty != true) id,
      ];
      if (still.isEmpty) break;
      for (final chunk in _chunks(still)) {
        final rows = await ditto.queryCollection(
          'journal_lines',
          'SELECT * FROM journal_lines WHERE $field IN :ids',
          {'ids': chunk},
        );
        for (final line in rows) {
          final entryId = (line[field] ?? '').toString();
          if (entryId.isEmpty) continue;
          linesByEntry.putIfAbsent(entryId, () => []).add(line);
        }
      }
    }

    final rows = <_LedgerRow>[];
    for (final entry in headerById.entries) {
      final row = entry.value;
      rows.add(
        _LedgerRow(
          sortId: (row['id'] ?? row['_id'] ?? '').toString(),
          date: DittoAccountingLedgerRepository._parseEntryRowDate(
            row['entry_date'] ?? row['entryDate'],
          ),
          entry: LedgerRowMapper.entryFromRow(
            row,
            (linesByEntry[entry.key] ?? const [])
                .map(LedgerRowMapper.lineFromRow)
                .toList(),
          ),
        ),
      );
    }
    return _JournalLedgerSnapshot(rows);
  }

  static Iterable<List<String>> _chunks(List<String> ids) sync* {
    for (var i = 0; i < ids.length; i += idsPerQuery) {
      yield ids.sublist(
        i,
        i + idsPerQuery > ids.length ? ids.length : i + idsPerQuery,
      );
    }
  }
}

class _LedgerRow {
  const _LedgerRow({
    required this.sortId,
    required this.date,
    required this.entry,
  });

  /// Tie-break for entries on the same day.
  final String sortId;

  /// Parsed once per refresh; `null` when the row has no usable date.
  final DateTime? date;
  final JournalEntry entry;
}

class _JournalLedgerSnapshot {
  _JournalLedgerSnapshot(this.rows);

  final List<_LedgerRow> rows;

  /// Entries in the range, newest first; same-day entries by id.
  List<JournalEntry> entriesIn({DateTime? startDate, DateTime? endDate}) {
    final picked = <(DateTime, _LedgerRow)>[];
    for (final r in rows) {
      if (!DittoAccountingLedgerRepository._dateInRange(
        r.date,
        startDate: startDate,
        endDate: endDate,
      )) {
        continue;
      }
      final day = r.date == null
          ? DateTime(1900)
          : DittoAccountingLedgerRepository._entryCalendarDay(
              r.date!,
              startDate: startDate,
              endDate: endDate,
            );
      picked.add((day, r));
    }
    // Sort on the raw entry date, newest first. Sorting the display string
    // ("Jul 7") would order entries alphabetically by month name. List.sort
    // is not stable, so ties break on the entry id.
    picked.sort((a, b) {
      final byDate = b.$1.compareTo(a.$1);
      if (byDate != 0) return byDate;
      return a.$2.sortId.compareTo(b.$2.sortId);
    });
    return [for (final p in picked) p.$2.entry];
  }
}
