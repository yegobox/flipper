import 'package:flutter/material.dart';

/// Design tokens from `assets/design_handoff_system_config_modal/README.md`.
abstract final class SystemConfigTokens {
  static const accent = Color(0xFF12B76A);
  static const accentStrong = Color(0xFF0A7A4D);
  static const ink = Color(0xFF0B2A20);
  static const secondary = Color(0xFF5E6F66);
  static const muted = Color(0xFF9DB0A6);
  static const switchOff = Color(0xFFD7DDD8);
  static const inputFill = Color(0xFFF4F8F5);
  static const vatSurface = Color(0xFFF7FAF8);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFEEF1EE);
  static const divider = Color(0xFFF1F4F1);
  static const inputBorder = Color(0xFFE6EAE6);
  static const scrim = Color.fromRGBO(8, 32, 26, 0.46);
  static const accentTint = Color.fromRGBO(18, 183, 106, 0.12);
  static const focusRing = Color.fromRGBO(18, 183, 106, 0.14);
  static const vatTrack = Color.fromRGBO(18, 183, 106, 0.4);

  static const cardRadius = 20.0;
  static const sectionRadius = 14.0;
  static const fieldRadius = 10.0;
  static const vatRadius = 12.0;
  static const buttonRadius = 12.0;
  static const iconRadius = 10.0;
  static const closeRadius = 9.0;

  static const cardMaxWidth = 740.0;
  static const cardPaddingH = 26.0;

  static const cardShadow = [
    BoxShadow(
      color: Color.fromRGBO(8, 32, 26, 0.34),
      blurRadius: 80,
      offset: Offset(0, 28),
    ),
    BoxShadow(
      color: Color.fromRGBO(8, 32, 26, 0.16),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
