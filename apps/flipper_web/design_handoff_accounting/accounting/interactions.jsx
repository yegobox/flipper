// ===========================================================
//  Flipper Accounting · interaction layer
//  Dropdown menus, toast notifications, a working search palette,
//  and the journal-entry detail modal. Everything renders INSIDE
//  the scaled .acc canvas, so overlays track transform: scale().
//
//  Shared globally via Object.assign(window, …) at the bottom.
// ===========================================================
const { useState: useIx, useEffect: useIxEff, useRef: useIxRef } = React;

/* ──────────────────────────── toast bus ──────────────────────────── */
const _toastSubs = new Set();
function toast(title, opts) {
  opts = opts || {};
  _toastSubs.forEach((fn) => fn({ title, ...opts }));
}
function ToastHost() {
  const [items, setItems] = useIx([]);
  useIxEff(() => {
    const fn = (t) => {
      const id = Math.random().toString(36).slice(2);
      setItems((xs) => [...xs, { id, ...t }]);
      const ttl = t.duration || 3400;
      setTimeout(() => setItems((xs) => xs.map((i) => (i.id === id ? { ...i, out: true } : i))), ttl);
      setTimeout(() => setItems((xs) => xs.filter((i) => i.id !== id)), ttl + 240);
    };
    _toastSubs.add(fn);
    return () => _toastSubs.delete(fn);
  }, []);
  return (
    <div className="acc-toasts">
      {items.map((t) => {
        const Ico = Icons[t.icon] || Icons.Check;
        return (
          <div key={t.id} className={`acc-toast ${t.tone || ''} ${t.out ? 'out' : ''}`}>
            <span className="acc-toast-ic"><Ico size={18} /></span>
            <div className="acc-toast-tx">
              <div className="acc-toast-title">{t.title}</div>
              {t.sub && <div className="acc-toast-sub">{t.sub}</div>}
            </div>
            <button className="acc-toast-x" onClick={() => setItems((xs) => xs.filter((i) => i.id !== t.id))}><Icons.X size={15} /></button>
          </div>
        );
      })}
    </div>
  );
}

/* ──────────────────────────── dropdown ──────────────────────────── */
function Dropdown({ trigger, children, align = 'right', up = false, width, panelClass = '', block = false }) {
  const [open, setOpen] = useIx(false);
  const ref = useIxRef(null);
  useIxEff(() => {
    if (!open) return;
    const onDown = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    const onKey = (e) => { if (e.key === 'Escape') setOpen(false); };
    document.addEventListener('mousedown', onDown);
    document.addEventListener('keydown', onKey);
    return () => { document.removeEventListener('mousedown', onDown); document.removeEventListener('keydown', onKey); };
  }, [open]);
  const close = () => setOpen(false);
  return (
    <div className={`acc-dd ${block ? 'block' : ''}`} ref={ref}>
      {trigger({ open, toggle: () => setOpen((o) => !o), close })}
      {open && (
        <div className={`acc-menu ${align === 'right' ? 'al-r' : 'al-l'} ${up ? 'up' : ''} ${panelClass}`}
             style={width ? { minWidth: width, width } : undefined}>
          {typeof children === 'function' ? children({ close }) : children}
        </div>
      )}
    </div>
  );
}
function MenuLabel({ children }) { return <div className="acc-menu-lbl">{children}</div>; }
function MenuSep() { return <div className="acc-menu-sep" />; }
function MenuItem({ icon, iconTone, mark, label, sub, right, active, danger, dot, onClick }) {
  const Ico = icon ? Icons[icon] : null;
  return (
    <button className={`acc-mi ${active ? 'is-active' : ''} ${danger ? 'danger' : ''}`} onClick={onClick}>
      {mark && <span className="mi-mark">{mark}</span>}
      {Ico && <span className={`mi-ic ${iconTone ? 't-' + iconTone : ''}`}><Ico size={16} /></span>}
      {dot && <span className="mi-dot" style={{ background: dot }} />}
      <span className="mi-tx">
        {label}
        {sub && <div className="mi-sub">{sub}</div>}
      </span>
      {right && <span className="mi-right">{right}</span>}
      {active && <span className="mi-check"><Icons.Check size={16} /></span>}
    </button>
  );
}

