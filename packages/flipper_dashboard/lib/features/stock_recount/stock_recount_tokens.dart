import 'package:flutter/material.dart';

/// Design tokens from stock-recount-flutter-handover.md §1.
abstract final class StockRecountTokens {
  static const accent = Color(0xFF2563EB);
  static const accentDeep = Color(0xFF1D4ED8);
  static const accentTint = Color(0xFFEAF1FE);
  static const accentTint2 = Color(0xFFDEEAFD);
  static const ink1 = Color(0xFF0B1220);
  static const ink2 = Color(0xFF4A5567);
  static const ink3 = Color(0xFF7E8AA0);
  static const ink4 = Color(0xFFAEB8CA);
  static const line = Color(0xFFE6ECF5);
  static const lineSoft = Color(0xFFEFF3F9);
  static const lineStrong = Color(0xFFD6DEEA);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF7F9FE);
  static const appBg = Color(0xFFF5F8FD);
  static const appBgDeep = Color(0xFFEEF2F9);

  /// `--grad-brand` from onboarding/styles.css
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
    stops: [0.0, 0.52, 1.0],
  );

  static const accentRing = Color(0x382563EB);

  /// `.rc-item.is-short` border
  static const shortItemBorder = Color(0xFFF3C9C9);
  static const pos = Color(0xFF10B981);
  static const posText = Color(0xFF047857);
  static const posTint = Color(0xFFE6F8F0);
  static const posBorder = Color(0xFFBBEAD4);
  static const neg = Color(0xFFEF4444);
  static const negText = Color(0xFFB91C1C);
  static const negTint = Color(0xFFFDECEC);
  static const negBorder = Color(0xFFF6C9C9);

  static const radiusSm = 10.0;
  static const radiusMd = 14.0;
  static const radiusLg = 20.0;
  static const radiusXl = 26.0;
  static const radiusPill = 999.0;

  static const maxContentWidth = 940.0;
  static const narrowBreakpoint = 560.0;
  static const actionBarHideSummaryBreakpoint = 380.0;

  static const cardShadows = <BoxShadow>[
    BoxShadow(color: Color(0x10102040), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x08102040), blurRadius: 1, offset: Offset(0, 1)),
  ];

  static const primaryButtonShadow = BoxShadow(
    color: Color(0x732563EB),
    blurRadius: 28,
    offset: Offset(0, 12),
    spreadRadius: -8,
  );

  static Color statusBg(String status) => switch (status) {
    'draft' => const Color(0xFFFEF3C7),
    'submitted' => const Color(0xFFDBEAFE),
    'synced' => const Color(0xFFD1FAE5),
    _ => surface2,
  };

  static Color statusText(String status) => switch (status) {
    'draft' => const Color(0xFFB45309),
    'submitted' => accent,
    'synced' => posText,
    _ => ink3,
  };

  static Color statusBgCss(String status) => switch (status) {
    'draft' => const Color(0xFFFEF3C7),
    'submitted' => accentTint2,
    'synced' => const Color(0xFFDEF7EC),
    _ => surface2,
  };

  static Decoration appBackgroundDecoration() => const BoxDecoration(
    gradient: RadialGradient(
      center: Alignment(0, -0.35),
      radius: 1.4,
      colors: [Color(0xFFFFFFFF), appBg, appBgDeep],
      stops: [0.0, 0.55, 1.0],
    ),
  );

  static const swatchPalette = <Color>[
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFF0EA5A4),
    Color(0xFFE0529C),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF6366F1),
    Color(0xFFEF6C3B),
  ];
}
