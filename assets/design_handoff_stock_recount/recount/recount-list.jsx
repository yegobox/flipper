/* ===== Flipper · Stock Recount — list screen ===== */
const { useState: useL, useMemo: useLMemo } = React;

function RCStatusBadge({ status }) {
  const s = RC_STATUS[status] || RC_STATUS.draft;
  return <span className={`rc-badge ${s.tone}`}>{s.label}</span>;
}

function RCNetPill({ net }) {
  if (net === 0) return <span className="rc-pill flat"><Icons.Check size={13} /> Balanced</span>;
  const pos = net > 0;
  return (
    <span className={`rc-pill ${pos ? 'pos' : 'neg'}`}>
      {pos ? <Icons.ArrowUp size={13} /> : <Icons.ArrowDown size={13} />}
      {pos ? '+' : ''}{rcNum(net)} net
    </span>
  );
}

function RCCard({ sess, onOpen, onExport, onDelete }) {
  const st = rcStats(sess.items);
  return (
    <div className="rc-card">
      <button className="rc-card-main" onClick={() => onOpen(sess.id)}>
        <span className="rc-card-ico" style={{ background: rcColor(sess.device) }}>
          {sess.status === 'draft' ? <Icons.Box size={22} /> : <Icons.Archive size={22} />}
        </span>
        <span className="rc-card-mid">
          <span className="rc-card-name">
            {sess.device}
            <RCStatusBadge status={sess.status} />
          </span>
          <span className="rc-card-meta"><Icons.Clock size={13} /> {rcFmtDateTime(sess.createdAt)}</span>
          {sess.note ? <span className="rc-card-note">{sess.note}</span> : null}
        </span>
        <span className="rc-card-right"><Icons.ChevRight size={20} color="#AEB8CA" /></span>
      </button>
      <div className="rc-card-foot">
        <span className="rc-pill"><Icons.Stack size={13} /> {st.count} {st.count === 1 ? 'item' : 'items'}</span>
        <RCNetPill net={st.net} />
        {st.short > 0 ? <span className="rc-pill neg"><Icons.ArrowDown size={13} /> {st.short} short</span> : null}
        <button
          className="rc-foot-act"
          onClick={(e) => { e.stopPropagation(); onExport(sess.id); }}
        >
          <Icons.Download size={15} /> Export PDF
        </button>
        {sess.status === 'draft' ? (
          <button
            className="rc-item-del"
            title="Delete draft"
            onClick={(e) => { e.stopPropagation(); onDelete(sess.id); }}
          >
            <Icons.Trash size={17} />
          </button>
        ) : null}
      </div>
    </div>
  );
}

function ListScreen({ sessions, onOpen, onNew, onExport, onDelete }) {
  const [q, setQ] = useL('');
  const [filter, setFilter] = useL('all');

  const counts = useLMemo(() => {
    const c = { all: sessions.length, draft: 0, submitted: 0, synced: 0 };
    sessions.forEach((s) => { c[s.status] = (c[s.status] || 0) + 1; });
    return c;
  }, [sessions]);

  const list = useLMemo(() => {
    const s = q.trim().toLowerCase();
    return sessions.filter((x) => {
      if (filter !== 'all' && x.status !== filter) return false;
      if (!s) return true;
      return x.device.toLowerCase().includes(s)
        || (x.note || '').toLowerCase().includes(s)
        || x.items.some((it) => it.name.toLowerCase().includes(s) || (it.sku || '').toLowerCase().includes(s));
    });
  }, [sessions, q, filter]);

  const FILTERS = [
    { k: 'all', label: 'All' },
    { k: 'draft', label: 'Draft' },
    { k: 'submitted', label: 'Submitted' },
    { k: 'synced', label: 'Synced' },
  ];

  return (
    <>
      <div className="rc-main">
        <div className="rc-wrap">
          <div className="rc-searchbar">
            <Icons.Search size={19} />
            <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search device, note, or product…" />
            {q ? <button className="rc-iconbtn" style={{ width: 30, height: 30, boxShadow: 'none', border: 0 }} onClick={() => setQ('')}><Icons.X size={16} /></button> : null}
          </div>

          <div className="rc-filters">
            <span className="rc-flabel"><Icons.Filter size={15} /> Filter</span>
            {FILTERS.map((f) => (
              <button key={f.k} className={`rc-chip ${filter === f.k ? 'on' : ''}`} onClick={() => setFilter(f.k)}>
                {f.label}
                <span className="rc-chip-n">{counts[f.k] || 0}</span>
              </button>
            ))}
          </div>

          {list.length === 0 ? (
            <div className="rc-empty">
              <div className="rc-empty-ico"><Icons.Archive size={40} /></div>
              <div className="rc-empty-h">{sessions.length === 0 ? 'No recounts yet' : 'Nothing matches'}</div>
              <div className="rc-empty-p">
                {sessions.length === 0
                  ? 'Start a new recount session to count physical stock against your system records.'
                  : 'Try a different search term or filter to find the recount you’re after.'}
              </div>
              {sessions.length === 0
                ? <button className="rc-btn rc-btn-primary" onClick={onNew}><Icons.Plus size={19} /> Start new recount</button>
                : <button className="rc-btn rc-btn-ghost" onClick={() => { setQ(''); setFilter('all'); }}><Icons.Refresh size={17} /> Clear filters</button>}
            </div>
          ) : (
            <div className="rc-list">
              {list.map((s) => (
                <RCCard key={s.id} sess={s} onOpen={onOpen} onExport={onExport} onDelete={onDelete} />
              ))}
            </div>
          )}
        </div>
      </div>

      <button className="rc-fab" onClick={onNew}><Icons.Plus size={20} /> New recount</button>
    </>
  );
}

window.ListScreen = ListScreen;
window.RCStatusBadge = RCStatusBadge;
