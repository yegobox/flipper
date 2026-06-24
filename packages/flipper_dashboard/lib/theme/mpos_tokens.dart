import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

/// Mobile POS tokens from [flipper/.windsurf/design_handoff_mobile_pos/mpos/mpos.css].
abstract final class MposTokens {
  static const Color bg = PosTokens.posBg;
  static const Color head = Color(0xFFFFFFFF);
  static const Color gain = Color(0xFF16A34A);
  static const Color gainInk = Color(0xFF15803D);
  static const Color gainTint = Color(0xFFE7F6EE);
  static const Color loss = PosTokens.loss;
  static const Color lossInk = PosTokens.lossInk;
  static const Color lossTint = Color(0xFFFDECEC);
  static const Color warnAmber = Color(0xFFB7791F);
  static const Color warnTint = Color(0xFFFBF1DC);
  static const Color pend = Color(0xFFD97706);
  static const Color pendTint = Color(0xFFFCEFD6);

  static const double radiusLg = 20;
  static const double radiusMd = PosTokens.radiusMd;
  static const double checkoutPrimaryHeight = 56;
  static const double cartBarHeight = 60;
  static const double sheetRadius = 26;

  static const LinearGradient gradBtn = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8)],
  );

  static const LinearGradient gradPayReady = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1FB36B), Color(0xFF16A34A)],
  );

  static const List<BoxShadow> shadowBlue = [
    BoxShadow(
      color: Color(0x732563EB),
      offset: Offset(0, 12),
      blurRadius: 28,
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Color(0x402563EB),
      offset: Offset(0, 3),
      blurRadius: 8,
    ),
  ];

  static const List<BoxShadow> shadowPayReady = [
    BoxShadow(
      color: Color(0x7316A34A),
      offset: Offset(0, 12),
      blurRadius: 28,
      spreadRadius: -8,
    ),
  ];

  static const Duration sheetSlide = Duration(milliseconds: 320);
  static const Duration scrimFade = Duration(milliseconds: 200);
  static const Curve sheetCurve = Curves.easeOutCubic;
}
