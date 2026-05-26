import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flipper_models/utils/bulk_xlsx_sanitize.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

/// Canonical column names for the bulk product import template.
const List<String> kBulkProductTemplateHeaders = [
  'BarCode',
  'Name',
  'Category',
  'Price',
  'SupplyPrice',
  'Quantity',
  'bcdU',
];

/// Result of parsing a bulk-import spreadsheet.
class BulkExcelParseResult {
  const BulkExcelParseResult({
    required this.rows,
    this.sheetName,
  });

  final List<Map<String, dynamic>> rows;
  final String? sheetName;
}

/// Thrown when a spreadsheet cannot be parsed for bulk import.
class BulkExcelParseException implements Exception {
  BulkExcelParseException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Parses Excel bytes for bulk product import (Excel, WPS-exported .xlsx/.xls).
class BulkExcelParser {
  BulkExcelParser._();

  static const Set<String> supportedExtensions = {'xlsx', 'xls'};

  static const Set<String> _unsupportedWpsExtensions = {'et', 'ett', 'ets'};

  static const Map<String, String> _headerAliases = {
    'barcode': 'BarCode',
    'name': 'Name',
    'productname': 'Name',
    'itemname': 'Name',
    'category': 'Category',
    'price': 'Price',
    'retailprice': 'Price',
    'sellingprice': 'Price',
    'supplyprice': 'SupplyPrice',
    'cost': 'SupplyPrice',
    'costprice': 'SupplyPrice',
    'quantity': 'Quantity',
    'qty': 'Quantity',
    'stock': 'Quantity',
    'bcdu': 'bcdU',
    'bcdunit': 'bcdU',
    'unit': 'bcdU',
  };

  static bool isSupportedExtension(String pathOrName) {
    final ext = _extension(pathOrName);
    return supportedExtensions.contains(ext);
  }

  static bool isKnownUnsupportedExtension(String pathOrName) {
    return _unsupportedWpsExtensions.contains(_extension(pathOrName));
  }

  static String unsupportedFormatHelp(String pathOrName) {
    final ext = _extension(pathOrName);
    if (_unsupportedWpsExtensions.contains(ext)) {
      return 'WPS "$ext" files are not supported. In WPS Office choose '
          'File → Save As → Excel Workbook (.xlsx), then upload again.';
    }
    if (ext.isEmpty) {
      return 'Could not detect a file type. Please use an Excel .xlsx or .xls file.';
    }
    return 'Unsupported file type ".$ext". Supported formats: .xlsx, .xls';
  }

  static List<Map<String, dynamic>> parse(Uint8List bytes) {
    return parseWithMeta(bytes).rows;
  }

  static BulkExcelParseResult parseWithMeta(Uint8List bytes) {
    if (bytes.isEmpty) {
      throw BulkExcelParseException('The file is empty.');
    }

    try {
      return _rowsFromDecoded(Excel.decodeBytes(bytes));
    } catch (e) {
      if (!_needsStylesSanitize(e)) {
        throw BulkExcelParseException(
          'Could not read this spreadsheet. Try re-downloading the template, or '
          'save the file again as Excel (.xlsx). ($e)',
        );
      }
      try {
        return _rowsFromDecoded(
          Excel.decodeBytes(sanitizeXlsxBytesForExcelPackage(bytes)),
        );
      } catch (e2) {
        throw BulkExcelParseException(
          'Could not read this spreadsheet. Try re-downloading the template, or '
          'save the file again as Excel (.xlsx). ($e2)',
        );
      }
    }
  }

  static bool _needsStylesSanitize(Object error) {
    final message = error.toString();
    return message.contains('numFmtId') || message.contains('numFmt');
  }

