/* ipm-purchase.jsx — Purchase mode: supplier invoices, per-line variant mapping (itemMapper), async approve */

const PURCHASE_STATUS_OPTS = [
  { v: "all", l: "All" }, { v: "pending", l: "Pending" }, { v: "approved", l: "Approved" }, { v: "rejected", l: "Rejected" },
];
const PAGE_SIZE = 4;
const CAT_LABEL = { A: "A · Exempt", B: "B · VAT 18%", C: "C · Zero", D: "D · Deemed" };

function LineBadge({ it }) {
  if (it.status === "processing") return <span className="badge processing"><span className="spin"><Icon.spinner /></span>Processing</span>;
  if (!it.assigned) return <span className="unassigned-tag"><Icon.alert /> Map variant</span>;
  if (!it.variant) return <span className="badge approved" style={{ background: "var(--accent-wash)", color: "var(--accent-strong)" }}><Icon.plusCircle style={{ width: 13, height: 13 }} /> New variant</span>;
  return <span className={"badge " + it.status}><span className="dot" />{STATUS_LABEL[it.status]}</span>;
}

function PurchaseView({ groups, setGroups, statusFilter, setStatusFilter, toast, job, isMobile }) {
  const [openIds, setOpenIds] = useState(() => new Set([1]));
  const [page, setPage] = useState(0);
  const [assign, setAssign] = useState(null); // { gid, iid }
  const [draft, setDraftRaw] = useState({ mode: "new", variant: "", name: "", supply: "", retail: "" });
  const set = (patch) => setDraftRaw((d) => ({ ...d, ...patch }));

  const filtered = useMemo(
    () => groups.filter((g) => statusFilter === "all" || g.status === statusFilter),
    [groups, statusFilter]
  );
  const total = filtered.length;
  const pages = Math.max(1, Math.ceil(total / PAGE_SIZE));
  const cur = Math.min(page, pages - 1);
  const visible = filtered.slice(cur * PAGE_SIZE, cur * PAGE_SIZE + PAGE_SIZE);
  useEffect(() => { if (page > pages - 1) setPage(pages - 1); }, [pages, page]);

  const toggle = (id) => setOpenIds((s) => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });

  const approveInvoice = (g) => {
    const mergeCount = g.items.filter((it) => it.assigned && it.variant).length;
    const newCount = g.items.length - mergeCount;
    setGroups((s) => s.map((x) => x.id === g.id ? { ...x, items: x.items.map((it) => ({ ...it, status: "processing" })) } : x));
    job("Approving invoice",
      () => setGroups((s) => s.map((x) => x.id === g.id ? { ...x, status: "approved", items: x.items.map((it) => ({ ...it, status: "approved", assigned: true })) } : x)),
      `Invoice approved · ${mergeCount} merged, ${newCount} new`);
  };
  const declineInvoice = (g) => {
    setGroups((s) => s.map((x) => x.id === g.id ? { ...x, items: x.items.map((it) => ({ ...it, status: "processing" })) } : x));
    job("Rejecting invoice",
      () => setGroups((s) => s.map((x) => x.id === g.id ? { ...x, status: "rejected", items: x.items.map((it) => ({ ...it, status: "rejected" })) } : x)),
      "Invoice rejected", "bad");
  };

  const openAssign = (g, it) => {
    setAssign({ gid: g.id, iid: it.id });
    setDraftRaw({ mode: it.variant ? "existing" : "new", variant: it.variant, name: it.name, supply: String(it.supply), retail: String(it.retail) });
  };
  const saveAssign = () => {
    const existing = draft.mode === "existing";
    setGroups((s) => s.map((g) => g.id !== assign.gid ? g : {
      ...g, items: g.items.map((it) => it.id !== assign.iid ? it : {
        ...it, assigned: true, variant: existing ? draft.variant : "",
        name: draft.name || it.name, supply: parseFloat(draft.supply) || 0, retail: parseFloat(draft.retail) || 0,
      }),
    }));
    setAssign(null);
    toast(existing ? "Mapped to existing variant" : "Will be created as a new variant");
  };

  const assignItem = assign && groups.find((g) => g.id === assign.gid)?.items.find((it) => it.id === assign.iid);

  return (
    <React.Fragment>
      {/* toolbar */}
      <div className="purchase-toolbar">
        <StatusFilter value={statusFilter} onChange={setStatusFilter} options={PURCHASE_STATUS_OPTS} />
        <span className="spacer only-desktop" />
        <div className="pager">
          <span className="ptxt">{total === 0 ? "0 of 0" : `${cur * PAGE_SIZE + 1}\u2013${Math.min(cur * PAGE_SIZE + PAGE_SIZE, total)} of ${total}`}</span>
          <button className="parr" disabled={cur === 0} onClick={() => setPage(cur - 1)} aria-label="Previous"><Icon.chev style={{ transform: "rotate(90deg)" }} /></button>
          <button className="parr" disabled={cur >= pages - 1} onClick={() => setPage(cur + 1)} aria-label="Next"><Icon.chev style={{ transform: "rotate(-90deg)" }} /></button>
        </div>
      </div>

      {/* groups */}
      {visible.length === 0 ? (
        <div className="empty">
          <div className="eic"><Icon.cart /></div>
          <h3>No purchase invoices</h3>
          <p>Nothing matches this status filter. Sync from RRA or change the filter.</p>
        </div>
      ) : visible.map((g) => {
        const open = openIds.has(g.id);
        const tot = groupTotal(g);
        const need = unmappedCount(g);
        const busy = g.items.some((it) => it.status === "processing");
        const pending = g.status === "pending";
        return (
          <div key={g.id} className={"panel sgroup" + (open ? " open" : "")}>
            <div className="sgroup-head" onClick={() => toggle(g.id)}>
              <div className="sg-id">
                <div className="sup">{g.supplier} <span className="cnt">({g.items.length})</span></div>
                <div className="inv">Invoice {g.invoice} · TIN {g.tin || "—"}</div>
              </div>
              <div className="sg-meta" onClick={(e) => e.stopPropagation()}>
                {pending && need > 0 && <span className="needmap"><Icon.alert /> {need} need mapping</span>}
                <span className="timepill">{g.time}</span>
                <span className="totalpill"><span className="cur">UGX</span>{fmt(tot)}</span>
                {pending && (busy
                  ? <span className="badge processing"><span className="spin"><Icon.spinner /></span>Processing</span>
                  : <div className="sg-actions-row">
                      <button className="btn btn-green-soft" onClick={() => approveInvoice(g)}><Icon.checkCircle /> Approve</button>
                      <button className="btn btn-danger-soft" onClick={() => declineInvoice(g)}><Icon.xCircle /> Decline</button>
                    </div>
                )}
              </div>
              <button className="sg-expand" aria-label={open ? "Collapse" : "Expand"} onClick={(e) => { e.stopPropagation(); toggle(g.id); }}><Icon.chev /></button>
            </div>

            {open && (
              <div className="sgroup-body">
                <div className="sg-info">
                  <span><b>Sales date</b> {g.salesDt}</span>
                  <span><b>Payment</b> {g.pmt}</span>
                  <span><b>Tax</b> {CAT_LABEL[g.items[0] ? g.items[0].cat : "B"]}</span>
                  <span><b>Items</b> {g.items.length}</span>
                </div>
                {!isMobile ? (
                  <div className="litbl only-desktop">
                    <div className="lh">
                      <span>No.</span><span>Name</span><span className="r">Qty</span>
                      <span className="r">Supply Price</span><span className="r">Retail Price</span><span>Mapping</span>
                    </div>
                    {g.items.map((it, i) => (
                      <div key={it.id} className="lr" onClick={() => openAssign(g, it)} title="Map variant">
                        <div className="no">{i + 1}</div>
                        <div className="nm">{it.name}{it.variant && <span className="vtag">{it.variant}</span>}</div>
                        <div className="mono r">{fmt(it.qty)}</div>
                        <div className="mono r">{fmt(it.supply)}</div>
                        <div className="mono r">{fmt(it.retail)}</div>
                        <div><LineBadge it={it} /></div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="licards only-mobile">
                    {g.items.map((it, i) => (
                      <div key={it.id} className="licard" onClick={() => openAssign(g, it)}>
                        <div className="licard-top">
                          <div className="nm">{i + 1}. {it.name}</div>
                          <LineBadge it={it} />
                        </div>
                        <div className="licard-grid">
                          <div><div className="lab">Qty</div><div className="val">{fmt(it.qty)}</div></div>
                          <div><div className="lab">Supply</div><div className="val">{fmt(it.supply)}</div></div>
                          <div><div className="lab">Retail</div><div className="val">{fmt(it.retail)}</div></div>
                        </div>
                        <div className="assignhint"><Icon.tag /> {it.assigned ? (it.variant ? `Mapped · ${it.variant} — tap to change` : "New variant — tap to change") : "Tap to map this line"}</div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        );
      })}

      {/* map-variant modal (itemMapper: existing vs new) */}
      {assign && (
        <Modal icon={<Icon.tag />} title="Map purchase line" sub={assignItem?.name}
          onClose={() => setAssign(null)}
          foot={<React.Fragment>
            <button className="btn btn-ghost" onClick={() => setAssign(null)}>Cancel</button>
            <button className="btn btn-primary" disabled={draft.mode === "existing" && !draft.variant} onClick={saveAssign}><Icon.check /> Save mapping</button>
          </React.Fragment>}>
          <div className="choice">
            <button className="choice-opt" aria-pressed={draft.mode === "new"} onClick={() => set({ mode: "new" })}>
              <span className="ci"><Icon.plusCircle /></span>
              <span className="ct"><span className="h">Create new variant</span><span className="d">This line becomes a new item on approval.</span></span>
              <span className="rad" />
            </button>
            <button className="choice-opt" aria-pressed={draft.mode === "existing"} onClick={() => set({ mode: "existing" })}>
              <span className="ci"><Icon.merge /></span>
              <span className="ct"><span className="h">Map to existing variant</span><span className="d">Adds this quantity to a variant you already stock.</span></span>
              <span className="rad" />
            </button>
          </div>
          {draft.mode === "existing" && (
            <div className="field choice-sub">
              <label>Existing variant</label>
              <Combo value={draft.variant} onChange={(v) => set({ variant: v, name: v })} options={VARIANTS} placeholder="Select a variant…" />
            </div>
          )}
          <div className="field">
            <label>Name</label>
            <input className="ctrl" value={draft.name} onChange={(e) => set({ name: e.target.value })} />
          </div>
          <div className="modal-2col">
            <div className="field">
              <label>Supply Price</label>
              <input className="ctrl" inputMode="decimal" value={draft.supply} onChange={(e) => set({ supply: e.target.value.replace(/[^0-9.]/g, "") })} />
            </div>
            <div className="field">
              <label>Retail Price</label>
              <input className="ctrl" inputMode="decimal" value={draft.retail} onChange={(e) => set({ retail: e.target.value.replace(/[^0-9.]/g, "") })} />
            </div>
          </div>
        </Modal>
      )}
    </React.Fragment>
  );
}

Object.assign(window, { PurchaseView, PURCHASE_STATUS_OPTS });
