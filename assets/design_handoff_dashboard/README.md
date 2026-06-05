# Handoff: Flipper Dashboard (mobile home)

## Overview
The **post-login home screen** of **Flipper** (a business OS / POS app; primary market Rwanda, currency RWF). It's the first thing a user sees after choosing a business + branch. It surfaces the headline profit number, stock value, revenue/expenses, a daily-goal nudge, persistent bottom navigation, and an **"All apps" launcher** (the **More** tab) that opens every Flipper module.

This is a **mobile** screen (designed inside a ~412px phone shell, portrait).

## About the design files
The files are a **design reference built in HTML + React-via-Babel + plain CSS** — a runnable prototype showing look, motion, and behavior. **Not production code to copy verbatim.** Rebuild it in the target stack (React Native / Expo is the natural fit for this mobile app; Flutter/native also fine) using that project's components, theming, navigation, and data layer. Treat **CSS as the source of truth for tokens/spacing/type**, **JSX as the source of truth for structure/state/interaction**.

## Fidelity
**High-fidelity.** Match colors, type, spacing, radii, motion, and copy. Exception: the **Flipper logo** is an approximate recreation of the brand ring mark — replace with the official asset.

---

## Layout (top → bottom)

```
┌──────────────────────────────────────┐
│ [logo] Flipper        🔥12   [DE]     │  ← header (fixed)
├──────────────────────────────────────┤
│ Today  This Week  This Month  This… → │  ← period pills (scroll-x)
│ [Net Profit]  [Gross Profit]          │  ← metric toggle
├──────────────────────────────────────┤  (scroll area ↓)
│  ╭───────── gauge card ──────────╮     │
│  │      ◜‾‾‾‾◝   RWF              │     │
│  │     (   2.28M  )              │     │  ← semicircle gauge
│  │      ↑18% vs last month       │     │
│  │      Net profit · This Month  │     │
│  │ ─────────────┬───────────────  │     │
│  │ GROSS PROFIT │ TAX & EXPENSES  │     │  ← split footer
│  ╰───────────────────────────────╯     │
│  ╭ Stock value ........ RWF 3.9B ╮     │
│  │ ▓▓▓▓▓▓▓▓░░░░░░                 │     │
│  │ ⚠ 3 items low      Full report›│     │
│  ╰───────────────────────────────╯     │
│  ╭ Revenue ╮  ╭ Expenses ╮            │  ← 2-up stat cards
│  ╭ 🎁 Today's goal · 8 of 10 ─────╮   │  ← daily goal (gamified)
├──────────────────────────────────────┤
│ Home  Sales  [＋]  Inventory  More    │  ← bottom tab bar (fixed)
└──────────────────────────────────────┘    ＋ = New sale FAB
```

- **Structure:** the screen is a flex column inside the phone: **fixed header**, **fixed selector block**, **flex-1 scroll area** (cards), **fixed bottom tab bar**. Only the card region scrolls.
- The **More** tab opens the **All apps sheet** (bottom sheet overlay, see below).

---

## Design tokens
Reuses the shared Flipper tokens in `onboarding/styles.css` (see the onboarding handoff for the full table). Dashboard-specific additions (defined at the top of `dashboard/dashboard.css`):

| Token | Value | Use |
|---|---|---|
| `--db-bg` | `#F4F6FB` | screen background behind cards |
| `--gain` | `#10B981` | profit / revenue (green) |
| `--gain-tint` | `#E6F7EF` | green tile bg |
| `--gain-ink` | `#047857` | green text on light |
| `--loss` | `#E5484D` | expenses / loss (red) |
| `--loss-tint` | `#FDECEC` | red tile bg |
| `--loss-ink` | `#B42318` | red text on light |
| accent `--blue` | `#2563EB` | active states, links, FAB, gauge end (re-themeable; indigo `#4F46E5` also approved) |
| `--grad-brand` | `linear-gradient(135deg,#22D3EE,#2563EB,#4F46E5)` | logo, stock bar, gauge fill |
| `--grad-xp` | `linear-gradient(135deg,#FFC24B,#FB9D00,#FF7A00)` | daily-goal accents |

**Type:** `Geist` (UI) + `Geist Mono` (ALL numerics — gauge value, money, deltas, badges). The tabular-mono numerics are the core "premium fintech" signal — keep them.
Sizes: gauge value mono **38**/700; stock value mono **24**; stat value mono **21**; section labels 11 uppercase; period pill 14.5; "RWF" currency marks are smaller/muted next to the figures.

**Key dimensions:** period pill h **40** / radius pill; metric pill h **38**; cards radius `--r-lg` (20px), `--sh-1` shadow, 1px `--line`; bottom-nav FAB **58×58** radius 19 with a 4px surface-colored ring, lifted **−28px** above the bar; app-tile icon **54×54** radius 17.

---

## Components & behavior

### Header
- Flipper logo + wordmark (left). Right: a **streak chip** ("🔥 12" — amber pill, mono) and a **brand-gradient avatar** ("DE" initials, rounded square). The streak chip is **hidden when gamification intensity = `subtle`**. Avatar is tappable (→ account/switch; stub here).

### Period selector
- Horizontally **scrollable** pill row: `Today · This Week · This Month · This Year`. Active pill = solid `--ink-1` (near-black) with white text; inactive = white with `--line` border. `white-space: nowrap` on each (so "This Month" never wraps).

### Metric toggle
- Two pills: `Net Profit` / `Gross Profit`. Active = blue text on `--blue-tint` with blue border. Switches which value the gauge shows.

