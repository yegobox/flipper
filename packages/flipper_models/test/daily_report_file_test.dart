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
  });
}
