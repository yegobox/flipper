# Handoff: Flipper Onboarding (gamified)

## Overview
A gamified, premium-feeling onboarding flow for **Flipper** (a business OS / POS app, primary market Rwanda). The flow takes a brand-new user from a welcome carousel through a 3-step sign-up to a reward/celebration moment and a small dashboard peek. Gamification (XP, a "welcome points" reward, a level badge, and a daily streak) is woven through to make account creation feel rewarding.

The flow is **mobile** (Android handsets; designed at a 390–412px logical screen width inside a phone shell).

## About the Design Files
The files in this bundle are **design references created in HTML/React-via-Babel** — runnable prototypes that show the intended look, motion, and behavior. **They are not production code to copy verbatim.** Your job is to **recreate these designs in the target codebase's existing environment** (e.g. React Native / Expo, Flutter, native Android, or a web stack) using its established components, navigation, theming, and form patterns.

If there is **no existing environment yet**, pick the most appropriate framework for a mobile-first product (React Native / Expo is a reasonable default for this app) and implement there.

The prototype uses inline-Babel React + plain CSS only so it stays readable. Treat the CSS values as the source of truth for tokens, spacing, and type; treat the JSX as the source of truth for structure, state, and interaction.

## Fidelity
**High-fidelity (hifi).** Final colors, typography, spacing, radii, shadows, motion, and copy are all intentional. Recreate pixel-faithfully using your codebase's primitives. The one exception: the **Flipper logo** here is an approximate recreation of the brand ring mark — replace it with the real brand asset.

---

## Design Tokens

### Color
| Token | Value | Use |
|---|---|---|
| `--bg` | `#EEF2F9` | studio/behind-phone (prototype only) |
| `--app` | `#F5F8FD` | screen base background |
| `--app-2` | `#EDF2FB` | screen base gradient stop |
| `--surface` | `#FFFFFF` | cards, fields |
| `--surface-2` | `#F7F9FE` | inset/disabled surfaces |
| `--ink-1` | `#0B1220` | primary text |
| `--ink-2` | `#4A5567` | secondary text |
| `--ink-3` | `#7E8AA0` | tertiary text / placeholders-strong |
| `--ink-4` | `#AEB8CA` | placeholder text |
| `--line` | `#E6ECF5` | default borders |
| `--line-soft` | `#EFF3F9` | hairline dividers |
| `--line-strong` | `#D6DEEA` | emphasized borders |
| `--blue` (accent) | `#2563EB` | primary brand/action (user can re-theme; indigo `#4F46E5` also approved) |
| `--blue-700` | `#1D4ED8` | pressed/darker action |
| `--cyan` | `#22D3EE` | brand gradient start |
| `--indigo` | `#4F46E5` | brand gradient end |
| `--blue-tint` | `#EAF1FE` | focus ring, soft chips |
| `--blue-tint2` | `#DEEAFD` | soft chip pressed |
| `--xp` / `--xp-2` | `#FB9D00` / `#FF8A00` | XP / points (amber) |
| `--xp-tint` | `#FFF3DC` | XP chip background |
| `--xp-ink` | `#8A5300` | XP chip text |
| `--win` | `#10B981` | success / completed field |
| `--win-tint` | `#DEF7EC` | success background |
| `--violet` | `#7C3AED` | secondary accent (reports) |

### Gradients
- **Brand**: `linear-gradient(135deg, #22D3EE 0%, #2563EB 52%, #4F46E5 100%)`
- **Brand soft** (logo disc): `linear-gradient(135deg,#E7FBFE 0%,#EAF1FE 60%,#EEECFE 100%)`
- **Primary button**: `linear-gradient(180deg,#2C6BF0 0%,#1D4ED8 100%)`
- **XP / points**: `linear-gradient(135deg,#FFC24B 0%,#FB9D00 60%,#FF7A00 100%)`
- **Celebration bg**: `radial-gradient(130% 80% at 50% 0%,#2C6BF0 0%,#1D4ED8 42%,#1E3A9E 100%)`

### Radius
`--r-sm 10` · `--r-md 14` · `--r-lg 20` · `--r-xl 26` · `--r-pill 999` (px)

