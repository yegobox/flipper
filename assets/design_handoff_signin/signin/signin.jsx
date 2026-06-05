const { useState: useSi, useEffect: useSiEffect, useCallback: useSiCb } = React;

const PIN_LEN = 6;
const CORRECT = '246813'; // demo pin

const USER = { name: 'Murangwa Eric', business: 'Demo Shop · Owner' };

// product-UI preview cards (self-contained for this screen)
function MiniChart() {
  const bars = [40, 64, 52, 86, 70, 100];
  return (
    <div className="pc" style={{ width: 168 }}>
      <div className="pc-row" style={{ justifyContent: 'space-between' }}>
        <span className="pc-label">Revenue · this week</span>
        <span className="pc-up"><Icons.TrendUp size={11} />18%</span>
      </div>
      <div className="pc-big" style={{ fontSize: 19, margin: '4px 0 9px' }}>RWF 248,500</div>
      <div className="bars">
        {bars.map((h, i) => (
          <i key={i} style={{ height: `${h}%`, background: i === bars.length - 1 ? 'var(--grad-brand)' : 'var(--blue-tint2)' }} />
        ))}
      </div>
    </div>
  );
}
function MiniSale() {
  return (
    <div className="pc pc-row" style={{ width: 178, gap: 11 }}>
      <span className="pc-ico" style={{ background: 'var(--win-tint)', color: 'var(--win)' }}><Icons.Check size={17} /></span>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 12.5, fontWeight: 700, whiteSpace: 'nowrap' }}>New sale</div>
        <div className="pc-label" style={{ fontWeight: 500 }}>Solar Kit · MoMo</div>
      </div>
      <div className="pc-big pc-up" style={{ fontSize: 14 }}>+12,000</div>
    </div>
  );
}
function MiniStreak() {
  return (
    <div className="pc pc-row" style={{ width: 152, gap: 10 }}>
      <span className="pc-ico" style={{ background: 'linear-gradient(135deg,#FF8A3D,#FF5A36)', color: '#fff' }}><Icons.Flame size={17} /></span>
      <div>
        <div style={{ fontSize: 16, fontWeight: 800, fontFamily: 'var(--mono)', letterSpacing: '-.02em' }}>12 days</div>
        <div className="pc-label" style={{ fontWeight: 500 }}>Sales streak</div>
      </div>
    </div>
  );
}

// floating product-UI cards reused from the welcome hero, on the blue panel
function HeroFloats() {
  return (
    <div className="si-hero">
      <div className="si-right-rings" />
      <div className="si-float" style={{ top: '8%', left: '14%', '--rot': '-5deg', animationDelay: '0s' }}><MiniChart /></div>
      <div className="si-float" style={{ top: '24%', right: '10%', '--rot': '5deg', animationDelay: '1.1s' }}><MiniSale /></div>
      <div className="si-float" style={{ top: '34%', left: '18%', '--rot': '4deg', animationDelay: '.6s' }}><MiniStreak /></div>
    </div>
  );
}

