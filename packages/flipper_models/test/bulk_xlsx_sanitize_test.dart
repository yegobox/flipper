import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/utils/bulk_excel_parser.dart';
import 'package:flipper_models/utils/bulk_xlsx_sanitize.dart';

void main() {
  test('removes built-in numFmt ids from styles.xml snippet', () {
    const input =
        '<numFmts count="1"><numFmt numFmtId="42" formatCode="General"/>'
        '<numFmt numFmtId="164" formatCode="Custom"/></numFmts>';
    final output = sanitizeStylesXmlForTest(input);
    expect(output.contains('numFmtId="42"'), isFalse);
    expect(output.contains('numFmtId="164"'), isTrue);
  });

  test('sanitized workbook with injected numFmtId 42 parses bulk rows', () {
    final workbook = Excel.createExcel();
    final sheetName = workbook.getDefaultSheet()!;
    final sheet = workbook.tables[sheetName]!;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = TextCellValue('BarCode');
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = TextCellValue('Name');
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
        .value = TextCellValue('SKU-1');
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
        .value = TextCellValue('Widget');

    var bytes = Uint8List.fromList(workbook.encode()!);
    bytes = _injectInvalidNumFmt(bytes);

    final rows = BulkExcelParser.parse(bytes);
    expect(rows, hasLength(1));
    expect(rows.first['BarCode'], 'SKU-1');
    expect(rows.first['Name'], 'Widget');
  });
}

Uint8List _injectInvalidNumFmt(Uint8List bytes) {
  final archive = ZipDecoder().decodeBytes(bytes);
  for (final file in archive.files) {
    if (!file.name.replaceAll('\\', '/').endsWith('xl/styles.xml')) continue;
    final content = file.content;
    if (content == null) continue;
    var xml = utf8.decode(content);
    if (xml.contains('<numFmts')) {
      xml = xml.replaceFirst(
        '<numFmts',
        '<numFmts count="99"><numFmt numFmtId="42" formatCode="General"/>',
      );
    } else {
      xml = xml.replaceFirst(
        '</styleSheet>',
        '<numFmts count="1"><numFmt numFmtId="42" formatCode="General"/>'
        '</numFmts></styleSheet>',
      );
    }
    final rebuilt = Archive();
    for (final entry in archive.files) {
      final entryName = entry.name.replaceAll('\\', '/');
      if (entryName.endsWith('xl/styles.xml')) {
        rebuilt.addFile(ArchiveFile.string(entryName, xml));
      } else {
        rebuilt.addFile(entry);
      }
    }
    return Uint8List.fromList(ZipEncoder().encode(rebuilt)!);
  }
  return bytes;
}
