// ===========================================================
//  Flipper Accounting · desktop shell (sidebar + topbar + router)
// ===========================================================
const { useState: useApp } = React;

// ─────────────────────────── Bank reconciliation ───────────────────────────
const BANK_SEED = [
  { date: 'May 30', desc: 'POS settlement · counter', amt: 283200, matched: true, je: 'JE-1046' },
  { date: 'May 29', desc: 'Rent payment · landlord', amt: -350000, matched: true, je: 'JE-1045' },
  { date: 'May 27', desc: 'Transfer from Karake Retail', amt: 560000, matched: true, je: 'JE-1043' },
  { date: 'May 26', desc: 'Salary run · staff', amt: -300000, matched: true, je: 'JE-1041' },
  { date: 'May 25', desc: 'Bank charges', amt: -8500, matched: false, je: null },
  { date: 'May 23', desc: 'Marketing · radio spot', amt: -180000, matched: true, je: 'JE-1038' },
  { date: 'May 22', desc: 'MoMo float top-up', amt: -120000, matched: false, je: null },
];
function BankRecView() {
  const [lines, setLines] = useApp(BANK_SEED);
  const [done, setDone] = useApp(false);
  const matched = lines.filter((l) => l.matched).length;
  const unmatched = lines.length - matched;
  const bankBal = 4180000;
  const diff = lines.filter((l) => !l.matched).reduce((s, l) => s + l.amt, 0);

  const matchLine = (i) => {
    setLines((ls) => ls.map((l, j) => (j === i ? { ...l, matched: true, je: 'JE-' + (1048 + j) } : l)));
    toast('Bank line matched', { sub: lines[i].desc, icon: 'Check', tone: 'success' });
  };
  const finish = () => { setDone(true); toast('Reconciliation complete', { sub: `${lines.length} of ${lines.length} lines matched`, icon: 'ShieldCheck', tone: 'success' }); };

  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Daybook</div>
          <h1 className="acc-h1">Bank reconciliation</h1>
          <div className="acc-sub">Bank · Bank of Kigali · statement 31 May 2026 · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-ghost acc-btn-sm" onClick={() => toast('Statement imported', { sub: 'Bank of Kigali · no new lines found', icon: 'Refresh', tone: 'info' })}><Icons.Refresh size={15} />Import statement</button>
          <button className="acc-btn acc-btn-primary acc-btn-sm" disabled={unmatched > 0 || done} style={(unmatched > 0 || done) ? { opacity: .5 } : {}} onClick={finish}><Icons.Check size={15} />{done ? 'Reconciled' : 'Finish reconciliation'}</button>
        </div>
      </div>
      <div className="acc-grid cols-3 mb16">
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic blue"><Icons.Wallet size={20} /></span><span className="acc-kpi-lbl">Statement balance</span></div><div className="acc-kpi-val"><small>RWF</small> {money(bankBal)}</div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic green"><Icons.Check size={20} /></span><span className="acc-kpi-lbl">Matched</span></div><div className="acc-kpi-val">{matched}<small> of {lines.length}</small></div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic amber"><Icons.Warn size={20} /></span><span className="acc-kpi-lbl">Needs attention</span></div><div className="acc-kpi-val">{unmatched}<small> lines · {money(Math.abs(diff))}</small></div></div>
      </div>
      <div className="acc-card">
        <div className="acc-card-head"><div className="acc-card-title">Statement lines</div><div className="acc-card-sub">Match each bank line to a journal entry</div></div>
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th>Date</th><th>Bank description</th><th className="r">Amount</th><th>Matched entry</th><th></th></tr></thead>
            <tbody>
              {lines.map((l, i) => (
                <tr key={i}>
                  <td className="muted">{l.date}</td>
                  <td className="je-memo">{l.desc}</td>
                  <td className="r num" style={{ fontWeight: 700, color: l.amt < 0 ? 'var(--loss-ink)' : 'var(--gain-ink)' }}>{l.amt < 0 ? `(${money(-l.amt)})` : money(l.amt)}</td>
                  <td>{l.matched ? <span className="je-id">{l.je}</span> : <span className="muted">— unmatched —</span>}</td>
                  <td className="r">{l.matched
                    ? <span className="pill posted"><span className="pdot" />Matched</span>
                    : <button className="acc-btn acc-btn-primary acc-btn-sm" style={{ height: 30 }} onClick={() => matchLine(i)}>Match</button>}</td>
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

// Flipper app switcher (9-dot launcher). href → real screens in this project.
const FLIPPER_APPS = [
  { name: 'Point of Sale', icon: 'Cart',         c: '#2563EB', href: 'Flipper POS.html' },
  { name: 'Books',         icon: 'Building',     c: '#4F46E5', current: true },
  { name: 'Dashboard',     icon: 'Home',         c: '#0891B2', href: 'Flipper Dashboard.html' },
  { name: 'Daily Reports', icon: 'Stack',        c: '#0D9488', href: 'Daily Reports.html' },
  { name: 'Income',        icon: 'ArrowUpRight', c: '#16A34A', href: 'Flipper Income Detail.html' },
  { name: 'Commissions',   icon: 'Coins',        c: '#E08600', href: 'Agent Commissions.html' },
  { name: 'Customers',     icon: 'Users',        c: '#7C3AED' },
  { name: 'Inventory',     icon: 'Box',          c: '#0EA5A4' },
  { name: 'Settings',      icon: 'Cog',          c: '#64748B' },
];
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
  const [ledgerCode, setLedgerCode] = useApp('1020');
  const [period, setPeriod] = useApp('May 2026');
  const [entity, setEntity] = useApp(ENTITIES[0]);
  const [bellUnread, setBellUnread] = useApp(true);
  const [jeDetail, setJeDetail] = useApp(null);
  const cur = ALL_ITEMS.find((i) => i.k === view) || ALL_ITEMS[0];

  const openComposer = () => setComposer(true);
  const gotoLedger = (code) => { setLedgerCode(code); setView('ledger'); };
  const openEntry = (e) => setJeDetail(e);

  return (
    <div className={`acc ${tweaks.density === 'compact' ? 'is-dense' : ''}`}>
      {/* sidebar */}
      <aside className="acc-side">
        <div className="acc-brand">
          <FlipperLogo size={30} />
          <span className="wordmark">Flipper</span>
          <span className="acc-brand-sub">Books</span>
        </div>

        {/* entity switcher */}
        <Dropdown align="left" width={230} block
          trigger={({ toggle }) => (
            <div className="acc-entity" onClick={toggle}>
              <div className="acc-entity-mark">{entity.mark}</div>
              <div className="acc-entity-meta">
                <div className="acc-entity-name">{entity.name}</div>
                <div className="acc-entity-fy">{entity.fy}</div>
              </div>
              <span className="chev"><Icons.ChevDown size={16} /></span>
            </div>
          )}>
          {({ close }) => (
            <>
              <MenuLabel>Your businesses</MenuLabel>
              {ENTITIES.map((e) => (
                <MenuItem key={e.id} mark={e.mark} label={e.name} sub={e.fy} active={e.id === entity.id}
                  onClick={() => { setEntity(e); close(); if (e.id !== entity.id) toast('Switched business', { sub: e.name, icon: 'Store', tone: 'info' }); }} />
              ))}
              <MenuSep />
              <MenuItem icon="Plus" label="Add a business" onClick={() => { close(); toast('Add a business', { sub: 'Opening setup wizard…', icon: 'Plus' }); }} />
              <MenuItem icon="Cog" label="Business settings" onClick={() => { close(); toast('Business settings', { sub: entity.name, icon: 'Cog' }); }} />
            </>
          )}
        </Dropdown>

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
          <Dropdown align="left" up width={230} block
            trigger={({ toggle }) => (
              <div className="acc-user" onClick={toggle} style={{ cursor: 'pointer' }}>
                <div className="acc-user-av">DE</div>
                <div className="acc-user-meta">
                  <div className="acc-user-name">Diane E.</div>
                  <div className="acc-user-role">Owner · Bookkeeper</div>
                </div>
                <span style={{ color: '#5C6B86' }}><Icons.Cog size={18} /></span>
              </div>
            )}>
            {({ close }) => (
              <>
                <MenuLabel>Diane Mukamana</MenuLabel>
                <MenuItem icon="User" label="My profile" onClick={() => { close(); toast('My profile', { icon: 'User' }); }} />
                <MenuItem icon="ShieldCheck" label="Roles & permissions" onClick={() => { close(); toast('Roles & permissions', { sub: 'Owner · Bookkeeper', icon: 'ShieldCheck' }); }} />
                <MenuItem icon="Cog" label="Preferences" onClick={() => { close(); toast('Preferences', { icon: 'Cog' }); }} />
                <MenuItem icon="Info" label="Help & support" onClick={() => { close(); toast('Help & support', { sub: 'Opening Flipper docs…', icon: 'Info' }); }} />
                <MenuSep />
                <MenuItem icon="LogOut" label="Sign out" danger onClick={() => { close(); toast('Signed out', { sub: 'See you soon, Diane', icon: 'LogOut', tone: 'info' }); }} />
              </>
            )}
          </Dropdown>
        </div>
      </aside>

      {/* main */}
      <div className="acc-body">
        <header className="acc-top">
          <div className="acc-crumb">{cur.sec}<Icons.ChevRight size={14} /><b>{cur.label}</b></div>
          <div className="acc-top-spacer" />

          <TopSearch onView={setView} onAccount={gotoLedger} onEntry={openEntry} />

          {/* period selector */}
          <Dropdown align="right" width={200}
            trigger={({ toggle }) => (
              <button className="acc-period" onClick={toggle}><span className="cal"><Icons.Calendar size={17} /></span>{period}<span className="chev"><Icons.ChevDown size={15} /></span></button>
            )}>
            {({ close }) => (
              <>
                <MenuLabel>Fiscal period 2026</MenuLabel>
                <div style={{ maxHeight: 260, overflowY: 'auto' }}>
                  {MONTHS.map((m) => <MenuItem key={m} icon="Calendar" label={m} active={m === period} onClick={() => { setPeriod(m); close(); if (m !== period) toast('Period changed', { sub: m, icon: 'Calendar', tone: 'info' }); }} />)}
                </div>
              </>
            )}
          </Dropdown>

          {/* notifications */}
          <Dropdown align="right" width={310}
            trigger={({ toggle }) => (
              <button className="acc-iconbtn" onClick={toggle}><Icons.Bell size={19} />{bellUnread && <span className="dot" />}</button>
            )}>
            {({ close }) => (
              <>
                <div className="flex" style={{ justifyContent: 'space-between', padding: '4px 6px 2px' }}>
                  <MenuLabel>Notifications</MenuLabel>
                  <button className="acc-card-link" style={{ fontSize: 12 }} onClick={() => { setBellUnread(false); toast('All caught up', { sub: 'Notifications marked read', icon: 'Check', tone: 'success' }); }}>Mark all read</button>
                </div>
                {NOTIFS.map((n) => (
                  <MenuItem key={n.id} icon={n.icon} iconTone={n.tone} label={n.title} sub={n.sub}
                    onClick={() => { setBellUnread(false); setView(n.go); close(); }} />
                ))}
              </>
            )}
          </Dropdown>

          {/* app launcher */}
          <Dropdown align="right" width={284}
            trigger={({ toggle, open }) => (
              <button className={`acc-iconbtn ${open ? 'is-on' : ''}`} onClick={toggle} title="Flipper apps"><Icons.Grid size={19} /></button>
            )}>
            {({ close }) => (
              <div className="acc-applaunch">
                <MenuLabel>Flipper apps · {entity.name}</MenuLabel>
                <div className="acc-applaunch-grid">
                  {FLIPPER_APPS.map((a) => {
                    const Ico = Icons[a.icon];
                    const inner = (
                      <>
                        <span className="acc-applaunch-ico" style={{ background: a.c }}><Ico size={22} /></span>
                        <span className="acc-applaunch-lbl">{a.name}</span>
                      </>
                    );
                    return a.href
                      ? <a key={a.name} className="acc-applaunch-item" href={a.href}>{inner}</a>
                      : a.current
                        ? <div key={a.name} className="acc-applaunch-item is-current">{inner}</div>
                        : <button key={a.name} className="acc-applaunch-item" onClick={() => { close(); toast(a.name, { sub: 'Opening ' + a.name + '…', icon: a.icon, tone: 'info' }); }}>{inner}</button>;
                  })}
                </div>
                <div className="acc-applaunch-foot"><Icons.Grid size={13} />Switch between your Flipper apps anytime</div>
              </div>
            )}
          </Dropdown>

          <a className="acc-iconbtn" href="Flipper Accounting Mobile.html" title="Open mobile view"><Icons.Phone size={19} /></a>
        </header>

        <div className="acc-scroll">
          {view === 'dashboard' && <OverviewView tweaks={tweaks} period={period} entity={entity} onNewEntry={openComposer} onView={setView} onLedger={gotoLedger} onEntry={openEntry} />}
          {view === 'journal' && <JournalView onNewEntry={openComposer} onEntry={openEntry} />}
          {view === 'ledger' && <GeneralLedgerView code={ledgerCode} setCode={setLedgerCode} />}
          {view === 'bankrec' && <BankRecView />}
          {view === 'ar' && <AgingView kind="ar" onNewEntry={openComposer} />}
          {view === 'ap' && <AgingView kind="ap" onNewEntry={openComposer} />}
          {view === 'tax' && <TaxView />}
          {view === 'statements' && <StatementsView />}
          {view === 'trial' && <TrialBalanceView />}
          {view === 'coa' && <ChartOfAccountsView onLedger={gotoLedger} />}
        </div>
      </div>

      {composer && <Composer onClose={() => setComposer(false)} />}
      {jeDetail && <JEDetail je={jeDetail} onClose={() => setJeDetail(null)} onEdit={() => { setJeDetail(null); openComposer(); }} />}
      <ToastHost />
    </div>
  );
}

window.AccountingApp = AccountingApp;
