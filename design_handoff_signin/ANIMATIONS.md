# Motion & Animation Spec — Flipper Sign In

Every animation on the sign-in screen, described in **framework-neutral** terms so you can reimplement in React Native (Reanimated/Moti), Flutter, SwiftUI, Jetpack Compose, or web — **without reading the CSS**. Do not infer motion from the CSS `@keyframes`; use this.

## Easing legend (CSS → your framework)
| Prototype curve | Character | Reanimated / Moti | Flutter | iOS / Compose |
|---|---|---|---|---|
| `cubic-bezier(.22,.9,.3,1)` | **Decelerate** (fast-out, soft-in) | `Easing.out(Easing.cubic)` | `Curves.easeOutCubic` | `easeOut` |
| `ease-in-out` | smooth both ends | `Easing.inOut(Easing.ease)` | `Curves.easeInOut` | `easeInEaseOut` |
| `ease` / default | gentle | `Easing.inOut(Easing.quad)` | `Curves.ease` | `easeInEaseOut` |
| linear | constant | `Easing.linear` | `Curves.linear` | `linear` |

> Rule of thumb: the only "personality" animation here is the **error shake**. Everything else is a quick state/colour transition or a slow ambient bob. Prefer native springs only if you want the shake to feel snappier; a keyframed translate is fine.

---

## 1. Error shake — `shake`  *(the important one)*
- **Trigger:** PIN verification fails (wrong PIN).
- **Applies to:** the row of PIN cells (animate the container, or each cell together).
- **Keyframes (translateX):** `0 → −6px (20%) → +6px (40%) → −6px (60%) → +6px (80%) → 0 (100%)`
- **Duration:** 400ms · **Easing:** default ease · plays **once**.
- **Accompanying state:** cells switch to the error style (red border `--danger`, red-tint background `#FDF1EF`) and a red error message appears below. On the next keypress, clear the error + styling.
- **Native:** drive a shared translateX value through the keyframe sequence (e.g. Reanimated `withSequence(withTiming(-6,{duration:80}), withTiming(6,{duration:80}), …)`), or a small `TweenSequence` in Flutter. Optionally add a short haptic (`notificationError`) on fail.

## 2. PIN cell state transitions
Each cell animates between three visual states via simple property transitions (no keyframes):
| State | Border | Background | Trigger |
|---|---|---|---|
| empty | `--line` (grey) | `--surface` | default |
| **active** (next to fill) | `--blue` + 4px `--blue-tint` focus ring | `--surface` | it's the caret position |
| **filled** | `--blue` | `--blue-tint` | a digit occupies it |
- **Transition:** border-color, background, box-shadow over **150ms**, default ease.
- The masked **dot** inside a filled cell can pop in (scale 0→1, ~120ms) for a tactile feel — optional but nice. When `show` is on, render the actual digit instead of the dot.

## 3. Success state
- **Trigger:** PIN verified.
- **Effect:** the error line is replaced by a green check + "Verified — opening {business}…"; the primary button label becomes "Signed in ✓". Then navigate.
- No dedicated keyframe — it's a content/colour swap. Optionally fade/slide the success line in (opacity 0→1, translateY 4→0, ~200ms, decelerate). Keep it brief, then route away (~600–900ms).

## 4. Button press feedback
- **Trigger:** press on any `.btn` (Sign in) and keypad key.
- **Effect:** scale → **0.96–0.975** while pressed, returns on release. ~120ms. Keypad keys also flash `--blue-tint` background on press.
- **Native:** use your pressable's built-in scale/opacity-on-press.

## 5. Loading state
- **Trigger:** while verifying (650ms in prototype; real = network).
- **Effect:** button label → "Verifying…", button disabled, PIN input locked. No spinner in the prototype — you may add a subtle inline spinner or a button shimmer if your design language uses one. Keep it understated.

## 6. Floating product-UI cards — `floaty`  *(right brand panel, desktop only)*
- **Trigger:** always, while the panel is visible (hidden ≤ 920px).
- **Keyframes (translateY):** `0 → −9px (50%) → 0`, preserving each card's static base rotation (`--rot`, e.g. −5°, +5°, +4°).
- **Duration:** 6000ms · **Easing:** ease-in-out · **Repeat:** infinite.
- Each of the 3 cards uses a **different delay** (0s, 0.6s, 1.1s) so they bob out of sync. Keep the per-card rotation constant while bobbing.
- **Native:** an infinite reversing translateY tween per card; combine with a static rotation transform. Pause when the panel isn't visible. Purely decorative — safe to simplify or drop on low-end devices.

## 7. Focus ring (inputs)
- On focus, inputs/cells gain a **4px `--blue-tint`** ring + blue border via a 150ms transition. Standard focus affordance — map to your platform's focus style.

---

## Reduced motion (`prefers-reduced-motion`)
When the OS "reduce motion" setting is on:
- **Disable** the floating-card bob (`floaty`) — show cards static.
- **Replace the shake** with a non-moving error indication (red border + message only; no translateX). Optionally a single brief opacity blink.
- Keep functional colour/state transitions (they're sub-200ms and non-vestibular).

## Performance
- Everything animates **transform and opacity / colour** — GPU-cheap.
- The floating cards are the only continuous animation — pause them when off-screen.
- No blur/heavy effects on this screen.

## Quick reference
| Name | Where | Type | Duration | Easing | Repeat |
|---|---|---|---|---|---|
| `shake` | PIN cells on error | keyframe (translateX ±6) | 400ms | ease | once |
| cell state | PIN cells | colour/shadow transition | 150ms | ease | on change |
| dot pop | filled cell dot | scale 0→1 | ~120ms | ease-out | once per fill |
| success line | below PIN | fade/slide in | ~200ms | decelerate | once |
| press | button + keys | scale 0.96–0.975 | ~120ms | ease | on press |
| `floaty` | brand-panel cards | ambient translateY | 6s | ease-in-out | ∞ |
| focus ring | inputs/cells | box-shadow transition | 150ms | ease | on focus |
