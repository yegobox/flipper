import 'package:flutter/material.dart';

/// Canonical Flipper brand and semantic colors.
abstract final class FlipperColors {
  static const Color primary = Color(0xFF00C2E8);
  static const Color seed = primary;
  static const Color secondary = Color(0xFF1D1D1D);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A202C);
  static const Color onSurface = Color(0xFF333333);
  static const Color onSurfaceDark = Color(0xFFBBC3CD);

  static const Color mediumGrey = Color(0xFF868686);
  static const Color lightGrey = Color(0xFFE5E5E5);
  static const Color veryLightGrey = Color(0xFFF2F2F2);

  static const Color success = Color(0xFF66CF80);
  static const Color warning = Color(0xFFFFD667);
  static const Color error = Color(0xFFFB006D);

  static const Color border = Color(0xFFEDEDEE);
  static const Color borderDark = Color(0xFF3A3F49);

}

/// @deprecated Use [FlipperColors.primary].
const Color kcPrimaryColor = FlipperColors.primary;

/// @deprecated Use [FlipperColors.mediumGrey].
const Color kcMediumGreyColor = FlipperColors.mediumGrey;

/// @deprecated Use [FlipperColors.lightGrey].
const Color kcLightGreyColor = FlipperColors.lightGrey;

/// @deprecated Use [FlipperColors.veryLightGrey].
const Color kcVeryLightGreyColor = FlipperColors.veryLightGrey;
