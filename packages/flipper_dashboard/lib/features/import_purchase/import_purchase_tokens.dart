import 'package:flutter/material.dart';

/// Design tokens from `assets/design_handoff_import_purchase/src/ipm.css` §3.
abstract final class ImportPurchaseTokens {
  static const accent = Color(0xFF2F6BFF);
  static const accentStrong = Color(0xFF1E5BE6);
  static const accentWash = Color(0xFFEAF0FF);

  static const green = Color(0xFF1F9D55);
  static const greenStrong = Color(0xFF178045);
  static const greenWash = Color(0xFFE7F6EE);

  static const red = Color(0xFFE5484D);
  static const redStrong = Color(0xFFD23A3F);
  static const redWash = Color(0xFFFDECEC);

  static const amber = Color(0xFF98690A);
  static const amberWash = Color(0xFFFFF3D6);
  static const amberDot = Color(0xFFE6A700);

  static const ink = Color(0xFF1A1F2E);
  static const ink2 = Color(0xFF545B6B);
  static const muted = Color(0xFF8A909C);
  static const faint = Color(0xFFB6BCC6);
  static const line = Color(0xFFECEDF1);
  static const line2 = Color(0xFFE2E5EC);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF7F8FB);
  static const surface3 = Color(0xFFEEF1F6);
  static const canvas = Color(0xFFF3F5F9);

  static const radiusLg = 18.0;
  static const radius = 14.0;
  static const radiusSm = 10.0;
  static const radiusXs = 8.0;

  static const fieldH = 46.0;
  static const gutterDesktop = 28.0;
  static const gutterMobile = 16.0;
  static const mobileBreakpoint = 880.0;
  static const modalSheetBreakpoint = 720.0;

  static const cardShadow = BoxShadow(
    color: Color(0x0D141E3C),
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  static const cardShadow2 = BoxShadow(
    color: Color(0x0A141E3C),
    blurRadius: 1,
    offset: Offset(0, 1),
  );

  static const modalShadow = BoxShadow(
    color: Color(0x6B0F172A),
    blurRadius: 60,
    offset: Offset(0, 24),
    spreadRadius: -12,
  );
  static const modalShadow2 = BoxShadow(
    color: Color(0x4D0F172A),
    blurRadius: 20,
    offset: Offset(0, 8),
    spreadRadius: -8,
  );

  static List<BoxShadow> get cardShadows => const [cardShadow, cardShadow2];
  static List<BoxShadow> get modalShadows => const [modalShadow, modalShadow2];

  static double gutter(double width) =>
      width <= mobileBreakpoint ? gutterMobile : gutterDesktop;
}
