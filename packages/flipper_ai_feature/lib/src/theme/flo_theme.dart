import 'package:flutter/material.dart';

/// Flo design tokens from Handover.html / assist.css
abstract final class FloTheme {
  static const ink1 = Color(0xFF0B1220);
  static const ink2 = Color(0xFF4A5567);
  static const ink3 = Color(0xFF7E8AA0);
  static const ink4 = Color(0xFFAEB8CA);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF3F6FB);
  static const chatBg = Color(0xFFFBFCFE);
  static const line = Color(0xFFE6ECF5);
  static const lineSoft = Color(0xFFEEF2F8);
  static const lineStrong = Color(0xFFD6DEEA);
  static const blue = Color(0xFF2563EB);
  static const blueDeep = Color(0xFF1D4ED8);
  static const blue700 = Color(0xFF1D4ED8);
  static const blueTint = Color(0xFFEAF1FE);
  static const blueTint2 = Color(0xFFD6E6FF);
  static const gain = Color(0xFF10B981);
  static const gainTint = Color(0xFFE6F7EF);
  static const gainInk = Color(0xFF047857);
  static const loss = Color(0xFFE5484D);
  static const lossTint = Color(0xFFFDECEC);
  static const lossInk = Color(0xFFB42318);
  static const warnBg = Color(0xFFFFF8EC);
  static const warnIco = Color(0xFFE08600);
  static const violet = Color(0xFF7C3AED);
  static const violetTint = Color(0xFFF1ECFB);
  static const xp = Color(0xFFFB9D00);
  static const xpTint = Color(0xFFFFF4E5);
  static const wa = Color(0xFF1EAE54);
  static const waDeep = Color(0xFF0E8A47);
  static const waTint = Color(0xFFE7F7EE);
  static const gradBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
  );
  static const gradBtn = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8)],
  );
  static const briefingGrad = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF4F8FF), Color(0xFFFFFFFF)],
    stops: [0.0, 0.46],
  );
  static const sh1 = BoxShadow(
    color: Color(0x0A0B1220),
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  static const sh2 = BoxShadow(
    color: Color(0x120B1220),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
  static const sh3 = BoxShadow(
    color: Color(0x180B1220),
    blurRadius: 32,
    offset: Offset(0, 12),
  );
  static const shBlue = BoxShadow(
    color: Color(0x402563EB),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
  static const markShadow = BoxShadow(
    color: Color(0x8C2563EB),
    blurRadius: 16,
    offset: Offset(0, 6),
    spreadRadius: -6,
  );
  static const radiusSm = 10.0;
  static const radiusMd = 14.0;
  static const radiusLg = 20.0;
  static const radiusXl = 26.0;
  static const radiusPill = 999.0;
  static const bubbleRadius = 20.0;
  static const contentMaxWidth = 760.0;
  static const mobileBreakpoint = 640.0;

  static TextStyle mono(num size, {FontWeight weight = FontWeight.w600}) {
    return TextStyle(
      fontSize: size.toDouble(),
      fontWeight: weight,
      fontFeatures: const [FontFeature.tabularFigures()],
      letterSpacing: -0.02,
    );
  }
}
