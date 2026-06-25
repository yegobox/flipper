# Handoff: System Configuration Modal (Flutter)

## Overview
A redesigned **System Configuration** dialog for the Flipper Books POS. It lets a cashier/admin manage POS behaviour toggles, system currency, and tax (EBM/RRA) integration settings. This is a single modal with two grouped sections (**General**, **Tax Configuration**) and a sticky Save footer.

---

## ⚠️ Instructions for your coding LLM (read first — token discipline)
You are implementing this in **Flutter/Dart**. Follow these rules to keep the work cheap and fast:

1. **Do NOT read the HTML file token-by-token or echo it back.** All values you need (colors, sizes, copy, behavior) are already extracted into this README. Build from the README. Open `System Configuration Modal.dc.html` only if a specific detail is ambiguous — never paste its contents into chat.
2. **Do not reproduce this README in your replies.** Reference section names instead (e.g. "per Design Tokens").
3. **Write code, not prose.** Skip long explanations, summaries, and restating the spec. One or two sentences max around each code block.
4. **One widget file is enough.** Produce a single `SystemConfigModal` widget (StatefulWidget) plus a small `AppColors` constants block. Don't scaffold a whole app, tests, or a state-management package unless asked.
5. **Reuse, don't invent.** If the target app already has theme colors, buttons, or a switch widget, use them and map our tokens onto them. Only hardcode the hex values below if no theme exists.
6. **Don't add features.** No extra fields, validation, persistence, or animations beyond what's in *Interactions & Behavior*. Ask before expanding scope.
7. The HTML is a **reference of intended look/behavior**, not code to transliterate. Recreate it with idiomatic Flutter widgets.

---

## About the Design Files
The file in this bundle (`System Configuration Modal.dc.html`) is a **design reference created in HTML** — a prototype showing the intended look and behavior. It is **not** production code to copy. Your task is to **recreate this design in Flutter** using the app's existing widgets, theme, and patterns. `support.js` and `preview.png` are only there to render/preview the HTML; ignore them when implementing.

## Fidelity
**High-fidelity.** Final colors, typography, spacing, and interactions. Recreate the UI to match. Exact values are in *Design Tokens*.

---

## Screen: System Configuration Modal

### Purpose
Configure POS behaviour, currency, and tax-server integration, then Save.

### Layout
- **Backdrop:** full-screen scrim `rgba(8,32,26,0.46)` over the dimmed POS screen (in Flutter just use a `Barrier`/`showDialog` with that scrim color; the dimmed POS behind it is the real app screen).
- **Card:** centered. `maxWidth: 740`, `maxHeight: 88%` of screen height. White `#FFFFFF`, `borderRadius: 20`, shadow `0 28px 80px rgba(8,32,26,0.34)`. `Column` with 3 parts:
  1. **Header** (fixed, not scrolling)
  2. **Body** (scrolls — wrap in `SingleChildScrollView`/`Expanded`)
  3. **Footer** (fixed)
- Card internal horizontal padding: **26px**.

### Header
- Padding `22px 26px`, bottom border `1px #EEF1EE`.
- Left: a **38×38** rounded-`10` square, fill `rgba(18,183,106,0.12)`, containing a **gear/settings icon** (20px) in green `#12B76A`. Use `Icons.settings_outlined`.
- Title: **"System Configuration"** — serif font (Spectral), `21px`, weight `600`, color `#0B2A20`, letter-spacing `-0.01em`.
- Subtitle: **"Manage POS behaviour, currency and tax integration."** — `12.5px`, color `#5E6F66`.
- Right: **close button**, 34×34, rounded-`9`, `1px #EEF1EE` border, `Icons.close` (16px) color `#5E6F66`; hover bg `#F4F8F5`. Closes the modal.

### Body — Section "GENERAL"
- Section label: **"General"** — `11px`, weight `700`, uppercase, letter-spacing `0.16em`, color `#12B76A`, followed by a `1px #EEF1EE` divider line filling the row.
- A bordered container (`1px #EEF1EE`, radius `14`) holding stacked rows, each separated by a `1px #F1F4F1` top border. Row padding `16px 18px` (Comfortable) — see *Tweaks*.

**Toggle rows** (label left, switch right). Label `14.5px` weight `600` `#0B2A20`. Switch = pill `46×27`, radius `999`, 3px inner padding, knob `21×21` white circle with shadow `0 1px 3px rgba(8,32,26,0.3)`.
- Track OFF: `#D7DDD8`. Track ON: `#12B76A`. Knob slides `translateX(19px)` when on. (In Flutter, a styled `Switch` with `activeColor: #12B76A`, `inactiveTrackColor: #D7DDD8` is fine.)
- Rows, all default **OFF**:
  1. **Training Mode**
  2. **Proforma Mode**
  3. **Print A4**
  4. **Export as PDF**

**Currency row** (same row styling):
- Label **"System Currency"**.
- A dropdown (`DropdownButton`), width ~230, bg `#F4F8F5`, `1px #E6EAE6`, radius `10`, padding `11px 14px`, text `14px` weight `600` `#0B2A20`, chevron `Icons.keyboard_arrow_down` `#5E6F66`.
- Options (default = first): `RWF (Rwandan Franc)`, `USD (US Dollar)`, `EUR (Euro)`, `KES (Kenyan Shilling)`, `UGX (Ugandan Shilling)`, `TZS (Tanzanian Shilling)`.

### Body — Section "TAX CONFIGURATION"
- Section label same style as General: **"Tax Configuration"**.
- Helper line under it: **"Save applies to EBM / tax URL, data connector URL, branch code, and MRC."** — `12.5px` `#5E6F66`.

