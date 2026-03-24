import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/brick/models/plan.dart';
import 'ditto_core_mixin.dart';

mixin PlanMixin on DittoCore {
  /// Registered [businessId]s for which we already installed a
  /// [Sync.registerSubscription] for the `plans` collection.
  static final Set<String> _planReplicationSubscriptions = {};

  static const String _planQuery =
      'SELECT * FROM plans WHERE businessId = :businessId';

  /// Ensures Ditto **replicates** matching `plans` documents from the mesh /
  /// Big Peer. Without this, [Store.execute] only sees whatever is already
  /// local and never pulls online updates (see Ditto `Store.execute` docs).
  ///
  /// Returns `true` the first time we register for this [businessId].
  bool _ensurePlanReplicationSubscription(String businessId) {
    if (dittoInstance == null) return false;
    if (_planReplicationSubscriptions.contains(businessId)) return false;
    dittoInstance!.sync.registerSubscription(
      _planQuery,
      arguments: {'businessId': businessId},
    );
    _planReplicationSubscriptions.add(businessId);
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
      return _planFromDittoDocument(doc);
    } catch (e) {
      debugPrint('❌ Error getting payment plan from Ditto: $e');
      return null;
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

  Plan _planFromDittoDocument(Map<String, dynamic> document) {
    final id = document["_id"] ?? document["id"];
    if (id == null) throw ArgumentError('Plan document missing id');

    return Plan(
      id: id,
      businessId: document["businessId"],
      branchId: document["branchId"],
      selectedPlan: document["selectedPlan"],
      additionalDevices: document["additionalDevices"],
      isYearlyPlan: document["isYearlyPlan"],
      totalPrice: document["totalPrice"],
      createdAt: _parseDateTime(document["createdAt"]),
      paymentCompletedByUser: document["paymentCompletedByUser"],
      rule: document["rule"],
      paymentMethod: document["paymentMethod"],
      nextBillingDate: _parseDateTime(document["nextBillingDate"]),
      numberOfPayments: document["numberOfPayments"],
      phoneNumber: document["phoneNumber"],
      externalId: document["externalId"],
      paymentStatus: document["paymentStatus"],
      lastProcessedAt: _parseDateTime(document["lastProcessedAt"]),
      lastError: document["lastError"],
      updatedAt: _parseDateTime(document["updatedAt"]),
      lastUpdated: _parseDateTime(document["lastUpdated"]),
      processingStatus: document["processingStatus"],
      lastPaymentDate: _parseDateTime(document["lastPaymentDate"]),
    );
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
