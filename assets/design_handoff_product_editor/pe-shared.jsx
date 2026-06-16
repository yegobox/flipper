/* Shared data, color system, and field/variant primitives for the product
   editor. Exposed on window for the two direction files. */

const { useState: useS, useRef: useR, useEffect: useE } = React;

/* ---------------- domain data ---------------- */
const PACKAGING = ['Ampoule : Ampoule', 'Each : 1 unit', 'Box : 12 units', 'Carton : 24 units', 'Bottle : 750 ml', 'Sachet : 1 unit'];
const CLASSIFICATIONS = ['Finished Product', 'Raw Material', 'Service', 'Consumable', 'Composite'];
const ORIGINS = ['Rwanda (RW)', 'Kenya (KE)', 'Uganda (UG)', 'Tanzania (TZ)', 'Ascension Island (AC)'];
const CATEGORY_SUGGEST = ['Beverages', 'Snacks', 'Personal Care', 'Household', 'Stationery'];
const UNITS = ['Per Item', 'Per Kg', 'Per Litre', 'Per Box', 'Per Pack'];
const TAX_CODES = ['A', 'B', 'C', 'D'];
const TAX_PRODUCTS = ['Fanta 5020230601', 'Coca-Cola 5020230602', 'Inyange Water 5020230610', 'Standard Goods 0000000000'];
const PRODUCTS = [
  { name: 'Mango Mango', cost: 150 },
  { name: 'Umuceri Umuceri', cost: 400 },
  { name: 'Sugar (1kg)', cost: 900 },
  { name: 'Fresh Milk (1L)', cost: 700 },
  { name: 'Wheat Flour (1kg)', cost: 1100 },
  { name: 'Cooking Oil (1L)', cost: 2300 },
  { name: 'Bottled Water (500ml)', cost: 300 },
  { name: 'Tea Leaves (250g)', cost: 1200 }];

/* ---------------- color system ---------------- */
function hslToHex(h, s, l) {
  s /= 100;l /= 100;
  const k = (n) => (n + h / 30) % 12;
  const a = s * Math.min(l, 1 - l);
  const f = (n) => {
    const c = l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));
    return Math.round(255 * c).toString(16).padStart(2, '0');
  };
  return `#${f(0)}${f(8)}${f(4)}`;
}
const HUES = [
{ name: 'Red', h: 4, s: 78 },
{ name: 'Orange', h: 24, s: 88 },
{ name: 'Amber', h: 40, s: 92 },
{ name: 'Green', h: 145, s: 58 },
{ name: 'Teal', h: 178, s: 62 },
{ name: 'Blue', h: 218, s: 84 },
{ name: 'Indigo', h: 244, s: 62 },
{ name: 'Violet', h: 270, s: 60 },
{ name: 'Slate', h: 214, s: 18 }];

// 10 shades light→dark
const SHADE_L = [95, 88, 79, 69, 60, 52, 45, 38, 31, 24];
function makeShades(hue) {
  return SHADE_L.map((l, i) => hslToHex(hue.h, Math.min(96, hue.s + (i < 2 ? -8 : 0)), l));
}
function defaultColor() {
  const hue = HUES[5]; // Blue
  return { hueName: hue.name, shadeIdx: 5, hex: makeShades(hue)[5] };
}

