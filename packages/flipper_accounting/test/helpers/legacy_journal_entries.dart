// The ledger read as it was before the coalesced source (copied verbatim from
// DittoAccountingLedgerRepository.watchJournalEntries, one emission's worth).
// Tests compare the new implementation against it, so do not "fix" it.
import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/ledger_row_mapper.dart';
import 'package:intl/intl.dart';

Future<List<JournalEntry>> legacyJournalEntries(
  AccountingDittoStore store, {
  required String businessId,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  const entriesQuery =
      'SELECT * FROM journal_entries '
      'WHERE businessId = :businessId OR business_id = :businessId';
  final args = <String, dynamic>{'businessId': businessId};
  final entries = await store.queryCollection(
    'journal_entries',
    entriesQuery,
    args,
  );

  final headerById = <String, Map<String, dynamic>>{};
  for (final row in entries) {
    final entryId = (row['id'] ?? row['_id']).toString();
    if (entryId.isNotEmpty) headerById[entryId] = row;
  }

  // Lines replicate globally; headers are business-scoped. Join lines to
  // headers by entry id and heal missing headers (orphan lines after sync).
  final businessLines = await store.queryCollection(
    'journal_lines',
    'SELECT * FROM journal_lines '
        'WHERE businessId = :businessId OR business_id = :businessId',
    args,
  );
  final linesByEntry = <String, List<Map<String, dynamic>>>{};
  for (final line in businessLines) {
    final entryId = (line['journalEntryId'] ?? line['journal_entry_id'] ?? '')
        .toString();
    if (entryId.isEmpty) continue;
    linesByEntry.putIfAbsent(entryId, () => []).add(line);
  }

  for (final entryId in linesByEntry.keys) {
    if (headerById.containsKey(entryId)) continue;
    final hdr = await store.queryCollection(
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

  // Sort on the raw entry_date, newest first. Sorting the mapped display
  // string ("Jul 7") would order entries alphabetically by month name.
  inRangeHeaders.sort((a, b) {
    final da = _entrySortKey(a, startDate: startDate, endDate: endDate);
    final db = _entrySortKey(b, startDate: startDate, endDate: endDate);
    final byDate = db.compareTo(da);
    if (byDate != 0) return byDate;
    // List.sort is not stable, so same-day rows would reshuffle between
    // refreshes. Break ties on the entry id to keep a consistent order.
    final ida = (a['id'] ?? a['_id'] ?? '').toString();
    final idb = (b['id'] ?? b['_id'] ?? '').toString();
    return ida.compareTo(idb);
  });

  final result = <JournalEntry>[];
  for (final row in inRangeHeaders) {
    final entryId = (row['id'] ?? row['_id']).toString();
    var lines = linesByEntry[entryId] ?? [];
    if (lines.isEmpty) {
      lines = await store.queryCollection(
        'journal_lines',
        'SELECT * FROM journal_lines WHERE journalEntryId = :entryId',
        {'entryId': entryId},
      );
      if (lines.isEmpty) {
        lines = await store.queryCollection(
          'journal_lines',
          'SELECT * FROM journal_lines WHERE journal_entry_id = :entryId',
          {'entryId': entryId},
        );
      }
    }
    result.add(
      LedgerRowMapper.entryFromRow(
        row,
        lines.map(LedgerRowMapper.lineFromRow).toList(),
      ),
    );
  }
  return result;
}

/// Chronological sort key for a journal entry row; unparseable dates sort last.
DateTime _entrySortKey(
  Map<String, dynamic> row, {
  DateTime? startDate,
  DateTime? endDate,
}) {
  final parsed = _parseEntryRowDate(row['entry_date'] ?? row['entryDate']);
  if (parsed == null) return DateTime(1900);
  return _entryCalendarDay(parsed, startDate: startDate, endDate: endDate);
}

/// Minimal header when lines replicated but `journal_entries` header is absent
/// (common when the connector posted lines before GL sync subscriptions existed).
Map<String, dynamic> _syntheticHeaderFromEntryId(
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
(String, String, String)? _parseDeterministicEntryId(String entryId) {
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

bool _entryInDateRange(
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
DateTime _entryCalendarDay(
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

DateTime? _parseEntryRowDate(dynamic raw) {
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
