# Stock Recount — Flutter Implementation Handover

Complete spec to rebuild the **Flipper · Stock Recount** feature in Flutter. All sizes are logical pixels (1 CSS px = 1 Flutter lp). Everything needed is here — do not invent values.

---

## 0. Packages

```yaml
dependencies:
  google_fonts: ^6        # Geist (fallback: Inter) — Geist may need bundled .ttf; see §2
  intl: ^0.19             # date/number formatting
  uuid: ^4                # session/item ids
  pdf: ^3                 # build the PDF
  printing: ^5            # preview + share/save PDF
  mobile_scanner: ^5      # barcode scanning (replaces the simulated scanner)
```

State: a single `ChangeNotifier` (`RecountStore`) holding `List<RecountSession>` + UI state, exposed via `Provider`/`Riverpod`. No backend — seed in memory (§5). Persist later if needed.

---

## 1. Design Tokens

### Colors
| Token | Hex | Use |
|---|---|---|
| accent | `#2563EB` | primary actions, active states, counted zone |
| accentDeep | `#1D4ED8` | button gradient bottom, pressed |
| accentTint | `#EAF1FE` | accent surfaces (counted zone bg, chips) |
| accentTint2 | `#DEEAFD` | accent borders |
| ink1 | `#0B1220` | primary text |
| ink2 | `#4A5567` | secondary text |
| ink3 | `#7E8AA0` | tertiary / labels / meta |
| ink4 | `#AEB8CA` | placeholders, chevrons |
| line | `#E6ECF5` | default borders |
| lineSoft | `#EFF3F9` | inner dividers |
| lineStrong | `#D6DEEA` | ghost-button border, handle |
| surface | `#FFFFFF` | cards |
| surface2 | `#F7F9FE` | inset fields, footers |
| appBg | `#F5F8FD` | screen background (use plain, or radial F5F8FD→EEF2F9) |
| pos | `#10B981` | surplus/over (accents) |
| posText | `#047857` | surplus text |
| posTint | `#E6F8F0` | surplus bg |
| posBorder | `#BBEAD4` | surplus border |
| neg | `#EF4444` | short (accents/dot) |
| negText | `#B91C1C` | short text |
| negTint | `#FDECEC` | short bg |
| negBorder | `#F6C9C9` | short border |

**Status badge** (bg / text): Draft `#FEF3C7`/`#B45309` · Submitted `#DBEAFE`/`#1D4ED8` · Synced `#D1FAE5`/`#047857`.

**Accent options** (Tweak; ship blue as default): `[#2563EB,#1D4ED8]`, `[#4F46E5,#4338CA]`, `[#0E9488,#0F766E]`, `[#E0529C,#BE2A78]`. Derive: tint = accent @ 9% over white, tint2 = @16%, ring = @22% alpha.

### Type (family Geist; weights 400/500/600/700/800)
| Role | Size / Weight | Color |
|---|---|---|
| AppBar title | 19 / 700, ls -0.02em | ink1 |
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

Numbers showing quantities/variance use **tabular figures** (`FontFeature.tabularFigures()`). Format with thousands separators (`NumberFormat.decimalPattern('en_US')`). Variance always signed: `+8,000`, `-1`, `0`.

### Radii
sm 10 · md 14 · lg 20 · xl 26 · pill 999. Cards lg(20); fields/buttons md(14); chips/pills pill; icon buttons 11; swatches 10–13.

### Shadows (BoxShadow approximations)
- sh1 (cards): `color #10204010, blur 2, y 1` + `#10204008, blur 1, y 1`
- sh2 (hover): `#10204024 blur 18 y6 spread -6`
- sh3 (dropdown/sheet): `#10204038 blur 44 y18 spread -12`
- shBlue (primary btn/FAB): `color accent@45% blur 28 y12 spread -8`

### Spacing
Screen horizontal padding **20** (≤560px width: **16**). Vertical rhythm 12–16 between blocks. Card inner padding 16–18 (compact 12–14). Scroll content bottom padding **140** (clears the action bar). Element gaps via Row/Column `spacing`/SizedBox — never rely on text whitespace.

---

## 2. Fonts
Geist is **not** in the `google_fonts` package. Either bundle `Geist[-Mono].ttf` in `assets/fonts/` and declare in `pubspec.yaml`, or fall back to **Inter** via `GoogleFonts.inter`. Apply as the app `textTheme` default. Mono (Geist Mono) is optional — only if you mirror the receipt-style numerals; otherwise tabular Geist/Inter is fine.

---

## 3. Data Model