  static BulkExcelParseResult _rowsFromDecoded(Excel excel) {
    if (excel.tables.isEmpty) {
      throw BulkExcelParseException('No worksheets found in the file.');
    }

    String? sheetName;
    Sheet? sheet;
    var bestScore = -1;

    for (final name in excel.tables.keys) {
      final candidate = excel.tables[name];
      if (candidate == null || candidate.rows.isEmpty) continue;

      final headerRowIndex = _findHeaderRowIndex(candidate);
      if (headerRowIndex == -1) continue;

      final headerIndices = _mapHeaderIndices(candidate.rows[headerRowIndex]);
      final score = _sheetScore(headerIndices);
      if (score > bestScore) {
        bestScore = score;
        sheet = candidate;
        sheetName = name;
      }
    }

    if (sheet == null || bestScore < 0) {
      throw BulkExcelParseException(
        'Required columns were not found. The first row should include '
        'BarCode and Name (extra spaces and capitalization are OK). '
        'Expected: ${kBulkProductTemplateHeaders.join(', ')}.',
      );
    }

    final headerRowIndex = _findHeaderRowIndex(sheet);
    final headerIndices = _mapHeaderIndices(sheet.rows[headerRowIndex]);

    if (!headerIndices.containsKey('BarCode') ||
        !headerIndices.containsKey('Name')) {
      throw BulkExcelParseException(
        'Missing required columns BarCode and/or Name on sheet '
        '"${sheetName ?? 'unknown'}". Found: '
        '${headerIndices.keys.join(', ')}.',
      );
    }

    final rows = <Map<String, dynamic>>[];
    for (var i = headerRowIndex + 1; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      final rowData = <String, dynamic>{};
      var hasNonEmptyValue = false;

      for (final header in kBulkProductTemplateHeaders) {
        final columnIndex = headerIndices[header];
        if (columnIndex == null) {
          rowData[header] = '';
          continue;
        }
        final cellValue = columnIndex < row.length
            ? cellValueToString(row[columnIndex]?.value)
            : '';
        if (cellValue.isNotEmpty) {
          hasNonEmptyValue = true;
        }
        rowData[header] = cellValue;
      }

      if (hasNonEmptyValue) {
        rows.add(rowData);
      }
    }

    if (rows.isEmpty) {
      throw BulkExcelParseException(
        'No product rows found below the header row on sheet '
        '"${sheetName ?? 'unknown'}".',
      );
    }

    return BulkExcelParseResult(rows: rows, sheetName: sheetName);
  }

  /// Normalizes a header cell for alias lookup (BOM, spaces, case).
  @visibleForTesting
  static String normalizeHeaderKey(String raw) {
    var s = raw.trim();
    if (s.startsWith('\uFEFF')) {
      s = s.substring(1).trim();
    }
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    final collapsed = s.toLowerCase().replaceAll(RegExp(r'[\s_\-]'), '');
    return collapsed;
  }

  /// Maps a normalized key to a canonical template header, if recognized.
  @visibleForTesting
  static String? canonicalHeaderForKey(String normalizedKey) {
    if (normalizedKey.isEmpty) return null;
    if (kBulkProductTemplateHeaders
        .map(normalizeHeaderKey)
        .contains(normalizedKey)) {
      return kBulkProductTemplateHeaders.firstWhere(
        (h) => normalizeHeaderKey(h) == normalizedKey,
      );
    }
    return _headerAliases[normalizedKey];
  }

  /// Converts any [CellValue] to a plain string for import.
  @visibleForTesting
  static String cellValueToString(CellValue? value) {
    if (value == null) return '';

    return switch (value) {
      TextCellValue() => value.value.toString().trim(),
      IntCellValue() => value.value.toString(),
      DoubleCellValue() => _formatDouble(value.value),
      BoolCellValue() => value.value.toString(),
      DateCellValue() => value.toString(),
      TimeCellValue() => value.toString(),
      FormulaCellValue() => value.formula.trim(),
      _ => value.toString().trim(),
    };
  }

  static String _formatDouble(double n) {
    if (n == n.roundToDouble()) {
      return n.toInt().toString();
    }
    return n.toString();
  }

  static int _sheetScore(Map<String, int> headerIndices) {
    var score = 0;
    if (headerIndices.containsKey('BarCode')) score += 10;
    if (headerIndices.containsKey('Name')) score += 10;
    for (final header in kBulkProductTemplateHeaders) {
      if (headerIndices.containsKey(header)) score += 1;
    }
    return score;
  }

  static int _findHeaderRowIndex(Sheet sheet, {int maxScan = 40}) {
    final limit = maxScan < sheet.rows.length ? maxScan : sheet.rows.length;
    var bestIndex = -1;
    var bestScore = -1;

    for (var i = 0; i < limit; i++) {
      final indices = _mapHeaderIndices(sheet.rows[i]);
      final score = _sheetScore(indices);
      if (indices.containsKey('BarCode') &&
          indices.containsKey('Name') &&
          score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  static Map<String, int> _mapHeaderIndices(List<Data?> headerRow) {
    final indices = <String, int>{};
    for (var i = 0; i < headerRow.length; i++) {
      final raw = cellValueToString(headerRow[i]?.value);
      if (raw.isEmpty) continue;
      final canonical = canonicalHeaderForKey(normalizeHeaderKey(raw));
      if (canonical != null && !indices.containsKey(canonical)) {
        indices[canonical] = i;
      }
    }
    return indices;
  }

  static String _extension(String pathOrName) {
    final dot = pathOrName.lastIndexOf('.');
    if (dot == -1 || dot == pathOrName.length - 1) return '';
    return pathOrName.substring(dot + 1).toLowerCase();
  }
}

/// Top-level entry for [compute] — keeps heavy decode off the UI isolate.
BulkExcelParseResult parseBulkExcelInIsolate(Uint8List bytes) {
  return BulkExcelParser.parseWithMeta(bytes);
}
