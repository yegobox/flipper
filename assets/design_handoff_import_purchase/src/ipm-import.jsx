/* ipm-import.jsx — shared UI (Combo, StatusFilter, useMedia, Modal, Toasts) + Import mode */

/* ---------- responsive hook ---------- */
function useMedia(query = "(max-width: 880px)") {
  const [m, setM] = useState(() => window.matchMedia(query).matches);
  useEffect(() => {
    const mq = window.matchMedia(query);
    const h = (e) => setM(e.matches);
    mq.addEventListener("change", h);
    return () => mq.removeEventListener("change", h);
  }, [query]);
  return m;
}

/* ---------- searchable combo ---------- */
function Combo({ value, onChange, options, placeholder = "Select…", small = false }) {
  const [open, setOpen] = useState(false);
  const [q, setQ] = useState("");
  const ref = useRef(null);
  useEffect(() => {
    if (!open) return;
    const h = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    document.addEventListener("mousedown", h);
    return () => document.removeEventListener("mousedown", h);
  }, [open]);
  const list = options.filter((o) => o.toLowerCase().includes(q.toLowerCase()));
  return (
    <div className="combo" ref={ref}>
      <button type="button" className={"combo-btn" + (value ? "" : " placeholder")}
        aria-expanded={open} onClick={() => { setOpen((v) => !v); setQ(""); }}>
        {value || placeholder}
        <span className="chev"><Icon.chev /></span>
      </button>
      {open && (
        <div className="combo-pop">
          <div className="combo-search">
            <div className="selectwrap">
              <input autoFocus className="ctrl" style={{ height: 40, paddingLeft: 38 }} placeholder="Search variants…"
                value={q} onChange={(e) => setQ(e.target.value)} />
              <span className="chev" style={{ left: 12, right: "auto", color: "var(--faint)" }}><Icon.search /></span>
            </div>
          </div>
          <div className="combo-list">
            {list.length === 0 && <div className="combo-empty">No matching variants.</div>}
            {list.map((o) => (
              <div key={o} className="combo-opt" aria-selected={o === value}
                onClick={() => { onChange(o); setOpen(false); }}>
                {o}{o === value && <span className="ck"><Icon.check /></span>}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

/* ---------- status filter (native select, styled) ---------- */
function StatusFilter({ value, onChange, options, label = "Filter by Status" }) {
  return (
    <div className="statusfilter">
      <label>{label}</label>
      <div className="selectwrap">
        <select className="ctrl" value={value} onChange={(e) => onChange(e.target.value)}>
          {options.map((o) => <option key={o.v} value={o.v}>{o.l}</option>)}
        </select>
        <span className="chev"><Icon.chev /></span>
      </div>
    </div>
  );
}

/* ---------- modal shell ---------- */
function Modal({ icon, title, sub, onClose, children, foot }) {
  useEffect(() => {
    const h = (e) => { if (e.key === "Escape") onClose(); };
    document.addEventListener("keydown", h);
    return () => document.removeEventListener("keydown", h);
  }, [onClose]);
  return (
    <div className="scrim" onMouseDown={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div className="modal" role="dialog" aria-modal="true" aria-label={title}>
        <div className="modal-head">
          {icon && <div className="mi">{icon}</div>}
          <div>
            <h2>{title}</h2>
            {sub && <div className="sub">{sub}</div>}
          </div>
          <span className="spacer" />
          <button className="hdr iconbtn" style={{ width: 34, height: 34, border: "none" }} onClick={onClose} aria-label="Close"><Icon.x /></button>
        </div>
        <div className="modal-body">{children}</div>
        {foot && <div className="modal-foot">{foot}</div>}
      </div>
    </div>
  );
}

/* ---------- toasts ---------- */
function useToasts() {
  const [items, setItems] = useState([]);
  const push = useCallback((msg, kind = "ok", ttl = 2600) => {
    const id = uid();
    setItems((s) => [...s, { id, msg, kind }]);
    setTimeout(() => setItems((s) => s.filter((t) => t.id !== id)), ttl);
    return id;
  }, []);
  const node = (
    <div className="toasts">
      {items.map((t) => (
        <div key={t.id} className={"toast " + t.kind}>
          {t.kind === "ok" ? <Icon.checkCircle /> : t.kind === "bad" ? <Icon.xCircle /> : <span className="spin"><Icon.spinner /></span>}{t.msg}
        </div>
      ))}
    </div>
  );
  return [push, node];
}

/* ---------- shared edit fields ---------- */
function EditFields({ draft, set }) {
  return (
    <React.Fragment>
      <div className="field">
        <label>Item name</label>
        <input className="ctrl" placeholder="Enter a name" value={draft.name} onChange={(e) => set({ name: e.target.value })} />
      </div>
      <div className="field">
        <label>Supply price</label>
        <input className="ctrl" inputMode="decimal" placeholder="Enter supply price" value={draft.supply}
          onChange={(e) => set({ supply: e.target.value.replace(/[^0-9.]/g, "") })} />
      </div>
      <div className="field">
        <label>Retail price</label>
        <input className="ctrl" inputMode="decimal" placeholder="Enter retail price" value={draft.retail}
          onChange={(e) => set({ retail: e.target.value.replace(/[^0-9.]/g, "") })} />
      </div>
      <div className="field">
        <label>Variant</label>
        <Combo value={draft.variant} onChange={(v) => set({ variant: v })} options={VARIANTS} placeholder="Select Variant" />
      </div>
    </React.Fragment>
  );
}

const STATUS_OPTS = [
  { v: "all", l: "All" }, { v: "pending", l: "Pending" }, { v: "approved", l: "Approved" }, { v: "rejected", l: "Rejected" },
];
const blankDraft = { name: "", supply: "", retail: "", variant: "" };

/* ============================================================
   Import view
   ============================================================ */
function ImportView({ items, setItems, statusFilter, setStatusFilter, toast, job, isMobile, showSecondary }) {
  const [selectedId, setSelectedId] = useState(null);
  const [draft, setDraftRaw] = useState(blankDraft);
  const [sheet, setSheet] = useState(false);
  const [approve, setApprove] = useState(null); // { id, mode:'new'|'existing', variant }
  const set = (patch) => setDraftRaw((d) => ({ ...d, ...patch }));

  const filtered = useMemo(
    () => items.filter((it) => statusFilter === "all" || it.status === statusFilter),
    [items, statusFilter]
  );

  useEffect(() => {
    if (selectedId && !filtered.some((it) => it.id === selectedId)) { setSelectedId(null); setDraftRaw(blankDraft); }
  }, [filtered, selectedId]);

  const selectRow = (it, openSheet = false) => {
    setSelectedId(it.id);
    setDraftRaw({ name: it.item, supply: it.supply ? String(it.supply) : "", retail: it.retail ? String(it.retail) : "", variant: it.variant });
    if (openSheet) setSheet(true);
  };

  const saveDraft = () => {
    if (!selectedId) { toast("Select an item to edit first", "bad"); return; }
    setItems((s) => s.map((it) => it.id === selectedId
      ? { ...it, item: draft.name || it.item, supply: parseFloat(draft.supply) || 0, retail: parseFloat(draft.retail) || 0, variant: draft.variant }
      : it));
    setSheet(false);
    toast("Changes saved");
  };

  const setStatus = (id, status) => setItems((s) => s.map((it) => it.id === id ? { ...it, status } : it));
  const openApprove = (it) => setApprove({ id: it.id, mode: it.variant ? "existing" : "new", variant: it.variant || "" });
  const confirmApprove = () => {
    const { id, mode, variant } = approve;
    const merge = mode === "existing";
    setApprove(null);
    setStatus(id, "processing");
    job(merge ? "Merging into existing variant" : "Approving as new variant",
      () => setItems((s) => s.map((it) => it.id === id ? { ...it, status: "approved", variant: merge ? variant : it.variant } : it)),
      merge ? "Merged into existing variant" : "Approved as new variant");
  };
  const reject = (id) => {
    setStatus(id, "processing");
    job("Rejecting item", () => setItems((s) => s.map((it) => it.id === id ? { ...it, status: "rejected" } : it)), "Item rejected", "bad");
  };
  const acceptAll = () => {
    const ids = filtered.filter((it) => it.status === "pending").map((it) => it.id);
    if (!ids.length) { toast("Nothing pending to approve", "bad"); return; }
    setItems((s) => s.map((it) => ids.includes(it.id) ? { ...it, status: "processing" } : it));
    job(`Approving ${ids.length} items`,
      () => setItems((s) => s.map((it) => ids.includes(it.id) ? { ...it, status: "approved" } : it)),
      `Approved ${ids.length} item${ids.length > 1 ? "s" : ""}`);
  };

  const Badge = ({ s }) => <span className={"badge " + s}>{s === "processing" ? <span className="spin"><Icon.spinner /></span> : <span className="dot" />}{STATUS_LABEL[s]}</span>;

  const cols = showSecondary
    ? "46px minmax(140px,1.4fr) 140px 110px 116px 116px 104px 150px 130px 92px"
    : "46px minmax(160px,1.6fr) 110px 116px 116px 104px 92px";

  return (
    <React.Fragment>
      {/* ----- desktop edit toolbar ----- */}
      {!isMobile && (
        <div className="panel editbar only-desktop">
          {selectedId
            ? <div className="eb-hint">Editing <span className="badge-no">#{filtered.findIndex((i) => i.id === selectedId) + 1}</span> {items.find((i) => i.id === selectedId)?.item}
                <button className="clear" onClick={() => { setSelectedId(null); setDraftRaw(blankDraft); }}>Clear</button>
              </div>
            : <div className="eb-hint idle"><Icon.pencil style={{ width: 16, height: 16 }} /> Select a row below to edit its name, prices &amp; variant</div>}
          <div className="eb-fields">
            <EditFields draft={draft} set={set} />
          </div>
          <div className="eb-bottom">
            <button className="btn btn-primary" onClick={saveDraft}><Icon.check /> Save Changes</button>
            <button className="btn btn-green" onClick={acceptAll}><Icon.checkCircle /> Accept All</button>
            <StatusFilter value={statusFilter} onChange={setStatusFilter} options={STATUS_OPTS} />
          </div>
        </div>
      )}

      {/* ----- mobile toolbar ----- */}
      {isMobile && (
        <div className="mbar only-mobile flex">
          <div className="statuspill">
            <Icon.filter style={{ width: 18, height: 18, color: "var(--muted)" }} />
            <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}
              style={{ flex: 1, border: "none", background: "transparent", font: "inherit", fontWeight: 600, outline: "none", appearance: "none" }}>
              {STATUS_OPTS.map((o) => <option key={o.v} value={o.v}>{o.l}</option>)}
            </select>
            <Icon.chev />
          </div>
          <button className="btn btn-green" onClick={acceptAll}><Icon.checkCircle /> Accept All</button>
        </div>
      )}

      {/* ----- list ----- */}
      {filtered.length === 0 ? (
        <div className="empty">
          <div className="eic"><Icon.inbox /></div>
          <h3>No imported items</h3>
          <p>Nothing matches this status filter. Switch the filter or import a new batch.</p>
        </div>
      ) : !isMobile ? (
        <div className="panel only-desktop">
          <div className="tablewrap">
            <div className="tbl import">
              <div className="tbl-head" style={{ gridTemplateColumns: cols }}>
                <span>No.</span><span>Item Name</span>{showSecondary && <span>HS Code</span>}
                <span>Quantity</span><span className="r">Retail Price</span><span className="r">Supply Price</span>
                <span>Status</span>{showSecondary && <span>Supplier</span>}{showSecondary && <span>Date</span>}
                <span className="r">Actions</span>
              </div>
              {filtered.map((it, i) => (
                <div key={it.id} className={"tbl-row" + (selectedId === it.id ? " selected" : "")}
                  style={{ gridTemplateColumns: cols }} onClick={() => selectRow(it)}>
                  <div className="no">{i + 1}</div>
                  <div className="name">{it.item}{it.variant && <span className="vtag">{it.variant}</span>}</div>
                  {showSecondary && <div className="cell mono">{it.hs}</div>}
                  <div className="cell strong">{it.qty}</div>
                  <div className="cell mono strong r">{fmt(it.retail)}</div>
                  <div className="cell mono strong r">{fmt(it.supply)}</div>
                  <div><Badge s={it.status} /></div>
                  {showSecondary && <div className="cell">{it.supplier}</div>}
                  {showSecondary && <div className="cell">{it.date}</div>}
                  <div className="rowacts" onClick={(e) => e.stopPropagation()}>
                    <button className="act act-accept" title="Approve" onClick={() => openApprove(it)}><Icon.checkCircle /></button>
                    <button className="act act-reject" title="Reject" onClick={() => reject(it.id)}><Icon.xCircle /></button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      ) : (
        <div className="cardlist only-mobile">
          {filtered.map((it, i) => (
            <div key={it.id} className={"icard" + (selectedId === it.id ? " selected" : "")}>
              <div className="icard-top">
                <div className="no">{i + 1}</div>
                <div className="ti">
                  <div className="nm">{it.item}</div>
                  {it.variant ? <div className="vtag">Variant · {it.variant}</div> : <div className="vtag" style={{ color: "var(--faint)" }}>No variant assigned</div>}
                </div>
                <span className={"badge " + it.status}>{it.status === "processing" ? <span className="spin"><Icon.spinner /></span> : <span className="dot" />}{STATUS_LABEL[it.status]}</span>
              </div>
              <div className="icard-grid">
                <div><div className="lab">Barcode</div><div className="val">{it.bcd}</div></div>
                <div><div className="lab">Quantity</div><div className="val">{it.qty}</div></div>
                <div><div className="lab">Supply Price</div><div className="val">{fmt(it.supply)}</div></div>
                <div><div className="lab">Retail Price</div><div className="val">{fmt(it.retail)}</div></div>
                <div><div className="lab">Supplier</div><div className="val" style={{ fontWeight: 600 }}>{it.supplier}</div></div>
                <div><div className="lab">Date</div><div className="val" style={{ fontWeight: 600, color: "var(--muted)" }}>{it.date}</div></div>
              </div>
              <div className="icard-foot">
                <button className="edit" onClick={() => selectRow(it, true)}><Icon.pencil /> Edit</button>
                <button className="act act-accept" title="Approve" onClick={() => openApprove(it)}><Icon.checkCircle /></button>
                <button className="act act-reject" title="Reject" onClick={() => reject(it.id)}><Icon.xCircle /></button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ----- mobile edit sheet ----- */}
      {sheet && (
        <Modal icon={<Icon.pencil />} title="Edit item" sub={items.find((i) => i.id === selectedId)?.item}
          onClose={() => setSheet(false)}
          foot={<React.Fragment>
            <button className="btn btn-ghost" onClick={() => setSheet(false)}>Cancel</button>
            <button className="btn btn-primary" onClick={saveDraft}><Icon.check /> Save Changes</button>
          </React.Fragment>}>
          <EditFields draft={draft} set={set} />
        </Modal>
      )}

      {/* ----- approve choice: new vs merge (imports/approve targetVariantId) ----- */}
      {approve && (
        <Modal icon={<Icon.checkCircle />} title="Approve import item" sub={items.find((i) => i.id === approve.id)?.item}
          onClose={() => setApprove(null)}
          foot={<React.Fragment>
            <button className="btn btn-ghost" onClick={() => setApprove(null)}>Cancel</button>
            <button className="btn btn-green" disabled={approve.mode === "existing" && !approve.variant} onClick={confirmApprove}><Icon.check /> Approve</button>
          </React.Fragment>}>
          <div className="choice">
            <button className="choice-opt" aria-pressed={approve.mode === "new"} onClick={() => setApprove((a) => ({ ...a, mode: "new" }))}>
              <span className="ci"><Icon.plusCircle /></span>
              <span className="ct"><span className="h">Create new variant</span><span className="d">Registers a brand-new item, then runs RRA save &amp; stock-in.</span></span>
              <span className="rad" />
            </button>
            <button className="choice-opt" aria-pressed={approve.mode === "existing"} onClick={() => setApprove((a) => ({ ...a, mode: "existing" }))}>
              <span className="ci"><Icon.merge /></span>
              <span className="ct"><span className="h">Merge into existing variant</span><span className="d">Adds the imported quantity to a variant you already stock.</span></span>
              <span className="rad" />
            </button>
            {approve.mode === "existing" && (
              <div className="choice-sub field">
                <label>Target variant</label>
                <Combo value={approve.variant} onChange={(v) => setApprove((a) => ({ ...a, variant: v }))} options={VARIANTS} placeholder="Select a variant to merge into…" />
              </div>
            )}
          </div>
        </Modal>
      )}
    </React.Fragment>
  );
}

Object.assign(window, { useMedia, Combo, StatusFilter, Modal, useToasts, EditFields, ImportView, STATUS_OPTS, blankDraft });
