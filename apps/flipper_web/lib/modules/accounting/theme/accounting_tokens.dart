import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AccountingTokens {
  static const Color workspaceBg = Color(0xFFF1F4FA);
  /// Light rail — matches [EnhancedSideMenu] / PosTokens.surface.
  static const Color sidebarBg = Color(0xFFFFFFFF);
  static const Color sidebarBg2 = Color(0xFFF7F9FE);
  static const Color sidebarBorder = Color(0xFFE5E7EB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF4F6FB);
  static const Color ink1 = Color(0xFF0B1220);
  static const Color ink2 = Color(0xFF4A5567);
  static const Color ink3 = Color(0xFF7E8AA0);
  static const Color ink4 = Color(0xFF9AA8BC);
  static const Color line = Color(0xFFE6ECF5);
  static const Color lineStrong = Color(0xFFD1D5DB);
  static const Color accent = Color(0xFF2563EB);
  static const Color accentTint = Color(0xFFEAF1FE);
  static const Color gain = Color(0xFF16A34A);
  static const Color gainInk = Color(0xFF15803D);
  static const Color gainTint = Color(0xFFE7F6EE);
  static const Color loss = Color(0xFFDC2626);
  static const Color lossInk = Color(0xFFB42318);
  static const Color lossTint = Color(0xFFFCECEC);
  static const Color warnAmber = Color(0xFFB45309);
  static const Color warnTint = Color(0xFFFEF3E2);
  static const Color drInk = Color(0xFF1D4ED8);
  static const Color crInk = Color(0xFF0F766E);
  static const Color violet = Color(0xFF7C3AED);
  static const Color navMuted = Color(0xFF5E6E8C);

  static const double sidebarWidth = 248;
  static const double topbarHeight = 60;
  static const double contentMaxWidth = 1080;
  static const double composerWidth = 720;
  static const double radiusLg = 20;
  static const double radiusMd = 14;
  static const double radiusSm = 10;

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
    stops: [0, 0.52, 1],
  );

  static TextStyle sans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color color = ink1,
    double? letterSpacing,
    double? height,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontStyle: fontStyle,
    );
  }

  static TextStyle mono({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color color = ink1,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: -0.01 * fontSize,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle pageH1 = sans(fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -0.025 * 27);
  static TextStyle eyebrow = sans(fontSize: 11, fontWeight: FontWeight.w700, color: ink3, letterSpacing: 0.08 * 11);
  static TextStyle cardTitle = sans(fontSize: 15.5, fontWeight: FontWeight.w700);
  static TextStyle tableHead = sans(fontSize: 11, fontWeight: FontWeight.w700, color: ink3, letterSpacing: 0.05 * 11);
  static TextStyle kpiValue = mono(fontSize: 26, fontWeight: FontWeight.w700);
}
