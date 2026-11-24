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
  Future<void> setEnabled(bool enabled) async {}

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  }) async {}

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

/// Records what the app sends, each event tagged by [contextProvider] the way
/// the real analytics tags it (base properties plus `$groups`).
class RecordingProductAnalytics extends FakeProductAnalytics
    with AnalyticsContextMixin {
  RecordingProductAnalytics(this.contextProvider);

  @override
  final AnalyticsContextProvider contextProvider;

  /// Each tracked event's name and its properties as sent.
  final events = <(String, Map<String, Object?>)>[];

  /// `identify:<id>` and `group:<type>:<key>` calls, in order.
  final calls = <String>[];

  /// The properties of each [calls] entry.
  final callProperties = <Map<String, Object?>>[];

  /// The properties of the last event named [eventName].
  Map<String, Object?> lastEvent(String eventName) =>
      events.lastWhere((event) => event.$1 == eventName).$2;

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {
    events.add((eventName, withEventContext(properties)));
  }

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {
    calls.add('identify:$userId');
    callProperties.add(properties);
  }

  @override
  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  }) async {
    calls.add('group:$groupType:$groupKey');
    callProperties.add(properties);
  }
}
