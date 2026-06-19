import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_ledger_repository.dart';
import 'package:intl/intl.dart';

/// Posts a balanced journal entry for a recurring schedule when "Run now"
/// fires. Mirrors [DocumentJournalPoster]: deterministic transaction ids make
/// a repeat run within the same period idempotent.
class RecurringJournalPoster {
  const RecurringJournalPoster(this._ledger);

  final AccountingLedgerRepository _ledger;

  /// Returns true when a new entry was posted, false when this schedule had
  /// already posted for [period] (deduped via the deterministic txn id).
  Future<bool> postSchedule({
    required String businessId,
    required RecurringSchedule schedule,
    required String period,
  }) async {
    if (schedule.debitCode.isEmpty || schedule.creditCode.isEmpty) {
      throw StateError('Recurring schedule ${schedule.id} is missing accounts');
    }

    await _ledger.ensureSeeded(businessId: businessId);

    final transactionId = 'recur_${schedule.id}_$period';
    final existing = await _ledger.findEntryIdByTransactionId(
      businessId: businessId,
      transactionId: transactionId,
    );
    if (existing != null) return false;

    final n = DateTime.now().microsecondsSinceEpoch % 10000;
    final entry = JournalEntry(
      id: 'JE-${1040 + n}',
      date: DateFormat('d MMM y').format(DateTime.now()),
      memo: '${schedule.name} — recurring',
      ref: schedule.id,
      status: JournalStatus.posted,
      src: 'Recurring',
      lines: [
        JournalLine(ac: schedule.debitCode, dr: schedule.amount),
        JournalLine(ac: schedule.creditCode, cr: schedule.amount),
      ],
    );

    final entryId = await _ledger.createJournalEntry(
      businessId: businessId,
      entry: entry,
      transactionId: transactionId,
      journalCode: 'misc',
    );
    await _ledger.postJournalEntry(businessId: businessId, entryId: entryId);
    return true;
  }
}

/// Period key for idempotency, derived from the schedule frequency.
/// Monthly/Weekly post once per calendar month; Quarterly once per quarter;
/// Yearly once per year.
String recurringPeriodKey(String freq, DateTime now) {
  final f = freq.toLowerCase();
  if (f.startsWith('quarter')) {
    final q = ((now.month - 1) ~/ 3) + 1;
    return '${now.year}-Q$q';
  }
  if (f.startsWith('year') || f.startsWith('annual')) {
    return '${now.year}';
  }
  // Monthly (and weekly, which we cap at one auto-post per month here).
  return DateFormat('yyyy-MM').format(now);
}

/// Advances a `d MMM y` next-run label by one interval for [freq].
/// Returns the original label unchanged when it cannot be parsed.
String advanceNextRun(String next, String freq) {
  DateTime parsed;
  try {
    parsed = DateFormat('d MMM y').parseLoose(next);
  } catch (_) {
    return next;
  }
  final f = freq.toLowerCase();
  DateTime advanced;
  if (f.startsWith('week')) {
    advanced = parsed.add(const Duration(days: 7));
  } else if (f.startsWith('quarter')) {
    advanced = DateTime(parsed.year, parsed.month + 3, parsed.day);
  } else if (f.startsWith('year') || f.startsWith('annual')) {
    advanced = DateTime(parsed.year + 1, parsed.month, parsed.day);
  } else {
    advanced = DateTime(parsed.year, parsed.month + 1, parsed.day);
  }
  return DateFormat('d MMM y').format(advanced);
}
