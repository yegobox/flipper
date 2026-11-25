import 'dart:async';

import 'bootstrap/flipper_analytics_bootstrap.dart';
import 'events/analytics_events.dart';
import 'events/analytics_properties.dart';
import 'interfaces/product_analytics.dart';

/// Records that someone created an account and its business: the first step
/// of the onboarding funnel (signup, then a first product, then a first sale).
/// PostHog funnels count first occurrences themselves, so the later steps are
/// the ordinary `product_created` and `transaction_completed` events.
///
/// Call it once, after the server created the business. The session does not
/// hold the new business yet at that point, so the event names it as its
/// PostHog group itself rather than leaving it out.
///
/// Only ids and the choices made on the form: never a name, phone, email or
/// TIN. Fire-and-forget and never throws, like [trackFeatureUsed]: signup
/// must finish whether or not analytics started.
void trackSignupCompleted({
  required String source,
  required String businessId,
  int? businessTypeId,
  String? country,
  bool? localMode,
  String? accountMode,
  ProductAnalytics? analytics,
}) {
  _send(analytics, AnalyticsEvents.signupCompleted, {
    AnalyticsProperties.source: source,
    AnalyticsProperties.businessId: businessId,
    AnalyticsGroups.property: {AnalyticsGroups.business: businessId},
    if (businessTypeId != null) 'business_type_id': businessTypeId,
    if (country != null && country.isNotEmpty) 'country': country,
    if (localMode != null) 'local_mode': localMode,
    if (accountMode != null) 'account_mode': accountMode,
  });
}

/// Records that an expense was saved, from the Cash Book ("Cash Out") or the
/// Books "Record expense" panel ([surface]: `cashbook` or `books`).
///
/// [categoryType] says what kind of category it was filed under, never its
/// name: owners name categories after people and suppliers. No amount either.
/// Fire-and-forget and never throws.
void trackExpenseRecorded({
  required String surface,
  required String categoryType,
  String? paymentMethod,
  ProductAnalytics? analytics,
}) {
  _send(analytics, AnalyticsEvents.expenseRecorded, {
    AnalyticsProperties.source: surface,
    'surface': surface,
    'category_type': categoryType,
    if (paymentMethod != null && paymentMethod.isNotEmpty)
      'payment_method': paymentMethod,
  });
}

/// Sends [event] to [analytics], or the app's instance when none is given.
/// Skipped when there is none (startup's optional analytics step failed).
void _send(
  ProductAnalytics? analytics,
  String event,
  Map<String, Object?> properties,
) {
  final target = analytics ?? FlipperAnalytics.maybeInstance;
  if (target == null) return;
  unawaited(
    target.track(event, properties: properties).catchError((Object _) {}),
  );
}
