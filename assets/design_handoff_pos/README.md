# Handoff: Flipper POS — Desktop Register

## Overview
The **desktop point-of-sale register** for **Flipper** (a business OS / POS app; primary market Rwanda, currency RWF). A cashier searches/taps products on the left, the cart fills on the right, and they tender payment + take change. This is the core "make a sale" screen, used on a desktop/tablet at a counter.

## About the design files
The files are a **design reference built in HTML + React-via-Babel + plain CSS** — a runnable, interactive prototype showing look and behavior. **Not production code to copy verbatim.** Rebuild it in the target stack (React + your styling, or whatever the Flipper web app uses) with that project's components, theming, routing, and data layer. Treat **CSS as the source of truth for tokens/spacing/type** and **JSX as the source of truth for structure/state/interaction**.

## Fidelity
**High-fidelity.** Match colors, type, spacing, radii, and the interaction model. Exception: the **Flipper logo** is an approximate recreation — use the official asset (`icons/flipper-logo.svg` provided here is the prototype's version).

---

## Canvas & responsiveness
- The prototype is authored on a **fixed 1440 × 912 canvas** and JS-scaled to fit the viewport (letterboxed on a dark stage) so it always shows whole. **This scaling is a prototype convenience — do NOT replicate it in production.** In the real app this is a normal fluid desktop layout:
  - Three columns: **left icon rail (64px, fixed)** · **catalog (fluid, center)** · **cart panel (460px, fixed)**.
  - Top bar is full-width and fixed. Catalog and cart each scroll independently.
- Minimum comfortable width ~1180px. Below tablet width this screen would need its own responsive treatment (out of scope here).

## Layout

```
┌──────────────────────────────────────────────────────────────────────┐
│ ◐ FLIPPER  Point of Sale   [▦][▥][🛒][▢][＋]      Home Transactions … 🔔 ↻⁰  V▾ │ top bar (64)
├──┬──────────────────────────────────────────┬──────────────────────────┤
│▦ │  [🔍 Search products…           ] [▥]     │ Amount to Change · Txn · Inv│
│👥│  Showing 1–16 of 194    Sort by latest ▾  ├──────────────────────────┤
│🛡│  ┌─────┐┌─────┐┌─────┐┌─────┐             │ 🔍 Search Customer  [walk][+]│
│▤ │  │ Cel ││ Cou ││ Uru ││ Ibi │  product   ├──────────────────────────┤
│📈│  └─────┘└─────┘└─────┘└─────┘  grid (4col)│  cart line items / empty   │
│… │  …                                        │  ▸ swatch  name  − qty +  ₣ │
│  │                                           │                            │
│  │  ‹ 1 2 3              Page 1 of 13 ›       │  Grand Total · n   RWF n   │
│  │                                           │  [tender ₣][CASH▾]         │
│  │                                           │  [Exact][5k][10k][20k]     │
│⎋ │                                           │  [ Tickets ][   Pay  ₣  ]  │
│⚙ │                                           │                            │
└──┴──────────────────────────────────────────┴──────────────────────────┘
```

---

## Design tokens
Reuses the shared Flipper tokens in `onboarding/styles.css` (full table in the other handoffs). POS-specific additions (top of `pos/pos.css`):

| Token | Value | Use |
|---|---|---|
| `--pos-bg` | `#F4F6FB` | app background |
| `--gain` / `--gain-ink` | `#16A34A` / `#15803D` | in-stock, change-due, positive |
| `--loss` / `--loss-ink` | `#E5484D` / `#B42318` | out-of-stock, delete |
| `--warnamber` | `#E08600` | low-stock |
| `--warn-tint` | `#FFF4E2` | low-stock badge bg |
| accent `--blue` | `#2563EB` | active nav, links, totals, Pay, focus (re-themeable; indigo `#4F46E5` also ok) |

**Type:** `Geist` (UI) + `Geist Mono` (ALL numerics — prices, totals, qty, stock counts, change, BCD, txn id). Keep the tabular-mono treatment.
- Product price 15 mono/700 · grand total 26 mono/700 (accent) · card name 14.5/700 · section labels 11–13.

**The product-tile palette (key part of this redesign).** The original used arbitrary pastels with poor contrast. Replace with a **fixed, harmonious 12-color family**, all medium-dark so **white text always passes contrast**:
```
#3B6FE0 #5457D6 #7A56E8 #9A5BC4 #C2557E #C76B45
#B5893B #5E8C3C #2E9E83 #2C8FB0 #5B7488 #9A6248
```
Assign a color **deterministically from the product name** (stable hash → index), so a product always gets the same tile color. The tile shows the product's first ~3 letters in white. (See `colorFor` / `hashIdx` / `abbr` in `pos/pos.jsx`.) In production, prefer a **real product image** when available and fall back to this colored initial tile.

**Dimensions:** top bar 64 · rail 64 · cart 460 · product card thumb 104 tall · grid `repeat(4, 1fr)` gap 14 · buttons 58 tall · fields 50–52 tall · cards radius `--r-md` (14px), `--sh-1`/`--sh-2` shadows.

---

## Components & behavior

### Top bar
Logo + "Point of Sale"; a tool cluster (catalog/scan/cart/customer-display/new); right-aligned primary nav (**Home** active, Transactions, EOD, Analytics) + open-display + more; notifications bell; **sync** button with a count badge; user chip (avatar "V" + VICTORIA / Branch).

### Left rail
Vertical module icons (catalog active), a spacer, then a **sign-out** (red on hover) and a **green settings cog** pinned at the bottom.

### Catalog (center)
- **Search** field (focus ring) + a **barcode-scan** button.
- Meta row: "Showing 1–N of 194 results" + "Sort by latest ▾".
- **Product grid** (4 cols). Each card = colored thumb with white initials, name, `BCD: {id}`, mono price, stock text. **Stock cues:**
  - `≤10` → amber **"Low"** badge + amber stock text.
  - `0` → grayed/desaturated tile, red **"Out"** badge, "Out of stock", **not clickable**.
  - in cart → a count pill (✓ n) on the thumb.
- Pagination (‹ 1 2 3 … ›, "Page n of 13").

### Cart (right)
- **Header chips:** "Amount to Change: RWF n" (accent), "Txn ID: …" (truncates), "Invoice No: 1".
- **Customer** search + action icons (walk-in, quick-add, support, add-customer).
- **Line items** (or empty state "No items yet / Tap a product to start a sale"): each line = color swatch + name + unit price, a **− qty +** stepper, line total (mono), and a delete (trash) button.
- **Footer:** "Grand Total · n items" + big mono total; when tender entered, a Tendered / Change subline; a **tender field** (mono) + **payment-method** selector (CASH); **quick-cash** buttons (Exact / 5,000 / 10,000 / 20,000); **Tickets** (ghost) + **Pay RWF n** (primary, disabled when empty).

---

## State & logic (lift into your store)
| State | Meaning |
|---|---|
| `cart` | map of productId → qty |
| `tender` | amount tendered (string) |
| `query` | catalog search text |
| `page` | catalog page |

Derived: `total = Σ price×qty`, `count = Σ qty`, `change = max(0, tender − total)`. Add caps qty at the product's `stock`. Decrement to 0 removes the line. `del` removes a line. Pay disabled when `total === 0`.

**Production data:** replace the hardcoded `PRODUCTS` array + 194/13-page counts with your catalog API (search, pagination, real stock, barcode lookup), and wire `Pay` to your checkout/payment service (the method selector → CASH/MoMo/Card, split payments). Stock thresholds (`≤10` low) should come from product settings.

## Assets — icons
All icons used on this screen are exported as clean standalone SVGs in **`icons/`** (1.5px stroke, 24×24, `currentColor` — recolor via CSS `color`). Preview them in **`icons/_icons-sheet.html`**. Files:
`home, refresh, wallet, chart, grid, barcode, cart, monitor, plus, arrow-up-right, more, bell, search, chevron-down, chevron-left, chevron-right, check, warn, minus, trash, walk, phone, user, users, shield-check, stack, receipt, clock, log-out, cog` + `flipper-logo.svg`.
These match Lucide/Phosphor closely if you prefer an icon-font dependency. **Fonts:** Geist + Geist Mono.

## Files in this bundle
- `Flipper POS.html` — entry; mounts the screen + accent tweak + fit-scaling (prototype only).
- `ANIMATIONS.md` — all motion/interaction notes (read before implementing).
- `icons/` — 31 standalone SVGs + logo + a preview sheet.
- `pos/pos.jsx` — the screen: catalog, cart logic, products, tender/change.
- `pos/pos.css` — POS tokens + all styles.
- `onboarding/styles.css` — shared design tokens + base primitives (dependency).
- `onboarding/frame.jsx` — `FlipperLogo`.
- `onboarding/icons.jsx` — the source icon set (React).
- `onboarding/tweaks-panel.jsx` — prototype-only controls (ignore for production).

To run: open `Flipper POS.html`, tap products to build a sale, try a quick-cash button.
