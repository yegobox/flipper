import 'package:flutter/material.dart';

/// One resolved colour set for the Flipper Books marketing page.
///
/// The handoff was authored dark-only; [light] is the mirrored set, and it is
/// the default so the marketing page matches the rest of flipper_web (the
/// accounting workspace and sign-in are light surfaces).
///
/// Colours that sit on a *brand* surface (the blue brand band, the violet
/// primary button, the brand-gradient chips) do not belong here — they are the
/// same in both modes and live on [AppColors] as plain constants.
@immutable
class BooksPalette {
  const BooksPalette({
    required this.brightness,
    required this.bg,
    required this.bg2,
    required this.panel,
    required this.panel2,
    required this.mockScreen,
    required this.ink0,
    required this.ink1,
    required this.ink2,
    required this.ink3,
    required this.ink4,
    required this.blue,
    required this.royal,
    required this.violet,
    required this.indigo,
    required this.cyan,
    required this.green,
    required this.greenInk,
    required this.amber,
    required this.amber2,
    required this.downKpi,
    required this.popularTagInk,
    required this.washInk,
    required this.lineAlpha,
    required this.line2Alpha,
    required this.washScale,
    required this.glowScale,
    required this.shadowScale,
    required this.glassCard,
    required this.suiteCardFill,
    required this.pricingCardFill,
    required this.toastFill,
    required this.chartBar,
  });

  final Brightness brightness;

  // Surfaces.
  final Color bg;
  final Color bg2;
  final Color panel;
  final Color panel2;

  /// Screen fill of the POS phone mock in the hero stage.
  final Color mockScreen;

  // Ink ramp, strongest (ink0) to faintest (ink4).
  final Color ink0;
  final Color ink1;
  final Color ink2;
  final Color ink3;
  final Color ink4;

  // Accents.
  final Color blue;
  final Color royal;
  final Color violet;
  final Color indigo;
  final Color cyan;
  final Color green;
  final Color greenInk;
  final Color amber;
  final Color amber2;
  final Color downKpi;

  /// Ink on the solid-green "Most Popular" pill.
  final Color popularTagInk;

  /// Base colour of hairlines and surface washes: white on dark, ink on light.
  final Color washInk;

  final double lineAlpha;
  final double line2Alpha;

  /// Multiplier applied to [wash] alphas. A 2% white film reads on near-black;
  /// on white the same idea needs a slightly firmer ink film.
  final double washScale;

  /// Multiplier for the radial brand glows — they must not bloom on white.
  final double glowScale;

  /// Multiplier for drop-shadow alphas.
  final double shadowScale;

  // Surface gradients.
  final Gradient glassCard;
  final Gradient suiteCardFill;
  final Gradient pricingCardFill;
  final Gradient toastFill;
  final Gradient chartBar;

  bool get isDark => brightness == Brightness.dark;

  Color get line => washInk.withValues(alpha: lineAlpha);
  Color get line2 => washInk.withValues(alpha: line2Alpha);

  /// Subtle film over the page background (the handoff's `rgba(255,255,255,.0x)`
  /// panel fills). Inverts to an ink film in light mode.
  Color wash(double alpha) =>
      washInk.withValues(alpha: (alpha * washScale).clamp(0.0, 1.0));

  /// A brand glow, damped in light mode.
  Color glow(Color color, double alpha) =>
      color.withValues(alpha: (alpha * glowScale).clamp(0.0, 1.0));

  /// A drop shadow, damped in light mode.
  Color shadow(double alpha) => (isDark ? Colors.black : const Color(0xFF0B1220))
      .withValues(alpha: (alpha * shadowScale).clamp(0.0, 1.0));

