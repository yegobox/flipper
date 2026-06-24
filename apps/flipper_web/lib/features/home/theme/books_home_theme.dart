import 'package:flutter/material.dart';

/// Design tokens for the Flipper Books marketing home page (handoff v1).
abstract final class AppColors {
  static const bg = Color(0xFF06080D);
  static const bg2 = Color(0xFF0A0E16);
  static const panel = Color(0xFF0E1422);
  static const panel2 = Color(0xFF121A2B);
  static const ink0 = Color(0xFFFFFFFF);
  static const ink1 = Color(0xFFE9EEF6);
  static const ink2 = Color(0xFFAAB4C4);
  static const ink3 = Color(0xFF7D8798);
  static const ink4 = Color(0xFF586172);
  static const blue = Color(0xFF3F7BFF);
  static const royal = Color(0xFF2F5CF5);
  static const violet = Color(0xFF6D5CF0);
  static const indigo = Color(0xFF4F46E5);
  static const cyan = Color(0xFF34C8E6);
  static const green = Color(0xFF2FE0A0);
  static const greenInk = Color(0xFF10B981);
  static const amber = Color(0xFFFFB43D);
  static const amber2 = Color(0xFFFB9D00);
  static const suiteActiveInk = Color(0xFF061018);
  static const downKpi = Color(0xFFFF8B6B);
  static const posSo = Color(0xFFC4663D);
  static const posCc = Color(0xFF3F7FD6);
  static const posFc = Color(0xFF5F8A3C);
  static const whiteCardInk = Color(0xFF0B1220);
  static const whiteCardMuted = Color(0xFF6B7689);
  static const whiteCardBar = Color(0xFFDDE4F6);
  static const saleCheckBg = Color(0xFFE6F9F1);
  static const popularTagInk = Color(0xFF06140E);
  static const whiteButtonText = Color(0xFF2B50E0);

  static final line = Colors.white.withValues(alpha: 0.08);
  static final line2 = Colors.white.withValues(alpha: 0.14);
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

  static const glassCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xEB141C2E), Color(0xF00B101C)],
  );

  static const suiteCardFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x09FFFFFF), Color(0x03FFFFFF)],
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

  static const pricingCardFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x12FFFFFF), Color(0x06FFFFFF)],
  );
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
  static final card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.7),
      blurRadius: 50,
      spreadRadius: -20,
      offset: const Offset(0, 18),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 14,
      offset: const Offset(0, 4),
    ),
  ];

  static final violetGlow = [
    BoxShadow(
      color: AppColors.violet.withValues(alpha: 0.6),
      blurRadius: 30,
      spreadRadius: -10,
      offset: const Offset(0, 12),
    ),
  ];

  static final bandShadow = [
    BoxShadow(
      color: const Color(0xFF2B50E0).withValues(alpha: 0.7),
      blurRadius: 90,
      spreadRadius: -40,
      offset: const Offset(0, 40),
    ),
  ];

  static final popularGlow = [
    BoxShadow(
      color: AppColors.green.withValues(alpha: 0.4),
      blurRadius: 70,
      spreadRadius: -30,
      offset: const Offset(0, 30),
    ),
  ];

  static final cyanSuiteGlow = [
    BoxShadow(
      color: AppColors.cyan.withValues(alpha: 0.4),
      blurRadius: 60,
      spreadRadius: -28,
      offset: const Offset(0, 24),
    ),
  ];

  static final whiteCard = [
    BoxShadow(
      color: const Color(0xFF081034).withValues(alpha: 0.55),
      blurRadius: 54,
      spreadRadius: -18,
      offset: const Offset(0, 26),
    ),
  ];

  static final greenGlow = [
    BoxShadow(
      color: AppColors.green.withValues(alpha: 0.35),
      blurRadius: 32,
      spreadRadius: -8,
      offset: const Offset(0, 14),
    ),
  ];

  static final cyanGlow = [
    BoxShadow(
      color: AppColors.cyan.withValues(alpha: 0.28),
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

  static const h3 = TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 21,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.ink0,
  );

  static const h4 = TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 16.5,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.165,
    height: 1.5,
    color: AppColors.ink0,
  );

  static const body = TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 16.5,
    height: 1.55,
    color: AppColors.ink2,
  );

  static const lead = TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 18,
    height: 1.55,
    fontWeight: FontWeight.w400,
    color: AppColors.ink2,
  );

  static const small = TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    height: 1.5,
    color: AppColors.ink3,
  );

  static const eyebrow = TextStyle(
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

  static const buttonLabel = TextStyle(
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
  static const _colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.violet,
    onPrimary: AppColors.ink0,
    secondary: AppColors.cyan,
    onSecondary: AppColors.ink0,
    tertiary: AppColors.blue,
    onTertiary: AppColors.ink0,
    error: Color(0xFFCF6679),
    onError: AppColors.ink0,
    surface: AppColors.panel,
    onSurface: AppColors.ink1,
    surfaceContainerHighest: AppColors.panel2,
    onSurfaceVariant: AppColors.ink2,
    outline: AppColors.ink4,
  );

  static ThemeData get data => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Geist',
        scaffoldBackgroundColor: AppColors.bg,
        canvasColor: AppColors.bg,
        cardColor: AppColors.panel,
        dialogTheme: const DialogThemeData(backgroundColor: AppColors.panel),
        dividerColor: AppColors.line,
        splashColor: AppColors.violet.withValues(alpha: 0.14),
        highlightColor: Colors.white.withValues(alpha: 0.06),
        hoverColor: Colors.white.withValues(alpha: 0.06),
        colorScheme: _colorScheme,
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
        iconTheme: const IconThemeData(color: AppColors.ink2, size: 22),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: AppColors.ink1,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.violet,
          circularTrackColor: AppColors.panel2,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.blue,
          selectionColor: Color(0x403F7BFF),
          selectionHandleColor: AppColors.blue,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.panel,
          surfaceTintColor: Colors.transparent,
          modalBackgroundColor: AppColors.panel,
        ),
      );
}
