# Handoff: Flipper Stock Recount

## Overview
A redesign of **Flipper**'s **Stock Recount** feature (Flipper = a business OS / POS app; primary market Rwanda, currency RWF). A recount lets a shop count physical stock against the system's recorded stock, see the **variance** per item, then **submit** the result and/or **export a PDF** report. This package makes the feature **mobile-first and responsive**, fixes the old "submission blocked until variance is zero" problem, and adds **PDF export before and after submitting**.

**Target stack: Flutter.** This bundle is a runnable **HTML + React (in-browser Babel) + plain CSS** prototype — a reference for look, motion, behavior. **Not code to copy verbatim.** Rebuild in Flutter using the spec below.

- **`recount/recount.css` is the source of truth for tokens, spacing, type, color.**
- **`recount/recount-*.jsx` are the source of truth for structure, state, logic, copy.**
- **`recount/recount-data.jsx` is the data model + seed + pure helpers — port it first.**

## Fidelity
**High-fidelity.** Match colors, type, spacing, radii, motion, copy. Exceptions:
- The **Flipper logo** is an approximate ring mark (`onboarding/frame.jsx` → `FlipperLogo`) — replace with the official asset.
- Icons are an inline 1.5px-stroke set (`onboarding/icons.jsx`); substitute Flutter `Icons.*` (mapping in §13). Lucide is a near-exact match if you prefer an icon pack.
- Catalog, branch, and seed sessions are realistic placeholder data — swap for real.
- The barcode scanner is **simulated** in the prototype (auto-resolves to a random item); wire a real scanner (`mobile_scanner`) in Flutter (§8F).

## How to run the reference
Open `Stock Recount.html` in a browser. Deps pinned in `<head>`: React 18.3.1, ReactDOM 18.3.1, Babel 7.29.0, Google Font **Geist**. App code loads as `<script type="text/babel">`; components shared via `Object.assign(window, …)`. `recount/mobile-preview.html` (if present) frames it in two phones at 390px.

> Sizes below are logical pixels (1 CSS px = 1 Flutter lp). Everything needed is here — do not invent values.

---

## 0. Flutter packages
```yaml
dependencies:
  google_fonts: ^6        # Geist (fallback Inter; Geist may need a bundled .ttf — see §2)
  intl: ^0.19             # date/number formatting
  uuid: ^4                # session/item ids
  pdf: ^3                 # build the PDF
  printing: ^5            # preview + share/save PDF
  mobile_scanner: ^5      # real barcode scan (replaces the simulated overlay)
```
State: one `ChangeNotifier` (`RecountStore`) holding `List<RecountSession>` + UI state, via Provider/Riverpod. No backend — seed in memory (§5).

---

## 1. Design tokens

### Colors
| Token | Hex | Use |
|---|---|---|
| accent | `#2563EB` | primary actions, active, counted zone |
| accentDeep | `#1D4ED8` | button gradient bottom, pressed |
| accentTint | `#EAF1FE` | accent surfaces (counted zone bg, chips) |
| accentTint2 | `#DEEAFD` | accent borders |
| ink1 | `#0B1220` | primary text |
| ink2 | `#4A5567` | secondary text |
| ink3 | `#7E8AA0` | tertiary / labels / meta |
| ink4 | `#AEB8CA` | placeholders, chevrons |
| line | `#E6ECF5` | default borders |
| lineSoft | `#EFF3F9` | inner dividers |
| lineStrong | `#D6DEEA` | ghost-button border, sheet handle |
| surface | `#FFFFFF` | cards |
| surface2 | `#F7F9FE` | inset fields, footers |
| appBg | `#F5F8FD` | screen bg (plain, or radial F5F8FD→EEF2F9) |
| pos | `#10B981` | surplus accents/dot |
| posText | `#047857` | surplus text |
| posTint | `#E6F8F0` | surplus bg |
| posBorder | `#BBEAD4` | surplus border |
| neg | `#EF4444` | short accents/dot |
| negText | `#B91C1C` | short text |
| negTint | `#FDECEC` | short bg |
| negBorder | `#F6C9C9` | short border |

**Status badge** (bg / text): Draft `#FEF3C7`/`#B45309` · Submitted `#DBEAFE`/`#1D4ED8` · Synced `#D1FAE5`/`#047857`.

