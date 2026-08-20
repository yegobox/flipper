import 'package:flutter/material.dart';

/// The one palette Flipper HR's signed-in surfaces draw from.
///
/// Mirrors flipper_web's `AccountingTokens` so HR and Books read as the same
/// product. Lives here rather than inside the shell because pages need it too:
/// the paywall and the subscribe screen sit in the shell's workspace, and a page
/// that reaches for Material's defaults instead lands a slightly different white
/// on a slightly different grey.
///
/// Light only, on purpose — see the `themeMode` note in `main.dart`.
abstract final class HrTokens {
  static const Color workspaceBg = Color(0xFFF1F4FA);
  static const Color sidebarBg   = Color(0xFFFFFFFF);
  static const Color sidebarBg2  = Color(0xFFF7F9FE);
  static const Color border      = Color(0xFFE5E7EB);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surface2    = Color(0xFFF4F6FB);
  static const Color ink1        = Color(0xFF0B1220);
  static const Color ink2        = Color(0xFF4A5567);
  static const Color ink3        = Color(0xFF7E8AA0);
  static const Color ink4        = Color(0xFF9AA8BC);
  static const Color line        = Color(0xFFE6ECF5);
  static const Color accent      = Color(0xFF2563EB);
  static const Color accentTint  = Color(0xFFEAF1FE);
  static const Color danger      = Color(0xFFDC2626);
  static const Color dangerTint  = Color(0xFFFEF2F2);
  static const Color success     = Color(0xFF059669);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
    stops: [0, 0.52, 1],
  );

  static const double sidebarWidth = 240;
  static const double railWidth    = 68;
  static const double topbarHeight = 56;
  static const double radiusSm     = 10;
  static const double radiusMd     = 14;
  static const double radiusLg     = 18;

  /// One duration for every chrome transition, so the rail, its labels and the
  /// content edge all move together instead of arriving in three waves.
  static const Duration motion = Duration(milliseconds: 180);

  /// A panel: what a self-contained block of page content sits on.
  static BoxDecoration panel({Color? color}) => BoxDecoration(
    color: color ?? surface,
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: line),
  );
}
