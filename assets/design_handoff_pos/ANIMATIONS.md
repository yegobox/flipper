# Motion & Interaction Spec — Flipper POS (Desktop Register)

This screen is intentionally **calm and instant** — a register should feel snappy, not animated. There are **no keyframe animations** on it. All motion is **micro-transitions** (hover/press/focus) plus **immediate state updates** (cart, totals). Below is everything, framework-neutral, so you can reproduce it without reading the CSS.

## Easing
Everything uses the browser default `ease` over short durations. In native terms: `Easing.inOut(Easing.ease)` / `Curves.ease`. No springs, no overshoot.

---

## 1. Hover transitions (desktop pointer)
| Element | On hover | Duration |
|---|---|---|
| **Product card** | border → `--line-strong`, shadow `--sh-1`→`--sh-2`, **lift translateY(−2px)** | 100–200ms |
| Top-bar tool / icon button | background → `--surface-2` (or surface-2 circle) | 120ms |
| Nav item | background → `--surface-2` | 120ms |
| Rail button | background → `--surface-2`, color → `--ink-1` | 120ms |
| Rail sign-out | background → `--loss-tint`, color → `--loss` | 120ms |
| Search / scan / customer-action | border or bg → accent tint | 120–150ms |
| Qty stepper (− / +) | border + color → accent, bg → `--blue-tint` | 120ms |
| Quick-cash button | bg → `--blue-tint`, color → accent | 120ms |
| Pager page / sort | border → `--line-strong` | 120ms |
| Line delete (trash) | color → `--loss` | 120ms |

The out-of-stock card has **hover disabled** (no lift/shadow) and `cursor: not-allowed`.

## 2. Press / active feedback
| Element | Effect | Duration |
|---|---|---|
| Product card | scale **0.985** | 100ms |
| Pay / Tickets buttons | scale **0.98** | 100ms |
Use your pressable's built-in scale-on-press.

## 3. Focus rings (inputs)
- Search, customer search, and the tender field show a **4px `--blue-tint` ring + accent border** on focus, 150ms transition. The tender field carries this "active" ring at rest (it's the primary input). Standard focus affordance — map to your platform focus style.

## 4. Selection / toggle states (instant or ≤150ms)
- **Active nav item / rail item:** `--blue-tint` bg + accent text.
- **Payment method, sort:** standard control states.
- These are color swaps; a ≤150ms color transition is enough, no movement.

## 5. State-driven UI updates (no animation, just re-render)
These happen **instantly** on interaction — do not add entrance animations, it should feel immediate like a real register:
- **Tap product → cart:** a new line appears (or its qty increments); the product card gains an **in-cart count pill** (✓ n) on its thumb; **Grand Total + item count** update; **Pay** enables.
- **Qty − / +:** line total + grand total recompute live. Decrementing to 0 removes the line.
- **Delete line:** line removed; totals recompute; if cart becomes empty, the **empty state** ("No items yet") returns.
- **Tender input / quick-cash:** the Tendered/Change subline appears and **"Amount to Change"** chip + Change value recompute live (`change = max(0, tender − total)`).
- **Search:** grid filters as you type.

> Optional niceties (NOT in the prototype) if your design language uses them — keep them subtle and fast (≤150ms): a brief fade/scale-in on a newly added cart line, or a 1-frame pulse on the Grand Total when it changes. Don't add anything that slows the cashier down.

## 6. Prototype-only: fit-to-viewport scale
The host scales the fixed 1440×912 canvas with a CSS `transform: scale()` to letterbox it in the preview. **This is not part of the design** — production is a normal fluid layout (see README). Don't port it.

## Reduced motion
With `prefers-reduced-motion`, drop the product-card **lift** and press **scale**; keep instant color/border/focus changes (they're non-vestibular). Nothing else to disable.

## Performance
- All transitions are on `transform`, `opacity`, `background`, `border-color`, `box-shadow` — GPU-cheap.
- No looping or timed animations. The screen is idle until the cashier acts.

## Quick reference
| Name | Where | Type | Duration | Easing |
|---|---|---|---|---|
| card hover lift | product card | translateY(−2px)+shadow | ~150ms | ease |
| press | card / buttons | scale 0.98–0.985 | 100ms | ease |
| focus ring | inputs | box-shadow+border | 150ms | ease |
| hover tint | tools/nav/rail/steppers/quick-cash | bg/color/border | 120ms | ease |
| active state | nav/rail | bg+color swap | ≤150ms | ease |
| (all cart/total updates) | cart + footer | instant re-render | — | — |
