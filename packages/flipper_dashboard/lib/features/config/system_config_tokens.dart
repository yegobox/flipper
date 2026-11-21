import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';

/// Design tokens from `assets/design_handoff_system_config_modal/README.md`,
/// on the POS palette ([PosTokens]): brand blue for actions and toggles, cool
/// neutrals for ink, surfaces and lines.
abstract final class SystemConfigTokens {
  static const accent = PosTokens.blue;
  static const accentStrong = Color(0xFF1D4ED8);
  static const ink = PosTokens.ink1;
  static const secondary = PosTokens.ink2;
  static const muted = PosTokens.ink3;
  static const switchOff = PosTokens.lineStrong;
  static const inputFill = PosTokens.surface2;
  static const vatSurface = PosTokens.surface2;
  static const surface = PosTokens.surface;
  static const border = PosTokens.line;
  static const divider = PosTokens.line;
  static const inputBorder = PosTokens.lineStrong;
  static const scrim = Color.fromRGBO(11, 18, 32, 0.46);
  static const accentTint = PosTokens.blueTint;
  static const focusRing = Color.fromRGBO(37, 99, 235, 0.14);
  static const vatTrack = Color.fromRGBO(37, 99, 235, 0.4);

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
      color: Color.fromRGBO(11, 18, 32, 0.34),
      blurRadius: 80,
      offset: Offset(0, 28),
    ),
    BoxShadow(
      color: Color.fromRGBO(11, 18, 32, 0.16),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