### Shadow
| Token | Value |
|---|---|
| `--sh-1` | `0 1px 2px rgba(16,32,64,.05), 0 1px 1px rgba(16,32,64,.04)` |
| `--sh-2` | `0 6px 18px -6px rgba(16,32,64,.14), 0 2px 6px rgba(16,32,64,.06)` |
| `--sh-3` | `0 18px 44px -12px rgba(16,32,64,.22), 0 6px 14px rgba(16,32,64,.08)` |
| `--sh-blue` | `0 12px 28px -8px rgba(37,99,235,.45), 0 3px 8px rgba(37,99,235,.25)` |
| `--sh-xp` | `0 10px 24px -8px rgba(251,157,0,.5)` |

### Typography
- **UI font**: `Geist` (weights 400/500/600/700/800).
- **Numeric/mono font**: `Geist Mono` (500/600/700) — used for **all numbers**: XP, points, money, counts, OTP, step counters. This tabular-mono treatment is the core "premium fintech" signal — keep it.
- Key sizes (px): display H1 (welcome) 27 / 700 / -.025em; step title 23 / 700 / -.02em; celebration H1 32 / 800; body 14–15; labels 12.5 / 600; field input 16 / 500; XP chip 13; big stat (count-up / balance) 28–30 mono / 700.
- `text-wrap: balance` on headlines, `text-wrap: pretty` on body.

### Spacing & layout
- Screen horizontal padding: **20–22px**.
- Field height **56px**, radius `--r-md`, 1.5px border; focus = blue border + `0 0 0 4px var(--blue-tint)` ring.
- Primary button height **56px**, radius `--r-md`, full width, `:active` scale .975.
- 8px-ish rhythm; cards radius `--r-md`/`--r-lg`.

---

## Screens / Views

### 1. Welcome carousel (`welcome.jsx`)
- **Purpose**: Introduce the product and route to Create account / Sign in.
- **Layout** (vertical flex, full screen):
  1. **Top bar**: Flipper logo (32px) + "Flipper" wordmark (19/700) on the left; "Skip" text button (`--ink-3`) right. Padding `4px 22px 0`.
  2. **Hero** (flex:1): a soft radial glow + a faint concentric ring decoration, with **3 floating product-UI cards** absolutely positioned per slide. Cards gently bob (`floaty` 6s ease-in-out infinite, ~9px travel, slight per-card rotation `--rot`). Cards: white, 1px `--line`, radius `--r-md`, `--sh-3`.
     - *Mini revenue chart*: label "Revenue · this week", "+18%" in green, "RWF 248,500" (mono 19), 6 mini bars (last bar uses brand gradient).
     - *Mini sale toast*: green check icon, "New sale", "Solar Kit · MoMo", "+12,000" green mono.
     - *Mini daily report*: chart icon chip, "Daily report", 3 labeled progress bars (Sales/Stock/Tax) using brand gradient.
     - *Mini streak*: orange flame chip, "12 days" (mono 16/800), "Sales streak".
     - *Mini badge* (rewards slide): amber trophy chip, "Gold Seller", amber progress bar 72%.
  3. **Copy block** (centered, min-height ~116px): H1 with one word wrapped in brand-gradient text (`em`), 15px subcopy below.
  4. **Dots**: 4 dots, active one widens to 26px and turns blue (`width`/`background` transition .3s).
  5. **CTAs** (column, 12px gap): primary button ("Next" on slides 1–3 → advances; "Create account" on last slide → sign-up). Secondary text button below (slides 1–3: "Skip intro — **Create account**"; last: "Already selling on Flipper? **Sign in**").
- **Slides** (headline / subcopy):
  1. "Run your whole **business** from one app" / "Sell, track stock, and manage your team — Flipper is your business in your pocket."
  2. "Simple, useful **reports** that help you grow" / "See exactly what sells, what's running low, and where your money goes — every day."
  3. "Get paid faster, **track every franc**" / "Accept MoMo, cash, and card. Flipper records every sale and reconciles it for you."
  4. "Grow your business, **earn rewards**" / "Hit daily goals, keep your streak alive, and level up from Bronze to Gold Seller."
- **Behavior**: dots are tappable (jump to slide). When intensity = `playful`, the carousel auto-advances every 5.2s; otherwise manual only.

### 2. Sign-up — 3 steps (`signup.jsx`)
- **Purpose**: Collect identity → verify contact → business profile, while awarding XP.
- **Persistent header** (`.su-head`, row): circular back button (44px) → progress block → XP chip.
  - **Progress block**: row with step label (e.g. "Identity", 12.5/700) and "Step N of 3" (mono 11.5, `--ink-3`, `white-space:nowrap`); a 7px track below filled with the **brand gradient**, width = `(step + (stepValid?1:0.45)) / 3`, transition .5s.
  - **XP chip** (`.xp-chip`): amber-tint pill with a gradient coin (bolt icon) + "`{xp}` XP" (mono). On each award it plays a `bump` scale animation (1→1.18→1).
