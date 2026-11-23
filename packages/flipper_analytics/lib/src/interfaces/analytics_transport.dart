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

  /// Sends an `$exception` event to PostHog error tracking.
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  });

  /// Opts this device in to or out of sending anything at all.
  Future<void> setEnabled(bool enabled);
}
