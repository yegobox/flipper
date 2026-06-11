/* ipm-purchase.jsx — Purchase mode: supplier groups, line items, Assign Variant modal */

const PURCHASE_STATUS_OPTS = [
  { v: "all", l: "All" }, { v: "waiting", l: "Waiting" }, { v: "approved", l: "Approved" }, { v: "rejected", l: "Rejected" },
];
const PAGE_SIZE = 4;
const stLabel = { waiting: "Waiting", approved: "Approved", rejected: "Rejected" };

function PurchaseView({ groups, setGroups, statusFilter, setStatusFilter, toast, isMobile }) {
  const [openIds, setOpenIds] = useState(() => new Set([1]));
  const [page, setPage] = useState(0);
  const [assign, setAssign] = useState(null); // { gid, iid }
  const [draft, setDraftRaw] = useState({ variant: "", name: "", supply: "", retail: "" });
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

  const setGroupStatus = (gid, status) => setGroups((s) => s.map((g) => g.id === gid
    ? { ...g, status, items: g.items.map((it) => ({ ...it, status })) } : g));
  const acceptAll = (gid) => { setGroupStatus(gid, "approved"); toast("Invoice approved"); };
  const declineAll = (gid) => { setGroupStatus(gid, "rejected"); toast("Invoice declined", "bad"); };

  const openAssign = (g, it) => {
    setAssign({ gid: g.id, iid: it.id });
    setDraftRaw({ variant: it.variant, name: it.name, supply: String(it.supply), retail: String(it.retail) });
  };
  const saveAssign = () => {
    setGroups((s) => s.map((g) => g.id !== assign.gid ? g : {
      ...g, items: g.items.map((it) => it.id !== assign.iid ? it : {
        ...it, variant: draft.variant, name: draft.name || it.name,
        supply: parseFloat(draft.supply) || 0, retail: parseFloat(draft.retail) || 0,
      }),
    }));
    setAssign(null);
    toast("Variant assigned");
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
          <p>Nothing matches this status filter. Record a purchase or change the filter.</p>
        </div>
      ) : visible.map((g) => {
        const open = openIds.has(g.id);
        const tot = groupTotal(g);
        return (
          <div key={g.id} className={"panel sgroup" + (open ? " open" : "")}>
            <div className="sgroup-head" onClick={() => toggle(g.id)}>
              <div className="sg-id">
                <div className="sup">Supplier: {g.supplier} <span className="cnt">({g.items.length})</span></div>
                <div className="inv">Invoice: {g.invoice}</div>
              </div>
              <div className="sg-meta" onClick={(e) => e.stopPropagation()}>
                <span className="timepill">{g.time}</span>
                <span className="totalpill"><span className="cur">UGX</span>{fmt(tot)}</span>
                <div className="sg-actions-row">
                  <button className="btn btn-green-soft" onClick={() => acceptAll(g.id)}><Icon.checkCircle /> Accept All</button>
                  <button className="btn btn-danger-soft" onClick={() => declineAll(g.id)}><Icon.xCircle /> Decline All</button>
                </div>
              </div>
              <button className="sg-expand" aria-label={open ? "Collapse" : "Expand"} onClick={(e) => { e.stopPropagation(); toggle(g.id); }}><Icon.chev /></button>
            </div>

            {open && (
              <div className="sgroup-body">
                {!isMobile ? (
                  <div className="litbl only-desktop">
                    <div className="lh">
                      <span>No.</span><span>Name</span><span className="r">Qty</span>
                      <span className="r">Supply Price</span><span className="r">Retail Price</span><span>Status</span>
                    </div>
                    {g.items.map((it, i) => (
                      <div key={it.id} className="lr" onClick={() => openAssign(g, it)} title="Assign variant">
                        <div className="no">{i + 1}</div>
                        <div className="nm">{it.name}{it.variant && <span className="vtag">{it.variant}</span>}</div>
                        <div className="mono r">{fmt(it.qty)}</div>
                        <div className="mono r">{fmt(it.supply)}</div>
                        <div className="mono r">{fmt(it.retail)}</div>
                        <div>{it.variant
                          ? <span className={"badge " + it.status}><span className="dot" />{stLabel[it.status]}</span>
                          : <span className="assign"><Icon.tag /> Assign variant</span>}</div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="licards only-mobile">
                    {g.items.map((it, i) => (
                      <div key={it.id} className="licard" onClick={() => openAssign(g, it)}>
                        <div className="licard-top">
                          <div className="nm">{i + 1}. {it.name}</div>
                          <span className={"badge " + it.status}><span className="dot" />{stLabel[it.status]}</span>
                        </div>
                        <div className="licard-grid">
                          <div><div className="lab">Qty</div><div className="val">{fmt(it.qty)}</div></div>
                          <div><div className="lab">Supply</div><div className="val">{fmt(it.supply)}</div></div>
                          <div><div className="lab">Retail</div><div className="val">{fmt(it.retail)}</div></div>
                        </div>
                        <div className="assignhint"><Icon.tag /> {it.variant ? `Variant · ${it.variant} — tap to edit` : "Tap to assign variant"}</div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        );
      })}

      {/* assign variant modal */}
      {assign && (
        <Modal icon={<Icon.tag />} title="Assign Variant" sub={assignItem?.name}
          onClose={() => setAssign(null)}
          foot={<React.Fragment>
            <button className="btn btn-ghost" onClick={() => setAssign(null)}>Cancel</button>
            <button className="btn btn-primary" onClick={saveAssign}><Icon.check /> Save</button>
          </React.Fragment>}>
          <div className="field">
            <label>Variant</label>
            <Combo value={draft.variant} onChange={(v) => set({ variant: v, name: v })} options={VARIANTS} placeholder="Select a variant…" />
          </div>
          <div className="field">
            <label>Name</label>
            <input className="ctrl" value={draft.name} onChange={(e) => set({ name: e.target.value })} />
          </div>
          <div className="field">
            <label>Supply Price</label>
            <input className="ctrl" inputMode="decimal" value={draft.supply} onChange={(e) => set({ supply: e.target.value.replace(/[^0-9.]/g, "") })} />
          </div>
          <div className="field">
            <label>Retail Price</label>
            <input className="ctrl" inputMode="decimal" value={draft.retail} onChange={(e) => set({ retail: e.target.value.replace(/[^0-9.]/g, "") })} />
          </div>
        </Modal>
      )}
    </React.Fragment>
  );
}

Object.assign(window, { PurchaseView, PURCHASE_STATUS_OPTS });
