import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:qr/qr.dart';

/// Horizontal alignment for [EscPos] text and images.
enum EscPosAlign { left, center, right }

/// How the receipt QR code is drawn.
///
/// [raster] sends the code as a 1-bit bitmap at a whole number of dots per
/// module: pixel-exact and understood by every ESC/POS printer. [native] sends
/// `GS ( k` and lets the printer draw it, which many 58 mm clone firmwares
/// silently ignore — so it is opt-in, after a test print shows it works.
enum EscPosQrMode { raster, native }

/// Builds a raw ESC/POS byte stream for a 58 mm thermal printer.
///
/// Text uses the printer's own fonts (crisp at any speed); images are 1-bit
/// rasters sent with `GS v 0`. Only the small command subset every 58 mm
/// printer understands is used.
class EscPos {
  EscPos({this.dotsPerLine = 384, this.columns = 32});

  /// Printable width: 384 dots = 48 mm at 203 dpi.
  final int dotsPerLine;

  /// Characters per line in Font A (12×24 dots).
  final int columns;

  final BytesBuilder _out = BytesBuilder(copy: false);

  static const int _esc = 0x1B;
  static const int _gs = 0x1D;
  static const int _lf = 0x0A;

  /// `ESC t 2`: code page PC850 (Multilingual Latin I), where most printers
  /// put é/è/à/ç. Characters outside it are transliterated or replaced.
  static const int _codePagePc850 = 2;

  /// The bytes built so far.
  Uint8List bytes() => _out.toBytes();

  /// `ESC @` then PC850: clears any style left over from a previous job.
  void init() {
    _out.add([_esc, 0x40, _esc, 0x74, _codePagePc850]);
  }

  void align(EscPosAlign a) => _out.add([_esc, 0x61, a.index]);

  void bold(bool on) => _out.add([_esc, 0x45, on ? 1 : 0]);

  /// `GS !`: character size multipliers, 1–8 each way.
  void size({int width = 1, int height = 1}) {
    final w = (width.clamp(1, 8) - 1) << 4;
    final h = height.clamp(1, 8) - 1;
    _out.add([_gs, 0x21, w | h]);
  }

  /// Prints [text] on its own line(s) with the given style, then resets the
  /// style so it never leaks into the next line.
  void text(
    String text, {
    EscPosAlign align = EscPosAlign.left,
    bool bold = false,
    int width = 1,
    int height = 1,
  }) {
    this.align(align);
    if (bold) this.bold(true);
    if (width != 1 || height != 1) size(width: width, height: height);
    _out.add(encodeText(text));
    _out.addByte(_lf);
    if (width != 1 || height != 1) size();
    if (bold) this.bold(false);
    if (align != EscPosAlign.left) this.align(EscPosAlign.left);
  }

  /// [left] and [right] on one line, right flush to the edge. When both do
  /// not fit, [left] wraps above and [right] stays right-aligned below.
  void row(String left, String right, {bool bold = false}) {
    for (final line in layoutRow(left, right, columns)) {
      text(line, bold: bold);
    }
  }

  /// Long text wrapped at word boundaries to [columns].
  void wrapped(
    String text, {
    EscPosAlign align = EscPosAlign.left,
    bool bold = false,
  }) {
    for (final line in wrap(text, columns)) {
      this.text(line, align: align, bold: bold);
    }
  }

  /// A full-width dashed rule.
  void rule() => text('-' * columns);

  void feed([int lines = 1]) => _out.add([_esc, 0x64, lines.clamp(0, 255)]);

  /// Feeds past the tear bar, then `GS V 66 0` (feed-and-cut). Built-in 58 mm
  /// printers mostly have no cutter and ignore the cut, so the feed is what
  /// makes the last line tearable.
  void cut({int feedLines = 4}) {
    feed(feedLines);
    _out.add([_gs, 0x56, 0x42, 0x00]);
  }

  /// A 1-bit image centred on the line, sent in bands of [bandHeight] rows so
  /// a slow printer with a small buffer is not handed one huge command.
  void image(MonoBitmap source, {int bandHeight = 24}) {
    // Centred by padding to the full line rather than with ESC a, which some
    // firmwares ignore for raster images.
    final bitmap = source.width < dotsPerLine
        ? source.centredIn(dotsPerLine)
        : source;
    final widthBytes = (bitmap.width + 7) >> 3;
    for (var top = 0; top < bitmap.height; top += bandHeight) {
      final rows = math.min(bandHeight, bitmap.height - top);
      _out.add([
        _gs, 0x76, 0x30, 0x00, // GS v 0, normal density
        widthBytes & 0xFF, widthBytes >> 8,
        rows & 0xFF, rows >> 8,
      ]);
      _out.add(
        Uint8List.sublistView(
          bitmap.data,
          top * widthBytes,
          (top + rows) * widthBytes,
        ),
      );
    }
  }

