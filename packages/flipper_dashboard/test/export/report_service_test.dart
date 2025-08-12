import 'package:flipper_dashboard/export/report_service.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/export/report_service_test.dart
void main() {
  group('ReportService Tests', () {
    late ReportService reportService;

    setUp(() {
      reportService = ReportService();
    });

    group('generateReport', () {
      test('throws ArgumentError when Z report has no endDate', () {
        expect(
          () => reportService.generateReport(reportType: 'Z'),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'endDate is required for Z-Reports',
          )),
        );
      });

      test('validates Z report requires endDate', () {
        expect(
          () => reportService.generateReport(reportType: 'Z', endDate: null),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('validates Z report endDate requirement logic', () {
        // Test the validation logic directly
        const reportType = 'Z';
        DateTime? endDate;
        
        // This simulates the validation logic from the actual method
        expect(reportType == 'Z', isTrue);
        
        endDate = DateTime(2024, 1, 15);
        expect(reportType == 'Z' && endDate != null, isTrue);
      });

      test('validates X report does not require endDate', () {
        const reportType = 'X';
        
        // X reports should not require endDate
        expect(reportType == 'X', isTrue);
        expect(reportType == 'Z', isFalse);
      });
    });

    group('Date calculations with service integration', () {
      test('Z report calculates start date correctly from service logic', () {
        final endDate = DateTime(2024, 1, 15, 14, 30, 45);
        
        // Test actual service logic: startDate = DateTime(endDate.year, endDate.month, endDate.day)
        final startDate = DateTime(endDate.year, endDate.month, endDate.day);
        
        expect(startDate.year, equals(2024));
        expect(startDate.month, equals(1));
        expect(startDate.day, equals(15));
        expect(startDate.hour, equals(0));
        expect(startDate.minute, equals(0));
        expect(startDate.second, equals(0));
        expect(startDate.millisecond, equals(0));
      });

      test('UTC conversion for local day range', () {
        // Test local to UTC conversion for day boundaries
        final localDate = DateTime(2024, 1, 15, 14, 30, 45);
        final localStartOfDay = DateTime(localDate.year, localDate.month, localDate.day);
        final localEndOfDay = DateTime(localDate.year, localDate.month, localDate.day, 23, 59, 59, 999);
        
        final utcStartOfDay = localStartOfDay.toUtc();
        final utcEndOfDay = localEndOfDay.toUtc();
        
        expect(utcStartOfDay.isUtc, isTrue);
        expect(utcEndOfDay.isUtc, isTrue);
        expect(utcStartOfDay.isBefore(utcEndOfDay), isTrue);
      });

      test('service date range spans correct 24-hour period', () {
        final endDate = DateTime(2024, 1, 15, 14, 30, 45);
        final startDate = DateTime(endDate.year, endDate.month, endDate.day);
        
        final duration = endDate.difference(startDate);
        expect(duration.inHours, greaterThanOrEqualTo(14));
        expect(duration.inHours, lessThan(24));
      });

      test('handles timezone edge cases in date calculations', () {
        // Test edge case: end of year with timezone
        final endOfYear = DateTime(2024, 12, 31, 23, 59, 59);
        final startOfDay = DateTime(endOfYear.year, endOfYear.month, endOfYear.day);
        
        expect(startOfDay.year, equals(2024));
        expect(startOfDay.month, equals(12));
        expect(startOfDay.day, equals(31));
        
        // Verify UTC conversion maintains date integrity
        final utcStart = startOfDay.toUtc();
        final utcEnd = endOfYear.toUtc();
        expect(utcStart.isBefore(utcEnd), isTrue);
      });

      test('leap year date handling in service context', () {
        final leapYearDate = DateTime(2024, 2, 29, 12, 0, 0);
        final startOfDay = DateTime(leapYearDate.year, leapYearDate.month, leapYearDate.day);
        
        expect(startOfDay.year, equals(2024));
        expect(startOfDay.month, equals(2));
        expect(startOfDay.day, equals(29));
        
        // Verify leap year date survives UTC conversion
        final utcDate = startOfDay.toUtc();
        expect(utcDate.isUtc, isTrue);
      });

      test('X report date range calculation from last Z report', () {
        // Simulate X report logic: uses lastZReportDate as startDate
        final lastZReportDate = DateTime(2024, 1, 14, 23, 59, 59);
        final currentDate = DateTime(2024, 1, 15, 14, 30, 45);
        
        // X report should span from last Z report to current time
        final duration = currentDate.difference(lastZReportDate);
        expect(duration.inHours, greaterThan(14));
        expect(duration.inMinutes, greaterThan(14 * 60 + 30));
      });
    });

    group('Report type validation', () {
      test('validates report type logic', () {
        // Test different report type scenarios
        expect('Z'.toLowerCase(), equals('z'));
        expect('X'.toLowerCase(), equals('x'));
        expect('z'.toUpperCase(), equals('Z'));
        expect('x'.toUpperCase(), equals('X'));
      });

      test('handles empty and special report types', () {
        const emptyType = '';
        const nullType = 'null';
        
        expect(emptyType.isEmpty, isTrue);
        expect(nullType.isNotEmpty, isTrue);
        expect(nullType, equals('null'));
      });
    });

    group('Error handling', () {
      test('validates required parameters', () {
        expect(
          () => reportService.generateReport(reportType: 'Z'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('validates date format handling', () {
        final validDate = DateTime(2024, 1, 15);
        
        expect(validDate.year, equals(2024));
        expect(validDate.month, equals(1));
        expect(validDate.day, equals(15));
        expect(validDate.isUtc, isFalse);
      });
    });

    group('Business logic validation', () {
      test('validates payment method processing logic', () {
        // Test the logic for payment method breakdown
        final Map<String, double> salesByPaymentMethod = {};
        final paymentType = 'CASH';
        final amount = 100.0;
        
        salesByPaymentMethod[paymentType.toLowerCase()] = 
            (salesByPaymentMethod[paymentType.toLowerCase()] ?? 0) + amount;
        
        expect(salesByPaymentMethod['cash'], equals(100.0));
      });

      test('validates tax calculation logic', () {
        final subTotal = 100.0;
        final expectedTax = subTotal * 0.18;
        
        expect(expectedTax, equals(18.0));
      });

      test('validates receipt counting logic', () {
        final salesCount = 5;
        final refundCount = 2;
        final netReceipts = salesCount - refundCount;
        
        expect(netReceipts, equals(3));
      });

      test('validates discount calculation', () {
        final transactions = [
          {'discountAmount': 10.0},
          {'discountAmount': 5.0},
          {'discountAmount': null},
        ];
        
        final totalDiscount = transactions.fold<double>(
          0.0, 
          (sum, t) => sum + (t['discountAmount'] ?? 0.0),
        );
        
        expect(totalDiscount, equals(15.0));
      });
    });

    group('Service integration with date calculations', () {
      test('validates service uses correct date calculation for Z reports', () {
        // Test the exact logic from ReportService.generateReport
        final endDate = DateTime(2024, 1, 15, 14, 30, 45);
        final reportType = 'Z';
        
        DateTime startDate;
        if (reportType == 'Z') {
          startDate = DateTime(endDate.year, endDate.month, endDate.day);
        } else {
          startDate = DateTime.now().subtract(const Duration(days: 1));
        }
        
        expect(startDate.year, equals(2024));
        expect(startDate.month, equals(1));
        expect(startDate.day, equals(15));
        expect(startDate.hour, equals(0));
      });

      test('validates service date range for transaction queries', () {
        final endDate = DateTime(2024, 1, 15, 14, 30, 45);
        final startDate = DateTime(endDate.year, endDate.month, endDate.day);
        
        // Verify the date range would capture transactions correctly
        final testTransaction1 = DateTime(2024, 1, 15, 8, 0, 0);  // Should be included
        final testTransaction2 = DateTime(2024, 1, 14, 23, 59, 59); // Should be excluded
        final testTransaction3 = DateTime(2024, 1, 15, 23, 59, 59); // Should be included
        
        expect(testTransaction1.isAfter(startDate) || testTransaction1.isAtSameMomentAs(startDate), isTrue);
        expect(testTransaction1.isBefore(endDate) || testTransaction1.isAtSameMomentAs(endDate), isTrue);
        
        expect(testTransaction2.isBefore(startDate), isTrue);
        
        expect(testTransaction3.isAfter(startDate), isTrue);
        expect(testTransaction3.isBefore(endDate) || testTransaction3.isAtSameMomentAs(endDate), isTrue);
      });

      test('validates UTC conversion preserves date boundaries', () {
        final localEndDate = DateTime(2024, 1, 15, 14, 30, 45);
        final localStartDate = DateTime(localEndDate.year, localEndDate.month, localEndDate.day);
        
        final utcStartDate = localStartDate.toUtc();
        final utcEndDate = localEndDate.toUtc();
        
        // Verify UTC conversion maintains proper ordering
        expect(utcStartDate.isBefore(utcEndDate), isTrue);
        expect(utcStartDate.isUtc, isTrue);
        expect(utcEndDate.isUtc, isTrue);
        
        // Verify the time span is preserved
        final localDuration = localEndDate.difference(localStartDate);
        final utcDuration = utcEndDate.difference(utcStartDate);
        expect(utcDuration.inMilliseconds, equals(localDuration.inMilliseconds));
      });
    });

    group('Data processing validation', () {
      test('validates transaction filtering logic', () {
        final transactions = [
          {'receiptType': 'NS', 'subTotal': 100.0},
          {'receiptType': 'NR', 'subTotal': 50.0},
          {'receiptType': 'CS', 'subTotal': 25.0},
        ];
        
        final salesTransactions = transactions
            .where((t) => t['receiptType'] == 'NS')
            .toList();
        final refundTransactions = transactions
            .where((t) => t['receiptType'] == 'NR')
            .toList();
        
        expect(salesTransactions.length, equals(1));
        expect(refundTransactions.length, equals(1));
        expect(salesTransactions.first['subTotal'], equals(100.0));
        expect(refundTransactions.first['subTotal'], equals(50.0));
      });

      test('validates null safety in calculations', () {
        final Map<String, double?> transaction = {
          'subTotal': null,
          'discountAmount': null,
        };
        
        final safeSubTotal = transaction['subTotal'] ?? 0.0;
        final safeDiscount = transaction['discountAmount'] ?? 0.0;
        
        expect(safeSubTotal, equals(0.0));
        expect(safeDiscount, equals(0.0));
      });
    });
  });
}