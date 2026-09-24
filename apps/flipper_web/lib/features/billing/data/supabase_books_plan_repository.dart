import 'dart:async';
import 'dart:convert';

import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/data/books_plan_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// A read that can answer when Supabase cannot — Ditto's mirrored `plans`
/// document, on a device that has one.
typedef BooksOfflinePlanReader = Future<Plan?> Function(String businessId);

/// Supabase-backed [BooksPlanRepository].
///
/// Supabase is authoritative: it is where data-connector settles a payment and
/// where an admin edits a plan. Ditto's copy is only consulted when Supabase
/// cannot be reached, and never to override a fresh row.
class SupabaseBooksPlanRepository implements BooksPlanRepository {
  SupabaseBooksPlanRepository(
    this._supabase,
    this._http, {
    BooksOfflinePlanReader? offlineFallback,
    Duration nudgeTimeout = const Duration(seconds: 10),
  }) : _offlineFallback = offlineFallback,
       _nudgeTimeout = nudgeTimeout;

  final SupabaseClient _supabase;
  final http.Client _http;
  final BooksOfflinePlanReader? _offlineFallback;
  final Duration _nudgeTimeout;

  @override
  Future<Plan?> fetchPlan(String businessId) async {
    try {
      final row = await _supabase
          .from('plans')
          .select()
          .eq('business_id', businessId)
          .maybeSingle();
      if (row == null) return null;
      return Plan.fromSupabaseJson(Map<String, dynamic>.from(row));
    } catch (e) {
      final fallback = _offlineFallback;
      if (fallback == null) rethrow;
      debugPrint('plans: Supabase read failed ($e); trying Ditto');
      final local = await fallback(businessId);
      if (local == null) rethrow;
      return local;
    }
  }

  @override
  Stream<Plan?> watchPlan(String businessId) {
    // `.stream()` allows one PostgREST filter; narrow by business and pick the
    // row in the listener. A business is meant to have exactly one.
    return _supabase
        .from('plans')
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
        .map((rows) {
          if (rows.isEmpty) return null;
          return Plan.fromSupabaseJson(Map<String, dynamic>.from(rows.first));
        });
  }

