// ===========================================================
//  Flipper Accounting · charts + small shared components
// ===========================================================
const { useState: useAccState } = React;

// Revenue vs Expenses, 6 months. style: 'bars' | 'area' | 'line'
function TrendChart({ data, style = 'bars', height = 196 }) {
  const W = 620, H = height, padL = 8, padR = 8, padT = 14, padB = 26;
  const max = Math.max(...data.map((d) => Math.max(d.rev, d.exp))) * 1.12;
  const iw = W - padL - padR, ih = H - padT - padB;
  const x = (i) => padL + (iw / data.length) * (i + 0.5);
  const y = (v) => padT + ih - (v / max) * ih;
  const colW = (iw / data.length) * 0.62;

  const linePath = (key) => data.map((d, i) => `${i ? 'L' : 'M'} ${x(i).toFixed(1)} ${y(d[key]).toFixed(1)}`).join(' ');
  const areaPath = (key) => `${linePath(key)} L ${x(data.length - 1).toFixed(1)} ${padT + ih} L ${x(0).toFixed(1)} ${padT + ih} Z`;

  return (
    <svg viewBox={`0 0 ${W} ${H}`} width="100%" style={{ display: 'block' }} preserveAspectRatio="none">
      <defs>
        <linearGradient id="revArea" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" style={{ stopColor: 'var(--blue)', stopOpacity: 0.22 }} />
          <stop offset="1" style={{ stopColor: 'var(--blue)', stopOpacity: 0 }} />
        </linearGradient>
      </defs>
      {/* gridlines */}
      {[0.25, 0.5, 0.75, 1].map((g) => (
        <line key={g} x1={padL} x2={W - padR} y1={padT + ih * (1 - g)} y2={padT + ih * (1 - g)}
          stroke="var(--line)" strokeWidth="1" strokeDasharray="2 4" />
      ))}

      {style === 'bars' && data.map((d, i) => (
        <g key={i}>
          <rect x={x(i) - colW / 2} y={y(d.rev)} width={colW * 0.46} height={padT + ih - y(d.rev)}
            rx="3" style={{ fill: 'var(--blue)' }} />
          <rect x={x(i) + colW * 0.02} y={y(d.exp)} width={colW * 0.46} height={padT + ih - y(d.exp)}
            rx="3" style={{ fill: 'var(--ink-4)', opacity: 0.55 }} />
        </g>
      ))}

      {style === 'area' && (
        <>
          <path d={areaPath('rev')} fill="url(#revArea)" />
          <path d={linePath('rev')} fill="none" style={{ stroke: 'var(--blue)' }} strokeWidth="2.5" strokeLinejoin="round" strokeLinecap="round" />
          <path d={linePath('exp')} fill="none" style={{ stroke: 'var(--ink-4)' }} strokeWidth="2" strokeDasharray="5 4" strokeLinejoin="round" strokeLinecap="round" />
        </>
      )}

      {style === 'line' && (
        <>
          <path d={linePath('rev')} fill="none" style={{ stroke: 'var(--blue)' }} strokeWidth="2.5" strokeLinejoin="round" strokeLinecap="round" />
          <path d={linePath('exp')} fill="none" style={{ stroke: 'var(--loss)', opacity: 0.7 }} strokeWidth="2.5" strokeLinejoin="round" strokeLinecap="round" />
          {data.map((d, i) => (
            <g key={i}>
              <circle cx={x(i)} cy={y(d.rev)} r="3.5" style={{ fill: 'var(--surface)', stroke: 'var(--blue)' }} strokeWidth="2" />
              <circle cx={x(i)} cy={y(d.exp)} r="3" style={{ fill: 'var(--surface)', stroke: 'var(--loss)' }} strokeWidth="2" opacity="0.75" />
            </g>
          ))}
        </>
      )}

      {/* month labels */}
      {data.map((d, i) => (
        <text key={i} x={x(i)} y={H - 8} textAnchor="middle" style={{ fill: 'var(--ink-3)', fontSize: 11, fontFamily: 'var(--mono)' }}>{d.m}</text>
      ))}
    </svg>
  );
}

// Donut for composition. segments: [{label,value,color}]
function Donut({ segments, size = 150, thickness = 22, center }) {
  const total = segments.reduce((s, x) => s + x.value, 0) || 1;
  const r = (size - thickness) / 2;
  const c = 2 * Math.PI * r;
  let off = 0;
  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
      <g transform={`rotate(-90 ${size / 2} ${size / 2})`}>
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="var(--line)" strokeWidth={thickness} />
        {segments.map((s, i) => {
          const len = (s.value / total) * c;
          const el = (
            <circle key={i} cx={size / 2} cy={size / 2} r={r} fill="none"
              stroke={s.color} strokeWidth={thickness}
              strokeDasharray={`${len} ${c - len}`} strokeDashoffset={-off}
              strokeLinecap="butt" />
          );
          off += len;
          return el;
        })}
      </g>
      {center && (
        <foreignObject x="0" y="0" width={size} height={size}>
          <div style={{ height: '100%', display: 'grid', placeItems: 'center', textAlign: 'center' }}>{center}</div>
        </foreignObject>
      )}
    </svg>
  );
}

// progress bar (cash gauge etc)
function MiniBar({ pct, color = 'var(--blue)', track = 'var(--line)', h = 8 }) {
  return (
    <div style={{ height: h, borderRadius: 999, background: track, overflow: 'hidden' }}>
      <div style={{ width: `${Math.max(0, Math.min(100, pct))}%`, height: '100%', background: color, borderRadius: 999, transition: 'width .5s cubic-bezier(.22,.9,.3,1)' }} />
    </div>
  );
}

Object.assign(window, { TrendChart, Donut, MiniBar });