/* ---------------- shared product state ---------------- */
function useProduct(seed) {
  const [composite, setComposite] = useS(false);
  const [name, setName] = useS('Fight until the end');
  const [retail, setRetail] = useS('200');
  const [supply, setSupply] = useS('400');
  const [color, setColor] = useS(defaultColor());
  const [packaging, setPackaging] = useS(PACKAGING[0]);
  const [cats, setCats] = useS(['Beverages']);
  const [classification, setClassification] = useS(CLASSIFICATIONS[0]);
  const [origin, setOrigin] = useS(ORIGINS[4]);
  const [variants, setVariants] = useS(seed || []);

  // composite (bill of materials)
  const [sku, setSku] = useS('');
  const [barcode, setBarcode] = useS('');
  const [components, setComponents] = useS([
    { id: 1, name: 'Mango Mango', qty: 1, cost: 150 },
    { id: 2, name: 'Umuceri Umuceri', qty: 1, cost: 400 }]
  );
  const addComponent = (name, cost = 0) => setComponents((c) => c.some((x) => x.name === name) ? c : [...c, { id: Date.now() + Math.random(), name, qty: 1, cost }]);
  const patchComponent = (id, p) => setComponents((c) => c.map((x) => x.id === id ? { ...x, ...p } : x));
  const removeComponent = (id) => setComponents((c) => c.filter((x) => x.id !== id));
  const compTotal = components.reduce((s, x) => s + (parseFloat(x.cost) || 0) * (parseFloat(x.qty) || 0), 0);

  const addVariant = (vName) => {
    const nm = (vName || '').trim();
    if (!nm) return;
    setVariants((v) => [...v, {
      id: Date.now() + Math.random(), name: nm, price: retail || '0', qty: 0,
      lowStock: 0, tax: 'B', discount: 0, unit: 'Per Item',
      classification: TAX_PRODUCTS[0], expiration: '', image: null
    }]);
  };
  const patchVariant = (id, p) => setVariants((v) => v.map((x) => x.id === id ? { ...x, ...p } : x));
  const removeVariant = (id) => setVariants((v) => v.filter((x) => x.id !== id));

  const margin = (() => {
    const r = parseFloat(retail) || 0,s = composite ? compTotal : parseFloat(supply) || 0;
    const profit = r - s;
    const pct = r > 0 ? profit / r * 100 : 0;
    return { profit, pct };
  })();

  return {
    composite, setComposite, name, setName, retail, setRetail, supply, setSupply,
    color, setColor, packaging, setPackaging, cats, setCats,
    classification, setClassification, origin, setOrigin,
    variants, addVariant, patchVariant, removeVariant, margin,
    sku, setSku, barcode, setBarcode,
    components, addComponent, patchComponent, removeComponent, compTotal
  };
}

/* ---------------- field primitives ---------------- */
function Field({ label, required, optional, hint, children }) {
  return (
    <div className="pe-field">
      {label &&
      <label className="pe-label">
          {label}
          {required && <span className="req">*</span>}
          {optional && <span className="opt">· optional</span>}
        </label>
      }
      {children}
      {hint && <div className="pe-hint"><Icons.Info size={13} />{hint}</div>}
    </div>);

}

function TextInput({ value, onChange, placeholder, pre, suf, mono, type = 'text' }) {
  return (
    <div className={`pe-input ${value ? 'is-filled' : ''}`}>
      {pre && <span className="pre">{pre}</span>}
      <input type={type} value={value} placeholder={placeholder} className={mono ? 'mono' : ''}
      onChange={(e) => onChange(e.target.value)} />
      {suf && <span className="suf">{suf}</span>}
    </div>);

}

function SelectInput({ value, onChange, options }) {
  return (
    <div className="pe-select">
      <select value={value} onChange={(e) => onChange(e.target.value)}>
        {options.map((o) => <option key={o} value={o}>{o}</option>)}
      </select>
      <span className="chev"><Icons.ChevDown size={18} /></span>
    </div>);

}

function Toggle({ on, onChange, title, desc }) {
  return (
    <div className="pe-toggle-row">
      <div className="pe-card-ico violet"><Icons.Layers size={17} /></div>
      <div className="tx">
        <div className="pe-toggle-t">{title}</div>
        <div className="pe-toggle-d">{desc}</div>
      </div>
      <button className={`pe-switch ${on ? 'on' : ''}`} onClick={() => onChange(!on)} aria-pressed={on} aria-label={title} />
    </div>);

}

