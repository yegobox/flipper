# Motion & Animation Spec — Flipper Mobile POS

Every animation in the mobile sale flow, in **framework-neutral** terms so you can reimplement in React Native (Reanimated/Moti), Flutter, SwiftUI, or Compose **without reading the CSS**. Do not infer motion from the CSS `@keyframes` — use this.

## Easing legend (CSS → your framework)
| Prototype curve | Character | Reanimated / Moti | Flutter | iOS / Compose |
|---|---|---|---|---|
| `cubic-bezier(.22,.9,.3,1)` | **Decelerate** (fast-out, soft-in) | `Easing.out(Easing.cubic)` | `Curves.easeOutCubic` | `easeOut` |
| `cubic-bezier(.2,1.4,.4,1)` | **Overshoot** (springy pop) | `withSpring({damping:12,stiffness:180})` | `Curves.elasticOut` (tame it) / spring | spring | 
| `ease` / default | gentle | `Easing.inOut(Easing.ease)` | `Curves.ease` | `easeInEaseOut` |
| linear | constant | `Easing.linear` | `Curves.linear` | `linear` |

> Personality lives in two places: the **bottom sheet slide-up** and the **success check pop**. Everything else is quick state/press/focus micro-transitions. The flow should feel snappy — a register, not a toy.

---

## 1. Customer picker — bottom sheet open/close  *(signature interaction)*
Two coordinated pieces, triggered when the customer sheet opens (Checkout → "Add" / customer row):
- **Scrim fade** (`mpFade`): a dark backdrop `rgba(11,18,32,.42)` opacity **0 → 1**, **200ms**, ease.
- **Sheet slide-up** (`mpUp`): the sheet translateY **100% → 0**, **320ms**, **Decelerate** (`.22,.9,.3,1`). Sheet is bottom-anchored, top corners 26px radius, max-height **88%** of the screen, with a grab handle.
- **Close** (✕, scrim tap, walk-in, or picking a customer): reverse — slide down + fade out, mirror the same durations.
- **Native:** a standard modal bottom sheet — RN `@gorhom/bottom-sheet` or Reanimated `withTiming(translateY)` + animated backdrop opacity; Flutter `showModalBottomSheet` (tune to ~320ms easeOut). Add drag-to-dismiss on the handle if your sheet lib supports it.

## 2. Confirmation toast  *(replaces the old blocking success modal)*
- **Trigger:** a customer is attached to the sale.
- **Element:** a dark pill (`#0B1220`, white text, green check) pinned near the bottom of the screen.
- **Enter** (`mpToast`): translateY **20px → 0** + opacity **0 → 1**, **300ms**, Decelerate.
- **Auto-dismiss:** after **~2.6s** (fade/slide out, or just remove). Non-blocking — the user can keep working.
- **Native:** a Snackbar/Toast. RN: a small Reanimated entry + `setTimeout` to dismiss; Flutter: `SnackBar` with matching duration. Optional light haptic (`selection`/`success`) on attach.

## 3. Success screen entrance
On navigating to the green success screen, three things animate:
- **Check tile** (`mpPop`): scale **0 → 1**, **500ms**, **Overshoot** (`.2,1.4,.4,1`) — a satisfying pop. Use a spring in native (damping ~12, stiffness ~180).
- **Receipt card** (`scrIn`): translateY **8px → 0** + opacity **0 → 1**, **~420ms**, Decelerate, with a **~200ms delay** (lands just after the check).
- **Confetti** (`fall`): ~70 multi-color pieces (mixed rects/circles) fall from top, translateY to ~940px while rotating **720°**, durations **2.2–4s**, random per-piece delays up to ~0.5s, each a slightly different horizontal start. Decorative — safe to simplify/drop on low-end devices.
- **Native:** spring the check, fade-translate the receipt with a delay, and use a confetti lib (RN: `react-native-confetti-cannon`; Flutter: `confetti`). 
- **IMPORTANT for QA/screenshots:** these entrance animations are fill-`both`; in a backgrounded/throttled webview they can appear *stuck at their start frame* (check at scale 0 → 0×0 box, receipt at opacity 0). That's a capture artifact, **not** a bug — they play in a real foreground app. Verify via DOM/state, not just a screenshot.

