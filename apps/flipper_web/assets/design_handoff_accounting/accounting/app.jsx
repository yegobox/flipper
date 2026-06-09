// ===========================================================
//  Flipper Accounting · desktop shell (sidebar + topbar + router)
// ===========================================================
const { useState: useApp } = React;

// ─────────────────────────── Bank reconciliation ───────────────────────────
const BANK_LINES = [
  { date: 'May 30', desc: 'POS settlement · counter', amt: 283200, matched: true, je: 'JE-1046' },
  { date: 'May 29', desc: 'Rent payment · landlord', amt: -350000, matched: true, je: 'JE-1045' },
  { date: 'May 27', desc: 'Transfer from Karake Retail', amt: 560000, matched: true, je: 'JE-1043' },
  { date: 'May 26', desc: 'Salary run · staff', amt: -300000, matched: true, je: 'JE-1041' },
  { date: 'May 25', desc: 'Bank charges', amt: -8500, matched: false, je: null },
  { date: 'May 23', desc: 'Marketing · radio spot', amt: -180000, matched: true, je: 'JE-1038' },
  { date: 'May 22', desc: 'MoMo float top-up', amt: -120000, matched: false, je: null },
];
function BankRecView() {
  const matched = BANK_LINES.filter((l) => l.matched).length;
  const unmatched = BANK_LINES.length - matched;
  const bankBal = 4180000;
  const diff = BANK_LINES.filter((l) => !l.matched).reduce((s, l) => s + l.amt, 0);
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Daybook</div>
          <h1 className="acc-h1">Bank reconciliation</h1>
          <div className="acc-sub">Bank · Bank of Kigali · statement 31 May 2026 · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-ghost acc-btn-sm"><Icons.Refresh size={15} />Import statement</button>
          <button className="acc-btn acc-btn-primary acc-btn-sm" disabled={unmatched > 0} style={unmatched > 0 ? { opacity: .5 } : {}}><Icons.Check size={15} />Finish reconciliation</button>
        </div>
      </div>
      <div className="acc-grid cols-3 mb16">
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic blue"><Icons.Wallet size={20} /></span><span className="acc-kpi-lbl">Statement balance</span></div><div className="acc-kpi-val"><small>RWF</small> {money(bankBal)}</div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic green"><Icons.Check size={20} /></span><span className="acc-kpi-lbl">Matched</span></div><div className="acc-kpi-val">{matched}<small> of {BANK_LINES.length}</small></div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic amber"><Icons.Warn size={20} /></span><span className="acc-kpi-lbl">Needs attention</span></div><div className="acc-kpi-val">{unmatched}<small> lines · {money(Math.abs(diff))}</small></div></div>
      </div>
      <div className="acc-card">
        <div className="acc-card-head"><div className="acc-card-title">Statement lines</div><div className="acc-card-sub">Match each bank line to a journal entry</div></div>
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th>Date</th><th>Bank description</th><th className="r">Amount</th><th>Matched entry</th><th></th></tr></thead>
            <tbody>
              {BANK_LINES.map((l, i) => (
                <tr key={i} className="acc-row-click">
                  <td className="muted">{l.date}</td>
                  <td className="je-memo">{l.desc}</td>
                  <td className="r num" style={{ fontWeight: 700, color: l.amt < 0 ? 'var(--loss-ink)' : 'var(--gain-ink)' }}>{l.amt < 0 ? `(${money(-l.amt)})` : money(l.amt)}</td>
                  <td>{l.matched ? <span className="je-id">{l.je}</span> : <span className="muted">— unmatched —</span>}</td>
                  <td className="r">{l.matched
                    ? <span className="pill posted"><span className="pdot" />Matched</span>
                    : <button className="acc-btn acc-btn-primary acc-btn-sm" style={{ height: 30 }}>Match</button>}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────── nav config ────────────────────────────────────
const PENDING = JOURNAL.filter((e) => e.status === 'pending').length;
const NAV = [
  { sec: 'Overview', items: [{ k: 'dashboard', label: 'Dashboard', icon: 'Home' }] },
  { sec: 'Daybook', items: [
      { k: 'journal', label: 'Journal entries', icon: 'Receipt', badge: PENDING },
      { k: 'ledger', label: 'General ledger', icon: 'Stack' },
      { k: 'bankrec', label: 'Bank reconciliation', icon: 'Refresh' },
  ] },
  { sec: 'Money', items: [
      { k: 'ar', label: 'Receivables', icon: 'ArrowUpRight' },
      { k: 'ap', label: 'Payables', icon: 'ArrowDown' },
      { k: 'tax', label: 'Tax & VAT', icon: 'ShieldCheck' },
  ] },
  { sec: 'Reports', items: [
      { k: 'statements', label: 'Financial statements', icon: 'Chart' },
      { k: 'trial', label: 'Trial balance', icon: 'Group' },
  ] },
  { sec: 'Setup', items: [{ k: 'coa', label: 'Chart of accounts', icon: 'Building' }] },
];
const ALL_ITEMS = NAV.flatMap((g) => g.items.map((it) => ({ ...it, sec: g.sec })));

function AccountingApp({ tweaks }) {
  const [view, setView] = useApp('dashboard');
  const [composer, setComposer] = useApp(false);
  const cur = ALL_ITEMS.find((i) => i.k === view) || ALL_ITEMS[0];
  const openComposer = () => setComposer(true);

  return (
    <div className={`acc ${tweaks.density === 'compact' ? 'is-dense' : ''}`}>
      {/* sidebar */}
      <aside className="acc-side">
        <div className="acc-brand">
          <FlipperLogo size={30} />
          <span className="wordmark">Flipper</span>
          <span className="acc-brand-sub">Books</span>
        </div>
        <div className="acc-entity">
          <div className="acc-entity-mark">DS</div>
          <div className="acc-entity-meta">
            <div className="acc-entity-name">Demo Shop Ltd</div>
            <div className="acc-entity-fy">FY 2026 · RWF</div>
          </div>
          <span className="chev"><Icons.ChevDown size={16} /></span>
        </div>
        <nav className="acc-nav">
          {NAV.map((g) => (
            <div key={g.sec}>
              <div className="acc-nav-sec">{g.sec}</div>
              {g.items.map((it) => {
                const Ico = Icons[it.icon];
                return (
                  <button key={it.k} className={`acc-navitem ${view === it.k ? 'is-on' : ''}`} onClick={() => setView(it.k)}>
                    <span className="ic"><Ico size={19} /></span>{it.label}
                    {it.badge > 0 && <span className="acc-navitem-badge">{it.badge}</span>}
                  </button>
                );
              })}
            </div>
          ))}
        </nav>
        <div className="acc-side-foot">
          <div className="acc-user">
            <div className="acc-user-av">DE</div>
            <div className="acc-user-meta">
              <div className="acc-user-name">Diane E.</div>
              <div className="acc-user-role">Owner · Bookkeeper</div>
            </div>
            <span style={{ color: '#5C6B86' }}><Icons.Cog size={18} /></span>
          </div>
        </div>
      </aside>

      {/* main */}
      <div className="acc-body">
        <header className="acc-top">
          <div className="acc-crumb">{cur.sec}<Icons.ChevRight size={14} /><b>{cur.label}</b></div>
          <div className="acc-top-spacer" />
          <div className="acc-search">
            <Icons.Search size={17} />
            <input placeholder="Search entries, accounts, invoices…" />
            <kbd>⌘K</kbd>
          </div>
          <button className="acc-period"><span className="cal"><Icons.Calendar size={17} /></span>May 2026<span className="chev"><Icons.ChevDown size={15} /></span></button>
          <button className="acc-iconbtn"><Icons.Bell size={19} /><span className="dot" /></button>
          <a className="acc-iconbtn" href="Flipper Accounting Mobile.html" title="Open mobile view"><Icons.Phone size={19} /></a>
        </header>

        <div className="acc-scroll">
          {view === 'dashboard' && <OverviewView tweaks={tweaks} onNewEntry={openComposer} />}
          {view === 'journal' && <JournalView onNewEntry={openComposer} />}
          {view === 'ledger' && <GeneralLedgerView />}
          {view === 'bankrec' && <BankRecView />}
          {view === 'ar' && <AgingView kind="ar" />}
          {view === 'ap' && <AgingView kind="ap" />}
          {view === 'tax' && <TaxView />}
          {view === 'statements' && <StatementsView />}
          {view === 'trial' && <TrialBalanceView />}
          {view === 'coa' && <ChartOfAccountsView />}
        </div>
      </div>

      {composer && <Composer onClose={() => setComposer(false)} />}
    </div>
  );
}

window.AccountingApp = AccountingApp;
