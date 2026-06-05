# Motion & Animation Spec — Flipper Checkout Error → Recovery

Every animation on this screen, described in **framework-neutral** terms so you can reimplement in React Native (Reanimated/Moti), Flutter, SwiftUI, or Jetpack Compose — **without reading the CSS**. Do not infer motion from the CSS `@keyframes`; use this.

## Easing legend (CSS → your framework)
| Prototype curve | Character | Reanimated / Moti | Flutter | iOS / Compose |
|---|---|---|---|---|
| `cubic-bezier(.22,.9,.3,1)` | **Decelerate** (fast-out, soft-in) | `Easing.out(Easing.cubic)` | `Curves.easeOutCubic` | `easeOut` |
| `cubic-bezier(.2,1.4,.4,1)` | **Overshoot** (springy pop) | spring (damping ~12) | `Curves.elasticOut` (tame it) | spring |
| `ease` / default | gentle | `Easing.inOut(Easing.ease)` | `Curves.ease` | `easeInEaseOut` |
| linear | constant | `Easing.linear` | `Curves.linear` | `linear` |

> Rule of thumb: there are two "personality" moments — the **badge pop** on entry and the **error shake** on a futile retry. Everything else is a quick state transition, a sheet slide, or a spinner. All entrance animations are gated behind `prefers-reduced-motion: no-preference` and the base (no-motion) state is the **fully-visible** end state, so reduced-motion and screenshots render correctly.

---

## 1. Status-glyph pop — `errPop`  *(entry)*
- **Trigger:** the error screen (and the ready-state green badge) mounts.
- **Applies to:** the 96px circular badge.
- **Keyframes:** scale `0 → 1`, opacity `0 → 1`.
- **Duration:** 500ms · **Easing:** overshoot `cubic-bezier(.2,1.4,.4,1)` · plays **once**, holds end state.
- **Native:** a scale spring from 0 to 1 with a little overshoot. The dashed ring around the badge is static (no spin).

## 2. Error shake — `errShake`  *(the important one)*
- **Trigger:** user taps **"Try again"** while still no branch is selected (the retry resolves to the same failure).
- **Applies to:** the status-glyph badge (shake the glyph, not the whole screen).
- **Keyframes (translateX):** `0 → −7px (20%) → +6px (40%) → −4px (60%) → +2px (80%) → 0 (100%)`
- **Duration:** 500ms · **Easing:** ease · plays **once**.
- **Accompanying:** a dark toast slides up (see #6) reading *"Still no branch selected — pick one to continue."* Optionally fire an error haptic.

## 3. Retry spinner
- **Trigger:** "Try again" pressed → `retrying = true` (prototype 1100ms; real = network).
- **Effect:** the **refresh icon** inside the button spins (rotate `0 → 360°`, **800ms, linear, infinite**) while retrying; the label changes to "Checking…" and the button is disabled. On resolve, spinning stops.
- **Native:** infinite linear rotation on the icon while the async call is pending.

## 4. Branch-picker sheet — `mpFade` + `mpUp`
- **Trigger:** "Select a branch" pressed (open) / scrim tap or Continue (close).
- **Scrim (`mpFade`):** opacity `0 → 1`, **200ms, ease**.
- **Sheet (`mpUp`):** translateY `100% → 0` (slides up from the bottom edge), **320ms, decelerate** `cubic-bezier(.22,.9,.3,1)`.
- **Close:** reverse — sheet slides down, scrim fades out. (Prototype unmounts immediately; add the exit tween in production for polish.)
- **Native:** standard bottom-sheet present/dismiss. A drag-to-dismiss handle is drawn but not wired — wire it to your sheet component.

## 5. Branch selection + checkbox
- **Branch row select:** on tap, the row transitions to the selected style (blue border, `--blue-tint` background, 3px blue ring; icon flips to solid blue) over **150ms**. The right-side **radio → check** swaps with a small pop (scale `0 → 1`, overshoot, ~300ms).
- **"Set as default" checkbox:** box fills blue + check appears on toggle; simple **150ms** colour transition.
- **Press feedback:** rows scale to **0.99** while pressed (~100ms).

## 6. Toast — `mpToast`
- **Trigger:** futile retry (#2). Auto-dismisses after ~2.6s in the prototype.
- **Keyframes:** translateY `20px → 0` + opacity `0 → 1`.
- **Duration:** 300ms · **Easing:** decelerate · plays **once** in; fade/slide out on dismiss.
- Dark pill (`#0B1220`), amber icon chip. Anchor above the action footer.

## 7. Loading state spinner
- **Trigger:** after committing a branch (`stage = 'loading'`; prototype 1500ms, real = network).
- **Effect:** full-screen branded surface with a **46px ring spinner** (rotate `0 → 360°`, **750ms, linear, infinite**) over the `--blue` accent, plus "Loading checkout… / {branch name}".
- The overlay itself fades in via `mpFade` (200ms).

## 8. Screen / state transitions — `scrIn`
- **Trigger:** error → ready, and any screen swap.
- **Effect:** opacity `0 → 1` + translateY `8px → 0`, **~420ms, decelerate**. Use a brief cross-fade/slide when routing between the three states.

## 9. Button press feedback
- **Trigger:** press on the primary recovery action, "Try again", Continue, Open checkout.
- **Effect:** scale → **0.985** while pressed, returns on release (~120ms). Use your pressable's built-in scale.

---

## Reduced motion (`prefers-reduced-motion`)
When the OS "reduce motion" setting is on:
- **Disable** the badge pop (`errPop`) — render the badge at full size immediately. (Already handled: the animation is gated; base state is visible.)
- **Replace the shake** (`errShake`) with a non-moving cue — keep the toast + the badge's red/amber styling; no translateX.
- **Sheet:** present without the slide (or a quick opacity fade); keep it functional.
- Keep the spinners (loading/retry) but they're rotation-only and acceptable; if you want, swap for a static "Loading…" label.
- Keep sub-200ms colour/state transitions — they're non-vestibular.

## Performance
- Everything animates **transform / opacity / colour** — GPU-cheap.
- The only continuous animations are the two spinners, and only while a request is pending — never idle.
- No blur-heavy or layout-thrashing effects.

## Quick reference
| Name | Where | Type | Duration | Easing | Repeat |
|---|---|---|---|---|---|
| `errPop` | status glyph + ready badge | scale 0→1 + fade | 500ms | overshoot | once |
| `errShake` | glyph on futile retry | keyframe translateX (±7) | 500ms | ease | once |
| retry spin | refresh icon while retrying | rotate 360° | 800ms | linear | ∞ (while pending) |
| `mpFade` | sheet scrim / loader overlay | opacity 0→1 | 200ms | ease | once |
| `mpUp` | branch sheet | translateY 100%→0 | 320ms | decelerate | once |
| branch select | branch row | colour/ring transition | 150ms | ease | on change |
| radio→check | selected row tick | scale 0→1 | ~300ms | overshoot | once |
| `mpToast` | "still no branch" toast | translateY 20→0 + fade | 300ms | decelerate | once |
| loader spinner | loading state | rotate 360° | 750ms | linear | ∞ (while loading) |
| `scrIn` | state transitions | fade + translateY 8→0 | 420ms | decelerate | once |
| press | all buttons | scale 0.985 | ~120ms | ease | on press |
