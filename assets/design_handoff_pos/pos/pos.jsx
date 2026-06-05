const { useState: usePos, useMemo: usePosMemo, useEffect: usePosEffect } = React;

/* Harmonious, on-brand tile palette — all medium-dark so WHITE text always
   has contrast (fixes the original's washed-out pastels). Assigned by name hash. */
const TILE_COLORS = [
  '#3B6FE0', '#5457D6', '#7A56E8', '#9A5BC4',
  '#C2557E', '#C76B45', '#B5893B', '#5E8C3C',
  '#2E9E83', '#2C8FB0', '#5B7488', '#9A6248',
];
function hashIdx(str, mod) {
  let h = 0;
  for (let i = 0; i < str.length; i++) h = (h * 31 + str.charCodeAt(i)) >>> 0;
  return h % mod;
}
const colorFor = (name) => TILE_COLORS[hashIdx(name, TILE_COLORS.length)];
const abbr = (name) => name.replace(/[^A-Za-z ]/g, '').slice(0, 3) || name.slice(0, 3);

/* products — names mirror the reference screen */
const PRODUCTS = [
  { id: 143, name: 'Cellure GJS',      price: 12000, stock: 4 },
  { id: 160, name: 'Coupe coupe',      price: 2400,  stock: 368 },
  { id: 189, name: "Urukezo 18' nziza", price: 3000, stock: 476 },
  { id: 51,  name: 'Ibivero',          price: 6500,  stock: 1028 },
  { id: 144, name: 'Cylendre Wista',   price: 3250,  stock: 763 },
  { id: 100, name: 'Socket france',    price: 240,   stock: 3896 },
  { id: 104, name: 'Toilesolante',     price: 250,   stock: 1855 },
  { id: 171, name: 'Inyundo 5kg',      price: 12000, stock: 9 },
  { id: 151, name: 'Ibitiyo 1kg',      price: 2500,  stock: 154 },
  { id: 118, name: 'Umwiko',           price: 1125,  stock: 1053 },
  { id: 178, name: 'Pince BUNT',       price: 3000,  stock: 0 },
  { id: 96,  name: "Roulon 4'",        price: 600,   stock: 1205 },
  { id: 207, name: 'Agafuni',          price: 4500,  stock: 62 },
  { id: 212, name: 'Imbaho ya 3m',     price: 1800,  stock: 7 },
  { id: 233, name: 'Fer à béton 12',   price: 9800,  stock: 240 },
  { id: 245, name: 'Sima Cimerwa',     price: 11500, stock: 88 },
];

const money = (n) => n.toLocaleString('en-US', { minimumFractionDigits: 0 });

function stockState(s) {
  if (s <= 0) return 'out';
  if (s <= 10) return 'low';
  return 'ok';
}

/* ============================ top bar ============================ */
function TopBar() {
  const nav = [
    { k: 'home', label: 'Home', icon: 'Home' },
    { k: 'tx', label: 'Transactions', icon: 'Refresh' },
    { k: 'eod', label: 'EOD', icon: 'Wallet' },
    { k: 'an', label: 'Analytics', icon: 'Chart' },
  ];
  const [on, setOn] = usePos('home');
  return (
    <div className="pos-top">
      <div className="pos-logo">
        <FlipperLogo size={30} />
        <span className="wordmark">FLIPPER</span>
        <span className="pos-logo-sub">Point of Sale</span>
      </div>
      <div className="pos-top-tools">
        <button className="pos-tool" title="Catalog"><Icons.Grid size={19} /></button>
        <button className="pos-tool" title="Scan"><Icons.Barcode size={19} /></button>
        <button className="pos-tool" title="Cart"><Icons.Cart size={19} /></button>
        <button className="pos-tool" title="Display"><Icons.Monitor size={19} /></button>
        <button className="pos-tool" title="New"><Icons.Plus size={19} /></button>
      </div>
      <div className="pos-top-spacer" />
      <nav className="pos-nav">
        {nav.map((n) => {
          const Ico = Icons[n.icon];
          return (
            <button key={n.k} className={`pos-navitem ${on === n.k ? 'is-on' : ''}`} onClick={() => setOn(n.k)}>
              <Ico size={18} />{n.label}
            </button>
          );
        })}
        <button className="pos-tool" title="Open display"><Icons.ArrowUpRight size={18} /></button>
        <button className="pos-tool" title="More"><Icons.More size={18} /></button>
      </nav>
      <button className="pos-iconbtn" title="Notifications">
        <Icons.Bell size={20} />
      </button>
      <button className="pos-iconbtn" title="Sync"><Icons.Refresh size={19} /><span className="pos-badge">0</span></button>
      <div className="pos-user">
        <div className="pos-user-av">V</div>
        <div className="pos-user-meta">
          <div className="pos-user-name">VICTORIA</div>
          <div className="pos-user-role">Branch</div>
        </div>
      </div>
    </div>
  );
}