  static const dark = BooksPalette(
    brightness: Brightness.dark,
    bg: Color(0xFF06080D),
    bg2: Color(0xFF0A0E16),
    panel: Color(0xFF0E1422),
    panel2: Color(0xFF121A2B),
    mockScreen: Color(0xFF0D1320),
    ink0: Color(0xFFFFFFFF),
    ink1: Color(0xFFE9EEF6),
    ink2: Color(0xFFAAB4C4),
    ink3: Color(0xFF7D8798),
    ink4: Color(0xFF586172),
    blue: Color(0xFF3F7BFF),
    royal: Color(0xFF2F5CF5),
    violet: Color(0xFF6D5CF0),
    indigo: Color(0xFF4F46E5),
    cyan: Color(0xFF34C8E6),
    green: Color(0xFF2FE0A0),
    greenInk: Color(0xFF10B981),
    amber: Color(0xFFFFB43D),
    amber2: Color(0xFFFB9D00),
    downKpi: Color(0xFFFF8B6B),
    popularTagInk: Color(0xFF06140E),
    washInk: Color(0xFFFFFFFF),
    lineAlpha: 0.08,
    line2Alpha: 0.14,
    washScale: 1,
    glowScale: 1,
    shadowScale: 1,
    glassCard: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xEB141C2E), Color(0xF00B101C)],
    ),
    suiteCardFill: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x09FFFFFF), Color(0x03FFFFFF)],
    ),
    pricingCardFill: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x12FFFFFF), Color(0x06FFFFFF)],
    ),
    toastFill: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFA161E32), Color(0xFA0E1422)],
    ),
    chartBar: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xD93F86FF), Color(0x403F86FF)],
    ),
  );

  /// Light mirror of [dark]. Inks are borrowed from the sign-in / accounting
  /// token sets (`SITokens`, `AccountingTokens`) so the landing page and the
  /// app behind it read as one product, and accents are darkened to keep
  /// text-on-white contrast.
  static const light = BooksPalette(
    brightness: Brightness.light,
    bg: Color(0xFFFFFFFF),
    bg2: Color(0xFFF7F9FE),
    panel: Color(0xFFFFFFFF),
    panel2: Color(0xFFF4F6FB),
    mockScreen: Color(0xFFFFFFFF),
    ink0: Color(0xFF0B1220),
    ink1: Color(0xFF16203A),
    ink2: Color(0xFF4A5567),
    ink3: Color(0xFF7E8AA0),
    ink4: Color(0xFF9AA8BC),
    blue: Color(0xFF2563EB),
    royal: Color(0xFF1D4ED8),
    violet: Color(0xFF5B4FE6),
    indigo: Color(0xFF4338CA),
    cyan: Color(0xFF0E93AE),
    green: Color(0xFF0E9F6E),
    greenInk: Color(0xFF047857),
    amber: Color(0xFFB45309),
    amber2: Color(0xFFC2740A),
    downKpi: Color(0xFFD1483A),
    popularTagInk: Color(0xFFFFFFFF),
    washInk: Color(0xFF0B1220),
    lineAlpha: 0.10,
    line2Alpha: 0.18,
    washScale: 1.1,
    glowScale: 0.45,
    shadowScale: 0.22,
    glassCard: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FE)],
    ),
    suiteCardFill: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFF9FBFF)],
    ),
    pricingCardFill: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FE)],
    ),
    toastFill: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFF4F7FD)],
    ),
    chartBar: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xD92563EB), Color(0x402563EB)],
    ),
  );
}

/// Design tokens for the Flipper Books marketing home page (handoff v1).
///
/// Every mode-dependent token reads from [AppColors.palette], which
/// [BooksHomeTheme.of] swaps before the page's `ThemeData` is built. The page
/// renders one palette at a time (it is a single full-screen route), so a
/// process-wide active palette keeps the ~200 call sites free of a context
/// lookup; nothing else in flipper_web reads these tokens.
abstract final class AppColors {
  /// The palette the page is currently rendering with. Installed by
  /// [BooksHomeTheme.of]; light until something says otherwise.
  static BooksPalette palette = BooksPalette.light;