**Accent options** (Tweak; ship blue default): `[#2563EB,#1D4ED8]`, `[#4F46E5,#4338CA]`, `[#0E9488,#0F766E]`, `[#E0529C,#BE2A78]`. Derive: tint = accent @9% over white, tint2 = @16%, ring = @22% alpha.

### Type (family Geist; weights 400/500/600/700/800)
| Role | Size / Weight | Color |
|---|---|---|
| AppBar title | 19 / 700, ls −.02em | ink1 |
| AppBar subtitle | 12.5 / 500 | ink3 |
| Card / session name | 16–19 / 700 | ink1 |
| Section header (h3) | 16 / 700 | ink1 |
| Meta / sublabels | 12.5 / 500–600 | ink3 |
| Stat value | 23 / 800, tabular | ink1 / posText / negText |
| Stat key | 11.5 / 600 | ink3 |
| Zone value | 21 / 800, tabular | per zone |
| Zone key | 11 / 600, nowrap | per zone |
| Item name | 15.5 / 700 | ink1 |
| Button label | 15.5 / 700 | white / ink1 |
| Badge | 10.5 / 700, uppercase, ls .05em | per status |
| Sheet title | 19 / 700 | ink1 |
| Stepper number | 17 / 700, tabular | accentDeep |

Quantities/variance use **tabular figures** (`FontFeature.tabularFigures()`), thousands separators (`NumberFormat.decimalPattern('en_US')`), variance always signed (`+8,000`, `-1`, `0`).

### Radii
sm 10 · md 14 · lg 20 · xl 26 · pill 999. Cards lg; fields/buttons md; chips/pills pill; icon buttons 11; swatches 10–13.

### Shadows (BoxShadow approximations)
- sh1 (cards): `#10204010 blur2 y1` + `#10204008 blur1 y1`
- sh2 (hover): `#10204024 blur18 y6 spread −6`
- sh3 (dropdown/sheet): `#10204038 blur44 y18 spread −12`
- shBlue (primary btn / FAB): `accent@45% blur28 y12 spread −8`

### Spacing
Screen horizontal padding **20** (≤560 width: **16**). Vertical rhythm 12–16 between blocks. Card inner pad 16–18 (compact 12–14). Scroll bottom pad **140** (clears action bar). Use Row/Column spacing — never inline text whitespace.

---

## 2. Fonts
Geist is **not** in the `google_fonts` package. Either bundle `Geist[-Mono].ttf` in `assets/fonts/` + declare in `pubspec.yaml`, or fall back to **Inter** via `GoogleFonts.inter`. Apply as the app `textTheme` default. Mono is optional — tabular Geist/Inter is enough.

---

## 3. Data model
```dart
class Product { String id, name, sku, barcode; int system; }   // catalog

class CountItem {
  String id;                 // uuid
  String name, sku;
  int system;                // snapshot of product.system at add time
  int counted;               // user-entered, >= 0
  DateTime countedAt;
  int get variance => counted - system;   // >0 surplus, <0 short, 0 match
}

enum RecountStatus { draft, submitted, synced }

class RecountSession {
  String id; String device; String note;
  RecountStatus status;
  DateTime createdAt; DateTime? submittedAt;
  List<CountItem> items;
  String? shortageReason;    // captured on submit when shorts exist
}
```
**Stats** over `items`: `count=length`, `match=#(v==0)`, `over=#(v>0)`, `short=#(v<0)`, `net=Σv`, `sysTot=Σsystem`, `cntTot=Σcounted`.

---

## 4. Editable rule
A session is editable **only when `status == draft`**. Submitted/synced are read-only: hide Add panel, steppers, delete, and Submit; note field becomes disabled text; keep Export.

---

## 5. Seed data
**Branch (PDF):** business `Kigali General Store`, branch `Nyabugogo Branch`, counter `Richard M.` (counter is settable/Tweak).

