// Rebuilds the launcher-icon source variants in assets/icon/ from the single
// master artwork in assets/hr_logo_transparent.png.
//
// Usage, from apps/flipper_hr:
//
//   dart run tool/gen_app_icons.dart
//   dart run flutter_launcher_icons
//   dart run tool/gen_app_icons.dart --maskable-only
//
// The third step is required: flutter_launcher_icons writes the maskable web
// icons as plain copies of the standard icon, which ignores the PWA maskable
// safe zone, so it undoes what the first step produced.
//
// Why the variants exist at all -- the source artwork is the HR mark drawn in a
// blue-to-teal gradient on a transparent canvas with wide margins, but:
//   * a launcher/PWA icon must be opaque, or Android and iOS plate it with an
//     arbitrary black or white square;
//   * the source's margins waste ~40% of the canvas, so a straight resize
//     produces a mark that is unreadable at favicon size;
//   * maskable art must survive a circle crop of the inner 80%, and this mark's
//     ink reaches its own bounding-box corners, so it needs its own render.
//
// The plate inverts the source: the brand gradient becomes the background and
// the mark is knocked out in white. That is the same structure as eduAi's icon
// (gradient plate + white glyph) and it keeps the mark legible at 16px, which a
// gradient-on-white mark does not.
//
// Unlike eduAi there are no iOS, macOS or Android adaptive variants here: HR
// ships web-only (there is no ios/, macos/ or android/ directory in this app).
// If a native target is ever added, port those branches from
// eduAi/tool/gen_app_icons.dart rather than reinventing them.

import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const srcPath = 'assets/hr_logo_transparent.png';
const outDir = 'assets/icon';
const webIconDir = 'web/icons';
const maskablePath = '$outDir/hr_icon_maskable_1024.png';

/// Output canvas for every generated master.
const size = 1024;

/// Fraction of the canvas the mark's longer bounding-box edge fills on the
/// standard (non-maskable) icon. Leaves a margin that survives the rounded-rect
/// and superellipse masks launchers apply to a plain icon.
const standardFill = 0.72;

/// PWA maskable safe zone: a circle over the inner 80% of the canvas. The mark
/// is fitted by its *enclosing circle*, not its bounding box -- the H's top-left
/// and the R's bottom-right leg sit at the bbox corners, so a box-fit would push
/// them outside the circle and the crop would clip them off.
const maskableSafe = 0.80;

