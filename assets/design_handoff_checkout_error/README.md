# Handoff: Flipper Checkout Error → Recovery ("No branch selected")

## Overview
The **error / recovery state for the POS checkout** in **Flipper** (a business OS / POS app). When a sale is opened on a device that has **no branch (location) selected**, checkout can't resolve where products and totals belong, so it can't load. Instead of a dead end, this screen **diagnoses the cause and walks the user to the fix**: pick a branch → checkout loads.

It is a **single phone screen** with three sequential states (error → loading → ready) plus a **branch-picker bottom sheet**. It shares the Flipper POS visual system (`mpos.css`) and the base onboarding tokens (`styles.css`).

> Replaces a generic, off-brand error card ("Failed to Load Checkout / Bad state: No default branch selected" with a lone "Try Again" button). The redesign keeps the same underlying condition but reframes it as a recoverable, branded, actionable state.

## About the design files
The files in this bundle are **design references built in HTML + React-via-Babel + plain CSS** — a runnable prototype that shows the intended look, motion, and behavior. **It is not production code to copy verbatim.** Recreate it in the target codebase using that project's existing component library, theming, navigation, and data layer. If there is no codebase yet, React Native / Expo (mobile) is the reasonable default.

Treat the **CSS as the source of truth for tokens/spacing/type**, and the **JSX as the source of truth for structure, state, and interaction**.

## Fidelity
**High-fidelity.** Colors, type, spacing, radii, motion, and copy are intentional — match them. Exceptions:
- The **Flipper logo** is an approximate recreation of the brand ring mark; swap in the official asset.
- The **branch list data** (names, locations, staff counts) is **placeholder** — wire it to the real branches/locations the user belongs to.
- The diagnostic error code string (`no_default_branch`) is illustrative — map it to your real error taxonomy.

---

## Layout

```
ERROR STATE (default)                 BRANCH PICKER (bottom sheet)        READY STATE (after load)
┌─────────────────────────────┐       ┌─────────────────────────────┐    ┌─────────────────────────────┐
│ 🛒 Checkout · Sale      [✕] │       │            ───              │    │                             │
│                             │       │  Select a branch            │    │                             │
│                             │       │  Where is this sale …?      │    │           ✓  (green)        │
│           ⌂ (badge)         │       │ ┌─────────────────────────┐ │    │                             │
│        warning glyph        │       │ │ ⌂ Main Store      [HQ] ○│ │    │      Checkout ready         │
│                             │       │ │   📍 Osu · 4 staff      │ │    │  You're all set to take …   │
│       ACTION NEEDED         │       │ ├─────────────────────────┤ │    │                             │
│   No branch selected yet    │       │ │ ⌂ East Legon Kiosk    ○ │ │    │      [ ⌂ Main Store ]       │
│   Checkout needs a branch…  │       │ │   📍 Lagos Ave · 2 staff│ │    │                             │
│                             │       │ ├─────────────────────────┤ │    │                             │
│  ┌ ⓘ What happened ───────┐ │       │ │ ⌂ Makola Stall        ○ │ │    │                             │
│  │ no_default_branch — …  │ │       │ └─────────────────────────┘ │    │                             │
│  └────────────────────────┘ │       │ ☑ Set as default for device │    │  ┌────────────────────────┐ │
│                             │       │ ┌─────────────────────────┐ │    │  │ 🛒 Open checkout      → │ │
│ ┌─────────────────────────┐ │       │ │  Continue to checkout   │ │    │  └────────────────────────┘ │
│ │ ⌂ Select a branch     → │ │       │ └─────────────────────────┘ │    └─────────────────────────────┘
│ │   Choose where this …   │ │       └─────────────────────────────┘
│ └─────────────────────────┘ │
│ [ ↻ Try again ]             │       LOADING (between picker and ready)
│ Still stuck? Get help       │       full-screen spinner + "Loading checkout… / {branch name}"
└─────────────────────────────┘
```

- Rendered inside the standard **412 × 892 phone shell** (`Phone` in `frame.jsx`): notch, status bar, home indicator. In production this is just a screen — drop the device chrome.
- **Error state** is a flex column: a context **breadcrumb row** at top (`🛒 Checkout · Sale` + close), a **vertically-centered body** (badge → eyebrow → headline → body → diagnostic chip), and a **pinned action footer** (primary recovery action → secondary "Try again" → "Get help").
- **Branch picker** is a bottom **sheet** overlay (scrim + slide-up), with a list of branch cards, a "set as default" checkbox, and a sticky Continue button.
- **Ready state** is a centered confirmation (green check badge, headline, branch chip) with a pinned "Open checkout" CTA.

---

## The two action layouts (important product decision)
The primary recovery action is **"Select a branch"**, NOT "Try again" — because retrying does nothing until a branch exists. "Try again" is demoted to a secondary button. There's a tweak (`primaryAction`) to flip which is primary; **ship `branch` as primary**. If the user taps "Try again" while still branch-less, the badge **shakes** and a toast says *"Still no branch selected — pick one to continue."* — actively redirecting them to the real fix.

---

## Design tokens
Reuses Flipper onboarding tokens (`onboarding/styles.css`) + POS tokens (`mpos/mpos.css`). The ones used here:

