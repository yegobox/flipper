import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/custom_payment/application/custom_payment_controller.dart';
import 'package:flipper_web/features/custom_payment/application/custom_payment_providers.dart';
import 'package:flipper_web/features/custom_payment/data/custom_payment_api.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_custom_payment.dart';

ProviderContainer _container({
  required FakeCustomPaymentApi api,
  bool staff = true,
}) {
  final container = ProviderContainer(
    overrides: [
      authStateProvider.overrideWith(
        (ref) => Stream.value(AuthState.authenticated),
      ),
      billingStaffRepositoryProvider.overrideWithValue(
        FakeBillingStaffRepository(member: staff ? testStaff : null),
      ),
      customPaymentApiFactoryProvider.overrideWithValue((_) => api),
      customPaymentPollIntervalProvider.overrideWithValue(Duration.zero),
      customPaymentPollTimeoutProvider.overrideWithValue(
        const Duration(milliseconds: 300),
      ),
    ],
  );
  addTearDown(container.dispose);
  // The page watches these for as long as it is on screen; without listeners
  // Riverpod tears the providers down between reads, and the controller would
  // see "not staff" mid-payment.
  container.listen(authStateProvider, (_, __) {}, fireImmediately: true);
  container.listen(
    billingStaffMemberProvider,
    (_, __) {},
    fireImmediately: true,
  );
  container.listen(
    customPaymentControllerProvider,
    (_, __) {},
    fireImmediately: true,
  );
  return container;
}

CustomPaymentDraft _momoDraft({
  String phone = '0788123456',
  int amount = 25000,
}) => CustomPaymentDraft(
  businessId: 'biz-1',
  amountRwf: amount,
  cadence: CustomPaymentCadence.monthly,
  rail: CustomPaymentRail.momo,
  phoneNumber: phone,
);

Future<void> _resolveStaff(ProviderContainer container) async {
  await container.read(billingStaffMemberProvider.future);
}

void main() {
  group('CustomPaymentController', () {
    test(
      'MoMo: submits, waits for approval, then settles with the ids',
      () async {
        final api = FakeCustomPaymentApi(
          statuses: const [
            CustomPaymentStatus.awaitingApproval,
            CustomPaymentStatus.pending,
            CustomPaymentStatus.settled,
          ],
        );
        final container = _container(api: api);
        await _resolveStaff(container);
        final controller = container.read(
          customPaymentControllerProvider.notifier,
        );
        final stages = <CustomPaymentStage>[];
        container.listen(
          customPaymentControllerProvider,
          (_, next) => stages.add(next.stage),
        );

        await controller.submit(_momoDraft());

        final state = container.read(customPaymentControllerProvider);
        expect(state.stage, CustomPaymentStage.settled);
        expect(state.view?.id, 'cp-1');
        expect(state.view?.planId, 'plan-1');
        expect(state.view?.chargeId, 'charge-1');
        expect(state.view?.financialTransactionId, 'ft-1');
        expect(state.view?.nextBillingDate, '2026-10-14');
        expect(
          stages,
          containsAllInOrder([
            CustomPaymentStage.submitting,
            CustomPaymentStage.awaitingApproval,
            CustomPaymentStage.settled,
          ]),
        );
        expect(api.created.single.phoneNumber, '0788123456');
        expect(api.created.single.rail, CustomPaymentRail.momo);
      },
    );

    test('card: exposes the checkout link while waiting', () async {
      final api = FakeCustomPaymentApi(
        rail: CustomPaymentRail.card,
        statuses: const [CustomPaymentStatus.awaitingCheckout],
      );
      final container = _container(api: api);
      await _resolveStaff(container);
      final controller = container.read(
        customPaymentControllerProvider.notifier,
      );

      final submission = controller.submit(
        const CustomPaymentDraft(
          businessId: 'biz-1',
          amountRwf: 25000,
          cadence: CustomPaymentCadence.yearly,
          rail: CustomPaymentRail.card,
          email: 'owner@shop.rw',
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final mid = container.read(customPaymentControllerProvider);
      expect(mid.stage, CustomPaymentStage.awaitingCheckout);
      expect(mid.checkoutLink, 'https://checkout.example/x');

      await submission;
      final end = container.read(customPaymentControllerProvider);
      expect(
        end.stage,
        CustomPaymentStage.timedOut,
        reason: 'never paid within the window — but never called failed',
      );
      expect(end.message, contains('still counts'));
    });

    test('a failed charge reports the connector\'s reason', () async {
      final api = FakeCustomPaymentApi(
        statuses: const [CustomPaymentStatus.failed],
      );
      final container = _container(api: api);
      await _resolveStaff(container);
      await container
          .read(customPaymentControllerProvider.notifier)
          .submit(_momoDraft());
      expect(
        container.read(customPaymentControllerProvider).stage,
        CustomPaymentStage.failed,
      );
    });

    test('a 409 surfaces the payment already in flight', () async {
      final blocker = FakeCustomPaymentApi(rail: CustomPaymentRail.card);
      final api = FakeCustomPaymentApi(
        createError: CustomPaymentException(
          'busy',
          statusCode: 409,
          gatewayMessage: 'a card checkout is still open for this business',
          inFlight: blocker.view(
            CustomPaymentStatus.awaitingCheckout,
            id: 'cp-0',
          ),
        ),
      );
      final container = _container(api: api);
      await _resolveStaff(container);
      await container
          .read(customPaymentControllerProvider.notifier)
          .submit(_momoDraft());
      final state = container.read(customPaymentControllerProvider);
      expect(state.stage, CustomPaymentStage.failed);
      expect(state.message, contains('still open'));
      expect(state.inFlight?.id, 'cp-0');
      expect(api.created, isEmpty);
    });

    test(
      'rejects an implausible phone before touching the connector',
      () async {
        final api = FakeCustomPaymentApi();
        final container = _container(api: api);
        await _resolveStaff(container);
        await container
            .read(customPaymentControllerProvider.notifier)
            .submit(_momoDraft(phone: '12'));
        expect(
          container.read(customPaymentControllerProvider).stage,
          CustomPaymentStage.failed,
        );
        expect(api.created, isEmpty);
      },
    );

    test('a non-staff user cannot submit at all', () async {
      final api = FakeCustomPaymentApi();
      final container = _container(api: api, staff: false);
      await _resolveStaff(container);
      expect(container.read(customPaymentApiProvider), isNull);
      await container
          .read(customPaymentControllerProvider.notifier)
          .submit(_momoDraft());
      final state = container.read(customPaymentControllerProvider);
      expect(state.stage, CustomPaymentStage.failed);
      expect(state.message, contains('not authorised'));
      expect(api.created, isEmpty);
    });

    test('checkAgain after a timeout picks up a late settlement', () async {
      final api = FakeCustomPaymentApi(statuses: const []);
      final container = _container(api: api);
      await _resolveStaff(container);
      final controller = container.read(
        customPaymentControllerProvider.notifier,
      );
      await controller.submit(_momoDraft());
      expect(
        container.read(customPaymentControllerProvider).stage,
        CustomPaymentStage.timedOut,
      );

      final settledApi = FakeCustomPaymentApi(
        statuses: const [CustomPaymentStatus.settled],
      );
      final settled = _container(api: settledApi);
      await _resolveStaff(settled);
      final c2 = settled.read(customPaymentControllerProvider.notifier);
      await c2.submit(_momoDraft());
      expect(
        settled.read(customPaymentControllerProvider).stage,
        CustomPaymentStage.settled,
      );
    });
  });
}