void main(List<String> args) {
  if (args.contains('--maskable-only')) {
    writeWebMaskables(maskablePath, webIconDir);
    return;
  }

  Directory(outDir).createSync(recursive: true);
  final src = img.decodePng(File(srcPath).readAsBytesSync())!;
  final w = src.width, h = src.height;

  // --- 1. The mark is pure alpha coverage. Read nothing but the alpha channel:
  // the source stores magenta (254, 4, 243) in its fully transparent pixels, and
  // any interpolation that touches those RGB values fringes the edges pink.
  var minX = w, minY = h, maxX = -1, maxY = -1;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (src.getPixel(x, y).a <= 24) continue;
      minX = math.min(minX, x);
      maxX = math.max(maxX, x);
      minY = math.min(minY, y);
      maxY = math.max(maxY, y);
    }
  }
  stdout.writeln('mark bounds ($minX,$minY)-($maxX,$maxY) in ${w}x$h');

  // --- 2. Fit the brand gradient as a plane per channel: c = a0 + a1*u + a2*v,
  // with u = x/(w-1) and v = y/(h-1), sampled over the fully opaque pixels. The
  // source gradient is linear, so a plane recovers both its direction and its
  // endpoint colours.
  final fitR = fitPlane(src, 0), fitG = fitPlane(src, 1), fitB = fitPlane(src, 2);
  double clamp255(double v) => v < 0 ? 0 : (v > 255 ? 255 : v);
  List<double> planeAt(double u, double v) => [
        clamp255(fitR[0] + fitR[1] * u + fitR[2] * v),
        clamp255(fitG[0] + fitG[1] * u + fitG[2] * v),
        clamp255(fitB[0] + fitB[1] * u + fitB[2] * v),
      ];

  // The gradient axis, normalised. dv is about a tenth of du here: the brand
  // gradient runs left-to-right with a slight downward tilt, not at 45 degrees.
  final du = fitG[1], dv = fitG[2];
  final axisLen = math.sqrt(du * du + dv * dv);
  final ax = du / axisLen, ay = dv / axisLen;

  // Evaluate the endpoints at the mark's *own* extent along that axis rather
  // than at the canvas corners. Extrapolating the fit across the empty margins
  // runs the colours past anything in the source artwork -- the teal end turns
  // acid green. Clamping to the observed range keeps the plate on-brand.
  double proj(int x, int y) => ax * (x / (w - 1)) + ay * (y / (h - 1));
  var pMin = double.infinity, pMax = -double.infinity;
  for (var y = minY; y <= maxY; y++) {
    for (var x = minX; x <= maxX; x++) {
      if (src.getPixel(x, y).a < 250) continue;
      final p = proj(x, y);
      pMin = math.min(pMin, p);
      pMax = math.max(pMax, p);
    }
  }
  // Recover a (u, v) on the axis for each end, then read the plane there.
  final startColour = planeAt(ax * pMin, ay * pMin);
  final endColour = planeAt(ax * pMax, ay * pMax);
  String hex(List<double> c) =>
      '#${c.map((v) => v.round().toRadixString(16).padLeft(2, '0')).join()}';
  stdout.writeln('gradient axis (${ax.toStringAsFixed(3)}, ${ay.toStringAsFixed(3)})  '
      '${hex(startColour)} -> ${hex(endColour)}');

  /// Full-bleed plate: the brand gradient swept across the canvas along the
  /// axis measured above, between the two observed endpoint colours.
  img.Image plate(int s) {
    final out = img.Image(width: s, height: s, numChannels: 4);
    // Projection range of the canvas corners onto the axis, so the sweep spans
    // the whole plate exactly once.
    final lo = math.min(0.0, ax) + math.min(0.0, ay);
    final hi = math.max(0.0, ax) + math.max(0.0, ay);
    for (var y = 0; y < s; y++) {
      for (var x = 0; x < s; x++) {
        final t = ((ax * (x / (s - 1)) + ay * (y / (s - 1))) - lo) / (hi - lo);
        out.setPixelRgba(
          x,
          y,
          (startColour[0] + (endColour[0] - startColour[0]) * t).round(),
          (startColour[1] + (endColour[1] - startColour[1]) * t).round(),
          (startColour[2] + (endColour[2] - startColour[2]) * t).round(),
          255,
        );
      }
    }
    return out;
  }

  // --- 3. The mark as a white knockout: white everywhere, alpha from the source.
  final markW = maxX - minX + 1, markH = maxY - minY + 1;
  final white = img.Image(width: markW, height: markH, numChannels: 4);
  for (var y = 0; y < markH; y++) {
    for (var x = 0; x < markW; x++) {
      white.setPixelRgba(x, y, 255, 255, 255, src.getPixel(minX + x, minY + y).a.toInt());
    }
  }

  // The mark's enclosing radius about its own centre, needed for the maskable
  // fit. It comes out near the bbox half-diagonal, which is exactly why the
  // maskable render cannot just reuse the standard one.
  final cx = (markW - 1) / 2, cy = (markH - 1) / 2;
  var maxR = 0.0;
  for (var y = 0; y < markH; y++) {
    for (var x = 0; x < markW; x++) {
      if (white.getPixel(x, y).a <= 24) continue;
      final r = math.sqrt(math.pow(x - cx, 2) + math.pow(y - cy, 2));
      if (r > maxR) maxR = r;
    }
  }
  stdout.writeln('mark ${markW}x$markH, enclosing radius ${maxR.toStringAsFixed(1)}px');

  /// Plate with the white mark composited at [scale], centred.
  img.Image compose(double scale) {
    final mark = img.copyResize(
      white,
      width: math.max(1, (markW * scale).round()),
      height: math.max(1, (markH * scale).round()),
      interpolation: img.Interpolation.cubic,
    );
    final out = plate(size);
    img.compositeImage(out, mark,
        dstX: (size - mark.width) ~/ 2, dstY: (size - mark.height) ~/ 2);
    return out;
  }

  // Standard master: bounding-box fit, since a plain icon is masked to a rounded
  // rect rather than a circle.
  final standardScale = size * standardFill / math.max(markW, markH);
  File('$outDir/hr_icon_master_1024.png')
      .writeAsBytesSync(img.encodePng(compose(standardScale)));

  // Maskable master: enclosing-circle fit inside the 80% safe zone.
  final maskableScale = (size * maskableSafe / 2) / maxR;
  stdout.writeln('scale standard ${standardScale.toStringAsFixed(3)}, '
      'maskable ${maskableScale.toStringAsFixed(3)}');
  File(maskablePath).writeAsBytesSync(img.encodePng(compose(maskableScale)));

  // --- 4. Splash mark for web/index.html: the trimmed mark on transparency, in
  // its original gradient. The HTML splash paints it on the app's white
  // background before Flutter boots, so there it is the mark, not the plate,
  // that has to match what the signed-in shell shows.
  final trimmed = img.copyCrop(src, x: minX, y: minY, width: markW, height: markH);
  // Neutralise the magenta the source hides under its transparent pixels, so a
  // downscale cannot pull it into the mark's antialiased edge.
  for (var y = 0; y < markH; y++) {
    for (var x = 0; x < markW; x++) {
      final p = trimmed.getPixel(x, y);
      if (p.a < 250) {
        final n = nearestOpaque(trimmed, x, y);
        trimmed.setPixelRgba(x, y, n[0], n[1], n[2], p.a.toInt());
      }
    }
  }
  const splashW = 512;
  final splash = img.copyResize(trimmed,
      width: splashW,
      height: (markH * splashW / markW).round(),
      interpolation: img.Interpolation.cubic);
  File('web/splash_logo.png').writeAsBytesSync(img.encodePng(splash));

  stdout.writeln('wrote 2 files to $outDir and web/splash_logo.png');

  writeWebMaskables(maskablePath, webIconDir);
}