  /// The receipt QR code, centred. [moduleDots] is the size of one QR module
  /// in printer dots; 4 keeps an RRA payload (~110 chars, level M) about
  /// 30 mm wide.
  void qr(
    String data, {
    EscPosQrMode mode = EscPosQrMode.raster,
    int moduleDots = 4,
  }) {
    if (data.isEmpty) return;
    if (mode == EscPosQrMode.native) {
      _nativeQr(data, moduleDots);
    } else {
      image(qrBitmap(data, moduleDots: moduleDots, maxWidth: dotsPerLine));
    }
  }

  void _nativeQr(String data, int moduleDots) {
    final payload = encodeText(data);
    final len = payload.length + 3;
    align(EscPosAlign.center);
    _out
      // Model 2.
      ..add([_gs, 0x28, 0x6B, 4, 0, 0x31, 0x41, 0x32, 0x00])
      // Module size.
      ..add([_gs, 0x28, 0x6B, 3, 0, 0x31, 0x43, moduleDots.clamp(1, 16)])
      // Error correction M (49 = M), matching the raster path.
      ..add([_gs, 0x28, 0x6B, 3, 0, 0x31, 0x45, 49])
      // Store the data, then print it.
      ..add([_gs, 0x28, 0x6B, len & 0xFF, len >> 8, 0x31, 0x50, 0x30])
      ..add(payload)
      ..add([_gs, 0x28, 0x6B, 3, 0, 0x31, 0x51, 0x30])
      ..addByte(_lf);
    align(EscPosAlign.left);
  }

  // ── Pure helpers (unit-tested) ──────────────────────────────────────────

  /// `DLE EOT 1`: real-time printer status. Every ESC/POS printer that is
  /// listening answers with one byte, at the right baud only.
  static final Uint8List statusQuery = Uint8List.fromList([0x10, 0x04, 0x01]);

  /// True when [b] is a valid `DLE EOT 1` reply: bits 1 and 4 set, bit 0 and
  /// bit 7 clear. Line noise at the wrong baud almost never matches.
  static bool isStatusReply(int b) => (b & 0x93) == 0x12;

  /// [text] as PC850 bytes. Accented Latin letters map to their PC850 code;
  /// anything else is transliterated to ASCII or becomes `?`.
  static Uint8List encodeText(String text) {
    final out = <int>[];
    for (final rune in text.runes) {
      if (rune == 0x0A || (rune >= 0x20 && rune < 0x7F)) {
        out.add(rune);
        continue;
      }
      final mapped = _pc850[rune];
      if (mapped != null) {
        out.add(mapped);
        continue;
      }
      final ascii = _transliterate[rune];
      out.addAll((ascii ?? '?').codeUnits);
    }
    return Uint8List.fromList(out);
  }

  /// Word-wraps [text] to [width] columns; words longer than a line are split.
  static List<String> wrap(String text, int width) {
    final lines = <String>[];
    for (final paragraph in text.split('\n')) {
      var line = '';
      for (var word in paragraph.split(RegExp(r'\s+'))) {
        if (word.isEmpty) continue;
        while (word.length > width) {
          if (line.isNotEmpty) {
            lines.add(line);
            line = '';
          }
          lines.add(word.substring(0, width));
          word = word.substring(width);
        }
        if (line.isEmpty) {
          line = word;
        } else if (line.length + 1 + word.length <= width) {
          line = '$line $word';
        } else {
          lines.add(line);
          line = word;
        }
      }
      lines.add(line);
    }
    return lines;
  }

  /// Lines for a left/right pair; see [row].
  static List<String> layoutRow(String left, String right, int width) {
    if (right.length >= width) {
      return [...wrap(left, width), right.substring(right.length - width)];
    }
    if (left.length + 1 + right.length <= width) {
      return [left + right.padLeft(width - left.length)];
    }
    final leftLines = wrap(left, width);
    final last = leftLines.removeLast();
    if (last.length + 1 + right.length <= width) {
      return [...leftLines, last + right.padLeft(width - last.length)];
    }
    return [...leftLines, last, right.padLeft(width)];
  }

  /// Renders [data] as a QR code, [moduleDots] dots per module plus the
  /// 4-module quiet zone, shrinking the module size if it would not fit.
  static MonoBitmap qrBitmap(
    String data, {
    int moduleDots = 4,
    int maxWidth = 384,
  }) {
    final code = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final qr = QrImage(code);
    final modules = qr.moduleCount + 8;
    var scale = moduleDots;
    while (scale > 1 && modules * scale > maxWidth) {
      scale--;
    }
    final size = modules * scale;
    final bitmap = MonoBitmap(size, size);
    for (var row = 0; row < qr.moduleCount; row++) {
      for (var col = 0; col < qr.moduleCount; col++) {
        if (!qr.isDark(row, col)) continue;
        final x0 = (col + 4) * scale;
        final y0 = (row + 4) * scale;
        for (var y = y0; y < y0 + scale; y++) {
          for (var x = x0; x < x0 + scale; x++) {
            bitmap.set(x, y);
          }
        }
      }
    }
    return bitmap;
  }