```dart
class Product {            // catalog (search + barcode)
  String id, name, sku, barcode;
  int system;              // system stock
}

class CountItem {
  String id;               // uuid
  String name, sku;
  int system;              // snapshot of product.system at add time
  int counted;             // user-entered, >= 0
  DateTime countedAt;
  int get variance => counted - system;   // >0 surplus, <0 short, 0 match
}

enum RecountStatus { draft, submitted, synced }

class RecountSession {
  String id;               // uuid
  String device;           // e.g. "Device richard-"
  String note;             // free text, editable only while draft
  RecountStatus status;
  DateTime createdAt;
  DateTime? submittedAt;
  List<CountItem> items;
  String? shortageReason;  // captured on submit when shorts exist
}
```

**Stats** (compute over `items`):
```
count   = items.length
match   = items where variance == 0
over    = items where variance > 0
short   = items where variance < 0
net     = sum(variance)
sysTot  = sum(system)
cntTot  = sum(counted)
```

---

## 4. Editable rule
A session is **editable only when `status == draft`**. Submitted/synced are read-only: hide the Add panel, steppers, delete, note input becomes disabled text, hide Submit (keep Export).

---

## 5. Seed data

**Branch (for PDF):** business `Kigali General Store`, branch `Nyabugogo Branch`, counter `Richard M.` (counter is a Tweak/settable).

**Catalog** (`id,name,sku,barcode,system`):
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
1. `draft` "Device richard-", note "" — items: Umuceri sys3/cnt12 (+9), Inyange Water 1L sys540/cnt540 (0), Coca-Cola 50cl sys288/cnt274 (-14).
2. `submitted` "Device 5BCB7586", note "Monthly full-shelf recount" — Amplifier 200W sys2000/cnt10000 (+8000), Sugar sys96/cnt96 (0).
3. `synced` "Device A1F2-POS", note "Beverages aisle" — Primus sys240/cnt232 (-8), Akabanga sys64/cnt64 (0), Milk sys180/cnt188 (+8).

`new recount`: id=uuid, device = `Device ` + 4 random uppercase alphanumerics, empty items, status draft.

---

## 6. Item-swatch helpers
- **Initials**: first letters of first two words, uppercase (e.g. "Umuceri (Rice…" → "U(" — acceptable; or strip punctuation → "UR").
- **Swatch color**: hash the name → pick from `[#2563EB,#7C3AED,#0EA5A4,#E0529C,#F59E0B,#10B981,#6366F1,#EF6C3B]`. Swatch = solid color, white bold initials, rounded 10–13.

Dates: `MMM dd, yyyy` (e.g. `Jun 11, 2026`); time `HH:mm` (24h). DateTime label `Jun 11, 2026 · 09:21`.

---

## 7. Screens

### 7A. AppBar (shared, height ~64, white @82% + blur, bottom border `line`)
- **List view:** Flipper logo mark (34) · title "Stock Recount". Right: info icon button (36, rounded 11, surface/line) → shows toast explaining the feature.
- **Detail view:** back chevron button (left) · title "Stock Recount" with subtitle = `session.device`. Right: same info button.

### 7B. List screen
Vertical scroll, content max-width 940 centered (phone: full width, 16 padding).
1. **Search bar** — height 52, surface, 1.5 border `line`, radius md, search icon (ink3), placeholder "Search device, note, or product…", clear (X) button when non-empty. Focus: border accent + 4px ring accent@22%. Filters sessions by device/note/item name/sku (case-insensitive).
2. **Filter chips row** — leading "Filter" label (ink3, funnel icon). Chips: All / Draft / Submitted / Synced. Each chip height 36, radius pill, shows a **count badge**. Inactive: surface/line/ink2. Active: accent bg, white text, shBlue, badge bg white@24%.
3. **Recount cards** (`RecountCard`, see 8A), gap 14.
4. **Empty state** — centered: 92 circle (radial accentTint2→accentTint, accent archive icon), title (19/700) "No recounts yet" (or "Nothing matches"), subtitle (14.5, ink3, max 32ch), then a primary button "Start new recount" (or ghost "Clear filters" when filtered). Padding 56 vertical.
5. **FAB** — bottom-right (right 22, bottom 22+safearea): pill, accent→accentDeep gradient, shBlue, "+ New recount". Tapping creates a draft and navigates to detail.

