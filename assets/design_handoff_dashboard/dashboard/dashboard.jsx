const { useState: useDb, useMemo: useDbMemo } = React;

// ---- data per period ----
const PERIODS = [
  ['today', 'Today'], ['week', 'This Week'], ['month', 'This Month'], ['year', 'This Year'],
];
const DATA = {
  today: { txns: 0,    revenue: 0,         cogs: 0,         tax: 0,        deltaNet: null, deltaRev: null, deltaExp: null },
  week:  { txns: 142,  revenue: 1840000,   cogs: 1104000,   tax: 210000,   deltaNet: 14,   deltaRev: 9,    deltaExp: 4 },
  month: { txns: 612,  revenue: 7240000,   cogs: 4200000,   tax: 760000,   deltaNet: 18,   deltaRev: 12,   deltaExp: 6 },
  year:  { txns: 7280, revenue: 86500000,  cogs: 52300000,  tax: 9800000,  deltaNet: 23,   deltaRev: 19,   deltaExp: 11 },
};

function derive(d) {
  const gross = d.revenue - d.cogs;       // gross profit
  const expenses = d.cogs + d.tax;        // total expenses (cogs + tax/expenses)
  const net = d.revenue - expenses;       // net profit
  return { ...d, gross, expenses, net, taxExp: d.tax };
}

function money(n, { compact = true } = {}) {
  if (n == null) return '—';
  const abs = Math.abs(n);
  if (compact && abs >= 1e9) return (n / 1e9).toFixed(1) + 'B';
  if (compact && abs >= 1e6) return (n / 1e6).toFixed(2) + 'M';
  if (compact && abs >= 1e4) return Math.round(n / 1e3) + 'K';
  return n.toLocaleString('en-US');
}

// ---- semicircle gauge ----
function Gauge({ pct, empty }) {
  const p = Math.max(0, Math.min(1, pct || 0));
  return (
    <svg viewBox="0 0 280 168" width="100%" style={{ display: 'block', overflow: 'visible' }}>
      <defs>
        <linearGradient id="gaugeGrad" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0" stopColor="#10B981" />
          <stop offset="0.6" stopColor="#22D3EE" />
          <stop offset="1" stopColor="#2563EB" />
        </linearGradient>
      </defs>
      {/* track */}
      <path d="M 28 148 A 112 112 0 0 1 252 148" fill="none" stroke="var(--line)" strokeWidth="18" strokeLinecap="round" pathLength="100" />
      {/* fill */}
      {!empty && (
        <path d="M 28 148 A 112 112 0 0 1 252 148" fill="none" stroke="url(#gaugeGrad)" strokeWidth="18"
          strokeLinecap="round" pathLength="100" strokeDasharray="100"
          strokeDashoffset={100 - p * 100}
          style={{ transition: 'stroke-dashoffset .7s cubic-bezier(.22,.9,.3,1)' }} />
      )}
      {/* endpoint markers */}
      <circle cx="28" cy="148" r="4" fill={empty ? 'var(--ink-4)' : '#10B981'} />
      <circle cx="252" cy="148" r="4" fill="var(--loss)" opacity={empty ? '.4' : '.85'} />
    </svg>
  );
}

// ---- all-apps launcher ----
const APP_GROUPS = [
  { label: 'Sell', apps: [
    { icon: 'Cart',    name: 'Quick Sell',  c: '#2563EB' },
    { icon: 'Receipt', name: 'Invoices',    c: '#7C3AED' },
    { icon: 'Tag',     name: 'Pricing',     c: '#E5484D' },
    { icon: 'Wallet',  name: 'Payments',    c: '#0891B2' },
  ] },
  { label: 'Manage', apps: [
    { icon: 'Box',     name: 'Inventory',   c: '#10B981', badge: '3' },
    { icon: 'Truck',   name: 'Purchases',   c: '#F59E0B' },
    { icon: 'Users',   name: 'Customers',   c: '#0D9488' },
    { icon: 'Store',   name: 'Suppliers',   c: '#4F46E5' },
  ] },
  { label: 'Insights', apps: [
    { icon: 'Chart',   name: 'Reports',     c: '#2563EB' },
    { icon: 'Stack',   name: 'Daily Reports', c: '#0D9488' },
    { icon: 'Coins',   name: 'Commissions', c: '#F59E0B' },
    { icon: 'Receipt', name: 'Tax & VAT',   c: '#7C3AED' },
  ] },
  { label: 'Business', apps: [
    { icon: 'Users',   name: 'Team',        c: '#10B981' },
    { icon: 'Building',name: 'Branches',    c: '#4F46E5' },
    { icon: 'Bell',    name: 'Activity',    c: '#E5484D' },
    { icon: 'Cog',     name: 'Settings',    c: '#64748B' },
  ] },
];

