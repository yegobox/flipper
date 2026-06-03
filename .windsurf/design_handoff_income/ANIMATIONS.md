# Motion & Animation Spec — Flipper Income Detail

Every animation on the transaction-detail screen, in **framework-neutral** terms so you can reimplement in React Native (Reanimated/Moti), Flutter, SwiftUI, or Compose **without reading the CSS**. Do not infer motion from the CSS — use this.

## Easing legend (CSS → your framework)
| Prototype curve | Character | Reanimated / Moti | Flutter | iOS / Compose |
|---|---|---|---|---|
| `cubic-bezier(.22,.9,.3,1)` | **Decelerate** (fast-out, soft-in) | `Easing.out(Easing.cubic)` | `Curves.easeOutCubic` | `easeOut` |
| `ease` / default | gentle | `Easing.inOut(Easing.ease)` | `Curves.ease` | `easeInEaseOut` |

> This screen is calm: the only real animation is the **expand/collapse** of the two sections, plus small press feedback. No looping, no entrance choreography.

---

## 1. Section expand / collapse  *(the only signature motion)*
- **Trigger:** tapping a section header (Products / Transaction Timeline).
- **What animates:** the section **body height** between **0** and its **measured content height** (the prototype reads `scrollHeight` and animates the `height` from/to it).
- **Duration:** **280ms** · **Easing:** Decelerate (`.22,.9,.3,1`).
- **Chevron:** rotates **0° ↔ 180°** over the same 280ms, same easing.
- **Overflow:** the body clips during the animation (`overflow: hidden`) so content doesn't spill.
- **Native implementation:**
  - **RN:** measure content with `onLayout`, animate a Reanimated height (or use `LayoutAnimation`/Moti's `animatePresence`); rotate the chevron with an animated `rotate`. Easiest robust path: render the body always-measured off-screen, or use a known content height.
  - **Flutter:** `AnimatedSize` (or `AnimatedContainer`) wrapping the body, `duration: 280ms, curve: Curves.easeOutCubic`; `AnimatedRotation` for the chevron.
  - **Compose:** `AnimatedVisibility` with `expandVertically/shrinkVertically(tween(280, easing = EaseOutCubic))`; `animateFloatAsState` for chevron rotation.
- **Note for QA:** the prototype animates real measured height, so the first frame needs a layout pass — if you screenshot immediately after toggling you may catch it mid-animation. That's expected.

## 2. Press feedback
| Element | Effect | Duration |
|---|---|---|
| Header icon buttons (back, ⋯) | scale **0.93** while pressed | ~100ms |
| Footer buttons (More Actions, Invoice) | scale **0.98** | ~120ms |
| Section header | no scale; chevron + height animate on tap | — |
Use your pressable's built-in scale/opacity feedback.

## 3. Static / no-animation elements
These are **not** animated — render in final state:
- Status pill, direction line, amount, meta strip — all static.
- Timeline rail/nodes — static once the section is open (they appear as part of the height expand; don't stagger them unless you want to — see optional below).

## Optional niceties (NOT in the prototype)
Only if your design language uses them, and keep them subtle:
- **Amount count-up** on first load (0 → value, ~600ms easeOut, mono digits). Flipper's onboarding/celebration screens use this pattern — it can feel premium here too.
- **Timeline stagger:** when the timeline expands, fade/slide each row in with a ~40ms stagger. Skip if it complicates the height animation.
- **Status pill** entrance pop on load.

## Reduced motion (`prefers-reduced-motion`)
- **Expand/collapse:** skip the height tween — snap open/closed (or a ≤120ms opacity fade). Still rotate the chevron instantly or with a tiny fade.
- Drop any optional count-up / stagger.
- Keep press feedback (sub-150ms, non-vestibular).

## Performance
- Only height + rotate + press-scale animate — all cheap. Height animation triggers layout, but it's a small subtree and only on tap.
- No continuous/looping animations on this screen.

## Quick reference
| Name | Where | Type | Duration | Easing |
|---|---|---|---|---|
| section expand | Products / Timeline body | height 0↔content | 280ms | decelerate |
| chevron | section headers | rotate 0↔180° | 280ms | decelerate |
| header btn press | back / ⋯ | scale 0.93 | ~100ms | ease |
| footer btn press | More Actions / Invoice | scale 0.98 | ~120ms | ease |
| (amount count-up) | hero amount — OPTIONAL | number tween | ~600ms | easeOut |
