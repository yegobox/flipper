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
}
