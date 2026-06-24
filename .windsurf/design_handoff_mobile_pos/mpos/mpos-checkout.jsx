/* ===== Flipper Mobile POS · Checkout screen ===== */
const { useState: useCo } = React;

function ItemLine({ line, onInc, onDec, onDel, onSetPrice }) {
  const [open, setOpen] = useCo(false);
  const custom = line.price !== line.basePrice;
  return (
    <div className="mp-item">
      <div className="mp-item-top">
        <span className="mp-item-sw" style={{ background: mpColor(line.name) }}>{mpAbbr(line.name)}</span>
        <div className="mp-item-mid">
          <div className="mp-item-name">{line.name}</div>
          <div className="mp-item-unit">RWF {mpMoney(line.price)} each{custom && <span className="flag">edited</span>}</div>
        </div>
        <span className="mp-item-tot">RWF {mpMoney(line.price * line.qty)}</span>
      </div>
      <div className="mp-item-bottom">
        <div className="mp-stepper">
          <button onClick={() => onDec(line.id)}><Icons.Minus size={16} /></button>
          <span className="n">{line.qty}</span>
          <button onClick={() => onInc(line)} disabled={line.qty >= line.stock}><Icons.Plus size={16} /></button>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <button className="mp-item-edit" onClick={() => setOpen((o) => !o)}>
            <Icons.Tag size={15} /> {open ? 'Done' : 'Price'}
          </button>
          <button className="mp-item-del" onClick={() => onDel(line.id)} aria-label="Remove"><Icons.Trash size={18} /></button>
        </div>
      </div>
      {open && (
        <div className="mp-priceedit">
          <div className="mp-priceedit-lbl">Unit price {custom && <span style={{ color: 'var(--ink-3)', fontWeight: 500 }}>· default RWF {mpMoney(line.basePrice)}</span>}</div>
          <div className="mp-pricefield">
            <span className="cur">RWF</span>
            <input inputMode="decimal" value={line.price}
              onChange={(e) => onSetPrice(line.id, e.target.value.replace(/[^\d.]/g, ''))} />
            {custom && <button className="reset" onClick={() => onSetPrice(line.id, null)} aria-label="Reset"><Icons.Refresh size={15} /></button>}
          </div>
        </div>
      )}
    </div>
  );
}

function Checkout({ lines, customer, method, tender, total, count, time,
  onBack, onAddMore, onInc, onDec, onDel, onSetPrice, onSetMethod, onSetTender, onOpenCust, onClearCust, onComplete }) {

  const tenderNum = parseFloat(String(tender).replace(/[^\d.]/g, '')) || 0;
  const change = Math.max(0, tenderNum - total);
  const due = Math.max(0, total - tenderNum);
  const cashOk = method !== 'cash' || tenderNum >= total;
  const ready = total > 0 && cashOk;
  const QUICK = [total, 5000, 10000, 20000];

  return (
    <div className="mp">
      <div className="mp-head">
        <div className="mp-head-row">
          <button className="mp-back" onClick={onBack} aria-label="Back"><Icons.ChevLeft size={20} /></button>
          <div className="mp-head-titles">
            <div className="mp-head-title">Checkout</div>
            <div className="mp-head-meta">{count} {count === 1 ? 'item' : 'items'} · {time}</div>
          </div>
          <span className="status-pill"><span className="dot" />PENDING</span>
        </div>
      </div>

      <div className="mp-scroll">
        <div className="mp-co-body">
          {/* customer */}
          <div className="mp-sec-label">Customer</div>
          <div className="mp-card">
            {customer ? (
              <div className="mp-cust">
                <span className="mp-cust-av" style={{ background: mpColor(customer.name) }}>{mpAbbr(customer.name)}</span>
                <div className="mp-cust-mid">
                  <div className="mp-cust-name">{customer.name}</div>
                  <div className="mp-cust-sub">{customer.phone}</div>
                </div>
                <button className="mp-cust-clear" onClick={onClearCust} aria-label="Remove customer"><Icons.X size={18} /></button>
              </div>
            ) : (
              <button className="mp-cust" onClick={onOpenCust}>
                <span className="mp-cust-av empty"><Icons.User size={20} /></span>
                <div className="mp-cust-mid">
                  <div className="mp-cust-name">Walk-in customer</div>
                  <div className="mp-cust-sub">Tap to attach a customer (optional)</div>
                </div>
                <span className="mp-cust-act">Add <Icons.ChevRight size={16} /></span>
              </button>
            )}
          </div>

          {/* items */}
          <div className="mp-sec-label">Items</div>
          <div className="mp-card mp-items">
            {lines.map((l) => (
              <ItemLine key={l.id} line={l} onInc={onInc} onDec={onDec} onDel={onDel} onSetPrice={onSetPrice} />
            ))}
          </div>
          <button className="mp-addmore" onClick={onAddMore}><Icons.Plus size={17} /> Add more items</button>

          {/* payment */}
          <div className="mp-sec-label">Payment method</div>
          <div className="mp-card">
            <div className="mp-pays">
              {MP_PAY_METHODS.map((m) => {
                const Ico = Icons[m.icon];
                return (
                  <button key={m.id} className={`mp-pay ${method === m.id ? 'on' : ''}`} onClick={() => onSetMethod(m.id)}>
                    <Ico size={20} /><span>{m.label}</span>
                  </button>
                );
              })}
            </div>
            {method === 'cash' && (
              <div className="mp-tender-wrap">
                <div className="mp-tenderfield">
                  <span className="cur">RWF</span>
                  <input inputMode="numeric" value={tender} placeholder="0"
                    onChange={(e) => onSetTender(e.target.value.replace(/[^\d]/g, ''))} />
                </div>
                <div className="mp-quickcash">
                  {QUICK.map((v, idx) => (
                    <button key={idx} className={tenderNum === v && v > 0 ? 'on' : ''} onClick={() => onSetTender(String(v))}>
                      {idx === 0 ? 'Exact' : mpMoney(v)}
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>

          {/* totals */}
          <div className="mp-card mp-totals">
            <div className="mp-total-row"><span className="k">Subtotal</span><span className="v">RWF {mpMoney(total)}</span></div>
            <div className="mp-total-row"><span className="k">Tax</span><span className="v">RWF 0</span></div>
            <div className="mp-total-row mp-total-grand"><span className="k">Total</span><span className="v">RWF {mpMoney(total)}</span></div>
            {method === 'cash' && tenderNum > 0 && (
              due > 0
                ? <div className="mp-total-row due"><span className="k">Balance due</span><span className="v">RWF {mpMoney(due)}</span></div>
                : <div className="mp-total-row change"><span className="k">Change</span><span className="v">RWF {mpMoney(change)}</span></div>
            )}
          </div>
        </div>
      </div>

      <div className="mp-co-foot">
        <button className="mp-btn-ghost" onClick={onBack}>Save ticket</button>
        <button className={`mp-btn-pay ${ready ? 'ready' : ''}`} disabled={!ready} onClick={onComplete}>
          <Icons.Check size={19} /> Complete · RWF {mpMoney(total)}
        </button>
      </div>
    </div>
  );
}

window.Checkout = Checkout;
