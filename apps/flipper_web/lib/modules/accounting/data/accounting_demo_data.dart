import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

const demoEntityName = 'Demo Shop Ltd';
const demoFiscalYear = 'FY 2026';
const demoCurrency = 'RWF';
const demoPeriod = 'May 2026';

const demoAccounts = <Account>[
  Account(code: '1010', name: 'Cash on Hand', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 1240000),
  Account(code: '1020', name: 'Bank · Bank of Kigali', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 4180000),
  Account(code: '1030', name: 'Mobile Money (MoMo)', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 860000),
  Account(code: '1100', name: 'Accounts Receivable', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 2360000),
  Account(code: '1200', name: 'Inventory', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 5900000),
  Account(code: '1500', name: 'Equipment & Fixtures', type: AccountType.asset, sub: 'Fixed assets', normal: AccountNormal.debit, bal: 3200000),
  Account(code: '1510', name: 'Accumulated Depreciation', type: AccountType.asset, sub: 'Fixed assets', normal: AccountNormal.credit, bal: 900000, contra: true),
  Account(code: '2010', name: 'Accounts Payable', type: AccountType.liability, sub: 'Current liabilities', normal: AccountNormal.credit, bal: 1980000),
  Account(code: '2100', name: 'VAT Payable', type: AccountType.liability, sub: 'Current liabilities', normal: AccountNormal.credit, bal: 640000),
  Account(code: '2300', name: 'Wages Payable', type: AccountType.liability, sub: 'Current liabilities', normal: AccountNormal.credit, bal: 220000),
  Account(code: '2200', name: 'Bank Loan · Bank of Kigali', type: AccountType.liability, sub: 'Long-term liabilities', normal: AccountNormal.credit, bal: 4000000),
  Account(code: '3010', name: "Owner's Capital", type: AccountType.equity, sub: 'Equity', normal: AccountNormal.credit, bal: 6000000),
  Account(code: '3020', name: 'Retained Earnings', type: AccountType.equity, sub: 'Equity', normal: AccountNormal.credit, bal: 2080000, note: 'Opening'),
  Account(code: '4010', name: 'Sales Revenue', type: AccountType.income, sub: 'Operating income', normal: AccountNormal.credit, bal: 7240000),
  Account(code: '4020', name: 'Service Income', type: AccountType.income, sub: 'Operating income', normal: AccountNormal.credit, bal: 360000),
  Account(code: '4090', name: 'Sales Discounts', type: AccountType.income, sub: 'Operating income', normal: AccountNormal.debit, bal: 120000, contra: true),
  Account(code: '5010', name: 'Cost of Goods Sold', type: AccountType.expense, sub: 'Cost of sales', normal: AccountNormal.debit, bal: 4200000),
  Account(code: '6010', name: 'Rent', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 350000),
  Account(code: '6020', name: 'Salaries & Wages', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 520000),
  Account(code: '6030', name: 'Utilities', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 95000),
  Account(code: '6040', name: 'Transport', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 140000),
  Account(code: '6050', name: 'Marketing', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 180000),
  Account(code: '6900', name: 'Depreciation Expense', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 75000),
];

Map<String, Account> buildAccountMap(List<Account> accounts) {
  return {for (final a in accounts) a.code: a};
}

final demoAccountMap = buildAccountMap(demoAccounts);

