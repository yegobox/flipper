const { useState, useEffect, useRef } = React;

// ---- tweak defaults ----
const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "tone": "warning",
  "badgeStyle": "soft",
  "showDiagnostic": true,
  "primaryAction": "branch",
  "headline": "No branch selected yet"
}/*EDITMODE-END*/;

// tone -> palette mapping (drawn from the design-system tokens)
const TONES = {
  warning: {
    tint: 'var(--warn-tint)', ink: 'var(--warnamber)',
    ring: 'rgba(183,121,31,.28)', aura: 'rgba(183,121,31,.12)',
    eyebrow: 'Action needed',
  },
  error: {
    tint: 'var(--loss-tint)', ink: 'var(--loss-ink)',
    ring: 'rgba(180,35,24,.26)', aura: 'rgba(229,72,77,.12)',
    eyebrow: 'Checkout unavailable',
  },
};

const BRANCHES = [
  { id: 'main', name: 'Main Store', loc: 'Osu, Oxford St.', tag: 'HQ', staff: 4 },
  { id: 'east', name: 'East Legon Kiosk', loc: 'Lagos Ave.', staff: 2 },
  { id: 'market', name: 'Makola Market Stall', loc: 'Stall 118B', staff: 1 },
];

function CheckoutError() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const tone = TONES[t.tone] || TONES.warning;

  // flow state: 'error' | loading | 'ok'
  const [stage, setStage] = useState('error');
  const [sheet, setSheet] = useState(false);
  const [picked, setPicked] = useState(null);
  const [makeDefault, setMakeDefault] = useState(true);
  const [retrying, setRetrying] = useState(false);
  const [shake, setShake] = useState(false);
  const [toast, setToast] = useState(false);
  const [loadMsg, setLoadMsg] = useState('Loading checkout…');
  const timers = useRef([]);

  const after = (ms, fn) => { const id = setTimeout(fn, ms); timers.current.push(id); };
  useEffect(() => () => timers.current.forEach(clearTimeout), []);

  const tryAgain = () => {
    if (retrying) return;
    setRetrying(true);
    after(1100, () => {
      setRetrying(false);
      // still no branch -> reinforce the real fix
      setShake(true);
      setToast(true);
      after(500, () => setShake(false));
      after(2600, () => setToast(false));
    });
  };

  const confirmBranch = () => {
    if (!picked) return;
    setSheet(false);
    setLoadMsg('Loading checkout…');
    setStage('loading');
    after(1500, () => setStage('ok'));
  };

  const reset = () => {
    setStage('error'); setPicked(null); setSheet(false);
  };

  const branch = BRANCHES.find((b) => b.id === picked);

  // ---------- resolved state ----------
  if (stage === 'ok') {
    return (
      <div className="err">
        <div className="err-ok fade-screen">
          <div className="err-ok-badge"><Icons.Check size={46} stroke={2.4} /></div>
          <div className="err-ok-h">Checkout ready</div>
          <p className="err-ok-p">You're all set to take payments. Items and totals will sync to this branch.</p>
          <div className="err-ok-branch">
            <span className="bi"><Icons.Store size={18} /></span>
            {branch ? branch.name : 'Main Store'}
          </div>
          <div className="err-ok-foot">
            <button className="err-act" onClick={() => {}}>
              <span className="ic"><Icons.Cart size={20} /></span>
              <span className="mid"><span className="a">Open checkout</span></span>
              <span className="go"><Icons.ChevRight size={20} /></span>
            </button>
            <button className="err-help" style={{ marginTop: 12, background: 'none' }} onClick={reset}>
              Back to error state
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="err fade-screen" style={{
      '--err-tint': tone.tint, '--err-ink': tone.ink,
      '--err-ring': tone.ring, '--err-aura': tone.aura,
    }}>
      <div className="err-glow" />

      {/* loading overlay */}
      {stage === 'loading' && (
        <div className="err-load">
          <div className="spinner" />
          <div style={{ textAlign: 'center' }}>
            <div className="lt">{loadMsg}</div>
            <div className="ls">{branch ? branch.name : ''}</div>
          </div>
        </div>
      )}

      {/* breadcrumb / context */}
      <div className="err-top">
        <span className="err-crumb">
          <Icons.Cart size={16} /> <b>Checkout</b>
          <span className="sep">·</span> Sale
        </span>
        <button className="icon-circle" style={{ width: 38, height: 38 }} aria-label="Close">
          <Icons.X size={18} />
        </button>
      </div>

      {/* body */}
      <div className="err-body">
        <div className={`err-badge ${t.badgeStyle === 'outline' ? 'outline' : ''} ${shake ? 'shake' : ''}`}>
          <Icons.Store size={42} stroke={1.7} />
        </div>

        <div className="err-eyebrow">{tone.eyebrow}</div>
        <h1 className="err-h">{t.headline}</h1>
        <p className="err-p">
          Checkout needs a branch to load products and record the sale. Pick a branch to continue.
        </p>

        {t.showDiagnostic && (
          <div className="err-diag">
            <span className="ic"><Icons.Info size={17} /></span>
            <div className="tx">
              <div className="k">What happened</div>
              <div className="v">no_default_branch — checkout couldn't resolve a location for this device.</div>
            </div>
          </div>
        )}
      </div>

      {/* actions */}
      <div className="err-foot">
        {t.primaryAction === 'branch' ? (
          <React.Fragment>
            <button className="err-act" onClick={() => setSheet(true)}>
              <span className="ic"><Icons.Store size={20} /></span>
              <span className="mid">
                <span className="a">Select a branch</span>
                <span className="b">Choose where this sale happens</span>
              </span>
              <span className="go"><Icons.ChevRight size={20} /></span>
            </button>
            <button className={`err-retry ${retrying ? 'is-loading' : ''}`} onClick={tryAgain} disabled={retrying}>
              <span className="spin"><Icons.Refresh size={18} /></span>
              {retrying ? 'Checking…' : 'Try again'}
            </button>
          </React.Fragment>
        ) : (
          <React.Fragment>
            <button className={`err-act ${retrying ? '' : ''}`} onClick={tryAgain} disabled={retrying} style={{ justifyContent: 'center' }}>
              <span className={`spin ${retrying ? 'is-loading' : ''}`} style={{ display: 'inline-grid', placeItems: 'center', animation: retrying ? 'errSpin .8s linear infinite' : 'none' }}>
                <Icons.Refresh size={20} />
              </span>
              <span className="mid" style={{ flex: '0 1 auto' }}><span className="a">{retrying ? 'Checking…' : 'Try again'}</span></span>
            </button>
            <button className="err-retry" onClick={() => setSheet(true)}>
              <Icons.Store size={18} /> Select a branch
            </button>
          </React.Fragment>
        )}
        <div className="err-help">Still stuck? <b>Get help</b></div>
      </div>

      {/* toast after failed retry */}
      {toast && (
        <div className="err-toast">
          <span className="ic"><Icons.Warn size={15} /></span>
          <span className="tx">Still no branch selected — pick one to continue.</span>
        </div>
      )}

      {/* branch picker sheet */}
      {sheet && (
        <div className="err-overlay" onClick={(e) => { if (e.target.classList.contains('err-overlay')) setSheet(false); }}>
          <div className="err-sheet">
            <div className="err-sheet-handle" />
            <div className="err-sheet-head">
              <div className="err-sheet-title">Select a branch</div>
              <div className="err-sheet-sub">Where is this sale taking place?</div>
            </div>
            <div className="err-sheet-body">
              {BRANCHES.map((b) => {
                const on = picked === b.id;
                return (
                  <button key={b.id} className={`err-branch ${on ? 'on' : ''}`} onClick={() => setPicked(b.id)}>
                    <span className="bic"><Icons.Store size={22} /></span>
                    <span className="bmid">
                      <span className="bname">{b.name} {b.tag && <span className="btag">{b.tag}</span>}</span>
                      <span className="bsub"><Icons.MapPin size={13} /> {b.loc} · {b.staff} staff</span>
                    </span>
                    {on
                      ? <span className="bcheck"><Icons.Check size={15} stroke={2.6} /></span>
                      : <span className="bradio" />}
                  </button>
                );
              })}

              <div className="err-default-row" onClick={() => setMakeDefault((v) => !v)} style={{ cursor: 'pointer' }}>
                <span className={`err-check ${makeDefault ? 'on' : ''}`}>
                  {makeDefault && <Icons.Check size={13} stroke={2.6} />}
                </span>
                <span className="lbl">Set as default branch for this device</span>
              </div>
            </div>
            <div className="err-sheet-foot">
              <button className="btn btn-primary" disabled={!picked} onClick={confirmBranch}>
                {picked ? 'Continue to checkout' : 'Choose a branch'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ---- Tweaks ---- */}
      <TweaksPanel>
        <TweakSection label="Severity" />
        <TweakRadio label="Tone" value={t.tone} options={['warning', 'error']}
          onChange={(v) => setTweak('tone', v)} />
        <TweakRadio label="Status glyph" value={t.badgeStyle} options={['soft', 'outline']}
          onChange={(v) => setTweak('badgeStyle', v)} />

        <TweakSection label="Recovery" />
        <TweakRadio label="Primary action" value={t.primaryAction} options={['branch', 'retry']}
          onChange={(v) => setTweak('primaryAction', v)} />
        <TweakToggle label="Show diagnostic" value={t.showDiagnostic}
          onChange={(v) => setTweak('showDiagnostic', v)} />

        <TweakSection label="Copy" />
        <TweakText label="Headline" value={t.headline}
          onChange={(v) => setTweak('headline', v)} />
      </TweaksPanel>
    </div>
  );
}

function App() {
  return <Phone>{<CheckoutError />}</Phone>;
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
function hideBoot() {
  const boot = document.getElementById('boot');
  if (boot) { boot.classList.add('is-hidden'); setTimeout(() => boot.remove(), 500); }
}
requestAnimationFrame(() => requestAnimationFrame(hideBoot));
setTimeout(hideBoot, 400);
