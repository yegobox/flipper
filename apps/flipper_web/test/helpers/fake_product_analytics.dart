import 'package:flipper_analytics/flipper_analytics.dart';

/// No-op [ProductAnalytics] for unit/widget tests.
class FakeProductAnalytics implements ProductAnalytics {
  @override
  Future<void> flush() async {}

  @override
  Future<dynamic> getFeatureFlag(String flagKey) async => null;

  @override
  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  }) async {}

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {}

  @override
  Future<bool> isFeatureEnabled(String flagKey) async => false;

  @override
  Future<void> reloadFeatureFlags() async {}

  @override
  Future<void> reset() async {}

  @override
  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  }) async {}

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {}
}
