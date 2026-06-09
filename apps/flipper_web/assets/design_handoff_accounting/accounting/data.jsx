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

// ---- contacts: customers & suppliers (master records) ------------------
const CUSTOMERS = [
  { id: 'C-01', name: 'Karake Retail Group', contact: 'Jean-Paul Karake', phone: '+250 788 120 440', email: 'accounts@karake.rw', tin: '102938471', since: 'Mar 2024', terms: 'Net 30', balance: 640000 },
  { id: 'C-02', name: 'Mutoni Boutique',     contact: 'Aline Mutoni',     phone: '+250 788 304 119', email: 'aline@mutoni.rw',    tin: '109284756', since: 'Jul 2024', terms: 'Net 15', balance: 380000 },
  { id: 'C-03', name: 'Gisenyi Mini-Mart',   contact: 'Eric Niyonzima',   phone: '+250 788 551 202', email: 'gisenyi.mart@gmail.com', tin: '113847562', since: 'Jan 2024', terms: 'Net 30', balance: 410000 },
  { id: 'C-04', name: 'Twesigye Hardware',   contact: 'Robert Twesigye',  phone: '+250 788 667 833', email: 'sales@twesigye.rw',  tin: '118273645', since: 'Sep 2023', terms: 'Net 30', balance: 290000 },
  { id: 'C-05', name: 'Umutara Traders',     contact: 'Claudine Uwase',   phone: '+250 788 712 909', email: 'umutara.traders@yahoo.com', tin: '120394857', since: 'Feb 2025', terms: 'Net 15', balance: 520000 },
  { id: 'C-06', name: 'Kivu Fresh Foods',    contact: 'Patrick Habineza', phone: '+250 788 845 661', email: 'finance@kivufresh.rw', tin: '124857390', since: 'Nov 2024', terms: 'Net 30', balance: 120000 },
];
const SUPPLIERS = [
  { id: 'S-01', name: 'Habimana Wholesalers', contact: 'Théogène Habimana', phone: '+250 788 201 553', email: 'orders@habimana.rw',  tin: '130495761', since: 'Jan 2023', terms: 'Net 30', balance: 1200000 },
  { id: 'S-02', name: 'Rwanda Beverage Co.',  contact: 'Sales desk',         phone: '+250 788 990 014', email: 'b2b@rwandabev.rw',    tin: '133847562', since: 'May 2023', terms: 'Net 45', balance: 340000 },
  { id: 'S-03', name: 'Kigali Packaging Ltd', contact: 'Yves Mugisha',       phone: '+250 788 443 217', email: 'invoice@kpack.rw',    tin: '137162849', since: 'Aug 2024', terms: 'Net 30', balance: 180000 },
  { id: 'S-04', name: 'Akagera Logistics',    contact: 'Dispatch',           phone: '+250 788 118 776', email: 'billing@akageralog.rw', tin: '140382947', since: 'Oct 2024', terms: 'Net 15', balance: 260000 },
];

// ---- sales invoices & purchase bills (line-item documents) -------------
// status: draft | sent | paid | overdue.  lines: {desc, qty, price}
const INVOICES = [
  { id: 'INV-2210', who: 'Umutara Traders',     date: '30 May 2026', due: '14 Jun 2026', status: 'sent',    lines: [{ desc: 'Wholesale carton · cooking oil 20L', qty: 8, price: 52000 }, { desc: 'Delivery surcharge', qty: 1, price: 24000 }] },
  { id: 'INV-2209', who: 'Mutoni Boutique',     date: '28 May 2026', due: '12 Jun 2026', status: 'sent',    lines: [{ desc: 'Assorted fabric rolls', qty: 6, price: 48000 }, { desc: 'Tailoring accessories pack', qty: 2, price: 46000 }] },
  { id: 'INV-2208', who: 'Karake Retail Group', date: '24 May 2026', due: '08 Jun 2026', status: 'overdue', lines: [{ desc: 'Bulk sugar 50kg sack', qty: 10, price: 54237 }] },
  { id: 'INV-2207', who: 'Kivu Fresh Foods',    date: '22 May 2026', due: '06 Jun 2026', status: 'sent',    lines: [{ desc: 'Fresh produce crates', qty: 12, price: 8475 }] },
  { id: 'INV-2206', who: 'Gisenyi Mini-Mart',   date: '18 May 2026', due: '02 Jun 2026', status: 'overdue', lines: [{ desc: 'Soft drinks · mixed pallets', qty: 5, price: 69492 }] },
  { id: 'INV-2205', who: 'Karake Retail Group', date: '12 May 2026', due: '27 May 2026', status: 'paid',    lines: [{ desc: 'Rice 25kg bags', qty: 30, price: 22600 }] },
  { id: 'INV-2204', who: 'Twesigye Hardware',   date: '08 May 2026', due: '23 May 2026', status: 'paid',    lines: [{ desc: 'Cement bags 50kg', qty: 40, price: 11440 }] },
  { id: 'INV-2203', who: 'Mutoni Boutique',     date: '02 May 2026', due: '17 May 2026', status: 'draft',   lines: [{ desc: 'Seasonal collection deposit', qty: 1, price: 150000 }] },
];
const BILLS = [
  { id: 'BILL-512', who: 'Habimana Wholesalers', date: '28 May 2026', due: '27 Jun 2026', status: 'sent',    lines: [{ desc: 'Inventory restock · dry goods', qty: 1, price: 1016949 }] },
  { id: 'BILL-498', who: 'Rwanda Beverage Co.',  date: '20 May 2026', due: '04 Jul 2026', status: 'sent',    lines: [{ desc: 'Beverage supply · May', qty: 1, price: 288136 }] },
  { id: 'BILL-491', who: 'Kigali Packaging Ltd', date: '14 May 2026', due: '13 Jun 2026', status: 'overdue', lines: [{ desc: 'Branded packaging run', qty: 1, price: 152542 }] },
  { id: 'BILL-487', who: 'Akagera Logistics',    date: '10 May 2026', due: '25 May 2026', status: 'sent',    lines: [{ desc: 'Inter-city freight · May', qty: 1, price: 220339 }] },
  { id: 'BILL-480', who: 'Habimana Wholesalers', date: '02 May 2026', due: '01 Jun 2026', status: 'paid',    lines: [{ desc: 'Inventory restock · April', qty: 1, price: 940000 }] },
];