/* ──────────────────────────── shared data ──────────────────────────── */
const ENTITIES = [
  { id: 'demo', mark: 'DS', name: 'Demo Shop Ltd', fy: 'FY 2026 · RWF' },
  { id: 'kga', mark: 'KH', name: 'Kigali Hardware', fy: 'FY 2026 · RWF' },
  { id: 'aub', mark: 'AB', name: 'Aurora Bakery', fy: 'FY 2025 · RWF' },
];
const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'].map((m) => `${m} 2026`);
const NOTIFS = [
  { id: 'n1', icon: 'Receipt', tone: 'amber', title: '2 entries awaiting approval', sub: 'JE-1047 · JE-1041 — review & post', go: 'journal' },
  { id: 'n2', icon: 'ShieldCheck', tone: 'amber', title: 'VAT return due 15 Jun 2026', sub: 'Net payable RWF 640,000', go: 'tax' },
  { id: 'n3', icon: 'Refresh', tone: 'blue', title: '2 bank lines need matching', sub: 'Bank of Kigali · May statement', go: 'bankrec' },
  { id: 'n4', icon: 'TrendUp', tone: 'green', title: 'Net income up 18% vs April', sub: 'May 2026 close looks healthy', go: 'statements' },
];

/* ──────────────────────────── search palette ──────────────────────────── */
const SEARCH_VIEWS = [
  { k: 'dashboard', label: 'Dashboard', icon: 'Home' },
  { k: 'journal', label: 'Journal entries', icon: 'Receipt' },
  { k: 'ledger', label: 'General ledger', icon: 'Stack' },
  { k: 'bankrec', label: 'Bank reconciliation', icon: 'Refresh' },
  { k: 'ar', label: 'Receivables', icon: 'ArrowUpRight' },
  { k: 'ap', label: 'Payables', icon: 'ArrowDown' },
  { k: 'tax', label: 'Tax & VAT', icon: 'ShieldCheck' },
  { k: 'statements', label: 'Financial statements', icon: 'Chart' },
  { k: 'trial', label: 'Trial balance', icon: 'Group' },
  { k: 'coa', label: 'Chart of accounts', icon: 'Building' },
];
function TopSearch({ onView, onAccount, onEntry }) {
  const [q, setQ] = useIx('');
  const [open, setOpen] = useIx(false);
  const ref = useIxRef(null);
  const inputRef = useIxRef(null);
  useIxEff(() => {
    const onDown = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    const onKey = (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') { e.preventDefault(); setOpen(true); inputRef.current && inputRef.current.focus(); }
      if (e.key === 'Escape') setOpen(false);
    };
    document.addEventListener('mousedown', onDown);
    document.addEventListener('keydown', onKey);
    return () => { document.removeEventListener('mousedown', onDown); document.removeEventListener('keydown', onKey); };
  }, []);

  const ql = q.trim().toLowerCase();
  const views = SEARCH_VIEWS.filter((v) => !ql || v.label.toLowerCase().includes(ql)).slice(0, 4);
  const accts = !ql ? [] : ACCOUNTS.filter((a) => `${a.code} ${a.name}`.toLowerCase().includes(ql)).slice(0, 5);
  const entries = !ql ? [] : JOURNAL.filter((e) => `${e.id} ${e.memo} ${e.ref}`.toLowerCase().includes(ql)).slice(0, 5);
  const nothing = ql && !views.length && !accts.length && !entries.length;

  const pick = (fn) => { fn(); setOpen(false); setQ(''); };

  return (
    <div className="acc-search" ref={ref} onClick={() => { setOpen(true); inputRef.current && inputRef.current.focus(); }}>
      <Icons.Search size={17} />
      <input ref={inputRef} placeholder="Search entries, accounts, invoices…"
             value={q} onChange={(e) => { setQ(e.target.value); setOpen(true); }} onFocus={() => setOpen(true)} />
      <kbd>⌘K</kbd>
      {open && (
        <div className="acc-search-panel" onClick={(e) => e.stopPropagation()}>
          {!ql && <div className="acc-search-hint">Jump to a module, account or entry — try <kbd>rent</kbd> or <kbd>JE-1046</kbd></div>}
          {views.length > 0 && <><MenuLabel>{ql ? 'Modules' : 'Go to'}</MenuLabel>
            {views.map((v) => <MenuItem key={v.k} icon={v.icon} label={v.label} onClick={() => pick(() => onView(v.k))} />)}</>}
          {accts.length > 0 && <><MenuLabel>Accounts</MenuLabel>
            {accts.map((a) => <MenuItem key={a.code} icon="Stack" label={a.name} sub={`${a.code} · ${a.sub}`} right={money(a.bal)} onClick={() => pick(() => onAccount(a.code))} />)}</>}
          {entries.length > 0 && <><MenuLabel>Journal entries</MenuLabel>
            {entries.map((e) => <MenuItem key={e.id} icon="Receipt" label={e.memo} sub={`${e.id} · ${e.date} · ${e.ref}`} right={money(jeTotals(e).dr)} onClick={() => pick(() => onEntry(e))} />)}</>}
          {nothing && <div className="acc-search-empty">No matches for “{q}”.</div>}
        </div>
      )}
    </div>
  );
}

