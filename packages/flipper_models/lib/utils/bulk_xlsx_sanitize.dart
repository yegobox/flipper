import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

/// Fixes OOXML style sheets produced by WPS Office, Syncfusion, etc.
///
/// The Dart [excel] package rejects `<numFmt numFmtId="N">` entries in
/// `styles.xml` when N &lt; 164 (built-in ids incorrectly listed as custom).
Uint8List sanitizeXlsxBytesForExcelPackage(Uint8List bytes) {
  try {
    final archive = ZipDecoder().decodeBytes(bytes);
    final rebuilt = Archive();
    var changed = false;

    for (final file in archive.files) {
      if (!file.isFile) {
        rebuilt.addFile(file);
        continue;
      }

      final name = file.name.replaceAll('\\', '/');
      if (name == 'xl/styles.xml' || name.endsWith('/xl/styles.xml')) {
        final raw = file.content;
        if (raw is List<int> && raw.isNotEmpty) {
          final original = utf8.decode(raw);
          final sanitized = _sanitizeStylesXml(original);
          if (sanitized != original) {
            rebuilt.addFile(ArchiveFile.string(name, sanitized));
            changed = true;
            continue;
          }
        }
      }
      rebuilt.addFile(file);
    }

    if (!changed) return bytes;
    final encoded = ZipEncoder().encode(rebuilt);
    if (encoded == null) return bytes;
    return Uint8List.fromList(encoded);
  } catch (_) {
    return bytes;
  }
}

@visibleForTesting
String sanitizeStylesXmlForTest(String xml) => _sanitizeStylesXml(xml);

String _sanitizeStylesXml(String xml) {
  var result = xml.replaceAllMapped(
    RegExp(r'<numFmt\s+[^>]*numFmtId="(\d+)"[^>]*/>', multiLine: true),
    (match) {
      final id = int.tryParse(match.group(1)!);
      if (id != null && id < 164) return '';
      return match.group(0)!;
    },
  );

  result = result.replaceAllMapped(
    RegExp(
      r'<numFmt\s+[^>]*numFmtId="(\d+)"[^>]*>[\s\S]*?</numFmt>',
      multiLine: true,
    ),
    (match) {
      final id = int.tryParse(match.group(1)!);
      if (id != null && id < 164) return '';
      return match.group(0)!;
    },
  );

  return result;
}
