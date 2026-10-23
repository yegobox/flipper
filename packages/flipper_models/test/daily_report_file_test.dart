import 'package:flipper_models/models/daily_report_file.dart';
import 'package:flutter_test/flutter_test.dart';

DailyReportFile _file({
  String type = DailyReportFile.dailyDetailedTransactionsXlsxType,
  String? day = '2026-10-22',
  String? fileName,
}) => DailyReportFile(
  id: 'f1',
  branchId: 'b1',
  type: type,
  day: day,
  fileName: fileName,
);

void main() {
  group('DailyReportFile.reportName', () {
    test('names a server daily report REPORT-<day>', () {
      expect(
        _file(fileName: 'REPORT-2026-10-22.xlsx').reportName,
        'REPORT-2026-10-22',
      );
    });

    test('renames files catalogued before the rename', () {
      expect(
        _file(fileName: 'daily-transactions-2026-10-22.xlsx').reportName,
        'REPORT-2026-10-22',
      );
      expect(
        _file(type: 'other', fileName: 'daily_transactions_x.xlsx').reportName,
        'REPORT-2026-10-22',
      );
    });

    test('recognises legacy names with spaces or mixed separators', () {
      for (final fileName in [
        'daily transactions 2026-10-22.xlsx',
        'Daily  Transactions_2026-10-22.xlsx',
        'daily_-transactions.xlsx',
      ]) {
        expect(
          _file(type: 'other', fileName: fileName).reportName,
          'REPORT-2026-10-22',
          reason: fileName,
        );
      }
    });

    test('leaves merged files to their date-range name', () {
      expect(
        _file(
          day: '2026-10-01 - 2026-10-05',
          fileName: '2026-10-01 - 2026-10-05 (merged).xlsx',
        ).reportName,
        isNull,
      );
    });

    test('is null without a day or for other files', () {
      expect(_file(day: null).reportName, isNull);
      expect(_file(day: '  ').reportName, isNull);
      expect(
        _file(type: 'sales-summary', fileName: 'sales_summary.xlsx').reportName,
        isNull,
      );
    });

    test('merged files stay unnamed even with a daily-transactions name', () {
      expect(
        _file(
          type: 'other',
          fileName: 'daily transactions 2026-10-01 (merged).xlsx',
        ).reportName,
        isNull,
      );
    });
  });

  group('DailyReportFile.matchesSearch', () {
    final legacy = DailyReportFile(
      id: 'row-7',
      branchId: 'b1',
      type: DailyReportFile.dailyDetailedTransactionsXlsxType,
      day: '2026-10-22',
      fileName: 'daily-transactions-2026-10-22.xlsx',
      s3ObjectKey: 'reports/b1/key-abc.xlsx',
      runId: 'run-42',
    );

    test('finds a legacy file by its displayed REPORT-<day> name', () {
      expect(legacy.matchesSearch('REPORT-2026-10-22'), isTrue);
      expect(legacy.matchesSearch('  report-2026-10-22 '), isTrue);
    });

    test('still matches every stored field', () {
      expect(legacy.matchesSearch('DAILY-TRANSACTIONS'), isTrue);
      expect(legacy.matchesSearch('2026-10-22'), isTrue);
      expect(legacy.matchesSearch('key-abc'), isTrue);
      expect(legacy.matchesSearch('run-42'), isTrue);
      expect(legacy.matchesSearch('row-7'), isTrue);
    });

    test('an empty query matches and an unrelated one does not', () {
      expect(legacy.matchesSearch('   '), isTrue);
      expect(legacy.matchesSearch('REPORT-2026-10-23'), isFalse);
    });

    test('does not invent a report name for other files', () {
      final other = _file(type: 'sales-summary', fileName: 'sales.xlsx');
      expect(other.matchesSearch('report-'), isFalse);
      expect(_file(day: null, fileName: null).matchesSearch('x'), isFalse);
    });
  });
}
