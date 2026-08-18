import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_validation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';

void main() {
  final today = DateTime(2026, 8, 17);

  Map<EmployeeField, String> validate(Employee e) =>
      validateEmployee(e, today: today);

  test('a complete record has no errors', () {
    expect(validate(employee()), isEmpty);
  });

  group('required fields', () {
    test('first name, last name and job title are required', () {
      final errors = validate(
        employee(firstName: '  ', lastName: '', jobTitle: ''),
      );

      expect(errors[EmployeeField.firstName], 'First name is required');
      expect(errors[EmployeeField.lastName], 'Last name is required');
      expect(errors[EmployeeField.jobTitle], 'Job title is required');
    });

    test('department and email are optional', () {
      expect(validate(employee(department: '', email: '')), isEmpty);
    });
  });

  group('phone', () {
    test('is required', () {
      expect(
        validate(employee(phone: ''))[EmployeeField.phone],
        'Phone number is required',
      );
    });

    test('needs at least nine digits', () {
      expect(
        validate(employee(phone: '0788'))[EmployeeField.phone],
        contains('at least 9 digits'),
      );
    });

    test('accepts formatting and country codes', () {
      expect(validate(employee(phone: '+250 788 123 456')), isEmpty);
      expect(validate(employee(phone: '078-812-3456')), isEmpty);
    });
  });

  group('email', () {
    test('is checked only when present', () {
      expect(validate(employee(email: '')), isEmpty);
      expect(
        validate(employee(email: 'not-an-email'))[EmployeeField.email],
        'Enter a valid email address',
      );
      expect(
        validate(employee(email: 'aline@example'))[EmployeeField.email],
        isNotNull,
      );
      expect(validate(employee(email: 'aline@example.rw')), isEmpty);
    });
  });

  group('national ID', () {
    test('is optional', () {
      expect(validate(employee(nationalId: '')), isEmpty);
    });

    test('must be 16 digits when given', () {
      expect(
        validate(employee(nationalId: '123'))[EmployeeField.nationalId],
        'A national ID has 16 digits',
      );
      expect(validate(employee(nationalId: '1199080012345678')), isEmpty);
      // Spaces are tolerated; the digit count is what matters.
      expect(validate(employee(nationalId: '1199 0800 1234 5678')), isEmpty);
    });
  });

  group('dates', () {
    test('a start date within a year ahead is accepted', () {
      expect(validate(employee(hireDate: DateTime(2026, 12, 1))), isEmpty);
    });

    test('a start date further ahead is rejected as a typo', () {
      expect(
        validate(employee(hireDate: DateTime(2036, 1, 1)))[
            EmployeeField.hireDate],
        'Start date cannot be more than a year ahead',
      );
    });

    test('a past start date is always fine', () {
      expect(validate(employee(hireDate: DateTime(2001, 1, 1))), isEmpty);
    });

    test('the last day cannot precede the start date', () {
      final errors = validate(
        employee(hireDate: DateTime(2026, 5, 1), endDate: DateTime(2026, 4, 1)),
      );
      expect(
        errors[EmployeeField.endDate],
        'Last day cannot be before the start date',
      );
    });

    test('the same day for start and end is allowed', () {
      expect(
        validate(
          employee(
            hireDate: DateTime(2026, 5, 1),
            endDate: DateTime(2026, 5, 1),
          ),
        ),
        isEmpty,
      );
    });

    test('terminating requires a last day', () {
      expect(
        validate(employee(status: EmploymentStatus.terminated))[
            EmployeeField.endDate],
        'A last day is required to terminate',
      );
      expect(
        validate(
          employee(
            status: EmploymentStatus.terminated,
            endDate: DateTime(2026, 7, 1),
          ),
        ),
        isEmpty,
      );
    });
  });

  group('pay', () {
    test('cannot be negative', () {
      expect(
        validate(employee(baseSalary: -1))[EmployeeField.baseSalary],
        'Pay cannot be negative',
      );
    });

    test('zero is allowed — interns and volunteers exist', () {
      expect(validate(employee(baseSalary: 0)), isEmpty);
    });
  });

  group('payment details', () {
    test('mobile money falls back to the contact number', () {
      expect(
        validate(
          employee(
            paymentMethod: PaymentMethod.mobileMoney,
            phone: '0788123456',
            momoPhone: '',
          ),
        ),
        isEmpty,
      );
    });

    test('a mobile money number that is given must be long enough', () {
      expect(
        validate(
          employee(
            paymentMethod: PaymentMethod.mobileMoney,
            momoPhone: '0788',
          ),
        )[EmployeeField.momoPhone],
        contains('at least 9 digits'),
      );
    });

    test('mobile money needs a number when there is no usable phone', () {
      final errors = validate(
        employee(
          paymentMethod: PaymentMethod.mobileMoney,
          phone: '',
          momoPhone: '',
        ),
      );
      expect(errors[EmployeeField.momoPhone], 'Mobile money number is required');
      expect(errors[EmployeeField.phone], 'Phone number is required');
    });

    test('bank transfer needs a bank and an account number', () {
      final errors = validate(
        employee(paymentMethod: PaymentMethod.bankTransfer),
      );
      expect(errors[EmployeeField.bankName], 'Bank name is required');
      expect(errors[EmployeeField.bankAccount], 'Account number is required');
    });

    test('cash needs no payment details', () {
      expect(
        validate(employee(paymentMethod: PaymentMethod.cash)),
        isEmpty,
      );
    });
  });

  group('annual leave entitlement', () {
    test('blank means the statutory default, so it is not an error', () {
      expect(
        validate(employee(annualLeaveDays: null)),
        isNot(contains(EmployeeField.annualLeaveDays)),
      );
    });

    test('zero is allowed — it means no annual leave, deliberately', () {
      expect(
        validate(employee(annualLeaveDays: 0)),
        isNot(contains(EmployeeField.annualLeaveDays)),
      );
    });

    test('a better contract entitlement is fine', () {
      expect(
        validate(employee(annualLeaveDays: 25)),
        isNot(contains(EmployeeField.annualLeaveDays)),
      );
    });

    test('a negative entitlement is rejected', () {
      expect(
        validate(employee(annualLeaveDays: -1)),
        contains(EmployeeField.annualLeaveDays),
      );
    });

    test('more than a working year reads as hours typed as days', () {
      expect(
        validate(employee(annualLeaveDays: 1440))[
            EmployeeField.annualLeaveDays],
        contains('days, not hours'),
      );
    });
  });
}
