import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_services/abstractions/analytic.dart';

class FlipperAnalyticService implements Analytic {
  FlipperAnalyticService(this._analytics);

  final ProductAnalytics _analytics;

  @override
  void addContext() {}

  @override
  void trackEvent(String eventName, Map<String, dynamic> parameters) {
    _analytics.track(
      eventName,
      properties: Map<String, Object?>.from(parameters),
    );
  }
}
