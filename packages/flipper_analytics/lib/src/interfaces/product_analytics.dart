abstract class ProductAnalytics {
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  });

  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  });

  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  });

  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  });

  Future<bool> isFeatureEnabled(String flagKey);

  Future<dynamic> getFeatureFlag(String flagKey);

  Future<void> reloadFeatureFlags();

  Future<void> reset();

  Future<void> flush();

  /// Reports an error to PostHog error tracking, tagged like any event
  /// (app, platform, user, business, branch). Never throws.
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  });

  /// Opts this device in to or out of analytics. Off drops events instead of
  /// queueing them (local mode promises nothing leaves the device).
  Future<void> setEnabled(bool enabled);
}
