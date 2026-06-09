// ===========================================================
//  Flipper Accounting · shared data model
//  One coherent double-entry dataset. P&L, Balance Sheet and
//  Trial Balance are all DERIVED from the chart of accounts so
//  the numbers always agree (debits === credits).
//  Currency: RWF · Entity: Demo Shop Ltd · Period: May 2026
// ===========================================================

// account.normal = 'D' (debit-normal) or 'C' (credit-normal).
// bal is always stored positive in its normal direction.
const ACCOUNTS = [
  // ---- Assets ----
  { code: '1010', name: 'Cash on Hand',            type: 'asset', sub: 'Current assets', normal: 'D', bal: 1240000 },
  { code: '1020', name: 'Bank · Bank of Kigali',   type: 'asset', sub: 'Current assets', normal: 'D', bal: 4180000 },
  { code: '1030', name: 'Mobile Money (MoMo)',     type: 'asset', sub: 'Current assets', normal: 'D', bal: 860000 },
  { code: '1100', name: 'Accounts Receivable',     type: 'asset', sub: 'Current assets', normal: 'D', bal: 2360000 },
  { code: '1200', name: 'Inventory',               type: 'asset', sub: 'Current assets', normal: 'D', bal: 5900000 },
  { code: '1500', name: 'Equipment & Fixtures',    type: 'asset', sub: 'Fixed assets',   normal: 'D', bal: 3200000 },
  { code: '1510', name: 'Accumulated Depreciation', type: 'asset', sub: 'Fixed assets',  normal: 'C', bal: 900000, contra: true },

  // ---- Liabilities ----
  { code: '2010', name: 'Accounts Payable',        type: 'liability', sub: 'Current liabilities', normal: 'C', bal: 1980000 },
  { code: '2100', name: 'VAT Payable',             type: 'liability', sub: 'Current liabilities', normal: 'C', bal: 640000 },
  { code: '2300', name: 'Wages Payable',           type: 'liability', sub: 'Current liabilities', normal: 'C', bal: 220000 },
  { code: '2200', name: 'Bank Loan · Bank of Kigali', type: 'liability', sub: 'Long-term liabilities', normal: 'C', bal: 4000000 },

  // ---- Equity ----
  { code: '3010', name: "Owner's Capital",         type: 'equity', sub: 'Equity', normal: 'C', bal: 6000000 },
  { code: '3020', name: 'Retained Earnings',       type: 'equity', sub: 'Equity', normal: 'C', bal: 2080000, note: 'Opening' },

  // ---- Income ----
  { code: '4010', name: 'Sales Revenue',           type: 'income', sub: 'Operating income', normal: 'C', bal: 7240000 },
  { code: '4020', name: 'Service Income',          type: 'income', sub: 'Operating income', normal: 'C', bal: 360000 },
  { code: '4090', name: 'Sales Discounts',         type: 'income', sub: 'Operating income', normal: 'D', bal: 120000, contra: true },

  // ---- Expenses ----
  { code: '5010', name: 'Cost of Goods Sold',      type: 'expense', sub: 'Cost of sales',     normal: 'D', bal: 4200000 },
  { code: '6010', name: 'Rent',                    type: 'expense', sub: 'Operating expenses', normal: 'D', bal: 350000 },
  { code: '6020', name: 'Salaries & Wages',        type: 'expense', sub: 'Operating expenses', normal: 'D', bal: 520000 },
  { code: '6030', name: 'Utilities',               type: 'expense', sub: 'Operating expenses', normal: 'D', bal: 95000 },
  { code: '6040', name: 'Transport',               type: 'expense', sub: 'Operating expenses', normal: 'D', bal: 140000 },
  { code: '6050', name: 'Marketing',               type: 'expense', sub: 'Operating expenses', normal: 'D', bal: 180000 },
  { code: '6900', name: 'Depreciation Expense',    type: 'expense', sub: 'Operating expenses', normal: 'D', bal: 75000 },
];

const ACCT = Object.fromEntries(ACCOUNTS.map((a) => [a.code, a]));
const acctName = (code) => (ACCT[code] ? ACCT[code].name : code);

// debit / credit column value for the trial balance
const drOf = (a) => (a.normal === 'D' ? a.bal : 0);
const crOf = (a) => (a.normal === 'C' ? a.bal : 0);

// ---- derived statements -------------------------------------------------
function trialBalance() {
  const rows = ACCOUNTS.map((a) => ({ ...a, dr: drOf(a), cr: crOf(a) }));
  const totDr = rows.reduce((s, r) => s + r.dr, 0);
  const totCr = rows.reduce((s, r) => s + r.cr, 0);
  return { rows, totDr, totCr, balanced: totDr === totCr };
}

