# Handoff: Flipper Sign In ("Welcome back")

## Overview
The **returning-user sign-in screen** for **Flipper** (a business OS / POS app, primary market Rwanda, currency RWF). A user who already has an account lands here to unlock with their **PIN**. It is the counterpart to the onboarding flow (new users) and shares the same visual system.

This screen is **responsive**: a two-column split on desktop/tablet, collapsing to a single column with an on-screen numeric keypad on phones.

## About the design files
The files in this bundle are **design references built in HTML + React-via-Babel + plain CSS** — a runnable prototype that shows the intended look, motion, and behavior. **It is not production code to copy verbatim.** Recreate it in the target codebase using that project's existing component library, theming, navigation, and form/auth patterns. If there is no codebase yet, React Native / Expo (mobile) or React + your styling solution (web) are reasonable defaults.

Treat the **CSS as the source of truth for tokens/spacing/type**, and the **JSX as the source of truth for structure, state, and interaction**.

## Fidelity
**High-fidelity.** Colors, type, spacing, radii, motion, and copy are intentional — match them. Exception: the **Flipper logo** is an approximate recreation of the brand ring mark; swap in the official asset.

---

## Layout

```
┌───────────────────────────────┬───────────────────────────────┐
│  LEFT (form)                   │  RIGHT (brand panel)          │
│                                │                               │
│  [logo] Flipper                │   floating product-UI cards   │
│                                │   (chart / sale / streak)     │
│  Welcome back                  │                               │
│  Enter your PIN to manage …    │                               │
│                                │   FLIPPER BUSINESS OS         │
│  ┌ account chip ─ "Not you?" ┐ │   "Your shop, your team,      │
│                                │    your numbers — all in      │
│  PIN              👁 Show       │    one place."                │
│  ▢ ▢ ▢ ▢ ▢ ▢                   │   sub-copy                    │
│  (error / success line)        │   12,400+ · RWF 1.2B · 99.9%  │
│  [ on-screen keypad: mobile ]  │                               │
│  [    Sign in →    ]           │                               │
│  Trouble signing in?           │                               │
│  © Flipper 2026   🛡 Secured…  │                               │
└───────────────────────────────┴───────────────────────────────┘
```

- **Grid:** two equal columns (`1fr 1fr`) on desktop.
- **Left column:** brand top-left, the form **vertically centered** in a max-width **380px** stack, and a footer row pinned to the bottom (© + "Secured with end-to-end encryption").
- **Right column:** a blue brand panel. **IMPORTANT structural detail** — it's a flex column with **two stacked regions** so they can never overlap regardless of viewport height:
  1. `.si-hero-region` (`flex: 1`) — holds the floating cards (absolutely positioned *within this region only*).
  2. `.si-right-copy` (`flex-shrink: 0`) — the headline + stats, below the hero region.
  Do **not** position the floats against the whole panel; keep them inside the top flex region. (Earlier versions overlapped the headline because floats were positioned against the full-height panel.)

