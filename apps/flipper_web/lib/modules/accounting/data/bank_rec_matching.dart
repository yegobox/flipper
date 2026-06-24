import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_statement_service.dart';

/// Liquid accounts POS sales/expenses can post to (see [accountingLiquidAccountCode]).
const bankLiquidAccountCodes = ['1020', '1030', '1010'];

/// Net movement an entry posts to [accountCode]: debits minus credits.
int bankMovement(JournalEntry entry, String accountCode) => entry.lines
    .where((l) => l.ac == accountCode)
    .fold<int>(0, (s, l) => s + l.dr - l.cr);

/// Journal search window for bank reconciliation: statement period ± buffer,
/// not the accounting UI month filter.
(DateTime start, DateTime end) bankRecJournalDateRange(ParsedStatement? meta) {
  final now = DateTime.now();
  if (meta?.periodStart != null && meta?.periodEnd != null) {
    var start = DateTime.tryParse(meta!.periodStart!);
    var end = DateTime.tryParse(meta.periodEnd!);
    if (start != null && end != null) {
      start = correctStatementYear(start, now);
      end = correctStatementYear(end, now);
      if (end.isBefore(start)) {
        end = DateTime(start.year, start.month, start.day)
            .add(const Duration(days: 45));
      }
      return (
        DateTime(start.year, start.month, start.day)
            .subtract(const Duration(days: 30)),
        DateTime(end.year, end.month, end.day).add(const Duration(days: 30)),
      );
    }
  }
  // No imported metadata: search the last twelve months.
  return (DateTime(now.year, now.month, now.day).subtract(const Duration(days: 365)), now);
}

/// Bank-statement parsers often misread the year (e.g. 2024 on a 2026 stmt).
/// Nudge implausible years forward to the current calendar year.
DateTime correctStatementYear(DateTime date, DateTime now) {
  if (date.year >= now.year - 1) return date;
  return DateTime(now.year, date.month, date.day);
}

class BankMatchCandidate {
  const BankMatchCandidate(this.entry, this.accountCode);

  final JournalEntry entry;

  /// GL account the matching movement was found on (1020 bank, 1030 MoMo, …).
  final String accountCode;
}

/// Posted journal entries whose bank-side movement equals [line.amt].
/// Prefers account [primaryAccountCode] (1020); falls back to other liquid
/// accounts when POS posted to cash/MoMo instead of bank.
List<BankMatchCandidate> findBankMatchCandidates({
  required Iterable<JournalEntry> journal,
  required BankLine line,
  String primaryAccountCode = '1020',
}) {
  final posted =
      journal.where((e) => e.status == JournalStatus.posted).toList();

  final primary = _matchesOnAccount(posted, line, primaryAccountCode);
  if (primary.isNotEmpty) {
    _sortByDateProximity(primary, line);
    return primary;
  }

  final fallback = <BankMatchCandidate>[];
  for (final code in bankLiquidAccountCodes) {
    if (code == primaryAccountCode) continue;
    fallback.addAll(_matchesOnAccount(posted, line, code));
  }
  _sortByDateProximity(fallback, line);
  return fallback;
}

List<BankMatchCandidate> _matchesOnAccount(
  List<JournalEntry> posted,
  BankLine line,
  String accountCode,
) {
  return [
    for (final entry in posted)
      if (bankMovement(entry, accountCode) == line.amt)
        BankMatchCandidate(entry, accountCode),
  ];
}

void _sortByDateProximity(List<BankMatchCandidate> candidates, BankLine line) {
  candidates.sort((a, b) {
    final ad = a.entry.date == line.date ? 0 : 1;
    final bd = b.entry.date == line.date ? 0 : 1;
    return ad.compareTo(bd);
  });
}

String bankRecJournalRangeLabel(DateTime start, DateTime end) {
  String fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  return '${fmt(start)} – ${fmt(end)}';
}

String liquidAccountLabel(String code) => switch (code) {
      '1020' => 'Bank',
      '1030' => 'Mobile Money',
      '1010' => 'Cash',
      _ => code,
    };