/* ---------------- inline color picker ---------------- */
function ColorBlock({ color, setColor }) {
  const [open, setOpen] = useS(false);
  const [tab, setTab] = useS('Primary');
  const ref = useR(null);
  useE(() => {
    if (!open) return;
    const off = (e) => {if (ref.current && !ref.current.contains(e.target)) setOpen(false);};
    document.addEventListener('pointerdown', off, true);
    return () => document.removeEventListener('pointerdown', off, true);
  }, [open]);
  const hue = HUES.find((h) => h.name === color.hueName) || HUES[5];
  const shades = makeShades(hue);
  return (
    <div className="pe-color">
      <div className="pe-color-chip" style={{ background: color.hex }}>
        <span className="ph"><Icons.Palette size={24} /></span>
      </div>
      <div className="pe-color-txt">
        <div className="pe-color-name">{color.hueName} · shade {color.shadeIdx + 1}</div>
        <div className="pe-color-d">Used as the product's swatch across POS &amp; reports</div>
      </div>
      <div className="pe-color-trigger" ref={ref}>
        <button className="pe-btn-soft pe-btn" style={{ height: 42, padding: '0 16px' }} onClick={() => setOpen((o) => !o)}>
          <Icons.Palette size={16} /> Choose color
        </button>
        {open &&
        <div className="pe-pop" style={{ right: 0 }}>
            <div className="pe-pop-seg">
              {['Primary', 'Accent', 'Wheel'].map((t) =>
            <button key={t} className={tab === t ? 'on' : ''} onClick={() => setTab(t)}>{t}</button>
            )}
            </div>
            <div className="pe-hues">
              {HUES.map((h) => {
              const sh = makeShades(h);
              return (
                <button key={h.name} className={`pe-hue ${color.hueName === h.name ? 'on' : ''}`}
                style={{ background: sh[5] }} title={h.name}
                onClick={() => setColor({ hueName: h.name, shadeIdx: color.shadeIdx, hex: sh[color.shadeIdx] })} />);

            })}
            </div>
            <div className="pe-shade-lbl">Select color shade</div>
            <div className="pe-shades">
              {shades.map((hex, i) =>
            <button key={i} className="pe-shade" style={{ background: hex }}
            onClick={() => {setColor({ hueName: hue.name, shadeIdx: i, hex });}}>
                  {color.shadeIdx === i && <Icons.Check size={13} />}
                </button>
            )}
            </div>
          </div>
        }
      </div>
    </div>);

}

/* ---------------- category multi-select ---------------- */
function CategoryPicker({ cats, setCats }) {
  const [q, setQ] = useS('');
  const add = (c) => {const v = (c || q).trim();if (v && !cats.includes(v)) setCats([...cats, v]);setQ('');};
  const remaining = CATEGORY_SUGGEST.filter((c) => !cats.includes(c));
  return (
    <div>
      <div className="pe-search">
        <Icons.Search size={18} />
        <input value={q} placeholder="Search categories…"
        onChange={(e) => setQ(e.target.value)}
        onKeyDown={(e) => {if (e.key === 'Enter') {e.preventDefault();add();}}} />
        <button className="add" onClick={() => add()} aria-label="Add category"><Icons.Plus size={18} /></button>
      </div>
      {cats.length > 0 &&
      <div className="pe-chips">
          {cats.map((c) =>
        <span className="pe-chip" key={c}>{c}
              <button onClick={() => setCats(cats.filter((x) => x !== c))} aria-label={`Remove ${c}`}><Icons.X size={13} /></button>
            </span>
        )}
        </div>
      }
      {remaining.length > 0 &&
      <div className="pe-suggest">
          {remaining.map((c) =>
        <button className="sg" key={c} onClick={() => add(c)}><Icons.Plus size={12} />{c}</button>
        )}
        </div>
      }
    </div>);

}

/* ---------------- quick scan ---------------- */
function QuickScan({ onAdd }) {
  const [v, setV] = useS('');
  const go = () => {if (v.trim()) {onAdd(v);setV('');}};
  return (
    <div>
      <div className="pe-scan">
        <span className="bc"><Icons.Barcode size={22} /></span>
        <input value={v} placeholder="Scan barcode or type a variant name…"
        onChange={(e) => setV(e.target.value)}
        onKeyDown={(e) => {if (e.key === 'Enter') {e.preventDefault();go();}}} />
        <button className="go" onClick={go}><Icons.Plus size={15} /> Add variant</button>
      </div>
      <div className="pe-scan-hint"><Icons.Scan size={13} /> Point a scanner at the field, or type and press <kbd>Enter</kbd> to create a variant.</div>
    </div>);

}