function incomeStatement() {
  const income = ACCOUNTS.filter((a) => a.type === 'income');
  const grossRevenue = income.filter((a) => !a.contra).reduce((s, a) => s + a.bal, 0);
  const discounts = income.filter((a) => a.contra).reduce((s, a) => s + a.bal, 0);
  const netRevenue = grossRevenue - discounts;
  const cogs = ACCOUNTS.filter((a) => a.sub === 'Cost of sales').reduce((s, a) => s + a.bal, 0);
  const grossProfit = netRevenue - cogs;
  const opex = ACCOUNTS.filter((a) => a.sub === 'Operating expenses');
  const totalOpex = opex.reduce((s, a) => s + a.bal, 0);
  const netIncome = grossProfit - totalOpex;
  return {
    income, discounts, grossRevenue, netRevenue,
    cogs, grossProfit, opex, totalOpex, netIncome,
    grossMargin: grossProfit / netRevenue,
    netMargin: netIncome / netRevenue,
  };
}

function balanceSheet() {
  const a = (sub) => ACCOUNTS.filter((x) => x.type === 'asset' && x.sub === sub);
  const currentAssets = a('Current assets');
  const fixedAssets = a('Fixed assets');
  const assetVal = (x) => (x.contra ? -x.bal : x.bal);
  const totalCurrentAssets = currentAssets.reduce((s, x) => s + assetVal(x), 0);
  const totalFixedAssets = fixedAssets.reduce((s, x) => s + assetVal(x), 0);
  const totalAssets = totalCurrentAssets + totalFixedAssets;

  const curLiab = ACCOUNTS.filter((x) => x.sub === 'Current liabilities');
  const ltLiab = ACCOUNTS.filter((x) => x.sub === 'Long-term liabilities');
  const totalCurLiab = curLiab.reduce((s, x) => s + x.bal, 0);
  const totalLtLiab = ltLiab.reduce((s, x) => s + x.bal, 0);
  const totalLiab = totalCurLiab + totalLtLiab;

  const { netIncome } = incomeStatement();
  const capital = ACCT['3010'].bal;
  const retainedOpening = ACCT['3020'].bal;
  const retainedClosing = retainedOpening + netIncome;
  const totalEquity = capital + retainedClosing;

  return {
    currentAssets, fixedAssets, totalCurrentAssets, totalFixedAssets, totalAssets,
    curLiab, ltLiab, totalCurLiab, totalLtLiab, totalLiab,
    capital, retainedOpening, netIncome, retainedClosing, totalEquity,
    totalLiabEquity: totalLiab + totalEquity,
  };
}

// ---- journal entries (the daybook) -------------------------------------
// Each entry's lines balance (sum dr === sum cr). status: posted|pending|draft
const JOURNAL = [
  { id: 'JE-1047', date: 'May 31', memo: 'Monthly depreciation — equipment', ref: 'DEP-05', status: 'pending', src: 'Manual',
    lines: [{ ac: '6900', dr: 75000 }, { ac: '1510', cr: 75000 }] },
  { id: 'JE-1046', date: 'May 30', memo: 'Cash sale — counter (incl. 18% VAT)', ref: 'POS-8841', status: 'posted', src: 'POS',
    lines: [{ ac: '1010', dr: 283200 }, { ac: '4010', cr: 240000 }, { ac: '2100', cr: 43200 }] },
  { id: 'JE-1045', date: 'May 29', memo: 'Rent — June, Kigali branch', ref: 'EXP-220', status: 'posted', src: 'Manual',
    lines: [{ ac: '6010', dr: 350000 }, { ac: '1020', cr: 350000 }] },
  { id: 'JE-1044', date: 'May 28', memo: 'Supplier bill — Habimana Wholesalers', ref: 'BILL-512', status: 'posted', src: 'Bill',
    lines: [{ ac: '1200', dr: 1200000 }, { ac: '2010', cr: 1200000 }] },
  { id: 'JE-1043', date: 'May 27', memo: 'Customer payment — Karake Retail', ref: 'RCT-330', status: 'posted', src: 'Bank',
    lines: [{ ac: '1020', dr: 560000 }, { ac: '1100', cr: 560000 }] },
  { id: 'JE-1042', date: 'May 27', memo: 'MoMo sale — Nyamirambo stall', ref: 'POS-8839', status: 'posted', src: 'POS',
    lines: [{ ac: '1030', dr: 118000 }, { ac: '4010', cr: 100000 }, { ac: '2100', cr: 18000 }] },
  { id: 'JE-1041', date: 'May 26', memo: 'Staff salaries — May', ref: 'PAY-05', status: 'pending', src: 'Payroll',
    lines: [{ ac: '6020', dr: 520000 }, { ac: '2300', cr: 220000 }, { ac: '1020', cr: 300000 }] },
  { id: 'JE-1040', date: 'May 25', memo: 'Electricity & water — REG/WASAC', ref: 'EXP-219', status: 'posted', src: 'Manual',
    lines: [{ ac: '6030', dr: 95000 }, { ac: '1010', cr: 95000 }] },
  { id: 'JE-1039', date: 'May 24', memo: 'Delivery fuel & transport', ref: 'EXP-218', status: 'draft', src: 'Manual',
    lines: [{ ac: '6040', dr: 140000 }, { ac: '1010', cr: 140000 }] },
  { id: 'JE-1038', date: 'May 23', memo: 'Radio + flyer campaign', ref: 'EXP-217', status: 'posted', src: 'Manual',
    lines: [{ ac: '6050', dr: 180000 }, { ac: '1020', cr: 180000 }] },
];

