# Handoff: Flipper Income — Transaction Detail

## Overview
The **transaction detail screen** for **Flipper** (a business OS / POS app; primary market Rwanda, currency RWF). It shows a single completed **income** transaction: amount, status, method/reference, the products sold, and a timeline of events — with two expandable sections and a sticky action bar. This is a **mobile** screen (designed inside a ~412px phone shell, portrait).

This is a redesign of an existing screen. The original used a heavy full-bleed green header block and a loose, low-density layout; this version brings it into the Flipper system (clean light surface, mono numerics, soft cards).

### Design intent (keep these decisions)
- **No full-bleed colored header.** The old screen wrapped the top third in solid green. This version uses a neutral light background with a **white hero card** + a thin gradient accent line — color is used sparingly (status, amount sign), not as a slab.
- **Amount is the hero, in mono with a signed prefix.** `+ RWF 3,500` — the green `+` signals income (direction), the digits are tabular **Geist Mono** (the premium-fintech tell used across Flipper).
- **Surface the real transaction attributes.** The original only showed the date. A transaction record intrinsically has a **payment method** and a **reference** — those are shown in a compact meta strip (not filler; core data).
- **Expandable sections do real work.** Products and Timeline collapse/expand with animated height, so the screen stays scannable but detail is one tap away.

## About the design files
The files are a **design reference built in HTML + React-via-Babel + plain CSS** — a runnable, interactive prototype. **Not production code to copy verbatim.** Rebuild in the target stack (**React Native / Expo is the natural fit**; Flutter/native also fine) using that project's components, navigation, theming, and data layer. Treat **CSS as the source of truth for tokens/spacing/type** and **JSX as the source of truth for structure/state/interaction**.

## Fidelity
**High-fidelity.** Match colors, type, spacing, radii, motion, and copy. Exception: the phone frame (`Phone`, status bar, home indicator in `frame.jsx`) is a prototype device mock — drop it; your app runs full-screen on a real device.

---

## Layout (top → bottom)

```
┌──────────────────────────────────────┐
│ ‹   Income                        ⋯   │  header (fixed)
├──────────────────────────────────────┤  (scroll ↓)
│  ╭──────── hero card ───────────╮     │
│  │        ● COMPLETED           │     │  status pill
│  │      ↗ Income received       │     │  direction
│  │     +  RWF  3,500            │     │  mono amount
│  │   Created Jun 02, 2026·11:40 │     │
│  │  ┌ METHOD ────┬ REFERENCE ─┐ │     │  meta strip (2 cells)
│  │  │ ▢ Cash     │ #INC-4821  │ │     │
│  ╰───────────────────────────────╯     │
│  ╭ 🛒 Products            1 item  ⌄╮   │  expandable (open)
│  │   Coupe Coupe   1×RWF 3,500    │   │
│  │   Subtotal           RWF 3,500 │   │
│  ╰───────────────────────────────╯     │
│  ╭ 🕑 Transaction Timeline 2 events ⌄╮ │  expandable (collapsed)
│  │   ● Payment received …          │  │
│  │   ● Sale created …              │  │
│  ╰───────────────────────────────╯     │
├──────────────────────────────────────┤
│ [ ⋯ More Actions ] [ ▤ Invoice ]      │  footer (fixed)
└──────────────────────────────────────┘
```

- **Structure:** flex column inside the phone — **fixed header**, **flex-1 scroll area** (hero + sections), **fixed footer**. Only the middle scrolls.

---

## Design tokens
Reuses the shared Flipper tokens in `onboarding/styles.css` (full table in the other handoffs). Income-specific additions (top of `income/income.css`):

| Token | Value | Use |
|---|---|---|
| `--inc-bg` | `#F4F6FB` | screen background |
| `--gain` | `#16A34A` | income green — status dot, amount sign, trend |
| `--gain-ink` | `#15803D` | income text on light |
| `--gain-tint` | `#E7F6EE` | status pill / icon tile bg |
| `--gain-soft` | `#F1FAF5` | hero radial wash |
| `--loss` | `#E5484D` | (for the expense variant — see below) |
| accent `--blue` | `#2563EB` | products icon, Invoice primary button |

