import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Turns a photographed company stamp into ink on a transparent background.
///
/// Branches upload a phone photo of their stamp, paper and all. Drawn as-is it
/// prints as a grey square on the page — pasted, not stamped. Keying the paper
/// out leaves only the ink, so the page shows through the stamp the way it
/// would under a real one.
///
/// Runs at render time rather than at upload, so stamps saved before this
/// existed are fixed without a re-upload, and the original photo stays in
/// Ditto to be re-processed if the tuning below ever changes.
///
/// Anything that will not decode comes back unchanged: a corrupt stamp must
/// not cost the branch its document.
Uint8List inkifyStamp(Uint8List bytes) {
  final cached = _last;
  if (cached != null && _sameBytes(cached.input, bytes)) return cached.output;

  Uint8List output;
  try {
    output = _inkify(bytes) ?? bytes;
  } catch (_) {
    output = bytes;
  }
  _last = (input: bytes, output: output);
  return output;
}

/// Every quotation re-renders the same stamp; one entry covers the branch.
({Uint8List input, Uint8List output})? _last;

/// Longest side kept. A stamp prints at most 60 mm wide, so this is still
/// ~500 dpi, and it bounds the per-pixel loop for large phone photos.
const int _maxSide = 1200;

/// Colour distance from the paper, as a fraction of the largest possible,
/// below which a pixel is paper and above which it is solid ink. Between the
/// two the alpha ramps, which keeps the stamp's edges soft instead of cut out.
const double _paperBelow = 0.10;
const double _inkAbove = 0.30;

Uint8List? _inkify(Uint8List bytes) {
  var image = img.decodeImage(bytes);
  if (image == null) return null;

  // Someone already cut the stamp out. Their edges beat ours.
  if (image.hasAlpha && _hasTransparency(image)) return null;

  // 16-bit and palette PNGs otherwise report channels outside 0–255.
  image = image.convert(format: img.Format.uint8, numChannels: 3);

  if (math.max(image.width, image.height) > _maxSide) {
    image = image.width >= image.height
        ? img.copyResize(image, width: _maxSide)
        : img.copyResize(image, height: _maxSide);
  }

  final paper = _PaperMap.of(image);
  final out = img.Image(
    width: image.width,
    height: image.height,
    numChannels: 4,
  );
  const maxDistance = 441.67295593; // sqrt(3) * 255

  for (final p in image) {
    final r = p.r.toDouble();
    final g = p.g.toDouble();
    final b = p.b.toDouble();
    final (pr, pg, pb) = paper.at(p.x, p.y);
    // Ink only ever takes light away, so a pixel brighter than the paper
    // around it is glare or grain, not ink.
    final dr = math.max(0.0, pr - r);
    final dg = math.max(0.0, pg - g);
    final db = math.max(0.0, pb - b);
    final distance = math.sqrt(dr * dr + dg * dg + db * db) / maxDistance;
    final a = _smoothstep(_paperBelow, _inkAbove, distance);
    if (a <= 0) {
      out.setPixelRgba(p.x, p.y, 0, 0, 0, 0);
      continue;
    }
    // Un-blend the paper out of the edge pixels, or the soft edge reads as a
    // grey halo rather than thinning ink.
    out.setPixelRgba(
      p.x,
      p.y,
      _unblend(r, pr, a),
      _unblend(g, pg, a),
      _unblend(b, pb, a),
      (a * 255).round(),
    );
  }
  return img.encodePng(out);
}

bool _hasTransparency(img.Image image) {
  final max = image.maxChannelValue;
  for (final p in image) {
    if (p.a < max) return true;
  }
  return false;
}

/// The paper colour across the photo, as a coarse grid.
///
/// Phone photos are never evenly lit — one corner is always in the shadow of
/// the phone — so a single paper colour leaves the darker corner printing as
/// grey grain. Each cell takes its bright end (paper outnumbers ink almost
/// everywhere, and ink is always darker), neighbouring cells are median-ed so a
/// cell that is all ink borrows from the paper around it, and pixels read the
/// grid bilinearly so no cell edges show.
class _PaperMap {
  _PaperMap._(this._cells, this._cols, this._rows, this._cellW, this._cellH);

