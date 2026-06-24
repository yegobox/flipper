const { useState, useEffect, useRef, useMemo } = React;

// ============================================================ Flipper logo
// Recreated brand mark: incomplete gradient ring (cyan→blue→indigo).
function FlipperLogo({ size = 40, radius }) {
  const r = radius != null ? radius : size * 0.3;
  const stroke = size * 0.17;
  const id = 'flg' + size;
  return (
    <span className="brandmark" style={{ width: size, height: size, borderRadius: r }}>
      <svg width={size} height={size} viewBox="0 0 48 48" fill="none">
        <defs>
          <linearGradient id={id} x1="6" y1="8" x2="42" y2="40" gradientUnits="userSpaceOnUse">
            <stop stopColor="#22D3EE" />
            <stop offset="0.5" stopColor="#2563EB" />
            <stop offset="1" stopColor="#4F46E5" />
          </linearGradient>
        </defs>
        <path
          d="M24 7.5a16.5 16.5 0 1 1-11.6 4.8"
          stroke={`url(#${id})`} strokeWidth={stroke} strokeLinecap="round" fill="none"
        />
        <path
          d="M24 16.5a7.5 7.5 0 1 0 5.3 2.2"
          stroke={`url(#${id})`} strokeWidth={stroke * 0.78} strokeLinecap="round" fill="none" opacity="0.55"
        />
      </svg>
    </span>
  );
}

// Logo inside a soft tinted disc (used on signup header / splash)
function FlipperBadge({ size = 84 }) {
  return (
    <div style={{
      width: size, height: size, borderRadius: '50%',
      background: 'var(--grad-brand-soft)',
      border: '1px solid var(--line)',
      display: 'grid', placeItems: 'center',
      boxShadow: 'var(--sh-2)',
    }}>
      <FlipperLogo size={size * 0.56} />
    </div>
  );
}

// ============================================================ Status bar
function StatusBar({ dark }) {
  const c = dark ? '#fff' : '#0B1220';
  return (
    <div className={`statusbar ${dark ? 'on-dark' : ''}`}>
      <span className="statusbar-time">9:41</span>
      <div className="statusbar-right">
        {/* signal */}
        <svg width="18" height="13" viewBox="0 0 18 13" fill={c}><rect x="0" y="9" width="3" height="4" rx="1"/><rect x="5" y="6" width="3" height="7" rx="1"/><rect x="10" y="3" width="3" height="10" rx="1"/><rect x="15" y="0" width="3" height="13" rx="1"/></svg>
        {/* wifi */}
        <svg width="17" height="13" viewBox="0 0 17 13" fill={c}><path d="M8.5 2.2c2.8 0 5.4 1.1 7.3 2.9l-1.5 1.6A8 8 0 0 0 8.5 4.4 8 8 0 0 0 2.7 6.7L1.2 5.1A10.4 10.4 0 0 1 8.5 2.2Zm0 4a6 6 0 0 1 4.2 1.7l-1.6 1.6a3.7 3.7 0 0 0-5.2 0L4.3 7.9A6 6 0 0 1 8.5 6.2Zm0 3.9c.6 0 1.2.2 1.6.7L8.5 12.8 6.9 10.8c.4-.5 1-.7 1.6-.7Z"/></svg>
        {/* battery */}
        <svg width="26" height="13" viewBox="0 0 26 13" fill="none"><rect x="0.5" y="0.5" width="22" height="12" rx="3.5" stroke={c} opacity="0.45"/><rect x="2.5" y="2.5" width="16" height="8" rx="2" fill={c}/><rect x="24" y="4" width="2" height="5" rx="1" fill={c} opacity="0.45"/></svg>
      </div>
    </div>
  );
}

// ============================================================ Phone shell
function Phone({ children, dark, navDark }) {
  return (
    <div className="stage">
      <div className="phone">
        <div className="phone-screen">
          <div className="notch" />
          <StatusBar dark={dark} />
          <div className="screen">{children}</div>
          <div className={`home-ind ${navDark ? 'on-dark' : ''}`}><div /></div>
        </div>
      </div>
    </div>
  );
}

// ============================================================ Progress ring
function Ring({ progress = 0, size = 44, stroke = 4, children }) {
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  return (
    <div style={{ position: 'relative', width: size, height: size, flexShrink: 0 }}>
      <svg width={size} height={size} style={{ transform: 'rotate(-90deg)' }}>
        <defs>
          <linearGradient id="ringg" x1="0" y1="0" x2="1" y2="1">
            <stop stopColor="#22D3EE" /><stop offset="0.6" stopColor="#2563EB" /><stop offset="1" stopColor="#4F46E5" />
          </linearGradient>
        </defs>
        <circle cx={size/2} cy={size/2} r={r} fill="none" stroke="var(--line)" strokeWidth={stroke} />
        <circle cx={size/2} cy={size/2} r={r} fill="none" stroke="url(#ringg)" strokeWidth={stroke}
          strokeLinecap="round" strokeDasharray={c} strokeDashoffset={c * (1 - progress)}
          style={{ transition: 'stroke-dashoffset .6s cubic-bezier(.22,.9,.3,1)' }} />
      </svg>
      <div style={{ position: 'absolute', inset: 0, display: 'grid', placeItems: 'center' }}>{children}</div>
    </div>
  );
}

// ============================================================ Confetti
function Confetti({ run, count = 80 }) {
  const pieces = useMemo(() => {
    const colors = ['#22D3EE', '#2563EB', '#4F46E5', '#FB9D00', '#10B981', '#FF5A36', '#FFC24B'];
    return Array.from({ length: count }).map((_, i) => ({
      id: i,
      left: Math.random() * 100,
      delay: Math.random() * 0.5,
      dur: 2.2 + Math.random() * 1.8,
      color: colors[i % colors.length],
      w: 6 + Math.random() * 6,
      h: 9 + Math.random() * 9,
      round: Math.random() > 0.6,
    }));
  }, [count]);
  if (!run) return null;
  return (
    <div className="confetti-layer">
      {pieces.map((p) => (
        <span key={p.id} className="confetti" style={{
          left: `${p.left}%`,
          width: p.w, height: p.round ? p.w : p.h,
          borderRadius: p.round ? '50%' : 2,
          background: p.color,
          animationDelay: `${p.delay}s`,
          animationDuration: `${p.dur}s`,
        }} />
      ))}
    </div>
  );
}

Object.assign(window, { FlipperLogo, FlipperBadge, StatusBar, Phone, Ring, Confetti });
