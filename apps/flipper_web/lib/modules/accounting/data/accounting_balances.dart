import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

/// Applies posted journal lines to COA templates and returns accounts with balances.
List<Account> accountsWithBalances(
  List<Account> coa,
  List<JournalEntry> entries,
) {
  final normalByCode = {for (final a in coa) a.code: a};
  final balances = {
    for (final a in coa) a.code: a.bal,
  };

  for (final entry in entries.where((e) => e.status == JournalStatus.posted)) {
    for (final line in entry.lines) {
      final acct = normalByCode[line.ac];
      if (acct == null) continue;
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

/// Cash-flow buckets from posted journal lines on liquid accounts.
({int operating, int investing, int financing, int netChange}) cashFlowFromJournal(
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
