import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_row_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> row([Map<String, dynamic> overrides = const {}]) => {
    'id': 'emp-1',
    'business_id': 'biz-1',
    'branch_id': 'branch-1',
    'first_name': 'Aline',
    'last_name': 'Uwase',
    'phone': '0788123456',
    'email': 'aline@example.rw',
    'job_title': 'Cashier',
    'department': 'Retail',
    'employment_type': 'full_time',
    'status': 'on_leave',
    'hire_date': '2025-03-04',
    'end_date': null,
    'national_id': '1199080012345678',
    'rssb_number': 'RSSB-99',
    'base_salary': 250000,
    'currency': 'RWF',
    'pay_frequency': 'monthly',
    'payment_method': 'mobile_money',
    'momo_phone': '0788999888',
    'bank_name': null,
    'bank_account': null,
    'user_id': null,
    'notes': null,
    'created_at': '2026-01-02T08:30:00.000Z',
    'updated_at': '2026-01-03T09:00:00.000Z',
    ...overrides,
  };

  group('fromRow', () {
    test('reads a full row', () {
      final e = EmployeeRowMapper.fromRow(row());

      expect(e.id, 'emp-1');
      expect(e.fullName, 'Aline Uwase');
      expect(e.branchId, 'branch-1');
      expect(e.status, EmploymentStatus.onLeave);
      expect(e.type, EmploymentType.fullTime);
      expect(e.hireDate, DateTime(2025, 3, 4));
      expect(e.endDate, isNull);
      expect(e.baseSalary, 250000);
      expect(e.paymentMethod, PaymentMethod.mobileMoney);
      expect(e.momoPhone, '0788999888');
      expect(e.createdAt, DateTime.utc(2026, 1, 2, 8, 30));
      expect(e.isPersisted, isTrue);
    });

    test('nulls become empty strings, not "null"', () {
      final e = EmployeeRowMapper.fromRow(
        row({'email': null, 'notes': null, 'department': null}),
      );

      expect(e.email, '');
      expect(e.notes, '');
      expect(e.department, '');
      expect(e.userId, isNull);
    });

    test('numeric salary arrives as int, double or string', () {
      expect(EmployeeRowMapper.fromRow(row({'base_salary': 3})).baseSalary, 3);
      expect(
        EmployeeRowMapper.fromRow(row({'base_salary': 3.5})).baseSalary,
        3.5,
      );
      expect(
        EmployeeRowMapper.fromRow(row({'base_salary': '1250.75'})).baseSalary,
        1250.75,
      );
    });

    test('an unparseable salary reads as 0 rather than hiding the row', () {
      expect(
        EmployeeRowMapper.fromRow(row({'base_salary': 'n/a'})).baseSalary,
        0,
      );
    });

    test('unknown enum values fall back instead of throwing', () {
      final e = EmployeeRowMapper.fromRow(
        row({
          'status': 'probation',
          'employment_type': 'seasonal',
          'pay_frequency': 'fortnightly',
          'payment_method': 'crypto',
        }),
      );

      expect(e.status, EmploymentStatus.active);
      expect(e.type, EmploymentType.fullTime);
      expect(e.payFrequency, PayFrequency.monthly);
      expect(e.paymentMethod, PaymentMethod.mobileMoney);
    });

    test('enum values are matched regardless of separator or case', () {
      expect(
        EmployeeRowMapper.fromRow(row({'status': 'onLeave'})).status,
        EmploymentStatus.onLeave,
      );
      expect(
        EmployeeRowMapper.fromRow(row({'status': 'On Leave'})).status,
        EmploymentStatus.onLeave,
      );
    });

    test('a timestamp in hire_date still reads as a plain date', () {
      final e = EmployeeRowMapper.fromRow(
        row({'hire_date': '2025-03-04T22:00:00.000Z'}),
      );
      expect(e.hireDate.year, 2025);
      expect(e.hireDate.hour, 0);
    });

    test('a missing hire_date does not throw', () {
      final e = EmployeeRowMapper.fromRow(row({'hire_date': null}));
      expect(e.hireDate.year, 1970);
    });

    test('a blank currency falls back to RWF', () {
      expect(EmployeeRowMapper.fromRow(row({'currency': null})).currency, 'RWF');
      expect(EmployeeRowMapper.fromRow(row({'currency': ''})).currency, 'RWF');
    });
  });

  group('write rows', () {
    test('insert omits id and created_at so Postgres owns them', () {
      final insert = EmployeeRowMapper.toInsertRow(
        EmployeeRowMapper.fromRow(row()),
        now: DateTime.utc(2026, 5, 1),
      );

      expect(insert.containsKey('id'), isFalse);
      expect(insert.containsKey('created_at'), isFalse);
      expect(insert['updated_at'], '2026-05-01T00:00:00.000Z');
      expect(insert['branch_id'], 'branch-1');
    });

    test('dates are written date-only', () {
      final insert = EmployeeRowMapper.toInsertRow(
        EmployeeRowMapper.fromRow(row({'end_date': '2026-02-09'})),
      );

      expect(insert['hire_date'], '2025-03-04');
      expect(insert['end_date'], '2026-02-09');
    });

    test('blank optional text is written as null, not an empty string', () {
      final e = EmployeeRowMapper.fromRow(row()).copyWith(
        email: '   ',
        nationalId: '',
        bankName: '',
        notes: '',
      );
      final update = EmployeeRowMapper.toUpdateRow(e);

      expect(update['email'], isNull);
      expect(update['national_id'], isNull);
      expect(update['bank_name'], isNull);
      expect(update['notes'], isNull);
      // Required columns stay strings so the NOT NULL defaults hold.
      expect(update['first_name'], 'Aline');
      expect(update['department'], 'Retail');
    });

    test('names are trimmed on the way out', () {
      final e = EmployeeRowMapper.fromRow(
        row({'first_name': '  Aline ', 'last_name': ' Uwase  '}),
      );
      final update = EmployeeRowMapper.toUpdateRow(e);

      expect(update['first_name'], 'Aline');
      expect(update['last_name'], 'Uwase');
    });

    test('round-trips through Postgres shape without drift', () {
      final original = EmployeeRowMapper.fromRow(row());
      final written = EmployeeRowMapper.toUpdateRow(original);
      // Postgres would echo the row back with its id and created_at intact.
      final echoed = EmployeeRowMapper.fromRow({
        ...written,
        'id': original.id,
        'created_at': original.createdAt?.toIso8601String(),
      });

      expect(echoed.copyWith(updatedAt: original.updatedAt), original);
    });

    test('enum values are written as their wire strings', () {
      final e = EmployeeRowMapper.fromRow(row()).copyWith(
        status: EmploymentStatus.terminated,
        type: EmploymentType.partTime,
        payFrequency: PayFrequency.hourly,
        paymentMethod: PaymentMethod.bankTransfer,
      );
      final update = EmployeeRowMapper.toUpdateRow(e);

      expect(update['status'], 'terminated');
      expect(update['employment_type'], 'part_time');
      expect(update['pay_frequency'], 'hourly');
      expect(update['payment_method'], 'bank_transfer');
    });
  });

  group('formatDate', () {
    test('pads month and day', () {
      expect(EmployeeRowMapper.formatDate(DateTime(2026, 2, 9)), '2026-02-09');
      expect(EmployeeRowMapper.formatDate(DateTime(2026, 12, 31)),
          '2026-12-31');
    });
  });
}
