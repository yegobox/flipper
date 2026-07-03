# Handoff: Print Delegations (HTML + CSS)

## Overview
A redesigned **Print Delegations** screen for the **Flipper Books** POS. It lists transactions that were delegated across tills, with a live search box and a status filter (All / Failed / Delegated / Completed). Each delegation shows a status icon, till name, timestamp, a status badge, and a detail panel (Receipt Type, Payment, Amount). Currency is **RWF** throughout.

## About the Design Files
The files in this bundle are a **design reference implemented in plain HTML + CSS** (plus a small vanilla-JS render/filter layer). They show the intended look and behavior. They are directly runnable, but the intent is that you **recreate this design in your target codebase's environment** (React/Vue/Flutter/etc.) using its existing patterns, components, and data layer — or, if starting fresh, use these files as-is. The `DELEGATIONS` array in the HTML is placeholder data; wire it to your real API response.

## Fidelity
**High-fidelity.** Final colors, typography, spacing, radii, shadows, and interactions. Match these values exactly.

---

## Screen: Print Delegations

### Layout
- Page background `#EEF1EE`. Content centered in a container `max-width: 1080px`, padding `40px 32px 64px`.
- Vertical stack: **Header → Search → Filters → List** (or **Empty state** when no results).

### Header
- Row: title block (flex:1) on the left, a **40×40** round-`11` info icon-button on the right (border `1px #E6EAE6`, bg white, icon `#5E6F66`; hover → bg `#F4F8F5`, icon/`border` green `#12B76A`/`#CFEBD9`).
- **Title** "Print Delegations" — serif **Spectral** `30px` weight `600`, `letter-spacing:-0.015em`, line-height `1.08`, color `#0B2A20`.
- **Subtitle** `13.5px` `#5E6F66`: "Track and manage transactions delegated across your tills — **N** in view." (N = current visible count, bold `#0B2A20`).

### Search
- Full-width input. bg `#F7FAF8`, border `1px #E6EAE6`, radius `14`, padding `16px 18px 16px 48px`, text `15px` weight `500` `#0B2A20`.
- Leading **search icon** `19px`, green `#12B76A`, positioned left `18px`, vertically centered.
- Placeholder "Search delegations, receipt, payment…" color `#9DB0A6`.
- **Focus:** border `#12B76A`, bg `#FFFFFF`, ring `0 0 0 3px rgba(18,183,106,.14)`.

### Filters
- Row starts with a **"Filter"** label (`13.5px` weight `600` `#5E6F66`) preceded by a small funnel/lines icon.
- Then four **chips**: `All`, `Failed`, `Delegated`, `Completed`. Each chip = label + a count pill.
  - Inactive: bg `#FFFFFF`, border `1px #E6EAE6`, text `#5E6F66`, radius `10`, padding `9px 15px`, `13.5px` weight `600`; hover border `#CFEBD9`. Count pill bg `#EEF1EE`, text `#5E6F66`.
  - **Active:** bg `#12B76A`, text white, border `#12B76A`. Count pill bg `rgba(255,255,255,.22)`, text white.
- Count = number of items matching the current **search query** for that status (so counts update as you type). `All` = total matching search.

### List — Delegation card
- Card: bg white, border `1px #EEF1EE`, radius `16`, padding `20px 22px`, shadow `0 1px 2px rgba(8,32,26,.04), 0 8px 24px rgba(8,32,26,.05)`. Gap between cards `14px`.
- **Hover:** `translateY(-2px)`, shadow `0 2px 4px rgba(8,32,26,.05), 0 14px 34px rgba(8,32,26,.09)`. Transition `.16s ease`.
- **Summary row** (flex, align-center, gap `14`):
  - **Status icon** — `44×44` round-`12`, tinted bg + colored line icon by status (see Status colors). Completed = check, Delegated = right-arrow, Failed = ✕.
  - **Main** (flex:1): name `17px` weight `700` `#0B2A20`; below it timestamp row `13px` `#5E6F66` with a small clock icon (e.g. "Jul 02, 2026 · 20:58").
  - **Badge** (right) — uppercase `11px` weight `800`, `letter-spacing:.09em`, padding `6px 12px`, radius `999`, tint bg + status text color.
