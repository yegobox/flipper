import '../models/pending_analytics_event.dart';

abstract class AnalyticsTransport {
  Future<void> initialize();

  Future<void> send(PendingAnalyticsEvent event);

  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  });

  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  });

  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  });

  Future<void> reset();

  Future<void> flush();

  Future<bool> isFeatureEnabled(String flagKey);

  Future<dynamic> getFeatureFlag(String flagKey);

  Future<void> reloadFeatureFlags();
}
