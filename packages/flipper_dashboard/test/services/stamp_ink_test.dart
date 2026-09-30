import 'dart:typed_data';

import 'package:flipper_dashboard/services/stamp_ink.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

/// A phone photo of a stamp: grey paper, lit a little unevenly, with a blue
/// ring of ink in the middle.
Uint8List _photographedStamp({bool jpeg = false}) {
  final image = img.Image(width: 200, height: 200);
  for (final p in image) {
    final shade = 196 + (p.x + p.y) ~/ 40; // gentle light gradient
    final dx = p.x - 100;
    final dy = p.y - 100;
    final r2 = dx * dx + dy * dy;
    final onRing = r2 > 60 * 60 && r2 < 75 * 75;
    if (onRing) {
      p.setRgb(60, 70, 170);
    } else {
      p.setRgb(shade, shade, shade + 4);
    }
  }
  return jpeg ? img.encodeJpg(image, quality: 90) : img.encodePng(image);
}

img.Image _decode(Uint8List bytes) => img.decodePng(bytes)!;

void main() {
  test('paper becomes transparent and the ink stays blue', () {
    final out = _decode(inkifyStamp(_photographedStamp()));

    expect(out.numChannels, 4);
    for (final corner in [out.getPixel(2, 2), out.getPixel(197, 197)]) {
      expect(corner.a, 0);
    }
    final centre = out.getPixel(100, 100);
    expect(centre.a, 0, reason: 'the inside of the ring is paper too');

    final ink = out.getPixel(100 + 67, 100);
    expect(ink.a, greaterThan(200));
    expect(ink.b, greaterThan(ink.r + 60));
  });

  test('handles a JPEG photo', () {
    final out = _decode(inkifyStamp(_photographedStamp(jpeg: true)));
    expect(out.getPixel(2, 2).a, 0);
    expect(out.getPixel(167, 100).a, greaterThan(200));
  });

  test('a stamp that is already cut out is left alone', () {
    final clean = img.Image(width: 10, height: 10, numChannels: 4);
    clean.getPixel(5, 5).setRgba(0, 0, 255, 255);
    final bytes = img.encodePng(clean);

    expect(inkifyStamp(bytes), same(bytes));
  });

  test('bytes that are not an image come back unchanged', () {
    final junk = Uint8List.fromList([1, 2, 3, 4]);
    expect(inkifyStamp(junk), same(junk));
  });

  test('the same stamp is processed once', () {
    final bytes = _photographedStamp();
    final first = inkifyStamp(bytes);
    expect(inkifyStamp(Uint8List.fromList(bytes)), same(first));
  });
}
