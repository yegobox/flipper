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

const REASONS = ['Customer request', 'Wrong item', 'Damaged / faulty', 'Duplicate charge', 'Other'];

// ---- More Actions sheet ----
function ActionsSheet({ onClose, onRefund, refunded }) {
  const actions = [
    { ic: 'Share', a: 'Share receipt', b: 'Send via WhatsApp, SMS or email' },
    { ic: 'Download', a: 'Download PDF', b: 'Save a copy of this receipt' },
    { ic: 'Print', a: 'Print receipt', b: 'Send to a connected printer' },
  ];
  return (
    <div className="tx-overlay" onClick={onClose}>
      <div className="tx-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="tx-sheet-handle" />
        <div className="tx-sheet-head">
          <div><div className="tx-sheet-title">More actions</div><div className="tx-sheet-sub">Income · #INC-4821</div></div>
          <button className="tx-sheet-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="tx-sheet-body">
          {actions.map((x) => {
            const Ico = Icons[x.ic];
            return (
              <button key={x.a} className="tx-action" onClick={onClose}>
                <span className="ic"><Ico size={20} /></span>
                <span className="mid"><span className="a">{x.a}</span><span className="b">{x.b}</span></span>
                <span className="chev"><Icons.ChevRight size={18} /></span>
              </button>
            );
          })}
          {/* Refund — destructive */}
          <button className="tx-action danger" onClick={onRefund} disabled={refunded} style={refunded ? { opacity: .5 } : null}>
            <span className="ic"><Icons.Refresh size={20} /></span>
            <span className="mid">
              <span className="a">{refunded ? 'Already refunded' : 'Refund payment'}</span>
              <span className="b">{refunded ? 'This income has been refunded' : 'Return money to the customer'}</span>
            </span>
            {!refunded && <span className="chev"><Icons.ChevRight size={18} /></span>}
          </button>
        </div>
      </div>
    </div>
  );
}

// ---- Guided refund flow ----
function RefundSheet({ total, onClose, onConfirm }) {
  const [type, setType] = useInc('full');
  const [amount, setAmount] = useInc(String(total));
  const [reason, setReason] = useInc('Customer request');
  const [method, setMethod] = useInc('cash');
  const [step, setStep] = useInc('form'); // form | processing | done

  const amt = type === 'full' ? total : (parseInt(String(amount).replace(/\D/g, ''), 10) || 0);
  const over = amt > total;
  const valid = amt > 0 && !over;

  const submit = () => {
    setStep('processing');
    setTimeout(() => setStep('done'), 1100);
  };

  if (step === 'processing') {
    return (
      <div className="tx-overlay">
        <div className="tx-loader" style={{ position: 'absolute' }}>
          <span className="tx-spinner" />
          <span className="tx-loader-tx">Processing refund…</span>
        </div>
      </div>
    );
  }
  if (step === 'done') {
    return (
      <div className="tx-overlay">
        <div className="tx-refdone">
          <div className="tx-refdone-check"><Icons.Check size={48} /></div>
          <div className="tx-refdone-h">Refund completed</div>
          <div className="tx-refdone-s">
            <span className="tx-refdone-amt">RWF {incMoney(amt)}</span> was refunded to the customer via {method === 'cash' ? 'cash' : 'MoMo'}.
          </div>
          <button className="tx-refdone-btn" onClick={() => onConfirm({ amt, reason, method, partial: amt < total })}>Done</button>
        </div>
      </div>
    );
  }

  return (
    <div className="tx-overlay" onClick={onClose}>
      <div className="tx-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="tx-sheet-handle" />
        <div className="tx-sheet-head">
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button className="tx-sheet-back" onClick={onClose}><Icons.ChevLeft size={18} /></button>
            <div><div className="tx-sheet-title">Refund payment</div><div className="tx-sheet-sub">Return money for #INC-4821</div></div>
          </div>
          <button className="tx-sheet-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="tx-sheet-body">
          {/* step 1: amount */}
          <label className="tx-rf-lbl">1 · How much?</label>
          <div className="tx-rf-seg">
            <button className={`tx-rf-opt ${type === 'full' ? 'on' : ''}`} onClick={() => { setType('full'); setAmount(String(total)); }}>
              <span className="ot">Full refund</span>
              <span className="od">RWF {incMoney(total)}</span>
            </button>
            <button className={`tx-rf-opt ${type === 'partial' ? 'on' : ''}`} onClick={() => setType('partial')}>
              <span className="ot">Partial</span>
              <span className="od">Choose amount</span>
            </button>
          </div>
          {type === 'partial' && (
            <div style={{ marginTop: 10 }}>
              <div className="tx-rf-field">
                <span className="cur">RWF</span>
                <input inputMode="numeric" autoFocus value={amount}
                  onChange={(e) => setAmount(e.target.value.replace(/\D/g, ''))} placeholder="0" />
              </div>
              <div className={`tx-rf-hint ${over ? 'over' : ''}`}>
                {over ? `Can’t exceed the original RWF ${incMoney(total)}` : `Up to RWF ${incMoney(total)} available to refund`}
              </div>
            </div>
          )}

          {/* step 2: reason */}
          <label className="tx-rf-lbl">2 · Reason</label>
          <div className="tx-chips">
            {REASONS.map((r) => (
              <button key={r} className={`tx-chip ${reason === r ? 'on' : ''}`} onClick={() => setReason(r)}>{r}</button>
            ))}
          </div>

          {/* step 3: method */}
          <label className="tx-rf-lbl">3 · Refund to</label>
          <div className="tx-rf-seg">
            <button className={`tx-rf-opt ${method === 'cash' ? 'on' : ''}`} onClick={() => setMethod('cash')}>
              <span className="ot">Cash</span><span className="od">Hand back now</span>
            </button>
            <button className={`tx-rf-opt ${method === 'momo' ? 'on' : ''}`} onClick={() => setMethod('momo')}>
              <span className="ot">MoMo</span><span className="od">Send to phone</span>
            </button>
          </div>

          {/* summary */}
          <div className="tx-rf-summary">
            <div className="tx-rf-srow"><span className="k">Original payment</span><span className="v">RWF {incMoney(total)}</span></div>
            <div className="tx-rf-srow"><span className="k">Reason</span><span className="v" style={{ fontFamily: 'var(--sans)', fontWeight: 600 }}>{reason}</span></div>
            <div className="tx-rf-srow big"><span className="k">Refund amount</span><span className="v">RWF {incMoney(amt)}</span></div>
          </div>

          <button className="tx-rf-save" disabled={!valid} onClick={submit}>
            <Icons.Refresh size={18} /> Refund RWF {incMoney(amt)}
          </button>
        </div>
      </div>
    </div>
  );
}