**Catalog** (`id, name, sku, barcode, system`):
```
p1  Umuceri (Rice 25kg)    393993  6001240100013  3
p2  Amplifier 200W         AMP200  6009880023417  2000
p3  Inyange Water 1L       INY-1L  6009510800127  540
p4  Coca-Cola 50cl         CC-50   5449000000996  288
p5  Sugar (Kabuye 1kg)     SGR-1K  6001240200027  96
p6  Cooking Oil 1L         OIL-1L  6009690140031  120
p7  Akabanga 25ml          AKB-25  6009880011049  64
p8  Bralirwa Primus 72cl   PRM-72  6009510801025  240
p9  Bread (Sliced 600g)    BRD-600 6001240300037  45
p10 Milk (Inyange 1L)      MLK-1L  6009510800134  180
p11 Soap (Maisha 250g)     SOP-250 6001240400041  150
p12 Eggs (Tray of 30)      EGG-30  6001240500055  36
```
**Sessions:**
1. `draft` "Device richard-", note "" — Umuceri 3/12 (+9), Inyange Water 540/540 (0), Coca-Cola 288/274 (−14).
2. `submitted` "Device 5BCB7586", note "Monthly full-shelf recount" — Amplifier 2000/10000 (+8000), Sugar 96/96 (0).
3. `synced` "Device A1F2-POS", note "Beverages aisle" — Primus 240/232 (−8), Akabanga 64/64 (0), Milk 180/188 (+8).

`new recount`: id=uuid, device = `Device ` + 4 random uppercase alphanumerics, empty items, status draft.

---

## 6. Swatch + formatting helpers
- **Initials:** first letters of first two words, uppercase (strip punctuation if needed).
- **Swatch color:** hash the name → pick from `[#2563EB,#7C3AED,#0EA5A4,#E0529C,#F59E0B,#10B981,#6366F1,#EF6C3B]`. Swatch = solid fill, white bold initials, radius 10–13.
- Dates `MMM dd, yyyy` (e.g. `Jun 11, 2026`); time `HH:mm` (24h); datetime `Jun 11, 2026 · 09:21`.

---

## 7. Screens

### 7A. AppBar (shared, ~64h, white @82% + blur, bottom border `line`)
- **List:** Flipper logo (34) · title "Stock Recount". Right: info icon button (36, rounded 11) → toast explaining the feature.
- **Detail:** back chevron (left) · title "Stock Recount" + subtitle = `session.device`. Right: same info button.

### 7B. List screen
Vertical scroll, content max-width 940 centered (phone: full width, 16 pad).
1. **Search** — h52, surface, 1.5 `line`, radius md, search icon, placeholder "Search device, note, or product…", clear X when non-empty. Focus → accent border + 4px ring. Filters by device/note/item name/sku (case-insensitive).
2. **Filter chips** — leading "Filter" funnel label, then All / Draft / Submitted / Synced, each with a **count badge**. Inactive surface/line/ink2; active accent bg + white + shBlue (badge bg white@24%).
3. **Recount cards** (§8A), gap 14.
4. **Empty state** — 92 circle (radial accentTint2→accentTint, archive icon), title 19/700 "No recounts yet" / "Nothing matches", subtitle 14.5 ink3 max 32ch, then primary "Start new recount" (or ghost "Clear filters" when filtered).
5. **FAB** — bottom-right (22/22+safearea): pill, accent→accentDeep gradient, shBlue, "+ New recount" → creates a draft, opens detail.

### 7C. Detail screen
Vertical scroll (bottom pad 140) + pinned bottom action bar.
1. **Session header card** (lg, surface, sh1, pad 18): Row[48 gradient box-icon, Column(name 19/700, "Created {dateTime}" 12.5 ink3), status badge]. Below: **note field** — inset surface2, h48, receipt icon + input, placeholder "Add a note for this recount session…", disabled plain-text when not editable.
2. **Summary stats** — 4 cards (desktop 4-col; ≤560 → 2×2): key 11.5/600 ink3 + colored dot/icon, value 23/800 tabular. "Items counted" (count), "Matching" (match, green dot), "Surplus" (over, green dot, posText), "Short" (short, red dot, negText).
3. **Add panel** (editable only) — §8B.
4. **"Counted items" header** — h3 left; right meta `{count} items · net {±net}`.
5. **Item list** — `CountItemCard` (§8C), gap 12. Empty → inline empty state ("No items yet", "Search for a product above, or scan a barcode, then enter the quantity you physically counted.").
6. **Action bar** — §8D.

---

## 8. Components (exact anatomy)

