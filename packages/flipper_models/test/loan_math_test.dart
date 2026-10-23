import 'package:flipper_models/personal_loans/loan_math.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flutter_test/flutter_test.dart';

PersonalLoan _loan({
  double? payment,
  double? rate,
  double? principal,
  DateTime? start,
  DateTime? end,
  int? term,
  double? balance,
  DateTime? balanceAt,
  DateTime? createdAt,
  DateTime? closedAt,
}) => PersonalLoan(
  id: 'l1',
  businessId: 'b',
  branchId: 'br',
  lender: 'BK',
  monthlyPayment: payment,
  annualRatePct: rate,
  principal: principal,
  startDate: start,
  endDate: end,
  termMonths: term,
  balance: balance,
  balanceAt: balanceAt,
  createdAt: createdAt ?? DateTime(2026, 1, 10),
  closedAt: closedAt,
);

PersonalLoanPayment _pay(double amount, DateTime at) => PersonalLoanPayment(
  id: 'p${at.millisecondsSinceEpoch}',
  loanId: 'l1',
  businessId: 'b',
  amount: amount,
  paidAt: at,
);

void main() {
  group('installments', () {
    test('match the bank formula', () {
      // 1,000,000 over 12 months at 12%/year: 88,848.79 a month.
      expect(
        installmentFor(principal: 1000000, annualRatePct: 12, months: 12),
        closeTo(88848.79, 0.01),
      );
      expect(
        installmentFor(principal: 1200000, annualRatePct: 0, months: 12),
        100000,
      );
    });

    test('present value is the inverse', () {
      final m = installmentFor(
        principal: 500000,
        annualRatePct: 16,
        months: 24,
      );
      expect(
        presentValue(payment: m, annualRatePct: 16, months: 24),
        closeTo(500000, 0.01),
      );
    });

    test('the installment is derived from amount and term', () {
      expect(effectiveInstallment(_loan(principal: 1200000, term: 12)), 100000);
      expect(
        effectiveInstallment(
          _loan(
            principal: 1200000,
            start: DateTime(2026, 1, 1),
            end: DateTime(2027, 1, 1),
          ),
        ),
        100000,
      );
      expect(effectiveInstallment(_loan(payment: 50000, principal: 1)), 50000);
      expect(effectiveInstallment(_loan()), isNull);
    });
  });

  group('balance', () {
    test('no interest: borrowed minus repaid', () {
      final loan = _loan(principal: 300000, start: DateTime(2026, 1, 1));
      final b = loanBalance(loan, [
        _pay(100000, DateTime(2026, 2, 1)),
        _pay(50000, DateTime(2026, 3, 1)),
      ], DateTime(2026, 3, 15));
      expect(b, 150000);
    });

    test('with interest, on schedule, the balance follows the bank table', () {
      final m = installmentFor(
        principal: 1000000,
        annualRatePct: 12,
        months: 12,
      );
      final loan = _loan(
        principal: 1000000,
        rate: 12,
        payment: m,
        start: DateTime(2026, 1, 1),
      );
      final payments = [
        for (var k = 1; k <= 12; k++)
          _pay(
            m,
            addMonths(DateTime(2026, 1, 1), k).add(const Duration(hours: 1)),
          ),
      ];
      // After all 12 installments it is cleared (within rounding).
      expect(loanBalance(loan, payments, DateTime(2027, 1, 5))!, lessThan(m));
    });

    test('a balance the user entered wins', () {
      final loan = _loan(
        principal: 5000000,
        start: DateTime(2024, 1, 1),
        balance: 1200000,
        balanceAt: DateTime(2026, 3, 1),
      );
      expect(loanBalance(loan, const [], DateTime(2026, 3, 2)), 1200000);
    });

    test('"I pay X until Y" estimates the balance from the schedule', () {
      // 150,000 a month, no interest, 20 months left when added.
      final loan = _loan(
        payment: 150000,
        end: DateTime(2027, 9, 10),
        createdAt: DateTime(2026, 1, 10),
      );
      final anchor = loanAnchor(loan)!;
      expect(anchor.estimated, isTrue);
      expect(anchor.amount, 150000 * 20);
      final status = loanStatus(loan, const [], DateTime(2026, 1, 20));
      expect(status.estimated, isTrue);
      expect(status.outlook!.monthsLeft, 20);
    });

    test('nothing to go on gives no balance', () {
      expect(
        loanBalance(_loan(payment: 10000), const [], DateTime(2026, 2, 1)),
        isNull,
      );
    });
  });

  group('outlook', () {
    test('months left, payoff date and interest still to pay', () {
      final o = loanOutlook(
        balance: 1000000,
        payment: installmentFor(
          principal: 1000000,
          annualRatePct: 12,
          months: 12,
        ),
        annualRatePct: 12,
        now: DateTime(2026, 1, 15),
      );
      expect(o.monthsLeft, 12);
      expect(o.payoffDate, DateTime(2027, 1, 15));
      expect(o.interestLeft, closeTo(66185.5, 1));
      expect(o.neverEnds, isFalse);
    });

    test('a payment below the interest never clears the loan', () {
      final o = loanOutlook(
        balance: 1000000,
        payment: 5000,
        annualRatePct: 12,
        now: DateTime(2026, 1, 1),
      );
      expect(o.neverEnds, isTrue);
      expect(o.monthsLeft, isNull);
    });

    test('a month with no repayment recorded is due', () {
      final loan = _loan(
        payment: 100000,
        principal: 500000,
        start: DateTime(2026, 1, 1),
      );
      expect(
        loanStatus(loan, const [], DateTime(2026, 3, 10)).repaymentDue,
        isTrue,
      );
      expect(
        loanStatus(loan, [
          _pay(100000, DateTime(2026, 3, 2)),
        ], DateTime(2026, 3, 10)).repaymentDue,
        isFalse,
      );
      final closed = _loan(
        payment: 100000,
        principal: 500000,
        start: DateTime(2026, 1, 1),
        closedAt: DateTime(2026, 2, 1),
      );
      expect(
        loanStatus(closed, const [], DateTime(2026, 3, 10)).repaymentDue,
        isFalse,
      );
    });

    test('the overview adds open loans only', () {
      final now = DateTime(2026, 3, 10);
      final a = loanStatus(
        _loan(payment: 100000, principal: 400000, start: DateTime(2026, 3, 1)),
        const [],
        now,
      );
      final closed = loanStatus(
        _loan(
          payment: 50000,
          principal: 400000,
          start: DateTime(2026, 3, 1),
          closedAt: DateTime(2026, 3, 5),
        ),
        const [],
        now,
      );
      final o = loansOverview([a, closed]);
      expect(o.totalOwed, 400000);
      expect(o.monthlyPayments, 100000);
      expect(o.lastPayoff, DateTime(2026, 7, 10));
    });
  });

  group('affordability', () {
    final now = DateTime(2026, 3, 10);
    AffordabilityCheck check({
      double income = 1000000,
      double spending = 500000,
      double existing = 100000,
    }) => affordability(
      amount: 1200000,
      annualRatePct: 0,
      months: 12,
      existingInstallments: existing,
      avgIncome: income,
      avgSpending: spending,
      now: now,
    );

    test('a new installment that fits is comfortable or tight by share', () {
      final c = check(existing: 0);
      expect(c.newInstallment, 100000);
      expect(c.leftOver, 400000);
      expect(c.debtShare, closeTo(0.10, 1e-9));
      expect(c.verdict, Affordability.comfortable);
      expect(check(existing: 250000).verdict, Affordability.tight);
      expect(
        check(existing: 350000, spending: 100000).verdict,
        Affordability.risky,
      );
    });

    test('nothing left at month end is not covered', () {
      expect(check(spending: 850000).verdict, Affordability.notCovered);
    });

    test('no income recorded cannot be judged', () {
      expect(check(income: 0).verdict, Affordability.unknown);
    });
  });
}
