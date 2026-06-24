import 'package:mocktail/mocktail.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:excel/excel.dart';
import 'package:flipper_models/utils/excel_utility.dart';
import 'package:flipper_services/proxy.dart';

import 'package:talker/talker.dart';

class MockCrash extends Mock implements Crash, TalkerObserver {}

void main() {
  group('ExcelUtility Tests', () {
    late String testFilePath;
    late MockCrash mockCrash;

    setUpAll(() {
      mockCrash = MockCrash();
      // Mock log to avoid errors when talker is used
      when(() => mockCrash.log(any())).thenAnswer((_) async {});
      // ProxyService.crash = mockCrash;

      testFilePath = 'test_financials.xlsx';
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.appendRow([
        TextCellValue('Month'),
        TextCellValue('Revenue'),
        TextCellValue('Profit'),
      ]);
      sheet.appendRow([
        TextCellValue('Jan'),
        IntCellValue(1000),
        IntCellValue(200),
      ]);
      sheet.appendRow([
        TextCellValue('Feb'),
        IntCellValue(1200),
        IntCellValue(300),
      ]);

      final bytes = excel.encode();
      if (bytes != null) {
        File(testFilePath).writeAsBytesSync(bytes);
      }
    });

    tearDownAll(() {
      final file = File(testFilePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('excelToMarkdown converts excel to markdown table', () async {
      final markdown = await ExcelUtility.excelToMarkdown(testFilePath);

      expect(markdown, contains('### Sheet: Sheet1'));
      expect(markdown, contains('| Month | Revenue | Profit |'));
      expect(markdown, contains('| Jan | 1000 | 200 |'));
      expect(markdown, contains('| Feb | 1200 | 300 |'));
    });
  });
}