  static Color get bg => palette.bg;
  static Color get bg2 => palette.bg2;
  static Color get panel => palette.panel;
  static Color get panel2 => palette.panel2;
  static Color get mockScreen => palette.mockScreen;
  static Color get ink0 => palette.ink0;
  static Color get ink1 => palette.ink1;
  static Color get ink2 => palette.ink2;
  static Color get ink3 => palette.ink3;
  static Color get ink4 => palette.ink4;
  static Color get blue => palette.blue;
  static Color get royal => palette.royal;
  static Color get violet => palette.violet;
  static Color get indigo => palette.indigo;
  static Color get cyan => palette.cyan;
  static Color get green => palette.green;
  static Color get greenInk => palette.greenInk;
  static Color get amber => palette.amber;
  static Color get amber2 => palette.amber2;
  static Color get downKpi => palette.downKpi;
  static Color get popularTagInk => palette.popularTagInk;
  static Color get line => palette.line;
  static Color get line2 => palette.line2;

  static Color wash(double alpha) => palette.wash(alpha);
  static Color glow(Color color, double alpha) => palette.glow(color, alpha);
  static Color shadow(double alpha) => palette.shadow(alpha);

  // ── Mode-independent ───────────────────────────────────────────────────────
  // These sit on a brand-coloured surface (the brand band, the violet primary
  // button, a brand-gradient chip) or on a card that is white in both modes, so
  // they must not follow the page palette.

  /// Ink and small fills on top of a brand gradient or a saturated accent fill.
  static const onBrand = Color(0xFFFFFFFF);

  /// Fill of the floating cards inside the blue brand band.
  static const cardOnBrand = Color(0xFFFFFFFF);

  /// Ink on the brand-gradient suite chips / app tiles.
  static const suiteActiveInk = Color(0xFF061018);

  static const whiteCardInk = Color(0xFF0B1220);
  static const whiteCardMuted = Color(0xFF6B7689);

  /// "Up"/gain green readable on those permanently-white cards.
  static const whiteCardGain = Color(0xFF047857);
  static const whiteCardBar = Color(0xFFDDE4F6);
  static const saleCheckBg = Color(0xFFE6F9F1);
  static const whiteButtonText = Color(0xFF2B50E0);

  // POS mock product swatches — they sit on their own coloured tiles.
  static const posSo = Color(0xFFC4663D);
  static const posCc = Color(0xFF3F7FD6);
  static const posFc = Color(0xFF5F8A3C);
}

abstract final class AppGrad {
  static const brand = LinearGradient(
    begin: Alignment(-0.9, -0.5),
    end: Alignment(0.9, 0.5),
    colors: [Color(0xFF3F86FF), Color(0xFF5566F0), Color(0xFF6D5CF0)],
    stops: [0, 0.5, 1],
  );

  static const button = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF7B6CF2), Color(0xFF5B4FE6)],
  );

  static const band = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3361F7), Color(0xFF2B50E0), Color(0xFF4038CF)],
    stops: [0, 0.52, 1],
  );

  static const appIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5E9BFF), Color(0xFF4B41D6)],
  );

  static const soft = LinearGradient(
    begin: Alignment(-0.9, -0.5),
    end: Alignment(0.9, 0.5),
    colors: [
      Color(0x2E3F86FF),
      Color(0x295B4FE6),
      Color(0x2E6D5CF0),
    ],
    stops: [0, 0.5, 1],
  );

  static const suitePosIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5AA0FF), Color(0xFF2F6BF0)],
  );

  static const suiteBooksIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF43D6EE), Color(0xFF2F9FD0)],
  );

  static const suiteFlowIcon = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFC760), Color(0xFFFB9D00)],
  );

  static const streakFlame = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9A4D), Color(0xFFFB5E00)],
  );

  // Mode-dependent surface fills.
  static Gradient get glassCard => AppColors.palette.glassCard;
  static Gradient get suiteCardFill => AppColors.palette.suiteCardFill;
  static Gradient get pricingCardFill => AppColors.palette.pricingCardFill;
  static Gradient get toastFill => AppColors.palette.toastFill;
  static Gradient get chartBar => AppColors.palette.chartBar;
}

abstract final class AppSpace {
  static const rSm = 10.0;
  static const rMd = 16.0;
  static const rLg = 22.0;
  static const rXl = 30.0;
  static const maxW = 1200.0;
  static const heroSubMaxW = 620.0;
  static const gutter = 28.0;
  static const gutterMobile = 18.0;
  static const sectionY = 100.0;
}

