import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';

/// Adobe app names on macOS, tried in order when opening a saved PDF.
const _kMacOsAdobeAppNames = [
  'Adobe Acrobat',
  'Adobe Acrobat Reader',
  'Adobe Acrobat Reader DC',
];

/// Writes [bytes] to a temp file and opens it in a PDF viewer.
///
/// On macOS, tries Adobe Acrobat / Reader first, then falls back to the
/// system default via [OpenFilex].
Future<void> openPdfBytesOnDesktop({
  required Uint8List bytes,
  required String filename,
}) async {
  if (kIsWeb || !UniversalPlatform.isDesktop) {
    throw UnsupportedError('openPdfBytesOnDesktop is desktop-only');
  }

  final safeName = filename.toLowerCase().endsWith('.pdf')
      ? filename
      : '$filename.pdf';
  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/$safeName';
  await File(path).writeAsBytes(bytes, flush: true);

  if (Platform.isMacOS) {
    for (final appName in _kMacOsAdobeAppNames) {
      final result = await Process.run('open', ['-a', appName, path]);
      if (result.exitCode == 0) return;
    }
  }

  await OpenFilex.open(path);
}
