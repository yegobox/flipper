import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';

void main() {
  group('name helpers', () {
    test('fullName joins the parts it has', () {
      expect(employee(firstName: 'Aline', lastName: 'Uwase').fullName,
          'Aline Uwase');
      expect(employee(firstName: 'Aline', lastName: '').fullName, 'Aline');
      expect(employee(firstName: '', lastName: '').fullName, '');
    });

    test('initials use first and last, or two letters of a single name', () {
      expect(employee(firstName: 'Aline', lastName: 'Uwase').initials, 'AU');
      expect(employee(firstName: 'Aline', lastName: '').initials, 'AL');
      expect(employee(firstName: 'A', lastName: '').initials, 'A');
      expect(employee(firstName: '', lastName: '').initials, '');
    });
  });

  group('status', () {
    test('terminated is the only status that is not employed', () {
      expect(EmploymentStatus.active.isEmployed, isTrue);
      expect(EmploymentStatus.onLeave.isEmployed, isTrue);
      expect(EmploymentStatus.suspended.isEmployed, isTrue);
      expect(EmploymentStatus.terminated.isEmployed, isFalse);
    });
  });

  group('tenureDays', () {
    test('counts whole days since the start date', () {
      final e = employee(hireDate: DateTime(2026, 1, 1));
      expect(e.tenureDays(asOf: DateTime(2026, 1, 31)), 30);
    });

    test('a future start date is 0, never negative', () {
      final e = employee(hireDate: DateTime(2026, 9, 1));
      expect(e.tenureDays(asOf: DateTime(2026, 8, 17)), 0);
    });
  });

  group('monthlyCostEstimate', () {
    test('monthly pay is the base salary', () {
      expect(
        employee(baseSalary: 250000, payFrequency: PayFrequency.monthly)
            .monthlyCostEstimate,
        250000,
      );
    });

    test('weekly pay annualises over 52 weeks', () {
      expect(
        employee(baseSalary: 60000, payFrequency: PayFrequency.weekly)
            .monthlyCostEstimate,
        closeTo(260000, 0.01),
      );
    });

    test('daily pay uses the working-days assumption', () {
      expect(
        employee(baseSalary: 10000, payFrequency: PayFrequency.daily)
            .monthlyCostEstimate,
        10000 * Employee.workingDaysPerMonth,
      );
    });

    test('hourly pay uses hours per day and days per month', () {
      expect(
        employee(baseSalary: 1500, payFrequency: PayFrequency.hourly)
            .monthlyCostEstimate,
        1500 * Employee.workingHoursPerDay * Employee.workingDaysPerMonth,
      );
    });

    test('a terminated person costs nothing', () {
      expect(
        employee(
          baseSalary: 250000,
          status: EmploymentStatus.terminated,
          endDate: DateTime(2026, 5, 1),
        ).monthlyCostEstimate,
        0,
      );
    });
  });

  group('copyWith', () {
    test('clearEndDate removes a date that a plain null would keep', () {
      final terminated = employee(
        status: EmploymentStatus.terminated,
        endDate: DateTime(2026, 5, 1),
      );

      expect(terminated.copyWith(endDate: null).endDate, isNotNull);
      expect(terminated.copyWith(clearEndDate: true).endDate, isNull);
    });

    test('unspecified fields are preserved', () {
      final original = employee(nationalId: '1199080012345678');
      final renamed = original.copyWith(firstName: 'Alice');

      expect(renamed.nationalId, '1199080012345678');
      expect(renamed.baseSalary, original.baseSalary);
      expect(renamed.branchId, original.branchId);
    });
  });

  group('blank', () {
    test('is scoped to the branch and not yet persisted', () {
      final blank = Employee.blank(
        businessId: 'biz-1',
        branchId: 'branch-9',
        hireDate: DateTime(2026, 8, 17),
      );

      expect(blank.isPersisted, isFalse);
      expect(blank.branchId, 'branch-9');
      expect(blank.status, EmploymentStatus.active);
      expect(blank.currency, 'RWF');
    });
  });

  group('equality', () {
    test('compares by value', () {
      expect(employee(), employee());
      expect(employee().hashCode, employee().hashCode);
      expect(employee(firstName: 'Aline') == employee(firstName: 'Alice'),
          isFalse);
    });
  });
}
