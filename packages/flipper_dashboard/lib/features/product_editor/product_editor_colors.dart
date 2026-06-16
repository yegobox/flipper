import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProductEditorHue {
  const ProductEditorHue({
    required this.name,
    required this.h,
    required this.s,
  });

  final String name;
  final double h;
  final double s;
}

const List<ProductEditorHue> productEditorHues = [
  ProductEditorHue(name: 'Red', h: 4, s: 78),
  ProductEditorHue(name: 'Orange', h: 24, s: 88),
  ProductEditorHue(name: 'Amber', h: 40, s: 92),
  ProductEditorHue(name: 'Green', h: 145, s: 58),
  ProductEditorHue(name: 'Teal', h: 178, s: 62),
  ProductEditorHue(name: 'Blue', h: 218, s: 84),
  ProductEditorHue(name: 'Indigo', h: 244, s: 62),
  ProductEditorHue(name: 'Violet', h: 270, s: 60),
  ProductEditorHue(name: 'Slate', h: 214, s: 18),
];

const List<double> _shadeLightness = [
  95,
  88,
  79,
  69,
  60,
  52,
  45,
  38,
  31,
  24,
];

List<Color> makeProductEditorShades(ProductEditorHue hue) {
  return List<Color>.generate(_shadeLightness.length, (i) {
    final l = _shadeLightness[i];
    final s = math.min(96, hue.s + (i < 2 ? -8 : 0));
    return _hslToColor(hue.h, s.toDouble(), l);
  });
}

Color _hslToColor(double h, double s, double l) {
  final sat = s / 100;
  final light = l / 100;
  final c = (1 - (2 * light - 1).abs()) * sat;
  final x = c * (1 - ((h / 60) % 2 - 1).abs());
  final m = light - c / 2;
  double r;
  double g;
  double b;
  if (h < 60) {
    r = c;
    g = x;
    b = 0;
  } else if (h < 120) {
    r = x;
    g = c;
    b = 0;
  } else if (h < 180) {
    r = 0;
    g = c;
    b = x;
  } else if (h < 240) {
    r = 0;
    g = x;
    b = c;
  } else if (h < 300) {
    r = x;
    g = 0;
    b = c;
  } else {
    r = c;
    g = 0;
    b = x;
  }
  return Color.fromARGB(
    255,
    ((r + m) * 255).round().clamp(0, 255),
    ((g + m) * 255).round().clamp(0, 255),
    ((b + m) * 255).round().clamp(0, 255),
  );
}

ProductEditorHue defaultProductEditorHue() => productEditorHues[5];
