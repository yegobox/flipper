import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/services/books_overview_export.dart';

const tricky = 'Sale, 2 x "Fanta"\nline';

const fixtureAccounts = [
  Account(
    code: '1020',
    name: 'Bank',
    type: AccountType.asset,
    sub: 'Current assets',
    normal: AccountNormal.debit,
    bal: -2139346,
  ),
  Account(
    code: '4010',
    name: 'Sales',
    type: AccountType.income,
    sub: 'Revenue',
    normal: AccountNormal.credit,
    bal: 2619400,
  ),
  Account(
    code: '6100',
    name: 'Opérations',
    type: AccountType.expense,
    sub: 'Operating expenses',
    normal: AccountNormal.debit,
    bal: 4762346,
  ),
];

const fixturePl = IncomeStatementResult(
  income: [],
  discounts: 0,
  grossRevenue: 2619400,
  netRevenue: 2619400,
  cogs: 899596,
  grossProfit: 1719804,
  opex: [
    Account(
      code: '6100',
      name: 'Opérations',
      type: AccountType.expense,
      sub: 'Operating expenses',
      normal: AccountNormal.debit,
      bal: 4762346,
    ),
  ],
  totalOpex: 4762346,
  netIncome: -3042542,
  grossMargin: 0.66,
  netMargin: -1.16,
);

const fixtureJournal = [
  JournalEntry(
    id: 'JE-99',
    date: 'Oct 9',
    memo: tricky,
    ref: 'r1',
    status: JournalStatus.posted,
    src: 'POS',
    lines: [
      JournalLine(ac: '1020', dr: 4000),
      JournalLine(ac: '4010', cr: 4000),
    ],
  ),
  JournalEntry(
    id: 'JE-100',
    date: 'Oct 9',
    memo: 'Rent',
    ref: 'r2',
    status: JournalStatus.pending,
    src: 'Manual',
    lines: [
      JournalLine(ac: '6100', dr: 11566),
      JournalLine(ac: '1020', cr: 11566),
    ],
  ),
];

const fixtureTrend = [
  TrendPoint(m: 'Sep', rev: 0, exp: 0),
  TrendPoint(m: 'Oct', rev: 2619400, exp: 5661942),
];

BooksOverviewSnapshot fixtureSnapshot() => const BooksOverviewSnapshot(
  entityName: 'Muhazi Marina Beach',
  period: 'Oct 2026',
  currency: 'RWF',
  pl: fixturePl,
  cashBank: -2139346,
  arTotal: 0,
  apTotal: 1314001,
  trend: fixtureTrend,
  journal: fixtureJournal,
  accounts: fixtureAccounts,
);