- **Reward banner** (`.reward-banner`, hidden when intensity = `subtle`): warm gradient card; amber gift icon; "Finish setup to unlock 500 points"; subcopy "Spend points on lower fees & premium reports"; a mini amber progress track (`xp/150`); right-aligned "`{xp}`/150" in amber mono.
- **Body** (scroll): step title (23/700) + description (14, `--ink-2`), then step fields. When a field completes, a "+25 XP" text floats up and fades (`xpFloat` 1s) unless intensity = `subtle`.
- **Footer** (`.su-foot`, white, top hairline): primary button — "Continue" (steps 1–2) or "Create account · claim 500 pts" (step 3); disabled until `stepValid`. Below: "By continuing you agree to Flipper's **Terms** & **Privacy**".

**Step 1 — "Who are you?"** ("This is how you'll sign in and how teammates find you.")
- Field **Username** (user icon), placeholder "e.g. murangwa_eric". Field **Full name** (id-card icon), placeholder "Your full name".
- Each completed field (≥3 chars) shows a green circular check (pop animation) and awards **+25 XP** (once).
- `stepValid` when both ≥3 chars.

**Step 2 — "How do we reach you?"** ("We'll send a one-time code to verify it's really you.")
- **Single contact field** — label and placeholder both **"Phone number or email"**, with an `@`-style icon (NOT email-only). Right-aligned **"Send code"** action button inside the field (blue-tint; turns green "Sent ✓" once tapped).
- Below the field, **before** sending: a helper hint line (info icon, blue) — "Enter **either one** — we'll send your code by SMS or email, whichever you use." *(This dual-purpose clarity was an explicit requirement.)*
- After "Send code": hide the hint; show **one single OTP input** — full width, 60px tall, centered Geist Mono 26px with wide letter-spacing (~.62em), `maxLength 4`, numeric only, placeholder "0000". Label: "Enter the 4-digit code · sent to `{contact}`". Below: "Didn't get it? **Resend in 0:28**". **Do NOT use 4 separate boxes — one field only** *(explicit requirement)*.
- Completing all 4 digits awards **+50 XP**. `stepValid` when contact ≥5 chars AND code length = 4.

**Step 3 — "Tell us about your shop"** ("We'll tailor Flipper to how you sell.")
- **Usage** — 2-up segmented cards (`.seg2`): "Individual / Just me running my sales" (user icon) and "Business / A shop with a team & branches" (building icon). Selected card = blue border + blue-tint bg + soft ring; icon chip inverts to solid blue. Default `individual`.
- **Country** — select-style field showing 🇷🇼 flag + "Rwanda" + chevron (static in prototype; wire to a real picker).
- A green "almost there" banner: "You're one tap from 500 points / Plus your first daily streak starts today".
- Reaching step 3 awards the **usage +25 XP** (once). `stepValid` always true.
- Total XP across signup = **150**; welcome points unlocked on completion = **500**.

### 3. Celebration (`celebrate.jsx`)
- **Purpose**: Reward completion; establish level + streak.
- Full-screen **blue radial gradient**, white text, status bar/home-indicator switch to light. **Confetti** falls (hidden when intensity = `subtle`; ~110 pieces playful, ~70 balanced) — multi-color, mixed rects/circles, `fall` animation rotates 720° over 2.2–4s.
- Centered column: a dashed spinning ring behind an **amber trophy tile** (116px, radius 34, scales in with a slight rotate). Eyebrow "WELCOME TO FLIPPER", H1 "You're in" (+ "🎉" when playful), subcopy "Nice work, `{name}`. Your account is ready — and you've already started earning."
- **Reward card** (glassy, `backdrop-filter: blur(8px)`, white @ 12% over the gradient):
  - Top row: amber coins tile + **points count-up** "+`{0→500}`" (mono 28, eased over ~1.1s) + "Welcome points unlocked"; right pill "+150 XP".
  - Divider, then **level row**: bronze medal + "Level 1 · Bronze Seller" + "350 pts to Silver Seller" + a 50%-filled amber track.
- **Streak row**: orange flame tile + "Day 1 streak started" (+ "🔥" playful) + "Log a sale tomorrow to keep it alive" + 7 day-pips (first filled amber).
- **Footer** button: white pill "Enter Flipper" → dashboard peek.