// document line/VAT maths (18% Rwanda standard, prices are VAT-exclusive)
function docTotals(lines, rate = 0.18) {
  const subtotal = lines.reduce((s, l) => s + (Number(l.qty) || 0) * (Number(l.price) || 0), 0);
  const vat = Math.round(subtotal * rate);
  return { subtotal, vat, total: subtotal + vat };
}
const DOC_STATUS = {
  draft:   { label: 'Draft',   cls: 'draft' },
  sent:    { label: 'Sent',    cls: 'sent' },
  paid:    { label: 'Paid',    cls: 'posted' },
  overdue: { label: 'Overdue', cls: 'overdue' },
};

// ---- recurring schedules (auto-posting templates) ----------------------
const RECURRING = [
  { id: 'R-01', name: 'Monthly rent — Kigali branch', freq: 'Monthly', day: '1st', next: '01 Jun 2026', amount: 350000, accounts: 'Rent → Bank', icon: 'Home', active: true },
  { id: 'R-02', name: 'Staff salaries', freq: 'Monthly', day: '26th', next: '26 Jun 2026', amount: 520000, accounts: 'Salaries → Wages payable / Bank', icon: 'Users', active: true },
  { id: 'R-03', name: 'Internet & airtime', freq: 'Monthly', day: '5th', next: '05 Jun 2026', amount: 60000, accounts: 'Utilities → MoMo', icon: 'Wallet', active: true },
  { id: 'R-04', name: 'Equipment depreciation', freq: 'Monthly', day: 'Last', next: '30 Jun 2026', amount: 75000, accounts: 'Depreciation → Accum. depreciation', icon: 'Stack', active: true },
  { id: 'R-05', name: 'Quarterly insurance', freq: 'Quarterly', day: '1st', next: '01 Jul 2026', amount: 180000, accounts: 'Insurance → Bank', icon: 'ShieldCheck', active: false },
];

