import 'package:flipper_models/helpers/sale_personal_goal_auto_allocation.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:test/test.dart';

void main() {
  group('shouldAttemptPersonalGoalSaleSweep', () {
    test('true for completed sale with line items', () {
      expect(
        shouldAttemptPersonalGoalSaleSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: false,
          transactionType: kSaleTransactionType,
          hasProductLineItems: true,
        ),
        isTrue,
      );
    });

    test('false when not completed', () {
      expect(
        shouldAttemptPersonalGoalSaleSweep(
          completionStatus: 'pending',
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: false,
          transactionType: kSaleTransactionType,
          hasProductLineItems: true,
        ),
        isFalse,
      );
    });

    test('false for cash in category', () {
      expect(
        shouldAttemptPersonalGoalSaleSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: false,
          transactionType: 'Cash In',
          hasProductLineItems: true,
        ),
        isFalse,
      );
    });

    test('false when no line items', () {
      expect(
        shouldAttemptPersonalGoalSaleSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: false,
          transactionType: kSaleTransactionType,
          hasProductLineItems: false,
        ),
        isFalse,
      );
    });

    test('false in training or proforma', () {
      expect(
        shouldAttemptPersonalGoalSaleSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: true,
          isTrainingMode: false,
          transactionType: kSaleTransactionType,
          hasProductLineItems: true,
        ),
        isFalse,
      );
      expect(
        shouldAttemptPersonalGoalSaleSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: true,
          transactionType: kSaleTransactionType,
          hasProductLineItems: true,
        ),
        isFalse,
      );
    });
  });

  group('shouldAttemptPersonalGoalUtilityCashInSweep', () {
    test('true for completed utility cash-in with positive amount', () {
      expect(
        shouldAttemptPersonalGoalUtilityCashInSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: false,
          isUtilityCashbookMovement: true,
          movementSubTotal: 500,
        ),
        isTrue,
      );
    });

    test('false when not utility movement', () {
      expect(
        shouldAttemptPersonalGoalUtilityCashInSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: false,
          isUtilityCashbookMovement: false,
          movementSubTotal: 500,
        ),
        isFalse,
      );
    });

    test('false for cash out (not income)', () {
      expect(
        shouldAttemptPersonalGoalUtilityCashInSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: false,
          isProformaMode: false,
          isTrainingMode: false,
          isUtilityCashbookMovement: true,
          movementSubTotal: 500,
        ),
        isFalse,
      );
    });

    test('false when subtotal is zero', () {
      expect(
        shouldAttemptPersonalGoalUtilityCashInSweep(
          completionStatus: kCompletedTransactionStatus,
          isIncome: true,
          isProformaMode: false,
          isTrainingMode: false,
          isUtilityCashbookMovement: true,
          movementSubTotal: 0,
        ),
        isFalse,
      );
    });
  });

  group('computeSaleGrossProfitFromSaleLines', () {
    test('revenue minus supply price at sale', () {
      final profit = computeSaleGrossProfitFromSaleLines([
        const SaleLineForProfit(price: 100, qty: 2, supplyPriceAtSale: 30),
      ]);
      expect(profit, 140);
    });

    test('falls back to supplyPrice when at-sale missing', () {
      final profit = computeSaleGrossProfitFromSaleLines([
        const SaleLineForProfit(price: 50, qty: 1, supplyPrice: 20),
      ]);
      expect(profit, 30);
    });

    test('skips ignoreForReport and partOfComposite lines', () {
      final profit = computeSaleGrossProfitFromSaleLines([
        const SaleLineForProfit(price: 100, qty: 1, supplyPriceAtSale: 40),
        const SaleLineForProfit(
          price: 999,
          qty: 1,
          supplyPriceAtSale: 0,
          ignoreForReport: true,
        ),
        const SaleLineForProfit(
          price: 999,
          qty: 1,
          supplyPriceAtSale: 0,
          partOfComposite: true,
        ),
      ]);
      expect(profit, 60);
    });

    test('gross profit zero when supply matches retail (no allocation w/o revenue fallback)', () {
      final profit = computeSaleGrossProfitFromSaleLines([
        const SaleLineForProfit(
          price: 100,
          qty: 1,
          supplyPriceAtSale: 100,
        ),
      ]);
      expect(profit, 0);
      final revenue = computeSaleLineRevenueForPersonalGoals([
        const SaleLineForProfit(
          price: 100,
          qty: 1,
          supplyPriceAtSale: 100,
        ),
      ]);
      expect(revenue, 100);
    });
  });

  group('computeSaleLineRevenueForPersonalGoals', () {
    test('matches price x qty with same skips as profit', () {
      final rev = computeSaleLineRevenueForPersonalGoals([
        const SaleLineForProfit(price: 10, qty: 3, supplyPrice: 5),
        const SaleLineForProfit(
          price: 999,
          qty: 1,
          ignoreForReport: true,
        ),
      ]);
      expect(rev, 30);
    });
  });

  group('computeAutoAllocationContributions', () {
    test('10% of profit for one goal (Inventory Expansion style)', () {
      final goals = [
        PersonalGoal(
          id: 'g1',
          branchId: 'b1',
          name: 'Inventory Expansion',
          savedAmount: 0,
          targetAmount: 1000,
          autoAllocationPercent: 10,
        ),
      ];
      final rows = computeAutoAllocationContributions(
        allocationBase: 200,
        goals: goals,
      );
      expect(rows.length, 1);
      expect(rows.first.goalId, 'g1');
      expect(rows.first.amount, 20);
    });

    test('multiple goals each take their percent of the same profit base', () {
      final goals = [
        PersonalGoal(
          id: 'a',
          branchId: 'b',
          name: 'A',
          savedAmount: 0,
          targetAmount: 100,
          autoAllocationPercent: 10,
        ),
        PersonalGoal(
          id: 'b',
          branchId: 'b',
          name: 'B',
          savedAmount: 0,
          targetAmount: 100,
          autoAllocationPercent: 5,
        ),
        PersonalGoal(
          id: 'c',
          branchId: 'b',
          name: 'C',
          savedAmount: 0,
          targetAmount: 100,
        ),
      ];
      final rows = computeAutoAllocationContributions(
        allocationBase: 1000,
        goals: goals,
      );
      expect(rows.map((e) => e.goalId).toList(), ['a', 'b']);
      expect(rows.firstWhere((e) => e.goalId == 'a').amount, 100);
      expect(rows.firstWhere((e) => e.goalId == 'b').amount, 50);
    });
  });
}