**Type:** `Geist` (UI) + `Geist Mono` (ALL numerics — amount, reference, line prices, subtotal, timestamps). Keep the tabular-mono treatment; it's the core signal.
Sizes: header title 18/700 · status pill 12/800 tracked · **amount value 52 mono/700**, "RWF" mark 19/600 muted, "+" sign 40/600 green · section title 16/700 · meta key 11 uppercase/700 · meta value 14/700.

**Dimensions:** header icon buttons 40px · hero radius `--r-xl` (26px) · section cards `--r-lg` (20px) · meta cells split 1fr/1fr with a hairline gap · footer buttons 54px · timeline node 30px.

---

## Components & behavior

### Header (fixed)
Back button (circular, `--surface` + border), "Income" title, and a more (⋯) menu button. Both buttons are 40px tap targets with press-scale.

### Hero card
- **Status pill** — `COMPLETED` (green: dot + tinted pill). A **`pending`** variant exists in CSS (amber) — use it for unsettled transactions.
- **Direction line** — trend icon + "Income received" (green). For an **expense/refund**, swap to a down-trend + `--loss` red and a `−` sign.
- **Amount** — baseline-aligned row: green **`+`** sign · muted **`RWF`** · large mono **value**. Format with thousands separators.
- **Created** line — "Created {date} · {time}".
- **Meta strip** — a 2-cell grid (hairline-divided): **Method** (icon + label, e.g. Cash/MoMo/Card) and **Reference** (mono id). Extend with more cells (Customer, Branch, Cashier) if your record has them — keep 2 per row.

### Expandable sections (`Section` component)
- A card with a tappable header (icon tile + title + sub-count + chevron) and a body that animates **height** between 0 and its measured content height.
- **Products** (open by default): one row per line item — colored initial swatch, name, `qty × unit` (mono), line total (mono) — then a **Subtotal** row. The count sub ("1 item") pluralizes.
- **Transaction Timeline** (collapsed by default): a vertical **connector rail** (node + line) with events. Each event: a node (done = green check tile / pending = muted dot), title, detail line, and a mono timestamp. Most-recent first.
- Chevron rotates 180° when open; only one needs to be open at a time but they're independent.

### Footer (fixed)
Two buttons: **More Actions** (ghost — opens an actions sheet: share, download receipt, refund, delete, etc.) and **Invoice** (blue primary — generate/send an invoice for this transaction).

---

## State & data (lift into your store)
| State | Meaning |
|---|---|
| `openProd` | Products section expanded |
| `openTl` | Timeline section expanded |

The screen is otherwise **driven entirely by the transaction record** you pass in. Prototype hardcodes it; replace with your API. Expected shape:
```
{
  id, reference,            // '#INC-4821'
  direction: 'income'|'expense',
  status: 'completed'|'pending'|…,
  amount, currency,         // 3500, 'RWF'
  method,                   // 'Cash' | 'MoMo' | 'Card'
  createdAt,                // → 'Jun 02, 2026 · 11:40 PM'
  items: [{ name, qty, price }],
  timeline: [{ title, detail, time, done }],
}
```
Derive `subtotal = Σ qty×price`; the section sub-counts come from `items.length` / `timeline.length`. Status drives the pill variant; direction drives the sign + color (green income / red expense). Wire **More Actions** and **Invoice** to your real flows.

## Assets — icons
Inline 1.5px-stroke React icons in `onboarding/icons.jsx` (24×24, `currentColor`). Used here: `ChevLeft, More, ChevDown, TrendUp, Wallet, Cart, Clock, Check, Dot, Receipt`. Map to Lucide/Phosphor or your set.
> Standalone-SVG exports of the overlapping icon set were delivered with the **desktop POS handoff** (`design_handoff_pos/icons/`) — reuse those. **Fonts:** Geist + Geist Mono (Google Fonts).

## Files in this bundle
- `Flipper Income Detail.html` — entry; mounts the screen in the phone frame.
- `ANIMATIONS.md` — **all motion, framework-neutral. Read before implementing animation.**
- `income/income.css` — income-screen tokens + all styles.
- `income/income.jsx` — the screen: hero, the reusable `Section` (animated expand), products, timeline.
- `onboarding/styles.css` — shared design tokens + base primitives (dependency).
- `onboarding/frame.jsx` — `Phone` shell (drop in production).
- `onboarding/icons.jsx` — inline icon set.

To run: open `Flipper Income Detail.html`; tap the section headers to expand/collapse.
