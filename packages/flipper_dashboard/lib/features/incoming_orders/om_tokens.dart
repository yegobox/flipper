import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Orders Management tokens from design handoff (`ipm.css` / `orders-management.css`).
abstract final class OmTokens {
  static const Color accent = Color(0xFF2F6BFF);
  static const Color accentStrong = Color(0xFF1E5BE6);
  static const Color accentWash = Color(0xFFEAF0FF);

  static const Color green = Color(0xFF1F9D55);
  static const Color greenStrong = Color(0xFF178045);
  static const Color greenWash = Color(0xFFE7F6EE);

  static const Color red = Color(0xFFE5484D);
  static const Color redStrong = Color(0xFFD23A3F);
  static const Color redWash = Color(0xFFFDECEC);

  static const Color amber = Color(0xFF98690A);
  static const Color amberWash = Color(0xFFFFF3D6);
  static const Color amberDot = Color(0xFFE6A700);

  static const Color ink = Color(0xFF1A1F2E);
  static const Color ink2 = Color(0xFF545B6B);
  static const Color muted = Color(0xFF8A909C);
  static const Color faint = Color(0xFFB6BCC6);
  static const Color line = Color(0xFFECEDF1);
  static const Color line2 = Color(0xFFE2E5EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF7F8FB);
  static const Color surface3 = Color(0xFFEEF1F6);
  static const Color canvas = Color(0xFFF3F5F9);

  static const Color dateWash = Color(0xFFF1EBFD);
  static const Color dateIcon = Color(0xFF7C4FD1);

  static const double radiusLg = 18;
  static const double radius = 14;
  static const double radiusSm = 10;
  static const double radiusXs = 8;

  static const double maxContentWidth = 1120;
  static const double compactBreakpoint = 880;

  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: const Color(0xFF141E3C).withValues(alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: const Color(0xFF141E3C).withValues(alpha: 0.04),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ];

  /// Typography for this screen — uses bundled Outfit (same as FlipperTheme).
  /// Handoff specifies Inter; Inter is not in app assets and runtime fetch is disabled.
  static TextStyle text({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? ink,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
