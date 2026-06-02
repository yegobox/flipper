# Handoff: Flipper Mobile POS — Sale Flow

## Overview
The **mobile point-of-sale sale flow** for **Flipper** (a business OS / POS app; primary market Rwanda, currency RWF). A cashier on a phone builds a cart from the catalog, reviews it, optionally attaches a customer, takes payment, and completes the sale. This is a re-imagined, cleaner version of an existing flow — three connected screens plus one slide-up sheet:

1. **Catalog** — search/scan + product list, add to cart, persistent bottom cart bar.
2. **Checkout** — one screen: Customer · Items · Payment · Totals, with a single primary action.
3. **Success** — confirmation + receipt summary.
4. **Customer picker** — a bottom sheet opened from Checkout.

### Design intent (what this redesign fixed vs. the old flow — keep these)
- **One cart surface, not many.** A single **persistent bottom cart bar** replaces the old top "cart card" + the competing **Tickets/Items** toggle. It only appears once the cart is non-empty.
- **No stacked sheets.** Checkout is a full screen with clear sections, not sheets-on-sheets.
- **No blocking success modal for small actions.** Attaching a customer shows a **lightweight toast**, not a "Success → Continue" modal that interrupts the sale.
- **Quantity inline.** The product row's **＋** becomes a **− n ＋** pill in place, so qty is adjustable without leaving the list.
- **One clear primary action** per screen, gated by validity (Complete is disabled until cash covers the total).

## About the design files
The files are a **design reference built in HTML + React-via-Babel + plain CSS** — a runnable, interactive prototype. **Not production code to copy verbatim.** Rebuild in the target stack (**React Native / Expo is the natural fit**; Flutter/native also fine) using that project's components, navigation, theming, and data layer. Treat **CSS as the source of truth for tokens/spacing/type** and **JSX as the source of truth for structure/state/interaction**.

## Fidelity
**High-fidelity.** Match colors, type, spacing, radii, motion, and copy. Exception: the phone frame (`Phone`, status bar, home indicator in `frame.jsx`) is a prototype device mock — drop it; your app runs full-screen on a real device. The **Flipper logo** isn't used on these screens.

---

## Design tokens
Reuses the shared Flipper tokens in `onboarding/styles.css` (full table in the other handoffs). Mobile-POS additions (top of `mpos/mpos.css`):

| Token | Value | Use |
|---|---|---|
| `--mpos-bg` | `#F4F6FB` | screen background |
| `--mpos-head` | `#FFFFFF` | header / cards |
| `--gain` / `--gain-ink` / `--gain-tint` | `#16A34A` / `#15803D` / `#E7F6EE` | in-stock, change, success |
| `--loss` / `--loss-ink` / `--loss-tint` | `#E5484D` / `#B42318` / `#FDECEC` | out-of-stock, balance due, delete |
| `--warnamber` / `--warn-tint` | `#B7791F` / `#FBF1DC` | low-stock badge |
| `--pend` / `--pend-tint` | `#D97706` / `#FCEFD6` | PENDING status pill |
| accent `--blue` | `#2563EB` | add buttons, links, active states, primary CTA |
| `--grad-btn` | `linear-gradient(180deg,#2C6BF0,#1D4ED8)` | cart bar + Complete (pending) |

**Type:** `Geist` (UI) + `Geist Mono` (ALL numerics — prices, totals, qty, stock, tender, change, time). Keep the tabular-mono treatment; it's the "premium fintech" signal.
Sizes: header title 17/700 · section labels 11.5 uppercase/800 · product name 15/700 · price 14.5 mono · grand total 24 mono · cart-bar total 18 mono · success H1 28/800.

**Product/customer tile palette (important).** Avatars/thumbs use a **fixed 12-color family**, all medium-dark so **white text always passes contrast**:
```
#3B6FE0 #5457D6 #7A56E8 #9A5BC4 #C2557E #C76B45
#B5893B #5E8C3C #2E9E83 #2C8FB0 #5B7488 #9A6248
```
Pick the color **deterministically from the name** (stable string hash → index) and show 2-letter initials in white. In production, use a real **product image** when available, falling back to this colored initial tile. (See `mpColor` / `mpAbbr` / `mpHash` in `mpos/mpos-data.jsx`.)

**Money:** `mpMoney()` = thousands-separated integer (`2,400`), always prefixed with a smaller muted "RWF".

**Dimensions:** product/add button 40px · cart bar button 60px · checkout primary 56px · fields 48–56px · tap targets ≥40px · cards radius `--r-lg` (20px) / `--r-md` (14px) · sheet corner radius 26px.

---

## Screens

### 1. Catalog (`mpos-catalog.jsx`)
- **Header** (fixed, white): back button · "New sale" + "Walk-in · {time}" · **PENDING** status pill (amber). Below: a **search** field (focus ring) + a **Scan** button (blue-tint).
- **Meta row:** "{n} of {total} products" + a "Latest ▾" sort control.
- **Product rows** (scroll): colored thumb (initials) · name + BCD (mono) · price (mono) + **stock badge** (`≤10` → amber "N left", `0` → red "Out of stock", else green "N left") · trailing control:
  - not in cart → blue **＋** add button (disabled + row dimmed when out of stock).
  - in cart → blue **− n ＋** qty pill (＋ capped at stock).
