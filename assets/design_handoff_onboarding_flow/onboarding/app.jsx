const { useState: useStateA } = React;

// Tiny dashboard peek shown after "Enter Flipper" so the loop feels complete.
function DashPeek({ data, onRestart, intensity }) {
  return (
    <div className="signup fade-screen" style={{ background: 'var(--app)' }}>
      <div className="screen-scroll peek">
        <div className="row" style={{ justifyContent: 'space-between', marginBottom: 18 }}>
          <div className="row" style={{ gap: 11 }}>
            <div style={{ width: 44, height: 44, borderRadius: '50%', background: 'var(--grad-brand)', display: 'grid', placeItems: 'center', color: '#fff', fontWeight: 700 }}>
              {(data?.name || 'F').slice(0,1).toUpperCase()}
            </div>
            <div>
              <div style={{ fontSize: 12.5, color: 'var(--ink-3)' }}>Good morning</div>
              <div style={{ fontSize: 17, fontWeight: 700, letterSpacing: '-.01em' }}>{data?.name}</div>
            </div>
          </div>
          <div className="xp-chip"><span className="xp-coin"><Icons.Bolt size={11} /></span>{data?.xp || 150} XP</div>
        </div>

        <div style={{
          background: 'var(--grad-btn)', borderRadius: 'var(--r-lg)', padding: 18, color: '#fff',
          boxShadow: 'var(--sh-blue)', marginBottom: 14,
        }}>
          <div style={{ fontSize: 12.5, color: '#C8D7FB', fontWeight: 600 }}>Balance · points</div>
          <div style={{ fontFamily: 'var(--mono)', fontSize: 30, fontWeight: 700, letterSpacing: '-.02em', marginTop: 4 }}>
            {(data?.welcomePts || 500).toLocaleString()}
          </div>
          <div className="row" style={{ gap: 8, marginTop: 12 }}>
            <span className="lvl-medal" style={{ width: 30, height: 30 }}><Icons.Medal size={16} /></span>
            <span style={{ fontSize: 13, fontWeight: 600 }}>Bronze Seller</span>
            <div className="spacer" />
            <span style={{ fontSize: 12, color: '#C8D7FB' }}>350 to Silver →</span>
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 14 }}>
          {[
            { ico: 'Cart', l: 'New sale', c: 'var(--blue)' },
            { ico: 'Chart', l: 'Reports', c: 'var(--violet)' },
            { ico: 'Box', l: 'Inventory', c: 'var(--win)' },
            { ico: 'Flame', l: 'Daily goal', c: 'var(--xp-2)' },
          ].map((q) => {
            const Ico = Icons[q.ico];
            return (
              <div key={q.l} style={{ background: 'var(--surface)', border: '1px solid var(--line)', borderRadius: 'var(--r-md)', padding: 14, display: 'flex', alignItems: 'center', gap: 11, boxShadow: 'var(--sh-1)' }}>
                <span style={{ width: 38, height: 38, borderRadius: 11, display: 'grid', placeItems: 'center', background: 'color-mix(in srgb, ' + q.c + ' 12%, white)', color: q.c }}><Ico size={19} /></span>
                <span style={{ fontSize: 14, fontWeight: 600 }}>{q.l}</span>
              </div>
            );
          })}
        </div>

        <div style={{ background: 'linear-gradient(120deg,#FFFCF4,#FFF6E6)', border: '1px solid #FBE7C0', borderRadius: 'var(--r-md)', padding: 14, display: 'flex', alignItems: 'center', gap: 12 }}>
          <span className="reward-gift"><Icons.Gift size={20} /></span>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13.5, fontWeight: 700 }}>First daily goal</div>
            <div style={{ fontSize: 12, color: 'var(--ink-2)' }}>Log 1 sale today → <b style={{ color: 'var(--xp-2)' }}>+50 pts</b></div>
          </div>
          <Icons.ChevRight size={18} color="var(--ink-3)" />
        </div>

        <button className="btn-text" style={{ width: '100%', justifyContent: 'center', marginTop: 20 }} onClick={onRestart}>
          ↺ Replay onboarding from start
        </button>
      </div>
    </div>
  );
}

function App({ tweaks }) {
  const [screen, setScreen] = useStateA('welcome'); // welcome | signup | celebrate | dash
  const [data, setData] = useStateA(null);
  const intensity = tweaks.intensity;

  // status bar / nav tint per screen
  const dark = screen === 'celebrate';

  return (
    <Phone dark={dark} navDark={dark}>
      {screen === 'welcome' && (
        <Welcome
          intensity={intensity}
          onCreate={() => setScreen('signup')}
          onSignIn={() => setScreen('signup')}
        />
      )}
      {screen === 'signup' && (
        <Signup
          intensity={intensity}
          onBack={() => setScreen('welcome')}
          onDone={(d) => { setData(d); setScreen('celebrate'); }}
        />
      )}
      {screen === 'celebrate' && (
        <Celebrate data={data} intensity={intensity} onEnter={() => setScreen('dash')} />
      )}
      {screen === 'dash' && (
        <DashPeek data={data} intensity={intensity} onRestart={() => { setData(null); setScreen('welcome'); }} />
      )}
    </Phone>
  );
}

window.OnboardingApp = App;