### 8A. RecountCard
Card lg, surface, 1px line, sh1, clipped. Two regions:
- **Tappable main row** (pad 16×18) → open detail: Row[46 swatch (draft→box icon else archive, bg = hash color), Column(name 16/700 + inline status badge; meta clock+`{dateTime}` 12.5 ink3; optional note 13 ink2 ellipsis), chevron-right ink4].
- **Footer strip** (pad 11×18, top border lineSoft, bg surface2, wrap): pills — `{n} items`; **net pill**; if short>0 a `{short} short` neg pill; right-aligned **"Export PDF"** text-button (download icon, accent) → §8E. If draft, trailing trash icon-button → delete session.

**Net pill:** net==0 → flat "Balanced" (check, ink2); >0 → pos `↑ +{net} net`; <0 → neg `↓ {net} net`. Pills radius pill, 12.5/600, icon 13; flat surface/line/ink2, pos posTint/posBorder/posText, neg negTint/negBorder/negText.

### 8B. Add panel
Card lg, surface, sh1, pad 16. Header: 30 rounded-9 accentTint box (+ icon) + "Add a product to count" 15/700. Then:
- **Row**: [search field (flex) | scan button (52², accentTint bg, accentTint2 border, barcode icon) — only if `scanEnabled`].
  - Search field h52 (like 7B). Placeholder "Search product name, SKU or barcode…".
  - **Results dropdown** (query non-empty): overlay under field, surface, sh3, radius md, max-h 320 scroll, ≤6 matches. Row: 38 swatch + Column(name 14.5/700, "SKU {sku} · {barcode}" 12 ink3) + right: already-added → "✓ Added" (pos) else `{system}` over "in system". Keyboard ↑/↓ highlight, Enter select. Empty → "No product matches "{q}".".
  - Select → **stages** the product (clears search). If already in list → flash/scroll to it + toast "{name} is already in this count".
- **Staged row**: accentTint bg, accentTint2 border, radius md, pad 12×14: 38 swatch + Column(name 14.5/700 accentDeep, "SKU · {system} in system" 12 ink3) + **qty stepper** + primary "✓ Add" (h48). Enter commits. Add → append CountItem(counted=qty, countedAt=now), clear stage, toast "{name} added to the count".

**Qty stepper:** Row in 1.5 line border, radius md, clipped: [− 40×48 surface2 | number TextField w64 h48 center 17/700 tabular, integers only | +]. − disabled at 0.

### 8C. CountItemCard
Card lg, surface, 1px line (short items → negBorder), sh1, pad 16×18.
- **Top row**: 40 swatch + Column(name 15.5/700; "SKU {sku} · counted {HH:mm}" 12 ink3) + (editable) trash icon-button (34, ink3→neg/negTint hover).
- **Zones** — 3-zone comparison. Desktop grid `1fr auto 1fr auto 1fr` with chevron-right separators. **≤560:** 2-col (System | Counted), **Variance full-width on its own row**, hide chevrons.
  - **System**: surface2, 1px line, radius md, pad 11×14. key "▣ System" (11/600 ink3, monitor icon, nowrap) + value 21/800 ink1.
  - **Counted**: accentTint bg, 1.5 accentTint2. key "≣ Counted" (accentDeep). Body: editable → **in-zone small stepper** (− 36×40 | input | +); read-only → value 21/800 accentDeep. In-zone input full-width, 17/700 accentDeep, integers.
  - **Variance**: tone by sign — pos posTint/posBorder/posText, neg negTint/negBorder/negText, flat surface2/line/ink3. key icon (up TrendUp / down ArrowDown / zero Check) + "Variance"; value `{±variance}` 21/800.
- **Flag** (editable & variance≠0): full-width tinted strip, radius md, pad 10×13, 12.5/500, icon + text:
  - short: info icon, negTint/negText — "Counted {|v|} fewer than the system shows — this will be recorded as shrinkage."
  - surplus: trend icon, posTint/posText — "Counted {v} more than the system shows — a surplus will be recorded."

Editing counted recomputes variance, tone, flag, summary, and action-bar net **live**.