const demoJournal = <JournalEntry>[
  JournalEntry(id: 'JE-1047', date: 'May 31', memo: 'Monthly depreciation — equipment', ref: 'DEP-05', status: JournalStatus.pending, src: 'Manual', lines: [JournalLine(ac: '6900', dr: 75000), JournalLine(ac: '1510', cr: 75000)]),
  JournalEntry(id: 'JE-1046', date: 'May 30', memo: 'Cash sale — counter (incl. 18% VAT)', ref: 'POS-8841', status: JournalStatus.posted, src: 'POS', lines: [JournalLine(ac: '1010', dr: 283200), JournalLine(ac: '4010', cr: 240000), JournalLine(ac: '2100', cr: 43200)]),
  JournalEntry(id: 'JE-1045', date: 'May 29', memo: 'Rent — June, Kigali branch', ref: 'EXP-220', status: JournalStatus.posted, src: 'Manual', lines: [JournalLine(ac: '6010', dr: 350000), JournalLine(ac: '1020', cr: 350000)]),
  JournalEntry(id: 'JE-1044', date: 'May 28', memo: 'Supplier bill — Habimana Wholesalers', ref: 'BILL-512', status: JournalStatus.posted, src: 'Bill', lines: [JournalLine(ac: '1200', dr: 1200000), JournalLine(ac: '2010', cr: 1200000)]),
  JournalEntry(id: 'JE-1043', date: 'May 27', memo: 'Customer payment — Karake Retail', ref: 'RCT-330', status: JournalStatus.posted, src: 'Bank', lines: [JournalLine(ac: '1020', dr: 560000), JournalLine(ac: '1100', cr: 560000)]),
  JournalEntry(id: 'JE-1042', date: 'May 27', memo: 'MoMo sale — Nyamirambo stall', ref: 'POS-8839', status: JournalStatus.posted, src: 'POS', lines: [JournalLine(ac: '1030', dr: 118000), JournalLine(ac: '4010', cr: 100000), JournalLine(ac: '2100', cr: 18000)]),
  JournalEntry(id: 'JE-1041', date: 'May 26', memo: 'Staff salaries — May', ref: 'PAY-05', status: JournalStatus.pending, src: 'Payroll', lines: [JournalLine(ac: '6020', dr: 520000), JournalLine(ac: '2300', cr: 220000), JournalLine(ac: '1020', cr: 300000)]),
  JournalEntry(id: 'JE-1040', date: 'May 25', memo: 'Electricity & water — REG/WASAC', ref: 'EXP-219', status: JournalStatus.posted, src: 'Manual', lines: [JournalLine(ac: '6030', dr: 95000), JournalLine(ac: '1010', cr: 95000)]),
  JournalEntry(id: 'JE-1039', date: 'May 24', memo: 'Delivery fuel & transport', ref: 'EXP-218', status: JournalStatus.draft, src: 'Manual', lines: [JournalLine(ac: '6040', dr: 140000), JournalLine(ac: '1010', cr: 140000)]),
  JournalEntry(id: 'JE-1038', date: 'May 23', memo: 'Radio + flyer campaign', ref: 'EXP-217', status: JournalStatus.posted, src: 'Manual', lines: [JournalLine(ac: '6050', dr: 180000), JournalLine(ac: '1020', cr: 180000)]),
];

const demoAr = <AgingRow>[
  AgingRow(name: 'Karake Retail Group', inv: 'INV-2208', current: 0, d30: 640000, d60: 0, d90: 0),
  AgingRow(name: 'Mutoni Boutique', inv: 'INV-2204', current: 380000, d30: 0, d60: 0, d90: 0),
  AgingRow(name: 'Gisenyi Mini-Mart', inv: 'INV-2199', current: 0, d30: 0, d60: 410000, d90: 0),
  AgingRow(name: 'Twesigye Hardware', inv: 'INV-2188', current: 0, d30: 0, d60: 0, d90: 290000),
  AgingRow(name: 'Umutara Traders', inv: 'INV-2210', current: 520000, d30: 0, d60: 0, d90: 0),
  AgingRow(name: 'Kivu Fresh Foods', inv: 'INV-2195', current: 0, d30: 120000, d60: 0, d90: 0),
];

const demoAp = <AgingRow>[
  AgingRow(name: 'Habimana Wholesalers', inv: 'BILL-512', current: 1200000, d30: 0, d60: 0, d90: 0),
  AgingRow(name: 'Rwanda Beverage Co.', inv: 'BILL-498', current: 0, d30: 340000, d60: 0, d90: 0),
  AgingRow(name: 'Kigali Packaging Ltd', inv: 'BILL-491', current: 0, d30: 0, d60: 180000, d90: 0),
  AgingRow(name: 'Akagera Logistics', inv: 'BILL-487', current: 260000, d30: 0, d60: 0, d90: 0),
];

const demoVat = VatInfo(rate: 0.18, outputVat: 1280000, inputVat: 640000, dueDate: '15 Jun 2026');

const demoTrend = <TrendPoint>[
  TrendPoint(m: 'Dec', rev: 5900000, exp: 4400000),
  TrendPoint(m: 'Jan', rev: 6200000, exp: 4600000),
  TrendPoint(m: 'Feb', rev: 5800000, exp: 4500000),
  TrendPoint(m: 'Mar', rev: 6700000, exp: 4900000),
  TrendPoint(m: 'Apr', rev: 7000000, exp: 5200000),
  TrendPoint(m: 'May', rev: 7480000, exp: 5560000),
];

const demoBankLines = <BankLine>[
  BankLine(date: 'May 30', desc: 'POS settlement · counter', amt: 283200, matched: true, je: 'JE-1046'),
  BankLine(date: 'May 29', desc: 'Rent payment · landlord', amt: -350000, matched: true, je: 'JE-1045'),
  BankLine(date: 'May 27', desc: 'Transfer from Karake Retail', amt: 560000, matched: true, je: 'JE-1043'),
  BankLine(date: 'May 26', desc: 'Salary run · staff', amt: -300000, matched: true, je: 'JE-1041'),
  BankLine(date: 'May 25', desc: 'Bank charges', amt: -8500, matched: false),
  BankLine(date: 'May 23', desc: 'Marketing · radio spot', amt: -180000, matched: true, je: 'JE-1038'),
  BankLine(date: 'May 22', desc: 'MoMo float top-up', amt: -120000, matched: false),
];
