import 'package:flutter/material.dart';

/// Tokens from `design_handoff_signin/` (+ shared onboarding `styles.css`).
abstract final class SignInTokens {
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF7F9FE);
  static const Color ink1 = Color(0xFF0B1220);
  static const Color ink2 = Color(0xFF4A5567);
  static const Color ink3 = Color(0xFF7E8AA0);
  static const Color line = Color(0xFFE6ECF5);
  static const Color blue = Color(0xFF2563EB);
  static const Color blueTint = Color(0xFFEAF1FE);
  static const Color blueTint2 = Color(0xFFDEEAFD);
  static const Color win = Color(0xFF10B981);
  static const Color winTint = Color(0xFFDEF7EC);
  static const Color danger = Color(0xFFC0392B);
  static const Color dangerTint = Color(0xFFFDF1EF);

  static const double radiusMd = 14;
  static const double formMaxWidth = 380;
  static const double desktopSplitBreakpoint = 920;
  static const int pinCellCount = 6;
  static const double pinCellHeight = 60;
  static const double pinCellHeightCompact = 56;

  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandPanelGradient = LinearGradient(
    begin: Alignment(0.7, -0.9),
    end: Alignment(-0.2, 1.2),
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8), Color(0xFF1E3A9E)],
    stops: [0.0, 0.46, 1.0],
  );
}