## 4. Catalog: add-to-cart / qty pill
- Tapping **＋** swaps the add button for a **− n ＋** pill. The prototype swaps instantly (no morph). Optional nicety: a quick cross-fade/scale (~120ms) between ＋ and the pill, or a brief count "bump" when qty changes. Keep it ≤150ms.
- The **cart bar** appears when the cart becomes non-empty. Prototype shows/hides instantly; optional: slide it up from the bottom edge (translateY, ~200ms decelerate) the first time it appears.

## 5. Inline price editor (Checkout)
- Tapping **Price** expands the unit-price editor below the line. Prototype toggles instantly; optional: an accordion height/opacity reveal (~200ms decelerate). Keep collapse symmetric.

## 6. Press feedback (all interactive)
| Element | Effect | Duration |
|---|---|---|
| Back button | scale **0.94** | ~100ms |
| Catalog **＋** add | scale **0.9** | ~100ms |
| Cart bar button | scale **0.985** | ~120ms |
| Scan button | scale **0.96** | ~100ms |
| Complete / pay button | scale **0.985** | ~120ms |
| qty pill / stepper buttons | background flash (white-overlay or blue-tint) | ~120ms |
| quick-cash, customer rows, payment chips | background/border tint on press/active | ~120ms |
Use your pressable's built-in scale/opacity feedback.

## 7. Focus rings & selection transitions
- **Inputs** (search, tender, price): on focus → border turns accent + a **4px `--blue-tint`** ring, background lightens; **150ms** transition.
- **Payment chips / quick-cash / sort:** selected state = blue border + blue-tint bg; **120ms** color/border transition.
- **Stock badges, status pill:** static color states (no animation).

## 8. State-driven updates (instant — no animation)
These re-render immediately; do **not** add entrance animations (it must feel like a real register):
- Add/inc/dec/delete → cart bar count+total, checkout line totals, grand total, change/balance all recompute live.
- Tender input / quick-cash → Change or Balance due updates live; **Complete** enables and turns green the instant cash ≥ total.
- Search → list filters as you type.

---

## Reduced motion (`prefers-reduced-motion`)
- **Sheet:** present without the slide — a quick opacity fade is fine (avoid the large translate).
- **Success:** disable confetti; replace the check **pop** with a static check (or a ≤120ms fade); skip the receipt slide.
- **Toast:** fade only, no translate.
- Keep the sub-200ms color/border/focus transitions (non-vestibular).

## Performance
- Everything animates **transform / opacity / colour** — GPU-cheap.
- The only continuous animation is the success **confetti** — it's short-lived; stop it after a few seconds and don't loop.
- No looping animations on Catalog/Checkout — they're idle until the cashier acts.

## Quick reference
| Name | Where | Type | Duration | Easing |
|---|---|---|---|---|
| `mpFade` | customer sheet scrim | opacity 0→1 | 200ms | ease |
| `mpUp` | customer sheet | translateY 100%→0 | 320ms | decelerate |
| `mpToast` | confirmation toast | translateY 20→0 + opacity | 300ms | decelerate |
| `mpPop` | success check tile | scale 0→1 | 500ms | overshoot/spring |
| `scrIn` | success receipt | translateY 8→0 + opacity | ~420ms (+200ms delay) | decelerate |
| `fall` | success confetti | translateY + rotate 720° | 2.2–4s | linear |
| press | buttons/pills | scale 0.9–0.985 | ~100–120ms | ease |
| focus ring | inputs | border + box-shadow | 150ms | ease |
| chip/quick-cash select | payment/tender | bg+border | 120ms | ease |
| (cart/total updates) | everywhere | instant re-render | — | — |
