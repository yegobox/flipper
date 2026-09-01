import 'package:flipper_payments/flipper_payments.dart';
import 'package:flutter_test/flutter_test.dart';

SubscriptionPlanTemplate _mobile({int? dailyPrice}) => SubscriptionPlanTemplate(
      id: 't1',
      slug: 'mobile',
      name: 'Mobile',
      monthlyPrice: 5000,
      yearlyDiscountPercent: 20,
      dailyPrice: dailyPrice,
      addons: const [
        SubscriptionPlanAddonTemplate(
          id: 'a1',
          planTemplateId: 't1',
          slug: 'tax_reporting',
          name: 'Tax Reporting Consulting',
          monthlyPrice: 30000,
        ),
      ],
    );

void main() {
  group('cadence wire values', () {
    test('round-trip through plans.rule', () {
      for (final cadence in BillingCadence.values) {
        expect(BillingCadence.fromWire(cadence.wireValue), cadence);
      }
    });

    test('unknown and null bill monthly, matching the server fallback', () {
      expect(BillingCadence.fromWire(null), BillingCadence.monthly);
      expect(BillingCadence.fromWire('nonsense'), BillingCadence.monthly);
      expect(BillingCadence.fromWire(' DAY '), BillingCadence.daily);
      expect(BillingCadence.fromWire('annual'), BillingCadence.yearly);
    });

    test('only yearly sets the legacy is_yearly_plan flag', () {
      expect(BillingCadence.daily.isYearly, isFalse);
      expect(BillingCadence.monthly.isYearly, isFalse);
      expect(BillingCadence.yearly.isYearly, isTrue);
    });
  });

  group('daily price derivation', () {
    // Must equal Template::price_for_cadence in
    // data-connector/src/billing/catalog.rs — the server charges what it
    // computes and the app only displays it, so a franc of drift is a bug the
    // customer sees.
    test('rounds up so thirty days never undercut a month', () {
      expect(dailyPriceFromMonthly(5000), 167);
      expect(dailyPriceFromMonthly(5000) * 30, greaterThanOrEqualTo(5000));
      expect(dailyPriceFromMonthly(200), 7);
      expect(dailyPriceFromMonthly(350000), 11667);
      expect(dailyPriceFromMonthly(120000), 4000);
    });

    test('a zero or negative price stays zero', () {
      expect(dailyPriceFromMonthly(0), 0);
      expect(dailyPriceFromMonthly(-5), 0);
    });
  });

  group('template totals', () {
    test('Mobile at each cadence', () {
      final t = _mobile();
      expect(t.calculateTotalFor(cadence: BillingCadence.monthly), 5000);
      expect(t.calculateTotalFor(cadence: BillingCadence.daily), 167);
      expect(t.calculateTotalFor(cadence: BillingCadence.yearly), 48000);
    });

    test('daily divides the add-on too', () {
      final t = _mobile();
      // 35,000/month → 1,167/day. Pricing the tier daily but the add-on
      // monthly would charge a month of add-on for a day of service.
      expect(
        t.calculateTotalFor(
          cadence: BillingCadence.daily,
          selectedAddonSlugs: const ['tax_reporting'],
        ),
        1167,
      );
    });

    test('an explicit daily price still charges for add-ons', () {
      final t = _mobile(dailyPrice: 150);
      expect(t.calculateTotalFor(cadence: BillingCadence.daily), 150);
      // 150 for the tier + 1,000 for the 30,000/month add-on.
      expect(
        t.calculateTotalFor(
          cadence: BillingCadence.daily,
          selectedAddonSlugs: const ['tax_reporting'],
        ),
        1150,
      );
    });

    test('the boolean form still agrees with the cadence form', () {
      final t = _mobile();
      expect(t.calculateTotal(isYearly: false),
          t.calculateTotalFor(cadence: BillingCadence.monthly));
      expect(t.calculateTotal(isYearly: true),
          t.calculateTotalFor(cadence: BillingCadence.yearly));
    });
  });

  group('price lines', () {
    test('each cadence names its own period', () {
      final t = _mobile();
      expect(formatPaymentTilePriceFor(t, cadence: BillingCadence.monthly),
          '5,000 RWF/month');
      expect(formatPaymentTilePriceFor(t, cadence: BillingCadence.daily),
          '167 RWF/day');
      expect(formatPaymentTilePriceFor(t, cadence: BillingCadence.yearly),
          '4,000 RWF/mo · billed yearly');
    });

    test('add-on lines use the same divisor as the total', () {
      final t = _mobile();
      expect(
        formatPaymentAddonPriceFor(t, t.addons.first,
            cadence: BillingCadence.daily),
        '1,000 RWF/day',
      );
    });
  });

  group('next billing date', () {
    test('period length per cadence', () {
      expect(BillingCadence.daily.periodDays, 1);
      expect(BillingCadence.monthly.periodDays, 30);
      expect(BillingCadence.yearly.periodDays, 365);
    });
  });
}
