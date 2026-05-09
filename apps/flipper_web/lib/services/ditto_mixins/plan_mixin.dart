import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'ditto_core_mixin.dart';

mixin PlanMixin on DittoCore {
  /// Registered [businessId]s for which we already installed a
  /// [Sync.registerSubscription] for the `plans` collection.
  static final Set<String> _planReplicationSubscriptions = {};

  /// Registered plan ids for `addons` replication.
  static final Set<String> _addonReplicationSubscriptions = {};

  static const String _planQuery =
      'SELECT * FROM plans WHERE businessId = :businessId';

  static const String _addonQuery =
      'SELECT * FROM addons WHERE planId = :planId';

  /// Ensures Ditto **replicates** matching `plans` documents from the mesh /
  /// Big Peer. Without this, [Store.execute] only sees whatever is already
  /// local and never pulls online updates (see Ditto `Store.execute` docs).
  ///
  /// Returns `true` the first time we register for this [businessId].
  bool _ensurePlanReplicationSubscription(String businessId) {
    if (dittoInstance == null) return false;
    if (_planReplicationSubscriptions.contains(businessId)) return false;
    final prepared = prepareDqlSyncSubscription(
      _planQuery,
      {'businessId': businessId},
    );
    dittoInstance!.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
    _planReplicationSubscriptions.add(businessId);
    return true;
  }

  /// Returns `true` the first time we register for this [planId].
  bool _ensureAddonReplicationSubscription(String planId) {
    if (dittoInstance == null) return false;
    if (_addonReplicationSubscriptions.contains(planId)) return false;
    final prepared = prepareDqlSyncSubscription(
      _addonQuery,
      {'planId': planId},
    );
    dittoInstance!.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
    _addonReplicationSubscriptions.add(planId);
    return true;
  }

  List<Map<String, dynamic>> _mapsFromQueryResult(QueryResult result) {
    return result.items
        .map((item) => Map<String, dynamic>.from(item.value))
        .toList();
  }

  /// Get the payment plan for a business from Ditto.
  /// Returns server-synced plan data, available even when offline.
  /// Returns null if Ditto is not ready or no plan exists for the business.
  Future<Plan?> getPaymentPlanFromDitto(String businessId) async {
    if (dittoInstance == null) {
      return handleNotInitializedAndReturn('getPaymentPlanFromDitto', null);
    }

    final args = {'businessId': businessId};

    try {
      final isNewReplicationSub = _ensurePlanReplicationSubscription(
        businessId,
      );

      List<Map<String, dynamic>> execDocs;
      List<Map<String, dynamic>>? observerSnapshot;

      if (isNewReplicationSub) {
        // First time for this business: observe while replication catches up
        // ([Store.execute] does not wait for sync — Ditto docs).
        late final StoreObserver observer;
        observer = dittoInstance!.store.registerObserver(
          _planQuery,
          arguments: args,
          onChange: (result) {
            observerSnapshot = _mapsFromQueryResult(result);
          },
        );
        final streamSub = observer.changes.listen((_) {});
        try {
          await Future.delayed(const Duration(milliseconds: 1200));
        } finally {
          await streamSub.cancel();
          observer.cancel();
        }
      }

      final execResult = await dittoInstance!.store.execute(
        _planQuery,
        arguments: args,
      );
      execDocs = _mapsFromQueryResult(execResult);

      final merged = <Map<String, dynamic>>[...execDocs, ...?observerSnapshot];
      if (merged.isEmpty) return null;

      final doc = _selectCanonicalPlanDocument(merged);
      final planId = (doc['_id'] ?? doc['id'])?.toString();
      List<PlanAddon> addons = const [];
      if (planId != null && planId.isNotEmpty) {
        addons = await _addonsForPlanFromDitto(planId);
      }
      return _planFromDittoDocument(doc, addons: addons);
    } catch (e) {
      debugPrint('❌ Error getting payment plan from Ditto: $e');
      return null;
    }
  }

  Future<List<PlanAddon>> _addonsForPlanFromDitto(String planId) async {
    if (dittoInstance == null) return const [];

    final args = {'planId': planId};
    try {
      final isNew = _ensureAddonReplicationSubscription(planId);
      List<Map<String, dynamic>>? observerSnapshot;

      if (isNew) {
        late final StoreObserver observer;
        observer = dittoInstance!.store.registerObserver(
          _addonQuery,
          arguments: args,
          onChange: (result) {
            observerSnapshot = _mapsFromQueryResult(result);
          },
        );
        final streamSub = observer.changes.listen((_) {});
        try {
          await Future.delayed(const Duration(milliseconds: 1200));
        } finally {
          await streamSub.cancel();
          observer.cancel();
        }
      }

      final execResult = await dittoInstance!.store.execute(
        _addonQuery,
        arguments: args,
      );
      final execDocs = _mapsFromQueryResult(execResult);
      final merged = <Map<String, dynamic>>[...execDocs, ...?observerSnapshot];

      return merged.map(PlanAddon.fromDittoDocument).toList(growable: false);
    } catch (e) {
      debugPrint('❌ Error getting plan addons from Ditto: $e');
      return const [];
    }
  }

  /// When Ditto has more than one `plans` row per [businessId] (e.g. stale
  /// duplicates), `SELECT` order is undefined. Pick the row that represents the
  /// current subscription: latest [nextBillingDate], then latest update time.
  Map<String, dynamic> _selectCanonicalPlanDocument(
    List<Map<String, dynamic>> docs,
  ) {
    if (docs.length == 1) return docs.single;

    debugPrint(
      '⚠️ getPaymentPlanFromDitto: ${docs.length} plan documents for same '
      'business; using canonical row (latest nextBillingDate / updatedAt)',
    );

    final sorted = List<Map<String, dynamic>>.from(docs)
      ..sort(_comparePlanDocumentsForCanonical);
    return sorted.first;
  }

  int _comparePlanDocumentsForCanonical(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final na = _parseDateTime(a['nextBillingDate']);
    final nb = _parseDateTime(b['nextBillingDate']);
    if (na != null && nb != null && na != nb) {
      return nb.compareTo(na);
    }
    if (na != null && nb == null) return -1;
    if (na == null && nb != null) return 1;

    final ua =
        _parseDateTime(a['updatedAt']) ?? _parseDateTime(a['lastUpdated']);
    final ub =
        _parseDateTime(b['updatedAt']) ?? _parseDateTime(b['lastUpdated']);
    if (ua != null && ub != null && ua != ub) {
      return ub.compareTo(ua);
    }
    if (ua != null && ub == null) return -1;
    if (ua == null && ub != null) return 1;

    final pa = _parseDateTime(a['lastPaymentDate']);
    final pb = _parseDateTime(b['lastPaymentDate']);
    if (pa != null && pb != null && pa != pb) {
      return pb.compareTo(pa);
    }
    return 0;
  }

  Plan _planFromDittoDocument(
    Map<String, dynamic> document, {
    List<PlanAddon> addons = const [],
  }) {
    final idRaw = document['_id'] ?? document['id'];
    if (idRaw == null) throw ArgumentError('Plan document missing id');
    final id = idRaw.toString();

    return Plan(
      id: id,
      businessId: document['businessId']?.toString(),
      branchId: document['branchId']?.toString(),
      selectedPlan: document['selectedPlan']?.toString(),
      additionalDevices: (document['additionalDevices'] as num?)?.toInt(),
      isYearlyPlan: document['isYearlyPlan'] as bool?,
      totalPrice: (document['totalPrice'] as num?)?.toInt(),
      createdAt: _parseDateTime(document['createdAt']),
      paymentCompletedByUser: document['paymentCompletedByUser'] == true,
      rule: document['rule']?.toString(),
      paymentMethod: document['paymentMethod']?.toString(),
      nextBillingDate: _parseDateTime(document['nextBillingDate']),
      numberOfPayments: (document['numberOfPayments'] as num?)?.toInt(),
      addons: addons,
      phoneNumber: document['phoneNumber']?.toString(),
      externalId: document['externalId']?.toString(),
      paymentStatus: document['paymentStatus']?.toString(),
      lastProcessedAt: _parseDateTime(document['lastProcessedAt']),
      lastError: document['lastError']?.toString(),
      updatedAt: _parseDateTime(document['updatedAt']),
      lastUpdated: _parseDateTime(document['lastUpdated']),
      processingStatus: document['processingStatus']?.toString(),
      lastPaymentDate: _parseDateTime(document['lastPaymentDate']),
    );
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
