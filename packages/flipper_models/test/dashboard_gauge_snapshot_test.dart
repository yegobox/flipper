import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardGaugeSnapshot', () {
    test('a day with only a cash-out still has expenses to show', () {
      const snap = DashboardGaugeSnapshot(grossProfit: 0, deductions: 5000);
      expect(snap.isEmpty, isTrue, reason: 'no sales yet');
      expect(snap.hasDeductions, isTrue);
      expect(snap.hasActivity, isTrue);
      expect(snap.netProfit, -5000);
    });

    test('an empty day shows nothing', () {
      const snap = DashboardGaugeSnapshot(grossProfit: 0, deductions: 0);
      expect(snap.hasRevenue, isFalse);
      expect(snap.hasDeductions, isFalse);
      expect(snap.hasActivity, isFalse);
    });

    test('sales count as activity and revenue', () {
      const snap = DashboardGaugeSnapshot(
        grossProfit: 400,
        deductions: 0,
        revenue: 1000,
        transactionCount: 1,
      );
      expect(snap.hasRevenue, isTrue);
      expect(snap.hasActivity, isTrue);
      expect(snap.hasDeductions, isFalse);
    });
  });
}