### 7C. Detail screen
Vertical scroll (bottom pad 140) + a pinned bottom **action bar**.
1. **Session header card** (lg, surface, sh1, pad 18): Row[ 48 gradient box-icon, Column(name 19/700, "Created {dateTime}" 12.5 ink3), status badge ]. Below: **note field** — inset surface2 row, height 48, receipt icon + text input, placeholder "Add a note for this recount session…", disabled (plain text, ink2) when not editable.
2. **Summary stats** — 4 cards in a grid (desktop 4-col; ≤560px → 2×2). Each: key (11.5/600 ink3, with a colored 8px dot or icon) + value (23/800 tabular). Cards: "Items counted" (count), "Matching" (match, green dot), "Surplus" (over, green dot, value posText), "Short" (short, red dot, value negText).
3. **Add panel** (only if editable) — see 8B.
4. **"Counted items" header** — h3 left, right meta `{count} items · net {±net}`.
5. **Item list** — `CountItemCard` (8C), gap 12. If empty: inline empty state (clipboard icon, "No items yet", "Search for a product above, or scan a barcode, then enter the quantity you physically counted.").
6. **Action bar** (8D).

---

## 8. Components (exact anatomy)

### 8A. RecountCard
Card lg, surface, 1px line, sh1, clipped. Two regions:
- **Tappable main row** (pad 16×18) → open detail: Row[ 46 swatch (draft→box icon, else archive icon, bg = hash color), Column( name 16/700 + inline status badge; meta row clock+`{dateTime}` 12.5 ink3; optional note 13 ink2 ellipsis ), chevron-right (ink4) ].
- **Footer strip** (pad 11×18, top border lineSoft, bg surface2, wrap): pills — `{n} items`; **net pill** (see below); if short>0 a `{short} short` neg pill; then right-aligned **"Export PDF"** text-button (download icon, accent) → opens PDF (8E). If draft, a trailing trash icon-button → delete session.

**Net pill:** net==0 → flat pill "Balanced" (check icon, ink2); net>0 → pos pill `↑ +{net} net`; net<0 → neg pill `↓ {net} net`.

Pills: height ~26 content, radius pill, 12.5/600, icon 13. flat: surface/line/ink2. pos: posTint/posBorder/posText. neg: negTint/negBorder/negText.

### 8B. Add-panel
Card lg, surface, sh1, pad 16. Header row: 30 rounded-9 accentTint box (+ icon, accent) + "Add a product to count" (15/700). Then:
- **Row**: [ search field (flex) | scan button (52² , accentTint bg, accentTint2 border, barcode icon, accent) — only if `scanEnabled` ].
  - Search field: height 52, like 7B search. Placeholder "Search product name, SKU or barcode…".
  - **Results dropdown** (when query non-empty): absolute/overlay under field, surface, sh3, radius md, max-height 320 scroll, up to 6 matches. Each result row: 38 swatch + Column(name 14.5/700, "SKU {sku} · {barcode}" 12 ink3) + right: if already added → "✓ Added" (pos), else `{system}` over "in system" (12/700 ink2 + 10.5 ink4). Keyboard: ↑/↓ highlight, Enter selects. Empty → "No product matches "{q}".".
  - Selecting a product **stages** it (and clears search). If already in the list, instead flash/scroll to that item + toast "{name} is already in this count".
- **Staged row** (when a product is staged): accentTint bg, accentTint2 border, radius md, pad 12×14: 38 swatch + Column(name 14.5/700 accentDeep, "SKU · {system} in system" 12 ink3) + **qty stepper** + primary "✓ Add" button (height 48). Enter in qty commits. Add appends a CountItem(counted=qty, countedAt=now), clears stage, toast "{name} added to the count".

**Qty stepper** (`Stepper` widget): Row in a 1.5 line border, radius md, clipped: [ − button 40×48 surface2 | number TextField w64 h48 center 17/700 tabular, numeric only | + button ]. − disabled at 0. Buttons hover→accentTint.

### 8C. CountItemCard
Card lg, surface, 1px line (short items: border negBorder), sh1, pad 16×18.
- **Top row**: 40 swatch + Column(name 15.5/700; "SKU {sku} · counted {HH:mm}" 12 ink3) + (editable) trash icon-button (34, ink3→neg/negTint hover).
- **Zones** — a 3-zone comparison. Desktop grid `1fr auto 1fr auto 1fr` with chevron-right separators (ink4) between. **≤560px**: 2-col (System | Counted), **Variance spans full width on its own row**, hide the chevron separators.
  - **System** zone: surface2, 1px line, radius md, pad 11×14. key "▣ System" (11/600 ink3, monitor icon, nowrap) + value 21/800 ink1 = `{system}`.
  - **Counted** zone: accentTint bg, 1.5 accentTint2 border. key "≣ Counted" (accentDeep). Body: **editable → in-zone small stepper** (− 36×40 | input | + ); **read-only → value 21/800 accentDeep** = `{counted}`. The in-zone stepper input is full-width, 17/700, accentDeep, numeric.
  - **Variance** zone: tone by sign — pos: posTint/posBorder, text posText; neg: negTint/negBorder, text negText; flat: surface2/line, text ink3. key with icon (up: TrendUp; down: ArrowDown; zero: Check) + "Variance". value `{±variance}` 21/800.
