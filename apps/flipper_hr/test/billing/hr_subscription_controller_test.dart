import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/billing/application/hr_subscription_controller.dart';
import 'package:flipper_hr/features/billing/data/hr_billing_repository.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_hr/features/billing/data/hr_momo_gateway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_hr_billing_repository.dart';
import '../helpers/fake_hr_momo_gateway.dart';

ProviderContainer _container({
  required FakeHrBillingRepository billing,
  required FakeHrMomoGateway gateway,
}) {
  final container = ProviderContainer(
    overrides: [
      hrBillingRepositoryProvider.overrideWithValue(billing),
      hrMomoGatewayProvider.overrideWithValue(gateway),
      // Real cadence would make every test a five-minute wait.
      hrMomoPollIntervalProvider.overrideWithValue(Duration.zero),
      hrMomoPollTimeoutProvider.overrideWithValue(
        const Duration(milliseconds: 500),
      ),
    ],
  );
  addTearDown(container.dispose);
  // The paywall watches the controller for as long as it is on screen. Without
  // a listener here the auto-dispose provider is torn down mid-payment and
  // every state write lands on a disposed notifier.
  container.listen(
    hrSubscriptionControllerProvider,
    (_, __) {},
    fireImmediately: true,
  );
  return container;
}

void main() {
  group('paying for a subscription', () {
    test('prices server-side, charges the plan, and confirms', () async {
      final billing = FakeHrBillingRepository(
        access: unpaidState(),
        startResult: const HrSubscriptionStart(
          planId: 'plan-9',
          amountRwf: 350000,
        ),
      );
      final gateway = FakeHrMomoGateway(
        reference: 'mtn-ref',
        statuses: [HrMomoStatus.pending, HrMomoStatus.successful],
      );
      final container = _container(billing: billing, gateway: gateway);
      final controller = container.read(
        hrSubscriptionControllerProvider.notifier,
      );

      // The state the paywall shows after settlement has to be the new one.
      billing.access = entitledState();

      await controller.pay(
        businessId: 'biz-1',
        phoneNumber: '0788123456',
      );

      final state = container.read(hrSubscriptionControllerProvider);
      expect(state.stage, HrPaymentStage.confirmed);
      expect(state.reference, 'mtn-ref');

      // The plan row was written by the server before anything was charged...
      expect(billing.starts.single['businessId'], 'biz-1');
      expect(billing.starts.single['phoneNumber'], '0788123456');
      // ...and the charge went at the amount the server put on it.
      expect(gateway.charges.single['planId'], 'plan-9');
      expect(gateway.charges.single['amountRwf'], 350000);
      expect(gateway.finalized, ['mtn-ref']);
    });

    test('re-reads entitlement so the roster opens on this device', () async {
      final billing = FakeHrBillingRepository(access: unpaidState());
      final container = _container(
        billing: billing,
        gateway: FakeHrMomoGateway(),
      );
      // Prime the cache with the pre-payment answer.
      await container.read(hrAccessStateProvider('biz-1').future);
      expect(
        container.read(hrAccessSnapshotProvider('biz-1')).grantsAccess,
        isFalse,
      );

      billing.access = entitledState();
      await container
          .read(hrSubscriptionControllerProvider.notifier)
          .pay(businessId: 'biz-1', phoneNumber: '0788123456');

      expect(
        container.read(hrAccessSnapshotProvider('biz-1')).grantsAccess,
        isTrue,
      );
    });

    test('an invalid number never reaches the gateway', () async {
      final billing = FakeHrBillingRepository();
      final gateway = FakeHrMomoGateway();
      final container = _container(billing: billing, gateway: gateway);

      await container
          .read(hrSubscriptionControllerProvider.notifier)
          .pay(businessId: 'biz-1', phoneNumber: '07881');

      final state = container.read(hrSubscriptionControllerProvider);
      expect(state.stage, HrPaymentStage.failed);
      expect(state.message, contains('0788123456'));
      expect(billing.starts, isEmpty);
      expect(gateway.charges, isEmpty);
    });

    test('an already-active plan is not charged a second time', () async {
      final billing = FakeHrBillingRepository(
        access: entitledState(),
        startResult: const HrSubscriptionStart(
          planId: 'plan-9',
          amountRwf: 350000,
          alreadyActive: true,
        ),
      );
      final gateway = FakeHrMomoGateway();
      final container = _container(billing: billing, gateway: gateway);

      await container
          .read(hrSubscriptionControllerProvider.notifier)
          .pay(businessId: 'biz-1', phoneNumber: '0788123456');

      expect(
        container.read(hrSubscriptionControllerProvider).stage,
        HrPaymentStage.confirmed,
      );
      expect(gateway.charges, isEmpty);
    });

    test('a refused charge keeps the gateway\'s own words', () async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
        gateway: FakeHrMomoGateway(
          payFailure: const HrMomoException('MTN credential missing'),
        ),
      );

      await container
          .read(hrSubscriptionControllerProvider.notifier)
          .pay(businessId: 'biz-1', phoneNumber: '0788123456');

      final state = container.read(hrSubscriptionControllerProvider);
      expect(state.stage, HrPaymentStage.failed);
      expect(state.message, 'MTN credential missing');
    });

    test('MTN refusing the payment fails it, with the reason', () async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
        gateway: FakeHrMomoGateway(
          statuses: [HrMomoStatus.failed],
          reason: 'The payer declined the request.',
        ),
      );

      await container
          .read(hrSubscriptionControllerProvider.notifier)
          .pay(businessId: 'biz-1', phoneNumber: '0788123456');

      final state = container.read(hrSubscriptionControllerProvider);
      expect(state.stage, HrPaymentStage.failed);
      expect(state.message, 'The payer declined the request.');
    });

    test('no verdict inside the window times out, and never claims failure',
        () async {
      final container = _container(
        billing: FakeHrBillingRepository(access: unpaidState()),
        gateway: FakeHrMomoGateway(statuses: [HrMomoStatus.pending]),
      );

      await container
          .read(hrSubscriptionControllerProvider.notifier)
          .pay(businessId: 'biz-1', phoneNumber: '0788123456');

      final state = container.read(hrSubscriptionControllerProvider);
      expect(state.stage, HrPaymentStage.timedOut);
      expect(state.message, isNot(contains('failed')));
    });

    test('an unapplied migration is reported, not swallowed', () async {
      final container = _container(
        billing: FakeHrBillingRepository(
          failure: const HrBillingSchemaMissing(),
        ),
        gateway: FakeHrMomoGateway(),
      );

      await container
          .read(hrSubscriptionControllerProvider.notifier)
          .pay(businessId: 'biz-1', phoneNumber: '0788123456');

      final state = container.read(hrSubscriptionControllerProvider);
      expect(state.stage, HrPaymentStage.failed);
      expect(state.message, contains('0008_hr_billing.sql'));
    });
  });

  group('hrAccessStateProvider', () {
    test('an unapplied migration opens the app rather than locking it',
        () async {
      final container = _container(
        billing: FakeHrBillingRepository(
          failure: const HrBillingSchemaMissing(),
        ),
        gateway: FakeHrMomoGateway(),
      );

      final state = await container.read(hrAccessStateProvider('biz-1').future);

      expect(state.schemaMissing, isTrue);
      expect(state.grantsAccess, isTrue);
      expect(state.enforced, isFalse);
    });

    test('a failed read stays failed instead of retrying invisibly', () async {
      final container = _container(
        billing: FakeHrBillingRepository(
          failure: const HrBillingException('network down'),
        ),
        gateway: FakeHrMomoGateway(),
      );

      await expectLater(
        container.read(hrAccessStateProvider('biz-1').future),
        throwsA(isA<HrBillingException>()),
      );
      // Unknown grants access: the paywall must not appear because the network
      // blinked.
      expect(
        container.read(hrAccessSnapshotProvider('biz-1')).grantsAccess,
        isTrue,
      );
    });

    test('each business is asked about separately', () async {
      final billing = FakeHrBillingRepository();
      final container = _container(
        billing: billing,
        gateway: FakeHrMomoGateway(),
      );

      await container.read(hrAccessStateProvider('biz-1').future);
      await container.read(hrAccessStateProvider('biz-2').future);

      expect(billing.accessReads, ['biz-1', 'biz-2']);
    });
  });
}
