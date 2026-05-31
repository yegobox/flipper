# Motion & Animation Spec — Flipper Dashboard

Every animation on the dashboard, in **framework-neutral** terms so you can reimplement in React Native (Reanimated/Moti), Flutter, SwiftUI, or Compose **without reading the CSS**. Do not infer motion from the CSS `@keyframes` — use this.

## Easing legend (CSS → your framework)
| Prototype curve | Character | Reanimated / Moti | Flutter | iOS / Compose |
|---|---|---|---|---|
| `cubic-bezier(.22,.9,.3,1)` | **Decelerate** (fast-out, soft-in) | `Easing.out(Easing.cubic)` | `Curves.easeOutCubic` | `easeOut` |
| `ease` / default | gentle | `Easing.inOut(Easing.quad)` | `Curves.ease` | `easeInEaseOut` |

> This screen has **no springy/overshoot** motion. It's all decelerate tweens for value changes + one slide-up sheet + small press feedback. Calm and businesslike by design.

---

## 1. Gauge fill — value animation  *(the signature moment)*
- **Trigger:** gauge mounts, and whenever `period` or `metric` changes (the fill fraction changes).
- **What animates:** the **length of the colored arc** along the semicircle (CSS does this via `stroke-dashoffset` from `100 → 100 − fillPct`).
- **Duration:** 700ms · **Easing:** Decelerate (`.22,.9,.3,1`).
- **Native implementation:** drive a shared value `0→fillPct` with a 700ms easeOut tween and feed it to your arc renderer:
  - **RN:** `react-native-svg` `<Path>` (semicircle) with animated `strokeDashoffset` via Reanimated, or `react-native-svg-charts`/an arc lib.
  - **Flutter:** `CustomPainter` drawing `Path..arcTo`, repaint driven by an `AnimationController` (700ms, `easeOutCubic`); paint a `sweepGradient` or segment the stroke.
  - **Compose/SwiftUI:** `drawArc` with an animated sweep angle.
- **Arc geometry:** 180° semicircle, round stroke caps, ~18px stroke. Fill is a left→right gradient `#10B981 → #22D3EE → #2563EB`. Track is the neutral line color. Small dots mark the start (green) and end (red).
- **Bonus (optional):** the center number can **count up** to its value (see #2). The prototype doesn't count-up here (it just swaps), but a count-up paired with the arc fill feels great — match the 700ms arc duration if you add it.
- **Empty state:** no fill arc (track only), value shows "0" — no animation.

## 2. (Optional) Number count-up
- Not in the prototype dashboard, but recommended to pair with the gauge fill: animate the displayed value `0 → target` over ~700ms easeOut, rendered with the mono font / tabular figures. (The onboarding celebration screen uses this pattern at 1100ms.)

## 3. Stock progress bar — width tween
- **Trigger:** mount / when stock level changes.
- **What:** the filled portion width animates to its percentage.
- **Duration:** 500ms · **Easing:** Decelerate.
- **Native:** animate width (or scaleX from left origin) of the fill view. Fill uses the brand gradient.

## 4. Daily-goal progress track — width tween
- Same as #3 (500ms, decelerate), amber gradient fill, animating to the goal percentage.

## 5. All apps sheet — open/close  *(the More launcher)*
Two coordinated pieces:
- **Scrim fade** (`dbFade`): opacity `0 → 1`, **200ms**, ease. A dark translucent backdrop (`rgba(11,18,32,.42)` with a slight blur).
- **Sheet slide-up** (`dbSheetUp`): translateY `100% → 0`, **320ms**, Decelerate (`.22,.9,.3,1`). The sheet is anchored to the bottom, rounded top corners (26px), max-height ~86% of the screen.
- **Close:** reverse — slide the sheet down and fade the scrim out (mirror the same durations). Triggered by the X button, scrim tap, or selecting a tile.
- **Native:** a standard modal bottom sheet. RN: `@gorhom/bottom-sheet` or a Reanimated `withTiming(translateY)` + animated backdrop opacity. Flutter: `showModalBottomSheet` (its default is close enough; tune to 320ms easeOut). Add a drag-to-dismiss gesture on the grab handle if your sheet lib supports it.

## 6. Press feedback (all interactive)
| Element | Effect | Duration |
|---|---|---|
| New-sale **FAB** | scale → **0.94** while pressed | 120ms |
| **App tiles** (in sheet) | scale → **0.95** + `--surface-2` background flash | ~100–120ms |
| Period / metric pills | background + color + border transition on select | 150ms |
| Sheet close (X) | background flash to `--line` on press | — |
| Bottom-nav tabs | color transition to accent on active | 150ms |
Use your pressable's built-in scale/opacity feedback.

## 7. Selector state transitions
- Period pill active ↔ inactive: `background`, `color`, `border-color` transition, **150ms**, ease. (Active = dark fill; inactive = white + border.)
- Metric pill: same, active = blue text + blue-tint bg + blue border.

---

## Reduced motion (`prefers-reduced-motion`)
When the OS reduce-motion setting is on:
- **Gauge & bars:** skip the fill/width tween — snap to final value (or use a very short ≤120ms fade).
- **Sheet:** present without the slide; a quick opacity fade is fine (avoid large translate).
- Keep the sub-200ms color/state transitions (non-vestibular).

## Performance
- Everything animates **transform / opacity / colour / stroke-dashoffset** — GPU-cheap.
- No continuous/looping animations on this screen (unlike onboarding's floating cards).
- The gauge arc is the only custom-drawn element — cache/measure the path once; only animate the dash offset (or sweep angle), not the path geometry.

## Quick reference
| Name | Where | Type | Duration | Easing |
|---|---|---|---|---|
| gauge fill | semicircle arc | dashoffset / sweep | 700ms | decelerate |
| (count-up) | gauge number (optional) | number tween | ~700ms | easeOut |
| stock bar | stock card | width | 500ms | decelerate |
| goal track | daily-goal card | width | 500ms | decelerate |
| `dbFade` | sheet scrim | opacity 0→1 | 200ms | ease |
| `dbSheetUp` | apps sheet | translateY 100%→0 | 320ms | decelerate |
| FAB press | new-sale button | scale 0.94 | 120ms | ease |
| tile press | app tiles | scale 0.95 | ~110ms | ease |
| pill select | period/metric | colour/border | 150ms | ease |
