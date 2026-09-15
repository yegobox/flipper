import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/custom_payment/application/custom_payment_providers.dart';
import 'package:flipper_web/features/custom_payment/presentation/custom_payment_page.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fake_custom_payment.dart';

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  required FakeCustomPaymentApi api,
  bool staff = true,
  bool cardAvailable = false,
}) async {
  final container = ProviderContainer(
    overrides: [
      authStateProvider.overrideWith(
        (ref) => Stream.value(AuthState.authenticated),
      ),
      billingStaffRepositoryProvider.overrideWithValue(
        FakeBillingStaffRepository(member: staff ? testStaff : null),
      ),
      businessSearchRepositoryProvider.overrideWithValue(
        FakeBusinessSearchRepository(hits: const [testHit]),
      ),
      customPaymentApiFactoryProvider.overrideWithValue((_) => api),
      customPaymentCardAvailableProvider.overrideWith(
        (ref) async => cardAvailable,
      ),
      customPaymentPollIntervalProvider.overrideWithValue(Duration.zero),
      customPaymentPollTimeoutProvider.overrideWithValue(
        const Duration(milliseconds: 300),
      ),
    ],
  );
  addTearDown(container.dispose);

  final router = GoRouter(
    initialLocation: '/custom-payment',
    routes: [
      GoRoute(
        path: '/custom-payment',
        builder: (_, __) => const CustomPaymentPage(),
      ),
      GoRoute(path: '/accounting', builder: (_, __) => const Text('BOOKS')),
    ],
  );

  tester.view.physicalSize = const Size(1200, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> _pickBusinessAndAmount(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('custom-payment-search')),
    'kigali',
  );
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('custom-payment-hit-biz-1')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('custom-payment-business')), findsOneWidget);
  await tester.enterText(
    find.byKey(const Key('custom-payment-amount')),
    '25000',
  );
  await tester.pumpAndSettle();
}

void main() {
  group('CustomPaymentPage', () {
    testWidgets('a non-staff user sees the gate and no form', (tester) async {
      await _pump(tester, api: FakeCustomPaymentApi(), staff: false);
      expect(find.byKey(const Key('custom-payment-gate')), findsOneWidget);
      expect(find.byKey(const Key('custom-payment-search')), findsNothing);
      expect(find.byKey(const Key('custom-payment-submit')), findsNothing);
    });

    testWidgets('staff can find a business, charge by MoMo, and read the ids', (
      tester,
    ) async {
      final api = FakeCustomPaymentApi(
        statuses: const [
          CustomPaymentStatus.awaitingApproval,
          CustomPaymentStatus.settled,
        ],
      );
      await _pump(tester, api: api);
      expect(find.byKey(const Key('custom-payment-gate')), findsNothing);

      await _pickBusinessAndAmount(tester);
      // The phone is prefilled from the business row.
      expect(find.text('0788123456'), findsWidgets);

      await tester.tap(find.byKey(const Key('custom-payment-submit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('custom-payment-confirm')), findsOneWidget);
      await tester.tap(find.byKey(const Key('custom-payment-confirm')));
      await tester.pumpAndSettle();

      expect(api.created.single.businessId, 'biz-1');
      expect(api.created.single.amountRwf, 25000);
      expect(api.created.single.customerName, 'Kigali Mart');

      expect(find.byKey(const Key('custom-payment-settled')), findsOneWidget);
      expect(find.text('cp-1'), findsOneWidget);
      expect(find.text('plan-1'), findsOneWidget);
      expect(find.text('charge-1'), findsOneWidget);
      expect(find.text('ft-1'), findsOneWidget);
      expect(
        find.byKey(const Key('custom-payment-copy-receipt')),
        findsOneWidget,
      );
    });

    testWidgets('the card rail is hidden when the connector cannot sell it', (
      tester,
    ) async {
      await _pump(tester, api: FakeCustomPaymentApi(), cardAvailable: false);
      expect(find.byKey(const Key('custom-payment-rail')), findsNothing);
      expect(find.byKey(const Key('custom-payment-phone')), findsOneWidget);
    });

    testWidgets('card: the link is shown with a copy button while waiting', (
      tester,
    ) async {
      final api = FakeCustomPaymentApi(
        rail: CustomPaymentRail.card,
        statuses: const [CustomPaymentStatus.awaitingCheckout],
      );
      await _pump(tester, api: api, cardAvailable: true);
      await _pickBusinessAndAmount(tester);

      // Switch to card.
      await tester.tap(find.text('Card'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('custom-payment-card')), findsOneWidget);

      await tester.tap(find.byKey(const Key('custom-payment-submit')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('custom-payment-confirm')));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byKey(const Key('custom-payment-link')), findsOneWidget);
      expect(find.text('https://checkout.example/x'), findsWidgets);
      expect(find.byKey(const Key('custom-payment-copy-link')), findsOneWidget);
      expect(api.created.single.rail, CustomPaymentRail.card);
      expect(api.created.single.email, 'owner@kigalimart.rw');

      await tester.pumpAndSettle(const Duration(milliseconds: 400));
      expect(
        find.byKey(const Key('custom-payment-retry')),
        findsOneWidget,
        reason: 'timed out → "Check again"',
      );
    });

    testWidgets(
      'the submit button stays disabled until business and amount are set',
      (tester) async {
        await _pump(tester, api: FakeCustomPaymentApi());
        final button = tester.widget<PaymentPrimaryButton>(
          find.byKey(const Key('custom-payment-submit')),
        );
        expect(button.onPressed, isNull);
      },
    );
  });
}