/// Colour of the closest opaque-enough pixel, searched in a small ring. Used to
/// replace the source's magenta in its transparent pixels with the mark's own
/// edge colour, which is what a correct un-premultiplied PNG would have stored.
List<int> nearestOpaque(img.Image im, int x, int y) {
  for (var r = 1; r <= 4; r++) {
    for (var dy = -r; dy <= r; dy++) {
      for (var dx = -r; dx <= r; dx++) {
        final nx = x + dx, ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= im.width || ny >= im.height) continue;
        final p = im.getPixel(nx, ny);
        if (p.a >= 250) return [p.r.toInt(), p.g.toInt(), p.b.toInt()];
      }
    }
  }
  return [0, 122, 193]; // mid-gradient, for a pixel with no opaque neighbour
}

/// Least-squares fit of one channel as c = a0 + a1*u + a2*v over the fully
/// opaque pixels, with u = x/(w-1) and v = y/(h-1).
List<double> fitPlane(img.Image src, int channel) {
  final w = src.width, h = src.height;
  final m = List.generate(3, (_) => List<double>.filled(4, 0));
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final p = src.getPixel(x, y);
      if (p.a < 250) continue;
      final basis = [1.0, x / (w - 1), y / (h - 1)];
      final c = [p.r, p.g, p.b][channel].toDouble();
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          m[i][j] += basis[i] * basis[j];
        }
        m[i][3] += basis[i] * c;
      }
    }
  }
  // Gaussian elimination with partial pivoting.
  for (var i = 0; i < 3; i++) {
    var pivot = i;
    for (var k = i + 1; k < 3; k++) {
      if (m[k][i].abs() > m[pivot][i].abs()) pivot = k;
    }
    final swap = m[i];
    m[i] = m[pivot];
    m[pivot] = swap;
    for (var k = i + 1; k < 3; k++) {
      final f = m[k][i] / m[i][i];
      for (var j = i; j < 4; j++) {
        m[k][j] -= f * m[i][j];
      }
    }
  }
  final out = List<double>.filled(3, 0);
  for (var i = 2; i >= 0; i--) {
    var acc = m[i][3];
    for (var j = i + 1; j < 3; j++) {
      acc -= m[i][j] * out[j];
    }
    out[i] = acc / m[i][i];
  }
  return out;
}

/// flutter_launcher_icons emits the maskable web icons as plain copies of the
/// standard icon; overwrite them with the safe-zone-fitted render.
void writeWebMaskables(String masterPath, String webIconDir) {
  final master = img.decodePng(File(masterPath).readAsBytesSync())!;
  for (final size in [192, 512]) {
    final out = img.copyResize(master,
        width: size, height: size, interpolation: img.Interpolation.cubic);
    File('$webIconDir/Icon-maskable-$size.png').writeAsBytesSync(img.encodePng(out));
    stdout.writeln('wrote $webIconDir/Icon-maskable-$size.png');
  }
}
