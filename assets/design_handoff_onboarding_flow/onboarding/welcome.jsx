const { useState: useStateW, useEffect: useEffectW } = React;

// Little product-UI preview cards that float in the hero.
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
          <i key={i} style={{
            height: `${h}%`,
            background: i === bars.length - 1 ? 'var(--grad-brand)' : 'var(--blue-tint2)',
          }} />
        ))}
      </div>
    </div>
  );
}

function MiniSale() {
  return (
    <div className="pc pc-row" style={{ width: 178, gap: 11 }}>
      <span className="pc-ico" style={{ background: 'var(--win-tint)', color: 'var(--win)' }}>
        <Icons.Check size={17} />
      </span>
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
      <span className="pc-ico" style={{ background: 'linear-gradient(135deg,#FF8A3D,#FF5A36)', color: '#fff' }}>
        <Icons.Flame size={17} />
      </span>
      <div>
        <div style={{ fontSize: 16, fontWeight: 800, fontFamily: 'var(--mono)', letterSpacing: '-.02em' }}>12 days</div>
        <div className="pc-label" style={{ fontWeight: 500 }}>Sales streak</div>
      </div>
    </div>
  );
}

function MiniReport() {
  return (
    <div className="pc" style={{ width: 150 }}>
      <div className="pc-row" style={{ gap: 8, marginBottom: 8 }}>
        <span className="pc-ico" style={{ width: 26, height: 26, borderRadius: 8, background: 'var(--blue-tint)', color: 'var(--blue)' }}>
          <Icons.Chart size={15} />
        </span>
        <span style={{ fontSize: 12.5, fontWeight: 700, whiteSpace: 'nowrap' }}>Daily report</span>
      </div>
      {[[78,'Sales'], [54,'Stock'], [36,'Tax']].map(([w, l], i) => (
        <div key={i} style={{ marginBottom: 7 }}>
          <div style={{ fontSize: 10, color: 'var(--ink-3)', marginBottom: 3, fontWeight: 600 }}>{l}</div>
          <div style={{ height: 6, borderRadius: 999, background: 'var(--line)' }}>
            <div style={{ height: '100%', width: `${w}%`, borderRadius: 999, background: 'var(--grad-brand)' }} />
          </div>
        </div>
      ))}
    </div>
  );
}

function MiniBadge() {
  return (
    <div className="pc pc-row" style={{ width: 168, gap: 11 }}>
      <span className="pc-ico" style={{ width: 38, height: 38, borderRadius: '50%', background: 'var(--grad-xp)', color: '#fff', boxShadow: 'var(--sh-xp)' }}>
        <Icons.Trophy size={19} />
      </span>
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 13, fontWeight: 800 }}>Gold Seller</div>
        <div style={{ height: 5, borderRadius: 999, background: 'var(--line)', marginTop: 5 }}>
          <div style={{ height: '100%', width: '72%', borderRadius: 999, background: 'var(--grad-xp)' }} />
        </div>
      </div>
    </div>
  );
}

// Each slide arranges a few floats differently.
const SLIDES = [
  {
    key: 'run',
    h: <>Run your whole <em>business</em> from one app</>,
    sub: 'Sell, track stock, and manage your team — Flipper is your business in your pocket.',
    floats: [
      { c: <MiniChart />,  style: { top: '14%', left: '50%', marginLeft: -84, '--rot': '-4deg' }, delay: 0 },
      { c: <MiniSale />,   style: { top: '47%', left: '6%', '--rot': '5deg' }, delay: 1.2 },
      { c: <MiniReport />, style: { top: '52%', right: '4%', '--rot': '-6deg' }, delay: .6 },
    ],
  },
  {
    key: 'reports',
    h: <>Simple, useful <em>reports</em> that help you grow</>,
    sub: 'See exactly what sells, what’s running low, and where your money goes — every day.',
    floats: [
      { c: <MiniReport />, style: { top: '12%', left: '8%', '--rot': '-5deg' }, delay: .3 },
      { c: <MiniChart />,  style: { top: '34%', right: '4%', '--rot': '4deg' }, delay: 0 },
      { c: <MiniSale />,   style: { top: '62%', left: '12%', '--rot': '6deg' }, delay: .9 },
    ],
  },
  {
    key: 'paid',
    h: <>Get paid faster, <em>track every franc</em></>,
    sub: 'Accept MoMo, cash, and card. Flipper records every sale and reconciles it for you.',
    floats: [
      { c: <MiniSale />,   style: { top: '16%', right: '6%', '--rot': '-5deg' }, delay: .2 },
      { c: <MiniChart />,  style: { top: '40%', left: '6%', '--rot': '5deg' }, delay: 0 },
      { c: <MiniStreak />, style: { top: '66%', right: '10%', '--rot': '-4deg' }, delay: 1 },
    ],
  },
  {
    key: 'rewards',
    h: <>Grow your business, <em>earn rewards</em></>,
    sub: 'Hit daily goals, keep your streak alive, and level up from Bronze to Gold Seller.',
    floats: [
      { c: <MiniBadge />,  style: { top: '15%', left: '50%', marginLeft: -84, '--rot': '-3deg' }, delay: 0 },
      { c: <MiniStreak />, style: { top: '46%', left: '7%', '--rot': '6deg' }, delay: .7 },
      { c: <MiniSale />,   style: { top: '56%', right: '5%', '--rot': '-6deg' }, delay: 1.1 },
    ],
  },
];

function Welcome({ onCreate, onSignIn, intensity }) {
  const [i, setI] = useStateW(0);
  const playful = intensity === 'playful';
  const slide = SLIDES[i];

  // auto-advance only when playful
  useEffectW(() => {
    if (!playful) return;
    const t = setTimeout(() => setI((x) => (x + 1) % SLIDES.length), 5200);
    return () => clearTimeout(t);
  }, [i, playful]);

  return (
    <div className="welcome">
      <div className="welcome-top">
        <div className="welcome-brand">
          <FlipperLogo size={32} />
          <span className="wordmark">Flipper</span>
        </div>
        <button className="skip-btn" onClick={onSignIn}>Skip</button>
      </div>

      <div className="hero">
        <div className="hero-glow" />
        <div className="hero-rings" />
        {slide.floats.map((f, idx) => (
          <div key={slide.key + idx} className="float"
            style={{ ...f.style, animationDelay: `${f.delay}s` }}>
            {f.c}
          </div>
        ))}
      </div>

      <div className="welcome-copy">
        <h1 className="welcome-h">{slide.h}</h1>
        <p className="welcome-sub">{slide.sub}</p>
      </div>

      <div className="dots">
        {SLIDES.map((s, idx) => (
          <button key={s.key} className={`dot ${idx === i ? 'is-on' : ''}`} onClick={() => setI(idx)} aria-label={`Slide ${idx+1}`} />
        ))}
      </div>

      <div className="welcome-cta">
        <button className="btn btn-primary" onClick={i < SLIDES.length - 1 ? () => setI(i + 1) : onCreate}>
          {i < SLIDES.length - 1 ? 'Next' : 'Create account'}
          <Icons.ChevRight size={18} />
        </button>
        {i < SLIDES.length - 1 ? (
          <button className="btn-text" onClick={onCreate} style={{ alignSelf: 'center' }}>
            Skip intro — <b>Create account</b>
          </button>
        ) : (
          <button className="btn-text" onClick={onSignIn} style={{ alignSelf: 'center' }}>
            Already selling on Flipper? <b>Sign in</b>
          </button>
        )}
      </div>
    </div>
  );
}

window.Welcome = Welcome;
