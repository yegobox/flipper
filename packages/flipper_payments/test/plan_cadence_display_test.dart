import 'package:flipper_payments/flipper_payments.dart';
import 'package:flutter_test/flutter_test.dart';

/// A saved plan renders its cadence from `rule`, never from `is_yearly_plan`.
///
/// The bug this pins: the Payment Issue summary read
/// `plan.isYearlyPlan == true ? 'Yearly' : 'Monthly'`, so a daily plan showed
/// "Monthly" next to its (correct) daily price — 167 RWF, billed "Monthly".
void main() {
  group('billing label on a saved plan', () {
    test('a daily plan reads Daily, not Monthly', () {
      final plan = Plan.fromSupabaseJson(const {
        'id': 'p1',
        'selected_plan': 'Mobile',
        'total_price': 167,
        'rule': 'daily',
        // Written false for every non-yearly plan, daily included. Reading it
        // instead of `rule` is what produced the wrong label.
        'is_yearly_plan': false,
      });

      expect(plan.rule, 'daily');
      expect(BillingCadence.fromWire(plan.rule), BillingCadence.daily);
      expect(BillingCadence.fromWire(plan.rule).label, 'Daily');
      expect(BillingCadence.fromWire(plan.rule).periodSuffix, '/day');
    });

    test('monthly and yearly still read correctly', () {
      for (final (rule, isYearly, label) in const [
        ('monthly', false, 'Monthly'),
        ('yearly', true, 'Yearly'),
      ]) {
        final plan = Plan.fromSupabaseJson({
          'id': 'p',
          'rule': rule,
          'is_yearly_plan': isYearly,
        });
        expect(BillingCadence.fromWire(plan.rule).label, label);
      }
    });

    test('a plan written before rule existed falls back to monthly', () {
      final plan = Plan.fromSupabaseJson(const {'id': 'p', 'is_yearly_plan': false});
      expect(plan.rule, isNull);
      expect(BillingCadence.fromWire(plan.rule), BillingCadence.monthly);
    });
  });
}