  @override
  Future<Plan> savePlan(BooksPlanDraft draft) async {
    // A business keeps one row. The upsert conflicts on `id`, so minting a
    // fresh id while a row already exists would leave two — and mobile's
    // `.maybeSingle()` read would then fail for that business. When the
    // caller did not hand us the current row, look for it first.
    final existing = draft.existing ?? await _currentRow(draft.businessId);
    final planId = existing?.id ?? const Uuid().v4();
    final now = DateTime.now().toUtc();
    final nextBillingDate = now.add(
      Duration(days: draft.cadence.periodDays * draft.numberOfPayments),
    );

    // Same keys, same values, as `CoreSync._upsertPlan` on mobile. A phone
    // reading this row must not be able to tell which app wrote it.
    final planData = <String, dynamic>{
      'id': planId,
      'business_id': draft.businessId,
      if (draft.branchId != null) 'branch_id': draft.branchId,
      'selected_plan': draft.selectedPlan,
      if (draft.planTemplateId != null)
        'plan_template_id': draft.planTemplateId,
      'additional_devices': draft.additionalDevices,
      // Kept for released clients that still read it; it cannot express daily.
      'is_yearly_plan': draft.isYearly,
      'rule': draft.cadence.wireValue,
      'total_price': draft.totalPrice,
      'payment_method': draft.paymentMethod,
      'payment_completed_by_user': false,
      'next_billing_date': nextBillingDate.toIso8601String(),
      'number_of_payments': draft.numberOfPayments,
      if (draft.phoneNumber != null && draft.phoneNumber!.trim().isNotEmpty)
        'phone_number': draft.phoneNumber!.trim(),
      'created_at':
          existing?.createdAt?.toIso8601String() ?? now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    await _supabase.from('plans').upsert(planData);

    final addons = await _syncAddons(draft);

    unawaited(nudgeDittoSync(planId));

    return Plan(
      id: planId,
      businessId: draft.businessId,
      branchId: draft.branchId,
      selectedPlan: draft.selectedPlan,
      planTemplateId: draft.planTemplateId,
      additionalDevices: draft.additionalDevices,
      isYearlyPlan: draft.isYearly,
      rule: draft.cadence.wireValue,
      totalPrice: draft.totalPrice,
      createdAt: existing?.createdAt ?? now,
      numberOfPayments: draft.numberOfPayments,
      nextBillingDate: nextBillingDate,
      paymentMethod: draft.paymentMethod,
      addons: addons,
      phoneNumber: draft.phoneNumber,
      paymentCompletedByUser: false,
      updatedAt: now,
    );
  }

  /// The row Supabase holds for [businessId] right now — never Ditto's copy,
  /// which is what the write is about to overtake.
  Future<Plan?> _currentRow(String businessId) async {
    final row = await _supabase
        .from('plans')
        .select()
        .eq('business_id', businessId)
        .maybeSingle();
    if (row == null) return null;
    return Plan.fromSupabaseJson(Map<String, dynamic>.from(row));
  }

  /// Inserts add-ons the business does not already have.
  ///
  /// `addons.plan_id` holds the **business** id, not the plan id — that is
  /// what mobile writes (`CoreSync._processNewAddons`) and what its
  /// `select('*, addons(*)')` join expects, so it is kept here on purpose.
  Future<List<PlanAddon>> _syncAddons(BooksPlanDraft draft) async {
    final existing = await _existingAddons(draft.businessId);
    if (draft.addonNames.isEmpty) return existing;

    final have = existing.map((a) => a.addonName).toSet();
    final rows = <Map<String, dynamic>>[];
    final added = <PlanAddon>[];
    for (final name in draft.addonNames) {
      if (have.contains(name)) continue;
      final addon = PlanAddon(
        addonName: name,
        createdAt: DateTime.now().toUtc(),
        planId: draft.businessId,
      );
      added.add(addon);
      rows.add({
        'id': addon.id,
        'plan_id': addon.planId,
        'addon_name': addon.addonName,
        'created_at': addon.createdAt?.toIso8601String(),
      });
    }
    if (rows.isNotEmpty) {
      await _supabase.from('addons').insert(rows);
    }
    return [...existing, ...added];
  }

  Future<List<PlanAddon>> _existingAddons(String businessId) async {
    try {
      final response = await _supabase
          .from('plans')
          .select('*, addons(*)')
          .eq('business_id', businessId)
          .maybeSingle();
      final raw = response?['addons'];
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map(
            (row) => PlanAddon(
              id: row['id']?.toString(),
              planId: row['plan_id']?.toString(),
              addonName: row['addon_name']?.toString(),
              createdAt: DateTime.tryParse('${row['created_at']}'),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('plans: could not read existing add-ons: $e');
      return const [];
    }
  }

  @override
  Future<void> nudgeDittoSync(String planId) =>
      _post('/v2/api/plans/$planId/sync-ditto', what: 'plan Ditto sync');

  @override
  Future<void> finalizeOnSuccess({
    required String planId,
    required String reference,
  }) => _post(
    '/v2/api/payment/finalize-on-success',
    body: {'planId': planId, 'paymentReference': reference},
    what: 'payment finalize',
  );

  /// Best-effort POST to data-connector. Never throws: both callers are
  /// nudges, and the backend's own sweeps cover a nudge that never lands.
  Future<void> _post(
    String path, {
    Map<String, dynamic>? body,
    required String what,
  }) async {
    try {
      final base = await paymentsApiBaseUrl();
      // Through the device-token client: the bare one 401s once the connector
      // enforces auth, and a nudge that never lands just waits for a sweep.
      final response = await DataConnectorClient(baseUrl: base, inner: _http)
          .post(
            Uri.parse('$base$path'),
            headers: const {'Content-Type': 'application/json'},
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(_nudgeTimeout);
      if (response.statusCode >= 400) {
        debugPrint(
          'plans: $what returned ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('plans: $what failed: $e');
    }
  }
}