// ---- audit trail (immutable activity log) ------------------------------
const AUDIT_LOG = [
  { id: 'A-209', ts: '31 May 2026 · 16:42', user: 'Diane E.', role: 'Owner', action: 'posted', target: 'JE-1046', detail: 'Cash sale — counter (RWF 283,200)', icon: 'Check', tone: 'green' },
  { id: 'A-208', ts: '31 May 2026 · 16:40', user: 'Diane E.', role: 'Owner', action: 'approved', target: 'JE-1045', detail: 'Rent — June, Kigali branch', icon: 'ShieldCheck', tone: 'green' },
  { id: 'A-207', ts: '31 May 2026 · 11:18', user: 'Samuel R.', role: 'Bookkeeper', action: 'created', target: 'INV-2210', detail: 'Invoice to Umutara Traders (RWF 560,000)', icon: 'Receipt', tone: 'blue' },
  { id: 'A-206', ts: '30 May 2026 · 09:51', user: 'Samuel R.', role: 'Bookkeeper', action: 'edited', target: 'BILL-512', detail: 'Updated due date to 27 Jun 2026', icon: 'Receipt', tone: 'amber' },
  { id: 'A-205', ts: '29 May 2026 · 17:03', user: 'Diane E.', role: 'Owner', action: 'matched', target: 'JE-1045', detail: 'Bank line reconciled — rent payment', icon: 'Refresh', tone: 'blue' },
  { id: 'A-204', ts: '29 May 2026 · 14:22', user: 'Grace I.', role: 'Viewer', action: 'exported', target: 'Trial balance', detail: 'Downloaded Excel workbook', icon: 'Download', tone: 'slate' },
  { id: 'A-203', ts: '28 May 2026 · 10:09', user: 'Samuel R.', role: 'Bookkeeper', action: 'created', target: 'BILL-512', detail: 'Bill from Habimana Wholesalers', icon: 'Receipt', tone: 'blue' },
  { id: 'A-202', ts: '27 May 2026 · 15:47', user: 'Diane E.', role: 'Owner', action: 'recorded', target: 'RCT-330', detail: 'Customer payment — Karake Retail (RWF 560,000)', icon: 'ArrowDown', tone: 'green' },
];

// ---- team & role-based access ------------------------------------------
const TEAM = [
  { id: 'U-1', name: 'Diane Mukamana', initials: 'DE', color: '#2563EB', email: 'diane@demoshop.rw', role: 'Owner', last: 'Active now', you: true },
  { id: 'U-2', name: 'Samuel Rwema',   initials: 'SR', color: '#0D9488', email: 'samuel@demoshop.rw', role: 'Bookkeeper', last: '2 hours ago' },
  { id: 'U-3', name: 'Grace Iradukunda', initials: 'GI', color: '#7C3AED', email: 'grace@demoshop.rw', role: 'Viewer', last: 'Yesterday' },
  { id: 'U-4', name: 'Eric Niyibizi',  initials: 'EN', color: '#E08600', email: 'eric@demoshop.rw', role: 'Cashier', last: '3 days ago' },
];
const ROLES = [
  { role: 'Owner',      desc: 'Full access — approve, post, file taxes, manage team', color: '#2563EB' },
  { role: 'Bookkeeper', desc: 'Create & edit entries, invoices and bills; cannot approve or file', color: '#0D9488' },
  { role: 'Cashier',    desc: 'Record sales and receipts from POS only', color: '#E08600' },
  { role: 'Viewer',     desc: 'Read-only access to reports and statements', color: '#7C3AED' },
];
const PERMISSIONS = [
  { cap: 'View reports & statements',   Owner: true, Bookkeeper: true,  Cashier: false, Viewer: true },
  { cap: 'Create invoices & bills',     Owner: true, Bookkeeper: true,  Cashier: false, Viewer: false },
  { cap: 'Record payments & receipts',  Owner: true, Bookkeeper: true,  Cashier: true,  Viewer: false },
  { cap: 'Post & edit journal entries', Owner: true, Bookkeeper: true,  Cashier: false, Viewer: false },
  { cap: 'Approve entries',             Owner: true, Bookkeeper: false, Cashier: false, Viewer: false },
  { cap: 'File VAT with RRA',           Owner: true, Bookkeeper: false, Cashier: false, Viewer: false },
  { cap: 'Close periods & manage team', Owner: true, Bookkeeper: false, Cashier: false, Viewer: false },
];

// ---- period close checklist --------------------------------------------
const CLOSE_TASKS = [
  { id: 'ct1', label: 'All journal entries posted', detail: '2 entries still pending approval', done: false, go: 'journal', icon: 'Receipt' },
  { id: 'ct2', label: 'Bank accounts reconciled', detail: '2 statement lines unmatched', done: false, go: 'bankrec', icon: 'Refresh' },
  { id: 'ct3', label: 'Receivables reviewed', detail: 'Aging confirmed · 2 overdue invoices', done: true, go: 'ar', icon: 'ArrowUpRight' },
  { id: 'ct4', label: 'Payables reviewed', detail: 'All supplier bills entered', done: true, go: 'ap', icon: 'ArrowDown' },
  { id: 'ct5', label: 'VAT return prepared', detail: 'Net payable RWF 640,000 · due 15 Jun', done: true, go: 'tax', icon: 'ShieldCheck' },
  { id: 'ct6', label: 'Depreciation posted', detail: 'JE-1047 awaiting approval', done: false, go: 'journal', icon: 'Stack' },
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
  CUSTOMERS, SUPPLIERS, INVOICES, BILLS, docTotals, DOC_STATUS,
  RECURRING, AUDIT_LOG, TEAM, ROLES, PERMISSIONS, CLOSE_TASKS,
});
