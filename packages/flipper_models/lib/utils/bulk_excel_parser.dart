import 'dart:typed_data';

import 'package:excel/excel.dart' as xls;
import 'package:excel_plus/excel_plus.dart' as xlsx;
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

/// Isolate/compute payload: bytes plus optional sheet from the fast preview pass.
class BulkExcelIsolateArgs {
  const BulkExcelIsolateArgs(this.bytes, {this.preferredSheetName});

  final Uint8List bytes;

  /// When set, full parse prefers this worksheet if it still has valid headers.
  final String? preferredSheetName;
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
    // Do not map generic "Unit" → bcdU: packaging/unit columns would trigger
    // the barcode-update path and abort when no existing variant matches.
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

  static List<Map<String, dynamic>> parse(Uint8List bytes, {String? preferredSheet}) {
    return parseWithMeta(bytes, preferredSheetName: preferredSheet).rows;
  }

  /// [preferredSheetName] pins the worksheet when supplied (same sheet as preview).
  static BulkExcelParseResult parseWithMeta(
    Uint8List bytes, {
    String? preferredSheetName,
  }) {
    if (bytes.isEmpty) {
      throw BulkExcelParseException('The file is empty.');
    }

    if (!isZipXlsxBuffer(bytes)) {
      return _parseLegacyXls(bytes);
    }
    return _parseZipXlsx(bytes, preferredSheetName: preferredSheetName);
  }

  /// Zip local file header signature for `.xlsx` / OOXML.
  static bool isZipXlsxBuffer(Uint8List b) =>
      b.length >= 4 &&
      b[0] == 0x50 &&
      b[1] == 0x4B &&
      b[2] == 0x03 &&
      b[3] == 0x04;

  static BulkExcelParseResult _parseZipXlsx(
    Uint8List bytes, {
    String? preferredSheetName,
  }) {
    try {
      return _rowsFromDecodedXlsx(
        xlsx.Excel.decodeBytes(bytes),
        preferredSheetName: preferredSheetName,
      );
    } catch (e) {
      if (!_needsStylesSanitize(e)) {
        throw BulkExcelParseException(
          'Could not read this spreadsheet. Try re-downloading the template, or '
          'save the file again as Excel (.xlsx). ($e)',
        );
      }
      try {
        return _rowsFromDecodedXlsx(
          xlsx.Excel.decodeBytes(sanitizeXlsxBytesForExcelPackage(bytes)),
          preferredSheetName: preferredSheetName,
        );
      } catch (e2) {
        throw BulkExcelParseException(
          'Could not read this spreadsheet. Try re-downloading the template, or '
          'save the file again as Excel (.xlsx). ($e2)',
        );
      }
    }
  }

