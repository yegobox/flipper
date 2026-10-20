import 'package:flutter/foundation.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

/// Applies posted journal lines to COA templates and returns accounts with balances.
///
/// [opening] is what each account carried into the period (see
/// [openingBalances]); it is added on top of the COA's own opening amount.
List<Account> accountsWithBalances(
  List<Account> coa,
  List<JournalEntry> entries, {
  Map<String, int> opening = const {},
}) {
  final normalByCode = {for (final a in coa) a.code: a};
  final balances = {
    for (final a in coa) a.code: a.bal + (opening[a.code] ?? 0),
  };

  for (final entry in entries.where((e) => e.status == JournalStatus.posted)) {
    for (final line in entry.lines) {
      final acct = normalByCode[line.ac];
      if (acct == null) {
        // A line referencing an account that is not in the chart of accounts
        // would silently drop one leg of the entry and unbalance the ledger.
        // Surface it loudly in debug rather than hiding the imbalance.
        assert(() {
          debugPrint(
            '[Accounting] WARNING: journal entry ${entry.id} references unknown '
            'account "${line.ac}"; this leg was dropped and the trial balance '
            'will not balance. Add the account to the chart of accounts.',
          );
          return true;
        }());
        continue;
      }
      final cur = balances[line.ac] ?? 0;
      balances[line.ac] = acct.isDebitNormal
          ? cur + line.dr - line.cr
          : cur + line.cr - line.dr;
    }
  }

  return [
    for (final a in coa)
      Account(
        code: a.code,
        name: a.name,
        type: a.type,
        sub: a.sub,
        normal: a.normal,
        bal: balances[a.code] ?? 0,
        contra: a.contra,
        note: a.note,
      ),
  ];
}

/// Retained Earnings: carries the profit made before the period.
const retainedEarningsCode = '3020';

/// Entries in [throughPeriodEnd] that are not in [period]: the ones dated
/// before the period starts.
///
/// Both lists come from the same repository with the same end date, so they
/// agree on every entry's date, and an entry whose date cannot be read (which
/// the repository lets through every range) is in both and so never counted
/// twice. Matching is by backend id; the human-readable number can repeat.
List<JournalEntry> entriesBeforePeriod({
  required List<JournalEntry> throughPeriodEnd,
  required List<JournalEntry> period,
}) {
  String key(JournalEntry e) => e.uuid ?? e.id;
  final inPeriod = {for (final e in period) key(e)};
  return [
    for (final e in throughPeriodEnd)
      if (!inPeriod.contains(key(e))) e,
  ];
}

/// Balances carried into a period from posted [priorEntries].
///
/// Asset, liability and equity accounts carry their own balance, so Cash on
/// Hand shows the money actually held, not just this period's movement.
/// Income and expense accounts start every period at zero; the profit they
/// made before it is carried in Retained Earnings, which keeps the trial
/// balance balanced.
Map<String, int> openingBalances(
  List<Account> coa,
  List<JournalEntry> priorEntries,
) {
  final byCode = {for (final a in coa) a.code: a};
  final opening = <String, int>{};
  var priorProfit = 0;

  for (final entry in priorEntries.where(
    (e) => e.status == JournalStatus.posted,
  )) {
    for (final line in entry.lines) {
      final acct = byCode[line.ac];
      // Unknown accounts are dropped here exactly as in [accountsWithBalances].
      if (acct == null) continue;
      switch (acct.type) {
        case AccountType.income:
        case AccountType.expense:
          priorProfit += line.cr - line.dr;
        case AccountType.asset:
        case AccountType.liability:
        case AccountType.equity:
          opening[acct.code] =
              (opening[acct.code] ?? 0) +
              (acct.isDebitNormal ? line.dr - line.cr : line.cr - line.dr);
      }
    }
  }

  if (priorProfit != 0) {
    if (byCode.containsKey(retainedEarningsCode)) {
      opening[retainedEarningsCode] =
          (opening[retainedEarningsCode] ?? 0) + priorProfit;
    } else {
      assert(() {
        debugPrint(
          '[Accounting] WARNING: no Retained Earnings account '
          '($retainedEarningsCode); profit before the period ($priorProfit) '
          'is not carried and the trial balance will not balance.',
        );
        return true;
      }());
    }
  }
  return opening;
}

/// Cash-flow buckets from posted journal lines on liquid accounts.
({int operating, int investing, int financing, int netChange})
cashFlowFromJournal(
  List<JournalEntry> entries, {
  Set<String> liquidCodes = const {'1010', '1020', '1030'},
  Set<String> fixedAssetCodes = const {'1500', '1510'},
  Set<String> financingCodes = const {'2200', '3010'},
}) {
  var operating = 0;
  var investing = 0;
  var financing = 0;

  for (final entry in entries.where((e) => e.status == JournalStatus.posted)) {
    for (final line in entry.lines) {
      final net = line.dr - line.cr;
      if (liquidCodes.contains(line.ac)) {
        operating += net;
      } else if (fixedAssetCodes.contains(line.ac)) {
        investing += net;
      } else if (financingCodes.contains(line.ac)) {
        financing += net;
      } else {
        operating += net;
      }
    }
  }

  return (
    operating: operating,
    investing: investing,
    financing: financing,
    netChange: operating + investing + financing,
  );
}