/* ============================ left rail ============================ */
function Rail() {
  const top = ['Grid', 'Users', 'ShieldCheck', 'Stack', 'Chart', 'Receipt', 'Wallet', 'Clock'];
  const [on, setOn] = usePos('Grid');
  return (
    <div className="pos-rail">
      {top.map((k) => {
        const Ico = Icons[k];
        return (
          <button key={k} className={`pos-rail-btn ${on === k ? 'is-on' : ''}`} onClick={() => setOn(k)}>
            <Ico size={21} />
          </button>
        );
      })}
      <div className="pos-rail-spacer" />
      <button className="pos-rail-btn danger" title="Sign out"><Icons.LogOut size={21} /></button>
      <button className="pos-rail-btn pos-rail-cog" title="Settings"><Icons.Cog size={21} /></button>
    </div>
  );
}

/* ============================ product card ============================ */
function ProductCard({ p, qty, onAdd }) {
  const st = stockState(p.stock);
  const out = st === 'out';
  const c = colorFor(p.name);
  return (
    <button className={`pos-card ${out ? 'is-out' : ''}`} onClick={() => !out && onAdd(p)} disabled={out}>
      <div className="pos-thumb" style={{ background: c }}>
        <span className="pos-thumb-abbr">{abbr(p.name)}</span>
        {qty > 0 && <span className="pos-in-cart"><Icons.Check size={12} />{qty}</span>}
        {st === 'low' && <span className="pos-stock-badge low"><Icons.Warn size={11} />Low</span>}
        {out && <span className="pos-stock-badge out">Out</span>}
      </div>
      <div className="pos-card-body">
        <div className="pos-card-name">{p.name}</div>
        <div className="pos-card-bcd">BCD: {p.id}</div>
        <div className="pos-card-foot">
          <span className="pos-card-price"><small>RWF</small> {money(p.price)}</span>
          <span className={`pos-card-stock ${st}`}>{out ? 'Out of stock' : `${p.stock} in stock`}</span>
        </div>
      </div>
    </button>
  );
}

/* ============================ cart line ============================ */
function CartLine({ line, onInc, onDec, onDel }) {
  return (
    <div className="pos-line">
      <span className="pos-line-sw" style={{ background: colorFor(line.name) }}>{abbr(line.name)}</span>
      <div className="pos-line-mid">
        <div className="pos-line-name">{line.name}</div>
        <div className="pos-line-unit">RWF {money(line.price)} each</div>
      </div>
      <div className="pos-step">
        <button className="pos-step-btn" onClick={() => onDec(line.id)}><Icons.Minus size={15} /></button>
        <span className="pos-step-qty">{line.qty}</span>
        <button className="pos-step-btn" onClick={() => onInc(line.id)}><Icons.Plus size={15} /></button>
      </div>
      <span className="pos-line-total">{money(line.price * line.qty)}</span>
      <button className="pos-line-del" onClick={() => onDel(line.id)}><Icons.Trash size={17} /></button>
    </div>
  );
}