  static const int _gridSide = 12;

  /// Brightness percentile taken as "paper" within a cell.
  static const double _paperPercentile = 0.8;

  factory _PaperMap.of(img.Image image) {
    final cols = math.min(_gridSide, image.width);
    final rows = math.min(_gridSide, image.height);
    final cellW = image.width / cols;
    final cellH = image.height / rows;
    final raw =
        List<(double, double, double)>.filled(cols * rows, (255, 255, 255));

    for (var cy = 0; cy < rows; cy++) {
      for (var cx = 0; cx < cols; cx++) {
        final x0 = (cx * cellW).floor();
        final x1 = ((cx + 1) * cellW).floor();
        final y0 = (cy * cellH).floor();
        final y1 = ((cy + 1) * cellH).floor();
        // Sampling a few hundred pixels per cell is plenty for a percentile.
        final step =
            math.max(1, math.sqrt((x1 - x0) * (y1 - y0) / 400).floor());
        final samples = <(double, num, num, num)>[];
        for (var y = y0; y < y1; y += step) {
          for (var x = x0; x < x1; x += step) {
            final p = image.getPixel(x, y);
            samples
                .add((0.299 * p.r + 0.587 * p.g + 0.114 * p.b, p.r, p.g, p.b));
          }
        }
        if (samples.isEmpty) continue;
        samples.sort((a, b) => a.$1.compareTo(b.$1));
        final pick = samples[((samples.length - 1) * _paperPercentile).round()];
        raw[cy * cols + cx] =
            (pick.$2.toDouble(), pick.$3.toDouble(), pick.$4.toDouble());
      }
    }

    // 3x3 median, per channel.
    final cells = List<(double, double, double)>.generate(cols * rows, (i) {
      final cx = i % cols;
      final cy = i ~/ cols;
      final rs = <double>[];
      final gs = <double>[];
      final bs = <double>[];
      for (var y = math.max(0, cy - 1); y <= math.min(rows - 1, cy + 1); y++) {
        for (var x = math.max(0, cx - 1);
            x <= math.min(cols - 1, cx + 1);
            x++) {
          final c = raw[y * cols + x];
          rs.add(c.$1);
          gs.add(c.$2);
          bs.add(c.$3);
        }
      }
      return (_median(rs), _median(gs), _median(bs));
    });
    return _PaperMap._(cells, cols, rows, cellW, cellH);
  }

  final List<(double, double, double)> _cells;
  final int _cols;
  final int _rows;
  final double _cellW;
  final double _cellH;

  (double, double, double) at(int x, int y) {
    final gx = ((x + 0.5) / _cellW - 0.5).clamp(0.0, _cols - 1.0);
    final gy = ((y + 0.5) / _cellH - 0.5).clamp(0.0, _rows - 1.0);
    final x0 = gx.floor();
    final y0 = gy.floor();
    final x1 = math.min(x0 + 1, _cols - 1);
    final y1 = math.min(y0 + 1, _rows - 1);
    final tx = gx - x0;
    final ty = gy - y0;
    final a = _cells[y0 * _cols + x0];
    final b = _cells[y0 * _cols + x1];
    final c = _cells[y1 * _cols + x0];
    final d = _cells[y1 * _cols + x1];
    double mix(double p, double q, double r, double s) =>
        (p * (1 - tx) + q * tx) * (1 - ty) + (r * (1 - tx) + s * tx) * ty;
    return (
      mix(a.$1, b.$1, c.$1, d.$1),
      mix(a.$2, b.$2, c.$2, d.$2),
      mix(a.$3, b.$3, c.$3, d.$3),
    );
  }
}

double _median(List<double> values) {
  values.sort();
  return values[values.length ~/ 2];
}

double _smoothstep(double edge0, double edge1, double x) {
  final t = ((x - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
  return t * t * (3 - 2 * t);
}

int _unblend(double observed, double paper, double alpha) =>
    ((observed - paper * (1 - alpha)) / alpha).round().clamp(0, 255);

bool _sameBytes(Uint8List a, Uint8List b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
