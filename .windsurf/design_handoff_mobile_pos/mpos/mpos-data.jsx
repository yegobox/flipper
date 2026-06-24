/* ===== Flipper Mobile POS · data + helpers ===== */

// medium-dark harmonious palette — white text always legible
const MP_COLORS = ['#3B6FE0','#5457D6','#7A56E8','#9A5BC4','#C2557E','#C76B45','#B5893B','#5E8C3C','#2E9E83','#2C8FB0','#5B7488','#9A6248'];
function mpHash(s) { let h = 0; for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0; return h; }
function mpColor(name) { return MP_COLORS[mpHash(name) % MP_COLORS.length]; }
function mpAbbr(name) {
  const parts = String(name).trim().split(/\s+/);
  if (parts.length >= 2) return (parts[0][0] + parts[1][0]).toUpperCase();
  return name.slice(0, 2).toUpperCase();
}
function mpMoney(n) {
  const v = Math.round(Number(n) || 0);
  return v.toLocaleString('en-US');
}

const MP_PRODUCTS = [
  { id: 1,  name: 'Smoke 006',        bcd: 'SMK006', price: 30,    stock: 80  },
  { id: 2,  name: 'Coupe Coupe',      bcd: 'CPC012', price: 2400,  stock: 367 },
  { id: 3,  name: 'Fanta Citron',     bcd: 'FNT028', price: 800,   stock: 142 },
  { id: 4,  name: 'Inyange Water 1L', bcd: 'INY101', price: 600,   stock: 9   },
  { id: 5,  name: 'Bralirwa Primus',  bcd: 'BRL220', price: 1500,  stock: 54  },
  { id: 6,  name: 'Bread Loaf',       bcd: 'BRD003', price: 1200,  stock: 0   },
  { id: 7,  name: 'Sugar 1kg',        bcd: 'SGR010', price: 1800,  stock: 233 },
  { id: 8,  name: 'Cooking Oil 1L',   bcd: 'OIL015', price: 3500,  stock: 6   },
  { id: 9,  name: 'Rice 5kg',         bcd: 'RCE050', price: 8900,  stock: 47  },
  { id: 10, name: 'Soap Bar',         bcd: 'SOP008', price: 700,   stock: 310 },
  { id: 11, name: 'Airtime 1000',     bcd: 'AIR100', price: 1000,  stock: 999 },
  { id: 12, name: 'Matches Box',      bcd: 'MTC002', price: 100,   stock: 4   },
];

const MP_CUSTOMERS = [
  { id: 'c1', name: 'Murangwa Eric', phone: '0783 054 874' },
  { id: 'c2', name: 'Mutoni Claire', phone: '0788 120 145' },
  { id: 'c3', name: 'Keza Diane',    phone: '0722 901 663' },
  { id: 'c4', name: 'Habimana Jean', phone: '0733 445 902' },
];

const MP_PAY_METHODS = [
  { id: 'cash', label: 'Cash',  icon: 'Wallet' },
  { id: 'momo', label: 'MoMo',  icon: 'Phone'  },
  { id: 'card', label: 'Card',  icon: 'Receipt' },
];

Object.assign(window, { MP_COLORS, mpColor, mpAbbr, mpMoney, MP_PRODUCTS, MP_CUSTOMERS, MP_PAY_METHODS });