function AppsSheet({ business, onClose }) {
  return (
    <>
      <div className="db-sheet-scrim" onClick={onClose} />
      <div className="db-sheet">
        <div className="db-sheet-handle" />
        <div className="db-sheet-head">
          <div>
            <div className="db-sheet-title">All apps</div>
            <div className="db-sheet-sub">Everything in {business}</div>
          </div>
          <button className="db-sheet-close" onClick={onClose}><Icons.X size={17} /></button>
        </div>
        <div className="db-sheet-body">
          {APP_GROUPS.map((g) => (
            <div key={g.label}>
              <div className="db-appsec-h">{g.label}</div>
              <div className="db-appgrid">
                {g.apps.map((a) => {
                  const Ico = Icons[a.icon];
                  return (
                    <button key={a.name} className="db-app" onClick={onClose}>
                      <span className="db-app-ico" style={{ background: `color-mix(in srgb, ${a.c} 13%, white)`, color: a.c }}>
                        <Ico size={24} />
                        {a.badge && <span className="db-app-badge">{a.badge}</span>}
                      </span>
                      <span className="db-app-lbl">{a.name}</span>
                    </button>
                  );
                })}
              </div>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}

function DashHeader({ intensity, onAvatar }) {
  return (
    <div className="db-head">
      <div className="db-brand">
        <FlipperLogo size={30} />
        <span className="wordmark">Flipper</span>
      </div>
      <div className="db-head-right">
        {intensity !== 'subtle' && (
          <span className="db-streak"><span className="fl"><Icons.Flame size={15} /></span>12</span>
        )}
        <button className="db-avatar" onClick={onAvatar}>DE</button>
      </div>
    </div>
  );
}

function Dashboard({ tweaks }) {
  const [period, setPeriod] = useDb('month');
  const [metric, setMetric] = useDb('net'); // net | gross
  const [tab, setTab] = useDb('home');
  const [appsOpen, setAppsOpen] = useDb(false);
  const intensity = tweaks.intensity;

  const d = useDbMemo(() => derive(DATA[period]), [period]);
  const empty = d.txns === 0;

  const value = metric === 'net' ? d.net : d.gross;
  const denom = d.revenue || 1;
  const pct = metric === 'net' ? d.net / denom : d.gross / denom;
  const periodLabel = PERIODS.find((p) => p[0] === period)[1];
  const delta = d.deltaNet;

  return (
    <div className="db">
      <DashHeader intensity={intensity} />

      <div className="db-selectors">
        <div className="db-periods">
          {PERIODS.map(([k, lab]) => (
            <button key={k} className={`db-period ${period === k ? 'is-on' : ''}`} onClick={() => setPeriod(k)}>{lab}</button>
          ))}
        </div>
        <div className="db-metrics">
          <button className={`db-metric ${metric === 'net' ? 'is-on' : ''}`} onClick={() => setMetric('net')}>Net Profit</button>
          <button className={`db-metric ${metric === 'gross' ? 'is-on' : ''}`} onClick={() => setMetric('gross')}>Gross Profit</button>
        </div>
      </div>

      <div className="db-scroll">
        {/* gauge */}
        <div className="db-gauge-card">
          <div className="db-gauge-top">
            <div className="db-gauge-wrap">
              <Gauge pct={pct} empty={empty} />
              <div className="db-gauge-center">
                <span className="db-gauge-cur">RWF</span>
                <span className="db-gauge-val">{empty ? '0' : money(value)}</span>
                {empty ? (
                  <span className="db-gauge-delta flat">No transactions yet</span>
                ) : (
                  <span className="db-gauge-delta up"><Icons.ArrowUp size={12} />{delta}% vs last month</span>
                )}
              </div>
            </div>
            <span className="db-gauge-label">{metric === 'net' ? 'Net' : 'Gross'} profit · {periodLabel}</span>
          </div>
          <div className="db-split">
            <div className="db-split-cell">
              <span className="db-split-lbl"><span className="db-split-dot" style={{ background: 'var(--gain)' }} />Gross profit</span>
              <span className="db-split-val" style={{ color: empty ? 'var(--ink-4)' : 'var(--gain-ink)' }}>{empty ? '0' : money(d.gross)}</span>
            </div>
            <div className="db-split-cell">
              <span className="db-split-lbl"><span className="db-split-dot" style={{ background: 'var(--loss)' }} />Tax &amp; expenses</span>
              <span className="db-split-val" style={{ color: empty ? 'var(--ink-4)' : 'var(--loss-ink)' }}>{empty ? '0' : money(d.taxExp)}</span>
            </div>
          </div>
        </div>

        {/* stock */}
        <div className="db-stock">
          <div className="db-stock-top">
            <div className="db-stock-l">
              <span className="db-stock-ico"><Icons.Stack size={20} /></span>
              <span className="db-stock-name">Stock value</span>
            </div>
            <span className="db-stock-val"><small>RWF</small> 3.9B</span>
          </div>
          <div className="db-stock-bar"><i style={{ width: '64%' }} /></div>
          <div className="db-stock-foot">
            <span className={`db-stock-warn ${empty ? '' : 'has'}`}>
              <span className="ic"><Icons.Warn size={16} /></span>
              {empty ? '0 items low on stock' : '3 items low on stock'}
            </span>
            <button className="db-link">Full report <Icons.ChevRight size={15} /></button>
          </div>
        </div>

        {/* revenue / expenses */}
        <div className="db-grid2">
          <div className="db-stat">
            <span className="db-stat-ico gain"><Icons.ArrowUp size={20} /></span>
            <div className="db-stat-lbl">Revenue</div>
            <div className="db-stat-val"><small>RWF</small> {empty ? '0' : money(d.revenue)}</div>
            {!empty && <div className="db-stat-delta up"><Icons.TrendUp size={12} />{d.deltaRev}% up</div>}
          </div>
          <div className="db-stat">
            <span className="db-stat-ico loss"><Icons.ArrowDown size={20} /></span>
            <div className="db-stat-lbl">Expenses</div>
            <div className="db-stat-val"><small>RWF</small> {empty ? '0' : money(d.expenses)}</div>
            {!empty && <div className="db-stat-delta down"><Icons.ArrowUp size={12} />{d.deltaExp}% up</div>}
          </div>
        </div>

        {/* daily goal (gamified) */}
        {intensity !== 'subtle' && (
          <div className="db-goal">
            <span className="db-goal-ico"><Icons.Gift size={20} /></span>
            <div className="db-goal-txt">
              <div className="db-goal-h">Today’s goal · {empty ? '0' : '8'} of 10 sales</div>
              <div className="db-goal-p">{empty ? 'Log your first sale to start earning' : 'Just 2 more to'} <b>+50 pts</b></div>
              <div className="db-goal-track"><i style={{ width: empty ? '4%' : '80%' }} /></div>
            </div>
          </div>
        )}
      </div>

      {/* bottom nav */}
      <nav className="db-tabs">
        <button className={`db-tab ${tab === 'home' ? 'is-on' : ''}`} onClick={() => setTab('home')}><Icons.Home size={22} /><span className="db-tab-lbl">Home</span></button>
        <button className={`db-tab ${tab === 'sales' ? 'is-on' : ''}`} onClick={() => setTab('sales')}><Icons.Cart size={22} /><span className="db-tab-lbl">Sales</span></button>
        <div className="db-fab-wrap">
          <button className="db-fab"><Icons.Plus size={26} /></button>
          <span className="db-fab-lbl">New sale</span>
        </div>
        <button className={`db-tab ${tab === 'stock' ? 'is-on' : ''}`} onClick={() => setTab('stock')}><Icons.Box size={22} /><span className="db-tab-lbl">Inventory</span></button>
        <button className={`db-tab ${appsOpen ? 'is-on' : ''}`} onClick={() => setAppsOpen(true)}><Icons.Grid size={22} /><span className="db-tab-lbl">More</span></button>
      </nav>

      {appsOpen && <AppsSheet business="Demo Shop" onClose={() => setAppsOpen(false)} />}
    </div>
  );
}

window.DashboardApp = Dashboard;
