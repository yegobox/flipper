/* record-purchase-modal.jsx — Record Purchase as an in-app modal over the live screen.
   Exports window.RecordPurchaseModal({ onClose, onSaved }). Styles: record-purchase.css (.rp scope). */

(function () {
  const { useState, useMemo, useRef, useEffect } = React;

  const RI = {
    receipt: (p) => (<svg width="22" height="22" viewBox="0 0 24 24" fill="none" {...p}><path d="M5 3.5h9.5L19 8v12.5l-2-1-2 1-2-1-2 1-2-1-2 1V3.5Z" stroke="currentColor" strokeWidth="1.6" strokeLinejoin="round"/><path d="M14 3.5V8h4.5M8 11h6M8 14.5h4" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"/></svg>),
    x: (p) => (<svg width="20" height="20" viewBox="0 0 24 24" fill="none" {...p}><path d="M6 6l12 12M18 6L6 18" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round"/></svg>),
    search: (p) => (<svg width="17" height="17" viewBox="0 0 24 24" fill="none" {...p}><circle cx="11" cy="11" r="7" stroke="currentColor" strokeWidth="1.7"/><path d="m20 20-3.2-3.2" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round"/></svg>),
    plus: (p) => (<svg width="16" height="16" viewBox="0 0 24 24" fill="none" {...p}><path d="M12 5v14M5 12h14" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round"/></svg>),
    chev: (p) => (<svg width="16" height="16" viewBox="0 0 24 24" fill="none" {...p}><path d="m6 9 6 6 6-6" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/></svg>),
    cal: (p) => (<svg width="18" height="18" viewBox="0 0 24 24" fill="none" {...p}><rect x="3.5" y="5" width="17" height="15" rx="2.5" stroke="currentColor" strokeWidth="1.6"/><path d="M3.5 9.5h17M8 3.5v3M16 3.5v3" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>),
    trash: (p) => (<svg width="17" height="17" viewBox="0 0 24 24" fill="none" {...p}><path d="M5 7h14M10 7V5.5A1.5 1.5 0 0 1 11.5 4h1A1.5 1.5 0 0 1 14 5.5V7m4 0-.8 11.2A2 2 0 0 1 15.2 20H8.8a2 2 0 0 1-2-1.8L6 7" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"/></svg>),
    check: (p) => (<svg width="18" height="18" viewBox="0 0 24 24" fill="none" {...p}><path d="m5 12.5 4.5 4.5L19 7" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>),
    box: (p) => (<svg width="22" height="22" viewBox="0 0 24 24" fill="none" {...p}><path d="M12 3 4 7v10l8 4 8-4V7l-8-4Z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/><path d="m4 7 8 4 8-4M12 21V11" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/></svg>),
  };

  const CATS = {
    A: { label: "A · Exempt", taxable: false },
    B: { label: "B · 18%", taxable: true },
    C: { label: "C · Zero", taxable: false },
    D: { label: "D · Deemed", taxable: false },
  };
  const VAT_RATE = 0.18;
  const CATALOG = [
    { name: "A4 Paper Ream (80gsm)", cat: "B", price: 18000 },
    { name: "HP Printer Toner 26A", cat: "B", price: 245000 },
    { name: "Diesel Fuel", cat: "B", price: 5180, unit: "litre" },
    { name: "Bottled Water (case of 24)", cat: "A", price: 24000 },
    { name: "Maize Flour 50kg", cat: "A", price: 132000 },
    { name: "Medical Supplies Kit", cat: "A", price: 96000 },
    { name: "Exported Coffee Beans", cat: "C", price: 410000 },
    { name: "Bank Withholding Fee", cat: "D", price: 15000 },
    { name: "Laptop Repair Service", cat: "B", price: 80000 },
  ];
  const PAYMENTS = ["01 – Cash", "02 – Credit", "03 – Cash/Credit", "04 – Bank transfer", "05 – Mobile money"];
  const rfmt = (n) => n === 0 ? "0" : new Intl.NumberFormat("en-US").format(Math.round(n));
  let _ruid = 1; const ruid = () => _ruid++;

  function Field({ label, opt, children }) {
    return (
      <div className="field">
        <label>{label}{opt && <span className="opt"> (optional)</span>}</label>
        {children}
      </div>
    );
  }

  function Catalog({ onPick, onClose }) {
    const [q, setQ] = useState("");
    const ref = useRef(null);
    useEffect(() => {
      const h = (e) => { if (ref.current && !ref.current.contains(e.target)) onClose(); };
      document.addEventListener("mousedown", h);
      return () => document.removeEventListener("mousedown", h);
    }, []);
    const list = CATALOG.filter((c) => c.name.toLowerCase().includes(q.toLowerCase()));
    return (
      <div className="catalog" ref={ref}>
        <div className="cat-search">
          <div className="ctrl-wrap">
            <span className="lead"><RI.search /></span>
            <input autoFocus className="ctrl with-icon" style={{ height: 40 }} placeholder="Search catalog…" value={q} onChange={(e) => setQ(e.target.value)} />
          </div>
        </div>
        <div className="cat-list">
          {list.length === 0 && <div className="cat-empty">No matching items.</div>}
          {list.map((c, i) => (
            <div className="cat-item" key={i} onClick={() => onPick(c)}>
              <div>
                <div className="ci-name">{c.name}</div>
                <div className="ci-meta"><span className={"cat-chip chip-" + c.cat}>{c.cat}</span> {CATS[c.cat].label.split(" · ")[1]}{c.unit ? " · per " + c.unit : ""}</div>
              </div>
              <span className="spacer" />
              <span className="ci-price tnum">{rfmt(c.price)}</span>
              <span className="ci-add"><RI.plus /></span>
            </div>
          ))}
        </div>
      </div>
    );
  }

  function Row({ item, onChange, onDelete }) {
    const net = (parseFloat(item.qty) || 0) * (parseFloat(item.price) || 0);
    const vat = CATS[item.cat].taxable ? net * VAT_RATE : 0;
    return (
      <div className="li-row">
        <div className="li-cell li-name-cell">
          <span className="li-lab">Item</span>
          <input className="li-input name" placeholder="Item description" value={item.name} onChange={(e) => onChange({ ...item, name: e.target.value })} />
        </div>
        <div className="li-cell li-cat-cell">
          <span className="li-lab">Tax category</span>
          <div className="li-selectwrap">
            <select className="li-input" value={item.cat} onChange={(e) => onChange({ ...item, cat: e.target.value })}>
              {Object.keys(CATS).map((k) => <option key={k} value={k}>{CATS[k].label}</option>)}
            </select>
            <span className="chev"><RI.chev /></span>
          </div>
        </div>
        <div className="li-cell">
          <span className="li-lab">Qty</span>
          <input className="li-input num" inputMode="numeric" value={item.qty} onChange={(e) => onChange({ ...item, qty: e.target.value.replace(/[^0-9.]/g, "") })} />
        </div>
        <div className="li-cell">
          <span className="li-lab">Unit price</span>
          <input className="li-input num" inputMode="numeric" value={item.price} onChange={(e) => onChange({ ...item, price: e.target.value.replace(/[^0-9.]/g, "") })} />
        </div>
        <div className="li-cell">
          <span className="li-lab">VAT 18%</span>
          <div className="li-vat tnum">{vat ? rfmt(vat) : "—"}</div>
        </div>
        <div className="li-cell">
          <span className="li-lab">Amount</span>
          <div className="li-amt tnum">{rfmt(net + vat)}</div>
        </div>
        <button className="row-del" onClick={onDelete} title="Remove"><RI.trash /></button>
      </div>
    );
  }

  function RecordPurchaseModal({ onClose, onSaved, showCurrency = true }) {
    const [supplier, setSupplier] = useState("");
    const [tin, setTin] = useState("");
    const [invoice, setInvoice] = useState("");
    const [date, setDate] = useState("11 Jun 2026");
    const [payment, setPayment] = useState(PAYMENTS[0]);
    const [items, setItems] = useState([]);
    const [showCat, setShowCat] = useState(false);

    useEffect(() => {
      const h = (e) => { if (e.key === "Escape") onClose(); };
      document.addEventListener("keydown", h);
      return () => document.removeEventListener("keydown", h);
    }, [onClose]);

    const addNew = () => setItems((s) => [...s, { id: ruid(), name: "", cat: "B", qty: "1", price: "" }]);
    const addFromCatalog = (c) => setItems((s) => [...s, { id: ruid(), name: c.name, cat: c.cat, qty: "1", price: String(c.price) }]);
    const update = (id, v) => setItems((s) => s.map((it) => it.id === id ? v : it));
    const remove = (id) => setItems((s) => s.filter((it) => it.id !== id));

    const totals = useMemo(() => {
      let taxableB = 0, exempt = 0;
      items.forEach((it) => {
        const net = (parseFloat(it.qty) || 0) * (parseFloat(it.price) || 0);
        if (CATS[it.cat].taxable) taxableB += net; else exempt += net;
      });
      const vat = taxableB * VAT_RATE;
      return { taxableB, vat, exempt, total: taxableB + vat + exempt };
    }, [items]);

    const canApprove = supplier.trim() && items.length > 0;
    const save = (status) => { onSaved && onSaved({ supplier, invoice, items, total: totals.total, status }); onClose(); };

    return (
      <div className="rp">
        <div className="scrim" onClick={onClose} />
        <div className="modal-wrap" onMouseDown={(e) => { if (e.target === e.currentTarget) onClose(); }}>
          <div className="modal" role="dialog" aria-modal="true" aria-label="Record Purchase">
            <div className="m-head">
              <div className="icon-badge"><RI.receipt /></div>
              <div>
                <h1>Record Purchase</h1>
                <div className="sub">Capture a supplier invoice and its line items</div>
              </div>
              <span className="spacer" />
              <button className="x-btn" title="Close" onClick={onClose}><RI.x /></button>
            </div>
            <div className="m-divider" />

            <div className="m-body">
              <div className="field-grid">
                <Field label="Supplier">
                  <input className="ctrl" placeholder="Search or enter supplier name" value={supplier} onChange={(e) => setSupplier(e.target.value)} />
                </Field>
                <Field label="Supplier TIN" opt>
                  <input className="ctrl" placeholder="e.g. 1000123456" value={tin} onChange={(e) => setTin(e.target.value)} />
                </Field>
              </div>
              <div className="field-grid row2">
                <Field label="Invoice No.">
                  <input className="ctrl" placeholder="INV-0001" value={invoice} onChange={(e) => setInvoice(e.target.value)} />
                </Field>
                <Field label="Purchase date">
                  <div className="ctrl-wrap">
                    <input className="ctrl" value={date} onChange={(e) => setDate(e.target.value)} />
                    <span className="chev"><RI.cal /></span>
                  </div>
                </Field>
                <Field label="Payment type">
                  <div className="ctrl-wrap">
                    <select className="ctrl" value={payment} onChange={(e) => setPayment(e.target.value)}>
                      {PAYMENTS.map((p) => <option key={p}>{p}</option>)}
                    </select>
                    <span className="chev"><RI.chev /></span>
                  </div>
                </Field>
              </div>

              <div className="li-head">
                <h2>Line items</h2>
                {items.length > 0 && <span className="count">{items.length}</span>}
                <span className="spacer" />
                <div className="pop-anchor">
                  <button className="link-btn" onClick={() => setShowCat((v) => !v)}><RI.search /> Add from catalog</button>
                  {showCat && items.length > 0 && <Catalog onPick={addFromCatalog} onClose={() => setShowCat(false)} />}
                </div>
                <button className="link-btn" onClick={addNew}><RI.plus /> New item</button>
              </div>

              {items.length === 0 ? (
                <div className="li-empty">
                  <div className="e-icon"><RI.box /></div>
                  <p>No items yet — add from your catalog or create a new line.</p>
                  <div className="e-actions">
                    <div className="pop-anchor">
                      <button className="ghost-pill" onClick={() => setShowCat((v) => !v)}><RI.search /> Add from catalog</button>
                      {showCat && <Catalog onPick={addFromCatalog} onClose={() => setShowCat(false)} />}
                    </div>
                    <button className="ghost-pill primary" onClick={addNew}><RI.plus /> New item</button>
                  </div>
                </div>
              ) : (
                <div className="li-table">
                  <div className="li-col-head">
                    <span>Item</span><span>Tax category</span><span className="r">Qty</span><span className="r">Unit price</span><span className="r">VAT 18%</span><span className="r">Amount</span><span />
                  </div>
                  {items.map((it) => (
                    <Row key={it.id} item={it} onChange={(v) => update(it.id, v)} onDelete={() => remove(it.id)} />
                  ))}
                </div>
              )}

              <div className="totals">
                <div className="tstat">
                  <div className="tl">Taxable <span className="badge-cat">B</span></div>
                  <div className="tv tnum">{rfmt(totals.taxableB)}</div>
                </div>
                <div className="tstat">
                  <div className="tl">VAT 18%</div>
                  <div className="tv tnum">{rfmt(totals.vat)}</div>
                </div>
                <div className="tstat">
                  <div className="tl">Exempt / zero <span className="badge-cat" style={{ background: "#eef2f6", color: "#5a6b7b" }}>A+C+D</span></div>
                  <div className="tv tnum">{rfmt(totals.exempt)}</div>
                </div>
                <div className="tspacer" />
                <div className="tstat grand">
                  <div className="tl">Total</div>
                  <div className="tv tnum">{showCurrency && <span className="cur">UGX</span>}{rfmt(totals.total)}</div>
                </div>
              </div>
            </div>

            <div className="m-foot">
              <span className="spacer" />
              <button className="btn btn-ghost" onClick={onClose}>Cancel</button>
              <button className="btn btn-outline" onClick={() => save("waiting")}>Save as Waiting</button>
              <button className="btn btn-primary" disabled={!canApprove} onClick={() => canApprove && save("approved")}><RI.check /> Save &amp; Approve</button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  window.RecordPurchaseModal = RecordPurchaseModal;
})();
