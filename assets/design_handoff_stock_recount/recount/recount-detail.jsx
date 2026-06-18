/* ===== Flipper · Stock Recount — detail / edit screen ===== */
const { useState: useD, useMemo: useDMemo, useRef: useDRef, useEffect: useDEffect } = React;

/* ---------- fast add panel (search + barcode + stage) ---------- */
function AddPanel({ items, scanEnabled, onAdd, onScanReq, focusItem, showToast }) {
  const [q, setQ] = useD('');
  const [open, setOpen] = useD(false);
  const [staged, setStaged] = useD(null);   // catalog product staged for adding
  const [qty, setQty] = useD('');
  const [hl, setHl] = useD(0);
  const qtyRef = useDRef(null);
  const wrapRef = useDRef(null);

  const addedSkus = useDMemo(() => new Set(items.map((i) => i.sku)), [items]);

  const results = useDMemo(() => {
    const s = q.trim().toLowerCase();
    if (!s) return [];
    return RC_CATALOG.filter((p) =>
      p.name.toLowerCase().includes(s) || p.sku.toLowerCase().includes(s) || p.barcode.includes(s)
    ).slice(0, 6);
  }, [q]);

  useDEffect(() => {
    const onDoc = (e) => { if (wrapRef.current && !wrapRef.current.contains(e.target)) setOpen(false); };
    document.addEventListener('mousedown', onDoc);
    return () => document.removeEventListener('mousedown', onDoc);
  }, []);

  const stage = (p) => {
    if (addedSkus.has(p.sku)) { focusItem(p.sku); setQ(''); setOpen(false); showToast(`${p.name} is already in this count`); return; }
    setStaged(p); setQ(''); setOpen(false);
    setTimeout(() => qtyRef.current && qtyRef.current.focus(), 60);
  };

  const commit = () => {
    if (!staged) return;
    const n = parseInt(qty, 10);
    if (isNaN(n) || n < 0) { qtyRef.current && qtyRef.current.focus(); return; }
    onAdd(staged, n);
    setStaged(null); setQty('');
  };

  const onKey = (e) => {
    if (!results.length) return;
    if (e.key === 'ArrowDown') { e.preventDefault(); setHl((h) => Math.min(h + 1, results.length - 1)); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); setHl((h) => Math.max(h - 1, 0)); }
    else if (e.key === 'Enter') { e.preventDefault(); stage(results[hl] || results[0]); }
  };

  return (
    <div className="rc-add">
      <div className="rc-add-h">
        <span className="rc-add-ico"><Icons.Plus size={18} /></span>
        Add a product to count
      </div>

      <div className="rc-add-row">
        <div className="rc-search-wrap" ref={wrapRef}>
          <label className="rc-input">
            <Icons.Search size={19} />
            <input
              value={q}
              onChange={(e) => { setQ(e.target.value); setOpen(true); setHl(0); }}
              onFocus={() => setOpen(true)}
              onKeyDown={onKey}
              placeholder="Search product name, SKU or barcode…"
            />
          </label>
          {open && q.trim() ? (
            <div className="rc-results">
              {results.length === 0 ? (
                <div className="rc-results-empty">No product matches “{q.trim()}”.</div>
              ) : results.map((p, i) => {
                const added = addedSkus.has(p.sku);
                return (
                  <button key={p.id} className={`rc-result ${i === hl ? 'hl' : ''}`} onMouseEnter={() => setHl(i)} onClick={() => stage(p)}>
                    <span className="rc-result-sw" style={{ background: rcColor(p.name) }}>{rcAbbr(p.name)}</span>
                    <span className="rc-result-mid">
                      <span className="rc-result-nm">{p.name}</span>
                      <span className="rc-result-sub">SKU {p.sku} · {p.barcode}</span>
                    </span>
                    {added
                      ? <span className="rc-result-added"><Icons.Check size={13} /> Added</span>
                      : <span className="rc-result-sys">{rcNum(p.system)}<span>in system</span></span>}
                  </button>
                );
              })}
            </div>
          ) : null}
        </div>

        {scanEnabled ? (
          <button className="rc-scan" title="Scan barcode" onClick={onScanReq}><Icons.Barcode size={24} /></button>
        ) : null}
      </div>

      {staged ? (
        <div className="rc-stage">
          <span className="rc-stage-sw" style={{ background: rcColor(staged.name) }}>{rcAbbr(staged.name)}</span>
          <span className="rc-stage-mid">
            <span className="rc-stage-nm">{staged.name}</span>
            <span className="rc-stage-sub">SKU {staged.sku} · {rcNum(staged.system)} in system</span>
          </span>
          <div className="rc-stepper">
            <button onClick={() => setQty((v) => String(Math.max(0, (parseInt(v, 10) || 0) - 1)))}><Icons.Minus size={18} /></button>
            <input
              ref={qtyRef} inputMode="numeric" value={qty}
              onChange={(e) => setQty(e.target.value.replace(/[^\d]/g, ''))}
              onKeyDown={(e) => e.key === 'Enter' && commit()}
              placeholder="Qty"
            />
            <button onClick={() => setQty((v) => String((parseInt(v, 10) || 0) + 1))}><Icons.Plus size={18} /></button>
          </div>
          <button className="rc-btn rc-btn-primary" style={{ height: 48, padding: '0 18px' }} onClick={commit}>
            <Icons.Check size={18} /> Add
          </button>
        </div>
      ) : null}
    </div>
  );
}

