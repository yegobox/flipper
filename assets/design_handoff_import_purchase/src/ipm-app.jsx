/* ipm-app.jsx — shell: header, mode segmented control, date filter, tweaks, mount */

const ACCENTS = {
  Blue:    ["#2f6bff", "#1e5be6", "#eaf0ff"],
  Cyan:    ["#06b6d4", "#0e7fa3", "#e7fbff"],
  Indigo:  ["#6366f1", "#4338ca", "#eef0ff"],
  Emerald: ["#10b981", "#0a8f63", "#e7f8f0"],
};

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "accent": ["#2f6bff", "#1e5be6", "#eaf0ff"],
  "density": "comfortable",
  "showSecondary": true
}/*EDITMODE-END*/;

/* ---------- segmented control ---------- */
function Segmented({ value, options, onChange }) {
  const ref = useRef(null);
  const [thumb, setThumb] = useState({ left: 4, width: 0 });
  const recalc = useCallback(() => {
    const el = ref.current; if (!el) return;
    const idx = Math.max(0, options.findIndex((o) => o.v === value));
    const btn = el.querySelectorAll("button")[idx];
    if (btn) setThumb({ left: btn.offsetLeft, width: btn.offsetWidth });
  }, [value, options]);
  useEffect(() => { recalc(); }, [recalc]);
  useEffect(() => {
    window.addEventListener("resize", recalc);
    return () => window.removeEventListener("resize", recalc);
  }, [recalc]);
  return (
    <div className="seg" ref={ref} role="tablist">
      <span className="thumb" style={{ left: thumb.left, width: thumb.width }} />
      {options.map((o) => (
        <button key={o.v} role="tab" aria-selected={o.v === value} onClick={() => onChange(o.v)}>
          {o.icon}{o.l}
        </button>
      ))}
    </div>
  );
}

/* ---------- switch ---------- */
function Switch({ on, onChange, label }) {
  return (
    <span className="switchwrap">
      {label && <span className="sw-l">{label}</span>}
      <button className="switch" data-on={on ? "1" : "0"} role="switch" aria-checked={on} onClick={() => onChange(!on)}><i /></button>
    </span>
  );
}

const MODE_OPTS = [
  { v: "import", l: "Import", icon: <Icon.import style={{ width: 17, height: 17 }} /> },
  { v: "purchase", l: "Purchase", icon: <Icon.cart style={{ width: 17, height: 17 }} /> },
];

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  useEffect(() => {
    const r = document.documentElement.style;
    const [a, s, w] = t.accent;
    r.setProperty("--accent", a); r.setProperty("--accent-strong", s); r.setProperty("--accent-wash", w);
    document.body.classList.toggle("compact", t.density === "compact");
  }, [t.accent, t.density]);

  const isMobile = useMedia();
  const [push, toastNode] = useToasts();

  // async job runner — mirrors the connector's 202 + jobId + poll-until-success flow
  const job = useCallback((label, commit, okMsg, okKind = "ok") => {
    push(label + "…", "job", 1300);
    setTimeout(() => { commit(); if (okMsg) push(okMsg, okKind); }, 1200);
  }, [push]);

  const [mode, setMode] = useState("import");
  const [date, setDate] = useState("2026-06-11");
  const [syncing, setSyncing] = useState(false);
  const [lastSync, setLastSync] = useState({ import: "2 min ago", purchase: "8 min ago" });

  const [items, setItems] = useState(() => IMPORT_SEED.map((x) => ({ ...x })));
  const [groups, setGroups] = useState(() => PURCHASE_SEED.map((g) => ({ ...g, items: g.items.map((i) => ({ ...i })) })));
  const [importFilter, setImportFilter] = useState("all");
  const [purchaseFilter, setPurchaseFilter] = useState("pending");
  const [recordOpen, setRecordOpen] = useState(false);

  const syncNow = () => {
    if (syncing) return;
    setSyncing(true);
    push(`Syncing ${mode === "import" ? "imports" : "purchases"} from RRA…`, "job", 1900);
    setTimeout(() => {
      setSyncing(false);
      setLastSync((s) => ({ ...s, [mode]: "just now" }));
      const n = mode === "import" ? 3 : 2;
      push(`Fetched ${n} new ${mode === "import" ? "items" : "invoices"} from RRA`, "ok");
    }, 1800);
  };

  return (
    <div className="app">
      <div className="subbar">
        <div className="datefield">
          <span className="dlabel">{mode === "import" ? "Import" : "Purchase"} from</span>
          <input className="dinput" type="date" value={date} onChange={(e) => setDate(e.target.value)} />
        </div>
        <span className={"synced" + (syncing ? " syncing" : "")}>
          {syncing
            ? <React.Fragment><span className="spin"><Icon.spinner /></span> Syncing…</React.Fragment>
            : <React.Fragment><span className="dotg" /> Synced {lastSync[mode]}</React.Fragment>}
        </span>
        <span className="spacer" />
        <button className="btn btn-ghost hdr-export" aria-label="Export" onClick={() => push("Preparing export…")}><Icon.download /> <span className="lbl">Export</span></button>
        {mode === "purchase" && (
          <button className="btn btn-ghost hdr-record" onClick={() => setRecordOpen(true)}><Icon.plusDoc /> <span className="lbl">Add manually</span></button>
        )}
        <button className={"btn btn-primary hdr-record" + (syncing ? " busy" : "")} onClick={syncNow} disabled={syncing}>
          {syncing ? <span className="spin"><Icon.spinner /></span> : <Icon.sync />} <span className="lbl">Sync from RRA</span>
        </button>
        <span className="spacer only-desktop" />
        <Segmented value={mode} options={MODE_OPTS} onChange={setMode} />
      </div>

      <main className="content">
        {mode === "import"
          ? <ImportView items={items} setItems={setItems} statusFilter={importFilter} setStatusFilter={setImportFilter}
              toast={push} job={job} isMobile={isMobile} showSecondary={t.showSecondary} />
          : <PurchaseView groups={groups} setGroups={setGroups} statusFilter={purchaseFilter} setStatusFilter={setPurchaseFilter}
              toast={push} job={job} isMobile={isMobile} />}
      </main>

      {toastNode}

      {recordOpen && (
        <RecordPurchaseModal
          onClose={() => setRecordOpen(false)}
          onSaved={(p) => push(`Purchase from ${p.supplier || "supplier"} saved`)}
        />
      )}

      <TweaksPanel>
        <TweakSection label="Brand" />
        <TweakColor label="Accent" value={t.accent} options={Object.values(ACCENTS)} onChange={(v) => setTweak("accent", v)} />
        <TweakSection label="Layout" />
        <TweakRadio label="Density" value={t.density} options={["comfortable", "compact"]} onChange={(v) => setTweak("density", v)} />
        <TweakToggle label="Show HS / Supplier / Date columns" value={t.showSecondary} onChange={(v) => setTweak("showSecondary", v)} />
      </TweaksPanel>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
