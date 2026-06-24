import 'package:flipper_design_system/src/theme/flipper_theme_extension.dart';
import 'package:flipper_design_system/src/tokens/flipper_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central [ThemeData] factory for all Flipper apps.
abstract final class FlipperTheme {
  static ThemeData light({bool allowRuntimeFontFetching = false}) =>
      _build(
        brightness: Brightness.light,
        extension: FlipperThemeExtension.light(),
        allowRuntimeFontFetching: allowRuntimeFontFetching,
      );

  static ThemeData dark({bool allowRuntimeFontFetching = false}) =>
      _build(
        brightness: Brightness.dark,
        extension: FlipperThemeExtension.dark(),
        allowRuntimeFontFetching: allowRuntimeFontFetching,
      );

  static ThemeData _build({
    required Brightness brightness,
    required FlipperThemeExtension extension,
    required bool allowRuntimeFontFetching,
  }) {
    GoogleFonts.config.allowRuntimeFetching = allowRuntimeFontFetching;

    final isLight = brightness == Brightness.light;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: FlipperColors.seed,
      brightness: brightness,
      primary: FlipperColors.primary,
      secondary: FlipperColors.secondary,
      surface: isLight ? FlipperColors.surface : FlipperColors.surfaceDark,
    );

    final textTheme = allowRuntimeFontFetching
        ? GoogleFonts.outfitTextTheme(
            ThemeData(brightness: brightness).textTheme,
          )
        : ThemeData(brightness: brightness).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      textTheme: textTheme,
      primaryColor: FlipperColors.primary,
      colorScheme: colorScheme,
      extensions: [extension],
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? FlipperColors.surface : extension.background,
        foregroundColor: isLight ? Colors.black : Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