/* ---------- per-item count card ---------- */
function ItemCard({ it, editable, onCount, onDelete }) {
  const v = rcVar(it);
  const tone = v === 0 ? 'flat' : v > 0 ? 'pos' : 'neg';
  const set = (n) => onCount(it.id, Math.max(0, n));

  return (
    <div className={`rc-item ${editable && v < 0 ? 'is-short' : ''}`} data-screen-label={`item-${it.sku}`}>
      <div className="rc-item-top">
        <span className="rc-item-sw" style={{ background: rcColor(it.name) }}>{rcAbbr(it.name)}</span>
        <span className="rc-item-id">
          <span className="rc-item-nm">{it.name}</span>
          <span className="rc-item-sub">SKU {it.sku} · counted {rcFmtTime(it.countedAt)}</span>
        </span>
        {editable ? (
          <button className="rc-item-del" title="Remove item" onClick={() => onDelete(it.id)}><Icons.Trash size={18} /></button>
        ) : null}
      </div>

      <div className="rc-zones">
        <div className="rc-zone sys">
          <div className="rc-zone-k"><Icons.Monitor size={13} /> System</div>
          <div className="rc-zone-v">{rcNum(it.system)}</div>
        </div>
        <div className="rc-arrowcol"><Icons.ChevRight size={18} /></div>
        <div className="rc-zone cnt">
          <div className="rc-zone-k"><Icons.Stack size={13} /> Counted</div>
          {editable ? (
            <div className="rc-stepper sm">
              <button onClick={() => set((Number(it.counted) || 0) - 1)}><Icons.Minus size={17} /></button>
              <input
                inputMode="numeric" value={it.counted}
                onChange={(e) => set(parseInt(e.target.value.replace(/[^\d]/g, '') || '0', 10))}
                onFocus={(e) => e.target.select()}
              />
              <button onClick={() => set((Number(it.counted) || 0) + 1)}><Icons.Plus size={17} /></button>
            </div>
          ) : (
            <div className="rc-zone-v">{rcNum(it.counted)}</div>
          )}
        </div>
        <div className="rc-arrowcol"><Icons.ChevRight size={18} /></div>
        <div className={`rc-zone var ${tone}`}>
          <div className="rc-zone-k">
            {v > 0 ? <Icons.TrendUp size={13} /> : v < 0 ? <Icons.ArrowDown size={13} /> : <Icons.Check size={13} />} Variance
          </div>
          <div className="rc-zone-v">{v > 0 ? '+' : ''}{rcNum(v)}</div>
        </div>
      </div>

      {editable && v !== 0 ? (
        <div className={`rc-item-flag ${tone}`}>
          {v < 0 ? <Icons.Info size={15} /> : <Icons.TrendUp size={15} />}
          {v < 0
            ? `Counted ${rcNum(-v)} fewer than the system shows — this will be recorded as shrinkage.`
            : `Counted ${rcNum(v)} more than the system shows — a surplus will be recorded.`}
        </div>
      ) : null}
    </div>
  );
}

