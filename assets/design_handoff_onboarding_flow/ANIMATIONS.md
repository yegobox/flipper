# Motion & Animation Spec — Flipper Onboarding

This document describes **every animation** in the prototype in framework-neutral terms so you can reimplement them in React Native (Reanimated/Moti), Flutter, SwiftUI, Jetpack Compose, or web — without reading the CSS.

## How to read this
Each entry lists:
- **What** moves and **when** (trigger)
- **From → To** property values
- **Duration** and **Easing**
- **Repeat** behavior

### Easing legend (CSS cubic-bezier → your framework)
The prototype uses a few custom curves. Translate them as follows:

| Prototype curve | Character | Reanimated / Moti | Flutter | iOS / Compose |
|---|---|---|---|---|
| `cubic-bezier(.22,.9,.3,1)` | **Decelerate** (fast-out, soft-in) | `Easing.out(Easing.cubic)` | `Curves.easeOutCubic` | `easeOut` |
| `cubic-bezier(.2,1.4,.4,1)` | **Overshoot / spring** (settles past 100% then back) | `withSpring({ damping: 12, stiffness: 180 })` | `Curves.easeOutBack` | spring, slight bounce |
| `cubic-bezier(.2,1.5,.4,1)` | **Stronger overshoot** (pop-in) | `withSpring({ damping: 10, stiffness: 220 })` | `Curves.elasticOut` (mild) / `easeOutBack` | spring, more bounce |
| `ease-in-out` | smooth both ends | `Easing.inOut(Easing.ease)` | `Curves.easeInOut` | `easeInEaseOut` |
| `ease-out` | soft landing | `Easing.out(Easing.ease)` | `Curves.easeOut` | `easeOut` |
| `linear` | constant | `Easing.linear` | `Curves.linear` | `linear` |

> **Rule of thumb:** every "pop", "bump", and "trophy" curve is a **spring with a little overshoot**. If your framework has native springs, prefer them over a fixed-duration tween — it'll feel better than the bezier approximation.

---

## A. Screen / layout motion

### 1. Screen enter — `scrIn`  *(every screen)*
- **Trigger:** a screen mounts / becomes active.
- **From:** opacity 0, translateY **+8px**
- **To:** opacity 1, translateY 0
- **Duration:** 420ms · **Easing:** Decelerate
- Used on welcome→signup→celebrate→business→branch→dash transitions. In a native stack navigator, a subtle fade-up on the incoming screen achieves the same feel; disable the navigator's default horizontal slide if it competes.

### 2. Celebration staggered reveal
The reward content animates in **after** the screen, in sequence (all use `scrIn`, 600ms):
- Reward card: **delay 200ms**
- Streak row: **delay 320ms**
- (The trophy has its own entrance — see C-1.)
Implement as a stagger: each child starts ~120ms after the previous.

---

## B. Press / interaction feedback (all near-instant)

| Element | Trigger | Effect | Duration |
|---|---|---|---|
| Primary & all `.btn` buttons | press down | scale → **0.975** | 120ms |
| Circular icon button (`back`) | press down | scale → **0.92** | 120ms |
| Segmented option card (usage) | press down | scale → **0.98** | — |
| "Send code" button | press | background darkens to `--blue-tint2` | 150ms |
| Carousel dot | becomes active | width **7px → 26px**, color grey → accent | 300ms |
| Input field | focus | border → accent + 4px accent-tint focus ring | 150ms |
| Selection card | select | border → accent, bg → accent-tint, 3px soft ring | 150ms |

All of these are "release back to normal on press-up." Use your framework's pressable/scale-on-press primitive.

---

## C. Gamification moments (the important ones)

### C-1. Trophy entrance — `trophyIn`  *(celebration)*
- **Trigger:** celebration screen mounts.
- **From:** scale **0**, rotate **−25°**, opacity 0
- **To:** scale 1, rotate 0°, opacity 1
- **Duration:** 600ms · **Easing:** Overshoot/spring (`.2,1.4,.4,1`)
- This is the hero moment — it should slightly overshoot and settle. Prefer a real spring.

### C-2. Points count-up  *(celebration reward card)*
- **Trigger:** ~350ms after celebration mounts.
- **Effect:** the number animates **0 → 500** (the welcome-points value).
- **Duration:** ~1100ms · **Easing:** cubic ease-out (`1 - (1-t)³`)
- Not a CSS animation — it's a JS `requestAnimationFrame` counter. In native, drive a shared value 0→1 with an easeOut tween and render `Math.round(value * target)`. Numbers use the **mono font, tabular figures**.

### C-3. XP chip bump — `bump`  *(signup header, on each XP award)*
- **Trigger:** XP total increases (field completed).
- **Keyframes:** scale 1 → **1.18** (at 40%) → 1
- **Duration:** 500ms · **Easing:** Overshoot
- Fires every time points are awarded. Implement as a one-shot scale pulse on the chip.