/* ============================ app ============================ */
function POS({ tweaks }) {
  const [cart, setCart] = usePos({});          // id -> qty
  const [tender, setTender] = usePos('');
  const [page, setPage] = usePos(1);
  const [query, setQuery] = usePos('');

  const products = usePosMemo(() => {
    const q = query.trim().toLowerCase();
    return q ? PRODUCTS.filter((p) => p.name.toLowerCase().includes(q) || String(p.id).includes(q)) : PRODUCTS;
  }, [query]);

  const lines = usePosMemo(() =>
    Object.entries(cart).map(([id, qty]) => {
      const p = PRODUCTS.find((x) => x.id === +id);
      return { ...p, qty };
    }).filter((l) => l.name), [cart]);

  const total = lines.reduce((s, l) => s + l.price * l.qty, 0);
  const count = lines.reduce((s, l) => s + l.qty, 0);
  const tenderNum = parseFloat(String(tender).replace(/[^\d.]/g, '')) || 0;
  const change = Math.max(0, tenderNum - total);

  const add = (p) => setCart((c) => ({ ...c, [p.id]: Math.min(p.stock, (c[p.id] || 0) + 1) }));
  const inc = (id) => { const p = PRODUCTS.find((x) => x.id === id); setCart((c) => ({ ...c, [id]: Math.min(p.stock, (c[id] || 0) + 1) })); };
  const dec = (id) => setCart((c) => {
    const n = (c[id] || 0) - 1; const nx = { ...c };
    if (n <= 0) delete nx[id]; else nx[id] = n; return nx;
  });
  const del = (id) => setCart((c) => { const nx = { ...c }; delete nx[id]; return nx; });
  const clearAll = () => { setCart({}); setTender(''); };

  const txid = 'c8e33018-008c-4197-b3a9-4e6a362ff828';

  return (
    <div className="pos">
      <TopBar />
      <div className="pos-body">
        <Rail />

        {/* catalog */}
        <div className="pos-catalog">
          <div className="pos-search-row">
            <div className="pos-search">
              <Icons.Search size={20} color="var(--ink-3)" />
              <input placeholder="Search products…" value={query} onChange={(e) => { setQuery(e.target.value); setPage(1); }} />
            </div>
            <button className="pos-scan" title="Scan barcode"><Icons.Barcode size={22} /></button>
          </div>

          <div className="pos-meta-row">
            <span className="pos-count">Showing <b>1–{products.length}</b> of <b>194</b> results</span>
            <button className="pos-sort">Sort by latest <Icons.ChevDown size={16} /></button>
          </div>

          <div className="pos-grid-scroll">
            <div className="pos-grid">
              {products.map((p) => <ProductCard key={p.id} p={p} qty={cart[p.id] || 0} onAdd={add} />)}
            </div>
          </div>

          <div className="pos-pager">
            <div className="pos-pages">
              <button className="pos-page arrow" onClick={() => setPage((x) => Math.max(1, x - 1))}><Icons.ChevLeft size={18} /></button>
              {[1, 2, 3].map((n) => (
                <button key={n} className={`pos-page ${page === n ? 'is-on' : ''}`} onClick={() => setPage(n)}>{n}</button>
              ))}
            </div>
            <button className="pos-pageinfo" onClick={() => setPage((x) => Math.min(13, x + 1))}>
              <Icons.ChevRight size={16} /> Page {page} of 13
            </button>
          </div>
        </div>

        {/* cart */}
        <div className="pos-cart">
          <div className="pos-cart-head">
            <div className="pos-chips">
              <span className="pos-chip accent">Amount to Change: <span className="mono">RWF {money(change)}</span></span>
              <span className="pos-chip pos-chip-txid"><span className="v">Txn ID: {txid}</span></span>
              <span className="pos-chip"><span className="mono">Invoice No: 1</span></span>
            </div>
          </div>

          <div className="pos-cust">
            <div className="pos-cust-search">
              <Icons.Search size={19} color="var(--blue)" />
              <input placeholder="Search Customer" />
            </div>
            <div className="pos-cust-actions">
              <button className="pos-cust-act" title="Walk-in"><Icons.Walk size={20} /></button>
              <button className="pos-cust-act" title="Quick add"><Icons.ArrowUpRight size={18} /></button>
              <button className="pos-cust-act" title="Support"><Icons.Phone size={18} /></button>
              <button className="pos-cust-act" title="Add customer"><Icons.User size={18} /></button>
            </div>
          </div>

          <div className="pos-lines">
            {lines.length === 0 ? (
              <div className="pos-empty">
                <span className="pos-empty-ic"><Icons.Cart size={34} /></span>
                <div className="pos-empty-h">No items yet</div>
                <div className="pos-empty-p">Tap a product to start a sale</div>
              </div>
            ) : (
              lines.map((l) => <CartLine key={l.id} line={l} onInc={inc} onDec={dec} onDel={del} />)
            )}
          </div>

          <div className="pos-foot">
            <div className="pos-total-row">
              <span className="pos-total-lbl">Grand Total{count > 0 ? ` · ${count} item${count > 1 ? 's' : ''}` : ''}</span>
              <span className="pos-total-val"><small>RWF</small> {money(total)}</span>
            </div>
            {tenderNum > 0 && (
              <div className="pos-subtle">
                <span>Tendered <span className="mono">RWF {money(tenderNum)}</span></span>
                <span>Change <span className="mono" style={{ color: 'var(--gain-ink)' }}>RWF {money(change)}</span></span>
              </div>
            )}

            <div className="pos-tender">
              <div className="pos-tender-field">
                <input inputMode="decimal" placeholder="0.0" value={tender} onChange={(e) => setTender(e.target.value)} />
                <span className="pos-tender-cur">RWF</span>
              </div>
              <div className="pos-method">
                <span className="pos-method-ic"><Icons.Wallet size={15} /></span>
                CASH
                <span className="pos-method-chev"><Icons.ChevDown size={16} /></span>
              </div>
            </div>

            <div className="pos-quickcash">
              {[total, 5000, 10000, 20000].map((v, i) => (
                <button key={i} className="pos-qc" onClick={() => setTender(String(v))} disabled={v === 0}>
                  {i === 0 ? 'Exact' : money(v)}
                </button>
              ))}
            </div>

            <div className="pos-actions">
              <button className="pos-btn pos-btn-ghost" onClick={clearAll}>Tickets</button>
              <button className="pos-btn pos-btn-pay" disabled={total === 0}>
                Pay <span className="amt">RWF {money(total)}</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

window.POSApp = POS;