  static BulkExcelParseResult _parseLegacyXls(Uint8List bytes) {
    try {
      return _rowsFromDecodedXls(xls.Excel.decodeBytes(bytes));
    } catch (e) {
      if (!_needsStylesSanitize(e)) {
        throw BulkExcelParseException(
          'Could not read this spreadsheet. Try re-downloading the template, or '
          'save the file again as Excel (.xlsx). ($e)',
        );
      }
      try {
        return _rowsFromDecodedXls(
          xls.Excel.decodeBytes(sanitizeXlsxBytesForExcelPackage(bytes)),
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

  static BulkExcelParseResult _rowsFromDecodedXlsx(
    xlsx.Excel excel, {
    String? preferredSheetName,
  }) {
    final tables = excel.tables;
    if (tables.isEmpty) {
      throw BulkExcelParseException('No worksheets found in the file.');
    }

    if (preferredSheetName != null) {
      final preferred = tables[preferredSheetName];
      if (preferred != null && preferred.rows.isNotEmpty) {
        final headerRow = _headerRowIndexForXlsxRows(preferred.rows);
        if (headerRow != null) {
          return _bulkRowsFromIndexedSheet(
            preferred.rows,
            headerRowIndex: headerRow,
            sheetName: preferredSheetName,
            rowCellText: (d) => cellValueToStringFromXlsx(d?.value),
          );
        }
      }
    }

    return _pickBestSheetXlsx(excel);
  }

  static BulkExcelParseResult _pickBestSheetXlsx(xlsx.Excel excel) {
    var bestSheetName = '';
    xlsx.Sheet? sheet;
    var bestScore = -1;

    for (final name in excel.tables.keys) {
      final candidate = excel.tables[name];
      if (candidate == null || candidate.rows.isEmpty) continue;

      final headerRowIndex = _headerRowIndexForXlsxRows(candidate.rows);
      if (headerRowIndex == null) continue;

      final headerIndices = _mapHeaderIndicesXlsx(candidate.rows[headerRowIndex]);
      final score = sheetScoreForHeaderIndices(headerIndices);
      if (score > bestScore) {
        bestScore = score;
        sheet = candidate;
        bestSheetName = name;
      }
    }

    if (sheet == null || bestScore < 0) {
      throw BulkExcelParseException(
        'Required columns were not found. The first row should include '
        'BarCode and Name (extra spaces and capitalization are OK). '
        'Expected: ${kBulkProductTemplateHeaders.join(', ')}.',
      );
    }

    final headerRowIndex = _headerRowIndexForXlsxRows(sheet.rows)!;
    return _bulkRowsFromIndexedSheet(
      sheet.rows,
      headerRowIndex: headerRowIndex,
      sheetName: bestSheetName,
      rowCellText: (d) => cellValueToStringFromXlsx(d?.value),
    );
  }

  static BulkExcelParseResult _rowsFromDecodedXls(xls.Excel excel) {
    if (excel.tables.isEmpty) {
      throw BulkExcelParseException('No worksheets found in the file.');
    }

    String? sheetName;
    xls.Sheet? sheet;
    var bestScore = -1;

    for (final name in excel.tables.keys) {
      final candidate = excel.tables[name];
      if (candidate == null || candidate.rows.isEmpty) continue;

      final headerRowIndex = _findHeaderRowIndexXls(candidate);
      if (headerRowIndex == -1) continue;

      final headerIndices = _mapHeaderIndicesXls(candidate.rows[headerRowIndex]);
      final score = sheetScoreForHeaderIndices(headerIndices);
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

    final headerRowIndex = _findHeaderRowIndexXls(sheet);
    return _bulkRowsFromIndexedSheet(
      sheet.rows,
      headerRowIndex: headerRowIndex,
      sheetName: sheetName,
      rowCellText: (d) => cellValueToStringFromXls(d?.value),
    );
  }

  static BulkExcelParseResult _bulkRowsFromIndexedSheet<T>(
    List<List<T?>> rows, {
    required int headerRowIndex,
    required String? sheetName,
    required String Function(T?) rowCellText,
  }) {
    final headerIndices = _mapHeaderIndicesGeneric(rows[headerRowIndex], rowCellText);
    if (!headerIndices.containsKey('BarCode') ||
        !headerIndices.containsKey('Name')) {
      throw BulkExcelParseException(
        'Missing required columns BarCode and/or Name on sheet '
        '"${sheetName ?? 'unknown'}". Found: '
        '${headerIndices.keys.join(', ')}.',
      );
    }

    final out = <Map<String, dynamic>>[];
    for (var i = headerRowIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final rowData = <String, dynamic>{};
      var hasNonEmptyValue = false;

      for (final header in kBulkProductTemplateHeaders) {
        final columnIndex = headerIndices[header];
        if (columnIndex == null) {
          rowData[header] = '';
          continue;
        }
        final cellValue =
            columnIndex < row.length ? rowCellText(row[columnIndex]) : '';
        if (cellValue.isNotEmpty) {
          hasNonEmptyValue = true;
        }
        rowData[header] = cellValue;
      }

      if (hasNonEmptyValue) {
        out.add(rowData);
      }
    }

    if (out.isEmpty) {
      throw BulkExcelParseException(
        'No product rows found below the header row on sheet '
        '"${sheetName ?? 'unknown'}".',
      );
    }

    return BulkExcelParseResult(rows: out, sheetName: sheetName);
  }

  /// Normalizes a header cell for alias lookup (BOM, spaces, case).
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

  /// Header scoring for sheet selection (shared with fast xlsx preview).
  static int sheetScoreForHeaderIndices(Map<String, int> headerIndices) {
    var score = 0;
    if (headerIndices.containsKey('BarCode')) score += 10;
    if (headerIndices.containsKey('Name')) score += 10;
    for (final header in kBulkProductTemplateHeaders) {
      if (headerIndices.containsKey(header)) score += 1;
    }
    return score;
  }

  /// Plain string cell text for preview maps (already decoded XML / shared strings).
  static String cellValueRawString(String raw) {
    var s = raw.trim();
    if (s.startsWith('\uFEFF')) {
      s = s.substring(1).trim();
    }
    return s;
  }

  /// Converts any [xlsx.CellValue] to a plain string for import.
  @visibleForTesting
  static String cellValueToStringFromXlsx(xlsx.CellValue? value) {
    if (value == null) return '';

    return switch (value) {
      xlsx.TextCellValue() => value.value.toString().trim(),
      xlsx.IntCellValue() => value.value.toString(),
      xlsx.DoubleCellValue() => _formatDouble(value.value),
      xlsx.BoolCellValue() => value.value.toString(),
      xlsx.DateCellValue() => value.toString(),
      xlsx.DateTimeCellValue() => value.toString(),
      xlsx.TimeCellValue() => value.toString(),
      xlsx.FormulaCellValue() => value.formula.trim(),
    };
  }

  /// Converts any [xls.CellValue] to a plain string for import.
  @visibleForTesting
  static String cellValueToStringFromXls(xls.CellValue? value) {
    if (value == null) return '';

    return switch (value) {
      xls.TextCellValue() => value.value.toString().trim(),
      xls.IntCellValue() => value.value.toString(),
      xls.DoubleCellValue() => _formatDouble(value.value),
      xls.BoolCellValue() => value.value.toString(),
      xls.DateCellValue() => value.toString(),
      xls.TimeCellValue() => value.toString(),
      xls.FormulaCellValue() => value.formula.trim(),
      _ => value.toString().trim(),
    };
  }

  /// Kept for tests / call sites that used the old name.
  @visibleForTesting
  static String cellValueToString(Object? value) {
    if (value is xlsx.CellValue) return cellValueToStringFromXlsx(value);
    if (value is xls.CellValue) return cellValueToStringFromXls(value);
    return '';
  }

  static String _formatDouble(double n) {
    if (n == n.roundToDouble()) {
      return n.toInt().toString();
    }
    return n.toString();
  }

  static int? _headerRowIndexForXlsxRows(
    List<List<xlsx.Data?>> rows, {
    int maxScan = 40,
  }) {
    final limit = maxScan < rows.length ? maxScan : rows.length;
    var bestIndex = -1;
    var bestScore = -1;

    for (var i = 0; i < limit; i++) {
      final indices = _mapHeaderIndicesXlsx(rows[i]);
      final score = sheetScoreForHeaderIndices(indices);
      if (indices.containsKey('BarCode') &&
          indices.containsKey('Name') &&
          score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }
    return bestIndex == -1 ? null : bestIndex;
  }

  static int _findHeaderRowIndexXls(xls.Sheet sheet, {int maxScan = 40}) {
    final limit = maxScan < sheet.rows.length ? maxScan : sheet.rows.length;
    var bestIndex = -1;
    var bestScore = -1;

    for (var i = 0; i < limit; i++) {
      final indices = _mapHeaderIndicesXls(sheet.rows[i]);
      final score = sheetScoreForHeaderIndices(indices);
      if (indices.containsKey('BarCode') &&
          indices.containsKey('Name') &&
          score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  static Map<String, int> _mapHeaderIndicesXlsx(List<xlsx.Data?> headerRow) {
    return _mapHeaderIndicesGeneric(
      headerRow,
      (d) => cellValueToStringFromXlsx(d?.value),
    );
  }

  static Map<String, int> _mapHeaderIndicesXls(List<xls.Data?> headerRow) {
    return _mapHeaderIndicesGeneric(
      headerRow,
      (d) => cellValueToStringFromXls(d?.value),
    );
  }

  static Map<String, int> _mapHeaderIndicesGeneric<T>(
    List<T?> headerRow,
    String Function(T?) rowCellText,
  ) {
    final indices = <String, int>{};
    for (var i = 0; i < headerRow.length; i++) {
      final raw = rowCellText(headerRow[i]);
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
BulkExcelParseResult parseBulkExcelInIsolate(BulkExcelIsolateArgs args) {
  return BulkExcelParser.parseWithMeta(
    args.bytes,
    preferredSheetName: args.preferredSheetName,
  );
}