abstract final class AppShadow {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.shadow(0.7),
          blurRadius: 50,
          spreadRadius: -20,
          offset: const Offset(0, 18),
        ),
        BoxShadow(
          color: AppColors.shadow(0.4),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get violetGlow => [
        BoxShadow(
          color: AppColors.glow(AppColors.violet, 0.6),
          blurRadius: 30,
          spreadRadius: -10,
          offset: const Offset(0, 12),
        ),
      ];

  /// The brand band is the same saturated blue in both modes, so its shadow is
  /// keyed to the band, not to the page.
  static final bandShadow = [
    BoxShadow(
      color: const Color(0xFF2B50E0).withValues(alpha: 0.7),
      blurRadius: 90,
      spreadRadius: -40,
      offset: const Offset(0, 40),
    ),
  ];

  static List<BoxShadow> get popularGlow => [
        BoxShadow(
          color: AppColors.glow(AppColors.green, 0.4),
          blurRadius: 70,
          spreadRadius: -30,
          offset: const Offset(0, 30),
        ),
      ];

  static List<BoxShadow> get cyanSuiteGlow => [
        BoxShadow(
          color: AppColors.glow(AppColors.cyan, 0.4),
          blurRadius: 60,
          spreadRadius: -28,
          offset: const Offset(0, 24),
        ),
      ];

  /// Lift under the white cards floating on the brand band.
  static final whiteCard = [
    BoxShadow(
      color: const Color(0xFF081034).withValues(alpha: 0.55),
      blurRadius: 54,
      spreadRadius: -18,
      offset: const Offset(0, 26),
    ),
  ];

  static List<BoxShadow> get greenGlow => [
        BoxShadow(
          color: AppColors.glow(AppColors.green, 0.35),
          blurRadius: 32,
          spreadRadius: -8,
          offset: const Offset(0, 14),
        ),
      ];

  static List<BoxShadow> get cyanGlow => [
        BoxShadow(
          color: AppColors.glow(AppColors.cyan, 0.28),
          blurRadius: 28,
          spreadRadius: -6,
          offset: const Offset(0, 10),
        ),
      ];
}

abstract final class AppCurves {
  static const reveal = Cubic(0.2, 0.7, 0.3, 1);
  static const press = Cubic(0.3, 0.7, 0.4, 1);
}

abstract final class AppText {
  // Geist / Geist Mono (the handoff fonts) are bundled as assets and declared
  // in pubspec.yaml under these family names. A bare `fontFamily: 'Geist'`
  // resolves against those bundled files; Inter is the offline fallback.
  static const _sans = 'Geist';
  static const _mono = 'Geist Mono';
  static const _fallback = <String>['Inter', 'system-ui', 'sans-serif'];

  // These are getters, not constants: they bake in a palette colour, and the
  // palette can change when the viewer switches theme.

  static TextStyle h1(double size) => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 0.98,
        letterSpacing: -0.035 * size,
        color: AppColors.ink0,
      );

  static TextStyle h2(double size) => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.04,
        letterSpacing: -0.03 * size,
        color: AppColors.ink0,
      );

  static TextStyle get h3 => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: AppColors.ink0,
      );

  static TextStyle get h4 => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: 16.5,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.165,
        height: 1.5,
        color: AppColors.ink0,
      );

  static TextStyle get body => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: 16.5,
        height: 1.55,
        color: AppColors.ink2,
      );

  static TextStyle get lead => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: 18,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: AppColors.ink2,
      );

  static TextStyle get small => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: 13,
        height: 1.5,
        color: AppColors.ink3,
      );

  static TextStyle get eyebrow => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.7,
        color: AppColors.ink2,
      );

  static TextStyle mono({
    double size = 14,
    FontWeight w = FontWeight.w600,
    Color? c,
  }) =>
      TextStyle(
        fontFamily: _mono,
        fontFamilyFallback: _fallback,
        fontSize: size,
        fontWeight: w,
        letterSpacing: -0.14,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: c ?? AppColors.ink1,
      );

  static TextStyle get buttonLabel => TextStyle(
        fontFamily: _sans,
        fontFamilyFallback: _fallback,
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01 * 15.5,
        color: AppColors.ink0,
      );

  /// Handoff `.btn` = 50px; `.btn-sm` (nav) = 42px.
  static const buttonHeightHero = 50.0;
  static const buttonHeightNav = 42.0;
  static const buttonPadX = 26.0;
  static const buttonPadXSm = 20.0;
}

