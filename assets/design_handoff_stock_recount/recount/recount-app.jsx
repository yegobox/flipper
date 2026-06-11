/* ===== Flipper · Stock Recount — root app ===== */
const { useState: useApp, useMemo: useAppMemo } = React;

const RC_ACCENTS = [
  ['#2563EB', '#1D4ED8'], // Flipper blue
  ['#4F46E5', '#4338CA'], // indigo
  ['#0E9488', '#0F766E'], // teal
  ['#E0529C', '#BE2A78'], // magenta
];

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "accent": ["#2563EB", "#1D4ED8"],
  "variancePolicy": "confirm",
  "density": "comfortable",
  "scanEnabled": true,
  "counter": "Richard M."
}/*EDITMODE-END*/;

function focusItemEl(sku) {
  const el = document.querySelector(`[data-screen-label="item-${sku}"]`);
  if (!el) return;
  el.style.transition = 'box-shadow .2s';
  el.style.boxShadow = '0 0 0 3px var(--ac-ring)';
  setTimeout(() => { el.style.boxShadow = ''; }, 1100);
}

function RecountApp() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);

  const [sessions, setSessions] = useApp(() => rcSeed());
  const [view, setView] = useApp('list');     // list | detail
  const [currentId, setCurrentId] = useApp(null);
  const [toast, setToast] = useApp('');
  const [reportId, setReportId] = useApp(null);
  const [confirmOpen, setConfirmOpen] = useApp(false);
  const [scanning, setScanning] = useApp(false);

  const current = useAppMemo(() => sessions.find((s) => s.id === currentId) || null, [sessions, currentId]);
  const reportSess = useAppMemo(() => sessions.find((s) => s.id === reportId) || null, [sessions, reportId]);
  const editable = current && current.status === 'draft';

  const branch = useAppMemo(() => ({ ...RC_BRANCH, counter: t.counter || RC_BRANCH.counter }), [t.counter]);

  const showToast = (msg) => { setToast(msg); clearTimeout(window.__rcToast); window.__rcToast = setTimeout(() => setToast(''), 2600); };

  // ---- session ops ----
  const patch = (id, fn) => setSessions((ss) => ss.map((s) => (s.id === id ? fn(s) : s)));

  const openSession = (id) => { setCurrentId(id); setView('detail'); document.querySelector('.rc-main') && (document.querySelector('.rc-main').scrollTop = 0); };
  const backToList = () => { setView('list'); setCurrentId(null); };

  const newRecount = () => {
    const id = rcUid();
    const dev = 'Device ' + Math.random().toString(36).slice(2, 6).toUpperCase();
    const s = { id, device: dev, note: '', status: 'draft', createdAt: Date.now(), items: [] };
    setSessions((ss) => [s, ...ss]);
    setCurrentId(id); setView('detail');
    showToast('New recount session started');
  };

  const deleteSession = (id) => { setSessions((ss) => ss.filter((s) => s.id !== id)); showToast('Draft deleted'); };

  const updateNote = (val) => patch(currentId, (s) => ({ ...s, note: val }));

  const addItem = (p, qty) => {
    patch(currentId, (s) => ({
      ...s,
      items: [...s.items, { id: rcUid(), name: p.name, sku: p.sku, system: p.system, counted: qty, countedAt: Date.now() }],
    }));
    showToast(`${p.name} added to the count`);
  };

  const countItem = (itemId, n) => patch(currentId, (s) => ({
    ...s, items: s.items.map((it) => (it.id === itemId ? { ...it, counted: n, countedAt: Date.now() } : it)),
  }));

  const deleteItem = (itemId) => patch(currentId, (s) => ({ ...s, items: s.items.filter((it) => it.id !== itemId) }));

  // ---- submit flow ----
  const requestSubmit = () => {
    const st = rcStats(current.items);
    if (t.variancePolicy === 'confirm' && st.short > 0) { setConfirmOpen(true); return; }
    doSubmit();
  };
  const doSubmit = () => {
    setConfirmOpen(false);
    patch(currentId, (s) => ({ ...s, status: 'submitted', submittedAt: Date.now() }));
    showToast('Recount submitted ✓');
  };

  // ---- scanner ----
  const resolveScan = () => {
    setScanning(false);
    const used = new Set((current?.items || []).map((i) => i.sku));
    const pool = RC_CATALOG.filter((p) => !used.has(p.sku));
    if (pool.length === 0) { showToast('Every catalog item is already in this count'); return; }
    const p = pool[Math.floor(Math.random() * pool.length)];
    addItem(p, p.system);
    showToast(`Scanned ${p.name} — adjust the count if needed`);
    setTimeout(() => focusItemEl(p.sku), 120);
  };

  // ---- top bar ----
  const topTitle = (
    <div className="rc-topbar">
      {view === 'detail'
        ? <button className="rc-back" onClick={backToList}><Icons.ChevLeft size={20} /></button>
        : (window.FlipperLogo ? <FlipperLogo size={34} /> : null)}
      <div className="rc-top-brand" style={{ flexDirection: 'column', alignItems: 'flex-start', gap: 0 }}>
        <span className="rc-top-title">Stock Recount</span>
        {view === 'detail' && current ? <span className="rc-top-sub">{current.device}</span> : null}
      </div>
      <div className="rc-top-spacer" />
      <button className="rc-iconbtn" title="About stock recount" onClick={() => showToast('Count physical stock, compare to the system, then submit or export.')}>
        <Icons.Info size={19} />
      </button>
    </div>
  );

  return (
    <div
      className={`rc-shell ${t.density === 'compact' ? 'rc-compact' : ''}`}
      style={{ '--ac': t.accent[0], '--ac-deep': t.accent[1] }}
    >
      {topTitle}

      {view === 'list' ? (
        <ListScreen
          sessions={sessions}
          onOpen={openSession}
          onNew={newRecount}
          onExport={(id) => setReportId(id)}
          onDelete={deleteSession}
        />
      ) : current ? (
        <DetailScreen
          sess={current}
          editable={editable}
          variancePolicy={t.variancePolicy}
          scanEnabled={t.scanEnabled}
          onUpdateNote={updateNote}
          onAddItem={addItem}
          onCount={countItem}
          onDeleteItem={deleteItem}
          onSubmit={requestSubmit}
          onExport={() => setReportId(currentId)}
          onScanReq={() => setScanning(true)}
          showToast={showToast}
        />
      ) : null}

      {reportSess ? <ReportModal sess={reportSess} branch={branch} onClose={() => setReportId(null)} /> : null}
      {confirmOpen && current ? <ConfirmSubmitSheet sess={current} onClose={() => setConfirmOpen(false)} onConfirm={() => doSubmit()} /> : null}
      {scanning ? <Scanner onResolve={resolveScan} onClose={() => setScanning(false)} /> : null}

      {toast ? (
        <div className="rc-toast"><span className="ic"><Icons.Check size={13} color="#fff" /></span> {toast}</div>
      ) : null}

      <TweaksPanel>
        <TweakSection label="Appearance" />
        <TweakColor label="Accent" value={t.accent} options={RC_ACCENTS} onChange={(v) => setTweak('accent', v)} />
        <TweakRadio label="Density" value={t.density} options={['comfortable', 'compact']} onChange={(v) => setTweak('density', v)} />

        <TweakSection label="Counting" />
        <TweakToggle label="Barcode scan button" value={t.scanEnabled} onChange={(v) => setTweak('scanEnabled', v)} />
        <TweakSelect
          label="When counts are short"
          value={t.variancePolicy}
          options={[
            { value: 'confirm', label: 'Confirm & allow (recommended)' },
            { value: 'allow', label: 'Allow without asking' },
            { value: 'block', label: 'Block submission' },
          ]}
          onChange={(v) => setTweak('variancePolicy', v)}
        />

        <TweakSection label="Report" />
        <TweakText label="Counted by" value={t.counter} placeholder="Name on PDF" onChange={(v) => setTweak('counter', v)} />
      </TweaksPanel>
    </div>
  );
}

window.RecountApp = RecountApp;