- **Sticky bottom cart bar** (fixed): when empty, a muted "Tap a product to start a sale". When non-empty, a blue gradient button: **count badge · "{n} items in cart" + RWF total · "Review & Pay ›"** → goes to Checkout.

### 2. Checkout (`mpos-checkout.jsx`)
- **Header:** back · "Checkout" + "{n} items · {time}" · PENDING pill.
- **Customer section:** a card. If none: "Walk-in customer / Tap to attach a customer (optional)" + "Add ›" → opens the customer sheet. If attached: colored avatar + name + phone + an **✕** to clear.
- **Items section:** card listing each line — colored swatch, name, "RWF {price} each" (+ "edited" flag if overridden), line total; a row below with a **− n ＋ stepper**, a **Price** toggle, and a **trash** button. **Price** expands an inline editor: a labelled unit-price field with an **RWF prefix chip**, mono input, and a **reset** icon (restores default) when overridden. Below the card: a dashed **"Add more items"** button → back to Catalog.
- **Payment method:** card with 3 chips — **Cash / MoMo / Card** (selected = blue border + tint). Selecting **Cash** reveals a **tender field** (RWF prefix, mono) + **quick-cash** buttons (**Exact** / 5,000 / 10,000 / 20,000).
- **Totals:** card — Subtotal, Tax (0), **Total** (grand), and when cash tendered: **Change** (green) or **Balance due** (red), computed live.
- **Footer** (fixed): **Save ticket** (ghost) + **Complete · RWF {total}** (primary). Complete is **disabled** until `total > 0` AND (method ≠ cash OR tendered ≥ total); when ready it turns **green**.

### 3. Customer picker sheet (`mpos-app.jsx` → `CustomerSheet`)
- A bottom sheet over a scrim: grab handle, "Attach customer" title, ✕ close. A search field (name/phone), a **"Continue as walk-in"** row, then customer rows (avatar · name · phone) and a dashed **"Add new customer"**. Picking a customer closes the sheet and fires a toast.

### 4. Success (`mpos-app.jsx` → `Success`)
- Full green gradient screen: confetti, a check tile, "Sale complete", a subline ("{METHOD} · {n} items · {customer|Walk-in}"), a glassy **receipt card** (Total paid / Tendered / Change), and footer buttons **New sale** (resets to catalog) + **Print receipt**.

---

## State & logic (lift into your store)
| State | Meaning |
|---|---|
| `screen` | `catalog │ checkout │ done` |
| `cart` | map productId → qty |
| `prices` | map productId → custom unit-price override |
| `customer` | attached customer object or `null` (walk-in) |
| `method` | `cash │ momo │ card` |
| `tender` | cash amount tendered (string) |
| `custOpen` | customer sheet visibility |
| `toast` | transient confirmation text |
| `done` | snapshot passed to the success screen |

Derived: line `price = override ?? basePrice`; `total = Σ price×qty`; `count = Σ qty`; `change = max(0, tender − total)`; `due = max(0, total − tender)`. Qty caps at product `stock`; decrement to 0 removes the line. `complete()` snapshots `{total, count, method, customer, tendered, change}` and navigates to success; **New sale** clears everything.

**Production data:** replace the hardcoded `MP_PRODUCTS` / `MP_CUSTOMERS` with your catalog + customer APIs (search, pagination, real stock, barcode lookup). Wire **Complete** to your checkout/payment service (Cash/MoMo/Card; MoMo likely needs a phone-number + "request payment" step — not in this prototype). **Save ticket** should persist a held/parked sale. Stock thresholds (`≤10` low) come from product settings.

## Assets — icons
All icons are inline 1.5px-stroke React components in `onboarding/icons.jsx` (24×24, `currentColor`). Used here: `ChevLeft, ChevRight, ChevDown, Search, Barcode, Plus, Minus, Cart, Tag, Trash, Refresh, User, Walk, Phone, Wallet, Receipt, Check, X`. Map to Lucide/Phosphor or your set. **Fonts:** Geist + Geist Mono (Google Fonts).
> A standalone-SVG export of the icon set was delivered with the **desktop POS handoff** (`design_handoff_pos/icons/`) — reuse those files; the set overlaps.

## Files in this bundle
- `Flipper POS Mobile.html` — entry; mounts the app inside the phone frame.
- `ANIMATIONS.md` — **all motion, framework-neutral. Read before implementing animation.**
- `mpos/mpos.css` — mobile-POS tokens + all styles & keyframes.
- `mpos/mpos-data.jsx` — products, customers, payment methods, helpers (`mpColor/mpAbbr/mpMoney`).
- `mpos/mpos-catalog.jsx` — Catalog screen.
- `mpos/mpos-checkout.jsx` — Checkout screen + inline price editor.
- `mpos/mpos-app.jsx` — customer sheet, success screen, flow controller/state.
- `onboarding/styles.css` — shared design tokens + base primitives (dependency).
- `onboarding/frame.jsx` — `Phone` shell + `Confetti` (success). Drop the Phone in production; keep a Confetti equivalent.
- `onboarding/icons.jsx` — inline icon set.

To run: open `Flipper POS Mobile.html`, add products, tap **Review & Pay**, attach a customer, enter cash, **Complete**.
