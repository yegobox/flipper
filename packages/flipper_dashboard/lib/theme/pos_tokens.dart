import 'dart:ui';

import 'package:flutter/material.dart';

/// Design tokens for the desktop register.
///
/// Colours come from [flipper/design_handoff_pos]; the size, radius and type
/// scales were tightened for a desktop-first, information-dense layout: calm
/// neutral surfaces, 6–10px radii, 40px controls and colour reserved for
/// semantic states (selected, low/out of stock, success, warning, error).
abstract final class PosTokens {
  // Surfaces
  static const Color posBg = Color(0xFFF4F6FB);
  static const Color posRail = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF7F9FE);

  // Ink
  static const Color ink1 = Color(0xFF0B1220);
  static const Color ink2 = Color(0xFF4A5567);
  static const Color ink3 = Color(0xFF7E8AA0);
  static const Color ink4 = Color(0xFFAEB8CA);

  // Lines
  static const Color line = Color(0xFFE6ECF5);
  static const Color lineStrong = Color(0xFFD6DEEA);

  // Brand / accent
  static const Color blue = Color(0xFF2563EB);
  static const Color blueTint = Color(0xFFEAF1FE);

  /// Avatar gradient ([design_handoff_pos/onboarding/styles.css] `--grad-brand`).
  static const LinearGradient gradBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
    stops: [0.0, 0.52, 1.0],
  );

  // Semantic
  static const Color gain = Color(0xFF16A34A);
  static const Color gainInk = Color(0xFF15803D);
  static const Color loss = Color(0xFFE5484D);
  static const Color lossInk = Color(0xFFB42318);
  static const Color lossTint = Color(0xFFFEE4E2);
  static const Color warnAmber = Color(0xFFE08600);
  static const Color warnTint = Color(0xFFFFF4E2);

  /// Neutral product thumb (no per-product colour; image wins when present).
  static const Color neutralThumb = surface2;
  static const Color neutralThumbInk = ink2;

  // Layout (desktop shell)
  static const double topBarHeight = 56;
  static const double sideMenuWidth = 56;

  /// Fixed cart column on a wide split; see
  /// [PosLayoutBreakpoints.cartColumnWidth].
  static const double cartPanelWidth = 460;
  static const double cartPanelMinWidth = 400;
  static const double cartPanelFraction = 0.36;

  static const double productThumbHeight = 56;
  static const double gridGap = 12;

  /// Minimum product tile width the catalog grid packs against.
  static const double productTileMinWidth = 168;

  // Radii: small controls / cards & fields / dialogs & panels.
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 10;

  /// Catalog card shape.
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(radiusMd),
  );

  // Control sizes
  static const double controlHeight = 40;
  static const double controlHeightSm = 32;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double searchFieldHeight = controlHeight;
  static const double scanButtonSize = controlHeight;
  static const double payButtonHeight = 52;
  static const double chipHeight = controlHeightSm;

  // Motion (ANIMATIONS.md)
  static const Duration hoverTransition = Duration(milliseconds: 120);
  static const Duration focusTransition = Duration(milliseconds: 150);
  static const Duration pressTransition = Duration(milliseconds: 100);
  static const double cardHoverLift = 2;
  static const double cardPressScale = 0.985;
  static const double buttonPressScale = 0.98;

  static const List<BoxShadow> shadow1 = [
    BoxShadow(color: Color(0x0D102040), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x0A102040), offset: Offset(0, 1), blurRadius: 1),
  ];

  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color(0x24103240),
      offset: Offset(0, 6),
      blurRadius: 18,
      spreadRadius: -6,
    ),
    BoxShadow(color: Color(0x0F103240), offset: Offset(0, 2), blurRadius: 6),
  ];

  // Type scale (desktop hierarchy)
  //   page title 20 · section 14/600 · body 13 · meta 11.5–12 · totals 24.
  static const TextStyle pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ink1,
    letterSpacing: -0.2,
    height: 1.2,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: ink1,
    height: 1.2,
  );
  static const TextStyle body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: ink1,
    height: 1.3,
  );
  static const TextStyle bodyStrong = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ink1,
    height: 1.3,
  );
  static const TextStyle meta = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    color: ink3,
    height: 1.3,
  );

  /// Uppercase section eyebrow ("PAYMENT", "INVOICE").
  static const TextStyle eyebrow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: ink3,
    letterSpacing: 0.4,
    height: 1.2,
  );

  static TextStyle posMonoStyle(
    TextTheme textTheme, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? ink1,
      fontFeatures: const [FontFeature.tabularFigures()],
      letterSpacing: -0.01,
    );
  }

  static TextStyle posPriceStyle(
    TextTheme textTheme, {
    double fontSize = 15,
    Color? color,
  }) {
    return posMonoStyle(
      textTheme,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color ?? ink1,
    );
  }

  /// Dominant amount (grand total).
  static TextStyle totalStyle(TextTheme textTheme, {Color? color}) =>
      posPriceStyle(textTheme, fontSize: 24, color: color);

  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.maybeOf(context)?.disableAnimations == true;
  }
}
