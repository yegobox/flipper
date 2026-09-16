import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Bundle assets shared by the A4 `pdf`-package document builders.
///
/// Both loads are cached for the life of the process and both fail soft: a
/// missing font or logo should cost a document its polish, never its existence.
abstract final class PdfAssets {
  static const flipperLogoSvgAsset =
      'packages/flipper_dashboard/assets/pos_handoff/icons/flipper-logo.svg';
  static const _notoSansAsset = 'packages/receipt/assets/fonts/NotoSans-Regular.ttf';

  static pw.Font? _fallbackFont;
  static String? _flipperLogoSvg;

  /// Helvetica has no Kinyarwanda/accented coverage worth relying on; this is
  /// the fallback that keeps a guest's name from rendering as boxes.
  static Future<pw.Font?> unicodeFallback() async {
    if (_fallbackFont != null) return _fallbackFont;
    try {
      final data = await rootBundle.load(_notoSansAsset);
      _fallbackFont = pw.Font.ttf(data);
    } catch (_) {}
    return _fallbackFont;
  }

  static Future<String?> flipperLogoMarkup() async {
    if (_flipperLogoSvg != null) return _flipperLogoSvg;
    try {
      _flipperLogoSvg = await rootBundle.loadString(flipperLogoSvgAsset);
    } catch (_) {}
    return _flipperLogoSvg;
  }

  /// Visible for tests, which run without a real asset bundle.
  static void resetForTest() {
    _fallbackFont = null;
    _flipperLogoSvg = null;
  }
}