function SignIn({ tweaks }) {
  const [pin, setPin] = useSi('');
  const [show, setShow] = useSi(false);
  const [error, setError] = useSi('');
  const [loading, setLoading] = useSi(false);
  const [done, setDone] = useSi(false);

  const submit = useSiCb((value) => {
    setLoading(true);
    setTimeout(() => {
      if (value === CORRECT) { setError(''); setDone(true); }
      else { setError('That PIN doesn’t match. Try again.'); setPin(''); }
      setLoading(false);
    }, 650);
  }, []);

  const push = (d) => {
    if (loading || done) return;
    setError('');
    setPin((p) => {
      if (p.length >= PIN_LEN) return p;
      const next = p + d;
      if (next.length === PIN_LEN) submit(next);
      return next;
    });
  };
  const back = () => { if (!loading) { setError(''); setPin((p) => p.slice(0, -1)); } };

  // physical keyboard support
  useSiEffect(() => {
    const onKey = (e) => {
      if (e.key >= '0' && e.key <= '9') push(e.key);
      else if (e.key === 'Backspace') back();
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [loading, done]);

  return (
    <div className="si">
      {/* LEFT — form */}
      <div className="si-left">
        <div className="si-brand">
          <FlipperLogo size={32} />
          <span className="wordmark">Flipper</span>
        </div>

        <div className="si-form-wrap">
          <h1 className="si-h">Welcome back</h1>
          <p className="si-sub">Enter your PIN to manage your business securely.</p>

          <div className="si-acct">
            <span className="si-acct-av">{USER.name.slice(0, 1)}</span>
            <div className="si-acct-txt">
              <div className="si-acct-name">{USER.name}</div>
              <div className="si-acct-sub">{USER.business}</div>
            </div>
            <button className="si-acct-switch">Not you?</button>
          </div>

          <div className="si-pin-head">
            <span className="si-pin-label">PIN</span>
            <button className="si-pin-toggle" onClick={() => setShow((s) => !s)}>
              {show ? <Icons.Eye size={15} /> : <Icons.Eye size={15} />}
              {show ? 'Hide' : 'Show'}
            </button>
          </div>

          <div className="si-pin">
            {Array.from({ length: PIN_LEN }).map((_, i) => {
              const filled = i < pin.length;
              const active = i === pin.length && !done;
              return (
                <div key={i} className={`si-pin-cell ${filled ? 'filled' : ''} ${active && !loading ? 'active' : ''} ${error ? 'error' : ''}`}>
                  {filled ? (show ? pin[i] : <span className="dot" />) : ''}
                </div>
              );
            })}
          </div>

          <div className="si-error">
            {error && <><Icons.Info size={15} />{error}</>}
            {done && <span style={{ color: 'var(--win)', display: 'inline-flex', alignItems: 'center', gap: 7 }}><Icons.Check size={15} />Verified — opening Demo Shop…</span>}
          </div>

          {/* on-screen keypad (mobile/touch) */}
          <div className="si-keypad">
            {['1','2','3','4','5','6','7','8','9'].map((d) => (
              <button key={d} className="si-key" onClick={() => push(d)}>{d}</button>
            ))}
            <button className="si-key is-action" onClick={() => setShow((s) => !s)} title="Show/hide"><Icons.Eye size={20} /></button>
            <button className="si-key" onClick={() => push('0')}>0</button>
            <button className="si-key is-action" onClick={back} title="Delete"><Icons.ChevLeft size={20} /></button>
          </div>

          <div className="si-cta">
            <button className="btn btn-primary" disabled={pin.length < PIN_LEN || loading || done} onClick={() => submit(pin)}>
              {loading ? 'Verifying…' : done ? 'Signed in ✓' : 'Sign in'}
              {!loading && !done && <Icons.ArrowUpRight size={18} />}
            </button>
          </div>

          <div className="si-foot">
            <a className="si-trouble" href="#">Trouble signing in?</a>
          </div>
        </div>

        <div className="si-bottom">
          <span className="si-bottom-note">© Flipper 2026</span>
          <span className="si-secure"><Icons.ShieldCheck size={14} />Secured with end-to-end encryption</span>
        </div>
      </div>

      {/* RIGHT — brand panel */}
      <div className="si-right">
        <div className="si-right-glow" />
        <div className="si-hero-region">
          <div className="si-right-rings" />
          <div className="si-float" style={{ top: '14%', left: '12%', '--rot': '-5deg', animationDelay: '0s' }}><MiniChart /></div>
          <div className="si-float" style={{ top: '40%', right: '8%', '--rot': '5deg', animationDelay: '1.1s' }}><MiniSale /></div>
          <div className="si-float" style={{ top: '60%', left: '16%', '--rot': '4deg', animationDelay: '.6s' }}><MiniStreak /></div>
        </div>
        <div className="si-right-copy">
          <div className="si-right-eyebrow">Flipper Business OS</div>
          <div className="si-right-h">Your shop, your team, your numbers — all in one place.</div>
          <p className="si-right-p">Pick up right where you left off. Today’s sales, stock, and reports are ready.</p>
          <div className="si-right-stats">
            <div><div className="si-right-stat-v">12,400+</div><div className="si-right-stat-l">businesses</div></div>
            <div><div className="si-right-stat-v">RWF 1.2B</div><div className="si-right-stat-l">processed monthly</div></div>
            <div><div className="si-right-stat-v">99.9%</div><div className="si-right-stat-l">uptime</div></div>
          </div>
        </div>
      </div>
    </div>
  );
}

window.SignInApp = SignIn;
