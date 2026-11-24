import 'dart:async';

import 'bootstrap/flipper_analytics_bootstrap.dart';
import 'events/analytics_events.dart';
import 'events/analytics_properties.dart';
import 'interfaces/product_analytics.dart';

/// Records that [module] was opened or used.
///
/// Fire-and-forget and never throws: a module must open whether or not
/// analytics started. [analytics] defaults to the app's instance and is
/// skipped when there is none (startup's optional analytics step failed).
void trackFeatureUsed(
  String module, {
  String action = 'open',
  Map<String, Object?> properties = const {},
  ProductAnalytics? analytics,
}) {
  final target = analytics ?? FlipperAnalytics.maybeInstance;
  if (target == null) return;
  unawaited(
    target
        .track(
          AnalyticsEvents.featureUsed,
          properties: {
            ...properties,
            AnalyticsProperties.module: module,
            AnalyticsProperties.action: action,
          },
        )
        .catchError((Object _) {}),
  );
}
