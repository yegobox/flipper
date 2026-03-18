import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/brick/models/plans.model.dart';
import 'ditto_core_mixin.dart';

mixin PlanMixin on DittoCore {
  /// Get the payment plan for a business from Ditto.
  /// Returns server-synced plan data, available even when offline.
  /// Returns null if Ditto is not ready or no plan exists for the business.
  Future<Plan?> getPaymentPlanFromDitto(String businessId) async {
    if (dittoInstance == null) {
      return handleNotInitializedAndReturn('getPaymentPlanFromDitto', null);
    }

    try {
      final result = await dittoInstance!.store.execute(
        "SELECT * FROM plans WHERE businessId = :businessId",
        arguments: {"businessId": businessId},
      );

      if (result.items.isEmpty) return null;

      final doc = Map<String, dynamic>.from(result.items.first.value);
      return _planFromDittoDocument(doc);
    } catch (e) {
      debugPrint('❌ Error getting payment plan from Ditto: $e');
      return null;
    }
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
    );
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