/* ──────────────────────────── JE detail modal ──────────────────────────── */
function JEDetail({ je, onClose, onEdit }) {
  const t = jeTotals(je);
  return (
    <div className="acc-modal-scrim" onClick={onClose}>
      <div className="acc-modal" onClick={(e) => e.stopPropagation()}>
        <div className="acc-modal-head">
          <div>
            <div className="flex gap8" style={{ marginBottom: 4 }}>
              <span className="je-id" style={{ fontSize: 15 }}>{je.id}</span>
              <span className={`pill ${je.status}`}><span className="pdot" />{je.status}</span>
              <span className="tag">{je.src}</span>
            </div>
            <div className="acc-modal-title">{je.memo}</div>
            <div className="acc-modal-sub">{je.date} 2026 · reference {je.ref}</div>
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="acc-modal-body">
          {je.lines.map((l, i) => {
            const a = ACCT[l.ac];
            const isDr = !!l.dr;
            return (
              <div className="je-line" key={i}>
                <span className={`side ${isDr ? 'dr' : 'cr'}`}>{isDr ? 'DR' : 'CR'}</span>
                <div>
                  <div className="ac-nm">{a ? a.name : l.ac}</div>
                  <div className="ac-code">{a ? a.code : ''}</div>
                </div>
                <span className="amt" style={{ color: isDr ? 'var(--dr-ink)' : 'var(--cr-ink)' }}>{money(l.dr || l.cr)}</span>
              </div>
            );
          })}
          <div className="je-balstrip">
            <span className="ic"><Icons.Check size={13} /></span>
            Balanced · {money(t.dr)} = {money(t.cr)}
          </div>
        </div>
        <div className="acc-modal-foot">
          <button className="acc-btn acc-btn-ghost" onClick={() => { onClose(); toast('Entry duplicated', { sub: 'Draft created from ' + je.id, icon: 'Receipt', tone: 'info' }); }}>Duplicate</button>
          <button className="acc-btn acc-btn-primary" onClick={() => { onClose(); onEdit && onEdit(); }}><Icons.Receipt size={16} />Edit in composer</button>
        </div>
      </div>
    </div>
  );
}

/* ──────────────────────────── generic create modal ──────────────────────────── */
function CreateAccountModal({ onClose }) {
  const [type, setType] = useIx('asset');
  const [name, setName] = useIx('');
  const [code, setCode] = useIx('');
  const types = [['asset', 'Asset'], ['liability', 'Liability'], ['equity', 'Equity'], ['income', 'Income'], ['expense', 'Expense']];
  const ok = name.trim() && code.trim();
  return (
    <div className="acc-modal-scrim" onClick={onClose}>
      <div className="acc-modal" onClick={(e) => e.stopPropagation()}>
        <div className="acc-modal-head">
          <div>
            <div className="acc-modal-title">New account</div>
            <div className="acc-modal-sub">Add a line to the chart of accounts</div>
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="acc-modal-body">
          <div className="acc-mform">
            <div className="acc-mfield">
              <div className="acc-field-lbl">Account type</div>
              <div className="acc-seg">
                {types.map(([k, lbl]) => <button key={k} className={type === k ? 'on' : ''} onClick={() => setType(k)}>{lbl}</button>)}
              </div>
            </div>
            <div className="acc-fieldrow" style={{ marginBottom: 0 }}>
              <div className="acc-mfield">
                <div className="acc-field-lbl">Code</div>
                <div className="acc-input"><span className="ic"><Icons.Hash size={16} /></span><input placeholder="e.g. 1040" value={code} onChange={(e) => setCode(e.target.value.replace(/[^\d]/g, '').slice(0, 4))} /></div>
              </div>
              <div className="acc-mfield">
                <div className="acc-field-lbl">Category</div>
                <div className="acc-input"><span className="ic"><Icons.Group size={16} /></span><input placeholder="e.g. Current assets" /></div>
              </div>
            </div>
            <div className="acc-mfield">
              <div className="acc-field-lbl">Account name</div>
              <div className="acc-input"><span className="ic"><Icons.Building size={16} /></span><input autoFocus placeholder="e.g. Petty Cash" value={name} onChange={(e) => setName(e.target.value)} /></div>
            </div>
          </div>
        </div>
        <div className="acc-modal-foot">
          <button className="acc-btn acc-btn-ghost" onClick={onClose}>Cancel</button>
          <button className="acc-btn acc-btn-primary" disabled={!ok} style={!ok ? { opacity: .5 } : {}}
            onClick={() => { onClose(); toast('Account created', { sub: `${code} · ${name}`, icon: 'Check', tone: 'success' }); }}>
            <Icons.Plus size={16} />Create account
          </button>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, {
  toast, ToastHost, Dropdown, MenuLabel, MenuSep, MenuItem,
  ENTITIES, MONTHS, NOTIFS, TopSearch, JEDetail, CreateAccountModal,
});