function IncomeDetail() {
  const [openProd, setOpenProd] = useInc(true);
  const [openTl, setOpenTl] = useInc(false);
  const [sheet, setSheet] = useInc(null); // null | 'actions' | 'refund'
  const [refund, setRefund] = useInc(null); // { amt, reason, method, partial } once done

  const TOTAL = 3500;
  const items = [
    { name: 'Coupe Coupe', qty: 1, price: 3500 },
  ];
  const subtotal = items.reduce((s, i) => s + i.qty * i.price, 0);

  const baseTimeline = [
    { t: 'Payment received', d: 'RWF 3,500 · Cash', time: 'Jun 02, 2026 · 11:40 PM', done: true },
    { t: 'Sale created', d: 'by Victoria · Kigali — Main', time: 'Jun 02, 2026 · 11:40 PM', done: true },
  ];
  const timeline = refund
    ? [{ t: refund.partial ? 'Partially refunded' : 'Refunded', d: `RWF ${incMoney(refund.amt)} · ${refund.reason}`, time: 'Jun 03, 2026 · 09:15 AM', done: true, isRefund: true }, ...baseTimeline]
    : baseTimeline;

  const status = !refund ? 'completed' : (refund.partial ? 'partial' : 'refund');
  const statusLabel = !refund ? 'COMPLETED' : (refund.partial ? 'PARTIALLY REFUNDED' : 'REFUNDED');

  const doRefund = (r) => { setRefund(r); setSheet(null); setOpenTl(true); };

  return (
    <div className="tx">
      <div className="tx-head">
        <button className="tx-iconbtn" aria-label="Back"><Icons.ChevLeft size={20} /></button>
        <span className="tx-head-title">Income</span>
        <button className="tx-iconbtn" aria-label="More" onClick={() => setSheet('actions')}><Icons.More size={20} /></button>
      </div>

      <div className="tx-scroll">
        {/* hero */}
        <div className={`tx-hero ${refund ? 'refunded' : ''}`}>
          <span className={`tx-status ${status === 'completed' ? '' : status}`}><span className="dot" />{statusLabel}</span>

          {!refund && <div className="tx-dir"><span className="ic"><Icons.TrendUp size={14} /></span> Income received</div>}

          <div className={`tx-amount ${refund && !refund.partial ? 'struck' : ''}`}>
            <span className="sign">+</span>
            <span className="cur">RWF</span>
            <span className="val">{incMoney(TOTAL)}</span>
          </div>

          <div className="tx-when">Created <b>Jun 02, 2026</b> · 11:40 PM</div>

          {refund && (
            <div className="tx-refbanner">
              <span className="ic"><Icons.Refresh size={18} /></span>
              <div>
                <div className="t">{refund.partial ? `RWF ${incMoney(refund.amt)} refunded` : 'Fully refunded to customer'}</div>
                <div className="s">{refund.reason} · via {refund.method === 'cash' ? 'Cash' : 'MoMo'} · Jun 03</div>
              </div>
            </div>
          )}

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
                  <span className={`tx-tl-node ${ev.isRefund ? 'muted' : 'done'}`} style={ev.isRefund ? { background: '#FDECEC', color: 'var(--loss)', border: '1px solid #F8D4D4' } : null}>
                    {ev.isRefund ? <Icons.Refresh size={14} /> : <Icons.Check size={15} />}
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
        <button className="tx-btn tx-btn-ghost" onClick={() => setSheet('actions')}><Icons.More size={18} /> More Actions</button>
        <button className="tx-btn tx-btn-primary"><Icons.Receipt size={18} /> Invoice</button>
      </div>

      {sheet === 'actions' && <ActionsSheet refunded={!!refund} onClose={() => setSheet(null)} onRefund={() => setSheet('refund')} />}
      {sheet === 'refund' && <RefundSheet total={TOTAL} onClose={() => setSheet('actions')} onConfirm={doRefund} />}
    </div>
  );
}

function IncomeApp() {
  return <Phone dark={false} navDark={false}><IncomeDetail /></Phone>;
}
window.IncomeApp = IncomeApp;