double booksHomeH1Size(double width) => (width * 0.066).clamp(44.0, 88.0);

double booksHomeH2Size(double width) => (width * 0.04).clamp(32.0, 52.0);

/// Section H2 sizing per the handoff `clamp(32px, 4vw, 52px)`. The `4vw` is
/// viewport-relative, so it must read the screen width — not the (capped 1200)
/// content width of the section, which would render headings undersized.
double booksHomeH2SizeOf(BuildContext context) =>
    booksHomeH2Size(MediaQuery.sizeOf(context).width);

double booksHomeGutter(double width) =>
    width < 560 ? AppSpace.gutterMobile : AppSpace.gutter;

int booksHomeCols(double width) =>
    width > 860 ? 3 : width > 560 ? 2 : 1;

/// Full [ThemeData] for the Books marketing page (handoff § Flutter theme setup).
abstract final class BooksHomeTheme {
  /// Activates the palette for [brightness] and returns the matching theme.
  ///
  /// Call this before building any marketing-page widget — the tokens on
  /// [AppColors] read the palette it installs.
  static ThemeData of(Brightness brightness) {
    AppColors.palette =
        brightness == Brightness.dark ? BooksPalette.dark : BooksPalette.light;
    return _build(brightness);
  }

  static ColorScheme _colorScheme(Brightness brightness) => ColorScheme(
        brightness: brightness,
        primary: AppColors.violet,
        onPrimary: AppColors.onBrand,
        secondary: AppColors.cyan,
        onSecondary: AppColors.onBrand,
        tertiary: AppColors.blue,
        onTertiary: AppColors.onBrand,
        error: brightness == Brightness.dark
            ? const Color(0xFFCF6679)
            : const Color(0xFFB3261E),
        onError: AppColors.onBrand,
        surface: AppColors.panel,
        onSurface: AppColors.ink1,
        surfaceContainerHighest: AppColors.panel2,
        onSurfaceVariant: AppColors.ink2,
        outline: AppColors.ink4,
      );

  static ThemeData _build(Brightness brightness) => ThemeData(
        useMaterial3: true,
        brightness: brightness,
        fontFamily: 'Geist',
        scaffoldBackgroundColor: AppColors.bg,
        canvasColor: AppColors.bg,
        cardColor: AppColors.panel,
        dialogTheme: DialogThemeData(backgroundColor: AppColors.panel),
        dividerColor: AppColors.line,
        splashColor: AppColors.violet.withValues(alpha: 0.14),
        highlightColor: AppColors.wash(0.06),
        hoverColor: AppColors.wash(0.06),
        colorScheme: _colorScheme(brightness),
        textTheme: TextTheme(
          displayLarge: AppText.h1(88),
          displayMedium: AppText.h2(52),
          headlineMedium: AppText.h3,
          titleMedium: AppText.h4,
          bodyLarge: AppText.body,
          bodyMedium: AppText.lead,
          bodySmall: AppText.small,
          labelSmall: AppText.eyebrow,
        ),
        iconTheme: IconThemeData(color: AppColors.ink2, size: 22),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: AppColors.ink1,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.violet,
          circularTrackColor: AppColors.panel2,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.blue,
          selectionColor: AppColors.blue.withValues(alpha: 0.25),
          selectionHandleColor: AppColors.blue,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.panel,
          surfaceTintColor: Colors.transparent,
          modalBackgroundColor: AppColors.panel,
        ),
      );
}
