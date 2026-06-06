import 'dart:ui' show FontFeature;

import 'package:flutter/cupertino.dart';

/// Font size scale (formerly in flipper_infra `size.dart`).
class FontSizes {
  static double get scale => 1;

  static double get s11 => 11 * scale;

  static double get s12 => 12 * scale;

  static double get s14 => 14 * scale;

  static double get s16 => 16 * scale;

  static double get s18 => 18 * scale;

  static double get s20 => 20 * scale;

  static double get s24 => 24 * scale;

  static double get s32 => 32 * scale;

  static double get s44 => 44 * scale;
}

/// Stacked-style text styles used across legacy screens.
const TextStyle heading1Style = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w400,
);

const TextStyle heading2Style = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w600,
);

const TextStyle heading3Style = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
);

const TextStyle headlineStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
);

const TextStyle bodyStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

const TextStyle subheadingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
);

const TextStyle captionStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

/// Monospace labels (amounts, IDs, codes) using platform fonts — no bundled TTFs.
abstract final class FlipperFonts {
  static const List<String> _monoFallback = <String>[
    'Menlo',
    'SF Mono',
    'Roboto Mono',
    'Courier New',
    'Courier',
    'monospace',
  ];

  static TextStyle mono({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    FontStyle? fontStyle,
    double? height,
    TextDecoration? decoration,
    List<FontFeature>? fontFeatures,
  }) {
    return TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: _monoFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
      height: height,
      decoration: decoration,
      fontFeatures: fontFeatures,
    );
  }
}
