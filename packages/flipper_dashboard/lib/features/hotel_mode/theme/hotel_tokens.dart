import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

/// Design tokens for Hotel Mode.
///
/// Inherits the shared Flipper design-system scale ([PosTokens]) so the front
/// desk sits in the same visual language as POS and Bar Mode; only the
/// room-state palette is specific to this module.
abstract final class HotelTokens {
  // Canvas — the front desk handover is drawn on the same 1440×912 stage
  // as Bar Mode, so the host can scale it the same way.
  static const double canvasWidth = 1440;
  static const double canvasHeight = 912;

  static const Color stageBg = Color(0xFF0B0E17);
  static const Color bg = Color(0xFFEEF2F9);
  static const Color surface = PosTokens.surface;
  static const Color surface2 = PosTokens.surface2;
  static const Color ink1 = PosTokens.ink1;
  static const Color ink2 = PosTokens.ink2;
  static const Color ink3 = PosTokens.ink3;
  static const Color ink4 = PosTokens.ink4;
  static const Color line = PosTokens.line;
  static const Color lineStrong = PosTokens.lineStrong;
  static const Color blue = PosTokens.blue;
  static const Color blueTint = PosTokens.blueTint;
  static const Color posBg = PosTokens.posBg;
  static const Color lossInk = PosTokens.lossInk;

  // Room-state palette — one ink + one tint per [HotelRoomState].
  static const Color vacantInk = Color(0xFF10B981);
  static const Color vacantTint = Color(0xFFDEF7EC);
  static const Color occupiedInk = Color(0xFF2C6BF0);
  static const Color occupiedTint = Color(0xFFDEEAFD);
  static const Color reservedInk = Color(0xFF7C3AED);
  static const Color reservedTint = Color(0xFFF3EEFB);
  static const Color dirtyInk = Color(0xFFE08600);
  static const Color dirtyTint = Color(0xFFFDF3E2);
  static const Color blockedInk = Color(0xFF8A94A6);
  static const Color blockedTint = Color(0xFFEDF0F5);

  static const Color dangerBorder = Color(0xFFF3C9C9);
  static const Color toastBg = Color(0xFF10233F);
  static const Color toastCheck = Color(0xFF55E3A0);

  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 26;

  static const LinearGradient gradBtn = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8)],
  );

  static const List<BoxShadow> shadow1 = PosTokens.shadow1;
  static const List<BoxShadow> shadow2 = PosTokens.shadow2;

  static const Duration fadeIn = Duration(milliseconds: 340);

  // Mobile handover reference sizes (402×874 canvas).
  static const double mobileCanvasWidth = 402;
  static const double mobileCanvasHeight = 874;
  static const double mobilePrimaryButtonHeight = 52;
  static const double mobileSheetRadius = 26;
  static const double mobileRoomCardMinHeight = 118;
}