| Token | Value | Use |
|---|---|---|
| `--app` / `--app-2` | `#F5F8FD` / `#EDF2FB` | screen background gradient |
| `--surface` | `#FFFFFF` | cards, diagnostic chip, secondary button, branch rows |
| `--surface-2` | `#F7F9FE` | pressed states |
| `--ink-1` | `#0B1220` | headings |
| `--ink-2` | `#4A5567` | body copy |
| `--ink-3` | `#7E8AA0` | breadcrumb, helper text, diagnostic value |
| `--line` / `--line-strong` | `#E6ECF5` / `#D6DEEA` | borders |
| `--blue` (accent) | `#2563EB` | primary action, selected branch, links |
| `--blue-tint` | `#EAF1FE` | selected-branch bg, focus rings |
| `--grad-btn` | `linear-gradient(180deg,#2C6BF0,#1D4ED8)` | primary recovery button, Continue, Open checkout |
| `--sh-blue` | see CSS | primary-button glow shadow |
| **warning tone** `--warn-tint` / `--warnamber` | `#FBF1DC` / `#B7791F` | default error glyph + eyebrow + diagnostic icon |
| **error tone** `--loss-tint` / `--loss-ink` | `#FDECEC` / `#B42318` | alternate (harder) error tone |
| `--gain-tint` / `--gain-ink` | `#E7F6EE` / `#15803D` | ready-state success badge |
| `--r-md` / `--r-lg` / `--r-pill` | `14px` / `20px` / `999px` | radii |

**Tone:** default is **warning** (amber) — "no branch selected" is a recoverable setup gap, not a hard failure. An **error** (red) tone is available via tweak for genuinely broken loads. Pick per error class.

**Type:** `Geist` (UI) + `Geist Mono` (the diagnostic code string only). Headline = 25/700/-.025em; eyebrow = 11.5/800, .14em tracking, uppercase; body = 15/1.5.

**Key dimensions:** status glyph disc **96px**; primary recovery action **60px** tall, radius 16px; secondary "Try again" **52px**, radius 15px; branch card radius `--r-md`; sheet corner radius **26px**; ready-state badge **96px**.

---

## State (lift into your checkout/store)
| State | Type | Meaning |
|---|---|---|
| `stage` | `'error' \| 'loading' \| 'ok'` | which of the three screen states is showing |
| `sheet` | boolean | branch-picker sheet open |
| `picked` | branchId \| null | branch selected in the sheet (not yet committed) |
| `makeDefault` | boolean | "set as default branch for this device" checkbox |
| `retrying` | boolean | "Try again" in-flight (spins the refresh icon) |
| `shake` | boolean | badge shake after a futile retry |
| `toast` | boolean | "still no branch" toast visibility |

**Real wiring:**
- The screen should only appear when checkout fails to resolve a branch. `Select a branch` opens the picker; `Continue` commits `picked` (and persists default if `makeDefault`), then **re-attempts the real checkout load** (`stage = 'loading'`) and routes into checkout on success (`stage = 'ok'` → Open checkout).
- `Try again` should re-run the **same load attempt** the screen failed on. If it still has no branch, surface the toast (as the prototype does). If a branch got selected elsewhere in the meantime, it should now succeed.
- The prototype uses fixed timers (`tryAgain` 1100ms; branch-confirm load 1500ms) — replace all with real async calls.

## Behavior
- **Breadcrumb / close** — `✕` dismisses the sale/checkout (stub here). Breadcrumb is non-interactive context.
- **Diagnostic chip** — collapsible affordance for the technical reason; keep it subtle. Toggle-able via `showDiagnostic` tweak; default **on**. Useful for support, not alarming to the user.
- **Branch picker** — single-select radio behavior; tapping a row selects it (blue highlight + check). `Continue` is disabled until a branch is picked. "Set as default" persists the choice for this device so the user doesn't hit this screen again.
- **Loading** — full-screen branded spinner with the chosen branch name. Real = network.
- **Ready** — confirmation with branch chip; `Open checkout` proceeds into the live checkout. (The prototype's "Back to error state" link is a demo-only reset — remove it.)
- **Accessibility:** the error should be announced (`role="alert"` / live region) when it appears. The branch list is a radio group — use proper roles and keyboard support. Buttons ≥ 44px hit target (they are). Respect `prefers-reduced-motion` (see ANIMATIONS.md).

## Assets
- **Flipper logo** — recreated gradient ring (`FlipperLogo` in `frame.jsx`); replace with official asset. (Used on the boot splash only.)
- **Icons** — inline 1.5px-stroke set in `icons.jsx`. Used here: `Store`, `Cart`, `Refresh`, `Info`, `Warn`, `Check`, `ChevRight`, `MapPin`, `X`. Map to Lucide/Phosphor or your set.
- **Fonts:** Geist + Geist Mono (Google Fonts).

## Files in this bundle
- `Flipper Checkout Error.html` — entry; boot splash, mounts the screen.
- `ANIMATIONS.md` — **all motion, framework-neutral. Read this before implementing any animation.**
- `error_checkout/error-app.jsx` — the screen: state machine, branch picker, ready state, tweaks.
- `error_checkout/error.css` — all error/recovery-specific styles + animations.
- `error_checkout/tweaks-panel.jsx` — prototype-only control panel (ignore for production).
- `onboarding/styles.css` — shared design tokens + base button/animation primitives (dependency).
- `mpos/mpos.css` — POS tokens + shared sheet/toast/loader animations (`mpFade`, `mpUp`, `mpToast`) the screen reuses (dependency).
- `onboarding/frame.jsx` — `Phone` shell, `StatusBar`, `FlipperLogo`.
- `onboarding/icons.jsx` — inline icon set.

To run the reference: open `Flipper Checkout Error.html`. Tap **Select a branch** to run the full recovery flow; tap **Try again** (without picking a branch) to see the shake + toast. Use the **Tweaks** panel to preview tone/glyph/primary-action/copy variants.
