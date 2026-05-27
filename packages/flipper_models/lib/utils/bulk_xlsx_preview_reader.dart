import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flipper_models/bulk_add_constants.dart';
import 'package:flipper_models/utils/bulk_excel_parser.dart';
import 'package:flipper_models/utils/bulk_xlsx_sanitize.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

/// Fast preview for `.xlsx` (zip OOXML): row estimate + thin row scan.
class BulkXlsxPreviewResult {
  BulkXlsxPreviewResult({
    required this.sheetName,
    required this.estimatedDataRows,
    required this.previewRows,
    required this.headerRowIndex,
  });

  final String sheetName;
  final int estimatedDataRows;
  final List<Map<String, dynamic>> previewRows;

  /// 1-based Excel row index of the header row.
  final int headerRowIndex;
}

class _SheetRef {
  _SheetRef(this.name, this.path);
  final String name;
  final String path;
}

class BulkXlsxPreviewReader {
  BulkXlsxPreviewReader._();

  static const _maxCharsForDimensionScan = 120000;

  static int get _maxPhysicalRowsToScan => kBulkPreviewScanRowLimit;

  static BulkXlsxPreviewResult read(Uint8List bytes) {
    if (!isZipXlsx(bytes)) {
      throw StateError('Not a zip-based .xlsx');
    }

    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      archive = ZipDecoder().decodeBytes(sanitizeXlsxBytesForExcelPackage(bytes));
    }

    final sharedStrings = _readSharedStrings(archive);
    final pairs = _readSheetNameAndPaths(archive);
    if (pairs.isEmpty) {
      throw BulkExcelParseException('No worksheets found in the file.');
    }

    var bestName = '';
    var bestHeaderRow = -1;
    var bestScore = -1;
    var bestEstimate = 0;
    final bestRows = <int, Map<int, String>>{};

    for (final pair in pairs) {
      final file = archive.findFile(pair.path);
      if (file == null) continue;
      file.decompress();
      final raw = file.content;
      if (raw is! List<int> || raw.isEmpty) continue;
      final xml = utf8.decode(raw);
      final dimMax = _maxRowFromDimension(xml);
      final scanned = _scanRowsLimited(
        xml,
        maxPhysicalRow: _maxPhysicalRowsToScan,
        sharedStrings: sharedStrings,
      );
      if (scanned.isEmpty) continue;

      final headerRowIndex = _findBestHeaderRowIndex(scanned);
      if (headerRowIndex == -1) continue;

      final headerMap = _headerIndicesForSparseRow(scanned[headerRowIndex] ?? const {});
      final score = BulkExcelParser.sheetScoreForHeaderIndices(headerMap);
      if (headerMap.containsKey('BarCode') &&
          headerMap.containsKey('Name') &&
          score > bestScore) {
        bestScore = score;
        bestName = pair.name;
        bestHeaderRow = headerRowIndex;
        bestRows
          ..clear()
          ..addAll(scanned);
        final scannedMax = scanned.keys.isEmpty
            ? 0
            : scanned.keys.reduce((a, b) => a > b ? a : b);
        bestEstimate = _estimateDataRows(
          dimensionMaxRow: dimMax,
          headerRowIndex: headerRowIndex,
          scannedMaxRow: scannedMax,
        );
      }
    }

    if (bestName.isEmpty || bestHeaderRow == -1) {
      throw BulkExcelParseException(
        'Required columns were not found. The first row should include '
        'BarCode and Name (extra spaces and capitalization are OK). '
        'Expected: ${kBulkProductTemplateHeaders.join(', ')}.',
      );
    }

    final headerIndices = _headerIndicesForSparseRow(bestRows[bestHeaderRow] ?? const {});
    final previewRows = _buildPreviewRowMaps(
      bestRows,
      headerRowIndex: bestHeaderRow,
      headerIndices: headerIndices,
      maxDataRows: kBulkLargeFilePreviewLimit,
    );

    if (previewRows.isEmpty) {
      throw BulkExcelParseException(
        'No product rows found below the header row on sheet "$bestName".',
      );
    }

