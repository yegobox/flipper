import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_hr/features/billing/data/hr_msisdn.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.utc(2026, 8, 18, 9);

void main() {
  group('HrAccessState.fromJson', () {
    test('reads the entitled shape hr_access_state() returns', () {
      final state = HrAccessState.fromJson({
        'status': 'entitled',
        'business_id': 'biz-1',
        'plan_id': 'plan-1',
        'plan_name': 'Basic',
        'slug': 'basic',
        'is_yearly': false,
        'amount_rwf': 350000,
        'payment_status': 'COMPLETED',
        'phone_number': '250788123456',
        'valid_until': '2026-09-17T09:00:00+00:00',
        'grace_days': 0,
        'test_mode': false,
        'max_pos_users': 5,
        'max_branches': 1,
        'max_hr_employees': 50,
        'pos_users_used': 2,
        'branches_used': 1,
        'employees_used': 50,
      });

      expect(state.status, HrAccessStatus.entitled);
      expect(state.grantsAccess, isTrue);
      expect(state.needsPayment, isFalse);
      expect(state.amountRwf, 350000);
      expect(state.allowance.maxHrEmployees, 50);
      expect(state.allowance.employeesExhausted, isTrue);
      expect(state.allowance.posUsersExhausted, isFalse);
    });

    test('an unknown status neither grants nor demands payment silently', () {
      final state = HrAccessState.fromJson({'status': 'something-new'});

      expect(state.status, HrAccessStatus.unknown);
      // Unknown is permissive on purpose: a paying customer must not meet a
      // paywall because a status string changed.
      expect(state.grantsAccess, isTrue);
      expect(state.needsPayment, isFalse);
    });

    test('a null limit is unlimited, not zero', () {
      final state = HrAccessState.fromJson({
        'status': 'entitled',
        'max_hr_employees': null,
        'employees_used': 900,
      });

      expect(state.allowance.maxHrEmployees, isNull);
      expect(state.allowance.employeesExhausted, isFalse);
      expect(state.allowance.hasLimits, isFalse);
    });
  });

  group('access decisions', () {
    test('needs_payment locks the manager surfaces', () {
      final state = HrAccessState.fromJson({
        'status': 'needs_payment',
        'business_id': 'biz-1',
        'valid_until': '2026-08-01T00:00:00Z',
      });

      expect(state.grantsAccess, isFalse);
      expect(state.needsPayment, isTrue);
      expect(state.hasLapsed, isTrue);
    });

    test('needs_setup asks for a first payment, not a renewal', () {
      final state = HrAccessState.fromJson({
        'status': 'needs_setup',
        'business_id': 'biz-1',
      });

      expect(state.grantsAccess, isFalse);
      expect(state.hasLapsed, isFalse);
    });

    test('an employee with no business is let through, not billed', () {
      final state = HrAccessState.fromJson({'status': 'no_business'});

      // They cannot pay their employer's invoice, and their own leave page
      // resolves its own scope.
      expect(state.grantsAccess, isTrue);
      expect(state.needsPayment, isFalse);
    });

    test('an unpaid plan with a charge in flight says so', () {
      final state = HrAccessState.fromJson({
        'status': 'needs_payment',
        'payment_status': 'PENDING',
        'valid_until': '2026-08-01T00:00:00Z',
      });

      expect(state.isAwaitingSettlement, isTrue);
    });

    test('a skip unlocks without claiming a real payment', () {
      final state = HrAccessState.fromJson({
        'status': 'skipped',
        'business_id': 'biz-1',
        'skips_used': 1,
        'max_payment_skips': 2,
        'skip_expires_at': '2026-09-17T09:00:00+00:00',
      });

      expect(state.status, HrAccessStatus.skipped);
      expect(state.grantsAccess, isTrue);
      // A skip is not a subscription to buy or renew — the reminder strip,
      // not the paywall, is what tells the user about it.
      expect(state.needsPayment, isFalse);
      expect(state.isSkipped, isTrue);
      expect(state.skipsUsed, 1);
      expect(state.maxPaymentSkips, 2);
      expect(state.skipsRemaining, 1);
    });

    test('a payload from before skips existed still defaults safely', () {
      final state = HrAccessState.fromJson({
        'status': 'needs_payment',
        'business_id': 'biz-1',
      });

      // No skip keys sent (pre-migration-0009 server): fails closed, no skip
      // is ever offered rather than defaulting to "unlimited".
      expect(state.skipsUsed, 0);
      expect(state.maxPaymentSkips, 0);
      expect(state.skipsRemaining, 0);
      expect(state.canSkipPayment, isFalse);
    });

    test('skipsRemaining and canSkipPayment track usage against the cap', () {
      final oneLeft = HrAccessState.fromJson({
        'status': 'needs_payment',
        'skips_used': 1,
        'max_payment_skips': 2,
      });
      expect(oneLeft.skipsRemaining, 1);
      expect(oneLeft.canSkipPayment, isTrue);

      final exhausted = HrAccessState.fromJson({
        'status': 'needs_payment',
        'skips_used': 2,
        'max_payment_skips': 2,
      });
      expect(exhausted.skipsRemaining, 0);
      expect(exhausted.canSkipPayment, isFalse);

      final paidUp = HrAccessState.fromJson({
        'status': 'entitled',
        'skips_used': 0,
        'max_payment_skips': 2,
      });
      // Skips are only ever offered when a payment is actually due.
      expect(paidUp.canSkipPayment, isFalse);
    });

    test('an unapplied migration opens up and flags itself', () {
      const state = HrAccessState.schemaMissing();

      expect(state.grantsAccess, isTrue);
      expect(state.enforced, isFalse);
      expect(state.schemaMissing, isTrue);
      // Nothing may claim this business is on a plan.
      expect(state.needsPayment, isFalse);
    });
  });

  group('daysLeft', () {
    test('counts whole days and floors at zero', () {
      final state = HrAccessState.fromJson({
        'status': 'entitled',
        'valid_until': '2026-08-21T09:00:00Z',
      });

      expect(state.daysLeft(now: _now), 3);
      expect(
        state.daysLeft(now: DateTime.utc(2026, 9, 1)),
        0,
        reason: 'a period that ended is zero days left, never negative',
      );
    });

    test('is null when there is no period to count', () {
      expect(const HrAccessState.unknown().daysLeft(now: _now), isNull);
    });
  });

  group('HrPlanQuote.fromJson', () {
    test('carries the test amount and the real one', () {
      final quote = HrPlanQuote.fromJson({
        'business_id': 'biz-1',
        'template_id': 't-1',
        'slug': 'basic',
        'name': 'Basic',
        'features': ['Up to 5 POS users', '1 branch'],
        'monthly_price': 350000,
        'amount_rwf': 100,
        'full_amount_rwf': 350000,
        'test_mode': true,
        'period_days': 30,
        'max_hr_employees': 50,
        'employees_used': 3,
      });

      expect(quote.amountRwf, 100);
      expect(quote.fullAmountRwf, 350000);
      expect(quote.testMode, isTrue);
      expect(quote.features, hasLength(2));
      expect(quote.periodLabel, 'per month');
    });

    test('a yearly quote is labelled per year', () {
      final quote = HrPlanQuote.fromJson({
        'slug': 'basic',
        'name': 'Basic',
        'is_yearly': true,
        'amount_rwf': 3360000,
        'period_days': 365,
      });

      expect(quote.periodLabel, 'per year');
      expect(quote.amountRwf, 3360000);
    });
  });

  group('formatRwf', () {
    test('groups thousands so the figure can be read at a glance', () {
      expect(formatRwf(350000), '350,000');
      expect(formatRwf(3360000), '3,360,000');
      expect(formatRwf(100), '100');
      expect(formatRwf(0), '0');
    });
  });

  group('HrMsisdn', () {
    test('accepts every shape a Rwandan mobile is written in', () {
      for (final phone in [
        '0788123456',
        '788123456',
        '+250788123456',
        '250 788 123 456',
        '0730123456',
      ]) {
        expect(HrMsisdn.isValid(phone), isTrue, reason: phone);
        expect(HrMsisdn.toPartyId(phone), startsWith('250'));
      }
    });

    test('refuses anything that is not one, before it reaches MTN', () {
      for (final phone in ['', '07881234', '0688123456', 'not a number']) {
        expect(HrMsisdn.isValid(phone), isFalse, reason: phone);
        expect(HrMsisdn.toPartyId(phone), isNull, reason: phone);
      }
    });

    test('renders a stored number back as a local one', () {
      expect(HrMsisdn.toLocal('250788123456'), '0788123456');
      expect(HrMsisdn.toLocal(''), '');
    });
  });
}
