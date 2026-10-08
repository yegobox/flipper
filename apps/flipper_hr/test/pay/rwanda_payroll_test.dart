import 'package:flipper_hr/features/pay/data/rwanda_payroll.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flutter_test/flutter_test.dart';

PayslipFigures _month(
  double gross, {
  TaxCategory tax = TaxCategory.primary,
  bool rssb = true,
  int year = 2026,
  double allowances = 0,
}) => computeRwandaPayslip(
  PayslipInput(
    basePay: gross - allowances,
    allowances: allowances,
    periodStart: DateTime(year, 10, 1),
    periodEnd: DateTime(year, 10, 31),
    taxCategory: tax,
    rssbEnrolled: rssb,
  ),
);

void main() {
  group('PAYE bands (Law 027/2022)', () {
    test('nothing up to 60,000', () {
      expect(_month(60000).paye, 0);
    });

    test('10% between 60,000 and 100,000', () {
      expect(_month(100000).paye, 4000);
    });

    test('20% between 100,000 and 200,000', () {
      expect(_month(200000).paye, 24000);
    });

    test('30% above 200,000', () {
      expect(_month(300000).paye, 54000);
    });

    test('casual labourers pay 15% above 60,000 only', () {
      expect(_month(100000, tax: TaxCategory.casual).paye, 6000);
      expect(_month(50000, tax: TaxCategory.casual).paye, 0);
    });

    test('a second employer withholds 30% of everything', () {
      expect(_month(100000, tax: TaxCategory.secondary).paye, 30000);
    });
  });

  group('a 200,000 monthly salary in 2026', () {
    final f = _month(200000);

    test('employee deductions', () {
      expect(f.pensionEmployee, 12000); // 6%
      expect(f.maternityEmployee, 600); // 0.3%
      // 0.5% of what is left after PAYE, pension and maternity.
      expect(f.cbhi, 817); // 0.5% × 163,400
    });

    test('net pay adds up', () {
      expect(f.netBeforeRecovery, 200000 - 24000 - 12000 - 600 - 817);
      expect(f.netBeforeRecovery, 162583);
    });

    test('employer contributions', () {
      expect(f.pensionEmployer, 12000);
      expect(f.maternityEmployer, 600);
      expect(f.occupationalHazards, 4000); // 2%
      expect(f.employerCost, 216600);
    });

    test(
      'at most half of pay after compulsory deductions can be recovered',
      () {
        // 0.5 × (200,000 − 37,417) = 81,291.5, rounded down.
        expect(f.maxRecovery, 81291);
        expect(f.netAfter(20000), 142583);
      },
    );

    test('uses the 2025 rate set', () {
      expect(f.rates.version, 'RW-2025-01');
    });
  });

  test('pension rises to 7% each side in 2027', () {
    final f = _month(200000, year: 2027);
    expect(f.rates.version, 'RW-2027-01');
    expect(f.pensionEmployee, 14000);
    expect(f.pensionEmployer, 14000);
  });

  test('allowances are taxed and pensioned but not in the maternity base', () {
    final f = _month(200000, allowances: 50000);
    expect(f.gross, 200000);
    expect(f.paye, 24000);
    expect(f.pensionEmployee, 12000);
    expect(f.maternityEmployee, 450); // 0.3% × 150,000
  });

  test('someone not enrolled with RSSB pays PAYE and CBHI only', () {
    final f = _month(200000, rssb: false);
    expect(f.pensionEmployee, 0);
    expect(f.maternityEmployee, 0);
    expect(f.employerContributions, 0);
    expect(f.cbhi, 880); // 0.5% × 176,000
  });

  test('a weekly period has its PAYE bands shrunk to the week', () {
    final f = computeRwandaPayslip(
      PayslipInput(
        basePay: 30000,
        periodStart: DateTime(2026, 10, 5),
        periodEnd: DateTime(2026, 10, 11),
      ),
    );
    // Bands × 7/30: 14,000 / 23,333 / 46,667.
    expect(f.paye, 2267);
  });

  group('periodBandFactor', () {
    test('a whole calendar month is 1, whatever its length', () {
      expect(periodBandFactor(DateTime(2026, 2, 1), DateTime(2026, 2, 28)), 1);
      expect(periodBandFactor(DateTime(2026, 1, 1), DateTime(2026, 1, 31)), 1);
    });

    test('a week is 7/30', () {
      expect(
        periodBandFactor(DateTime(2026, 10, 5), DateTime(2026, 10, 11)),
        closeTo(7 / 30, 1e-9),
      );
    });
  });
}
