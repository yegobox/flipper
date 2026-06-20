# Flipper Books — Home Page · Developer Handoff (Flutter)

> **How to use this pack.** Give an LLM coding agent **this file plus `reference/home.html` and `reference/styles.css`**. The reference files are the source of truth — every number below is taken from them. When in doubt, read the CSS. Build in the order in §9.

---

## 1. What you're building

A single scrolling **marketing home page** for **Flipper Books** (the accounting app in the Flipper suite). Positioning: *"accounting that does itself"* — powered by **Flow AI**, deeply integrated with **Flipper POS**.

**Theme:** dark. **Brand:** blue → violet. **Fonts:** Geist + Geist Mono.

**Cohesion contract (must match the existing login screen):**
- Rounded-square **app-icon logo** (NOT a swirl) — see `assets/flipper_mark.svg`.
- **Violet** primary buttons (same as the login "Sign In").
- Royal-blue brand surfaces with **floating white cards + concentric rings**.
- Stats `12,400+ businesses · RWF 1.2B processed monthly · 99.9% uptime`.

**Section order (top → bottom):**
1. Sticky header — logo, suite switcher (POS · Books · Flow), nav links, "Start free".
2. Hero — gradient headline, sub, 2 CTAs, trust micro-row, product stage (Books dashboard + floating Flow toast + floating POS phone).
3. Trust strip — 4 chips.
4. Connected suite — 3 cards (Sell / Account / Automate) + connectors + loop line.
5. Flow AI — feature list + chat panel showing an auto-posted journal entry.
6. Capabilities — 6-card grid.
7. Pricing — 3 tiers (Mobile / Mobile+Desktop=Most Popular / Enterprise).
8. Brand band — royal-blue panel (login echo): rings, floating white cards, stats, CTAs.
9. Footer — brand + 4 link columns + legal row.

---

## 2. Rules for the coding agent (paste this verbatim)

```
ROLE: Implement the Flipper Books marketing home page in Flutter.
STACK: Flutter 3.x, null-safe. Web is primary; responsive down to 360px.

HARD RULES
1. Use the tokens in AppColors / AppText / AppGrad / AppSpace verbatim.
   Never hardcode a hex or size that isn't a token.
2. Primary buttons = VIOLET gradient (AppGrad.button), white text, StadiumBorder.
3. Logo = the SVG in assets/ rendered with flutter_svg. Do NOT redraw it.
4. Background is dark (AppColors.bg). Body text = ink2; headings = ink0/ink1.
5. Respect reduced motion: if MediaQuery.disableAnimations is true, skip the
   float + reveal animations and render the final state.
6. Responsive via LayoutBuilder at breakpoints 1040 / 860 / 560 (see §8).
7. Hero product UI, charts and the journal-entry card are decorative MOCKS —
   build them with Containers/Rows, no charting/data packages.

DELIVER IN THIS ORDER
a) tokens  b) shared widgets (buttons, chips, glass card)  c) sections top→bottom
d) animations  e) assemble into one CustomScrollView/SingleChildScrollView.

Match animation curves and durations exactly (see §7). They are not suggestions.
Allowed packages: flutter_svg, visibility_detector. Everything else core Flutter.
```

---

## 3. Color tokens

```dart
// lib/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // surfaces
  static const bg     = Color(0xFF06080D);
  static const bg2    = Color(0xFF0A0E16);
  static const panel  = Color(0xFF0E1422);
  static const panel2 = Color(0xFF121A2B);
  // ink
  static const ink0 = Color(0xFFFFFFFF);
  static const ink1 = Color(0xFFE9EEF6);
  static const ink2 = Color(0xFFAAB4C4); // default body text
  static const ink3 = Color(0xFF7D8798);
  static const ink4 = Color(0xFF586172);
  // brand + semantic
  static const blue    = Color(0xFF3F7BFF); // accent
  static const royal   = Color(0xFF2F5CF5); // brand band base
  static const violet  = Color(0xFF6D5CF0); // primary button
  static const indigo  = Color(0xFF4F46E5);
  static const cyan    = Color(0xFF34C8E6); // "Books" tag only
  static const green   = Color(0xFF2FE0A0);
  static const greenInk= Color(0xFF10B981);
  static const amber   = Color(0xFFFFB43D); // Flow accent
  // lines (white over dark bg)
  static final line  = Colors.white.withOpacity(0.08);
  static final line2 = Colors.white.withOpacity(0.14);
}
```

---

## 4. Gradients

CSS angles → Flutter alignments: `120deg` ≈ topLeft→bottomRight (slight), `180deg` = top→bottom, `135deg` = topLeft→bottomRight.

