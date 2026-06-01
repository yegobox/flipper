// Stroke icons (1.5 stroke). All sized via parent font-size / width.
const I = ({ d, size = 16, stroke = 1.5, fill = 'none', extra }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill}
       stroke="currentColor" strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round"
       aria-hidden="true">
    {typeof d === 'string' ? <path d={d} /> : d}
    {extra}
  </svg>
);

const Icons = {
  Search: (p) => <I {...p} d={<><circle cx="11" cy="11" r="7" /><path d="m20 20-3.5-3.5" /></>} />,
  Download: (p) => <I {...p} d={<><path d="M12 4v12" /><path d="m7 11 5 5 5-5" /><path d="M5 20h14" /></>} />,
  Check: (p) => <I {...p} d="M5 12.5 10 17 19 7.5" />,
  Refresh: (p) => <I {...p} d={<><path d="M4 12a8 8 0 0 1 14-5.3L20 9" /><path d="M20 4v5h-5" /><path d="M20 12a8 8 0 0 1-14 5.3L4 15" /><path d="M4 20v-5h5" /></>} />,
  ChevDown: (p) => <I {...p} d="m6 9 6 6 6-6" />,
  ChevRight: (p) => <I {...p} d="m9 6 6 6-6 6" />,
  ChevLeft: (p) => <I {...p} d="m15 6-6 6 6 6" />,
  More: (p) => <I {...p} d={<><circle cx="5" cy="12" r="1.2" fill="currentColor" stroke="none" /><circle cx="12" cy="12" r="1.2" fill="currentColor" stroke="none" /><circle cx="19" cy="12" r="1.2" fill="currentColor" stroke="none" /></>} />,
  Eye: (p) => <I {...p} d={<><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z" /><circle cx="12" cy="12" r="3" /></>} />,
  X: (p) => <I {...p} d={<><path d="m6 6 12 12" /><path d="m18 6-12 12" /></>} />,
  Merge: (p) => <I {...p} d={<><path d="M5 4v4a4 4 0 0 0 4 4h6a4 4 0 0 1 4 4v4" /><path d="M16 17l3 3 3-3" transform="translate(-3 0)" /><path d="M2 7h6" /><path d="m5 4-3 3 3 3" /></>} />,
  Archive: (p) => <I {...p} d={<><rect x="3" y="4" width="18" height="4" rx="1" /><path d="M5 8v11a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V8" /><path d="M10 12h4" /></>} />,
  Share: (p) => <I {...p} d={<><path d="M4 12v7a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-7" /><path d="m8 8 4-4 4 4" /><path d="M12 4v12" /></>} />,
  Filter: (p) => <I {...p} d="M3 5h18l-7 9v6l-4-2v-4z" />,
  Calendar: (p) => <I {...p} d={<><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M3 9h18" /><path d="M8 3v4" /><path d="M16 3v4" /></>} />,
  SortDesc: (p) => <I {...p} d={<><path d="M7 4v16" /><path d="m3 16 4 4 4-4" /><path d="M14 6h7" /><path d="M14 11h5" /><path d="M14 16h3" /></>} />,
  Group: (p) => <I {...p} d={<><rect x="3" y="4" width="18" height="3" rx="1" /><rect x="3" y="10.5" width="18" height="3" rx="1" /><rect x="3" y="17" width="18" height="3" rx="1" /></>} />,
  Home: (p) => <I {...p} d={<><path d="m3 11 9-7 9 7" /><path d="M5 10v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9" /></>} />,
  Cart: (p) => <I {...p} d={<><path d="M3 4h2l2.5 11a2 2 0 0 0 2 1.6h7.5a2 2 0 0 0 2-1.6L21 8H6" /><circle cx="9" cy="20" r="1.2" fill="currentColor" stroke="none" /><circle cx="18" cy="20" r="1.2" fill="currentColor" stroke="none" /></>} />,
  Box: (p) => <I {...p} d={<><path d="M3 7.5 12 3l9 4.5v9L12 21l-9-4.5z" /><path d="M3 7.5 12 12l9-4.5" /><path d="M12 12v9" /></>} />,
  Chart: (p) => <I {...p} d={<><path d="M4 4v16h16" /><path d="m7 14 3-3 3 3 5-6" /></>} />,
  Users: (p) => <I {...p} d={<><circle cx="9" cy="9" r="3.5" /><path d="M3 19c0-3 3-5 6-5s6 2 6 5" /><circle cx="17" cy="8" r="2.5" /><path d="M16 14c2 0 5 1.5 5 4" /></>} />,
  Cog: (p) => <I {...p} d={<><circle cx="12" cy="12" r="3" /><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1Z" /></>} />,
  Bell: (p) => <I {...p} d={<><path d="M6 8a6 6 0 0 1 12 0c0 7 3 8 3 8H3s3-1 3-8" /><path d="M10 20a2 2 0 0 0 4 0" /></>} />,
  Plus: (p) => <I {...p} d={<><path d="M12 5v14" /><path d="M5 12h14" /></>} />,
  Sparkle: (p) => <I {...p} d="M12 3 13.8 9 20 10.5 13.8 12 12 18 10.2 12 4 10.5 10.2 9z" />,
  Clock: (p) => <I {...p} d={<><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></>} />,
  Dot: (p) => <I {...p} fill="currentColor" stroke="none" d="M12 8a4 4 0 1 1 0 8 4 4 0 0 1 0-8Z" />,
  Stack: (p) => <I {...p} d={<><path d="M4 7l8-4 8 4-8 4z" /><path d="M4 12l8 4 8-4" /><path d="M4 17l8 4 8-4" /></>} />,
  Wallet: (p) => <I {...p} d={<><path d="M3 7a2 2 0 0 1 2-2h12v3" /><path d="M3 7v10a2 2 0 0 0 2 2h14a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1H5a2 2 0 0 1-2-2Z" /><circle cx="17" cy="13.5" r="1.3" fill="currentColor" stroke="none" /></>} />,
  Receipt: (p) => <I {...p} d={<><path d="M6 3h12v18l-3-2-3 2-3-2-3 2z" /><path d="M9 8h6" /><path d="M9 12h6" /></>} />,
  TrendUp: (p) => <I {...p} d={<><path d="m4 15 5-5 4 4 7-7" /><path d="M16 7h4v4" /></>} />,
  ArrowUpRight: (p) => <I {...p} d={<><path d="M7 17 17 7" /><path d="M8 7h9v9" /></>} />,
  Phone: (p) => <I {...p} d={<><rect x="6" y="3" width="12" height="18" rx="2.5" /><path d="M11 18h2" /></>} />,
  Medal: (p) => <I {...p} d={<><circle cx="12" cy="14" r="6" /><path d="M9 8.5 7 3h4l1.5 3" /><path d="m15 8.5 2-5.5h-4l-1.5 3" /><path d="m12 11 1 2h2l-1.5 1.5.5 2-2-1-2 1 .5-2L11 13h2z" /></>} />,
  User: (p) => <I {...p} d={<><circle cx="12" cy="8" r="4" /><path d="M4 20c0-4 4-6 8-6s8 2 8 6" /></>} />,
  Info: (p) => <I {...p} d={<><circle cx="12" cy="12" r="9" /><path d="M12 11v5" /><path d="M12 7.5h.01" /></>} />,
  Print: (p) => <I {...p} d={<><path d="M7 9V3h10v6" /><path d="M7 17H5a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2h-2" /><rect x="7" y="14" width="10" height="7" rx="1" /></>} />,
  Hourglass: (p) => <I {...p} d={<><path d="M6 3h12" /><path d="M6 21h12" /><path d="M7 3c0 5 5 5 5 9s-5 4-5 9" /><path d="M17 3c0 5-5 5-5 9s5 4 5 9" /></>} />,
  Mail: (p) => <I {...p} d={<><rect x="3" y="5" width="18" height="14" rx="2.5" /><path d="m4 7 8 6 8-6" /></>} />,
  IdCard: (p) => <I {...p} d={<><rect x="3" y="5" width="18" height="14" rx="2.5" /><circle cx="8.5" cy="11" r="2" /><path d="M5.5 16c.4-1.5 1.6-2.2 3-2.2s2.6.7 3 2.2" /><path d="M14 10h4" /><path d="M14 13.5h3" /></>} />,
  Gift: (p) => <I {...p} d={<><rect x="3.5" y="8.5" width="17" height="12" rx="2" /><path d="M3.5 12.5h17" /><path d="M12 8.5v12" /><path d="M12 8.5C12 8.5 11 4.5 8.5 4.5a2 2 0 0 0 0 4Z" /><path d="M12 8.5C12 8.5 13 4.5 15.5 4.5a2 2 0 0 1 0 4Z" /></>} />,
  Flame: (p) => <I {...p} fill="currentColor" stroke="none" d="M13 2.5c.5 3-1.5 4.2-2.8 5.8C9 9.7 8.4 11 9.2 12.3c-1.6-.3-2.4-1.7-2.4-1.7C5.6 12 5 13.6 5 15.2 5 18.8 8.1 21.5 12 21.5s7-2.7 7-6.3c0-4.6-3.8-6.6-3.4-10.2-.9.5-1.9 1.4-2.6 2.8C12.6 6 12.4 4 13 2.5Z" />,
  Trophy: (p) => <I {...p} d={<><path d="M7 4h10v5a5 5 0 0 1-10 0z" /><path d="M7 5H4v1a3 3 0 0 0 3 3" /><path d="M17 5h3v1a3 3 0 0 1-3 3" /><path d="M12 14v3" /><path d="M8.5 21h7l-.5-3.5h-6z" /></>} />,
  Bolt: (p) => <I {...p} fill="currentColor" stroke="none" d="M13 2 4.5 13.5H11l-1 8.5 8.5-12H12z" />,
  Star: (p) => <I {...p} fill="currentColor" stroke="none" d="M12 3l2.6 5.4 5.9.8-4.3 4.1 1 5.9L12 16.9 6.8 19.2l1-5.9L3.5 9.2l5.9-.8z" />,
  Building: (p) => <I {...p} d={<><rect x="4" y="3" width="16" height="18" rx="2" /><path d="M9 7h2M9 11h2M9 15h2M13 7h2M13 11h2M13 15h2" /></>} />,
  Coins: (p) => <I {...p} d={<><ellipse cx="9" cy="7" rx="5" ry="2.5" /><path d="M4 7v5c0 1.4 2.2 2.5 5 2.5s5-1.1 5-2.5V7" /><path d="M10 14.5c.6 1.2 2.6 2 5 2 2.8 0 5-1.1 5-2.5v-5c0-1.4-2.2-2.5-5-2.5-1 0-1.9.1-2.7.4" /></>} />,
  ShieldCheck: (p) => <I {...p} d={<><path d="M12 3 5 6v5c0 4.5 3 7.6 7 9 4-1.4 7-4.5 7-9V6z" /><path d="m9 11.5 2 2 4-4" /></>} />,
  AtSign: (p) => <I {...p} d={<><circle cx="12" cy="12" r="4" /><path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-3.9 7.9" /></>} />,
  MapPin: (p) => <I {...p} d={<><path d="M12 21s7-5.6 7-11a7 7 0 1 0-14 0c0 5.4 7 11 7 11Z" /><circle cx="12" cy="10" r="2.5" /></>} />,
  Store: (p) => <I {...p} d={<><path d="M4 9 5.2 4.5A1 1 0 0 1 6.2 4h11.6a1 1 0 0 1 1 .8L20 9" /><path d="M4 9h16v2a3 3 0 0 1-6 0 3 3 0 0 1-6 0 3 3 0 0 1-4 .3" /><path d="M5 11.5V20h14v-8.5" /><path d="M9.5 20v-4.5h5V20" /></>} />,
  LogOut: (p) => <I {...p} d={<><path d="M14 4h4a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1h-4" /><path d="M10 8 6 12l4 4" /><path d="M6 12h11" /></>} />,
  Warn: (p) => <I {...p} d={<><path d="M12 4 2.5 20h19z" /><path d="M12 10v4" /><path d="M12 17.5h.01" /></>} />,
  Grid: (p) => <I {...p} d={<><rect x="3.5" y="3.5" width="7" height="7" rx="1.5" /><rect x="13.5" y="3.5" width="7" height="7" rx="1.5" /><rect x="3.5" y="13.5" width="7" height="7" rx="1.5" /><rect x="13.5" y="13.5" width="7" height="7" rx="1.5" /></>} />,
  ArrowUp: (p) => <I {...p} d={<><path d="M12 19V5" /><path d="m6 11 6-6 6 6" /></>} />,
  ArrowDown: (p) => <I {...p} d={<><path d="M12 5v14" /><path d="m6 13 6 6 6-6" /></>} />,
  Tag: (p) => <I {...p} d={<><path d="M11.5 3.5 21 13l-8 8L3.5 11.5V4.5a1 1 0 0 1 1-1z" /><circle cx="8" cy="8" r="1.4" fill="currentColor" stroke="none" /></>} />,
  Truck: (p) => <I {...p} d={<><rect x="2.5" y="6" width="11" height="9" rx="1.5" /><path d="M13.5 9H18l3 3v3h-7.5z" /><circle cx="7" cy="17.5" r="1.6" /><circle cx="17" cy="17.5" r="1.6" /></>} />,
  Minus: (p) => <I {...p} d="M5 12h14" />,
  Trash: (p) => <I {...p} d={<><path d="M4 7h16" /><path d="M9 7V5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" /><path d="M6 7l1 13a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1l1-13" /><path d="M10 11v6M14 11v6" /></>} />,
  Monitor: (p) => <I {...p} d={<><rect x="3" y="4" width="18" height="12" rx="2" /><path d="M9 20h6" /><path d="M12 16v4" /></>} />,
  Barcode: (p) => <I {...p} d={<><path d="M4 6v12M7 6v12M10 6v9M13 6v12M16 6v9M19 6v12M21.5 6v12" /></>} />,
  Walk: (p) => <I {...p} d={<><circle cx="13" cy="4.5" r="1.6" /><path d="M11 21l1.5-6L10 12V8l4 1 2 3" /><path d="M12.5 15 9 21" /><path d="m14 9 1 6" /></>} />,
};

// Excel-style file glyph — restrained, not branded.
const ExcelGlyph = ({ size = 28 }) => (
  <svg width={size} height={size} viewBox="0 0 32 32" aria-hidden="true">
    <rect x="4.5" y="3.5" width="23" height="25" rx="3" fill="#F7FAF7" stroke="#CFE0D2" />
    <path d="M19 3.5v6a2 2 0 0 0 2 2h6.5" stroke="#CFE0D2" fill="none" />
    <rect x="8" y="15" width="16" height="9" rx="1" fill="#0E5132" />
    <path d="M8 18.5h16M8 22h16M13.5 15v9M18.5 15v9" stroke="#F7FAF7" strokeWidth="0.9" />
  </svg>
);

Object.assign(window, { Icons, ExcelGlyph });
