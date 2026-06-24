const { useState: useInc, useRef: useIncRef, useEffect: useIncEffect } = React;

// tiny self-contained color helper (matches the POS palette feel)
const INC_COLORS = ['#3B6FE0','#5457D6','#7A56E8','#9A5BC4','#C2557E','#C76B45','#B5893B','#5E8C3C','#2E9E83','#2C8FB0'];
function incColor(s){ let h=0; for(let i=0;i<s.length;i++) h=(h*31+s.charCodeAt(i))>>>0; return INC_COLORS[h%INC_COLORS.length]; }
function incAbbr(s){ const p=String(s).trim().split(/\s+/); return (p.length>=2?(p[0][0]+p[1][0]):s.slice(0,2)).toUpperCase(); }
function incMoney(n){ return Math.round(n).toLocaleString('en-US'); }

// Expandable section that animates its real measured height
function Section({ icon, tone, title, sub, open, onToggle, children }) {
  const ref = useIncRef(null);
  const [h, setH] = useInc(0);
  useIncEffect(() => {
    if (!ref.current) return;
    setH(open ? ref.current.scrollHeight : 0);
  }, [open, children]);
  const Ico = Icons[icon];
  return (
    <div className="tx-sec">
      <div className="tx-card">
        <button className="tx-sechead" onClick={onToggle} aria-expanded={open}>
          <span className={`tx-sec-ic ${tone}`}><Ico size={21} /></span>
          <span className="tx-sec-mid">
            <span className="tx-sec-t">{title}</span>
            <span className="tx-sec-s">{sub}</span>
          </span>
          <span className={`tx-chev ${open ? 'open' : ''}`}><Icons.ChevDown size={20} /></span>
        </button>
        <div className="tx-secbody" style={{ height: h }}>
          <div className="tx-secbody-inner" ref={ref}>{children}</div>
        </div>
      </div>
    </div>
  );
}

function IncomeDetail() {
  const [openProd, setOpenProd] = useInc(true);
  const [openTl, setOpenTl] = useInc(false);

  const items = [
    { name: 'Coupe Coupe', qty: 1, price: 3500 },
  ];
  const subtotal = items.reduce((s, i) => s + i.qty * i.price, 0);

  const timeline = [
    { t: 'Payment received', d: 'RWF 3,500 · Cash', time: 'Jun 02, 2026 · 11:40 PM', done: true },
    { t: 'Sale created', d: 'by Victoria · Kigali — Main', time: 'Jun 02, 2026 · 11:40 PM', done: true },
  ];

  return (
    <div className="tx">
      <div className="tx-head">
        <button className="tx-iconbtn" aria-label="Back"><Icons.ChevLeft size={20} /></button>
        <span className="tx-head-title">Income</span>
        <button className="tx-iconbtn" aria-label="More"><Icons.More size={20} /></button>
      </div>

      <div className="tx-scroll">
        {/* hero */}
        <div className="tx-hero">
          <span className="tx-status"><span className="dot" />COMPLETED</span>

          <div className="tx-dir"><span className="ic"><Icons.TrendUp size={14} /></span> Income received</div>

          <div className="tx-amount">
            <span className="sign">+</span>
            <span className="cur">RWF</span>
            <span className="val">{incMoney(3500)}</span>
          </div>

          <div className="tx-when">Created <b>Jun 02, 2026</b> · 11:40 PM</div>

          <div className="tx-meta">
            <div className="tx-meta-cell">
              <div className="tx-meta-k">Method</div>
              <div className="tx-meta-v"><span className="pm"><Icons.Wallet size={13} /></span>Cash</div>
            </div>
            <div className="tx-meta-cell">
              <div className="tx-meta-k">Reference</div>
              <div className="tx-meta-v mono">#INC-4821</div>
            </div>
          </div>
        </div>

        {/* products */}
        <Section icon="Cart" tone="blue" title="Products" sub={`${items.length} item${items.length > 1 ? 's' : ''}`}
          open={openProd} onToggle={() => setOpenProd((o) => !o)}>
          {items.map((it, i) => (
            <div className="tx-prod" key={i}>
              <span className="tx-prod-sw" style={{ background: incColor(it.name) }}>{incAbbr(it.name)}</span>
              <div className="tx-prod-mid">
                <div className="tx-prod-nm">{it.name}</div>
                <div className="tx-prod-meta">{it.qty} × RWF {incMoney(it.price)}</div>
              </div>
              <span className="tx-prod-tot">RWF {incMoney(it.qty * it.price)}</span>
            </div>
          ))}
          <div className="tx-prod-sub" style={{ borderTop: '1px solid var(--line-soft)' }}>
            <span className="k">Subtotal</span>
            <span className="v">RWF {incMoney(subtotal)}</span>
          </div>
        </Section>

        {/* timeline */}
        <Section icon="Clock" tone="green" title="Transaction Timeline" sub={`${timeline.length} events`}
          open={openTl} onToggle={() => setOpenTl((o) => !o)}>
          <div className="tx-tl">
            {timeline.map((ev, i) => (
              <div className="tx-tl-row" key={i}>
                <div className="tx-tl-rail">
                  <span className={`tx-tl-node ${ev.done ? 'done' : 'muted'}`}>
                    {ev.done ? <Icons.Check size={15} /> : <Icons.Dot size={14} />}
                  </span>
                  <span className="tx-tl-line" />
                </div>
                <div className="tx-tl-body">
                  <div className="tx-tl-t">{ev.t}</div>
                  <div className="tx-tl-d">{ev.d}</div>
                  <div className="tx-tl-time">{ev.time}</div>
                </div>
              </div>
            ))}
          </div>
        </Section>

        <div style={{ height: 8 }} />
      </div>

      <div className="tx-foot">
        <button className="tx-btn tx-btn-ghost"><Icons.More size={18} /> More Actions</button>
        <button className="tx-btn tx-btn-primary"><Icons.Receipt size={18} /> Invoice</button>
      </div>
    </div>
  );
}

function IncomeApp() {
  return <Phone dark={false} navDark={false}><IncomeDetail /></Phone>;
}
window.IncomeApp = IncomeApp;