/* ---------------- quantity stepper popover ---------------- */
function QtyCell({ variant, patch }) {
  const [open, setOpen] = useS(false);
  const [val, setVal] = useS(variant.qty);
  const [pos, setPos] = useS(null);
  const btnRef = useR(null);
  const popRef = useR(null);

  const place = () => {
    const b = btnRef.current; if (!b) return;
    const r = b.getBoundingClientRect();
    const W = 288, H = 250, M = 10;
    const left = Math.min(Math.max(M, r.left), window.innerWidth - W - M);
    let top = r.bottom + 8;
    if (top + H > window.innerHeight - M) top = Math.max(M, r.top - H - 8);
    setPos({ left, top });
  };

  useE(() => {
    if (!open) return;
    setVal(variant.qty);
    place();
    const off = (e) => {
      if (btnRef.current && btnRef.current.contains(e.target)) return;
      if (popRef.current && popRef.current.contains(e.target)) return;
      setOpen(false);
    };
    const close = () => setOpen(false);
    const onKey = (e) => { if (e.key === 'Escape') setOpen(false); };
    document.addEventListener('pointerdown', off, true);
    window.addEventListener('resize', close);
    window.addEventListener('scroll', close, true);
    document.addEventListener('keydown', onKey);
    return () => {
      document.removeEventListener('pointerdown', off, true);
      window.removeEventListener('resize', close);
      window.removeEventListener('scroll', close, true);
      document.removeEventListener('keydown', onKey);
    };
  }, [open]);

  return (
    <>
      <button className="pe-qty" ref={btnRef} onClick={() => setOpen((o) => !o)}>
        {(+variant.qty).toFixed(1)} <Icons.Pencil size={13} />
      </button>
      {open && pos && ReactDOM.createPortal(
        <div className="pe" style={{ position: 'fixed', inset: 0, pointerEvents: 'none', zIndex: 70 }}>
          <div className="pe-pop pe-qtypop" ref={popRef}
            style={{ position: 'fixed', top: pos.top, left: pos.left, width: 288, margin: 0, pointerEvents: 'auto' }}>
            <div className="pe-qtypop-head">
              <div className="ic"><Icons.Box size={18} /></div>
              <div className="tt">
                <div className="t">Edit quantity</div>
                <div className="d">{variant.name}</div>
              </div>
              <button className="x" onClick={() => setOpen(false)} aria-label="Close"><Icons.X size={16} /></button>
            </div>
            <div className="pe-stepper" style={{ marginTop: 16 }}>
              <button className="pe-step-btn minus" onClick={() => setVal((q) => Math.max(0, +(q - 1).toFixed(1)))}><Icons.Minus size={20} /></button>
              <div className="pe-step-val">{(+val).toFixed(1)}</div>
              <button className="pe-step-btn plus" onClick={() => setVal((q) => +(q + 1).toFixed(1))}><Icons.Plus size={20} /></button>
            </div>
            <button className="pe-btn pe-btn-primary" style={{ width: '100%', marginTop: 14 }}
              onClick={() => { patch({ qty: val }); setOpen(false); }}>Update stock</button>
          </div>
        </div>,
        document.body
      )}
    </>);

}

/* ---------------- variant card (responsive · no horizontal scroll) ---------------- */
function VField({ label, children }) {
  return (
    <div className="pe-vf">
      <span className="pe-vf-label">{label}</span>
      {children}
    </div>);

}

