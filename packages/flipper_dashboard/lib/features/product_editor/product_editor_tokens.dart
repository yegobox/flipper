import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';

/// Layout + style tokens from design handoff `pe.css` / `base.css`.
abstract final class ProductEditorTokens {
  static const Color bg = Color(0xFFEEF2F9);
  static const Color app = Color(0xFFF5F8FD);
  static const Color violet = Color(0xFF7C3AED);
  static const Color violetTint = Color(0xFFF3EEFB);
  static const Color winTint = Color(0xFFE7F6EE);
  static const Color lineSoft = Color(0xFFEFF3F9);

  static const double topBarHeight = 68;
  static const double footerHeight = 76;
  static const double navWidth = 232;
  static const double sheetMaxWidth = 760;
  static const double sectionGap = 34;
  static const double fieldHeight = 50;
  static const double radiusLg = 20;
  static const double radiusXl = 26;

  static const double breakpointNav = 860;
  static const double breakpointStack = 560;

  static const LinearGradient gradBtn = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8)],
  );

  static const LinearGradient gradBrand = PosTokens.gradBrand;

  // Re-export shared ink/surface tokens.
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
  static const Color gain = PosTokens.gain;
  static const Color loss = PosTokens.loss;
}