```dart
// lib/theme/gradients.dart
class AppGrad {
  static const brand = LinearGradient(            // hero headline phrase + accents
    begin: Alignment(-0.9, -0.5), end: Alignment(0.9, 0.5),
    colors: [Color(0xFF3F86FF), Color(0xFF5566F0), Color(0xFF6D5CF0)],
    stops: [0, 0.5, 1],
  );
  static const button = LinearGradient(           // VIOLET primary button (180deg)
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFF7B6CF2), Color(0xFF5B4FE6)],
  );
  static const band = LinearGradient(             // royal-blue brand band (135deg)
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF3361F7), Color(0xFF2B50E0), Color(0xFF4038CF)],
    stops: [0, 0.52, 1],
  );
  static const appIcon = LinearGradient(          // logo tile
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF5E9BFF), Color(0xFF4B41D6)],
  );
}

// Gradient TEXT (e.g. "does itself."): ShaderMask over the Text.
ShaderMask(
  shaderCallback: (r) => AppGrad.brand.createShader(r),
  blendMode: BlendMode.srcIn,
  child: Text('does itself.', style: heroH1Style),
);
```

---

## 5. Typography

Geist everywhere; **Geist Mono** for money/numbers/codes (tabular figures). Headings tight + heavy.

| Role | Size / line-height | Weight | Tracking | Color |
|---|---|---|---|---|
| Hero H1 | clamp 44–88 / 0.98 | 800 | -0.035em | ink0 |
| Section H2 | clamp 32–52 / 1.04 | 700 | -0.03em | ink0 |
| Card H3 | 21 / 1.2 | 700 | -0.02em | ink0 |
| Sub-head H4 | 16.5 / 1.5 | 600 | -0.01em | ink0 |
| Body / lead | 16–20 / 1.55 | 400–500 | 0 | ink2 |
| Small / meta | 12.5–13.5 / 1.5 | 500 | 0 | ink3 |
| Eyebrow | 12 / 1 | 700 | +0.14em UPPER | ink2 |
| Money / num | Geist Mono | 600–800 | -0.01em tabular | varies |

No `clamp()` in Flutter — compute from width inside a `LayoutBuilder`:
`final h1 = (w * 0.066).clamp(44.0, 88.0);` (and `h2 = (w*0.04).clamp(32.0,52.0)`).

```dart
// lib/theme/text.dart
import 'dart:ui';
class AppText {
  static const _f = 'Geist', _m = 'Geist Mono';
  static TextStyle h1({required double size}) => TextStyle(fontFamily:_f, fontSize:size,
      fontWeight:FontWeight.w800, height:0.98, letterSpacing:size*-0.035, color:AppColors.ink0);
  static TextStyle h2({required double size}) => TextStyle(fontFamily:_f, fontSize:size,
      fontWeight:FontWeight.w700, height:1.04, letterSpacing:size*-0.03, color:AppColors.ink0);
  static const h3 = TextStyle(fontFamily:_f, fontSize:21, fontWeight:FontWeight.w700,
      letterSpacing:-0.4, color:AppColors.ink0);
  static const body = TextStyle(fontFamily:_f, fontSize:16.5, height:1.55, color:AppColors.ink2);
  static const small = TextStyle(fontFamily:_f, fontSize:13, height:1.5, color:AppColors.ink3);
  static const eyebrow = TextStyle(fontFamily:_f, fontSize:12, fontWeight:FontWeight.w700,
      letterSpacing:1.7, color:AppColors.ink2);
  static TextStyle mono({double size=14, FontWeight w=FontWeight.w600, Color? c}) =>
      TextStyle(fontFamily:_m, fontSize:size, fontWeight:w, letterSpacing:-0.14,
          fontFeatures:const [FontFeature.tabularFigures()], color: c ?? AppColors.ink1);
}
```

`pubspec.yaml`: bundle Geist (400/500/600/700/800) and Geist Mono (500/600), plus `assets/` for SVGs. Or use the `google_fonts` package.

---

## 6. Spacing · radii · shadows

```dart
class AppSpace {
  static const rSm=10.0, rMd=16.0, rLg=22.0, rXl=30.0; // pill = 999 → StadiumBorder
  static const maxW=1200.0, gutter=28.0, gutterSm=18.0, sectionY=100.0;
}
class AppShadow {
  static final card = [
    BoxShadow(color: Colors.black.withOpacity(0.7), blurRadius:50, spreadRadius:-20, offset: Offset(0,18)),
    BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius:14, offset: Offset(0,4)),
  ];
  static final violetGlow = [BoxShadow(color: AppColors.violet.withOpacity(0.6),
      blurRadius:30, spreadRadius:-10, offset: Offset(0,12))];
  static final whiteCard = [BoxShadow(color: const Color(0xFF081034).withOpacity(0.55),
      blurRadius:54, spreadRadius:-18, offset: Offset(0,26))];
}
```