function VariantCard({ variant: v, patch, remove, selectable, selected, onToggleSel }) {
  return (
    <div className={`pe-vrow ${selected ? 'sel' : ''}`}>
      <div className="pe-vrow-head">
        {selectable &&
          <span className={`pe-checkbox ${selected ? 'on' : ''}`} onClick={onToggleSel}>{selected && <Icons.Check size={13} />}</span>}
        <div className="pe-cellphoto" title="Add photo"><Icons.Camera size={17} /></div>
        <div className="meta">
          <div className="nm">{v.name}</div>
          <div className="sub">{v.classification}</div>
        </div>
        <button className="pe-trash" onClick={() => remove(v.id)} aria-label="Delete variant"><Icons.Trash size={17} /></button>
      </div>
      <div className="pe-vfields">
        <VField label="Price">
          <div className="pe-vfbox"><span className="pre">RWF</span><input className="mono" value={v.price} onChange={(e) => patch(v.id, { price: e.target.value.replace(/[^\d.]/g, '') })} /></div>
        </VField>
        <VField label="Quantity"><QtyCell variant={v} patch={(x) => patch(v.id, x)} /></VField>
        <VField label="Low stock">
          <div className="pe-vfbox"><input className="mono" value={v.lowStock} placeholder="0" onChange={(e) => patch(v.id, { lowStock: e.target.value.replace(/\D/g, '') })} /></div>
        </VField>
        <VField label="Tax">
          <div className="pe-tsel"><select value={v.tax} onChange={(e) => patch(v.id, { tax: e.target.value })}>{TAX_CODES.map((t) => <option key={t}>{t}</option>)}</select><span className="chev"><Icons.ChevDown size={14} /></span></div>
        </VField>
        <VField label="Discount">
          <div className="pe-vfbox"><input className="mono" value={v.discount} placeholder="0" onChange={(e) => patch(v.id, { discount: e.target.value.replace(/\D/g, '') })} /><span className="suf">%</span></div>
        </VField>
        <VField label="Unit">
          <div className="pe-tsel"><select value={v.unit} onChange={(e) => patch(v.id, { unit: e.target.value })}>{UNITS.map((u) => <option key={u}>{u}</option>)}</select><span className="chev"><Icons.ChevDown size={14} /></span></div>
        </VField>
        <VField label="Classification">
          <div className="pe-tsel"><select value={v.classification} onChange={(e) => patch(v.id, { classification: e.target.value })}>{TAX_PRODUCTS.map((c) => <option key={c}>{c}</option>)}</select><span className="chev"><Icons.ChevDown size={14} /></span></div>
        </VField>
        <VField label="Expiration">
          <button className="pe-vfbox pe-vexp"><Icons.Calendar size={15} /><span>{v.expiration || 'Set date'}</span></button>
        </VField>
      </div>
    </div>);

}

function VariantList({ variants, patch, remove }) {
  const [sel, setSel] = useS([]);
  const allOn = sel.length === variants.length && variants.length > 0;
  const toggleAll = () => setSel(allOn ? [] : variants.map((v) => v.id));
  const toggle = (id) => setSel((s) => s.includes(id) ? s.filter((x) => x !== id) : [...s, id]);
  return (
    <div>
      <div className="pe-vtools">
        <span className={`pe-checkbox ${allOn ? 'on' : ''}`} onClick={toggleAll}>{allOn && <Icons.Check size={13} />}</span>
        <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--ink-2)' }}>{sel.length ? `${sel.length} selected` : 'Select all'}</span>
      </div>
      <div className="pe-vlist">
        {variants.map((v) =>
          <VariantCard key={v.id} variant={v} patch={patch} remove={remove}
            selectable selected={sel.includes(v.id)} onToggleSel={() => toggle(v.id)} />
        )}
      </div>
    </div>);

}

/* ---------------- adaptive variant area ---------------- */
function VariantArea({ p }) {
  if (p.variants.length === 0) {
    return (
      <div className="pe-var-empty">
        <div className="ic"><Icons.Box size={22} /></div>
        <div className="t">No variants yet</div>
        <div className="d">Scan or type above to add the first one. Single-variant products stay simple.</div>
      </div>);

  }
  if (p.variants.length === 1) {
    return (
      <>
        <div className="pe-var-bar">
          <span className="pe-var-count"><span className="n">1</span> variant</span>
        </div>
        <div className="pe-vlist">
          <VariantCard variant={p.variants[0]} patch={p.patchVariant} remove={p.removeVariant} />
        </div>
      </>);

  }
  return (
    <>
      <div className="pe-var-bar">
        <span className="pe-var-count"><span className="n">{p.variants.length}</span> variants</span>
      </div>
      <VariantList variants={p.variants} patch={p.patchVariant} remove={p.removeVariant} />
    </>);

}

