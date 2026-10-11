import 'package:flutter/material.dart';

/// One resolved colour set for the Flipper Books marketing page.
///
/// The page is editorial: warm paper and ink, hairline rules, one blue accent,
/// and no gradients, glows or shadows. [light] is the default so the page
/// matches the rest of flipper_web (sign-in and the workspace are light).
///
/// The names mirror the reference's CSS variables (`--bg`, `--ink`,
/// `--muted`, `--line`…) so a value can be checked against it one to one.
@immutable
class BooksPalette {
  const BooksPalette({
    required this.brightness,
    required this.bg,
    required this.bgRaised,
    required this.bgSunken,
    required this.ink,
    required this.inkStrong,
    required this.muted,
    required this.faint,
    required this.line,
    required this.lineStrong,
    required this.accent,
    required this.accentInk,
    required this.invertBg,
    required this.invertFg,
    required this.danger,
    required this.gain,
    required this.scanline,
  });

  final Brightness brightness;

  // Surfaces.
  final Color bg;
  final Color bgRaised;
  final Color bgSunken;

  // Ink, strongest to faintest. [muted] and [faint] are translucent ink so
  // they sit right on any of the three surfaces.
  final Color ink;
  final Color inkStrong;
  final Color muted;
  final Color faint;

  // Hairlines.
  final Color line;
  final Color lineStrong;

  /// The only hue on the page. [accentInk] is the text-safe shade of it.
  final Color accent;
  final Color accentInk;

  /// A block that flips to the opposite mode: filled buttons, the popular
  /// plan, hovered cells.
  final Color invertBg;
  final Color invertFg;

  // Signed numbers in the product mocks.
  final Color danger;
  final Color gain;

  /// The 1px rules behind the hero.
  final Color scanline;

  bool get isDark => brightness == Brightness.dark;

  static const light = BooksPalette(
    brightness: Brightness.light,
    bg: Color(0xFFF2F1EE),
    bgRaised: Color(0xFFFAF9F7),
    bgSunken: Color(0xFFE9E8E4),
    ink: Color(0xFF101014),
    inkStrong: Color(0xFF000000),
    muted: Color(0x9E101014),
    faint: Color(0x6B101014),
    line: Color(0x29101014),
    lineStrong: Color(0x66101014),
    accent: Color(0xFF2D81FF),
    accentInk: Color(0xFF1659C4),
    invertBg: Color(0xFF101014),
    invertFg: Color(0xFFF2F1EE),
    danger: Color(0xFFB3261E),
    gain: Color(0xFF1B7A4B),
    scanline: Color(0x08101014),
  );

  static const dark = BooksPalette(
    brightness: Brightness.dark,
    bg: Color(0xFF121316),
    bgRaised: Color(0xFF101014),
    bgSunken: Color(0xFF060607),
    ink: Color(0xFFF2F1EE),
    inkStrong: Color(0xFFFFFFFF),
    muted: Color(0x99F2F1EE),
    faint: Color(0x61F2F1EE),
    line: Color(0x26F2F1EE),
    lineStrong: Color(0x66F2F1EE),
    accent: Color(0xFF2D81FF),
    accentInk: Color(0xFF74AAFF),
    invertBg: Color(0xFFFFFFFF),
    invertFg: Color(0xFF0B0B0C),
    danger: Color(0xFFFF6259),
    gain: Color(0xFF5BD69A),
    scanline: Color(0x06FFFFFF),
  );
}

/// Design tokens for the Flipper Books marketing home page.
///
/// Every token reads from [AppColors.palette], which [BooksHomeTheme.of] swaps
/// before the page's `ThemeData` is built. The page renders one palette at a
/// time (it is a single full-screen route), so a process-wide active palette
/// keeps the call sites free of a context lookup; nothing else in flipper_web
/// reads these tokens.
abstract final class AppColors {
  /// The palette the page is currently rendering with. Installed by
  /// [BooksHomeTheme.of]; light until something says otherwise.
  static BooksPalette palette = BooksPalette.light;

  static Color get bg => palette.bg;
  static Color get bgRaised => palette.bgRaised;
  static Color get bgSunken => palette.bgSunken;
  static Color get ink => palette.ink;
  static Color get inkStrong => palette.inkStrong;
  static Color get muted => palette.muted;
  static Color get faint => palette.faint;
  static Color get line => palette.line;
  static Color get lineStrong => palette.lineStrong;
  static Color get accent => palette.accent;
  static Color get accentInk => palette.accentInk;
  static Color get invertBg => palette.invertBg;
  static Color get invertFg => palette.invertFg;
  static Color get danger => palette.danger;
  static Color get gain => palette.gain;
  static Color get scanline => palette.scanline;

  /// Ink on the accent fill, the same in both modes.
  static const onAccent = Color(0xFFFFFFFF);
}

abstract final class AppSpace {
  /// The phone mock is the one rounded thing on the page: it is a device.
  static const rDevice = 18.0;
  static const maxW = 1280.0;
  static const gutter = 28.0;
  static const gutterMobile = 18.0;
  static const sectionY = 120.0;
}

abstract final class AppCurves {
  static const reveal = Cubic(0.2, 0.7, 0.3, 1);
  static const press = Cubic(0.3, 0.7, 0.4, 1);
}

abstract final class AppText {
  // All four families are bundled as assets and declared in pubspec.yaml under
  // these names; Inter is the offline fallback.
  static const _display = 'Archivo';
  static const _serif = 'Instrument Serif';
  static const _sans = 'Geist';
  static const _mono = 'Geist Mono';
  static const _fallback = <String>['Inter', 'system-ui', 'sans-serif'];