/* ---------- detail screen ---------- */
function DetailScreen({ sess, editable, variancePolicy, onUpdateNote, onAddItem, onCount, onDeleteItem, onSubmit, onExport, scanEnabled, onScanReq, showToast }) {
  const st = rcStats(sess.items);
  const focusItem = (sku) => {
    const el = document.querySelector(`[data-screen-label="item-${sku}"]`);
    if (el) { el.style.transition = 'box-shadow .2s'; el.style.boxShadow = '0 0 0 3px var(--ac-ring)'; setTimeout(() => { el.style.boxShadow = ''; }, 1100); }
  };

  const hasShorts = st.short > 0;
  const blocked = editable && variancePolicy === 'block' && hasShorts;
  const canSubmit = editable && sess.items.length > 0 && !blocked;

  const STAT_TONE = (k) => (k === 'over' ? 'pos' : k === 'short' ? 'neg' : '');

  return (
    <>
      <div className="rc-main">
        <div className="rc-wrap">
          <div className="rc-sess-head">
            <div className="rc-sess-top">
              <span className="rc-sess-ico"><Icons.Box size={24} /></span>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div className="rc-sess-name">{sess.device}</div>
                <div className="rc-sess-meta">Created {rcFmtDateTime(sess.createdAt)}</div>
              </div>
              <RCStatusBadge status={sess.status} />
            </div>
            <div className="rc-note-field">
              <Icons.Receipt size={17} />
              <input
                value={sess.note}
                disabled={!editable}
                onChange={(e) => onUpdateNote(e.target.value)}
                placeholder="Add a note for this recount session…"
              />
            </div>
          </div>

          {/* summary / progress */}
          <div className="rc-summary">
            <div className="rc-stat">
              <div className="rc-stat-k"><Icons.Stack size={13} /> Items counted</div>
              <div className="rc-stat-v">{st.count}</div>
            </div>
            <div className="rc-stat">
              <div className="rc-stat-k"><span className="rc-stat-dot" style={{ background: '#10B981' }}></span> Matching</div>
              <div className="rc-stat-v">{st.match}</div>
            </div>
            <div className="rc-stat pos">
              <div className="rc-stat-k"><span className="rc-stat-dot" style={{ background: '#10B981' }}></span> Surplus</div>
              <div className="rc-stat-v">{st.over}</div>
            </div>
            <div className="rc-stat neg">
              <div className="rc-stat-k"><span className="rc-stat-dot" style={{ background: '#EF4444' }}></span> Short</div>
              <div className="rc-stat-v">{st.short}</div>
            </div>
          </div>

          {editable ? (
            <AddPanel items={sess.items} scanEnabled={scanEnabled} onAdd={onAddItem} onScanReq={onScanReq} focusItem={focusItem} showToast={showToast} />
          ) : null}

          <div className="rc-items-head">
            <h3>Counted items</h3>
            <span className="rc-count">{st.count} {st.count === 1 ? 'item' : 'items'}{st.net !== 0 ? ` · net ${st.net > 0 ? '+' : ''}${rcNum(st.net)}` : ''}</span>
          </div>

          {sess.items.length === 0 ? (
            <div className="rc-empty" style={{ padding: '40px 24px' }}>
              <div className="rc-empty-ico"><Icons.Stack size={38} /></div>
              <div className="rc-empty-h">No items yet</div>
              <div className="rc-empty-p">Search for a product above, or scan a barcode, then enter the quantity you physically counted.</div>
            </div>
          ) : (
            <div className="rc-items">
              {sess.items.map((it) => (
                <ItemCard key={it.id} it={it} editable={editable} onCount={onCount} onDelete={onDeleteItem} />
              ))}
            </div>
          )}
        </div>
      </div>

      {/* bottom action bar */}
      <div className="rc-actionbar">
        <div className="rc-actionbar-inner">
          <div className="rc-action-sum">
            <div className="a">{editable ? 'Net variance' : 'Recount total'}</div>
            <div className="b" style={{ color: st.net > 0 ? '#047857' : st.net < 0 ? '#B91C1C' : 'inherit' }}>
              {st.net > 0 ? '+' : ''}{rcNum(st.net)} · {st.count} {st.count === 1 ? 'item' : 'items'}
            </div>
          </div>
          <button className="rc-btn rc-btn-ghost" onClick={onExport}><Icons.Download size={18} /> Export PDF</button>
          {editable ? (
            <button className="rc-btn rc-btn-primary" disabled={!canSubmit} onClick={onSubmit}>
              <Icons.Check size={19} /> Submit
            </button>
          ) : null}
        </div>
      </div>
    </>
  );
}

window.DetailScreen = DetailScreen;
