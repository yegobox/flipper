import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/application/books_billing_providers.dart';
import 'package:flipper_web/features/billing/application/books_subscription_controller.dart';
import 'package:flipper_web/features/billing/data/books_entitlement.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/books_billing_fixtures.dart';
import '../helpers/fake_books_payment_rails.dart';
import '../helpers/fake_books_plan_repository.dart';

ProviderContainer _container({
  required FakeBooksPlanRepository repo,
  required FakeBooksPaymentRails rails,
}) {
  final container = ProviderContainer(
    overrides: [
      booksPlanRepositoryProvider.overrideWithValue(repo),
      booksPaymentRailsProvider.overrideWithValue(rails),
      // Real cadence would make every test a five-minute wait.
      booksMomoPollIntervalProvider.overrideWithValue(Duration.zero),
      booksMomoPollTimeoutProvider.overrideWithValue(
        const Duration(milliseconds: 300),
      ),
      booksCardPollTimeoutProvider.overrideWithValue(
        const Duration(milliseconds: 300),
      ),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(repo.dispose);
  container.read(selectedBusinessProvider.notifier).set(testBusiness());
  // The paywall watches the controller for as long as it is on screen. Without
  // a listener here the auto-dispose provider is torn down mid-payment and
  // every state write lands on a disposed notifier.
  container.listen(
    booksSubscriptionControllerProvider,
    (_, __) {},
    fireImmediately: true,
  );
  return container;
}

void main() {
  group('paying with Mobile Money', () {
    test('writes the row mobile expects, charges it, and confirms', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails(
        momoStatuses: [MomoPaymentStatus.pending, MomoPaymentStatus.successful],
      );
      rails.onSuccessfulStatus = () => repo.settle('biz-1');
      final container = _container(repo: repo, rails: rails);
      final controller =
          container.read(booksSubscriptionControllerProvider.notifier);

      await controller.payWithMomo(
        business: testBusiness(),
        branchId: 'branch-1',
        selection: monthlyMobile(addons: ['reports']),
        phoneNumber: '0788123456',
      );

      final draft = repo.savedDrafts.single;
      expect(draft.paymentMethod, 'MTNMOMO');
      expect(draft.selectedPlan, 'Mobile');
      expect(draft.planTemplateId, 'tpl-mobile');
      expect(draft.cadence, BillingCadence.monthly);
      expect(draft.isYearly, isFalse);
      expect(draft.totalPrice, 35000);
      expect(draft.numberOfPayments, 1);
      expect(draft.addonNames, ['Reports']);
      expect(draft.branchId, 'branch-1');
      expect(draft.phoneNumber, '0788123456');
      expect(rails.lastAmount, 35000);
      expect(rails.lastPlanId, 'plan-1');

      expect(repo.finalizeCalls.single.planId, 'plan-1');
      expect(repo.finalizeCalls.single.reference, 'mtn-ref');

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.confirmed);
      expect(state.reference, 'mtn-ref');
      expect(
        container.read(booksAccessSnapshotProvider('biz-1')).status,
        BooksAccessStatus.entitled,
      );
    });

    test('a yearly pick writes a yearly row', () async {
      final repo = FakeBooksPlanRepository();
      final rails =
          FakeBooksPaymentRails(momoStatuses: [MomoPaymentStatus.successful]);
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: const BooksPlanSelection(
              template: mobileTemplate,
              cadence: BillingCadence.yearly,
            ),
            phoneNumber: '0788123456',
          );

      final draft = repo.savedDrafts.single;
      expect(draft.isYearly, isTrue);
      expect(draft.cadence.wireValue, 'yearly');
      expect(draft.totalPrice, 288000); // 30,000 × 12 × 0.8
      final saved = repo.plans['biz-1']!;
      expect(
        saved.nextBillingDate!.difference(DateTime.now()).inDays,
        inInclusiveRange(364, 365),
      );
    });

    test('a renewal keeps the existing plan id', () async {
      final existing = unpaidPlan(id: 'plan-old');
      final repo = FakeBooksPlanRepository(plans: {'biz-1': existing});
      final rails =
          FakeBooksPaymentRails(momoStatuses: [MomoPaymentStatus.successful]);
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: BooksPlanSelection(
              template: mobileTemplate,
              cadence: BillingCadence.monthly,
              existing: existing,
            ),
            phoneNumber: '0788123456',
          );

      expect(repo.savedDrafts.single.existing?.id, 'plan-old');
      expect(rails.lastPlanId, 'plan-old');
    });

    test('a refused mandate fails without polling — nothing was charged',
        () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails(
        momoOutcome: MomoSubscriptionOutcome.preapprovalRefused,
        momoMessage: 'Consent declined on the handset.',
      );
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: monthlyMobile(),
            phoneNumber: '0788123456',
          );

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.failed);
      expect(state.message, 'Consent declined on the handset.');
      expect(rails.statusCalls, 0);
      expect(repo.finalizeCalls, isEmpty);
    });

    test('a rejected charge fails with the gateway reason', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails(
        momoOutcome: MomoSubscriptionOutcome.chargeRejected,
        momoMessage: 'Amount above the configured ceiling.',
      );
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: monthlyMobile(),
            phoneNumber: '0788123456',
          );

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.failed);
      expect(state.message, 'Amount above the configured ceiling.');
    });

    test('a payment MTN reports failed is failed', () async {
      final repo = FakeBooksPlanRepository();
      final rails =
          FakeBooksPaymentRails(momoStatuses: [MomoPaymentStatus.failed]);
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: monthlyMobile(),
            phoneNumber: '0788123456',
          );

      expect(
        container.read(booksSubscriptionControllerProvider).stage,
        BooksPaymentStage.failed,
      );
      expect(repo.finalizeCalls, isEmpty);
    });

    test('still pending when the window closes times out, not fails',
        () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails();
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: monthlyMobile(),
            phoneNumber: '0788123456',
          );

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.timedOut);
      expect(state.message, isNot(contains('failed')));
      expect(rails.statusCalls, greaterThan(1));
    });

    test('a status read that throws keeps polling until a verdict', () async {
      final repo = FakeBooksPlanRepository();
      final rails =
          FakeBooksPaymentRails(momoStatuses: [MomoPaymentStatus.successful]);
      rails.statusError = Exception('blink');
      final container = _container(repo: repo, rails: rails);

      final done = container
          .read(booksSubscriptionControllerProvider.notifier)
          .payWithMomo(
            business: testBusiness(),
            selection: monthlyMobile(),
            phoneNumber: '0788123456',
          );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      rails.statusError = null;
      await done;

      expect(
        container.read(booksSubscriptionControllerProvider).stage,
        BooksPaymentStage.confirmed,
      );
    });

    test('an implausible number fails before anything is written', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails();
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: monthlyMobile(),
            phoneNumber: '12',
          );

      expect(
        container.read(booksSubscriptionControllerProvider).stage,
        BooksPaymentStage.failed,
      );
      expect(repo.savedDrafts, isEmpty);
      expect(rails.chargeCalls, 0);
    });

    test('a failed row write is reported, and nothing is charged', () async {
      final repo = FakeBooksPlanRepository()..saveError = Exception('rls');
      final rails = FakeBooksPaymentRails();
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithMomo(
            business: testBusiness(),
            selection: monthlyMobile(),
            phoneNumber: '0788123456',
          );

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.failed);
      expect(state.message, contains('rls'));
      expect(rails.chargeCalls, 0);
    });

    test('a second tap while busy is ignored', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails(
        momoStatuses: [MomoPaymentStatus.pending, MomoPaymentStatus.successful],
      );
      final container = _container(repo: repo, rails: rails);
      final controller =
          container.read(booksSubscriptionControllerProvider.notifier);

      final first = controller.payWithMomo(
        business: testBusiness(),
        selection: monthlyMobile(),
        phoneNumber: '0788123456',
      );
      await Future<void>.delayed(Duration.zero);
      await controller.payWithMomo(
        business: testBusiness(),
        selection: monthlyMobile(),
        phoneNumber: '0788123456',
      );
      await first;

      expect(repo.savedDrafts, hasLength(1));
      expect(rails.chargeCalls, 1);
    });
  });

  group('paying by card', () {
    test('writes a DODO row, opens checkout with a return URL, and confirms',
        () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails(
        cardStatuses: [entitledCardStatus('plan-1')],
      );
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithCard(
            business: testBusiness(),
            selection: monthlyMobile(),
            email: 'owner@example.com',
          );

      final draft = repo.savedDrafts.single;
      expect(draft.paymentMethod, 'DODO');
      expect(draft.totalPrice, 30000);
      expect(rails.lastEmail, 'owner@example.com');
      expect(rails.lastReturnUrl, contains('#/subscribe?'));
      expect(rails.lastReturnUrl, contains('planId=plan-1'));
      expect(rails.awaitCardCalls, 1);

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.confirmed);
      expect(state.rail, PaymentRail.card);
      expect(state.checkoutLink, 'https://checkout.dodo.test/abc');
    });

    test('needs an email before anything is written', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails();
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithCard(
            business: testBusiness(),
            selection: monthlyMobile(),
            email: '   ',
          );

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.failed);
      expect(state.message, contains('email'));
      expect(repo.savedDrafts, isEmpty);
      expect(rails.startCardCalls, 0);
    });

    test('a link that would not open fails but keeps the link', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails(
        cardOutcome: DodoCheckoutOutcome.couldNotOpenLink,
      );
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithCard(
            business: testBusiness(),
            selection: monthlyMobile(),
            email: 'owner@example.com',
          );

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.failed);
      expect(state.checkoutLink, 'https://checkout.dodo.test/abc');
      expect(rails.awaitCardCalls, 0);
    });

    test('no verdict inside the window times out', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails();
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithCard(
            business: testBusiness(),
            selection: monthlyMobile(),
            email: 'owner@example.com',
          );

      expect(
        container.read(booksSubscriptionControllerProvider).stage,
        BooksPaymentStage.timedOut,
      );
    });

    test('a declined card fails with a fresh link to fix it', () async {
      final repo = FakeBooksPlanRepository();
      final rails = FakeBooksPaymentRails(
        cardStatuses: [declinedCardStatus('plan-1')],
      );
      final container = _container(repo: repo, rails: rails);

      await container.read(booksSubscriptionControllerProvider.notifier).payWithCard(
            business: testBusiness(),
            selection: monthlyMobile(),
            email: 'owner@example.com',
          );

      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.failed);
      expect(state.checkoutLink, 'https://dodo.test/fix-card');
    });

    test('resuming from the return tab polls without writing a new row',
        () async {
      final repo = FakeBooksPlanRepository(plans: {'biz-1': unpaidPlan(id: 'plan-7')});
      final rails = FakeBooksPaymentRails(
        cardStatuses: [entitledCardStatus('plan-7')],
      );
      final container = _container(repo: repo, rails: rails);

      await container
          .read(booksSubscriptionControllerProvider.notifier)
          .resumeCard(businessId: 'biz-1', planId: 'plan-7');

      expect(repo.savedDrafts, isEmpty);
      expect(rails.startCardCalls, 0);
      expect(rails.awaitCardCalls, 1);
      final state = container.read(booksSubscriptionControllerProvider);
      expect(state.stage, BooksPaymentStage.confirmed);
      expect(state.planId, 'plan-7');
    });
  });

  group('entitlement provider', () {
    test('reads the row and applies the rule', () async {
      final repo = FakeBooksPlanRepository(plans: {'biz-1': paidPlan()});
      final container = _container(repo: repo, rails: FakeBooksPaymentRails());

      final state =
          await container.read(booksAccessStateProvider('biz-1').future);
      expect(state.status, BooksAccessStatus.entitled);
    });

    test('a null business is unknown, which grants', () async {
      final container = _container(
        repo: FakeBooksPlanRepository(),
        rails: FakeBooksPaymentRails(),
      );
      final state = await container.read(booksAccessStateProvider(null).future);
      expect(state.status, BooksAccessStatus.unknown);
      expect(state.grantsAccess, isTrue);
    });

    test('a realtime change on the row re-reads entitlement', () async {
      final repo = FakeBooksPlanRepository(plans: {'biz-1': unpaidPlan()});
      final container = _container(repo: repo, rails: FakeBooksPaymentRails());
      container.listen(booksPlanRealtimeProvider('biz-1'), (_, __) {});

      expect(
        (await container.read(booksAccessStateProvider('biz-1').future)).status,
        BooksAccessStatus.needsPayment,
      );
      final before = repo.fetchCount;

      repo.emit('biz-1', paidPlan());
      await Future<void>.delayed(Duration.zero);

      expect(
        (await container.read(booksAccessStateProvider('biz-1').future)).status,
        BooksAccessStatus.entitled,
      );
      expect(repo.fetchCount, greaterThan(before));
    });

    test('the Individual-business waiver reads the selected business',
        () async {
      final repo = FakeBooksPlanRepository();
      final container = _container(repo: repo, rails: FakeBooksPaymentRails());
      container
          .read(selectedBusinessProvider.notifier)
          .set(testBusiness(businessTypeId: 2, isDefault: true));

      final state =
          await container.read(booksAccessStateProvider('biz-1').future);
      expect(state.waived, isTrue);
    });
  });
}
