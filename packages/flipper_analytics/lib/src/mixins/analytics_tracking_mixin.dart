import '../events/analytics_events.dart';
import '../interfaces/product_analytics.dart';

mixin AnalyticsTrackingMixin {
  ProductAnalytics get analytics;

  Future<void> trackLoginSuccess({
    required String source,
    String? businessId,
    String? branchId,
    bool? commissionOnly,
  }) {
    return analytics.track(
      AnalyticsEvents.loginSuccess,
      properties: {
        'source': source,
        if (businessId != null) 'business_id': businessId,
        if (branchId != null) 'branch_id': branchId,
        if (commissionOnly != null) 'commission_only': commissionOnly,
      },
    );
  }

  Future<void> trackLoginFailed({
    required String source,
    required String reason,
  }) {
    return analytics.track(
      AnalyticsEvents.loginFailed,
      properties: {
        'source': source,
        'reason': reason,
      },
    );
  }

  Future<void> trackTransactionCompleted({
    required String transactionId,
    required String source,
    String? businessId,
    String? branchId,
    String? createdAt,
    String? completedAt,
    int? durationSeconds,
  }) {
    return analytics.track(
      AnalyticsEvents.transactionCompleted,
      properties: {
        'transaction_id': transactionId,
        'source': source,
        if (businessId != null) 'business_id': businessId,
        if (branchId != null) 'branch_id': branchId,
        if (createdAt != null) 'created_at': createdAt,
        if (completedAt != null) 'completed_at': completedAt,
        if (durationSeconds != null) 'duration_seconds': durationSeconds,
      },
    );
  }

  Future<void> trackProductCreated({required String source}) {
    return analytics.track(
      AnalyticsEvents.productCreated,
      properties: {'source': source},
    );
  }
}
