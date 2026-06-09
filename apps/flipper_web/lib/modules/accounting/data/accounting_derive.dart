import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:intl/intl.dart';

int drOf(Account a) => a.isDebitNormal ? a.bal : 0;

int crOf(Account a) => !a.isDebitNormal ? a.bal : 0;

String acctName(String code, Map<String, Account> map) {
  return map[code]?.name ?? code;
}

JeTotals jeTotals(JournalEntry e) {
  final dr = e.lines.fold<int>(0, (s, l) => s + l.dr);
  final cr = e.lines.fold<int>(0, (s, l) => s + l.cr);
  return JeTotals(dr: dr, cr: cr, balanced: dr == cr);
}

TrialBalanceResult trialBalance(List<Account> accounts) {
  final rows = accounts
      .map((a) => TrialBalanceRow(account: a, dr: drOf(a), cr: crOf(a)))
      .toList();
  final totDr = rows.fold<int>(0, (s, r) => s + r.dr);
  final totCr = rows.fold<int>(0, (s, r) => s + r.cr);
  return TrialBalanceResult(
    rows: rows,
    totDr: totDr,
    totCr: totCr,
    balanced: totDr == totCr,
  );
}

IncomeStatementResult incomeStatement(List<Account> accounts) {
  final income = accounts.where((a) => a.type == AccountType.income).toList();
  final grossRevenue =
      income.where((a) => !a.contra).fold<int>(0, (s, a) => s + a.bal);
  final discounts =
      income.where((a) => a.contra).fold<int>(0, (s, a) => s + a.bal);
  final netRevenue = grossRevenue - discounts;
  final cogs = accounts
      .where((a) => a.sub == 'Cost of sales')
      .fold<int>(0, (s, a) => s + a.bal);
  final grossProfit = netRevenue - cogs;
  final opex = accounts.where((a) => a.sub == 'Operating expenses').toList();
  final totalOpex = opex.fold<int>(0, (s, a) => s + a.bal);
  final netIncome = grossProfit - totalOpex;
  return IncomeStatementResult(
    income: income,
    discounts: discounts,
    grossRevenue: grossRevenue,
    netRevenue: netRevenue,
    cogs: cogs,
    grossProfit: grossProfit,
    opex: opex,
    totalOpex: totalOpex,
    netIncome: netIncome,
    grossMargin: netRevenue == 0 ? 0 : grossProfit / netRevenue,
    netMargin: netRevenue == 0 ? 0 : netIncome / netRevenue,
  );
}

int _assetVal(Account x) => x.contra ? -x.bal : x.bal;

BalanceSheetResult balanceSheet(List<Account> accounts) {
  List<Account> byAssetSub(String sub) => accounts
      .where((x) => x.type == AccountType.asset && x.sub == sub)
      .toList();

  final currentAssets = byAssetSub('Current assets');
  final fixedAssets = byAssetSub('Fixed assets');
  final totalCurrentAssets =
      currentAssets.fold<int>(0, (s, x) => s + _assetVal(x));
  final totalFixedAssets = fixedAssets.fold<int>(0, (s, x) => s + _assetVal(x));
  final totalAssets = totalCurrentAssets + totalFixedAssets;

  final curLiab =
      accounts.where((x) => x.sub == 'Current liabilities').toList();
  final ltLiab =
      accounts.where((x) => x.sub == 'Long-term liabilities').toList();
  final totalCurLiab = curLiab.fold<int>(0, (s, x) => s + x.bal);
  final totalLtLiab = ltLiab.fold<int>(0, (s, x) => s + x.bal);
  final totalLiab = totalCurLiab + totalLtLiab;

  final pl = incomeStatement(accounts);
  final acctMap = {for (final a in accounts) a.code: a};
  final capital = acctMap['3010']?.bal ?? 0;
  final retainedOpening = acctMap['3020']?.bal ?? 0;
  final retainedClosing = retainedOpening + pl.netIncome;
  final totalEquity = capital + retainedClosing;

  return BalanceSheetResult(
    currentAssets: currentAssets,
    fixedAssets: fixedAssets,
    totalCurrentAssets: totalCurrentAssets,
    totalFixedAssets: totalFixedAssets,
    totalAssets: totalAssets,
    curLiab: curLiab,
    ltLiab: ltLiab,
    totalCurLiab: totalCurLiab,
    totalLtLiab: totalLtLiab,
    totalLiab: totalLiab,
    capital: capital,
    retainedOpening: retainedOpening,
    netIncome: pl.netIncome,
    retainedClosing: retainedClosing,
    totalEquity: totalEquity,
    totalLiabEquity: totalLiab + totalEquity,
  );
}

AgeTotals ageTotals(List<AgingRow> rows) {
  const keys = ['current', 'd30', 'd60', 'd90'];
  final buckets = <String, int>{
    for (final k in keys)
      k: rows.fold<int>(0, (s, r) {
        switch (k) {
          case 'current':
            return s + r.current;
          case 'd30':
            return s + r.d30;
          case 'd60':
            return s + r.d60;
          case 'd90':
            return s + r.d90;
          default:
            return s;
        }
      }),
  };
  final total = buckets.values.fold<int>(0, (s, v) => s + v);
  return AgeTotals(buckets: buckets, total: total);
}

String money(int? n, {bool sign = false}) {
  if (n == null) return '—';
  final neg = n < 0;
  final s = NumberFormat('#,###', 'en_US').format(n.abs());
  if (neg) return '($s)';
  return '${sign ? '+' : ''}$s';
}

String compact(int n) {
  final abs = n.abs();
  if (abs >= 1e9) return '${(n / 1e9).toStringAsFixed(1)}B';
  if (abs >= 1e6) return '${(n / 1e6).toStringAsFixed(2)}M';
  if (abs >= 1e3) return '${(n / 1e3).round()}K';
  return n.round().toString();
}

int pendingJournalCount(List<JournalEntry> journal) {
  return journal.where((e) => e.status == JournalStatus.pending).length;
}

List<GlPosting> generalLedgerPostings(
  String accountCode,
  List<JournalEntry> journal,
  List<Account> accounts,
) {
  final acctMap = {for (final a in accounts) a.code: a};
  final account = acctMap[accountCode];
  if (account == null) return [];

  final postings = <({String date, String jeId, String memo, int debit, int credit})>[];
  for (final e in journal) {
    if (e.status == JournalStatus.draft) continue;
    for (final line in e.lines) {
      if (line.ac != accountCode) continue;
      postings.add((
        date: e.date,
        jeId: e.id,
        memo: e.memo,
        debit: line.dr,
        credit: line.cr,
      ));
    }
  }

  var running = account.bal;
  for (var i = postings.length - 1; i >= 0; i--) {
    final p = postings[i];
    if (account.isDebitNormal) {
      running -= p.debit - p.credit;
    } else {
      running -= p.credit - p.debit;
    }
  }
  final opening = running;

  var balance = opening;
  final result = <GlPosting>[];
  for (final p in postings) {
    if (account.isDebitNormal) {
      balance += p.debit - p.credit;
    } else {
      balance += p.credit - p.debit;
    }
    result.add(GlPosting(
      date: p.date,
      jeId: p.jeId,
      memo: p.memo,
      debit: p.debit,
      credit: p.credit,
      balance: balance,
    ));
  }
  return result;
}
