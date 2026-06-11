/* ===== Flipper · Stock Recount — PDF report, submit confirm, scanner ===== */
const { useState: useR, useEffect: useREffect } = React;

/* ---------- printable PDF report ---------- */
function ReportModal({ sess, branch, onClose }) {
  const st = rcStats(sess.items);
  const now = Date.now();
  const s = RC_STATUS[sess.status] || RC_STATUS.draft;
  const badgeStyle = {
    amber: { color: '#B45309', background: '#FEF3C7' },
    blue:  { color: '#1D4ED8', background: '#DBEAFE' },
    green: { color: '#047857', background: '#D1FAE5' },
  }[s.tone];

  return (
    <div className="rc-print-host" onClick={onClose}>
      <div className="rc-report-actions" onClick={(e) => e.stopPropagation()}>
        <span className="ttl"><Icons.Eye size={17} /> PDF preview — {sess.device}</span>
        <button className="rc-btn rc-btn-ghost" style={{ height: 44, background: '#fff' }} onClick={onClose}><Icons.X size={17} /> Close</button>
        <button className="rc-btn rc-btn-primary" style={{ height: 44 }} onClick={() => window.print()}><Icons.Print size={18} /> Print / Save PDF</button>
      </div>

      <div className="rc-report-doc" onClick={(e) => e.stopPropagation()}>
        <div className="rc-report-scroll">
          <div className="rc-rep-pad">
            <div className="rc-rep-head">
              <div className="rc-rep-brand">
                {window.FlipperLogo ? <FlipperLogo size={40} /> : null}
                <div>
                  <div className="nm">{branch.business}</div>
                  <div className="sub">{branch.branch}</div>
                </div>
              </div>
              <div className="rc-rep-title">
                <div className="t">Stock Recount</div>
                <div className="s">Report #{sess.id.slice(-6).toUpperCase()}</div>
                <span className="rc-rep-badge" style={badgeStyle}>{s.label}</span>
              </div>
            </div>

            <div className="rc-rep-meta">
              <div><div className="k">Device</div><div className="v">{sess.device}</div></div>
              <div><div className="k">Counted by</div><div className="v">{branch.counter}</div></div>
              <div><div className="k">Created</div><div className="v">{rcFmtDate(sess.createdAt)}</div></div>
              <div><div className="k">Generated</div><div className="v">{rcFmtDate(now)} {rcFmtTime(now)}</div></div>
            </div>

            {sess.note ? (
              <div style={{ fontSize: 13, color: '#4A5567', padding: '14px 0 0' }}>
                <b style={{ color: '#0B1220' }}>Note:</b> {sess.note}
              </div>
            ) : null}

            <table className="rc-rep-table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Product</th>
                  <th className="num">System</th>
                  <th className="num">Counted</th>
                  <th className="num">Variance</th>
                </tr>
              </thead>
              <tbody>
                {sess.items.map((it, i) => {
                  const v = rcVar(it);
                  const cls = v > 0 ? 'v-pos' : v < 0 ? 'v-neg' : 'v-flat';
                  return (
                    <tr key={it.id}>
                      <td style={{ color: '#8A93A6' }}>{i + 1}</td>
                      <td><div className="pn">{it.name}</div><div className="sk">SKU {it.sku}</div></td>
                      <td className="num">{rcNum(it.system)}</td>
                      <td className="num">{rcNum(it.counted)}</td>
                      <td className={`num ${cls}`}>{v > 0 ? '+' : ''}{rcNum(v)}</td>
                    </tr>
                  );
                })}
                {sess.items.length === 0 ? (
                  <tr><td colSpan="5" style={{ textAlign: 'center', color: '#8A93A6', padding: '24px' }}>No items counted.</td></tr>
                ) : null}
              </tbody>
              <tfoot>
                <tr>
                  <td></td>
                  <td>Totals · {st.count} {st.count === 1 ? 'item' : 'items'}</td>
                  <td className="num">{rcNum(st.sys)}</td>
                  <td className="num">{rcNum(st.counted)}</td>
                  <td className={`num ${st.net > 0 ? 'v-pos' : st.net < 0 ? 'v-neg' : 'v-flat'}`}>{st.net > 0 ? '+' : ''}{rcNum(st.net)}</td>
                </tr>
              </tfoot>
            </table>

            <div style={{ display: 'flex', gap: 10, marginTop: 18, flexWrap: 'wrap' }}>
              <span className="rc-pill flat"><Icons.Check size={13} /> {st.match} matching</span>
              <span className="rc-pill pos"><Icons.TrendUp size={13} /> {st.over} surplus</span>
              <span className="rc-pill neg"><Icons.ArrowDown size={13} /> {st.short} short</span>
            </div>

            <div className="rc-rep-sign">
              <div className="col"><div className="line"></div><div className="lbl">Counted by — {branch.counter}</div></div>
              <div className="col"><div className="line"></div><div className="lbl">Approved by</div></div>
            </div>

            <div className="rc-rep-foot">
              <span>Generated by Flipper · Stock Recount</span>
              <span>{branch.business} — {branch.branch}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

/* ---------- submit confirmation (shorts present, policy = confirm) ---------- */
function ConfirmSubmitSheet({ sess, onClose, onConfirm }) {
  const [reason, setReason] = useR('');
  const shorts = sess.items.filter((it) => rcVar(it) < 0);
  const st = rcStats(sess.items);
  return (
    <div className="rc-overlay" onClick={onClose}>
      <div className="rc-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="rc-sheet-handle" />
        <div className="rc-sheet-h">Confirm shortages before submitting</div>
        <div className="rc-sheet-p">
          {shorts.length} {shorts.length === 1 ? 'item is' : 'items are'} counted lower than the system — recording this submits a net variance of <b style={{ color: st.net < 0 ? '#B91C1C' : '#047857' }}>{st.net > 0 ? '+' : ''}{rcNum(st.net)}</b>. Add a reason so it’s clear why for whoever reviews it.
        </div>
        <div className="rc-sheet-shortlist">
          {shorts.map((it) => (
            <div key={it.id} className="rc-shortrow">
              <span className="rc-item-sw" style={{ width: 32, height: 32, fontSize: 11, background: rcColor(it.name) }}>{rcAbbr(it.name)}</span>
              <span className="nm">{it.name}</span>
              <span className="v">{rcNum(rcVar(it))}</span>
            </div>
          ))}
        </div>
        <textarea className="rc-reason" value={reason} onChange={(e) => setReason(e.target.value)} placeholder="Reason for shortage (e.g. damaged units, spoilage, theft)…" />
        <div className="rc-sheet-actions">
          <button className="rc-btn rc-btn-ghost rc-btn-block" onClick={onClose}>Keep editing</button>
          <button className="rc-btn rc-btn-primary rc-btn-block" onClick={() => onConfirm(reason)}><Icons.Check size={18} /> Confirm &amp; submit</button>
        </div>
      </div>
    </div>
  );
}

/* ---------- barcode scanner (simulated) ---------- */
function Scanner({ onResolve, onClose }) {
  useREffect(() => {
    const t = setTimeout(onResolve, 1500);
    return () => clearTimeout(t);
  }, []);
  return (
    <div className="rc-scanner">
      <div className="rc-scan-frame">
        <div className="rc-scan-corners" />
        <div className="rc-scan-laser" />
      </div>
      <div className="rc-scan-txt"><span className="rc-spinner-dot" /> Point at a barcode…</div>
      <button className="rc-scan-cancel" onClick={onClose}>Cancel</button>
    </div>
  );
}

Object.assign(window, { ReportModal, ConfirmSubmitSheet, Scanner });