  // These are getters, not constants: they bake in a palette colour, and the
  // palette can change when the viewer switches theme.

  /// Heavy, tight headline type.
  static TextStyle display(double size, {Color? c}) => TextStyle(
    fontFamily: _display,
    fontFamilyFallback: _fallback,
    fontSize: size,
    fontWeight: FontWeight.w800,
    height: 0.95,
    letterSpacing: -0.04 * size,
    color: c ?? AppColors.ink,
  );

  /// The serif italic set inside a [display] headline. Instrument Serif runs
  /// small next to Archivo, so it is nudged up to match the cap height.
  static TextStyle accent(double size, {Color? c}) => TextStyle(
    fontFamily: _serif,
    fontFamilyFallback: const ['Georgia', 'serif'],
    fontSize: size * 1.08,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 0.95 / 1.08,
    letterSpacing: -0.01 * size,
    color: c ?? AppColors.ink,
  );

  /// Card and row titles.
  static TextStyle title(double size, {Color? c}) => TextStyle(
    fontFamily: _display,
    fontFamilyFallback: _fallback,
    fontSize: size,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.02 * size,
    color: c ?? AppColors.ink,
  );

  static TextStyle get body => TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 15.5,
    height: 1.6,
    color: AppColors.muted,
  );

  static TextStyle get lead => TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 18,
    height: 1.55,
    color: AppColors.muted,
  );

  static TextStyle get small => TextStyle(
    fontFamily: _sans,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    height: 1.5,
    color: AppColors.faint,
  );

  /// Mono caps for buttons, section indexes and tags. Callers upper-case the
  /// string; a [TextStyle] cannot.
  static TextStyle label({
    double size = 11,
    FontWeight w = FontWeight.w700,
    Color? c,
  }) => TextStyle(
    fontFamily: _mono,
    fontFamilyFallback: _fallback,
    fontSize: size,
    fontWeight: w,
    height: 1.3,
    letterSpacing: 0.12 * size,
    color: c ?? AppColors.muted,
  );

  static TextStyle mono({
    double size = 14,
    FontWeight w = FontWeight.w600,
    Color? c,
  }) => TextStyle(
    fontFamily: _mono,
    fontFamilyFallback: _fallback,
    fontSize: size,
    fontWeight: w,
    letterSpacing: -0.01 * size,
    fontFeatures: const [FontFeature.tabularFigures()],
    color: c ?? AppColors.ink,
  );

  static const buttonHeight = 48.0;
  static const buttonHeightNav = 40.0;
}

/// The hero headline, sized off the viewport so it reads as a poster.
double booksHomeDisplaySize(double width) => (width * 0.085).clamp(48.0, 136.0);

/// Section headlines. Viewport-relative (like CSS `vw`), so it must read the
/// screen width — not the capped content width of the section.
double booksHomeH2Size(double width) => (width * 0.05).clamp(36.0, 76.0);

double booksHomeH2SizeOf(BuildContext context) =>
    booksHomeH2Size(MediaQuery.sizeOf(context).width);

double booksHomeGutter(double width) =>
    width < 560 ? AppSpace.gutterMobile : AppSpace.gutter;

int booksHomeCols(double width) => width > 860
    ? 3
    : width > 560
    ? 2
    : 1;

/// Full [ThemeData] for the Books marketing page.
abstract final class BooksHomeTheme {
  /// Activates the palette for [brightness] and returns the matching theme.
  ///
  /// Call this before building any marketing-page widget — the tokens on
  /// [AppColors] read the palette it installs.
  static ThemeData of(Brightness brightness) {
    AppColors.palette = brightness == Brightness.dark
        ? BooksPalette.dark
        : BooksPalette.light;
    return _build(brightness);
  }

  static ColorScheme _colorScheme(Brightness brightness) => ColorScheme(
    brightness: brightness,
    primary: AppColors.ink,
    onPrimary: AppColors.invertFg,
    secondary: AppColors.accent,
    onSecondary: AppColors.onAccent,
    error: AppColors.danger,
    onError: AppColors.onAccent,
    surface: AppColors.bgRaised,
    onSurface: AppColors.ink,
    surfaceContainerHighest: AppColors.bgSunken,
    onSurfaceVariant: AppColors.muted,
    outline: AppColors.lineStrong,
  );

  static ThemeData _build(Brightness brightness) => ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Geist',
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    cardColor: AppColors.bgRaised,
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.bgRaised,
      shape: const RoundedRectangleBorder(),
    ),
    dividerColor: AppColors.line,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: AppColors.ink.withValues(alpha: 0.04),
    colorScheme: _colorScheme(brightness),
    textTheme: TextTheme(
      displayLarge: AppText.display(96),
      displayMedium: AppText.display(64),
      headlineMedium: AppText.title(24),
      titleMedium: AppText.title(17),
      bodyLarge: AppText.body,
      bodyMedium: AppText.lead,
      bodySmall: AppText.small,
      labelSmall: AppText.label(),
    ),
    iconTheme: IconThemeData(color: AppColors.muted, size: 22),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.ink,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.accent,
      circularTrackColor: AppColors.bgSunken,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.accent,
      selectionColor: AppColors.accent.withValues(alpha: 0.25),
      selectionHandleColor: AppColors.accent,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.bgRaised,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColors.bgRaised,
      shape: const RoundedRectangleBorder(),
    ),
  );
}
