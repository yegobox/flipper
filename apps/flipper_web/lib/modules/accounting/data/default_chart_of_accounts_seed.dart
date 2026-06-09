import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

/// Zero-balance COA templates used for seeding and tests only — not runtime demo data.
const defaultChartOfAccountsSeed = <Account>[
  Account(code: '1010', name: 'Cash on Hand', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 0),
  Account(code: '1020', name: 'Bank', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 0),
  Account(code: '1030', name: 'Mobile Money (MoMo)', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 0),
  Account(code: '1100', name: 'Accounts Receivable', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 0),
  Account(code: '1200', name: 'Inventory', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 0),
  Account(code: '1500', name: 'Equipment & Fixtures', type: AccountType.asset, sub: 'Fixed assets', normal: AccountNormal.debit, bal: 0),
  Account(code: '1510', name: 'Accumulated Depreciation', type: AccountType.asset, sub: 'Fixed assets', normal: AccountNormal.credit, bal: 0, contra: true),
  Account(code: '2010', name: 'Accounts Payable', type: AccountType.liability, sub: 'Current liabilities', normal: AccountNormal.credit, bal: 0),
  Account(code: '2100', name: 'VAT Payable', type: AccountType.liability, sub: 'Current liabilities', normal: AccountNormal.credit, bal: 0),
  Account(code: '2300', name: 'Wages Payable', type: AccountType.liability, sub: 'Current liabilities', normal: AccountNormal.credit, bal: 0),
  Account(code: '2200', name: 'Bank Loan', type: AccountType.liability, sub: 'Long-term liabilities', normal: AccountNormal.credit, bal: 0),
  Account(code: '3010', name: "Owner's Capital", type: AccountType.equity, sub: 'Equity', normal: AccountNormal.credit, bal: 0),
  Account(code: '3020', name: 'Retained Earnings', type: AccountType.equity, sub: 'Equity', normal: AccountNormal.credit, bal: 0, note: 'Opening'),
  Account(code: '4010', name: 'Sales Revenue', type: AccountType.income, sub: 'Operating income', normal: AccountNormal.credit, bal: 0),
  Account(code: '4020', name: 'Service Income', type: AccountType.income, sub: 'Operating income', normal: AccountNormal.credit, bal: 0),
  Account(code: '4090', name: 'Sales Discounts', type: AccountType.income, sub: 'Operating income', normal: AccountNormal.debit, bal: 0, contra: true),
  Account(code: '5010', name: 'Cost of Goods Sold', type: AccountType.expense, sub: 'Cost of sales', normal: AccountNormal.debit, bal: 0),
  Account(code: '6010', name: 'Rent', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 0),
  Account(code: '6020', name: 'Salaries & Wages', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 0),
  Account(code: '6030', name: 'Utilities', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 0),
  Account(code: '6040', name: 'Transport', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 0),
  Account(code: '6050', name: 'Marketing', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 0),
  Account(code: '6900', name: 'Depreciation Expense', type: AccountType.expense, sub: 'Operating expenses', normal: AccountNormal.debit, bal: 0),
];
