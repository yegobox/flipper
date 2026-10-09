import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flutter_test/flutter_test.dart';

Employee _employee({
  PayFrequency frequency = PayFrequency.monthly,
  int? payDay,
  DateTime? hired,
  double salary = 200000,
}) => Employee(
  id: 'e-1',
  businessId: 'b-1',
  branchId: 'br-1',
  firstName: 'Aline',
  lastName: 'Uwase',
  hireDate: hired ?? DateTime(2025, 1, 1),
  baseSalary: salary,
  payFrequency: frequency,
  payDay: payDay,
);

Payslip _slip(
  DateTime start,
  DateTime end, {
  double net = 100,
  double paid = 0,
}) => Payslip(
  id: 's-${start.month}',
  employeeId: 'e-1',
  periodStart: start,
  periodEnd: end,
  currency: 'RWF',
  basePay: net,
  allowances: 0,
  extraEarnings: 0,
  gross: net,
  paye: 0,
  pensionEmployee: 0,
  maternityEmployee: 0,
  cbhi: 0,
  otherDeductions: 0,
  advanceRecovery: 0,
  netPay: net,
  pensionEmployer: 0,
  maternityEmployer: 0,
  occupationalHazards: 0,
  paidAmount: paid,
  status: paid >= net ? PayslipStatus.paid : PayslipStatus.unpaid,
);

Advance _advance(double amount, {double recovered = 0, double? step}) =>
    Advance(
      id: 'a-$amount',
      employeeId: 'e-1',
      amount: amount,
      currency: 'RWF',
      givenOn: DateTime(2026, 10, 3),
      method: PaymentMethod.cash,
      recovered: recovered,
      status: AdvanceStatus.open,
      installmentAmount: step,
    );

void main() {
  group('PayPeriod', () {
    test('monthly pay runs by calendar month', () {
      final p = PayPeriod.containing(
        PayFrequency.monthly,
        DateTime(2026, 2, 14),
      );
      expect(p.start, DateTime(2026, 2, 1));
      expect(p.end, DateTime(2026, 2, 28));
    });

    test('weekly and daily pay run Monday to Sunday', () {
      final p = PayPeriod.containing(PayFrequency.daily, DateTime(2026, 10, 8));
      expect(p.start, DateTime(2026, 10, 5));
      expect(p.end, DateTime(2026, 10, 11));
      expect(p.days, 7);
    });

    test('a pay day past the end of a short month falls on its last day', () {
      final feb = PayPeriod.containing(
        PayFrequency.monthly,
        DateTime(2026, 2, 1),
      );
      expect(feb.payDate(PayFrequency.monthly, 31), DateTime(2026, 2, 28));
      expect(feb.payDate(PayFrequency.monthly, 25), DateTime(2026, 2, 25));
      expect(feb.payDate(PayFrequency.monthly, null), DateTime(2026, 2, 28));
    });
  });

  group('EmployeePayAccount', () {
    test('before any payslip, only the latest pay day is due', () {
      // Starting payroll today must not open on three months of "overdue":
      // the months before were paid outside the app.
      final account = EmployeePayAccount(
        employee: _employee(payDay: 25),
        payslips: const [],
        payments: const [],
        advances: const [],
        today: DateTime(2026, 10, 26),
      );
      expect(account.isDue, isTrue);
      expect(account.nextPeriod.start, DateTime(2026, 10, 1));
    });

    test('after a payslip, a skipped month stays due until paid', () {
      final account = EmployeePayAccount(
        employee: _employee(payDay: 25),
        payslips: [
          _slip(DateTime(2026, 7, 1), DateTime(2026, 7, 31)),
          _slip(DateTime(2026, 8, 1), DateTime(2026, 8, 31)),
        ],
        payments: const [],
        advances: const [],
        today: DateTime(2026, 10, 26),
      );
      expect(account.nextPeriod.start, DateTime(2026, 9, 1));
    });

    test('nothing is due before the pay day, or before the hire date', () {
      final account = EmployeePayAccount(
        employee: _employee(payDay: 25, hired: DateTime(2026, 10, 1)),
        payslips: const [],
        payments: const [],
        advances: const [],
        today: DateTime(2026, 10, 20),
      );
      expect(account.isDue, isFalse);
      expect(account.nextPeriod.start, DateTime(2026, 10, 1));
      expect(account.daysToPay, 5);
    });

    test('advance balance and the suggested recovery', () {
      final account = EmployeePayAccount(
        employee: _employee(),
        payslips: const [],
        payments: const [],
        advances: [
          _advance(30000, recovered: 10000),
          _advance(50000, step: 10000),
        ],
        today: DateTime(2026, 10, 26),
      );
      expect(account.advanceBalance, 70000);
      expect(
        account.openAdvances.map((a) => a.suggestedRecovery),
        containsAll([20000.0, 10000.0]),
      );
    });

    test('money paid during a period counts every kind of payment', () {
      final account = EmployeePayAccount(
        employee: _employee(),
        payslips: const [],
        payments: [
          PayPayment(
            id: 'p1',
            employeeId: 'e-1',
            kind: PaymentKind.advance,
            amount: 20000,
            currency: 'RWF',
            paidOn: DateTime(2026, 10, 3),
            method: PaymentMethod.cash,
          ),
          PayPayment(
            id: 'p2',
            employeeId: 'e-1',
            kind: PaymentKind.other,
            amount: 5000,
            currency: 'RWF',
            paidOn: DateTime(2026, 9, 30),
            method: PaymentMethod.cash,
          ),
          PayPayment(
            id: 'p3',
            employeeId: 'e-1',
            kind: PaymentKind.other,
            amount: 999,
            currency: 'RWF',
            paidOn: DateTime(2026, 10, 4),
            method: PaymentMethod.cash,
            voided: true,
          ),
        ],
        advances: const [],
        today: DateTime(2026, 10, 26),
      );
      final october = PayPeriod.containing(
        PayFrequency.monthly,
        DateTime(2026, 10, 1),
      );
      expect(account.paidDuring(october), 20000);
      expect(account.lastPayment?.id, 'p1');
    });
  });
}
