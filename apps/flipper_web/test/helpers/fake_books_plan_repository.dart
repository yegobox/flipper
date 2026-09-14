import 'dart:async';

import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/data/books_plan_repository.dart';

/// In-memory [BooksPlanRepository]: one row per business, every write and
/// nudge recorded so a test can assert on the exact row shape.
class FakeBooksPlanRepository implements BooksPlanRepository {
  FakeBooksPlanRepository({Map<String, Plan?>? plans})
      : plans = {...?plans};

  final Map<String, Plan?> plans;
  final List<BooksPlanDraft> savedDrafts = [];
  final List<String> nudgeCalls = [];
  final List<({String planId, String reference})> finalizeCalls = [];
  final Map<String, StreamController<Plan?>> _streams = {};

  /// Makes the next [savePlan] throw.
  Object? saveError;

  /// Makes every [fetchPlan] throw.
  Object? fetchError;

  int fetchCount = 0;

  @override
  Future<Plan?> fetchPlan(String businessId) async {
    fetchCount++;
    final error = fetchError;
    if (error != null) throw error;
    return plans[businessId];
  }

  @override
  Stream<Plan?> watchPlan(String businessId) {
    final controller = _streams.putIfAbsent(
      businessId,
      () => StreamController<Plan?>.broadcast(),
    );
    return Stream.multi((sink) {
      sink.add(plans[businessId]);
      final sub = controller.stream.listen(sink.add, onError: sink.addError);
      sink.onCancel = sub.cancel;
    });
  }

  /// Simulates a realtime change landing on the row.
  void emit(String businessId, Plan? plan) {
    plans[businessId] = plan;
    _streams[businessId]?.add(plan);
  }

  @override
  Future<Plan> savePlan(BooksPlanDraft draft) async {
    final error = saveError;
    if (error != null) {
      saveError = null;
      throw error;
    }
    savedDrafts.add(draft);
    final now = DateTime.now().toUtc();
    final plan = Plan(
      id: draft.existing?.id ?? 'plan-${savedDrafts.length}',
      businessId: draft.businessId,
      branchId: draft.branchId,
      selectedPlan: draft.selectedPlan,
      planTemplateId: draft.planTemplateId,
      additionalDevices: draft.additionalDevices,
      isYearlyPlan: draft.isYearly,
      rule: draft.cadence.wireValue,
      totalPrice: draft.totalPrice,
      paymentMethod: draft.paymentMethod,
      paymentCompletedByUser: false,
      paymentStatus: 'PENDING',
      numberOfPayments: draft.numberOfPayments,
      nextBillingDate: now.add(
        Duration(days: draft.cadence.periodDays * draft.numberOfPayments),
      ),
      phoneNumber: draft.phoneNumber,
      createdAt: draft.existing?.createdAt ?? now,
      updatedAt: now,
    );
    plans[draft.businessId] = plan;
    return plan;
  }

  @override
  Future<void> nudgeDittoSync(String planId) async {
    nudgeCalls.add(planId);
  }

  @override
  Future<void> finalizeOnSuccess({
    required String planId,
    required String reference,
  }) async {
    finalizeCalls.add((planId: planId, reference: reference));
  }

  /// Marks the row paid, the way data-connector does on settlement.
  void settle(String businessId) {
    final current = plans[businessId];
    if (current == null) return;
    current
      ..paymentCompletedByUser = true
      ..paymentStatus = 'COMPLETED'
      ..lastPaymentDate = DateTime.now();
  }

  void dispose() {
    for (final c in _streams.values) {
      c.close();
    }
  }
}

Plan paidPlan({
  String id = 'plan-paid',
  String businessId = 'biz-1',
  DateTime? nextBillingDate,
  String? phoneNumber,
}) =>
    Plan(
      id: id,
      businessId: businessId,
      selectedPlan: 'Mobile',
      planTemplateId: 'tpl-mobile',
      rule: 'monthly',
      paymentCompletedByUser: true,
      paymentStatus: 'COMPLETED',
      nextBillingDate:
          nextBillingDate ?? DateTime.now().add(const Duration(days: 20)),
      phoneNumber: phoneNumber,
    );

Plan unpaidPlan({
  String id = 'plan-unpaid',
  String businessId = 'biz-1',
  String? paymentStatus,
  DateTime? nextBillingDate,
}) =>
    Plan(
      id: id,
      businessId: businessId,
      selectedPlan: 'Mobile',
      rule: 'monthly',
      paymentCompletedByUser: false,
      paymentStatus: paymentStatus,
      nextBillingDate: nextBillingDate,
    );