### 8D. Action bar (detail, pinned bottom)
White @86% + blur, top border line, pad 14×20 (+safearea). Inner max-w 940 centered, Row:
- **Left summary** (hidden <380): label (editable→"Net variance" else "Recount total", 13 ink3) + value `{±net} · {count} items` 15/700, colored posText/negText/ink1.
- **"Export PDF"** ghost button (download icon) → §8E. Always present.
- **"Submit"** primary (check icon) — editable only. Enabled when `items.isNotEmpty` && not blocked by policy (§9). Tap → submit flow (§9).

Buttons h52, radius md, 15.5/700. Primary accent→accentDeep gradient, white, shBlue, disabled opacity .45. Ghost surface, 1.5 lineStrong, sh1; hover accent.

### 8E. PDF report — see §10.

### 8F. Barcode scanner
Replace the simulated overlay with `mobile_scanner` `MobileScanner(onDetect:)`. On a barcode: match `Product.barcode`; if found & not already in session → add with `counted = system` (0-variance start the user adjusts), close, toast "Scanned {name} — adjust the count if needed", flash item. No match → toast "Unknown barcode". All catalog already counted → toast "Every catalog item is already in this count".

### 8G. Toast
Dark pill (ink1 bg, white 14/600), centered above the action bar (~bottom 96), green check chip leading, auto-dismiss 2.6s. Custom overlay or themed floating `SnackBar`.

---

## 9. Variance policy & submit flow
Tweakable `variancePolicy ∈ {confirm, allow, block}` (default **confirm**). *(The old build hard-blocked any non-zero variance; that defeats the purpose of a recount, so the default now allows variances and just confirms shortages.)*
- **allow** — Submit always enabled (items>0); submit just sets status.
- **confirm** (recommended) — on Submit, if any short item exists open the **Confirm-shortage sheet**; else submit directly.
- **block** — Submit **disabled** whenever a short item exists (legacy).

**Confirm-shortage sheet** (`ConfirmSubmitSheet`): bottom sheet (top radius xl; centered dialog ≥640), pad 22, max-w 540, handle bar. Title "Confirm shortages before submitting". Body "{n} item(s) counted lower than the system — recording this submits a net variance of {±net}. Add a reason…". List of short rows (negTint, 32 swatch + name + variance). Multiline reason field (placeholder "Reason for shortage (e.g. damaged units, spoilage, theft)…"). Actions: ghost "Keep editing" | primary "✓ Confirm & submit" (saves reason, submits).

**doSubmit:** set `status=submitted`, `submittedAt=now`, persist reason, toast "Recount submitted ✓". Stay on the (now read-only) detail so Export still works.

---

