// ===========================================================
//  Flipper Accounting · mobile companion
//  Tabs: Snapshot · Approvals · Reports · More
// ===========================================================
const { useState: useM } = React;

// ───────────────────────────── Snapshot (home) ─────────────────────────────
function Snapshot({ tweaks, go }) {
  const pl = incomeStatement();
  const cashBank = ACCT['1010'].bal + ACCT['1020'].bal + ACCT['1030'].bal;
  const ar = ageTotals(AR).total, ap = ageTotals(AP).total;
  const pending = JOURNAL.filter((e) => e.status === 'pending');
  return (
    <div className="macc-scroll">
      <div className="macc-hero">
        <div className="macc-hero-lbl"><span>Net income · May 2026</span><span className="macc-hero-pill"><Icons.ArrowUp size={11} />18%</span></div>
        <div className="macc-hero-val"><small>RWF</small> {money(pl.netIncome)}</div>
        <div className="macc-hero-foot">
          <div><div className="macc-hero-cell-k">Revenue</div><div className="macc-hero-cell-v">{compact(pl.netRevenue)}</div></div>
          <div><div className="macc-hero-cell-k">Expenses</div><div className="macc-hero-cell-v">{compact(pl.cogs + pl.totalOpex)}</div></div>
          <div><div className="macc-hero-cell-k">Margin</div><div className="macc-hero-cell-v">{(pl.netMargin * 100).toFixed(0)}%</div></div>
        </div>
      </div>

      <div className="macc-kpis">
        <div className="macc-kpi"><div className="macc-kpi-top"><span className="macc-kpi-ic blue"><Icons.Wallet size={17} /></span><span className="macc-kpi-lbl">Cash &amp; bank</span></div><div className="macc-kpi-val"><small>RWF</small> {compact(cashBank)}</div></div>
        <div className="macc-kpi"><div className="macc-kpi-top"><span className="macc-kpi-ic green"><Icons.Stack size={17} /></span><span className="macc-kpi-lbl">Stock value</span></div><div className="macc-kpi-val"><small>RWF</small> {compact(ACCT['1200'].bal)}</div></div>
        <div className="macc-kpi"><div className="macc-kpi-top"><span className="macc-kpi-ic amber"><Icons.ArrowUpRight size={17} /></span><span className="macc-kpi-lbl">Receivable</span></div><div className="macc-kpi-val"><small>RWF</small> {compact(ar)}</div></div>
        <div className="macc-kpi"><div className="macc-kpi-top"><span className="macc-kpi-ic red"><Icons.ArrowDown size={17} /></span><span className="macc-kpi-lbl">Payable</span></div><div className="macc-kpi-val"><small>RWF</small> {compact(ap)}</div></div>
      </div>

      {pending.length > 0 && (
        <button className="macc-approve" style={{ width: '100%', textAlign: 'left' }} onClick={() => go('approvals')}>
          <span className="macc-approve-ic"><Icons.ShieldCheck size={21} /></span>
          <span className="macc-approve-txt">
            <span className="macc-approve-h">{pending.length} entries need approval</span>
            <span className="macc-approve-p">Review &amp; post before month-end close</span>
          </span>
          <span className="macc-approve-go"><Icons.ChevRight size={17} /></span>
        </button>
      )}

      <div className="macc-card">
        <div className="macc-card-head"><span className="macc-card-title">Revenue vs expenses</span><span className="macc-card-link">6 mo</span></div>
        <div style={{ padding: '4px 12px 14px' }}><TrendChart data={TREND} style={tweaks.chartStyle} height={150} /></div>
      </div>

      <div className="macc-card">
        <div className="macc-card-head"><span className="macc-card-title">Recent entries</span><span className="macc-card-link" onClick={() => go('reports')}>Reports</span></div>
        <div>
          {JOURNAL.slice(0, 4).map((e) => {
            const t = jeTotals(e);
            return (
              <div className="macc-act" key={e.id}>
                <span className="macc-act-ic"><Icons.Receipt size={18} /></span>
                <span className="macc-act-mid"><span className="macc-act-memo">{e.memo}</span><span className="macc-act-sub">{e.id} · {e.date}</span></span>
                <span className="macc-act-amt">{money(t.dr)}</span>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── Approvals ───────────────────────────────────
function Approvals() {
  const [done, setDone] = useM({});
  const pending = JOURNAL.filter((e) => e.status === 'pending');
  return (
    <div className="macc-scroll">
      <div className="macc-ptitle">Approvals</div>
      <div className="macc-psub">Pending journal entries — tap approve to post to the ledger.</div>
      {pending.map((e) => {
        const t = jeTotals(e);
        const state = done[e.id];
        return (
          <div className={`macc-je ${state ? 'done' : ''}`} key={e.id}>
            <div className="macc-je-head">
              <div className="macc-je-top"><span className="macc-je-id">{e.id}</span><span className="m-pill pending"><span className="pdot" />pending</span></div>
              <div className="macc-je-memo">{e.memo}</div>
              <div className="macc-je-meta">{e.date} · {e.ref} · via {e.src}</div>
            </div>
            <div className="macc-je-lines">
              {e.lines.map((l, i) => (
                <div className="macc-je-line" key={i}>
                  <span className={`macc-je-side ${l.dr ? 'dr' : 'cr'}`}>{l.dr ? 'Dr' : 'Cr'}</span>
                  <span className="macc-je-acct">{acctName(l.ac)} <span className="code">{l.ac}</span></span>
                  <span className="macc-je-amt" style={{ color: l.dr ? 'var(--dr-ink)' : 'var(--cr-ink)' }}>{money(l.dr || l.cr)}</span>
                </div>
              ))}
            </div>
            <div className="macc-je-bal"><Icons.Check size={14} />Balanced · {money(t.dr)} = {money(t.cr)}</div>
            {state ? (
              <div className="macc-je-doneflag">
                {state === 'approve' ? <><Icons.Check size={16} />Approved &amp; posted</> : <><Icons.X size={16} />Sent back to drafts</>}
              </div>
            ) : (
              <div className="macc-je-actions">
                <button className="macc-je-btn reject" onClick={() => setDone((d) => ({ ...d, [e.id]: 'reject' }))}><Icons.X size={16} />Reject</button>
                <button className="macc-je-btn approve" onClick={() => setDone((d) => ({ ...d, [e.id]: 'approve' }))}><Icons.Check size={17} />Approve</button>
              </div>
            )}
          </div>
        );
      })}
      {pending.length === 0 && <div style={{ textAlign: 'center', color: 'var(--ink-3)', padding: 30 }}>Nothing waiting — you're all caught up.</div>}
    </div>
  );
}

// ───────────────────────────── Reports list + statements ───────────────────
const REPORTS = [
  { k: 'pl', name: 'Income statement', sub: 'Profit & loss · May', icon: 'TrendUp', tone: 'green' },
  { k: 'bs', name: 'Balance sheet', sub: 'Financial position', icon: 'Stack', tone: 'blue' },
  { k: 'tb', name: 'Trial balance', sub: 'In balance', icon: 'Group', tone: 'violet' },
  { k: 'vat', name: 'Tax & VAT', sub: `Net due ${money(VAT.netPayable)}`, icon: 'ShieldCheck', tone: 'amber' },
];
const TONE = { green: ['var(--gain-tint)', 'var(--gain)'], blue: ['var(--blue-tint)', 'var(--blue)'], violet: ['#F1EBFB', 'var(--violet)'], amber: ['var(--warn-tint)', 'var(--warnamber)'] };

function ReportsList({ open }) {
  return (
    <div className="macc-scroll">
      <div className="macc-ptitle">Reports</div>
      <div className="macc-psub">Generated live from the ledger · Demo Shop Ltd</div>
      <div className="macc-card">
        {REPORTS.map((r) => {
          const Ico = Icons[r.icon];
          const [bg, fg] = TONE[r.tone];
          return (
            <button className="macc-rep" style={{ width: '100%', textAlign: 'left' }} key={r.k} onClick={() => open(r.k)}>
              <span className="macc-rep-ic" style={{ background: bg, color: fg }}><Ico size={20} /></span>
              <span className="macc-rep-mid"><span className="macc-rep-name">{r.name}</span><span className="macc-rep-sub">{r.sub}</span></span>
              <span className="macc-rep-chev"><Icons.ChevRight size={18} /></span>
            </button>
          );
        })}
      </div>
    </div>
  );
}

function MSRow({ l, v }) { return <div className="macc-srow"><span className="l">{l}</span><span className="v">{money(v)}</span></div>; }
function MSSub({ l, v }) { return <div className="macc-ssub"><span className="l">{l}</span><span className="v">{money(v)}</span></div>; }

function StatementDetail({ which, back }) {
  const pl = incomeStatement(), bs = balanceSheet();
  const title = { pl: 'Income statement', bs: 'Balance sheet', tb: 'Trial balance', vat: 'Tax & VAT' }[which];
  return (
    <>
      <div className="macc-sub-head">
        <button className="macc-back" onClick={back}><Icons.ChevLeft size={20} /></button>
        <div className="macc-sub-title">{title}</div>
      </div>
      <div className="macc-scroll">
        <div className="macc-stmt-head">
          <div className="macc-stmt-co">Demo Shop Ltd</div>
          <div className="macc-stmt-t">{title}</div>
          <div className="macc-stmt-p">Period ending 31 May 2026 · RWF</div>
        </div>
        {which === 'pl' && (
          <>
            <div className="macc-sech">Revenue</div>
            <MSRow l="Sales revenue" v={ACCT['4010'].bal} />
            <MSRow l="Service income" v={ACCT['4020'].bal} />
            <MSRow l="Less: discounts" v={-ACCT['4090'].bal} />
            <MSSub l="Net revenue" v={pl.netRevenue} />
            <div className="macc-sech">Cost &amp; expenses</div>
            <MSRow l="Cost of goods sold" v={-pl.cogs} />
            <MSRow l="Operating expenses" v={-pl.totalOpex} />
            <MSSub l="Gross profit" v={pl.grossProfit} />
            <div className="macc-stotal"><span className="l">Net income</span><span className="v">{money(pl.netIncome)}</span></div>
          </>
        )}
        {which === 'bs' && (
          <>
            <div className="macc-sech">Assets</div>
            <MSRow l="Cash, bank &amp; MoMo" v={ACCT['1010'].bal + ACCT['1020'].bal + ACCT['1030'].bal} />
            <MSRow l="Accounts receivable" v={ACCT['1100'].bal} />
            <MSRow l="Inventory" v={ACCT['1200'].bal} />
            <MSRow l="Equipment (net)" v={ACCT['1500'].bal - ACCT['1510'].bal} />
            <MSSub l="Total assets" v={bs.totalAssets} />
            <div className="macc-sech">Liabilities</div>
            <MSRow l="Payables &amp; VAT" v={ACCT['2010'].bal + ACCT['2100'].bal + ACCT['2300'].bal} />
            <MSRow l="Bank loan" v={ACCT['2200'].bal} />
            <MSSub l="Total liabilities" v={bs.totalLiab} />
            <div className="macc-sech">Equity</div>
            <MSRow l="Owner's capital" v={bs.capital} />
            <MSRow l="Retained earnings" v={bs.retainedClosing} />
            <MSSub l="Total equity" v={bs.totalEquity} />
            <div className="macc-stotal" style={{ background: 'var(--blue-tint)' }}><span className="l" style={{ color: 'var(--blue)' }}>Liabilities + equity</span><span className="v" style={{ color: 'var(--blue)' }}>{money(bs.totalLiabEquity)}</span></div>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 7, marginTop: 14, fontSize: 12.5, fontWeight: 700, color: 'var(--gain-ink)' }}><Icons.Check size={14} />Balanced with total assets</div>
          </>
        )}
        {which === 'tb' && (
          <>
            <div className="macc-sech">All accounts</div>
            {trialBalance().rows.map((r) => (
              <div className="macc-srow" key={r.code}>
                <span className="l"><span style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--ink-4)', marginRight: 7 }}>{r.code}</span>{r.name}</span>
                <span className="v" style={{ color: r.dr ? 'var(--dr-ink)' : 'var(--cr-ink)' }}>{r.dr ? money(r.dr) : money(r.cr)}</span>
              </div>
            ))}
            <div className="macc-stotal" style={{ background: 'var(--surface-2)' }}><span className="l" style={{ color: 'var(--ink-1)' }}>Debits = Credits</span><span className="v" style={{ color: 'var(--ink-1)' }}>{money(trialBalance().totDr)}</span></div>
          </>
        )}
        {which === 'vat' && (
          <>
            <div className="macc-sech">VAT return · 18%</div>
            <MSRow l="Output VAT (sales)" v={VAT.outputVat} />
            <MSRow l="Input VAT (purchases)" v={-VAT.inputVat} />
            <div className="macc-stotal" style={{ background: 'var(--warn-tint)' }}><span className="l" style={{ color: 'var(--warnamber)' }}>Net VAT due</span><span className="v" style={{ color: 'var(--warnamber)' }}>{money(VAT.netPayable)}</span></div>
            <div style={{ textAlign: 'center', fontSize: 12.5, color: 'var(--ink-3)', marginTop: 12 }}>Due to RRA by {VAT.dueDate}</div>
          </>
        )}
      </div>
    </>
  );
}

// ───────────────────────────── More ────────────────────────────────────────
const MORE = [
  { name: 'Journal entries', icon: 'Receipt', c: '#2563EB' },
  { name: 'General ledger', icon: 'Stack', c: '#0D9488' },
  { name: 'Chart of accounts', icon: 'Building', c: '#4F46E5' },
  { name: 'Bank reconciliation', icon: 'Refresh', c: '#0891B2' },
  { name: 'Receivables', icon: 'ArrowUpRight', c: '#E89A2A' },
  { name: 'Payables', icon: 'ArrowDown', c: '#DC2626' },
];
function More() {
  return (
    <div className="macc-scroll">
      <div className="macc-ptitle">All accounting</div>
      <div className="macc-psub">The full workbench lives on desktop — view &amp; approve here.</div>
      <div className="macc-card">
        {MORE.map((m) => {
          const Ico = Icons[m.icon];
          return (
            <div className="macc-rep" key={m.name}>
              <span className="macc-rep-ic" style={{ background: `color-mix(in srgb, ${m.c} 13%, white)`, color: m.c }}><Ico size={20} /></span>
              <span className="macc-rep-mid"><span className="macc-rep-name">{m.name}</span></span>
              <span className="macc-rep-chev"><Icons.ChevRight size={18} /></span>
            </div>
          );
        })}
      </div>
      <a href="Flipper Accounting.html" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, height: 52, borderRadius: 14, background: 'var(--ink-1)', color: '#fff', fontWeight: 700, fontSize: 14.5, textDecoration: 'none' }}>
        <Icons.Monitor size={18} />Open desktop workspace
      </a>
    </div>
  );
}

// ───────────────────────────── App shell ───────────────────────────────────
function MAccountingApp({ tweaks }) {
  const [tab, setTab] = useM('home');
  const [report, setReport] = useM(null);
  const pending = JOURNAL.filter((e) => e.status === 'pending').length;
  const TABS = [
    { k: 'home', label: 'Snapshot', icon: 'Home' },
    { k: 'approvals', label: 'Approvals', icon: 'ShieldCheck', badge: pending },
    { k: 'reports', label: 'Reports', icon: 'Chart' },
    { k: 'more', label: 'More', icon: 'Grid' },
  ];
  const showSub = tab === 'reports' && report;
  return (
    <div className="macc">
      {!showSub && (
        <div className="macc-head">
          <div className="macc-brand"><FlipperLogo size={28} /><span className="wordmark">Flipper</span><span className="macc-brand-sub">Books</span></div>
          <div className="macc-head-r">
            <button className="macc-bell"><Icons.Bell size={18} />{pending > 0 && <span className="dot" />}</button>
            <div className="macc-av">DE</div>
          </div>
        </div>
      )}
      {!showSub && tab === 'home' && (
        <div className="macc-entity"><span className="macc-entity-mark">DS</span><div><div className="macc-entity-name">Demo Shop Ltd</div><div className="macc-entity-fy">FY 2026 · RWF</div></div><span className="chev"><Icons.ChevDown size={16} /></span></div>
      )}

      {tab === 'home' && <Snapshot tweaks={tweaks} go={(t) => { setTab(t); setReport(null); }} />}
      {tab === 'approvals' && <Approvals />}
      {tab === 'reports' && !report && <ReportsList open={setReport} />}
      {tab === 'reports' && report && <StatementDetail which={report} back={() => setReport(null)} />}
      {tab === 'more' && <More />}

      <nav className="macc-tabbar">
        {TABS.map((t) => {
          const Ico = Icons[t.icon];
          return (
            <button key={t.k} className={`macc-tabbtn ${tab === t.k ? 'is-on' : ''}`} onClick={() => { setTab(t.k); setReport(null); }}>
              <Ico size={21} />{t.badge > 0 && <span className="badge">{t.badge}</span>}<span className="macc-tabbtn-lbl">{t.label}</span>
            </button>
          );
        })}
      </nav>
    </div>
  );
}

window.MAccountingApp = MAccountingApp;