Glow blobs (hero/band background): `Positioned` `Container`s with a `RadialGradient` (transparent edge), `IgnorePointer`, optionally `ImageFiltered(blur)`.

---

## 7. Animations (match exactly)

| Pattern | From → To | Duration | Curve | Trigger |
|---|---|---|---|---|
| Scroll reveal | opacity 0→1, dy +22→0 | 700ms | `Cubic(.2,.7,.3,1)` | enters viewport (once) |
| Float (bob) | dy 0 → -12 → 0 | 5–6s | easeInOut | loop forever |
| Button press | scale 1→0.99 | 150ms | `Cubic(.3,.7,.4,1)` | tap down/up |
| Card hover | dy 0→-3 | 200ms | ease | pointer hover (web) |
| Header morph | bg+blur+border in | 200–250ms | ease | scrollY > 8 |

```dart
const kReveal = Cubic(0.2, 0.7, 0.3, 1);
const kPress  = Cubic(0.3, 0.7, 0.4, 1);
```

**Reveal** — start hidden+low, ease in once on scroll. Stagger groups by 0/80/160ms `delay`.
```dart
class Reveal extends StatefulWidget {
  final Widget child; final Duration delay;
  const Reveal({super.key, required this.child, this.delay = Duration.zero});
  @override State<Reveal> createState() => _RevealState();
}
class _RevealState extends State<Reveal> {
  bool _shown = false;
  @override Widget build(BuildContext ctx) {
    if (MediaQuery.of(ctx).disableAnimations) return widget.child;
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (i) {
        if (!_shown && i.visibleFraction > 0.12) {
          Future.delayed(widget.delay, () { if (mounted) setState(() => _shown = true); });
        }
      },
      child: AnimatedSlide(
        duration: const Duration(milliseconds:700), curve: kReveal,
        offset: _shown ? Offset.zero : const Offset(0, 0.14),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds:700), curve: kReveal,
          opacity: _shown ? 1 : 0, child: widget.child),
      ),
    );
  }
}
```

**Floaty** — the gentle bob for Flow toast, POS phone, and the band's white cards. Vary `period` (5s/6s) and `phase` so they don't move in lockstep.
```dart
import 'dart:math' as math;
class Floaty extends StatefulWidget {
  final Widget child; final double amplitude; final Duration period; final double phase;
  const Floaty({super.key, required this.child, this.amplitude=12,
      this.period=const Duration(seconds:5), this.phase=0});
  @override State<Floaty> createState() => _FloatyState();
}
class _FloatyState extends State<Floaty> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync:this, duration: widget.period)..repeat(reverse:true);
  @override Widget build(BuildContext ctx) {
    if (MediaQuery.of(ctx).disableAnimations) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) {
        final t = Curves.easeInOut.transform((_c.value + widget.phase) % 1.0);
        return Transform.translate(
          offset: Offset(0, -widget.amplitude * math.sin(t * math.pi)),
          child: child);
      },
      child: widget.child,
    );
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
}
```

**Press scale** (wrap every button):
```dart
class PressScale extends StatefulWidget {
  final Widget child; final VoidCallback onTap;
  const PressScale({super.key, required this.child, required this.onTap});
  @override State<PressScale> createState() => _PressScaleState();
}
class _PressScaleState extends State<PressScale> {
  bool _d = false;
  @override Widget build(BuildContext c) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTapDown: (_) => setState(() => _d = true),
      onTapCancel: () => setState(() => _d = false),
      onTap: () { setState(() => _d = false); widget.onTap(); },
      child: AnimatedScale(scale: _d ? 0.99 : 1,
        duration: const Duration(milliseconds:150), curve: kPress, child: widget.child),
    ));
}
```

**Header morph** — `ScrollController` listener sets `scrolled = offset > 8`; wrap the bar in `ClipRect` + `BackdropFilter(ImageFilter.blur(18,18))`, animate bg `rgba(6,8,13,.72)` + bottom border with `AnimatedContainer(200ms)`.

**Card hover lift** — `MouseRegion(onEnter/onExit)` toggles a bool → `AnimatedContainer(200ms)` with `transform: Matrix4.translationValues(0,-3,0)` + stronger border/shadow. Inert on touch (fine).

---

## 8. Layout & breakpoints

```dart
int gridCols(double w) => w > 860 ? 3 : w > 560 ? 2 : 1;
```