- **Detail panel** (below summary, margin-top `16`): bg `#F7FAF8`, border `1px #EEF1EE`, radius `12`, padding `14px 18px`. CSS grid `1fr 1fr`, gap `12px 24px`.
  - Row **Receipt Type** (icon `#9DB0A6`, label `13px` `#5E6F66` weight 600, value right-aligned `13.5px` weight 700 `#0B2A20`).
  - Row **Payment** (card icon, same styling).
  - Row **Amount** spans full width (`grid-column:1/-1`), separated by a `1px #EEF1EE` top border + `12px` top padding; amount icon green `#12B76A`; value in serif **Spectral** `19px` weight `700`.

### Empty state
- Shown when no rows match search+filter. Centered card (white, border `1px #EEF1EE`, radius `16`, padding `64px 24px`): a `56×56` round-`16` green-tint icon box with a search glyph, title "No delegations found" (Spectral `19px` weight 600), and helper text `13.5px` `#5E6F66`.

---

## Interactions & Behavior
- **Search** (`input` event): filters items by name, receipt type, payment, status label, formatted amount, and timestamp (case-insensitive substring). Updates list, filter counts, and header count live.
- **Filter chips** (`click`): sets active status; re-renders. Combined with the current search query.
- **Info button**: placeholder (wire to a help/docs action or tooltip as needed).
- **Card hover**: lift + stronger shadow only. No expand/collapse in this design.
- No entry animations required.

## State Management
Local view state only:
- `query: string` (search text, default `''`)
- `filter: 'all' | 'failed' | 'delegated' | 'completed'` (default `'all'`)
- Data source: `DELEGATIONS` array (replace with API data).

## Data model
Each delegation object:
```
{
  name:        string,   // till / branch name, e.g. "Main", "Counter 2"
  status:      'completed' | 'delegated' | 'failed',
  when:        string,   // preformatted timestamp "Jul 02, 2026 · 20:58"
  receiptType: string,   // EBM code, e.g. "NS", "NR", "CS"
  payment:     string,   // "Cash" | "Mobile Money" | "Card" | "Bank" | ...
  amount:      number,   // numeric; formatted for display
  currency:    string    // "RWF"
}
```
Amount formatting: `currency + ' ' + amount.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })` → e.g. `RWF 1,234.00`.

## Design Tokens
**Colors**
- Brand green (accent / active filter / completed / search icon): `#12B76A`
- Deep emerald (completed badge text): `#0A7A4D`
- Green tint (completed icon/badge bg): `rgba(18,183,106,.12)`
- Delegated icon: `#C88A1E` · badge text `#B7791F` · tint `rgba(196,138,30,.13)`
- Failed: `#D64545` · tint `rgba(214,69,69,.10)`
- Ink / primary text: `#0B2A20`
- Secondary text: `#5E6F66`
- Muted / placeholder / detail icons: `#9DB0A6`
- Page bg: `#EEF1EE` · Card bg: `#FFFFFF` · Input/panel fill: `#F7FAF8`
- Borders: control `#E6EAE6` · hairline/card `#EEF1EE`

**Typography**
- Sans (body/labels/buttons): **Plus Jakarta Sans** (400/500/600/700/800)
- Serif (title, amount, empty title): **Spectral** (600/700)
- Scale: title 30 · subtitle 13.5 · search 15 · chip 13.5 · card name 17 · timestamp 13 · badge 11 (uppercase, +.09em) · detail label 13 · detail value 13.5 · amount 19

**Radii**: card 16 · input 14 · chip 10 · panel 12 · status icon 12 · icon-button 11 · badge/count 999
**Shadows**: card `0 1px 2px rgba(8,32,26,.04), 0 8px 24px rgba(8,32,26,.05)` · hover `0 2px 4px rgba(8,32,26,.05), 0 14px 34px rgba(8,32,26,.09)`
**Spacing**: container padding `40 32 64` · header gap `16` / mb `26` · search mb `20` · filters gap `10` / mb `22` · card padding `20 22` · list gap `14` · detail panel padding `14 18` / grid gap `12 24`

## Assets
No raster assets. All icons are inline SVG line icons (stroke-based, `stroke-width` ~2–2.6). Fonts via Google Fonts (Plus Jakarta Sans + Spectral). If your codebase has an icon set, substitute equivalents: check, arrow-right, x, clock, receipt, credit-card, coins/currency, search, info, filter.

## Files
- `transaction-delegations.html` — standalone screen (markup + placeholder data + vanilla-JS render/search/filter).
- `styles.css` — all component styles with design tokens as CSS custom properties (`:root`).
- Original design source in the project: `Print Delegations.dc.html`.
