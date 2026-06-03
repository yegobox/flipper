/* ===== Flipper Mobile POS · Catalog screen ===== */
const { useState: useCat, useMemo: useCatMemo } = React;

function StockBadge({ stock }) {
  if (stock === 0) return <span className="mp-stock out">Out of stock</span>;
  if (stock <= 10) return <span className="mp-stock low">{stock} left</span>;
  return <span className="mp-stock">{stock} left</span>;
}

function ProductRow({ p, qty, onAdd, onInc, onDec }) {
  const out = p.stock === 0;
  return (
    <div className={`mp-prod ${out ? 'is-out' : ''}`}>
      <span className="mp-prod-thumb" style={{ background: mpColor(p.name) }}>{mpAbbr(p.name)}</span>
      <div className="mp-prod-mid">
        <div className="mp-prod-name">{p.name}</div>
        <div className="mp-prod-sub">{p.bcd}</div>
      </div>
      <div className="mp-prod-right">
        <span className="mp-prod-price">RWF {mpMoney(p.price)}</span>
        <StockBadge stock={p.stock} />
      </div>
      {qty > 0 ? (
        <div className="mp-qty-pill">
          <button onClick={() => onDec(p.id)} aria-label="Decrease"><Icons.Minus size={16} /></button>
          <span className="n">{qty}</span>
          <button onClick={() => onInc(p)} disabled={qty >= p.stock} aria-label="Increase"><Icons.Plus size={16} /></button>
        </div>
      ) : (
        <button className="mp-add" onClick={() => onAdd(p)} disabled={out} aria-label="Add"><Icons.Plus size={20} /></button>
      )}
    </div>
  );
}

function Catalog({ cart, onAdd, onInc, onDec, count, total, onReview, time }) {
  const [q, setQ] = useCat('');
  const list = useCatMemo(() => {
    const s = q.trim().toLowerCase();
    return s ? MP_PRODUCTS.filter((p) => p.name.toLowerCase().includes(s) || p.bcd.toLowerCase().includes(s)) : MP_PRODUCTS;
  }, [q]);

  return (
    <div className="mp">
      <div className="mp-head">
        <div className="mp-head-row">
          <button className="mp-back" aria-label="Back"><Icons.ChevLeft size={20} /></button>
          <div className="mp-head-titles">
            <div className="mp-head-title">New sale</div>
            <div className="mp-head-meta">Walk-in · {time}</div>
          </div>
          <span className="status-pill"><span className="dot" />PENDING</span>
        </div>
        <div className="mp-tools">
          <div className="mp-search">
            <Icons.Search size={19} />
            <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search products or scan…" />
          </div>
          <button className="mp-scan"><Icons.Barcode size={19} /> Scan</button>
        </div>
      </div>

      <div className="mp-scroll">
        <div className="mp-meta">
          <span className="mp-meta-count">{list.length} of {MP_PRODUCTS.length} products</span>
          <button className="mp-sort">Latest <Icons.ChevDown size={15} /></button>
        </div>
        <div className="mp-list">
          {list.map((p) => (
            <ProductRow key={p.id} p={p} qty={cart[p.id] || 0} onAdd={onAdd} onInc={onInc} onDec={onDec} />
          ))}
          {list.length === 0 && (
            <div style={{ textAlign: 'center', color: 'var(--ink-3)', padding: '40px 0', fontSize: 14 }}>
              No products match “{q}”.
            </div>
          )}
        </div>
      </div>

      <div className="mp-cartbar">
        {count > 0 ? (
          <button className="mp-cartbar-btn" onClick={onReview}>
            <span className="mp-cartbar-badge">{count}</span>
            <span className="mp-cartbar-mid">
              <span className="mp-cartbar-lbl">{count === 1 ? '1 item' : `${count} items`} in cart</span>
              <span className="mp-cartbar-total">RWF {mpMoney(total)}</span>
            </span>
            <span className="mp-cartbar-go">Review &amp; Pay <Icons.ChevRight size={18} /></span>
          </button>
        ) : (
          <div className="mp-cartbar-empty"><Icons.Cart size={18} /> Tap a product to start a sale</div>
        )}
      </div>
    </div>
  );
}

window.Catalog = Catalog;