| Width | Changes |
|---|---|
| > 1040 | Full. Suite 3-across w/ arrow connectors. Flow 2-col. Footer 5-col. |
| ≤ 1040 | Hide nav links + suite switcher (use menu). Flow → 1-col. Footer → 2-col. |
| ≤ 860 | Suite cards stack (connectors rotate 90°). Capabilities → 2-col. Pricing → 1-col. Brand band → 1-col (hide its visual). Hide hero floating phone/toast. |
| ≤ 560 | Gutter 18. Capabilities → 1-col. Books dashboard mock drops its sidebar. |

Page frame: `Center` → `ConstrainedBox(maxWidth: 1200)` → horizontal padding (18 if w<560 else 28).

---

## 9. Build order & component map

Widgets to create (in `reference/styles.css` find the matching class for exact values):

1. **Tokens** — `AppColors`, `AppText`, `AppGrad`, `AppSpace`, `AppShadow`.
2. **Buttons** — `primaryButton` (violet, `.btn-primary`), `ghostButton` (`.btn-ghost`), `whiteButton` (`.btn-white`), `outlineWhiteButton` (`.btn-outline-white`). All pill, height 50 (hero) / 42 (nav).
3. **Chips/tags** — trust chip (`.trust-chip`), Books tag (`.tag`), "Most Popular" tag (`.price-tag`).
4. **GlassCard** (`.glass`) — dark vertical-gradient fill, `line2` border, `AppShadow.card`, radius lg.
5. **Header** (`.site-head/.nav`) — sticky + morph on scroll.
6. **Hero** (`.hero`) — `Stack`: dashboard `GlassCard` (`.bk-app`) centered; Flow toast (`.flow-toast`) Positioned top-right; POS phone (`.pos-float`) bottom-left. Floats wrapped in `Floaty`, gated by `bool showDeviceMocks` (default true). Background grid + glow blobs behind.
7. **Trust strip** (`.trust`) — Wrap of 4 chips.
8. **Suite** (`.suite-flow`) — 3 `SuiteCard`s + arrow connectors + loop pill (`.suite-loop`). Books card highlighted (cyan border + glow).
9. **Flow AI** (`.flow-feat`) — left: 4 `flow-li` rows; right: chat panel (`.flow-chat`) with bubbles + a journal-entry card (`.fc-entry`, two debit/credit lines, "Balanced").
10. **Capabilities** (`.cap-grid`) — 6 `CapCard`s, hover lift.
11. **Pricing** (`.price-grid`) — 3 `PriceCard`s; middle `.pop` lifted + green border + primary CTA. Keep tiers/copy exact (see §10).
12. **Brand band** (`.brand-band`) — 2-col; left copy + 3 stats + white/outline CTAs; right `Stack`: 3 concentric ring circles (`.bb-rings i`) + 3 floating white cards (`.bcard-rev/-sale/-streak`) wrapped in `Floaty`.
13. **Footer** (`.foot`) — brand + 4 columns + legal row.
14. Wrap each section group in `Reveal` (staggered). Assemble in one scroll view.

---

## 10. Fixed content (do not paraphrase)

**Pricing tiers** (all `RWF / month`):
- **Mobile — 5,000**: Mobile app access · Basic business tools · Data encryption · Single device · *+ Tax reporting (+30,000 RWF)*.
- **Mobile + Desktop — 120,000** (★ Most Popular): Mobile + Desktop access · Advanced business tools · Military-grade encryption · Priority support · Multiple devices · Advanced analytics · *+ Tax reporting (+30,000 RWF)*.
- **Enterprise — 1.5M+**: Full platform access · Enterprise-grade security · 24/7 dedicated support · Unlimited users & branches · Custom integrations · *+ Premium tax consulting (+400,000 RWF)*.

**Brand-band stats:** `12,400+ businesses` · `RWF 1.2B processed monthly` · `99.9% uptime`.

**Hero:** H1 "Accounting that **does itself.**" (last 2 words gradient). Eyebrow "Flipper Books · powered by Flow AI". CTAs "Start free" + "See how it works". Micro: RRA / EBM-ready · Works offline · RWF-native.

---

## 11. Assets

`assets/flipper_mark.svg` (included) — render with `SvgPicture.asset('assets/flipper_mark.svg', width: 30)` at sizes 16 / 30 / 42. Wordmark "Flipper" is plain `Text` (w700, -0.02em) + cyan "Books" tag.

Line icons: 24×24, stroke-width 2, round caps/joins. Use Flutter built-ins where they match, else export each glyph as SVG. Keep stroke weight consistent — never mix filled + stroked.

---

## 12. Reference files

- `reference/home.html` — the complete page markup (every section, in order).
- `reference/styles.css` — every class with exact px/colors/shadows. **This is the spec.** When a value here and the CSS disagree, the CSS wins.
- `assets/flipper_mark.svg` — the logo.

Open `reference/home.html` in a browser side-by-side while implementing.