### Responsive behavior
- **≤ 920px:** right brand panel is **hidden**; left column becomes the whole screen; the **on-screen numeric keypad becomes visible** (it's hidden on desktop, where physical keyboard is used).
- **≤ 380px:** PIN cells tighten (smaller gap/height) to fit narrow phones.

---

## Design tokens
This screen reuses the Flipper onboarding tokens (see the main onboarding handoff's token table). The ones used here:

| Token | Value | Use |
|---|---|---|
| `--surface` | `#FFFFFF` | left column background, PIN cells |
| `--surface-2` | `#F7F9FE` | account chip, keypad keys |
| `--ink-1` | `#0B1220` | headings, PIN digits |
| `--ink-2` | `#4A5567` | body/sub |
| `--ink-3` | `#7E8AA0` | tertiary, footer |
| `--line` | `#E6ECF5` | borders |
| `--blue` (accent) | `#2563EB` | active/filled states, links, primary button (re-themeable; indigo `#4F46E5` also approved) |
| `--blue-tint` | `#EAF1FE` | filled PIN cell bg, focus ring |
| `--win` | `#10B981` | success state |
| `--danger` | `#C0392B` | error state (note: not in the base token file — this screen uses the literal `#C0392B`; define a `--danger` token in production) |
| `--grad-brand` | `linear-gradient(135deg,#22D3EE,#2563EB,#4F46E5)` | logo, chart bar accent |
| brand panel bg | `radial-gradient(120% 80% at 70% 10%, #2C6BF0, #1D4ED8 46%, #1E3A9E)` | right panel |

**Type:** `Geist` (UI) + `Geist Mono` (all numerics — PIN digits, stats, money). Heading "Welcome back" = 40/800/-.03em (32 on mobile). PIN digit = mono 24.

**Key dimensions:** PIN cell height **60px** (56 mobile), radius `--r-md` (14px); primary button height **56px**; account chip radius 14px; keypad key height **56px**.

---

## State (lift into your auth/store)
| State | Type | Meaning |
|---|---|---|
| `pin` | string | the digits entered so far (length 0–6) |
| `show` | boolean | reveal digits vs. masked dots |
| `error` | string | error message (empty = none) |
| `loading` | boolean | verifying in progress |
| `done` | boolean | verified/success |

Constants: `PIN_LEN = 6`. The prototype hardcodes a demo PIN `246813` — **replace with a real server-side verification call**; never check a PIN on the client in production.

## Behavior
- **Entry:** digits come from (a) the physical keyboard (`0–9` append, `Backspace` deletes), and (b) the on-screen keypad on touch. Both call the same `push(digit)` / `back()` handlers.
- **Auto-submit:** when the 6th digit is entered, submit automatically (don't make the user also press the button). The button is a fallback and is disabled until 6 digits.
- **Verify:** prototype simulates a **650ms** delay (`loading`), then success or error. In production this is your auth API call.
- **Success:** show green "Verified — opening {business}…" and navigate onward (to the business/branch picker or dashboard).
- **Error:** clear the entered PIN, show a red message + **shake** the cells (see animations), let the user retry. In production also handle lockout/too-many-attempts.
- **Masking:** each filled cell shows a dot (`•`) by default; "Show"/the eye toggles to reveal the actual digits.
- **"Not you?"** → switch account / sign in as someone else. **"Trouble signing in?"** → recovery flow. (Both are stubs here.)
- **Accessibility:** the PIN should be operable by screen readers and hardware keyboards (it already supports physical keys). Use one visually-hidden `<input inputmode="numeric" autocomplete="one-time-code">` driving the 6 visual cells, or proper ARIA on the cell group. Respect `prefers-reduced-motion` (see animations).

## Assets
- **Flipper logo** — recreated gradient ring (`FlipperLogo` in `frame.jsx`); replace with official asset.
- **Icons** — inline 1.5px-stroke set in `icons.jsx` (Eye, Check, Info, ChevLeft, ArrowUpRight, ShieldCheck, TrendUp, Flame). Map to Lucide/Phosphor or your set.
- **Floating cards** (chart / sale / streak) are decorative product previews — reuse your real components or keep as static mini-cards.
- **Fonts:** Geist + Geist Mono (Google Fonts).

## Files in this bundle
- `Flipper Sign In.html` — entry; mounts the screen, theme tokens, accent tweak.
- `ANIMATIONS.md` — **all motion, framework-neutral. Read this before implementing any animation.**
- `signin/signin.jsx` — the screen: PIN logic, keypad, states, brand panel.
- `signin/signin.css` — layout + all sign-in-specific styles/animations.
- `onboarding/styles.css` — shared design tokens + base button/animation primitives (this screen depends on it).
- `onboarding/frame.jsx` — `FlipperLogo` (+ other shell helpers).
- `onboarding/icons.jsx` — inline icon set.
- `onboarding/tweaks-panel.jsx` — prototype-only control panel (ignore for production).

To run the reference: open `Flipper Sign In.html`. Demo PIN **246813** (a wrong PIN demonstrates the error/shake).