    return BulkXlsxPreviewResult(
      sheetName: bestName,
      estimatedDataRows: bestEstimate > 0 ? bestEstimate : previewRows.length,
      previewRows: previewRows,
      headerRowIndex: bestHeaderRow,
    );
  }

  static bool isZipXlsx(Uint8List b) => BulkExcelParser.isZipXlsxBuffer(b);

  @visibleForTesting
  static int? maxRowFromDimensionForTest(String xml) => _maxRowFromDimension(xml);

  @visibleForTesting
  static int? maxRowFromRefForTest(String ref) => _maxRowFromRef(ref);

  static int excelColIndexZeroBased(String cellRef) {
    final letters = cellRef.replaceAll(RegExp(r'[^A-Za-z]'), '').toUpperCase();
    if (letters.isEmpty) return -1;
    var n = 0;
    for (var i = 0; i < letters.length; i++) {
      final c = letters.codeUnitAt(i);
      if (c < 65 || c > 90) return -1;
      n = n * 26 + (c - 64);
    }
    return n - 1;
  }

  static int _estimateDataRows({
    required int? dimensionMaxRow,
    required int headerRowIndex,
    required int scannedMaxRow,
  }) {
    if (dimensionMaxRow != null && dimensionMaxRow > headerRowIndex + 1) {
      return dimensionMaxRow - headerRowIndex - 1;
    }
    if (scannedMaxRow > headerRowIndex) {
      return scannedMaxRow - headerRowIndex;
    }
    return 0;
  }

  static int? _maxRowFromDimension(String xml) {
    final head = xml.length <= _maxCharsForDimensionScan
        ? xml
        : xml.substring(0, _maxCharsForDimensionScan);
    final m = RegExp(
      r'<dimension[^>]*ref="([^"]+)"',
      caseSensitive: false,
    ).firstMatch(head);
    if (m == null) return null;
    return _maxRowFromRef(m.group(1)!);
  }

  static int? _maxRowFromRef(String ref) {
    final parts = ref.split(':');
    final cell = parts.length == 2 ? parts[1] : parts[0];
    final rowStr = _trailingDigits(cell);
    if (rowStr.isEmpty) return null;
    return int.tryParse(rowStr);
  }

  static String _trailingDigits(String cellRef) {
    var i = cellRef.length - 1;
    while (i >= 0) {
      final c = cellRef.codeUnitAt(i);
      if (c >= 0x30 && c <= 0x39) {
        var start = i;
        while (start > 0) {
          final p = cellRef.codeUnitAt(start - 1);
          if (p >= 0x30 && p <= 0x39) {
            start--;
          } else {
            break;
          }
        }
        return cellRef.substring(start, i + 1);
      }
      i--;
    }
    return '';
  }

  static List<String> _readSharedStrings(Archive archive) {
    final f = archive.findFile('xl/sharedStrings.xml');
    if (f == null) return const [];
    f.decompress();
    final raw = f.content;
    if (raw is! List<int> || raw.isEmpty) return const [];
    final doc = XmlDocument.parse(utf8.decode(raw));
    final out = <String>[];
    for (final si in doc.findAllElements('si')) {
      final buf = StringBuffer();
      void collect(XmlNode n) {
        if (n is XmlText) buf.write(n.value);
        for (final c in n.children) {
          collect(c);
        }
      }

      collect(si);
      out.add(buf.toString());
    }
    return out;
  }

  static List<_SheetRef> _readSheetNameAndPaths(Archive archive) {
    final wb = archive.findFile('xl/workbook.xml');
    if (wb == null) return [];
    wb.decompress();
    final wbDoc = XmlDocument.parse(utf8.decode(wb.content as List<int>));

    final ridToTarget = <String, String>{};
    final relsFile = archive.findFile('xl/_rels/workbook.xml.rels');
    if (relsFile != null) {
      relsFile.decompress();
      final rels = XmlDocument.parse(utf8.decode(relsFile.content as List<int>));
      for (final rel in rels.findAllElements('Relationship')) {
        final id = rel.getAttribute('Id');
        final target = rel.getAttribute('Target');
        if (id != null && target != null) {
          ridToTarget[id] = target;
        }
      }
    }

    final list = <_SheetRef>[];
    for (final node in wbDoc.findAllElements('sheet')) {
      final name = node.getAttribute('name');
      final rid = node.getAttribute('r:id') ?? node.getAttribute('id');
      if (name == null || rid == null) continue;
      var target = ridToTarget[rid] ?? '';
      if (target.isEmpty) continue;
      if (target.startsWith('/')) {
        target = target.substring(1);
      }
      if (!target.startsWith('xl/')) {
        target = 'xl/$target';
      }
      list.add(_SheetRef(name, target));
    }
    return list;
  }

  static String? _xmlAttr(XmlStartElementEvent e, String name) {
    for (final a in e.attributes) {
      if (a.name == name || a.name.endsWith(':$name')) {
        return a.value;
      }
    }
    return null;
  }

  static Map<int, Map<int, String>> _scanRowsLimited(
    String xml, {
    required int maxPhysicalRow,
    required List<String> sharedStrings,
  }) {
    final out = <int, Map<int, String>>{};
    final rowCells = <int, String>{};
    var inSheetData = false;
    int? currentRow;
    var inRow = false;

    String? cRef;
    String? cType;
    var inV = false;
    var inIs = false;
    var inInlineT = false;
    final vBuf = StringBuffer();

    void putCell(String? ref, String text) {
      if (ref == null) return;
      final col = excelColIndexZeroBased(ref);
      if (col < 0 || currentRow == null) return;
      rowCells[col] = text;
    }

    void flushOpenCell() {
      final ref = cRef;
      if (ref == null) return;
      final col = excelColIndexZeroBased(ref);
      if (col >= 0 && currentRow != null && !rowCells.containsKey(col)) {
        rowCells[col] = '';
      }
      cRef = null;
      cType = null;
    }

    void commitRow() {
      final rowIx = currentRow;
      if (rowIx == null) return;
      if (rowCells.isEmpty) return;
      out[rowIx] = Map<int, String>.from(rowCells);
      rowCells.clear();
    }

    void applyVBuffer() {
      final raw = vBuf.toString();
      vBuf.clear();
      if (cRef == null) return;
      if (cType == 's') {
        final i = int.tryParse(raw.trim());
        final text = (i != null && i >= 0 && i < sharedStrings.length)
            ? sharedStrings[i]
            : '';
        putCell(cRef, text);
      } else {
        putCell(cRef, raw);
      }
    }

    for (final e in parseEvents(xml)) {
      if (e is XmlStartElementEvent) {
        if (e.name == 'sheetData') {
          inSheetData = true;
          continue;
        }
        if (!inSheetData) continue;

        if (e.name == 'row') {
          commitRow();
          currentRow = int.tryParse(_xmlAttr(e, 'r') ?? '');
          final rowNum = currentRow;
          inRow = rowNum != null;
          if (rowNum != null && rowNum > maxPhysicalRow) {
            break;
          }
          continue;
        }

        if (inRow && e.name == 'c') {
          flushOpenCell();
          cRef = _xmlAttr(e, 'r');
          cType = _xmlAttr(e, 't');
          if (e.isSelfClosing) {
            flushOpenCell();
          }
          continue;
        }

        if (inRow && cRef != null) {
          if (e.name == 'v') {
            inV = true;
            vBuf.clear();
          } else if (e.name == 'is') {
            inIs = true;
          } else if (e.name == 't') {
            if (inIs) {
              inInlineT = true;
              vBuf.clear();
            }
          }
        }
      } else if (e is XmlTextEvent) {
        if (inV || inInlineT) vBuf.write(e.value);
      } else if (e is XmlEndElementEvent) {
        if (e.name == 'v' && inV) {
          inV = false;
          applyVBuffer();
        } else if (e.name == 't' && inInlineT) {
          inInlineT = false;
          putCell(cRef, vBuf.toString());
          vBuf.clear();
        } else if (e.name == 'is') {
          inIs = false;
        } else if (e.name == 'c') {
          flushOpenCell();
          cRef = null;
          cType = null;
          inV = false;
          inInlineT = false;
        } else if (e.name == 'row') {
          commitRow();
          inRow = false;
          currentRow = null;
        } else if (e.name == 'sheetData') {
          inSheetData = false;
          commitRow();
          break;
        }
      }
    }

    return out;
  }

  static int _findBestHeaderRowIndex(Map<int, Map<int, String>> scanned) {
    final rows = scanned.keys.toList()..sort();
    var best = -1;
    var bestScore = -1;
    for (final r in rows) {
      if (r > 40) break;
      final sparse = scanned[r];
      if (sparse == null || sparse.isEmpty) continue;
      final indices = _headerIndicesForSparseRow(sparse);
      final score = BulkExcelParser.sheetScoreForHeaderIndices(indices);
      if (indices.containsKey('BarCode') &&
          indices.containsKey('Name') &&
          score > bestScore) {
        bestScore = score;
        best = r;
      }
    }
    return best;
  }

  static Map<String, int> _headerIndicesForSparseRow(Map<int, String> sparse) {
    final indices = <String, int>{};
    for (final e in sparse.entries) {
      final raw = e.value;
      if (raw.isEmpty) continue;
      final norm = BulkExcelParser.normalizeHeaderKey(raw);
      final canon = BulkExcelParser.canonicalHeaderForKey(norm);
      if (canon != null && !indices.containsKey(canon)) {
        indices[canon] = e.key;
      }
    }
    return indices;
  }

  static List<Map<String, dynamic>> _buildPreviewRowMaps(
    Map<int, Map<int, String>> scanned, {
    required int headerRowIndex,
    required Map<String, int> headerIndices,
    required int maxDataRows,
  }) {
    final rows = scanned.keys.where((r) => r > headerRowIndex).toList()..sort();
    final list = <Map<String, dynamic>>[];
    for (final r in rows) {
      if (list.length >= maxDataRows) break;
      final sparse = scanned[r];
      if (sparse == null) continue;

      final rowData = <String, dynamic>{};
      var hasAny = false;
      for (final header in kBulkProductTemplateHeaders) {
        final col = headerIndices[header];
        final text = col == null ? '' : (sparse[col] ?? '');
        final s = BulkExcelParser.cellValueRawString(text);
        if (s.isNotEmpty) hasAny = true;
        rowData[header] = s;
      }

      if (hasAny) {
        list.add(rowData);
      }
    }
    return list;
  }
}

/// Top-level entry for `compute()` — fast xlsx preview in a worker isolate.
BulkXlsxPreviewResult readBulkXlsxPreviewIsolate(Uint8List bytes) {
  return BulkXlsxPreviewReader.read(bytes);
}