function jeTotals(e) {
  const dr = e.lines.reduce((s, l) => s + (l.dr || 0), 0);
  const cr = e.lines.reduce((s, l) => s + (l.cr || 0), 0);
  return { dr, cr, balanced: dr === cr };
}

// ---- receivables / payables aging --------------------------------------
const AR = [
  { name: 'Karake Retail Group',    inv: 'INV-2208', current: 0,       d30: 640000,  d60: 0,      d90: 0,      },
  { name: 'Mutoni Boutique',        inv: 'INV-2204', current: 380000,  d30: 0,       d60: 0,      d90: 0,      },
  { name: 'Gisenyi Mini-Mart',      inv: 'INV-2199', current: 0,       d30: 0,       d60: 410000, d90: 0,      },
  { name: 'Twesigye Hardware',      inv: 'INV-2188', current: 0,       d30: 0,       d60: 0,      d90: 290000, },
  { name: 'Umutara Traders',        inv: 'INV-2210', current: 520000,  d30: 0,       d60: 0,      d90: 0,      },
  { name: 'Kivu Fresh Foods',       inv: 'INV-2195', current: 0,       d30: 120000,  d60: 0,      d90: 0,      },
];
const AP = [
  { name: 'Habimana Wholesalers',   inv: 'BILL-512', current: 1200000, d30: 0,       d60: 0,      d90: 0,      },
  { name: 'Rwanda Beverage Co.',    inv: 'BILL-498', current: 0,       d30: 340000,  d60: 0,      d90: 0,      },
  { name: 'Kigali Packaging Ltd',   inv: 'BILL-491', current: 0,       d30: 0,       d60: 180000, d90: 0,      },
  { name: 'Akagera Logistics',      inv: 'BILL-487', current: 260000,  d30: 0,       d60: 0,      d90: 0,      },
];
function ageTotals(rows) {
  const k = ['current', 'd30', 'd60', 'd90'];
  const buckets = Object.fromEntries(k.map((b) => [b, rows.reduce((s, r) => s + r[b], 0)]));
  const total = k.reduce((s, b) => s + buckets[b], 0);
  return { buckets, total };
}

// ---- VAT (18% Rwanda standard) -----------------------------------------
const VAT = {
  rate: 0.18,
  outputVat: 1280000,   // VAT collected on sales
  inputVat: 640000,     // VAT paid on purchases (reclaimable)
  get netPayable() { return this.outputVat - this.inputVat; },
  dueDate: '15 Jun 2026',
};

// ---- 6-month trend (for charts) ----------------------------------------
const TREND = [
  { m: 'Dec', rev: 5900000, exp: 4400000 },
  { m: 'Jan', rev: 6200000, exp: 4600000 },
  { m: 'Feb', rev: 5800000, exp: 4500000 },
  { m: 'Mar', rev: 6700000, exp: 4900000 },
  { m: 'Apr', rev: 7000000, exp: 5200000 },
  { m: 'May', rev: 7480000, exp: 5560000 },
];

// ---- formatting --------------------------------------------------------
function money(n, { sign = false } = {}) {
  if (n == null) return '—';
  const neg = n < 0;
  const s = Math.abs(Math.round(n)).toLocaleString('en-US');
  if (neg) return '(' + s + ')';
  return (sign ? '+' : '') + s;
}
function compact(n) {
  const abs = Math.abs(n);
  if (abs >= 1e9) return (n / 1e9).toFixed(1) + 'B';
  if (abs >= 1e6) return (n / 1e6).toFixed(2) + 'M';
  if (abs >= 1e3) return Math.round(n / 1e3) + 'K';
  return String(Math.round(n));
}

Object.assign(window, {
  ACCOUNTS, ACCT, acctName, drOf, crOf,
  trialBalance, incomeStatement, balanceSheet,
  JOURNAL, jeTotals, AR, AP, ageTotals, VAT, TREND,
  money, compact,
});
