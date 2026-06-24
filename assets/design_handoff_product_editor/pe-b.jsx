/* Direction B — settings sheet: left section nav (scroll-spy) + sticky footer.
   Composite toggle swaps the lower sections into a bill-of-materials builder. */

function DirectionB() {
  const p = useProduct([
    { id: 1, name: '22222', price: '200', qty: 0, lowStock: 0, tax: 'B', discount: 0, unit: 'Per Item', classification: TAX_PRODUCTS[0], expiration: '', image: null },
    { id: 2, name: 'Coca-Cola 500ml', price: '250', qty: 48, lowStock: 6, tax: 'B', discount: 5, unit: 'Per Item', classification: TAX_PRODUCTS[1], expiration: 'Jun 2027', image: null }]
  );
  const scrollRef = useR(null);
  const [active, setActive] = useS('basics');
  const composite = p.composite;

  const SECS = composite ?
    [
      { id: 'basics', t: 'Basics', d: 'Name & color', icon: (s) => <Icons.Tag size={s} /> },
      { id: 'pricing', t: 'Pricing & codes', d: 'Price, SKU, barcode', icon: (s) => <Icons.Coins size={s} /> },
      { id: 'components', t: 'Components', d: 'Bill of materials', icon: (s) => <Icons.Layers size={s} /> }] :

    [
      { id: 'basics', t: 'Basics', d: 'Name & color', icon: (s) => <Icons.Tag size={s} /> },
      { id: 'pricing', t: 'Pricing', d: 'Retail & supply', icon: (s) => <Icons.Coins size={s} /> },
      { id: 'inventory', t: 'Inventory', d: 'Category & class', icon: (s) => <Icons.Layers size={s} /> },
      { id: 'variants', t: 'Variants', d: 'Stock & scan', icon: (s) => <Icons.Barcode size={s} /> }];


  const filled = {
    basics: p.name.trim().length > 0,
    pricing: !!p.retail,
    inventory: p.cats.length > 0,
    variants: p.variants.length > 0,
    components: p.components.length > 0
  };
  const doneCount = SECS.filter((s) => filled[s.id]).length;
  const pct = Math.round(doneCount / SECS.length * 100);
  const canSave = filled.basics && filled.pricing && (composite ? filled.components : filled.inventory);

  useE(() => {
    const sc = scrollRef.current;
    if (!sc) return;
    const onScroll = () => {
      const top = sc.scrollTop + 90;
      let cur = null;
      sc.querySelectorAll('.pe-sec').forEach((el) => { if (el.offsetTop <= top) cur = el.id.replace('peb-', ''); });
      if (cur) setActive(cur);
    };
    sc.addEventListener('scroll', onScroll);
    onScroll();
    return () => sc.removeEventListener('scroll', onScroll);
  }, [composite]);

  const goTo = (id) => {
    const sc = scrollRef.current;
    const el = sc && sc.querySelector(`#peb-${id}`);
    if (sc && el) sc.scrollTo({ top: el.offsetTop - 24, behavior: 'smooth' });
  };

  return (
    <div className="pe" style={{ display: 'flex', flexDirection: 'column' }}>
      <div className="pe-topbar">
        <button className="pe-back" aria-label="Back"><Icons.ChevLeft size={20} /></button>
        <div className="pe-crumb">
          <div className="pe-crumb-k">Inventory · New {composite ? 'composite' : 'product'}</div>
          <div className="pe-crumb-v">{p.name || 'Untitled product'}</div>
        </div>
        <div className="sp" />
      </div>

      <div className="pe-bodyB">
        <nav className="pe-nav pe-scroll">
          <div className="pe-nav-t">Sections</div>
          {SECS.map((s) =>
            <button key={s.id} className={`pe-nav-item ${active === s.id ? 'on' : ''} ${filled[s.id] ? 'filled' : ''}`} onClick={() => goTo(s.id)}>
              <span className="ni">{s.icon(16)}</span>
              <span className="nt">
                <span className="nk">{s.t}</span>
                <span className="nd">{s.d}</span>
              </span>
              <span className="ck"><Icons.Check size={16} /></span>
            </button>
          )}
        </nav>

        <div className="pe-sheetwrap">
          <div className="pe-sheet pe-scroll" ref={scrollRef}>
            <div className="pe-sheet-inner">
              <section className="pe-sec" id="peb-basics">
                <div className="pe-sec-head">
                  <div className="pe-sec-num">1</div>
                  <div><div className="pe-sec-t">Basics</div><div className="pe-sec-d">Name, identity color, and item type</div></div>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
                  <Field label="Product color"><ColorBlock color={p.color} setColor={p.setColor} /></Field>
                  <Field label="Product name" required>
                    <TextInput value={p.name} onChange={p.setName} placeholder="e.g. Fanta Orange 500ml" />
                  </Field>
                  <Toggle on={p.composite} onChange={p.setComposite}
                    title="Composite item" desc="Built from other products — price is the sum of its components" />
                </div>
              </section>

              <section className="pe-sec" id="peb-pricing">
                <div className="pe-sec-head">
                  <div className="pe-sec-num">2</div>
                  <div>
                    <div className="pe-sec-t">{composite ? 'Pricing & codes' : 'Pricing'}</div>
                    <div className="pe-sec-d">{composite ? 'Sale price plus the identifiers for this build' : 'What you sell for and what it costs'}</div>
                  </div>
                </div>
                <div className="pe-grid2">
                  <Field label="Retail price" required hint="What the customer pays">
                    <TextInput value={p.retail} onChange={(v) => p.setRetail(v.replace(/[^\d.]/g, ''))} pre="RWF" mono placeholder="0" />
                  </Field>
                  {composite ?
                    <Field label="Supply price" hint="Calculated from components">
                      <div className="pe-input is-locked">
                        <span className="pre">RWF</span>
                        <input className="mono" value={p.compTotal} readOnly tabIndex={-1} />
                        <span className="lock"><Icons.Lock size={16} /></span>
                      </div>
                    </Field> :

                    <Field label="Supply price" hint="Your cost per unit">
                      <TextInput value={p.supply} onChange={(v) => p.setSupply(v.replace(/[^\d.]/g, ''))} pre="RWF" mono placeholder="0" />
                    </Field>}
                </div>
                {composite &&
                  <div className="pe-grid2" style={{ marginTop: 16 }}>
                    <Field label="SKU"><TextInput value={p.sku} onChange={p.setSku} placeholder="e.g. CMB-001" mono /></Field>
                    <Field label="Bar code"><TextInput value={p.barcode} onChange={(v) => p.setBarcode(v.replace(/\D/g, ''))} placeholder="Scan or enter" mono /></Field>
                  </div>}
                <div className="pe-margin" style={{ marginTop: 16 }}>
                  <div className="pe-margin-row"><span className="k">Profit per unit</span>
                    <span className="v" style={{ color: p.margin.profit < 0 ? 'var(--loss,#E5484D)' : 'var(--win)' }}>
                      {p.margin.profit < 0 ? '−' : ''}RWF {Math.abs(p.margin.profit).toLocaleString()}</span>
                  </div>
                  <div className="pe-margin-row"><span className="k">Margin</span><span className="v">{p.margin.pct.toFixed(0)}%</span></div>
                </div>
              </section>

              {composite ?
                <section className="pe-sec" id="peb-components">
                  <div className="pe-sec-head">
                    <div className="pe-sec-num">3</div>
                    <div><div className="pe-sec-t">Components</div><div className="pe-sec-d">The products this item is assembled from</div></div>
                  </div>
                  <ComponentsBuilder p={p} />
                </section> :

                <>
                  <section className="pe-sec" id="peb-inventory">
                    <div className="pe-sec-head">
                      <div className="pe-sec-num">3</div>
                      <div><div className="pe-sec-t">Inventory &amp; categorization</div><div className="pe-sec-d">How it's grouped, packaged, and classified</div></div>
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
                      <Field label="Packaging unit"><SelectInput value={p.packaging} onChange={p.setPackaging} options={PACKAGING} /></Field>
                      <Field label="Category" required><CategoryPicker cats={p.cats} setCats={p.setCats} /></Field>
                      <div className="pe-grid2">
                        <Field label="Classification"><SelectInput value={p.classification} onChange={p.setClassification} options={CLASSIFICATIONS} /></Field>
                        <Field label="Country of origin"><SelectInput value={p.origin} onChange={p.setOrigin} options={ORIGINS} /></Field>
                      </div>
                    </div>
                  </section>

                  <section className="pe-sec" id="peb-variants">
                    <div className="pe-sec-head">
                      <div className="pe-sec-num">4</div>
                      <div><div className="pe-sec-t">Variants &amp; stock</div><div className="pe-sec-d">Add each sellable variant by scan or name</div></div>
                    </div>
                    <QuickScan onAdd={p.addVariant} />
                    <VariantArea p={p} />
                  </section>
                </>}
            </div>
          </div>

          <div className="pe-footer">
            <div className="prog">
              <div className="track"><i style={{ width: pct + '%' }} /></div>
              <span className="lbl">{doneCount === SECS.length ? <b>Ready to save</b> : `${doneCount} of ${SECS.length} sections complete`}</span>
            </div>
            <button className="pe-btn pe-btn-ghost">Close</button>
            <button className="pe-btn pe-btn-primary" disabled={!canSave}><Icons.Check size={17} /> Save product</button>
          </div>
        </div>
      </div>
    </div>);

}

window.DirectionB = DirectionB;
