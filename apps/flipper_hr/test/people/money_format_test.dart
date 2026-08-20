import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatNumber', () {
    test('groups thousands', () {
      expect(formatNumber(0), '0');
      expect(formatNumber(999), '999');
      expect(formatNumber(1000), '1,000');
      expect(formatNumber(250000), '250,000');
      expect(formatNumber(1250000), '1,250,000');
    });

    test('shows cents only when there are any', () {
      expect(formatNumber(1500.5), '1,500.50');
      expect(formatNumber(1500.05), '1,500.05');
      expect(formatNumber(1500.0), '1,500');
    });

    test('rounds to two places', () {
      expect(formatNumber(0.005), '0.01');
      expect(formatNumber(1234.567), '1,234.57');
    });

    test('keeps the sign in front of the grouping', () {
      expect(formatNumber(-1250000), '-1,250,000');
    });
  });

  group('formatMoney', () {
    test('prefixes the currency', () {
      expect(formatMoney(250000, 'RWF'), 'RWF 250,000');
      expect(formatMoney(250000, 'USD'), 'USD 250,000');
    });

    test('omits the prefix when there is no currency', () {
      expect(formatMoney(250000, ''), '250,000');
    });
  });

  group('formatCompactMoney', () {
    test('abbreviates millions and thousands', () {
      expect(formatCompactMoney(1250000, 'RWF'), 'RWF 1.3M');
      expect(formatCompactMoney(2000000, 'RWF'), 'RWF 2M');
      expect(formatCompactMoney(48000, 'RWF'), 'RWF 48K');
    });

    test('shows small amounts in full', () {
      expect(formatCompactMoney(9500, 'RWF'), 'RWF 9,500');
      expect(formatCompactMoney(0, 'RWF'), 'RWF 0');
    });
  });

  group('formatShortDate', () {
    test('reads as day, month, year', () {
      expect(formatShortDate(DateTime(2026, 3, 4)), '4 Mar 2026');
      expect(formatShortDate(DateTime(2026, 12, 31)), '31 Dec 2026');
    });
  });

  group('formatTenure', () {
    final asOf = DateTime(2026, 8, 17);

    test('days under a month', () {
      expect(
        formatTenure(hireDate: DateTime(2026, 8, 1), asOf: asOf),
        '16 d',
      );
    });

    test('months under a year', () {
      expect(
        formatTenure(hireDate: DateTime(2026, 3, 17), asOf: asOf),
        '5 mo',
      );
    });

    test('years, with months when there are any', () {
      expect(
        formatTenure(hireDate: DateTime(2023, 8, 17), asOf: asOf),
        '3 yr',
      );
      expect(
        formatTenure(hireDate: DateTime(2023, 6, 17), asOf: asOf),
        '3 yr 2 mo',
      );
    });

    test('a part-month does not round up', () {
      // One day short of a full month.
      expect(
        formatTenure(hireDate: DateTime(2026, 7, 18), asOf: asOf),
        '30 d',
      );
    });

    test('a future start date announces the start instead', () {
      expect(
        formatTenure(hireDate: DateTime(2026, 9, 1), asOf: asOf),
        'Starts 1 Sep 2026',
      );
    });
  });
}