## 10. PDF export (before AND after submit)
Build with `pdf`, preview/share with `printing` (`Printing.layoutPdf`). Available from a **draft and a submitted/synced** session (list card Export + detail action bar Export). A4 portrait, ~40×44 margins, Geist/Inter.
- **Header** (bottom border 2px ink1): left = Flipper mark (40) + business (20/800) + branch (12.5 #5B6678). Right = "Stock Recount" (22/800) + "Report #{last 6 of id, uppercase}" + status badge pill.
- **Meta grid** (4 cols, top+bottom 1px line): Device / Counted by / Created / Generated ({date} {time} now). key 10.5/700 uppercase #8A93A6, value 14/700.
- **Note** line if present.
- **Table**: cols `# | Product | System | Counted | Variance` (last three right tabular). Header 10.5/700 uppercase #8A93A6, border 1.5 #D6DEEA. Rows: index ink3, product (name 700 + "SKU {sku}" 11 #8A93A6), system, counted, variance (pos green/neg red/flat grey, signed). **Footer row** (top 2px, 14/800): "Totals · {count} items", sysTot, cntTot, ±net (colored).
- **Summary pills**: "{match} matching · {over} surplus · {short} short".
- **Signatures** (margin-top 48): two columns each = 1px ink1 line + label ("Counted by — {counter}", "Approved by").
- **Footer**: "Generated by Flipper · Stock Recount" / "{business} — {branch}", 11 #8A93A6, top border.
- Filename: `recount_{device}_{yyyyMMdd}.pdf`.

---

## 11. Responsive (Flutter)
Mobile-first; `LayoutBuilder` on content width.
- Content width `min(width, 940)` centered; phones full width + **16** horizontal pad (else 20).
- **≤560:** summary → 2-col grid; item zones → 2-col (System|Counted) + **Variance full-width below**; hide zone chevrons; AppBar title 17.
- **≤380:** hide action-bar left summary; Export/Submit share the row (`Expanded`).
- Flex/Wrap/Grid with explicit spacing — never inline whitespace.
- Respect bottom **safe area** for action bar / FAB.
- Touch targets ≥44: steppers 40–48 tall, icon buttons 34–38 (pad hit area to 44).
- Optional **density** Tweak (`comfortable|compact`): item pad 16→12, zone value 21→18, item gap 12→9.

---

## 12. Widget mapping
| Spec | Flutter |
|---|---|
| Screen bg | `Scaffold(backgroundColor: appBg)` |
| AppBar blur | `AppBar` + `flexibleSpace: BackdropFilter` |
| Card | `Container(decoration: BoxDecoration(color, radius, border, boxShadow))` |
| Search/note field | `TextField` + custom `InputDecoration` |
| Filter chips | `ChoiceChip` or custom `InkWell` pill |
| Pills/badges | small `Container` + `Row(icon,text)` |
| Stepper | `Row[IconButton(-), SizedBox(TextField), IconButton(+)]` in bordered box |
| Zones grid | `LayoutBuilder` → `Row` (wide) / `Column`+`Row` (narrow) |
| Results dropdown | `CompositedTransformTarget/Follower` + `OverlayEntry`, or `Autocomplete` |
| Bottom sheets | `showModalBottomSheet(isScrollControlled:true, top-rounded xl)` |
| Toast | themed floating `SnackBar` or custom `Overlay` |
| FAB | `FloatingActionButton.extended` (pill, gradient via `Ink`/`Container`) |
| PDF | `pdf` `Document` + `Printing.layoutPdf` / `sharePdf` |
| Scanner | `mobile_scanner` `MobileScanner(onDetect:)` |
| Routing | `Navigator` push detail, or `IndexedStack`/flag (list↔detail) |

---

## 13. Icons (Material equivalents)
search→`search` · barcode→`qr_code_scanner` · box→`inventory_2` · archive→`archive` · clock→`schedule` · chevron→`chevron_right`/`chevron_left` · check→`check`/`check_circle` · plus→`add` · minus→`remove` · trash→`delete_outline` · download→`download` · print→`print` · filter→`filter_list` · info→`info_outline` · monitor→`desktop_windows` · stack→`layers` · trendUp→`trending_up` · arrowDown→`south` · arrowUp→`north` · receipt→`receipt_long` · eye→`visibility` · close→`close`.

---

## 14. Behaviors checklist
1. Live recompute of variance/tone/flag/summary/net on every counted change.
2. Counted clamped `>= 0`, integers only.
3. Duplicate product → focus/flash existing item, don't re-add.
4. Editable gating strictly by `status == draft`.
5. Submit respects `variancePolicy`; confirm-sheet captures reason on shorts.
6. Export works for draft and submitted/synced.
7. Filters + search both apply to the list; chip counts reflect all sessions.
8. Empty states: no sessions vs filtered-empty (list); no items (detail).
9. Date/number formatting per §6; variance always signed.
10. Mobile breakpoints §11; safe areas; ≥44 touch targets.

---

## Files in this bundle
```
Stock Recount.html              entry (loads everything; React+Babel; Tweaks panel)
recount/
  recount-data.jsx   ★ data model + catalog + seed sessions + helpers (port first)
  recount-list.jsx   list screen: search, filter chips, RecountCard, empty/FAB
  recount-detail.jsx detail screen: AddPanel, CountItemCard, summary, action bar
  recount-report.jsx PDF report (ReportModal), ConfirmSubmitSheet, Scanner
  recount-app.jsx    root: routing, state, submit flow, Tweaks wiring
  recount.css        ★ all styles + tokens (source of truth for visuals)
  tweaks-panel.jsx   prototype-only Tweaks shell (accent/density/scan/policy/counter)
onboarding/
  styles.css         shared Flipper tokens (--ink-*, --line*, --surface*, radii, shadows)
  icons.jsx          inline 1.5px-stroke icon set (map to Material/Lucide)
  frame.jsx          FlipperLogo mark (replace with official asset)
```

## Tweaks (prototype-only; not product UI)
Accent color · Density (comfortable/compact) · Barcode-scan button on/off · Short-count policy (confirm/allow/block) · "Counted by" name on the PDF.
