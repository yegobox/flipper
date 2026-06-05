const { useState: useStateC, useEffect: useEffectC } = React;

function Celebrate({ data, onEnter, intensity }) {
  const subtle = intensity === 'subtle';
  const playful = intensity === 'playful';
  const [count, setCount] = useStateC(0);
  const target = data?.welcomePts || 500;

  // count-up the points
  useEffectC(() => {
    let raf, start;
    const dur = 1100;
    const tick = (t) => {
      if (!start) start = t;
      const p = Math.min(1, (t - start) / dur);
      const eased = 1 - Math.pow(1 - p, 3);
      setCount(Math.round(eased * target));
      if (p < 1) raf = requestAnimationFrame(tick);
    };
    const d = setTimeout(() => { raf = requestAnimationFrame(tick); }, 350);
    return () => { clearTimeout(d); cancelAnimationFrame(raf); };
  }, [target]);

  return (
    <div className="celebrate fade-screen">
      <Confetti run={!subtle} count={playful ? 110 : 70} />
      <div className="celebrate-glow" />

      <div className="cel-scroll">
        <div style={{ position: 'relative', display: 'grid', placeItems: 'center' }}>
          {!subtle && <div className="cel-badge-ring" />}
          <div className="trophy"><Icons.Trophy size={54} /></div>
        </div>

        <div className="cel-eyebrow">Welcome to Flipper</div>
        <h1 className="cel-h">You’re in{playful ? ' 🎉' : ''}</h1>
        <p className="cel-sub">Nice work, {data?.name}. Your account is ready — and you’ve already started earning.</p>

        {/* reward card */}
        <div className="reward-card">
          <div className="reward-card-top">
            <span className="reward-coin-lg"><Icons.Coins size={26} /></span>
            <div>
              <div className="reward-card-amt">+{count.toLocaleString()}</div>
              <div className="reward-card-lbl">Welcome points unlocked</div>
            </div>
            <div className="spacer" />
            <span style={{
              fontFamily: 'var(--mono)', fontSize: 12, fontWeight: 700, color: '#BFD3FF',
              border: '1px solid rgba(255,255,255,.25)', borderRadius: 999, padding: '4px 9px',
            }}>+{data?.xp || 150} XP</span>
          </div>

          <div className="reward-card-divider" />

          <div className="lvl-row">
            <span className="lvl-medal"><Icons.Medal size={22} /></span>
            <div className="lvl-info">
              <div className="lvl-name">Level 1 · Bronze Seller</div>
              <div className="lvl-next">350 pts to Silver Seller</div>
              <div className="lvl-track"><i /></div>
            </div>
          </div>
        </div>

        {/* streak */}
        <div className="streak-row">
          <span className="streak-flame"><Icons.Flame size={19} color="#fff" /></span>
          <div className="streak-txt">
            <div className="streak-t">Day 1 streak started{playful ? ' 🔥' : ''}</div>
            <div className="streak-d">Log a sale tomorrow to keep it alive</div>
          </div>
          <div className="streak-pips">
            <i className="on" /><i /><i /><i /><i /><i /><i />
          </div>
        </div>

        <div style={{ height: 8 }} />
      </div>

      <div className="cel-foot">
        <button className="btn btn-on-blue" onClick={onEnter}>
          Enter Flipper <Icons.ArrowUpRight size={18} />
        </button>
      </div>
    </div>
  );
}

window.Celebrate = Celebrate;
