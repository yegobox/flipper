/* ===== Flipper Mobile POS · customer picker + success + app ===== */
const { useState: useApp, useMemo: useAppMemo } = React;

function CustomerSheet({ onClose, onPick, onWalkIn }) {
  const [q, setQ] = useApp('');
  const list = useAppMemo(() => {
    const s = q.trim().toLowerCase();
    return s ? MP_CUSTOMERS.filter((c) => c.name.toLowerCase().includes(s) || c.phone.replace(/\s/g, '').includes(s.replace(/\s/g, ''))) : MP_CUSTOMERS;
  }, [q]);
  return (
    <div className="mp-overlay" onClick={onClose}>
      <div className="mp-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="mp-sheet-handle" />
        <div className="mp-sheet-head">
          <span className="mp-sheet-title">Attach customer</span>
          <button className="mp-sheet-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="mp-sheet-body">
          <div className="mp-custsearch">
            <Icons.Search size={18} />
            <input autoFocus value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search name or phone…" />
          </div>
          <button className="mp-walkin" onClick={onWalkIn}>
            <span className="ic"><Icons.Walk size={20} /></span>
            <span className="mp-walkin-t">
              <span className="a">Continue as walk-in</span>
              <span className="b">No customer attached</span>
            </span>
          </button>
          {list.map((c) => (
            <button key={c.id} className="mp-custrow" onClick={() => onPick(c)}>
              <span className="av" style={{ background: mpColor(c.name) }}>{mpAbbr(c.name)}</span>
              <span className="mid">
                <span className="nm">{c.name}</span>
                <span className="ph"><Icons.Phone size={13} /> {c.phone}</span>
              </span>
              <span className="chev"><Icons.ChevRight size={18} /></span>
            </button>
          ))}
          <button className="mp-custadd"><Icons.Plus size={17} /> Add new customer</button>
        </div>
      </div>
    </div>
  );
}

function Success({ data, onNewSale, onReceipt }) {
  return (
    <div className="mp-done">
      <Confetti run count={70} />
      <div className="mp-done-scroll">
        <div className="mp-done-check"><Icons.Check size={52} color="#fff" /></div>
        <div className="mp-done-h">Sale complete</div>
        <div className="mp-done-sub">{data.method.toUpperCase()} · {data.count} {data.count === 1 ? 'item' : 'items'}{data.customer ? ` · ${data.customer.name}` : ' · Walk-in'}</div>
        <div className="mp-receipt">
          <div className="mp-receipt-row big"><span className="k">Total paid</span><span className="v">RWF {mpMoney(data.total)}</span></div>
          <div className="mp-receipt-div" />
          <div className="mp-receipt-row"><span className="k">Tendered</span><span className="v">RWF {mpMoney(data.tendered)}</span></div>
          <div className="mp-receipt-row"><span className="k">Change</span><span className="v">RWF {mpMoney(data.change)}</span></div>
        </div>
      </div>
      <div className="mp-done-foot">
        <button className="mp-done-btn solid" onClick={onNewSale}><Icons.Plus size={18} /> New sale</button>
        <button className="mp-done-btn ghost" onClick={onReceipt}><Icons.Receipt size={18} /> Print receipt</button>
      </div>
    </div>
  );
}

function MposApp() {
  const [screen, setScreen] = useApp('catalog'); // catalog | checkout | done
  const [cart, setCart] = useApp({});             // id -> qty
  const [prices, setPrices] = useApp({});         // id -> custom price
  const [customer, setCustomer] = useApp(null);
  const [method, setMethod] = useApp('cash');
  const [tender, setTender] = useApp('');
  const [custOpen, setCustOpen] = useApp(false);
  const [toast, setToast] = useApp('');
  const [done, setDone] = useApp(null);

  const time = useAppMemo(() => new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false }), []);

  const lines = useAppMemo(() => Object.entries(cart).map(([id, qty]) => {
    const p = MP_PRODUCTS.find((x) => x.id === +id); if (!p) return null;
    const ov = prices[id];
    return { ...p, qty, basePrice: p.price, price: (ov === undefined || ov === '' ? p.price : Number(ov)) };
  }).filter(Boolean), [cart, prices]);

  const total = lines.reduce((s, l) => s + l.price * l.qty, 0);
  const count = lines.reduce((s, l) => s + l.qty, 0);

  const add = (p) => setCart((c) => ({ ...c, [p.id]: Math.min(p.stock, (c[p.id] || 0) + 1) }));
  const inc = (p) => setCart((c) => ({ ...c, [p.id]: Math.min(p.stock, (c[p.id] || 0) + 1) }));
  const dec = (id) => setCart((c) => { const n = (c[id] || 0) - 1; const nx = { ...c }; if (n <= 0) delete nx[id]; else nx[id] = n; return nx; });
  const del = (id) => setCart((c) => { const nx = { ...c }; delete nx[id]; return nx; });
  const setPrice = (id, v) => setPrices((pr) => { const nx = { ...pr }; if (v === null || v === '') delete nx[id]; else nx[id] = v; return nx; });

  const showToast = (msg) => { setToast(msg); setTimeout(() => setToast(''), 2600); };

  const pickCustomer = (c) => { setCustomer(c); setCustOpen(false); showToast(`${c.name} attached to this sale`); };
  const walkIn = () => { setCustomer(null); setCustOpen(false); };

  const complete = () => {
    const tn = parseFloat(String(tender).replace(/[^\d]/g, '')) || 0;
    const tendered = method === 'cash' ? (tn || total) : total;
    setDone({ total, count, method, customer, tendered, change: Math.max(0, tendered - total) });
    setScreen('done');
  };
  const reset = () => { setCart({}); setPrices({}); setCustomer(null); setTender(''); setMethod('cash'); setDone(null); setScreen('catalog'); };

  return (
    <Phone dark={screen === 'done'} navDark={screen === 'done'}>
      {screen === 'catalog' && (
        <Catalog cart={cart} onAdd={add} onInc={inc} onDec={dec} count={count} total={total} time={time}
          onReview={() => setScreen('checkout')} />
      )}
      {screen === 'checkout' && (
        <Checkout lines={lines} customer={customer} method={method} tender={tender} total={total} count={count} time={time}
          onBack={() => setScreen('catalog')} onAddMore={() => setScreen('catalog')}
          onInc={inc} onDec={dec} onDel={del} onSetPrice={setPrice}
          onSetMethod={setMethod} onSetTender={setTender}
          onOpenCust={() => setCustOpen(true)} onClearCust={() => setCustomer(null)}
          onComplete={complete} />
      )}
      {screen === 'done' && done && (
        <Success data={done} onNewSale={reset} onReceipt={reset} />
      )}
      {custOpen && <CustomerSheet onClose={() => setCustOpen(false)} onPick={pickCustomer} onWalkIn={walkIn} />}
      {toast && screen !== 'done' && (
        <div className="mp-toast"><span className="ic"><Icons.Check size={15} color="#fff" /></span><span className="tx">{toast}</span></div>
      )}
    </Phone>
  );
}

window.MposApp = MposApp;
