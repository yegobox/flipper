// ===========================================================
//  Flipper Accounting · report & list views
//  (Journal + Composer live in journal.jsx)
// ===========================================================
const { useState: useV, useMemo: useVMemo } = React;

const AGE_BUCKETS = [
  { key: 'current', label: 'Current',    color: '#2563EB' },
  { key: 'd30',     label: '1\u201330 days', color: '#0EA5A4' },
  { key: 'd60',     label: '31\u201360 days', color: '#E89A2A' },
  { key: 'd90',     label: '60+ days',   color: '#DC2626' },
];

function Delta({ v, invert }) {
  if (v == null) return null;
  const up = v >= 0;
  const good = invert ? !up : up;
  return (
    <span className={`acc-kpi-delta ${good ? 'up' : 'down'}`}>
      {up ? <Icons.ArrowUp size={11} /> : <Icons.ArrowDown size={11} />}{Math.abs(v)}%
    </span>
  );
}

// ───────────────────────────── Overview / Dashboard ────────────────────────
function OverviewView({ tweaks, onNewEntry }) {
  const pl = incomeStatement();
  const bs = balanceSheet();
  const cashBank = ACCT['1010'].bal + ACCT['1020'].bal + ACCT['1030'].bal;
  const arAge = ageTotals(AR), apAge = ageTotals(AP);
  const opexSegs = pl.opex.map((a, i) => ({
    label: a.name, value: a.bal,
    color: ['#2563EB', '#0EA5A4', '#7C3AED', '#E89A2A', '#DC2626', '#64748B'][i % 6],
  }));

  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Financial overview</div>
          <h1 className="acc-h1">Books at a glance</h1>
          <div className="acc-sub">Demo Shop Ltd · fiscal period May 2026 · all amounts in RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-ghost"><Icons.Download size={17} />Export</button>
          <button className="acc-btn acc-btn-primary" onClick={onNewEntry}><Icons.Plus size={17} />New journal entry</button>
        </div>
      </div>

      {/* KPIs */}
      <div className="acc-grid cols-4 mb16">
        <div className="acc-card acc-kpi">
          <div className="acc-kpi-top"><span className="acc-kpi-ic green"><Icons.TrendUp size={20} /></span><span className="acc-kpi-lbl">Net income</span></div>
          <div className="acc-kpi-val"><small>RWF</small> {money(pl.netIncome)}</div>
          <div className="acc-kpi-foot"><Delta v={18} /><span className="acc-kpi-note">vs April</span></div>
        </div>
        <div className="acc-card acc-kpi">
          <div className="acc-kpi-top"><span className="acc-kpi-ic blue"><Icons.Wallet size={20} /></span><span className="acc-kpi-lbl">Cash &amp; bank</span></div>
          <div className="acc-kpi-val"><small>RWF</small> {money(cashBank)}</div>
          <div className="acc-kpi-foot"><Delta v={6} /><span className="acc-kpi-note">across 3 accounts</span></div>
        </div>
        <div className="acc-card acc-kpi">
          <div className="acc-kpi-top"><span className="acc-kpi-ic amber"><Icons.ArrowUpRight size={20} /></span><span className="acc-kpi-lbl">Receivable</span></div>
          <div className="acc-kpi-val"><small>RWF</small> {money(arAge.total)}</div>
          <div className="acc-kpi-foot"><span className="acc-kpi-delta down"><Icons.Clock size={11} />{money(arAge.buckets.d90)}</span><span className="acc-kpi-note">overdue 60+</span></div>
        </div>
        <div className="acc-card acc-kpi">
          <div className="acc-kpi-top"><span className="acc-kpi-ic red"><Icons.ArrowDown size={20} /></span><span className="acc-kpi-lbl">Payable</span></div>
          <div className="acc-kpi-val"><small>RWF</small> {money(apAge.total)}</div>
          <div className="acc-kpi-foot"><span className="acc-kpi-note">{AP.length} open bills</span></div>
        </div>
      </div>

      {/* trend + opex donut */}
      <div className="acc-grid split-7-5 mb16">
        <div className="acc-card">
          <div className="acc-card-head">
            <div>
              <div className="acc-card-title">Revenue vs expenses</div>
              <div className="acc-card-sub">Trailing 6 months</div>
            </div>
            <div className="flex gap12">
              <span className="aging-leg"><span className="sw" style={{ background: 'var(--blue)' }} />Revenue</span>
              <span className="aging-leg"><span className="sw" style={{ background: 'var(--ink-4)' }} />Expenses</span>
            </div>
          </div>
          <div style={{ padding: '18px 16px 8px' }}>
            <TrendChart data={TREND} style={tweaks.chartStyle} />
          </div>
        </div>
        <div className="acc-card">
          <div className="acc-card-head"><div className="acc-card-title">Where money went</div><span className="acc-card-link">Operating · May</span></div>
          <div style={{ padding: '18px 20px', display: 'flex', alignItems: 'center', gap: 18 }}>
            <Donut segments={opexSegs} size={148} center={
              <div><div className="num" style={{ fontSize: 18, fontWeight: 700 }}>{compact(pl.totalOpex)}</div><div style={{ fontSize: 10.5, color: 'var(--ink-3)' }}>opex</div></div>
            } />
            <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 9 }}>
              {opexSegs.slice(0, 5).map((s) => (
                <div key={s.label} className="flex gap8" style={{ fontSize: 12.5 }}>
                  <span className="sw" style={{ width: 9, height: 9, borderRadius: 3, background: s.color, flexShrink: 0 }} />
                  <span style={{ color: 'var(--ink-2)', flex: 1, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{s.label}</span>
                  <span className="num" style={{ fontWeight: 600 }}>{compact(s.value)}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* P&L mini + recent entries */}
      <div className="acc-grid split-7-5">
        <div className="acc-card">
          <div className="acc-card-head"><div className="acc-card-title">Recent journal entries</div><span className="acc-card-link">View daybook <Icons.ChevRight size={14} /></span></div>
          <div className="acc-tablewrap">
            <table className="acc-table">
              <thead><tr><th>Entry</th><th>Memo</th><th>Status</th><th className="r">Amount</th></tr></thead>
              <tbody>
                {JOURNAL.slice(0, 5).map((e) => {
                  const t = jeTotals(e);
                  return (
                    <tr key={e.id}>
                      <td><span className="je-id">{e.id}</span><div className="muted" style={{ fontSize: 11.5, marginTop: 2 }}>{e.date}</div></td>
                      <td><div className="je-memo">{e.memo}</div></td>
                      <td><span className={`pill ${e.status}`}><span className="pdot" />{e.status}</span></td>
                      <td className="r num" style={{ fontWeight: 700 }}>{money(t.dr)}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
        <div className="acc-card">
          <div className="acc-card-head"><div className="acc-card-title">Profit &amp; loss</div><span className="acc-card-link">May 2026</span></div>
          <div style={{ padding: '8px 20px 18px' }}>
            <PLRow label="Net revenue" val={pl.netRevenue} />
            <PLRow label="Cost of goods sold" val={-pl.cogs} muted />
            <PLRow label="Gross profit" val={pl.grossProfit} strong />
            <PLRow label="Operating expenses" val={-pl.totalOpex} muted />
            <div style={{ marginTop: 10, padding: '12px 14px', borderRadius: 12, background: 'var(--gain-tint)', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
              <span style={{ fontWeight: 800, color: 'var(--gain-ink)' }}>Net income</span>
              <span className="num" style={{ fontWeight: 800, fontSize: 19, color: 'var(--gain-ink)' }}>{money(pl.netIncome)}</span>
            </div>
            <div style={{ marginTop: 12, fontSize: 12, color: 'var(--ink-3)', display: 'flex', justifyContent: 'space-between' }}>
              <span>Gross margin {(pl.grossMargin * 100).toFixed(1)}%</span>
              <span>Net margin {(pl.netMargin * 100).toFixed(1)}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
function PLRow({ label, val, strong, muted }) {
  return (
    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '8px 0', borderTop: strong ? '1px solid var(--line)' : 'none' }}>
      <span style={{ fontSize: 13.5, fontWeight: strong ? 700 : 500, color: muted ? 'var(--ink-2)' : 'var(--ink-1)' }}>{label}</span>
      <span className="num" style={{ fontSize: 13.5, fontWeight: strong ? 700 : 600, color: muted ? 'var(--ink-2)' : 'var(--ink-1)' }}>{money(val)}</span>
    </div>
  );
}

// ───────────────────────────── Chart of Accounts ───────────────────────────
const TYPE_ORDER = [['asset', 'Assets'], ['liability', 'Liabilities'], ['equity', 'Equity'], ['income', 'Income'], ['expense', 'Expenses']];
function ChartOfAccountsView() {
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Setup</div>
          <h1 className="acc-h1">Chart of accounts</h1>
          <div className="acc-sub">{ACCOUNTS.length} accounts · numbered ledger structure</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-ghost acc-btn-sm"><Icons.Filter size={15} />Filter</button>
          <button className="acc-btn acc-btn-primary acc-btn-sm"><Icons.Plus size={15} />Add account</button>
        </div>
      </div>
      <div className="acc-card">
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th style={{ width: 70 }}>Code</th><th>Account name</th><th>Type</th><th>Category</th><th className="r">Balance (RWF)</th></tr></thead>
            <tbody>
              {TYPE_ORDER.map(([t, lbl]) => {
                const rows = ACCOUNTS.filter((a) => a.type === t);
                const sum = rows.reduce((s, a) => s + (a.contra ? -a.bal : a.bal), 0);
                return (
                  <React.Fragment key={t}>
                    <tr style={{ background: 'var(--surface-2)' }}>
                      <td colSpan={4} style={{ fontWeight: 800, letterSpacing: '.02em' }}>{lbl}</td>
                      <td className="r num" style={{ fontWeight: 800 }}>{money(sum)}</td>
                    </tr>
                    {rows.map((a) => (
                      <tr key={a.code} className="acc-row-click">
                        <td className="code">{a.code}</td>
                        <td><span className="je-memo">{a.name}</span>{a.contra && <span className="tag" style={{ marginLeft: 8 }}>contra</span>}{a.note && <span className="muted" style={{ fontSize: 11.5, marginLeft: 8 }}>{a.note}</span>}</td>
                        <td><span className={`acc-coa-type ${a.type}`}>{a.type}</span></td>
                        <td className="muted">{a.sub}</td>
                        <td className="r num" style={{ fontWeight: 700, color: a.contra ? 'var(--loss-ink)' : 'var(--ink-1)' }}>{a.contra ? `(${money(a.bal)})` : money(a.bal)}</td>
                      </tr>
                    ))}
                  </React.Fragment>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── Statements (P&L / BS / CF) ──────────────────
function StatementsView() {
  const [tab, setTab] = useV('pl');
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Reports</div>
          <h1 className="acc-h1">Financial statements</h1>
          <div className="acc-sub">Generated from the general ledger · May 2026</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-ghost acc-btn-sm"><Icons.Print size={15} />Print</button>
          <button className="acc-btn acc-btn-ghost acc-btn-sm"><Icons.Download size={15} />PDF</button>
        </div>
      </div>
      <div style={{ marginBottom: 16 }}>
        <div className="acc-tabs">
          <button className={`acc-tab ${tab === 'pl' ? 'is-on' : ''}`} onClick={() => setTab('pl')}>Income statement</button>
          <button className={`acc-tab ${tab === 'bs' ? 'is-on' : ''}`} onClick={() => setTab('bs')}>Balance sheet</button>
          <button className={`acc-tab ${tab === 'cf' ? 'is-on' : ''}`} onClick={() => setTab('cf')}>Cash flow</button>
        </div>
      </div>
      <div className="acc-card">
        {tab === 'pl' && <PLStatement />}
        {tab === 'bs' && <BSStatement />}
        {tab === 'cf' && <CFStatement />}
      </div>
    </div>
  );
}

function StmtHead({ title }) {
  return (
    <div className="stmt-meta">
      <div className="stmt-co">Demo Shop Ltd</div>
      <div className="stmt-title">{title}</div>
      <div className="stmt-period">For the period ending 31 May 2026 · RWF</div>
    </div>
  );
}
function SRow({ code, label, val }) {
  return <div className="stmt-row"><span className="code">{code}</span><span className="lbl">{label}</span><span className="val">{money(val)}</span></div>;
}
function SSub({ label, val }) { return <div className="stmt-sub"><span className="lbl">{label}</span><span className="val">{money(val)}</span></div>; }

function PLStatement() {
  const pl = incomeStatement();
  return (
    <div className="acc-stmt">
      <StmtHead title="Income Statement (Profit &amp; Loss)" />
      <div className="stmt-sech">Revenue</div>
      {pl.income.filter((a) => !a.contra).map((a) => <SRow key={a.code} code={a.code} label={a.name} val={a.bal} />)}
      {pl.income.filter((a) => a.contra).map((a) => <SRow key={a.code} code={a.code} label={`Less: ${a.name}`} val={-a.bal} />)}
      <SSub label="Net revenue" val={pl.netRevenue} />
      <div className="stmt-sech">Cost of sales</div>
      <SRow code="5010" label="Cost of goods sold" val={-pl.cogs} />
      <SSub label="Gross profit" val={pl.grossProfit} />
      <div className="stmt-sech">Operating expenses</div>
      {pl.opex.map((a) => <SRow key={a.code} code={a.code} label={a.name} val={-a.bal} />)}
      <SSub label="Total operating expenses" val={-pl.totalOpex} />
      <div className="stmt-total net"><span className="lbl">Net income</span><span className="val">{money(pl.netIncome)}</span></div>
    </div>
  );
}
function BSStatement() {
  const bs = balanceSheet();
  const av = (x) => (x.contra ? -x.bal : x.bal);
  return (
    <div className="acc-stmt">
      <StmtHead title="Balance Sheet (Statement of Financial Position)" />
      <div className="stmt-sech">Assets</div>
      <div style={{ fontSize: 12, fontWeight: 700, color: 'var(--ink-2)', padding: '8px 0 0 14px' }}>Current assets</div>
      {bs.currentAssets.map((a) => <SRow key={a.code} code={a.code} label={a.name} val={a.bal} />)}
      <div style={{ fontSize: 12, fontWeight: 700, color: 'var(--ink-2)', padding: '8px 0 0 14px' }}>Fixed assets</div>
      {bs.fixedAssets.map((a) => <SRow key={a.code} code={a.code} label={a.contra ? `Less: ${a.name}` : a.name} val={av(a)} />)}
      <SSub label="Total assets" val={bs.totalAssets} />
      <div className="stmt-sech">Liabilities</div>
      {bs.curLiab.map((a) => <SRow key={a.code} code={a.code} label={a.name} val={a.bal} />)}
      {bs.ltLiab.map((a) => <SRow key={a.code} code={a.code} label={a.name} val={a.bal} />)}
      <SSub label="Total liabilities" val={bs.totalLiab} />
      <div className="stmt-sech">Equity</div>
      <SRow code="3010" label="Owner's capital" val={bs.capital} />
      <SRow code="3020" label="Retained earnings (opening)" val={bs.retainedOpening} />
      <SRow code="—" label="Net income for period" val={bs.netIncome} />
      <SSub label="Total equity" val={bs.totalEquity} />
      <div className="stmt-total"><span className="lbl">Total liabilities &amp; equity</span><span className="val">{money(bs.totalLiabEquity)}</span></div>
      <div className="stmt-balcheck"><span className="ic"><Icons.Check size={13} /></span>Balanced — assets equal liabilities plus equity</div>
    </div>
  );
}
function CFStatement() {
  const pl = incomeStatement();
  const opsNet = pl.netIncome + 75000 - 420000; // net income + depreciation add-back − working-capital change
  const invNet = -600000;
  const finNet = -430000;
  const net = opsNet + invNet + finNet;
  const rows = [
    { sec: 'Operating activities' },
    { lbl: 'Net income', val: pl.netIncome },
    { lbl: 'Add: depreciation (non-cash)', val: 75000 },
    { lbl: 'Changes in working capital', val: -420000 },
    { sub: 'Net cash from operations', val: opsNet },
    { sec: 'Investing activities' },
    { lbl: 'Purchase of equipment', val: -600000 },
    { sub: 'Net cash from investing', val: invNet },
    { sec: 'Financing activities' },
    { lbl: 'Loan repayment', val: -250000 },
    { lbl: 'Owner drawings', val: -180000 },
    { sub: 'Net cash from financing', val: finNet },
  ];
  return (
    <div className="acc-stmt">
      <StmtHead title="Statement of Cash Flows" />
      {rows.map((r, i) => {
        if (r.sec) return <div key={i} className="stmt-sech">{r.sec}</div>;
        if (r.sub) return <SSub key={i} label={r.sub} val={r.val} />;
        return <div key={i} className="stmt-row"><span className="lbl">{r.lbl}</span><span className="val">{money(r.val)}</span></div>;
      })}
      <div className="stmt-total"><span className="lbl">Net change in cash</span><span className="val">{money(net)}</span></div>
    </div>
  );
}

// ───────────────────────────── Trial Balance ───────────────────────────────
function TrialBalanceView() {
  const tb = trialBalance();
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Reports</div>
          <h1 className="acc-h1">Trial balance</h1>
          <div className="acc-sub">Unadjusted · as at 31 May 2026 · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <span className={`pill ${tb.balanced ? 'posted' : 'pending'}`} style={{ height: 32, fontSize: 13 }}><span className="pdot" />{tb.balanced ? 'In balance' : 'Out of balance'}</span>
          <button className="acc-btn acc-btn-ghost acc-btn-sm"><Icons.Download size={15} />Export</button>
        </div>
      </div>
      <div className="acc-card">
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th style={{ width: 70 }}>Code</th><th>Account</th><th className="r">Debit</th><th className="r">Credit</th></tr></thead>
            <tbody>
              {tb.rows.map((r) => (
                <tr key={r.code}>
                  <td className="code">{r.code}</td>
                  <td className="je-memo">{r.name}</td>
                  <td className="r num">{r.dr ? <span className="dr-amt">{money(r.dr)}</span> : <span className="muted">—</span>}</td>
                  <td className="r num">{r.cr ? <span className="cr-amt">{money(r.cr)}</span> : <span className="muted">—</span>}</td>
                </tr>
              ))}
            </tbody>
            <tfoot className="acc-tfoot">
              <tr>
                <td colSpan={2}>Totals</td>
                <td className="r num" style={{ fontSize: 15 }}>{money(tb.totDr)}</td>
                <td className="r num" style={{ fontSize: 15 }}>{money(tb.totCr)}</td>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── Aging (AR / AP shared) ──────────────────────
function AgingView({ kind }) {
  const isAR = kind === 'ar';
  const rows = isAR ? AR : AP;
  const { buckets, total } = ageTotals(rows);
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">{isAR ? 'Money in' : 'Money out'}</div>
          <h1 className="acc-h1">{isAR ? 'Accounts receivable' : 'Accounts payable'}</h1>
          <div className="acc-sub">{isAR ? 'What customers owe you' : 'What you owe suppliers'} · aged · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-ghost acc-btn-sm"><Icons.Mail size={15} />{isAR ? 'Send reminders' : 'Schedule payment'}</button>
          <button className="acc-btn acc-btn-primary acc-btn-sm"><Icons.Plus size={15} />{isAR ? 'New invoice' : 'New bill'}</button>
        </div>
      </div>

      {/* aging summary */}
      <div className="acc-card mb16">
        <div className="acc-card-head"><div className="acc-card-title">Aging summary</div><span className="num" style={{ fontWeight: 800, fontSize: 17 }}>RWF {money(total)}</span></div>
        <div style={{ padding: '18px 20px' }}>
          <div className="aging-bar" style={{ height: 16, marginBottom: 14 }}>
            {AGE_BUCKETS.map((b) => buckets[b.key] > 0 && (
              <i key={b.key} style={{ width: `${(buckets[b.key] / total) * 100}%`, background: b.color }} title={b.label} />
            ))}
          </div>
          <div className="acc-grid cols-4">
            {AGE_BUCKETS.map((b) => (
              <div key={b.key} style={{ borderLeft: `3px solid ${b.color}`, paddingLeft: 12 }}>
                <div style={{ fontSize: 12, color: 'var(--ink-3)', fontWeight: 600 }}>{b.label}</div>
                <div className="num" style={{ fontSize: 18, fontWeight: 700, marginTop: 4 }}>{money(buckets[b.key])}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="acc-card">
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th>{isAR ? 'Customer' : 'Supplier'}</th><th>Reference</th>{AGE_BUCKETS.map((b) => <th key={b.key} className="r">{b.label}</th>)}<th className="r">Total</th></tr></thead>
            <tbody>
              {rows.map((r) => {
                const tot = AGE_BUCKETS.reduce((s, b) => s + r[b.key], 0);
                return (
                  <tr key={r.inv} className="acc-row-click">
                    <td className="je-memo">{r.name}</td>
                    <td className="code">{r.inv}</td>
                    {AGE_BUCKETS.map((b) => (
                      <td key={b.key} className="r num">{r[b.key] ? <span style={{ color: b.key === 'd90' ? 'var(--loss-ink)' : b.key === 'd60' ? 'var(--warnamber)' : 'var(--ink-1)', fontWeight: 600 }}>{money(r[b.key])}</span> : <span className="muted">—</span>}</td>
                    ))}
                    <td className="r num" style={{ fontWeight: 700 }}>{money(tot)}</td>
                  </tr>
                );
              })}
            </tbody>
            <tfoot className="acc-tfoot">
              <tr><td colSpan={2}>Totals</td>{AGE_BUCKETS.map((b) => <td key={b.key} className="r num">{money(buckets[b.key])}</td>)}<td className="r num" style={{ fontSize: 15 }}>{money(total)}</td></tr>
            </tfoot>
          </table>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── Tax / VAT ───────────────────────────────────
function TaxView() {
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Compliance</div>
          <h1 className="acc-h1">Tax &amp; VAT</h1>
          <div className="acc-sub">VAT at {(VAT.rate * 100).toFixed(0)}% (Rwanda standard) · period May 2026</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-primary acc-btn-sm"><Icons.ShieldCheck size={15} />File with RRA</button>
        </div>
      </div>
      <div className="acc-grid cols-3 mb16">
        <div className="acc-card acc-kpi">
          <div className="acc-kpi-top"><span className="acc-kpi-ic green"><Icons.ArrowUpRight size={20} /></span><span className="acc-kpi-lbl">Output VAT (on sales)</span></div>
          <div className="acc-kpi-val"><small>RWF</small> {money(VAT.outputVat)}</div>
        </div>
        <div className="acc-card acc-kpi">
          <div className="acc-kpi-top"><span className="acc-kpi-ic blue"><Icons.ArrowDown size={20} /></span><span className="acc-kpi-lbl">Input VAT (reclaimable)</span></div>
          <div className="acc-kpi-val"><small>RWF</small> {money(VAT.inputVat)}</div>
        </div>
        <div className="acc-card acc-kpi" style={{ background: 'linear-gradient(120deg,#FFFBF2,#FEF3E2)' }}>
          <div className="acc-kpi-top"><span className="acc-kpi-ic amber"><Icons.Receipt size={20} /></span><span className="acc-kpi-lbl">Net VAT payable</span></div>
          <div className="acc-kpi-val"><small>RWF</small> {money(VAT.netPayable)}</div>
          <div className="acc-kpi-foot"><span className="acc-kpi-note">Due {VAT.dueDate}</span></div>
        </div>
      </div>
      <div className="acc-card">
        <div className="acc-card-head"><div className="acc-card-title">VAT return summary</div><span className="tag">Draft</span></div>
        <div style={{ padding: '6px 24px 18px' }}>
          <div className="stmt-row" style={{ paddingLeft: 0 }}><span className="lbl">Total sales (VAT-inclusive)</span><span className="val">{money(8389000)}</span></div>
          <div className="stmt-row" style={{ paddingLeft: 0 }}><span className="lbl">Output VAT collected</span><span className="val">{money(VAT.outputVat)}</span></div>
          <div className="stmt-row" style={{ paddingLeft: 0 }}><span className="lbl">Input VAT on purchases</span><span className="val">{money(-VAT.inputVat)}</span></div>
          <div className="stmt-total"><span className="lbl">Net VAT due to RRA</span><span className="val">{money(VAT.netPayable)}</span></div>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── General Ledger ──────────────────────────────
function GeneralLedgerView() {
  const [code, setCode] = useV('1020');
  const acct = ACCT[code];
  // build a simple running ledger from JOURNAL lines touching this account
  const entries = [];
  let bal = 0;
  // seed opening so closing matches stored balance
  const lines = [];
  JOURNAL.slice().reverse().forEach((e) => {
    e.lines.forEach((l) => { if (l.ac === code) lines.push({ ...l, e }); });
  });
  const moved = lines.reduce((s, l) => s + (acct.normal === 'D' ? (l.dr || 0) - (l.cr || 0) : (l.cr || 0) - (l.dr || 0)), 0);
  let running = acct.bal - moved; // opening
  const opening = running;
  lines.forEach((l) => {
    const delta = acct.normal === 'D' ? (l.dr || 0) - (l.cr || 0) : (l.cr || 0) - (l.dr || 0);
    running += delta;
    entries.push({ ...l, running });
  });
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Daybook</div>
          <h1 className="acc-h1">General ledger</h1>
          <div className="acc-sub">Posted movements with running balance · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <select className="acc-btn acc-btn-ghost" style={{ paddingRight: 12 }} value={code} onChange={(e) => setCode(e.target.value)}>
            {ACCOUNTS.map((a) => <option key={a.code} value={a.code}>{a.code} · {a.name}</option>)}
          </select>
        </div>
      </div>
      <div className="acc-card">
        <div className="acc-card-head">
          <div><div className="acc-card-title">{acct.code} · {acct.name}</div><div className="acc-card-sub"><span className={`acc-coa-type ${acct.type}`}>{acct.type}</span> · normal {acct.normal === 'D' ? 'debit' : 'credit'}</div></div>
          <div style={{ textAlign: 'right' }}><div style={{ fontSize: 11.5, color: 'var(--ink-3)', fontWeight: 600 }}>CLOSING BALANCE</div><div className="num" style={{ fontSize: 20, fontWeight: 800 }}>{money(acct.bal)}</div></div>
        </div>
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th>Date</th><th>Entry</th><th>Memo</th><th className="r">Debit</th><th className="r">Credit</th><th className="r">Balance</th></tr></thead>
            <tbody>
              <tr><td className="muted">May 1</td><td className="muted">—</td><td className="muted">Opening balance</td><td></td><td></td><td className="r num" style={{ fontWeight: 700 }}>{money(opening)}</td></tr>
              {entries.map((l, i) => (
                <tr key={i}>
                  <td className="muted">{l.e.date}</td>
                  <td><span className="je-id">{l.e.id}</span></td>
                  <td>{l.e.memo}</td>
                  <td className="r num">{l.dr ? <span className="dr-amt">{money(l.dr)}</span> : ''}</td>
                  <td className="r num">{l.cr ? <span className="cr-amt">{money(l.cr)}</span> : ''}</td>
                  <td className="r num" style={{ fontWeight: 700 }}>{money(l.running)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, {
  OverviewView, ChartOfAccountsView, StatementsView, TrialBalanceView,
  AgingView, TaxView, GeneralLedgerView,
});
