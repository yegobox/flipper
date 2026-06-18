// ===========================================================
//  Flipper Accounting · Journal daybook + double-entry composer
//  The composer is the "pro layer, approachable" centerpiece:
//  live Debits = Credits meter, plain-language templates,
//  but real account codes underneath.
// ===========================================================
const { useState: useJ } = React;

const JE_FILTERS = [['all', 'All'], ['posted', 'Posted'], ['pending', 'Pending'], ['draft', 'Drafts']];

function JournalView({ onNewEntry, onEntry }) {
  const [filter, setFilter] = useJ('all');
  const [src, setSrc] = useJ('all');
  const list = JOURNAL.filter((e) => (filter === 'all' || e.status === filter) && (src === 'all' || e.src === src));
  const pending = JOURNAL.filter((e) => e.status === 'pending').length;
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Daybook</div>
          <h1 className="acc-h1">Journal entries</h1>
          <div className="acc-sub">Every transaction as a balanced double entry · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <Dropdown align="right" width={180}
            trigger={({ toggle }) => (
              <button className="acc-btn acc-btn-ghost" onClick={toggle}><Icons.Filter size={16} />{src === 'all' ? 'Filter' : src}</button>
            )}>
            {({ close }) => (
              <>
                <MenuLabel>By source</MenuLabel>
                <MenuItem label="All sources" active={src === 'all'} onClick={() => { setSrc('all'); close(); }} />
                {['POS', 'Manual', 'Bill', 'Bank', 'Payroll'].map((s) => <MenuItem key={s} label={s} active={src === s} onClick={() => { setSrc(s); close(); }} />)}
              </>
            )}
          </Dropdown>
          <button className="acc-btn acc-btn-primary" onClick={onNewEntry}><Icons.Plus size={17} />New journal entry</button>
        </div>
      </div>

      <div className="flex" style={{ justifyContent: 'space-between', marginBottom: 16 }}>
        <div className="acc-tabs">
          {JE_FILTERS.map(([k, lbl]) => (
            <button key={k} className={`acc-tab ${filter === k ? 'is-on' : ''}`} onClick={() => setFilter(k)}>
              {lbl}{k === 'pending' && pending > 0 && <span style={{ marginLeft: 7, fontFamily: 'var(--mono)', color: 'var(--warnamber)' }}>{pending}</span>}
            </button>
          ))}
        </div>
        {pending > 0 && (
          <div className="flex gap8" style={{ fontSize: 13, color: 'var(--ink-3)' }}>
            <Icons.Info size={15} /><span><b style={{ color: 'var(--warnamber)' }}>{pending} entries</b> awaiting approval</span>
          </div>
        )}
      </div>

      <div className="acc-card">
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th style={{ width: 130 }}>Entry</th><th>Memo &amp; accounts</th><th>Source</th><th>Status</th><th className="r">Amount</th></tr></thead>
            <tbody>
              {list.map((e) => {
                const t = jeTotals(e);
                return (
                  <tr key={e.id} className="acc-row-click" onClick={() => onEntry(e)}>
                    <td><span className="je-id">{e.id}</span><div className="muted" style={{ fontSize: 11.5, marginTop: 2 }}><Icons.Calendar size={11} style={{ verticalAlign: '-1px', marginRight: 4 }} />{e.date} · {e.ref}</div></td>
                    <td>
                      <div className="je-memo">{e.memo}</div>
                      <div className="je-accts">{e.lines.map((l, i) => (
                        <span key={i}>{i > 0 && ' · '}<span style={{ color: l.dr ? 'var(--dr-ink)' : 'var(--cr-ink)' }}>{l.dr ? 'Dr' : 'Cr'}</span> {acctName(l.ac)}</span>
                      ))}</div>
                    </td>
                    <td><span className="tag">{e.src}</span></td>
                    <td><span className={`pill ${e.status}`}><span className="pdot" />{e.status}</span></td>
                    <td className="r num" style={{ fontWeight: 700, fontSize: 14 }}>{money(t.dr)}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────── Account picker popover ────────────────────────
function AccountPicker({ onPick, onClose }) {
  const [q, setQ] = useJ('');
  const groups = [['asset', 'Assets'], ['liability', 'Liabilities'], ['equity', 'Equity'], ['income', 'Income'], ['expense', 'Expenses']];
  const match = (a) => `${a.code} ${a.name}`.toLowerCase().includes(q.toLowerCase());
  return (
    <>
      <div className="acc-pop-scrim" onClick={onClose} />
      <div className="acc-pop" onClick={(e) => e.stopPropagation()}>
        <div className="acc-input" style={{ height: 40, position: 'sticky', top: 0 }}>
          <span className="ic"><Icons.Search size={16} /></span>
          <input autoFocus placeholder="Search accounts…" value={q} onChange={(e) => setQ(e.target.value)} />
        </div>
        {groups.map(([t, lbl]) => {
          const rows = ACCOUNTS.filter((a) => a.type === t && match(a));
          if (!rows.length) return null;
          return (
            <div key={t}>
              <div className="acc-pop-sec">{lbl}</div>
              {rows.map((a) => (
                <div key={a.code} className="acc-pop-item" onClick={() => onPick(a.code)}>
                  <span className="code">{a.code}</span>
                  <span className="nm">{a.name}</span>
                  <span className="bal">{money(a.bal)}</span>
                </div>
              ))}
            </div>
          );
        })}
      </div>
    </>
  );
}

// ─────────────────────────── number input helper ───────────────────────────
const fmtInput = (s) => {
  const digits = String(s).replace(/[^\d]/g, '');
  if (!digits) return '';
  return Number(digits).toLocaleString('en-US');
};
const parseInput = (s) => Number(String(s).replace(/[^\d]/g, '')) || 0;

// ─────────────────────────── Composer ──────────────────────────────────────
const TEMPLATES = [
  { name: 'Record a sale', icon: 'Cart', lines: [{ ac: '1010' }, { ac: '4010', side: 'cr' }, { ac: '2100', side: 'cr' }] },
  { name: 'Pay an expense', icon: 'Wallet', lines: [{ ac: '6010' }, { ac: '1020', side: 'cr' }] },
  { name: 'Receive payment', icon: 'ArrowDown', lines: [{ ac: '1020' }, { ac: '1100', side: 'cr' }] },
  { name: 'Pay a bill', icon: 'Receipt', lines: [{ ac: '2010' }, { ac: '1020', side: 'cr' }] },
];

function Composer({ onClose }) {
  const [memo, setMemo] = useJ('');
  const [lines, setLines] = useJ([{ ac: '', dr: '', cr: '' }, { ac: '', dr: '', cr: '' }]);
  const [picker, setPicker] = useJ(null); // line index being picked
  const [posted, setPosted] = useJ(false);

  const totDr = lines.reduce((s, l) => s + parseInput(l.dr), 0);
  const totCr = lines.reduce((s, l) => s + parseInput(l.cr), 0);
  const diff = totDr - totCr;
  const balanced = diff === 0 && totDr > 0;
  const hasAccts = lines.every((l) => !l.ac || true) && lines.some((l) => l.ac);

  const setLine = (i, patch) => setLines((ls) => ls.map((l, j) => (j === i ? { ...l, ...patch } : l)));
  const addLine = () => setLines((ls) => [...ls, { ac: '', dr: '', cr: '' }]);
  const delLine = (i) => setLines((ls) => (ls.length > 2 ? ls.filter((_, j) => j !== i) : ls));
  const applyTemplate = (t) => {
    setLines(t.lines.map((l) => ({ ac: l.ac, dr: '', cr: '' })).concat(t.lines.length < 2 ? [{ ac: '', dr: '', cr: '' }] : []));
    setMemo(t.name);
  };

  if (posted) {
    return (
      <div className="acc-composer-scrim" onClick={onClose}>
        <div className="acc-composer" onClick={(e) => e.stopPropagation()} style={{ alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14, padding: 40 }}>
            <div style={{ width: 84, height: 84, borderRadius: 26, background: 'var(--gain)', color: '#fff', display: 'grid', placeItems: 'center', boxShadow: '0 18px 40px -10px rgba(22,163,74,.5)' }}>
              <Icons.Check size={40} />
            </div>
            <div style={{ fontSize: 23, fontWeight: 800, letterSpacing: '-.02em' }}>Entry posted &amp; balanced</div>
            <div style={{ fontSize: 14, color: 'var(--ink-3)', maxWidth: 320 }}>Debits equal credits. The ledger, trial balance and statements have all been updated.</div>
            <button className="acc-btn acc-btn-primary" style={{ marginTop: 10 }} onClick={onClose}>Done</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="acc-composer-scrim" onClick={onClose}>
      <div className="acc-composer" onClick={(e) => e.stopPropagation()}>
        <div className="acc-comp-head">
          <div>
            <div className="acc-comp-title">New journal entry</div>
            <div className="acc-comp-sub">Pick the accounts and enter amounts — Flipper keeps it balanced.</div>
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>

        <div className="acc-comp-body">
          {/* templates */}
          <div className="acc-field-lbl">Quick start</div>
          <div className="flex gap8" style={{ marginBottom: 18, flexWrap: 'wrap' }}>
            {TEMPLATES.map((t) => {
              const Ico = Icons[t.icon];
              return (
                <button key={t.name} className="acc-btn acc-btn-ghost acc-btn-sm" onClick={() => applyTemplate(t)}>
                  <Ico size={15} />{t.name}
                </button>
              );
            })}
          </div>

          <div className="acc-fieldrow">
            <div>
              <div className="acc-field-lbl">Date</div>
              <div className="acc-input"><span className="ic"><Icons.Calendar size={17} /></span><input defaultValue="31 May 2026" /></div>
            </div>
            <div>
              <div className="acc-field-lbl">Reference</div>
              <div className="acc-input"><span className="ic"><Icons.Hash size={17} /></span><input placeholder="Auto · JE-1048" /></div>
            </div>
          </div>
          <div style={{ marginBottom: 20 }}>
            <div className="acc-field-lbl">Memo / description</div>
            <div className="acc-input"><span className="ic"><Icons.Receipt size={17} /></span><input placeholder="What is this entry for?" value={memo} onChange={(e) => setMemo(e.target.value)} /></div>
          </div>

          {/* line editor */}
          <div className="acc-field-lbl" style={{ marginBottom: 10 }}>Lines</div>
          <div className="acc-lines-head"><span>Account</span><span className="r">Debit</span><span className="r">Credit</span><span /></div>
          {lines.map((l, i) => {
            const acct = ACCT[l.ac];
            return (
              <div className="acc-line" key={i} style={{ position: 'relative' }}>
                <div className={`acc-acct-pick ${acct ? 'filled' : ''}`} onClick={() => setPicker(i)}>
                  {acct ? <><span className="acc-acct-code">{acct.code}</span><span className="acc-acct-nm">{acct.name}</span></>
                        : <span className="acc-acct-nm" style={{ color: 'var(--ink-4)', fontWeight: 500 }}>Select account…</span>}
                  <span className="chev"><Icons.ChevDown size={16} /></span>
                </div>
                <div className="acc-amt-field dr">
                  <input inputMode="numeric" placeholder="0" value={l.dr}
                    onChange={(e) => setLine(i, { dr: fmtInput(e.target.value), cr: '' })} />
                </div>
                <div className="acc-amt-field cr">
                  <input inputMode="numeric" placeholder="0" value={l.cr}
                    onChange={(e) => setLine(i, { cr: fmtInput(e.target.value), dr: '' })} />
                </div>
                <button className="acc-line-del" onClick={() => delLine(i)} title="Remove line"><Icons.Trash size={16} /></button>
                {picker === i && <AccountPicker onClose={() => setPicker(null)} onPick={(code) => { setLine(i, { ac: code }); setPicker(null); }} />}
              </div>
            );
          })}
          <button className="acc-addline" onClick={addLine}><Icons.Plus size={15} />Add line</button>

          <div className="flex gap8" style={{ marginTop: 18, fontSize: 12.5, color: 'var(--ink-3)', lineHeight: 1.4 }}>
            <span style={{ color: 'var(--blue)', flexShrink: 0, marginTop: 1 }}><Icons.Info size={15} /></span>
            <span>Every entry has two sides. Money <b style={{ color: 'var(--dr-ink)' }}>into</b> an account is a debit; money <b style={{ color: 'var(--cr-ink)' }}>out</b> is a credit. They must add up to the same total.</span>
          </div>
        </div>

        {/* balance meter + actions */}
        <div className="acc-comp-foot">
          <div className={`acc-balance ${balanced ? 'ok' : 'off'}`}>
            <div className="acc-balance-side"><span className="acc-balance-k">Total debits</span><span className="acc-balance-v dr-amt">{money(totDr)}</span></div>
            <span className="acc-balance-eq">=</span>
            <div className="acc-balance-side"><span className="acc-balance-k">Total credits</span><span className="acc-balance-v cr-amt">{money(totCr)}</span></div>
            <div className="acc-balance-status">
              <span className="acc-balance-chip">{balanced ? <Icons.Check size={15} /> : <Icons.Warn size={14} />}</span>
              {balanced ? 'Balanced' : totDr === 0 ? 'Enter amounts' : `Off by ${money(Math.abs(diff))}`}
            </div>
          </div>
          <div className="acc-comp-actions">
            <button className="acc-btn acc-btn-ghost" onClick={() => { toast('Draft saved', { sub: 'JE-1048 kept in Drafts', icon: 'Receipt', tone: 'info' }); onClose(); }}>Save draft</button>
            <button className="acc-btn acc-btn-primary" disabled={!balanced || !hasAccts} onClick={() => setPosted(true)}>
              <Icons.Check size={18} />Post entry
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { JournalView, Composer });
