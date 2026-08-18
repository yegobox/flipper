import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/billing/application/hr_subscription_controller.dart';
import 'package:flipper_hr/features/billing/data/hr_momo_gateway.dart';
import 'package:flipper_hr/features/billing/data/hr_billing_repository.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_hr/features/billing/presentation/hr_billing_gate.dart';
import 'package:flipper_hr/features/billing/presentation/hr_subscribe_page.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_hr_billing_repository.dart';
import '../helpers/fake_hr_momo_gateway.dart';

final _business = Business.fromJson({'id': 'biz-1', 'name': 'Acme Ltd'});

ProviderContainer _container({
  required FakeHrBillingRepository billing,
  FakeHrMomoGateway? gateway,
  bool withBusiness = true,
}) {
  final container = ProviderContainer(
    overrides: [
      hrBillingRepositoryProvider.overrideWithValue(billing),
      hrMomoGatewayProvider.overrideWithValue(gateway ?? FakeHrMomoGateway()),
      hrMomoPollIntervalProvider.overrideWithValue(Duration.zero),
      hrMomoPollTimeoutProvider.overrideWithValue(
        const Duration(milliseconds: 200),
      ),
    ],
  );
  addTearDown(container.dispose);
  if (withBusiness) {
    container.read(selectedBusinessProvider.notifier).set(_business);
  }
  return container;
}

Future<void> _pump(WidgetTester tester, ProviderContainer container, Widget child) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('HrBillingGate', () {
    testWidgets('opens the page for a paid business', (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(access: entitledState()),
      );
      // Resolve entitlement before pumping so the gate is not asserting on the
      // permissive loading state.
      await container.read(hrAccessStateProvider('biz-1').future);

      await _pump(
        tester,
        container,
        const HrBillingGate(child: Text('the roster')),
      );

      expect(find.text('the roster'), findsOneWidget);
      expect(find.byKey(const Key('hr-paywall-panel')), findsNothing);
    });

    testWidgets('locks the page when the business has not paid', (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
      );
      await container.read(hrAccessStateProvider('biz-1').future);

      await _pump(
        tester,
        container,
        const HrBillingGate(featureName: 'The roster', child: Text('the roster')),
      );

      expect(find.text('the roster'), findsNothing);
      expect(find.byKey(const Key('hr-paywall-panel')), findsOneWidget);
      expect(find.text('The roster needs a subscription'), findsOneWidget);
      expect(find.byKey(const Key('hr-paywall-subscribe')), findsOneWidget);
    });

    testWidgets('a lapsed subscription is offered a renewal, not a first sale',
        (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(
          access: unpaidState(
            validUntil: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ),
      );
      await container.read(hrAccessStateProvider('biz-1').future);

      await _pump(
        tester,
        container,
        const HrBillingGate(child: Text('the roster')),
      );

      expect(find.text('Your subscription has ended'), findsOneWidget);
      expect(find.text('Renew now'), findsOneWidget);
    });

    testWidgets('an employee with no business is never shown a paywall',
        (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(
          access: const HrAccessState(status: HrAccessStatus.noBusiness),
        ),
        withBusiness: false,
      );
      await container.read(hrAccessStateProvider(null).future);

      await _pump(
        tester,
        container,
        const HrBillingGate(child: Text('my leave')),
      );

      expect(find.text('my leave'), findsOneWidget);
    });

    testWidgets('an unapplied migration does not lock anybody out',
        (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState())
          ..failure = const HrBillingSchemaMissing(),
      );

      await _pump(
        tester,
        container,
        const HrBillingGate(child: Text('the roster')),
      );

      expect(find.text('the roster'), findsOneWidget);
    });
  });

  group('HrSubscribePage', () {
    testWidgets('shows the Basic package, its price and its limits',
        (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
      );

      await _pump(tester, container, const HrSubscribePage());

      expect(find.byKey(const Key('hr-plan-card')), findsOneWidget);
      expect(find.text('Basic'), findsOneWidget);
      expect(find.text('350,000 RWF'), findsOneWidget);
      expect(find.text('per month'), findsOneWidget);
      expect(find.text('Up to 50 HR employees'), findsWidgets);
      // Usage against the limits, so "50 employees" is actionable.
      expect(find.text('2 of 5'), findsOneWidget);
      expect(find.text('12 of 50'), findsOneWidget);
    });

    testWidgets('a test charge is shown next to the amount it stands in for',
        (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(
          access: unpaidState(),
          quote: basicQuote(amountRwf: 100, testMode: true),
        ),
      );

      await _pump(tester, container, const HrSubscribePage());

      expect(find.text('100 RWF'), findsOneWidget);
      expect(find.byKey(const Key('hr-plan-test-mode')), findsOneWidget);
    });

    testWidgets('the pay button waits for a valid number', (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
      );

      await _pump(tester, container, const HrSubscribePage());

      final button = find.byKey(const Key('hr-pay-button'));
      expect(tester.widget<FilledButton>(button).onPressed, isNull);

      await tester.enterText(find.byKey(const Key('hr-momo-phone')), '0788123456');
      await tester.pump();

      expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    });

    testWidgets('paying charges the plan and confirms', (tester) async {
      final billing = FakeHrBillingRepository(access: unpaidState());
      final gateway = FakeHrMomoGateway();
      final container = _container(billing: billing, gateway: gateway);

      await _pump(tester, container, const HrSubscribePage());
      await tester.enterText(find.byKey(const Key('hr-momo-phone')), '0788123456');
      await tester.pump();

      billing.access = entitledState();
      // The card and its usage rows push the button below the fold on the
      // default test surface; a tap that misses reports as "nothing happened".
      await tester.ensureVisible(find.byKey(const Key('hr-pay-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('hr-pay-button')));
      await tester.pumpAndSettle();

      expect(gateway.charges, hasLength(1));
      expect(find.byKey(const Key('hr-payment-confirmed')), findsOneWidget);
      expect(find.byKey(const Key('hr-payment-continue')), findsOneWidget);
    });

    testWidgets('a refusal is shown in the gateway\'s own words',
        (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
        gateway: FakeHrMomoGateway(
          payFailure: const HrMomoException('MTN credential missing'),
        ),
      );

      await _pump(tester, container, const HrSubscribePage());
      await tester.enterText(find.byKey(const Key('hr-momo-phone')), '0788123456');
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('hr-pay-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('hr-pay-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('hr-payment-failed')), findsOneWidget);
      expect(find.textContaining('MTN credential missing'), findsOneWidget);
    });

    testWidgets('with no business picked it asks for one instead of a price',
        (tester) async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
        withBusiness: false,
      );

      await _pump(tester, container, const HrSubscribePage());

      expect(find.text('Choose a business'), findsOneWidget);
      expect(find.byKey(const Key('hr-plan-card')), findsNothing);
    });
  });
}