### Gauge card (hero)
- A **180° semicircle gauge**. Track is `--line`; the **fill arc** is a left→right gradient (`#10B981 → #22D3EE → #2563EB`), round caps. Small endpoint dots: green (left/start), red (right/end).
- **Fill fraction** = profit margin = `value / revenue`, clamped 0–1 (`value` = net or gross profit per the toggle).
- **Center readout:** "RWF" label, the big mono value (compact-formatted, see below), a delta chip ("↑ 18% vs last month", green tint), and a caption "Net profit · This Month".
- **Split footer:** two cells — **Gross profit** (green dot + green value) | **Tax & expenses** (red dot + red value), divided by a hairline.
- **Empty state** (no transactions): grey arc (no fill), value "0", chip reads "No transactions yet" (neutral), split values greyed. In the prototype, selecting **Today** triggers this state — keep an explicit empty state in production.

### Stock value card
- Icon + "Stock value" label, big mono value (`RWF 3.9B`). A progress bar (brand gradient) showing stock level. Footer: a low-stock warning ("3 items low on stock", amber when >0, neutral when 0) and a "Full report ›" link in **`--blue`** (not cyan).

### Revenue / Expenses (2-up grid)
- Two cards. Revenue = green up-arrow tile, mono value, "↑ X% up" green delta. Expenses = red down-arrow tile, mono value, red delta. Both greyed to "0" in empty state.

### Daily goal (gamified)
- Amber gradient card: gift icon, "Today's goal · 8 of 10 sales", "Just 2 more to **+50 pts**", and an amber progress track. **Hidden when intensity = `subtle`.**

### Bottom tab bar
- 5 slots: **Home · Sales · [New sale FAB] · Inventory · More**. The center **FAB** is a raised blue gradient "+" button (label "New sale") for the primary POS action. Active tab tinted `--blue`. **More** opens the All apps sheet (does not change the active content tab).

### All apps sheet (the **More** launcher) — KEY ADDITION
- A **bottom sheet** that slides up over a dark scrim. Contains: grab handle, title "All apps" + subtitle "Everything in {business}", close (X).
- **Body** = four labelled sections, each a **4-column grid** of app tiles (colored rounded icon tile + label). Tiles in the prototype:
  - **Sell:** Quick Sell, Invoices, Pricing, Payments
  - **Manage:** Inventory *(red "3" badge)*, Purchases, Customers, Suppliers
  - **Insights:** Reports, Daily Reports, Commissions, Tax & VAT
  - **Business:** Team, Branches, Activity, Settings
- Tile icon tint = `color-mix(in srgb, {color} 13%, white)` background with the full color as the icon — replace with your design system's module colors. Badges (e.g. low-stock count) sit top-right of the tile.
- Closes on: X, scrim tap, or selecting a tile. Body scrolls if it overflows.
- **In production:** this is the module launcher — wire each tile to its route. (Note: *Daily Reports* and *Commissions* are separate screens we've already designed — link those if present.)

---

## State (lift into your store / navigation)
| State | Type | Meaning |
|---|---|---|
| `period` | `today│week│month│year` | drives the dataset shown |
| `metric` | `net│gross` | which profit the gauge shows |
| `tab` | nav key | active bottom-nav content tab |
| `appsOpen` | boolean | All apps sheet visibility |

**Data:** the prototype hardcodes a per-period dataset `{ txns, revenue, cogs, tax, deltaNet, deltaRev, deltaExp }` and derives `gross = revenue−cogs`, `expenses = cogs+tax`, `net = revenue−expenses`. Replace with your analytics API per selected period/branch. `txns === 0` ⇒ empty state.

**Money formatting (`money()`):** compact — `≥1e9 → x.xB`, `≥1e6 → x.xM`, `≥1e4 → xK`, else thousands-separated. Currency prefix "RWF" rendered as a smaller muted mark.

## Gamification intensity (config)
Single setting (default `balanced`), same as the rest of the app:
- **subtle:** hide the header streak chip and the daily-goal card.
- **balanced / playful:** show both. (This screen doesn't use confetti; intensity only gates the streak chip + goal card here.)

## Assets
- **Flipper logo** — recreated ring mark (`FlipperLogo` in `frame.jsx`); replace with official asset.
- **Icons** — inline 1.5px-stroke set in `icons.jsx` (Home, Cart, Box, Grid, Plus, Stack, Warn, ArrowUp/Down, TrendUp, ChevRight, Flame, Gift, Coins, Receipt, Tag, Truck, Users, Store, Building, Bell, Cog, Wallet, Chart, X). Map to Lucide/Phosphor or your set.
- **Phone shell** (`Phone`, `StatusBar`, home indicator) is a prototype device frame — drop it; your app runs full-screen on a real device.
- **Fonts:** Geist + Geist Mono (Google Fonts).

## Files in this bundle
- `Flipper Dashboard.html` — entry; mounts the screen, theme tokens, intensity + accent tweaks.
- `ANIMATIONS.md` — **all motion, framework-neutral. Read before implementing animation.**
- `dashboard/dashboard.jsx` — the screen: gauge, cards, bottom nav, All apps sheet, data.
- `dashboard/dashboard.css` — dashboard tokens + all dashboard/sheet styles & keyframes.
- `onboarding/styles.css` — shared design tokens + base primitives (dependency).
- `onboarding/frame.jsx` — `Phone` shell + `FlipperLogo`.
- `onboarding/icons.jsx` — inline icon set.
- `onboarding/tweaks-panel.jsx` — prototype-only controls (ignore for production).

To run: open `Flipper Dashboard.html`. Switch period to **Today** for the empty state; tap **More** for the app launcher.
