enum AccountType { asset, liability, equity, income, expense }

enum AccountNormal { debit, credit }

enum JournalStatus { posted, pending, draft }

class Account {
  const Account({
    required this.code,
    required this.name,
    required this.type,
    required this.sub,
    required this.normal,
    required this.bal,
    this.contra = false,
    this.note,
  });

  final String code;
  final String name;
  final AccountType type;
  final String sub;
  final AccountNormal normal;
  final int bal;
  final bool contra;
  final String? note;

  bool get isDebitNormal => normal == AccountNormal.debit;
}

class JournalLine {
  const JournalLine({required this.ac, this.dr = 0, this.cr = 0});

  final String ac;
  final int dr;
  final int cr;
}

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.date,
    required this.memo,
    required this.ref,
    required this.status,
    required this.src,
    required this.lines,
  });

  final String id;
  final String date;
  final String memo;
  final String ref;
  final JournalStatus status;
  final String src;
  final List<JournalLine> lines;
}

class AgingRow {
  const AgingRow({
    required this.name,
    required this.inv,
    required this.current,
    required this.d30,
    required this.d60,
    required this.d90,
  });

  final String name;
  final String inv;
  final int current;
  final int d30;
  final int d60;
  final int d90;

  int get total => current + d30 + d60 + d90;
}

class TrendPoint {
  const TrendPoint({required this.m, required this.rev, required this.exp});

  final String m;
  final int rev;
  final int exp;
}

class BankLine {
  const BankLine({
    required this.date,
    required this.desc,
    required this.amt,
    required this.matched,
    this.je,
  });

  final String date;
  final String desc;
  final int amt;
  final bool matched;
  final String? je;
}

class VatInfo {
  const VatInfo({
    required this.rate,
    required this.outputVat,
    required this.inputVat,
    required this.dueDate,
  });

  final double rate;
  final int outputVat;
  final int inputVat;
  final String dueDate;

  int get netPayable => outputVat - inputVat;
}

class JeTotals {
  const JeTotals({required this.dr, required this.cr, required this.balanced});

  final int dr;
  final int cr;
  final bool balanced;
}

class TrialBalanceRow {
  const TrialBalanceRow({
    required this.account,
    required this.dr,
    required this.cr,
  });

  final Account account;
  final int dr;
  final int cr;
}

class TrialBalanceResult {
  const TrialBalanceResult({
    required this.rows,
    required this.totDr,
    required this.totCr,
    required this.balanced,
  });

  final List<TrialBalanceRow> rows;
  final int totDr;
  final int totCr;
  final bool balanced;
}

class IncomeStatementResult {
  const IncomeStatementResult({
    required this.income,
    required this.discounts,
    required this.grossRevenue,
    required this.netRevenue,
    required this.cogs,
    required this.grossProfit,
    required this.opex,
    required this.totalOpex,
    required this.netIncome,
    required this.grossMargin,
    required this.netMargin,
  });

  final List<Account> income;
  final int discounts;
  final int grossRevenue;
  final int netRevenue;
  final int cogs;
  final int grossProfit;
  final List<Account> opex;
  final int totalOpex;
  final int netIncome;
  final double grossMargin;
  final double netMargin;
}

class BalanceSheetResult {
  const BalanceSheetResult({
    required this.currentAssets,
    required this.fixedAssets,
    required this.totalCurrentAssets,
    required this.totalFixedAssets,
    required this.totalAssets,
    required this.curLiab,
    required this.ltLiab,
    required this.totalCurLiab,
    required this.totalLtLiab,
    required this.totalLiab,
    required this.capital,
    required this.retainedOpening,
    required this.netIncome,
    required this.retainedClosing,
    required this.totalEquity,
    required this.totalLiabEquity,
  });

  final List<Account> currentAssets;
  final List<Account> fixedAssets;
  final int totalCurrentAssets;
  final int totalFixedAssets;
  final int totalAssets;
  final List<Account> curLiab;
  final List<Account> ltLiab;
  final int totalCurLiab;
  final int totalLtLiab;
  final int totalLiab;
  final int capital;
  final int retainedOpening;
  final int netIncome;
  final int retainedClosing;
  final int totalEquity;
  final int totalLiabEquity;
}

class AgeTotals {
  const AgeTotals({required this.buckets, required this.total});

  final Map<String, int> buckets;
  final int total;
}

class GlPosting {
  const GlPosting({
    required this.date,
    required this.jeId,
    required this.memo,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  final String date;
  final String jeId;
  final String memo;
  final int debit;
  final int credit;
  final int balance;
}