- **Flag** (editable & variance≠0): full-width tinted strip, radius md, pad 10×13, 12.5/500, icon + text:
  - short: info icon, negTint/negText — "Counted {|v|} fewer than the system shows — this will be recorded as shrinkage."
  - surplus: trend icon, posTint/posText — "Counted {v} more than the system shows — a surplus will be recorded."

Editing counted recomputes variance, zone tone, flag, summary, and the action-bar net **live**.

### 8D. Action bar (detail, pinned bottom)
White @86% + blur, top border line, pad 14×20 (+safearea). Inner max-width 940 centered, Row:
- **Left summary** (hidden < 380px): label (editable→"Net variance", else "Recount total", 13 ink3) + value `{±net} · {count} items` (15/700, colored posText/negText/ink1).
- **"Export PDF"** ghost button (download icon) → 8E. Always present.
- **"Submit"** primary button (check icon) — editable only. Enabled when `items.isNotEmpty` and not blocked by policy (§9). Tap → submit flow (§9).

Buttons: height 52, radius md, 15.5/700. Primary: accent→accentDeep gradient, white, shBlue, disabled opacity .45. Ghost: surface, 1.5 lineStrong, sh1; hover accent.

### 8E. PDF report (preview + export) — see §10.

### 8F. Barcode scanner
Replace the simulated overlay with `mobile_scanner`'s `MobileScanner`. On a detected barcode: match `Product.barcode`; if found and not already in the session, add it with `counted = system` (a 0-variance starting point the user then adjusts), close scanner, toast "Scanned {name} — adjust the count if needed", flash the item. If no catalog match → toast "Unknown barcode". If all catalog items already counted (manual-scan test) → toast "Every catalog item is already in this count".

### 8G. Toast / SnackBar
Dark pill (`ink1` bg, white 14/600), centered above the action bar (~bottom 96), green check chip leading, auto-dismiss 2.6s. Use a custom overlay or themed `SnackBar`.

---

## 9. Variance policy & submit flow
Tweakable `variancePolicy ∈ {confirm, allow, block}` (default **confirm**).
- **allow** — Submit always enabled (items>0); submitting just sets status.
- **confirm** (recommended) — Submit enabled; on tap, **if any short item exists**, open the **Confirm-shortage bottom sheet**; else submit directly.
- **block** — Submit **disabled** whenever a short item exists (legacy). (Optionally show a banner "Cannot submit: some items are counted below system stock.")

**Confirm-shortage sheet** (`ConfirmSubmitSheet`): bottom sheet (radius xl top; centered dialog ≥640px), pad 22, max-width 540. Handle bar. Title "Confirm shortages before submitting". Body "{n} item(s) counted lower than the system — recording this submits a net variance of {±net}. Add a reason…". List of short rows (negTint, 32 swatch + name + variance value). Multiline reason textarea (placeholder "Reason for shortage (e.g. damaged units, spoilage, theft)…"). Actions: ghost "Keep editing" (close) | primary "✓ Confirm & submit" (saves `shortageReason`, submits).

**doSubmit**: set `status = submitted`, `submittedAt = now`, persist reason, toast "Recount submitted ✓". Stay on the (now read-only) detail screen so the user can still Export.

---

## 10. PDF export (before AND after submit)
Use `pdf` to build, `printing` (`Printing.layoutPdf`) to preview + let the user Save/Share PDF. Available from **both** a draft and a submitted session (list card Export + detail action bar Export). Page: A4 portrait, ~40×44 margins, Geist/Inter.