  /// Decodes a logo (PNG/JPEG/…), scales it to at most [maxWidth] dots wide
  /// (never up), flattens transparency onto white and Floyd–Steinberg dithers
  /// it to 1 bit. Null when [encoded] is not a readable image.
  static MonoBitmap? logoBitmap(
    Uint8List encoded, {
    int maxWidth = 360,
    int maxHeight = 160,
  }) {
    final decoded = img.decodeImage(encoded);
    if (decoded == null || decoded.width == 0 || decoded.height == 0) {
      return null;
    }
    final scale = math.min(
      1.0,
      math.min(maxWidth / decoded.width, maxHeight / decoded.height),
    );
    final resized = scale < 1
        ? img.copyResize(
            decoded,
            width: math.max(1, (decoded.width * scale).round()),
            height: math.max(1, (decoded.height * scale).round()),
            interpolation: img.Interpolation.average,
          )
        : decoded;
    return ditherToMono(resized);
  }

  /// Floyd–Steinberg to 1 bit; transparent pixels count as white paper.
  static MonoBitmap ditherToMono(img.Image src) {
    final w = src.width;
    final h = src.height;
    final lum = Float32List(w * h);
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final p = src.getPixel(x, y);
        final a = src.hasAlpha ? p.aNormalized : 1.0;
        final l =
            (0.299 * p.rNormalized +
                0.587 * p.gNormalized +
                0.114 * p.bNormalized) *
            255;
        lum[y * w + x] = l * a + 255 * (1 - a);
      }
    }
    final out = MonoBitmap(w, h);
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final i = y * w + x;
        final old = lum[i];
        final black = old < 128;
        if (black) out.set(x, y);
        final err = old - (black ? 0 : 255);
        if (x + 1 < w) lum[i + 1] += err * 7 / 16;
        if (y + 1 < h) {
          if (x > 0) lum[i + w - 1] += err * 3 / 16;
          lum[i + w] += err * 5 / 16;
          if (x + 1 < w) lum[i + w + 1] += err * 1 / 16;
        }
      }
    }
    return out;
  }

  static const Map<int, int> _pc850 = {
    0xC7: 0x80,
    0xFC: 0x81,
    0xE9: 0x82,
    0xE2: 0x83,
    0xE4: 0x84,
    0xE0: 0x85,
    0xE5: 0x86,
    0xE7: 0x87,
    0xEA: 0x88,
    0xEB: 0x89,
    0xE8: 0x8A,
    0xEF: 0x8B,
    0xEE: 0x8C,
    0xEC: 0x8D,
    0xC4: 0x8E,
    0xC5: 0x8F,
    0xC9: 0x90,
    0xE6: 0x91,
    0xC6: 0x92,
    0xF4: 0x93,
    0xF6: 0x94,
    0xF2: 0x95,
    0xFB: 0x96,
    0xF9: 0x97,
    0xFF: 0x98,
    0xD6: 0x99,
    0xDC: 0x9A,
    0xF8: 0x9B,
    0xA3: 0x9C,
    0xD8: 0x9D,
    0xE1: 0xA0,
    0xED: 0xA1,
    0xF3: 0xA2,
    0xFA: 0xA3,
    0xF1: 0xA4,
    0xD1: 0xA5,
    0xC1: 0xB5,
    0xC2: 0xB6,
    0xC0: 0xB7,
    0xCA: 0xD2,
    0xCB: 0xD3,
    0xC8: 0xD4,
    0xCD: 0xD6,
    0xCE: 0xD7,
    0xCF: 0xD8,
    0xD3: 0xE0,
    0xD4: 0xE2,
    0xD2: 0xE3,
    0xDA: 0xE9,
    0xDB: 0xEA,
    0xD9: 0xEB,
    0xB0: 0xF8,
  };

  static const Map<int, String> _transliterate = {
    0x2018: "'",
    0x2019: "'",
    0x201C: '"',
    0x201D: '"',
    0x2013: '-',
    0x2014: '-',
    0x2026: '...',
    0x00A0: ' ',
    0x20AC: 'EUR',
    0x0153: 'oe',
    0x0152: 'OE',
    0x2022: '*',
    0x00D7: 'x',
  };
}

/// A 1-bit image, rows packed MSB-first, 1 = black dot (the `GS v 0` layout).
class MonoBitmap {
  MonoBitmap(this.width, this.height)
    : data = Uint8List(((width + 7) >> 3) * height);

  final int width;
  final int height;
  final Uint8List data;

  int get _stride => (width + 7) >> 3;

  void set(int x, int y) {
    data[y * _stride + (x >> 3)] |= 0x80 >> (x & 7);
  }

  bool isBlack(int x, int y) =>
      data[y * _stride + (x >> 3)] & (0x80 >> (x & 7)) != 0;

  /// This image horizontally centred on a white strip [lineWidth] dots wide.
  MonoBitmap centredIn(int lineWidth) {
    final out = MonoBitmap(lineWidth, height);
    final left = (lineWidth - width) ~/ 2;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (isBlack(x, y)) out.set(left + x, y);
      }
    }
    return out;
  }
}
