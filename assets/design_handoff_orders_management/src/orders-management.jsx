/* orders-management.jsx — Orders Management screen (incoming/outgoing stock transfer requests) */
const { useState, useRef, useEffect, useCallback } = React;

const OIcon = {
  swap: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 8h13m0 0-3.5-3.5M17 8l-3.5 3.5M20 16H7m0 0 3.5-3.5M7 16l3.5 3.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  calendar: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><rect x="4" y="5.5" width="16" height="15" rx="2.5" stroke="currentColor" strokeWidth="1.8"/><path d="M4 10h16M8 3.5v4M16 3.5v4" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round"/></svg>),
  factory: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 20V11l5 3.5V11l5 3.5V11l5 3.5V20H4Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="M6 20v-4M12 20v-3M18 20v-4" stroke="currentColor" strokeWidth="1.7"/></svg>),
  dots: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M12 20c-4.4 0-8-3.1-8-7s3.6-7 8-7 8 3.1 8 7c0 1.5-.5 2.9-1.4 4.1l.6 3.1-3.2-1.2c-1.2.6-2.6 1-4 1Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><circle cx="9" cy="13" r="1.1" fill="currentColor"/><circle cx="12" cy="13" r="1.1" fill="currentColor"/><circle cx="15" cy="13" r="1.1" fill="currentColor"/></svg>),
  save: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M5 4h11l3 3v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="M8 4v5h7V4M8 20v-6h8v6" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/></svg>),
  pencil: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 20h4l10-10a2 2 0 0 0-2.8-2.8L5 17.2 4 20Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="m13.5 6.5 4 4" stroke="currentColor" strokeWidth="1.7"/></svg>),
  chev: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="m6 9 6 6 6-6" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  checkCircle: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><circle cx="12" cy="12" r="9" stroke="currentColor" strokeWidth="1.8"/><path d="m8 12 2.5 2.5L16 9" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  xCircle: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><circle cx="12" cy="12" r="9" stroke="currentColor" strokeWidth="1.8"/><path d="m9 9 6 6m0-6-6 6" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round"/></svg>),
  inbox: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 13 6.5 5.5A2 2 0 0 1 8.4 4h7.2a2 2 0 0 1 1.9 1.5L20 13v5a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-5Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="M4 13h4l1.5 2.5h5L16 13h4" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/></svg>),
  outbox: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 13 6.5 5.5A2 2 0 0 1 8.4 4h7.2a2 2 0 0 1 1.9 1.5L20 13v5a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-5Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="M12 12V7m0 0-2.3 2.3M12 7l2.3 2.3" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  box: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M12 3 4 7v10l8 4 8-4V7l-8-4Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="M4 7l8 4 8-4M12 11v10" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/></svg>),
};

function Segmented({ value, options, onChange, className }) {
  const ref = useRef(null);
  const [thumb, setThumb] = useState({ left: 4, width: 0 });
  const recalc = useCallback(() => {
    const el = ref.current; if (!el) return;
    const idx = Math.max(0, options.findIndex((o) => o.v === value));
    const btn = el.querySelectorAll("button")[idx];
    if (btn) setThumb({ left: btn.offsetLeft, width: btn.offsetWidth });
  }, [value, options]);
  useEffect(() => { recalc(); }, [recalc]);
  useEffect(() => {
    window.addEventListener("resize", recalc);
    return () => window.removeEventListener("resize", recalc);
  }, [recalc]);
  return (
    <div className={"seg " + (className || "")} ref={ref} role="tablist">
      <span className="thumb" style={{ left: thumb.left, width: thumb.width }} />
      {options.map((o) => (
        <button key={o.v} role="tab" aria-selected={o.v === value} onClick={() => onChange(o.v)}>
          {o.icon}{o.l}
        </button>
      ))}
    </div>
  );
}

const DIR_OPTS = [
  { v: "incoming", l: "Incoming", icon: <OIcon.inbox style={{ width: 18, height: 18 }} /> },
  { v: "outgoing", l: "Outgoing", icon: <OIcon.outbox style={{ width: 18, height: 18 }} /> },
];
const STATUS_OPTS = [
  { v: "pending", l: "Pending", icon: <OIcon.checkCircle style={{ width: 16, height: 16 }} /> },
  { v: "approved", l: "Approved", icon: <OIcon.checkCircle style={{ width: 16, height: 16 }} /> },
];

const ORDERS = {
  incoming: {
    pending: [
      { id: 1, from: "Richard Personal", to: "Demo Shop", requestedOn: "Jul 14, 2026 20:40", items: [{ name: "Fable 002", requested: 1, approved: 1 }] },
      { id: 2, from: "Richard Personal", to: "Demo Shop", requestedOn: "Jul 12, 2026 08:15", items: [{ name: "Amata", requested: 3, approved: 0 }, { name: "Sneakers Pro", requested: 2, approved: 0 }] },
    ],
    approved: [
      { id: 3, from: "Kampala Footwear", to: "Demo Shop", requestedOn: "Jul 9, 2026 14:02", items: [{ name: "Office Flat", requested: 4, approved: 4 }] },
    ],
  },
  outgoing: {
    pending: [
      { id: 4, from: "Demo Shop", to: "Demo Shop", requestedOn: "Feb 7, 2026 11:31", items: [{ name: "Amata", requested: 2 }, { name: "Shoes", requested: 5 }, { name: "T-shirt", requested: 4 }] },
    ],
    approved: [
      { id: 5, from: "Demo Shop", to: "Richard Personal", requestedOn: "Jan 28, 2026 09:47", items: [{ name: "Loafers", requested: 6, approved: 6 }] },
    ],
  },
};