### C-4. "+25 XP" float — `xpFloat`  *(signup, on field complete)*
- **Trigger:** a field is completed (hidden when intensity = `subtle`).
- **Keyframes:**
  - 0%: opacity 0, translateY +4px, scale 0.8
  - 25%: opacity 1, translateY −2px, scale 1
  - 100%: opacity 0, translateY −22px
- **Duration:** 1000ms · **Easing:** ease-out · plays once then removed.
- A small amber mono label that pops up and drifts away. Spawn it, animate, unmount.

### C-5. Field check pop — `pop`  *(signup field, and selection check)*
- **Trigger:** field validated / branch selected.
- **From:** scale 0 → **To:** scale 1
- **Duration:** 350ms (signup) / 300ms (selection) · **Easing:** Stronger overshoot (`.2,1.5,.4,1`)
- The green ✓ badge springs into existence.

### C-6. Progress bars / tracks (width tweens)
| Bar | From→To | Duration | Easing |
|---|---|---|---|
| Signup step progress | width grows per step `(step + (valid?1:.45))/3` | 500ms | Decelerate |
| Reward "xp/150" mini-track | width = `xp/150` | 500ms | default ease |
| Reward mini-track (banner) | same | 500ms | ease |
Animate width (or scaleX with left origin) whenever the value changes.

---

## D. Ambient / looping motion

### D-1. Floating product cards — `floaty`  *(welcome hero)*
- **Trigger:** always (welcome screen).
- **Keyframes:** translateY 0 → **−9px** (at 50%) → 0, preserving each card's base rotation (`--rot`, e.g. −4°, +5°)
- **Duration:** 6000ms · **Easing:** ease-in-out · **Repeat:** infinite
- Each card has a **different delay** (0s, 0.6s, 1.2s…) so they bob out of sync. Keep the per-card static rotation while bobbing.

### D-2. Celebration badge ring — `spin`
- **Trigger:** always (celebration).
- **Effect:** rotate 0 → **360°**
- **Duration:** 18000ms · **Easing:** linear · **Repeat:** infinite
- Slow rotating dashed ring behind the trophy.

### D-3. Confetti — `fall`  *(celebration; off when intensity = `subtle`)*
- **Trigger:** celebration mounts (~70 pieces balanced, ~110 playful).
- **Per piece:** translateY −20px → **+940px**, rotate 0 → **720°**
- **Duration:** 2200–4000ms (randomized per piece) · **Easing:** linear · plays once (`forwards`)
- Each piece has randomized: horizontal start (0–100%), start delay (0–0.5s), size (6–12px), shape (rect or circle), color (from the brand+reward palette). In native, spawn N absolutely-positioned views and animate each top/rotation independently; recycle or unmount when done.

---

## E. Auto-advance (carousel, intensity = `playful` only)
- **Trigger:** welcome screen, only when gamification intensity is `playful`.
- **Effect:** advance to next slide every **5200ms** (wraps around). Manual taps reset/override.
- Not a visual animation per se — a timer. Disable for `subtle`/`balanced`.

---

## Intensity gating (recap)
| Intensity | Confetti | "+XP" floats | XP bump | Auto-advance | Trophy/count-up |
|---|---|---|---|---|---|
| `subtle` | off | off | still bumps chip* | off | yes (calm) |
| `balanced` (default) | on (~70) | on | on | off | yes |
| `playful` | on (~110) | on | on | on | yes |

\* In `subtle`, the chip still updates but suppress the "+XP" float pops and confetti.

## Accessibility — `prefers-reduced-motion`
When the OS "reduce motion" setting is on, **disable**: floaty bob, badge spin, confetti, auto-advance, and the trophy overshoot (use a plain fade). Keep functional transitions (screen fades, progress bars) but shorten/curve them gently. Count-up may snap to final value.

## Performance notes
- Everything animates **transform (translate/scale/rotate) and opacity** — all GPU-cheap. Avoid animating layout (width is the only exception: progress bars; use scaleX if you see jank).
- Floating cards and confetti are the only continuous animations — pause them when their screen isn't visible.
- The trophy/celebration uses `backdrop-filter: blur` on the reward card; on native use a translucent blur view (e.g. `BlurView`) — it's decorative, safe to drop if costly.

---

## Quick reference — all named animations
| Name | Where | Type | Duration | Easing | Repeat |
|---|---|---|---|---|---|
| `scrIn` | every screen + cel. stagger | enter | 420 / 600ms | Decelerate | once |
| `floaty` | welcome cards | ambient | 6s | ease-in-out | ∞ |
| `bump` | XP chip | feedback | 500ms | Overshoot | once/award |
| `xpFloat` | signup field | feedback | 1s | ease-out | once |
| `pop` | field check / sel check | feedback | 350/300ms | Strong overshoot | once |
| `trophyIn` | celebration | enter | 600ms | Overshoot | once |
| `spin` | cel. badge ring | ambient | 18s | linear | ∞ |
| `fall` | confetti | one-shot | 2.2–4s | linear | once |
| (count-up) | cel. points | JS counter | ~1.1s | ease-out cubic | once |
| (press) | buttons/cards | feedback | 120–150ms | ease | on press |
| (width) | progress tracks | value tween | 500ms | Decelerate | on change |
