import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/custom_payment/data/billing_staff_repository.dart';
import 'package:flipper_web/features/custom_payment/data/business_search_repository.dart';
import 'package:flipper_web/features/custom_payment/data/custom_payment_api.dart';

/// Scripted stand-in for the connector's staff endpoints.
class FakeCustomPaymentApi implements CustomPaymentApi {
  FakeCustomPaymentApi({
    this.statuses = const [],
    this.createError,
    this.rail = CustomPaymentRail.momo,
  });

  /// Statuses the poll walks through, in order. The last one is repeated.
  final List<CustomPaymentStatus> statuses;
  final CustomPaymentException? createError;
  final CustomPaymentRail rail;

  final List<CustomPaymentDraft> created = [];
  int polls = 0;

  CustomPaymentView view(CustomPaymentStatus status, {String id = 'cp-1'}) =>
      CustomPaymentView(
        id: id,
        businessId: 'biz-1',
        planId: 'plan-1',
        rail: rail,
        amount: 25000,
        currency: 'RWF',
        cadence: CustomPaymentCadence.monthly,
        status: status,
        nextAction: switch (status) {
          CustomPaymentStatus.awaitingApproval =>
            CustomPaymentNextAction.approveOnPhone,
          CustomPaymentStatus.awaitingCheckout =>
            CustomPaymentNextAction.openPaymentLink,
          CustomPaymentStatus.settled => CustomPaymentNextAction.none,
          CustomPaymentStatus.failed ||
          CustomPaymentStatus.expired => CustomPaymentNextAction.retry,
          _ => CustomPaymentNextAction.awaitingSettlement,
        },
        nextBillingDate: status.isSettled ? '2026-10-14' : '2026-09-14',
        chargeId: rail.isMomo ? 'charge-1' : null,
        financialTransactionId: rail.isMomo && status.isSettled ? 'ft-1' : null,
        dodoSubscriptionId: rail.isCard ? 'sub_1' : null,
        dodoPaymentId: rail.isCard ? 'pay_1' : null,
        checkout: rail.isCard
            ? const DodoCheckout(paymentLink: 'https://checkout.example/x')
            : null,
        previous: const CustomPaymentPrevious(rail: 'momo', totalPrice: 5100),
      );

  @override
  Future<CustomPaymentView> create(CustomPaymentDraft draft) async {
    if (createError != null) throw createError!;
    created.add(draft);
    return view(
      rail.isCard
          ? CustomPaymentStatus.awaitingCheckout
          : CustomPaymentStatus.awaitingApproval,
    );
  }

  @override
  Future<CustomPaymentView?> awaitSettlement(
    String id, {
    required CustomPaymentRail rail,
    required Duration timeout,
    required Duration pollInterval,
    void Function(CustomPaymentView view)? onStatus,
    bool Function()? isCancelled,
  }) async {
    final deadline = DateTime.now().add(timeout);
    CustomPaymentView? last;
    while (DateTime.now().isBefore(deadline)) {
      if (isCancelled?.call() == true) return last;
      if (statuses.isEmpty) {
        await Future<void>.delayed(pollInterval);
        continue;
      }
      final status = statuses[polls.clamp(0, statuses.length - 1)];
      polls++;
      last = view(status);
      onStatus?.call(last);
      if (last.isTerminal) return last;
      await Future<void>.delayed(pollInterval);
    }
    return last;
  }

  @override
  Future<CustomPaymentView> status(String id, {bool sync = false}) async =>
      view(statuses.isEmpty ? CustomPaymentStatus.pending : statuses.last);

  @override
  Future<List<CustomPaymentView>> recentForBusiness(String businessId) async =>
      const [];
}

class FakeBillingStaffRepository implements BillingStaffRepository {
  FakeBillingStaffRepository({this.member});

  final BillingStaffMember? member;

  @override
  Future<BillingStaffMember?> current() async => member;
}

class FakeBusinessSearchRepository implements BusinessSearchRepository {
  FakeBusinessSearchRepository({this.hits = const []});

  final List<BusinessHit> hits;
  final List<String> queries = [];

  @override
  Future<List<BusinessHit>> search(String query, {int limit = 15}) async {
    queries.add(query);
    final q = query.toLowerCase();
    return hits
        .where(
          (h) =>
              h.name.toLowerCase().contains(q) ||
              (h.phoneNumber ?? '').contains(q) ||
              h.id == query,
        )
        .toList();
  }
}

const testStaff = BillingStaffMember(
  userId: 'user-1',
  staffToken: 'tok-1',
  displayName: 'Jane',
);

const testHit = BusinessHit(
  id: 'biz-1',
  name: 'Kigali Mart',
  phoneNumber: '0788123456',
  email: 'owner@kigalimart.rw',
);