function itemTotals(items, showApproved) {
  const req = items.reduce((s, it) => s + it.requested, 0);
  const app = items.reduce((s, it) => s + (it.approved || 0), 0);
  return showApproved ? `${app}/${req} Item${req === 1 ? "" : "s"}` : `${req} Item${req === 1 ? "" : "s"}`;
}

function OrderCard({ order, direction, status, open, onToggle }) {
  const isOutgoingPending = direction === "outgoing" && status === "pending";
  const showRatio = !isOutgoingPending;
  return (
    <div className={"panel sgroup" + (open ? " open" : "")}>
      <div className="sgroup-head" onClick={onToggle}>
        <span className="om-card-icon"><OIcon.box /></span>
        <div className="sg-id">
          <div className="sup">Request From {order.from} <span className="cnt">({order.items.length} item{order.items.length === 1 ? "" : "s"})</span></div>
        </div>
        <div className="sg-meta" onClick={(e) => e.stopPropagation()}>
          <span className="qtypill">{itemTotals(order.items, showRatio)}</span>
        </div>
        <button className="sg-expand" aria-label={open ? "Collapse" : "Expand"} onClick={(e) => { e.stopPropagation(); onToggle(); }}><OIcon.chev /></button>
      </div>
      {open && (
        <div className="om-body">
          <div className="om-flow">
            <span className="fic"><OIcon.swap /></span>
            <div className="frows">
              <div>From: <b className="from">{order.from}</b></div>
              <div>To: <b className="to">{order.to}</b></div>
            </div>
          </div>

          <div>
            <p className="om-lab" style={{ marginBottom: 10 }}>Items</p>
            <div className="om-items">
              {order.items.map((it, i) => (
                <div className="om-item" key={i}>
                  <div>
                    <div className="nm">{it.name}</div>
                    <div className="sub">
                      {isOutgoingPending
                        ? <React.Fragment>Requested: <b className="req">{it.requested}</b></React.Fragment>
                        : <React.Fragment>Approved: <b className="app">{it.approved}/{it.requested}</b></React.Fragment>}
                    </div>
                  </div>
                  {isOutgoingPending && (
                    <div className="om-item-acts">
                      <button className="om-iconbtn" aria-label="Edit quantity"><OIcon.pencil /></button>
                      <button className="linkbtn"><OIcon.save /> Update</button>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>

          <div>
            <p className="om-lab" style={{ marginBottom: 10 }}>Status &amp; Delivery</p>
            <div className="om-meta-grid">
              <div className="om-meta">
                <span className={"mic status" + (status === "approved" ? " approved" : "")}><OIcon.dots /></span>
                <div><div className="lab">Status</div><div className={"val status-" + status}>{status.toUpperCase()}</div></div>
              </div>
              <div className="om-meta">
                <span className="mic date"><OIcon.calendar /></span>
                <div><div className="lab">Requested On</div><div className="val">{order.requestedOn}</div></div>
              </div>
            </div>
          </div>

          {direction === "incoming" && status === "pending" && (
            <div className="om-actions">
              <button className="btn btn-ghost"><OIcon.factory /> Produce</button>
              <button className="btn btn-green-soft"><OIcon.checkCircle /> Approve</button>
              <button className="btn btn-ghost btn-void" disabled><OIcon.xCircle /> Void</button>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function App() {
  const [direction, setDirection] = useState("incoming");
  const [status, setStatus] = useState("pending");
  const [openIds, setOpenIds] = useState(() => new Set([1]));
  const toggle = (id) => setOpenIds((s) => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });

  const list = ORDERS[direction][status];
  const pendingCount = ORDERS[direction].pending.length;
  const sectionTitle = direction === "incoming" ? "Received Orders" : "Sent Orders";

  return (
    <div className="om-content">
      <div className="om-header">
        <div>
          <h1>Orders Management</h1>
          <p className="sub">Track and manage incoming and outgoing orders</p>
        </div>
        <Segmented value={status} options={STATUS_OPTS} onChange={setStatus} />
      </div>

      <Segmented value={direction} options={DIR_OPTS} onChange={setDirection} className="seg-lg" />

      {status === "pending" && (
        <div className="panel om-stat">
          <span className="ic"><OIcon.inbox /></span>
          <div>
            <div className="num">{pendingCount}</div>
            <div className="lab">Pending Requests</div>
          </div>
        </div>
      )}

      <div className="om-section">
        <h2>{sectionTitle}</h2>
        {list.length === 0 ? (
          <div className="empty">
            <div className="eic"><OIcon.inbox /></div>
            <h3>No {status} requests</h3>
            <p>Nothing to show here right now.</p>
          </div>
        ) : (
          <div className="om-list">
            {list.map((o) => (
              <OrderCard key={o.id} order={o} direction={direction} status={status}
                open={openIds.has(o.id)} onToggle={() => toggle(o.id)} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
