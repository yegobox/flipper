/* ===== Flipper · Stock Recount — data + helpers ===== */

// ---- product catalog (searchable / barcode-scannable) ----
const RC_CATALOG = [
  { id: 'p1',  name: 'Umuceri (Rice 25kg)',     sku: '393993', barcode: '6001240100013', system: 3 },
  { id: 'p2',  name: 'Amplifier 200W',          sku: 'AMP200',  barcode: '6009880023417', system: 2000 },
  { id: 'p3',  name: 'Inyange Water 1L',        sku: 'INY-1L',  barcode: '6009510800127', system: 540 },
  { id: 'p4',  name: 'Coca-Cola 50cl',          sku: 'CC-50',   barcode: '5449000000996', system: 288 },
  { id: 'p5',  name: 'Sugar (Kabuye 1kg)',      sku: 'SGR-1K',  barcode: '6001240200027', system: 96 },
  { id: 'p6',  name: 'Cooking Oil 1L',          sku: 'OIL-1L',  barcode: '6009690140031', system: 120 },
  { id: 'p7',  name: 'Akabanga 25ml',           sku: 'AKB-25',  barcode: '6009880011049', system: 64 },
  { id: 'p8',  name: 'Bralirwa Primus 72cl',    sku: 'PRM-72',  barcode: '6009510801025', system: 240 },
  { id: 'p9',  name: 'Bread (Sliced 600g)',     sku: 'BRD-600', barcode: '6001240300037', system: 45 },
  { id: 'p10', name: 'Milk (Inyange 1L)',       sku: 'MLK-1L',  barcode: '6009510800134', system: 180 },
  { id: 'p11', name: 'Soap (Maisha 250g)',      sku: 'SOP-250', barcode: '6001240400041', system: 150 },
  { id: 'p12', name: 'Eggs (Tray of 30)',       sku: 'EGG-30',  barcode: '6001240500055', system: 36 },
];

const RC_BRANCH = { business: 'Kigali General Store', branch: 'Nyabugogo Branch', counter: 'Richard M.' };

// ---- helpers ----
function rcUid() { return 'r' + Math.random().toString(36).slice(2, 9); }

function rcAbbr(name) {
  const w = String(name).trim().split(/\s+/);
  return ((w[0]?.[0] || '') + (w[1]?.[0] || w[0]?.[1] || '')).toUpperCase();
}

const RC_SWATCHES = ['#2563EB', '#7C3AED', '#0EA5A4', '#E0529C', '#F59E0B', '#10B981', '#6366F1', '#EF6C3B'];
function rcColor(seed) {
  let h = 0; const s = String(seed);
  for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
  return RC_SWATCHES[h % RC_SWATCHES.length];
}

function rcFmtDate(ts) {
  return new Date(ts).toLocaleDateString('en-US', { month: 'short', day: '2-digit', year: 'numeric' });
}
function rcFmtTime(ts) {
  return new Date(ts).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false });
}
function rcFmtDateTime(ts) { return `${rcFmtDate(ts)} · ${rcFmtTime(ts)}`; }
function rcNum(n) { return Number(n || 0).toLocaleString('en-US'); }

// variance of a single counted item
function rcVar(it) { return (Number(it.counted) || 0) - (Number(it.system) || 0); }

// aggregate stats for a session's items
function rcStats(items) {
  let match = 0, over = 0, short = 0, net = 0, sys = 0, counted = 0;
  items.forEach((it) => {
    const v = rcVar(it);
    net += v; sys += Number(it.system) || 0; counted += Number(it.counted) || 0;
    if (v === 0) match++; else if (v > 0) over++; else short++;
  });
  return { count: items.length, match, over, short, net, sys, counted };
}

// ---- seed sessions ----
function rcSeed() {
  const now = Date.now();
  const day = 86400000;
  return [
    {
      id: 'sess_richard',
      device: 'Device richard-',
      note: '',
      status: 'draft',
      createdAt: now - 2 * 3600000,
      items: [
        { id: rcUid(), name: 'Umuceri (Rice 25kg)', sku: '393993', system: 3, counted: 12, countedAt: now - 3600000 },
        { id: rcUid(), name: 'Inyange Water 1L', sku: 'INY-1L', system: 540, counted: 540, countedAt: now - 3000000 },
        { id: rcUid(), name: 'Coca-Cola 50cl', sku: 'CC-50', system: 288, counted: 274, countedAt: now - 2400000 },
      ],
    },
    {
      id: 'sess_5bcb',
      device: 'Device 5BCB7586',
      note: 'Monthly full-shelf recount',
      status: 'submitted',
      createdAt: now - 89 * day,
      submittedAt: now - 88 * day,
      items: [
        { id: rcUid(), name: 'Amplifier 200W', sku: 'AMP200', system: 2000, counted: 10000, countedAt: now - 89 * day },
        { id: rcUid(), name: 'Sugar (Kabuye 1kg)', sku: 'SGR-1K', system: 96, counted: 96, countedAt: now - 89 * day },
      ],
    },
    {
      id: 'sess_synced',
      device: 'Device A1F2-POS',
      note: 'Beverages aisle',
      status: 'synced',
      createdAt: now - 120 * day,
      submittedAt: now - 119 * day,
      items: [
        { id: rcUid(), name: 'Bralirwa Primus 72cl', sku: 'PRM-72', system: 240, counted: 232, countedAt: now - 120 * day },
        { id: rcUid(), name: 'Akabanga 25ml', sku: 'AKB-25', system: 64, counted: 64, countedAt: now - 120 * day },
        { id: rcUid(), name: 'Milk (Inyange 1L)', sku: 'MLK-1L', system: 180, counted: 188, countedAt: now - 120 * day },
      ],
    },
  ];
}

const RC_STATUS = {
  draft:     { label: 'Draft',     tone: 'amber' },
  submitted: { label: 'Submitted', tone: 'blue' },
  synced:    { label: 'Synced',    tone: 'green' },
};

Object.assign(window, {
  RC_CATALOG, RC_BRANCH, RC_STATUS, rcUid, rcAbbr, rcColor,
  rcFmtDate, rcFmtTime, rcFmtDateTime, rcNum, rcVar, rcStats, rcSeed,
});