### 4. Dashboard peek (`app.jsx` → `DashPeek`)
- **Purpose**: Land the loop somewhere real.
- Header: avatar (brand-gradient initial) + "Good morning / `{name}`" + XP chip. Blue gradient **points balance card** (mono 30) with bronze medal + "Bronze Seller" + "350 to Silver →". 2×2 quick-action grid (New sale / Reports / Inventory / Daily goal, each a tinted icon chip + label). Amber "First daily goal — Log 1 sale today → **+50 pts**" card. Text button "↺ Replay onboarding from start" → resets to welcome.

---

## Interactions & Behavior
- **Navigation/state** (lift into your router/state lib): a single `screen` enum drives `welcome | signup | celebrate | dash`. Sign-up holds its own `step` (0–2) and per-field values.
- **XP awarding**: idempotent — each award has a key tracked in a Set so re-entering a field doesn't double-count. Awards: username +25, full name +25, contact +25, OTP complete +50, usage (on reaching step 3) +25 → **150 total**.
- **Field completion**: ≥3 chars (text) shows green check + awards XP. OTP awards at exactly 4 digits.
- **Send code**: requires contact ≥5 chars; toggles button to "Sent ✓" (green) and reveals the OTP input + resend timer (timer is static copy in the prototype — wire a real countdown).
- **Validation gating**: primary button disabled until the step's `stepValid` is true.
- **Motion**: screen-enter `scrIn` (.42s, translateY 8→0 + fade); XP chip `bump`; field check `pop`; "+XP" `xpFloat`; trophy `trophyIn`; confetti `fall`; floating cards `floaty`; progress/track width transitions .5s. Respect `prefers-reduced-motion` in production (disable confetti/bob/auto-advance).
- **Count-up**: points animate 0→500 with cubic ease-out (~1.1s, requestAnimationFrame).

## State Management
- Global: `screen` (flow position), `onboardingData` `{ name, xp, welcomePts }` passed from signup → celebrate → dash.
- Sign-up local: `step`, `username`, `fullname`, `contact`, `codeSent`, `code` (string, ≤4 digits), `usage`, `xp`, awarded-keys Set, transient "+XP" pop, chip `bump` flag.
- Data fetching (not in prototype — add in app): real OTP send/verify, username availability, country list, account creation, and points/level/streak from your gamification service.

## Gamification intensity (config)
A single setting drives intensity — wire it as a build/theme config (default `balanced`):
- **subtle**: no confetti, no emoji, no "+XP" float pops, reward banner hidden, no auto-advance. (Calm/enterprise.)
- **balanced** (default): confetti on, "+XP" pops, reward banner shown, manual carousel.
- **playful**: + auto-advancing carousel, emoji in headers, denser confetti.

## Assets
- **Flipper logo**: the bundle uses a recreated gradient "incomplete ring" mark (`FlipperLogo` in `frame.jsx`). **Replace with the official brand asset.**
- **Icons**: simple 1.5px-stroke line icons defined inline in `icons.jsx` (no icon-font dependency). Map these to your icon set (Lucide/Phosphor are close matches). Icons used: user, id-card, at-sign, mail, shield-check, info, check, chevron-left/right/down, bolt, gift, coins, trophy, medal, flame, building, chart, cart, box, trend-up, arrow-up-right.
- **Flag**: 🇷🇼 emoji placeholder — use a real flag asset/picker.
- **Fonts**: Geist + Geist Mono (Google Fonts). Substitute only if your app already standardizes on another family, but keep a mono for numerics.
- No raster images or illustrations are required — the hero is built from product-UI preview cards.

## Files (in this bundle)
- `Flipper Onboarding.html` — entry; mounts the app, defines theme tokens + the intensity/accent config.
- `onboarding/styles.css` — **all tokens, components, and animations** (source of truth for visual values).
- `onboarding/frame.jsx` — phone shell, status bar, home indicator, Flipper logo/badge, progress Ring, Confetti.
- `onboarding/welcome.jsx` — welcome carousel + floating product-UI cards.
- `onboarding/signup.jsx` — 3-step sign-up, XP logic, fields, single OTP.
- `onboarding/celebrate.jsx` — celebration screen + count-up.
- `onboarding/app.jsx` — flow controller + dashboard peek.
- `onboarding/icons.jsx` — inline icon set.
- `onboarding/tweaks-panel.jsx` — prototype-only control panel (ignore for production).

To run the reference: open `Flipper Onboarding.html` in a browser and tap through (Create account → step through → Enter Flipper).
