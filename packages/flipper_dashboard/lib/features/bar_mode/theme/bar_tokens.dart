import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

/// Design tokens from Bar Mode HTML/CSS handover.
abstract final class BarTokens {
  // Canvas
  static const double canvasWidth = 1440;
  static const double canvasHeight = 912;
  static const Color stageBg = Color(0xFF0B0E17);
  static const Color adminPageBg = Color(0xFFF0F2F5);

  // Reuse POS tokens where identical
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
  static const Color blueTint2 = Color(0xFFDEEAFD);
  static const Color violet = Color(0xFF7C3AED);
  static const Color violetTint = Color(0xFFF3EEFB);
  static const Color win = Color(0xFF10B981);
  static const Color winTint = Color(0xFFDEF7EC);
  static const Color lossInk = PosTokens.lossInk;
  static const Color lossTint = Color(0xFFFDECEC);
  static const Color posBg = PosTokens.posBg;

  // Literals from handover
  static const Color toastBg = Color(0xFF10233F);
  static const Color toastCheck = Color(0xFF55E3A0);
  static const Color settleHoverFill = Color(0xFFFFFBEB);
  static const Color settleHoverBorder = Color(0xFFF0D9A6);
  static const Color dangerBorder = Color(0xFFF3C9C9);
  static const Color scrollbarThumb = Color(0xFFD4DCEA);

  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 26;

  static const LinearGradient gradBtn = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8)],
  );

  static const LinearGradient gradBrand = PosTokens.gradBrand;

  static const List<BoxShadow> shadow1 = PosTokens.shadow1;
  static const List<BoxShadow> shadow2 = PosTokens.shadow2;
  static const List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Color(0x33103240),
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: -8,
    ),
  ];

  static const Duration fadeIn = Duration(milliseconds: 340);
  static const Duration pinShake = Duration(milliseconds: 400);
}