**VAT locked row** (a card, not editable):
- Container: `1px #EEF1EE`, radius `12`, bg `#F7FAF8`, padding `14px 16px`.
- Left: **"VAT Enabled"** `14px` weight `600` `#5E6F66` with a small **lock icon** (`Icons.lock_outline`, 13px, `#9DB0A6`) beside it; sub-line **"Controlled by EBM configuration"** `12px` `#9DB0A6`.
- Right: a switch that is **always ON and disabled** — track `rgba(18,183,106,0.4)`, knob at `translateX(19px)`, cursor not-allowed. Render as a disabled `Switch(value: true, onChanged: null)`.

**Text inputs** (vertical stack, gap 14px). Each: label above (`12px` weight `600` `#5E6F66`, 6px gap), field bg `#F4F8F5`, `1px #E6EAE6`, radius `10`, padding `12px 14px`, text `14px` `#0B2A20`. **Focus** state: border `#12B76A`, bg `#FFFFFF`, focus ring `0 0 0 3px rgba(18,183,106,0.14)`.
1. **EBM / Tax server URL** — default `http://localhost:8080/fuel/`
2. **Data connector URL** — default `http://localhost:8084/`; helper line below `11.5px` `#9DB0A6`: "Bulk product RRA uses this service; RRA tax URL is configured on data-connector."
3. A **row of two** half-width fields (`Row` with two `Expanded`, 14px gap):
   - **Branch code (bhfId)** — default `00`
   - **MRC** — default `YEGO2015122`

### Footer
- Padding `16px 26px 20px`, top border `1px #EEF1EE`.
- **Full-width Save button**: bg `#12B76A`, white text `15px` weight `700`, radius `12`, padding `14`. Hover = `brightness(0.95)`; pressed = `scale(0.992)`.
  - Default label: **"Save configuration"**.
  - After tapping: bg becomes `#0A7A4D`, a white checkmark icon appears, label becomes **"Saved"**, then reverts to default after **2200ms**.
- Below button, centered: version string **"Version 1.185.4252223235606+1756529611"** — `11px` `#9DB0A6`.

---

## Interactions & Behavior
- **Toggles**: tap flips boolean; flipping any control resets the "Saved" state back to "Save configuration".
- **Currency dropdown**: standard select; selecting resets Saved state.
- **Text fields**: editing resets Saved state.
- **VAT switch**: non-interactive (disabled, always on).
- **Save**: sets a `saved=true` flag (green confirm look) for 2200ms, then auto-reverts. No network call in the design — wire to your real save logic.
- **Close**: dismisses the modal (`Navigator.pop`).
- No entry animation is required (the HTML's was removed). A standard Flutter dialog fade/scale is acceptable but optional.

## State Management
Local widget state only (a `StatefulWidget` with `setState`):
- `bool trainingMode, proformaMode, printA4, exportPdf` (all default `false`)
- `String currency` (default `'RWF (Rwandan Franc)'`)
- `String ebmUrl, dataUrl, branch, mrc` (defaults above) — back with `TextEditingController`s
- `bool saved` (drives Save button look; auto-resets via a `Timer`)

No external state-management package needed.

## Design Tokens
**Colors**
- Brand green (accent / Save / ON track): `#12B76A`
- Deep emerald (Saved confirm): `#0A7A4D`
- Ink / primary text: `#0B2A20`
- Secondary text: `#5E6F66`
- Muted text / placeholders: `#9DB0A6`
- Switch OFF track: `#D7DDD8`
- Input fill / tinted surface: `#F4F8F5`
- Locked VAT surface: `#F7FAF8`
- Card / page white: `#FFFFFF`
- Borders: outer `#EEF1EE`, inner divider `#F1F4F1`, input border `#E6EAE6`
- Scrim: `rgba(8,32,26,0.46)`
- Accent tint (header icon bg): `rgba(18,183,106,0.12)`
- Focus ring: `rgba(18,183,106,0.14)`

**Typography**
- Sans (body/labels/buttons): **Plus Jakarta Sans** (weights 400/500/600/700/800). Add via `google_fonts`: `GoogleFonts.plusJakartaSans(...)`.
- Serif (title only): **Spectral** weight 600 → `GoogleFonts.spectral(...)`.
- Scale: title 21 / subtitle 12.5 / section label 11 (uppercase, +0.16em) / row label 14.5 / input & dropdown 14 / field label 12 / helper 11.5–12.5 / button 15 / version 11.

**Radius**: card 20 · sections 14 · input/dropdown 10 · VAT card 12 · button 12 · header icon 10 · close btn 9 · switch pill 999.

**Spacing**: card padding-x 26 · header 22/26 · row 16/18 · input padding 12/14 · field stack gap 14 · footer 16/26/20.

**Shadows**: card `0 28px 80px rgba(8,32,26,0.34)` (+ `0 2px 8px rgba(8,32,26,0.16)`) · switch knob `0 1px 3px rgba(8,32,26,0.3)`.

## Tweaks (optional theming hooks present in the design)
- **Accent**: Money green `#12B76A` (default) / Deep emerald `#0A7A4D` / Bright `#21D07B`. Expose as a single accent constant.
- **Density**: Comfortable (row padding `16px 18px`) / Compact (`12px 16px`).

## Assets
No raster assets. Icons are simple line icons — use Flutter `Icons` (`settings_outlined`, `close`, `lock_outline`, `keyboard_arrow_down`, `check`). Fonts via `google_fonts`.

## Files
- `System Configuration Modal.dc.html` — the hi-fi HTML reference (open only if a detail is unclear).
- `preview.png` — rendered screenshot of the design.
- `support.js` — runtime only for previewing the HTML; **not** part of the implementation.
