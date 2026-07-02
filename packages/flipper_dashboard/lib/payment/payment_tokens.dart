import 'package:flutter/material.dart';

/// Design tokens from payment handover (HTML/CSS → Flutter).
/// Scoped to payment screens only — does not replace global FlipperColors.
abstract final class PaymentTokens {
  // Surfaces
  static const Color app = Color(0xFFF5F8FD);
  static const Color app2 = Color(0xFFEDF2FB);
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

  // Brand
  static const Color blue = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blueTint = Color(0xFFEAF1FE);
  static const Color blueTint2 = Color(0xFFDEEAFD);

  // Semantic
  static const Color loss = Color(0xFFDC2626);
  static const Color lossTint = Color(0xFFFCECEC);
  static const Color warnAmber = Color(0xFFB45309);
  static const Color warnTint = Color(0xFFFEF3E2);
  static const Color gain = Color(0xFF16A34A);
  static const Color gainInk = Color(0xFF15803D);
  static const Color gainTint = Color(0xFFE7F6EE);

  // Gradients
  static const LinearGradient gradBtn = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8)],
  );

  static const LinearGradient gradBrandSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE7FBFE),
      Color(0xFFEAF1FE),
      Color(0xFFEEECFE),
    ],
    stops: [0.0, 0.6, 1.0],
  );

  static RadialGradient screenBackground = RadialGradient(
    center: const Alignment(0, -0.88),
    radius: 1.2,
    colors: [
      Colors.white,
      app,
      app2,
    ],
    stops: const [0.0, 0.46, 1.0],
  );

  // Radii
  static const double rSm = 10;
  static const double rMd = 14;
  static const double rLg = 20;
  static const double rXl = 26;

  // Shadows
  static List<BoxShadow> get sh1 => [
        BoxShadow(
          color: const Color(0xFF102040).withValues(alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: const Color(0xFF102040).withValues(alpha: 0.04),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shBlue => [
        BoxShadow(
          color: blue.withValues(alpha: 0.45),
          blurRadius: 28,
          spreadRadius: -8,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: blue.withValues(alpha: 0.25),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];

  static const double blockGap = 16;
  static const EdgeInsets scrollPadding = EdgeInsets.fromLTRB(20, 4, 20, 26);
}