/* ---------------- composite: bill-of-materials builder ---------------- */
function ComponentsBuilder({ p }) {
  const [q, setQ] = useS('');
  const [open, setOpen] = useS(false);
  const ref = useR(null);
  useE(() => {
    if (!open) return;
    const off = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    document.addEventListener('pointerdown', off, true);
    return () => document.removeEventListener('pointerdown', off, true);
  }, [open]);
  const added = new Set(p.components.map((c) => c.name));
  const results = PRODUCTS.filter((x) => !added.has(x.name) && x.name.toLowerCase().includes(q.toLowerCase()));
  const pick = (prod) => { p.addComponent(prod.name, prod.cost); setQ(''); setOpen(false); };
  return (
    <div>
      <div className="pe-search" ref={ref} style={{ position: 'relative' }}>
        <Icons.Search size={18} />
        <input value={q} placeholder="Search products to add as components…"
          onFocus={() => setOpen(true)}
          onChange={(e) => { setQ(e.target.value); setOpen(true); }} />
        <span className="pe-allprod">All Products <Icons.ChevDown size={14} /></span>
        <button className="add" onClick={() => setOpen((o) => !o)} aria-label="Add component"><Icons.Plus size={18} /></button>
        {open &&
          <div className="pe-prod-dd pe-scroll">
            {results.length === 0 ?
              <div className="pe-prod-empty">No matching products</div> :
              results.map((r) =>
                <button key={r.name} className="pe-prod-opt" onClick={() => pick(r)}>
                  <span className="ic"><Icons.Box size={16} /></span>
                  <span className="nm">{r.name}</span>
                  <span className="cost">RWF {r.cost.toLocaleString()}</span>
                </button>
              )}
          </div>}
      </div>

      <div className="pe-var-bar">
        <span className="pe-var-count"><span className="n">{p.components.length}</span> {p.components.length === 1 ? 'component' : 'components'}</span>
      </div>

      {p.components.length === 0 ?
        <div className="pe-var-empty">
          <div className="ic"><Icons.Layers size={22} /></div>
          <div className="t">No components yet</div>
          <div className="d">Search above to add the products this item is built from.</div>
        </div> :
        <div className="pe-vlist">
          {p.components.map((c) =>
            <div className="pe-vrow" key={c.id}>
              <div className="pe-vrow-head">
                <div className="pe-cellphoto" title="Component" style={{ borderStyle: 'solid', color: 'var(--violet)', background: '#F3EEFB', borderColor: '#E6DBF7' }}><Icons.Box size={17} /></div>
                <div className="meta">
                  <div className="nm">{c.name}</div>
                  <div className="sub">Line total · RWF {((parseFloat(c.cost) || 0) * (parseFloat(c.qty) || 0)).toLocaleString()}</div>
                </div>
                <button className="pe-trash" onClick={() => p.removeComponent(c.id)} aria-label="Remove component"><Icons.Trash size={17} /></button>
              </div>
              <div className="pe-vfields" style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(160px, 1fr))' }}>
                <VField label="Quantity">
                  <div className="pe-vfbox"><input className="mono" value={c.qty} onChange={(e) => p.patchComponent(c.id, { qty: e.target.value.replace(/[^\d.]/g, '') })} /></div>
                </VField>
                <VField label="Unit cost">
                  <div className="pe-vfbox"><span className="pre">RWF</span><input className="mono" value={c.cost} onChange={(e) => p.patchComponent(c.id, { cost: e.target.value.replace(/[^\d.]/g, '') })} /></div>
                </VField>
              </div>
            </div>
          )}
        </div>}

      <div className="pe-margin" style={{ marginTop: 14 }}>
        <div className="pe-margin-row"><span className="k">Components</span><span className="v">{p.components.length}</span></div>
        <div className="pe-margin-row big">
          <span className="k">Supply cost (auto)</span>
          <span className="v" style={{ color: 'var(--ink-1)' }}>RWF {p.compTotal.toLocaleString()}</span>
        </div>
      </div>
    </div>);

}

Object.assign(window, {
  PACKAGING, CLASSIFICATIONS, ORIGINS, CATEGORY_SUGGEST, UNITS, TAX_CODES, TAX_PRODUCTS, PRODUCTS,
  HUES, makeShades, defaultColor, useProduct,
  Field, TextInput, SelectInput, Toggle, ColorBlock, CategoryPicker, QuickScan, VariantArea, ComponentsBuilder
});