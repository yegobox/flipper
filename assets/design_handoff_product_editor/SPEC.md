# Flipper · Add/Edit Product — Handoff (compact)

Redesign of the Add/Edit Product form. Was a cramped scroll-modal → now a **full-page, responsive editor**. Flipper = POS/business OS, market Rwanda, currency **RWF**.

**Reference build (look/behavior/copy, do not copy verbatim):** open `Flipper Add Product.html` (React + in-browser Babel + plain CSS). Rebuild in your stack from this spec.

**Sources of truth**
- `base.css` — design tokens (`--*`). **Don't invent values.**
- `pe.css` — every component style (class names below map 1:1).
- `pe-shared.jsx` — state model + all field/variant/component primitives. **Port `useProduct` first.**
- `pe-b.jsx` — page assembly, section nav, scroll-spy, composite branching.
- `icons.jsx`/`pe-icons.jsx` — inline 1.5px-stroke icons (map to Lucide/Material).

---

## Tokens (from base.css — use the var, names in parens)
Blue `#2563EB`(--blue) primary · gradient btn(--grad-btn) · blue-tint `#EAF1FE`(--blue-tint).
Ink: `#0B1220`(--ink-1) `#4A5567`(--ink-2) `#7E8AA0`(--ink-3) `#AEB8CA`(--ink-4).
Lines: `#E6ECF5`(--line) `#EFF3F9`(--line-soft) `#D6DEEA`(--line-strong).
Surface `#FFF`(--surface) `#F7F9FE`(--surface-2) · canvas `#EEF2F9`(--bg) `#F5F8FD`(--app).
Win `#16A34A`(--win) tint `#E7F6EE` · Loss `#E5484D`(--loss) tint `#FDECEC` · Violet `#7C3AED`.
Radii: sm10 md14 lg20 xl26 pill999 (--r-*). Shadows --sh-1/2/3, --sh-blue. Font **Geist** (--sans), **Geist Mono** (--mono) for all numbers (tabular).

---

## Layout (responsive)
Column: **topbar** (68h, sticky) → **body** (`.pe-bodyB`: left nav + sheet) → sheet has scroll area + **sticky footer** (76h).
- Topbar: back button + breadcrumb (eyebrow `INVENTORY · NEW {PRODUCT|COMPOSITE}` + product name). No actions here.
- Left **section nav** (232w): one item per section — icon tile, title, sub, ✓ when complete; active = blue-tint. Scroll-spy highlights current; click = smooth-scroll to section.
- **Sheet**: max-width 760 centered, sections stacked (gap 34), each = numbered head + fields.
- **Footer**: progress track (`completed/total`, "Ready to save" when done) + **Close** (ghost) + **Save product** (primary, disabled until required filled).
- **≤860px**: nav → horizontal scroller on top, fields stack. **≤560px**: hide topbar Close, color picker full-width, popovers full-width. (see `pe.css` @media)

---

## Sections — standard (composite OFF)
1. **Basics** — Product color (inline picker, below), Product name*, Composite toggle.
2. **Pricing** — Retail price* (RWF), Supply price (RWF). Shows live **Profit/unit** + **Margin %** (red if negative).
3. **Inventory & categorization** — Packaging unit (select), Category* (search+chips), Classification (select), Country of origin (select).
4. **Variants & stock** — Quick Scan + adaptive variant list (below).

Required to save: name + retail + ≥1 category.

## Sections — composite ON (toggle in Basics)
1. **Basics** (same).
2. **Pricing & codes** — Retail*, **Supply price LOCKED** = Σ(component qty×cost), dashed field + lock icon, hint "Calculated from components". Plus **SKU** + **Bar code**.
3. **Components** — bill of materials (below).

Required: name + retail + ≥1 component. Toggling rebuilds nav + sections live.

---

## Key components (class → anatomy)
- **Color picker** `.pe-color` + `.pe-pop`: swatch chip + name + "Choose color" → popover with Primary/Accent/Wheel tabs, 9 hue dots, 10-step shade row (✓ on selected). Inline — no separate dialog. Hues/shades generated in `pe-shared.jsx` (`HUES`, `makeShades` via HSL).
- **Field** `.pe-field`: label (req `*`, optional tag) + control + optional hint. Inputs `.pe-input` 50h, focus = blue border + 4px ring; selects `.pe-select`.
- **Toggle** `.pe-switch` (50×30, blue when on).
- **Category** `.pe-search`: input + add btn; selected = `.pe-chip` (removable); `.pe-suggest` dashed quick-adds.
- **Quick Scan** `.pe-scan`: barcode field + "Add variant"; Enter or button adds.
- **Variant area** — adaptive (`VariantArea`): 0 → empty prompt; 1 → single card; 2+ → list with select-all. Each = **card** `.pe-vrow` (NOT a table → no horizontal scroll): head (checkbox, photo, name, classification, delete) + fields in `repeat(auto-fit,minmax(150px,1fr))` grid: Price, Quantity, Low stock, Tax(A–D), Discount %, Unit, Classification, Expiration.
- **Quantity editor** `QtyCell`: cell shows `0.0 ✎`; click → **portal popover** (fixed, anchored to cell, flips above near bottom — never clipped): icon + "Edit quantity" + name + close, −/value/+ stepper, "Update stock". Closes on outside-click/scroll/Esc.
- **Components builder** (`ComponentsBuilder`): product search (`All Products` filter + add) with dropdown of catalog `PRODUCTS` (excludes already-added); each component = `.pe-vrow` card (Quantity + Unit cost + line total + delete); footer shows **Supply cost (auto) = Σ(qty×cost)** = the locked supply price.

---

## Data model (`useProduct`)
```
composite:bool, name:str, retail:str, supply:str, color:{hueName,shadeIdx,hex},
packaging:str, cats:str[], classification:str, origin:str,
variants:[{id,name,price,qty,lowStock,tax,discount,unit,classification,expiration,image}],
sku:str, barcode:str, components:[{id,name,qty,cost}]
margin = retail − (composite ? compTotal : supply); pct = margin/retail*100
compTotal = Σ(component.cost × component.qty)
```
Seed/catalog (`PACKAGING, CLASSIFICATIONS, ORIGINS, UNITS, TAX_CODES, TAX_PRODUCTS, PRODUCTS`) in `pe-shared.jsx` — replace with real data.

## Behaviors
1. Composite toggle swaps sections 3–4 ↔ Components; supply locks to compTotal.
2. Margin/profit recompute live; negative → loss color.
3. Variant/component fields edit live; numbers clamp (qty≥0, integers where shown).
4. Variant list never scrolls horizontally — fields wrap to width.
5. Quantity popover portaled + anchored (not in scroll container).
6. Save disabled until required fields met; progress footer reflects completion.
7. Section nav = scroll-spy + smooth-scroll.
8. Responsive per `pe.css` breakpoints; touch targets ≥40.

## Icons → Lucide/Material
tag→tag/`label` · coins→`payments` · layers→`layers` · barcode→`qr_code_scanner` · camera→`photo_camera` · box→`inventory_2` · palette→`palette` · search→`search` · plus/minus→`add`/`remove` · trash→`delete_outline` · pencil→`edit` · calendar→`event` · percent→`percent` · lock→`lock` · check→`check` · chevron-left/-down→`chevron_left`/`expand_more` · x→`close` · info→`info`.

## Files
```
Flipper Add Product.html   entry (mounts DirectionB)
base.css   ★ tokens          pe.css   ★ component styles
pe-shared.jsx ★ state+primitives (port first)   pe-b.jsx  page assembly
icons.jsx / pe-icons.jsx   inline icon set
```