**Layout (single page, table may paginate):**
- **Header row** (bottom border 2px ink1): left = Flipper logo mark (40) + business name (20/800) + branch (12.5, #5B6678). Right = "Stock Recount" (22/800) + "Report #{last 6 of id, uppercase}" (12, #5B6678) + status badge pill (colors §1).
- **Meta grid** (4 cols, top+bottom 1px line): Device / Counted by / Created / Generated ({date} {time} now). key 10.5/700 uppercase #8A93A6, value 14/700.
- **Note** line if present ("Note: …").
- **Table** (full width): cols `# | Product | System | Counted | Variance` (last three right-aligned, tabular). Header 10.5/700 uppercase #8A93A6, bottom 1.5 #D6DEEA. Rows: index (ink3), product (name 700 + "SKU {sku}" 11 #8A93A6), system, counted, variance (pos green / neg red / flat grey, 700, signed). **Footer row** (top 2px #D6DEEA, 14/800): "Totals · {count} items", sysTot, cntTot, ±net (colored).
- **Summary pills** under table: "{match} matching · {over} surplus · {short} short".
- **Signature block** (margin-top 48): two columns each = 1px ink1 line + label ("Counted by — {counter}", "Approved by").
- **Footer**: "Generated by Flipper · Stock Recount" / "{business} — {branch}", 11 #8A93A6, top border.

Filename suggestion: `recount_{device}_{yyyyMMdd}.pdf`.

---

## 11. Responsive (Flutter)
This is mobile-first; use `LayoutBuilder` on the content width.
- **Content width**: `min(width, 940)` centered; on phones use full width with **16** horizontal padding (else 20).
- **≤ 560**: summary stats → `GridView`/`Wrap` 2 columns; item zones → 2-col (System|Counted) with **Variance full-width below**; hide zone chevron separators; AppBar title 17.
- **≤ 380**: hide the action-bar left summary; Export/Submit buttons share the row equally (`Expanded`).
- Use `Flex`/`Wrap`/`GridView` with explicit `spacing` — never inline text spacing.
- Respect bottom **safe area** for action bar / FAB (`SafeArea` / `MediaQuery.padding.bottom`).
- Touch targets ≥ 44: steppers 40–48 tall, icon buttons 34–38 (pad to 44 hit area via `InkWell`/`IconButton` constraints).
- Optional **density** Tweak (`comfortable|compact`): compact trims item pad 16→12, zone value 21→18, item gap 12→9.

---

## 12. Widget mapping (cheat-sheet)
| Spec element | Flutter |
|---|---|
| Screen bg | `Scaffold(backgroundColor: appBg)` |
| AppBar blur | `AppBar` + `flexibleSpace: BackdropFilter` (or `PreferredSize` custom) |
| Card | `Container(decoration: BoxDecoration(color, radius, border, boxShadow))` |
| Search/note field | `TextField` with `InputDecoration` (filled, custom border, prefixIcon) |
| Filter chips | `ChoiceChip` (or custom `InkWell` pill) |
| Pills/badges | small `Container` + `Row(icon,text)` |
| Stepper | `Row[IconButton(-), SizedBox(TextField), IconButton(+)]` in bordered container |
| Zones grid | `LayoutBuilder` → `Row` (wide) / `Column`+`Row` (narrow) |
| Results dropdown | `CompositedTransformTarget/Follower` + `OverlayEntry`, or `Autocomplete` |
| Bottom sheets | `showModalBottomSheet(isScrollControlled: true, shape: top-rounded xl)` |
| Toast | `ScaffoldMessenger` themed `SnackBar` (floating) or custom `Overlay` |
| FAB | `FloatingActionButton.extended` (pill, gradient via `Ink`/`Container`) |
| PDF | `pdf` `Document` + `Printing.layoutPdf` / `sharePdf` |
| Scanner | `mobile_scanner` `MobileScanner(onDetect:)` |
| Routing | `Navigator` push detail; or `IndexedStack`/state flag (list↔detail) |

---

## 13. Icons (Material equivalents)
search→`search` · barcode→`qr_code_scanner` · box→`inventory_2` · archive→`archive` · clock→`schedule` · chevron→`chevron_right`/`chevron_left` · check→`check`/`check_circle` · plus→`add` · minus→`remove` · trash→`delete_outline` · download→`download` · print→`print` · filter→`filter_list` · info→`info_outline` · monitor→`desktop_windows` · stack→`layers` · trendUp→`trending_up` · arrowDown→`south` · arrowUp→`north` · receipt→`receipt_long` · eye→`visibility` · close→`close`.

---

## 14. Behaviors checklist (must-haves)
1. Live recompute of variance/tone/flag/summary/net on every counted change.
2. Counted is clamped `>= 0`; integers only.
3. Duplicate product → focus/flash existing item, don't re-add.
4. Editable gating strictly by `status == draft`.
5. Submit respects `variancePolicy`; confirm-sheet captures reason on shorts.
6. Export works for draft and submitted/synced.
7. Filters + search both apply to the list; counts on chips reflect all sessions.
8. Empty states: no sessions vs filtered-empty (list); no items (detail).
9. Date/number formatting per §6; variance always signed.
10. Mobile breakpoints §11; safe areas; ≥44 touch targets.

End of spec.
