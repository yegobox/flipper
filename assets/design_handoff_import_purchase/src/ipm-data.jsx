/* ipm-data.jsx — icons, sample data, helpers (exported to window) */
const { useState, useMemo, useRef, useEffect, useCallback } = React;

/* ---------- Icons ---------- */
const Icon = {
  back: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M15 5l-7 7 7 7" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  download: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M12 4v11m0 0 4-4m-4 4-4-4M5 19h14" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  import: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M12 14V4m0 10 3.5-3.5M12 14 8.5 10.5M5 16v2a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-2" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  cart: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M3 4h2l1.6 10.4a1.5 1.5 0 0 0 1.5 1.3h7.9a1.5 1.5 0 0 0 1.5-1.2L20 7H6" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/><circle cx="9.5" cy="19.5" r="1.4" fill="currentColor"/><circle cx="17" cy="19.5" r="1.4" fill="currentColor"/></svg>),
  chev: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="m6 9 6 6 6-6" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  search: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><circle cx="11" cy="11" r="7" stroke="currentColor" strokeWidth="1.8"/><path d="m20 20-3.2-3.2" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round"/></svg>),
  check: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="m5 12.5 4.5 4.5L19 7" stroke="currentColor" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  checkCircle: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><circle cx="12" cy="12" r="9" stroke="currentColor" strokeWidth="1.8"/><path d="m8 12 2.5 2.5L16 9" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  xCircle: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><circle cx="12" cy="12" r="9" stroke="currentColor" strokeWidth="1.8"/><path d="m9 9 6 6m0-6-6 6" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round"/></svg>),
  x: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M6 6l12 12M18 6 6 18" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round"/></svg>),
  pencil: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 20h4l10-10a2 2 0 0 0-2.8-2.8L5 17.2 4 20Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="m13.5 6.5 4 4" stroke="currentColor" strokeWidth="1.7"/></svg>),
  plusDoc: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M6 3h7l5 5v9a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="M13 3v5h5M12 11v5m-2.5-2.5h5" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  inbox: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 13 6.5 5.5A2 2 0 0 1 8.4 4h7.2a2 2 0 0 1 1.9 1.5L20 13v5a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-5Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><path d="M4 13h4l1.5 2.5h5L16 13h4" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/></svg>),
  tag: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 4h7l9 9-7 7-9-9V4Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/><circle cx="8" cy="8" r="1.4" fill="currentColor"/></svg>),
  filter: (p) => (<svg viewBox="0 0 24 24" fill="none" {...p}><path d="M4 5h16l-6 7v6l-4-2v-4L4 5Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round"/></svg>),
};

const Brand = (p) => (
  <svg viewBox="0 0 48 48" fill="none" {...p}>
    <defs><linearGradient id="flg" x1="6" y1="8" x2="42" y2="40" gradientUnits="userSpaceOnUse">
      <stop stopColor="#22D3EE"/><stop offset="0.5" stopColor="var(--accent)"/><stop offset="1" stopColor="#4F46E5"/>
    </linearGradient></defs>
    <path d="M24 7.5a16.5 16.5 0 1 1-11.6 4.8" stroke="url(#flg)" strokeWidth="8.16" strokeLinecap="round" fill="none"/>
    <path d="M24 16.5a7.5 7.5 0 1 0 5.3 2.2" stroke="url(#flg)" strokeWidth="6.36" strokeLinecap="round" fill="none" opacity="0.55"/>
  </svg>
);

/* ---------- helpers ---------- */
const fmt = (n) => new Intl.NumberFormat("en-US", { maximumFractionDigits: 2 }).format(n);
const fmt0 = (n) => new Intl.NumberFormat("en-US").format(Math.round(n));
let _uid = 100;
const uid = () => ++_uid;

const VARIANTS = ["Sandals", "FP0057", "FP0072", "Hero", "FP0059", "FP0073", "Loafers", "Sneakers Pro", "FP0061", "Office Flat"];

/* import items awaiting variant assignment + pricing */
const IMPORT_SEED = [
  { id: 1, item: "MUVURA-002", hs: "7323930000", qty: "460.0 U", retail: 0, supply: 0, status: "wait", supplier: "MUVURA LTD", date: "a moment ago", variant: "" },
  { id: 2, item: "Sandals", hs: "6404190000", qty: "120.0 U", retail: 120, supply: 100, status: "wait", supplier: "MUVURA LTD", date: "a minute ago", variant: "Sandals" },
  { id: 3, item: "NBA-014", hs: "6402990000", qty: "85.0 U", retail: 0, supply: 0, status: "wait", supplier: "Kampala Footwear", date: "12 minutes ago", variant: "" },
  { id: 4, item: "FP0072 Canvas", hs: "6404110000", qty: "300.0 U", retail: 45000, supply: 32000, status: "approved", supplier: "Equator Imports", date: "an hour ago", variant: "FP0072" },
  { id: 5, item: "Hero Runner", hs: "6403910000", qty: "210.0 U", retail: 88000, supply: 61000, status: "approved", supplier: "Equator Imports", date: "2 hours ago", variant: "Hero" },
  { id: 6, item: "LeatherSole-X", hs: "6406100000", qty: "40.0 U", retail: 0, supply: 0, status: "rejected", supplier: "Nile Traders", date: "yesterday", variant: "" },
  { id: 7, item: "FP0059", hs: "6402190000", qty: "150.0 U", retail: 52000, supply: 39000, status: "wait", supplier: "Kampala Footwear", date: "yesterday", variant: "FP0059" },
];

/* purchase invoices grouped by supplier */
const PURCHASE_SEED = [
  {
    id: 1, supplier: "MUVURA LTD", invoice: "3182", time: "a moment ago", status: "waiting",
    items: [
      { id: 11, name: "NBA 002", qty: 1, supply: 587607.95, retail: 587607.95, status: "waiting", variant: "" },
      { id: 12, name: "MUVURA-002", qty: 460, supply: 410, retail: 480, status: "waiting", variant: "" },
      { id: 13, name: "Sandals", qty: 120, supply: 100, retail: 120, status: "waiting", variant: "Sandals" },
    ],
  },
  {
    id: 2, supplier: "Equator Imports", invoice: "2974", time: "3 hours ago", status: "waiting",
    items: [
      { id: 21, name: "FP0072 Canvas", qty: 300, supply: 32000, retail: 45000, status: "waiting", variant: "FP0072" },
      { id: 22, name: "Hero Runner", qty: 210, supply: 61000, retail: 88000, status: "waiting", variant: "Hero" },
    ],
  },
  {
    id: 3, supplier: "Kampala Footwear", invoice: "1183", time: "yesterday", status: "approved",
    items: [
      { id: 31, name: "FP0059", qty: 150, supply: 39000, retail: 52000, status: "approved", variant: "FP0059" },
      { id: 32, name: "Office Flat", qty: 90, supply: 28000, retail: 41000, status: "approved", variant: "Office Flat" },
      { id: 33, name: "Loafers", qty: 60, supply: 47000, retail: 69000, status: "approved", variant: "Loafers" },
    ],
  },
];

const groupTotal = (g) => g.items.reduce((s, it) => s + it.supply * it.qty, 0);

Object.assign(window, {
  Icon, Brand, fmt, fmt0, uid, VARIANTS, IMPORT_SEED, PURCHASE_SEED, groupTotal,
});
