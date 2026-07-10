import '../interfaces/analytics_context_provider.dart';
import '../interfaces/analytics_event_store.dart';
import '../interfaces/analytics_transport.dart';
import '../interfaces/product_analytics.dart';
import '../mixins/analytics_context_mixin.dart';
import '../mixins/offline_first_analytics_mixin.dart';
import '../models/pending_analytics_event.dart';

class OfflineFirstAnalytics
    with AnalyticsContextMixin, OfflineFirstAnalyticsMixin
    implements ProductAnalytics {
  OfflineFirstAnalytics({
    required this.contextProvider,
    required this.transport,
    required this.eventStore,
  });

  @override
  final AnalyticsContextProvider contextProvider;

  @override
  final AnalyticsEventStore eventStore;

  @override
  final AnalyticsTransport transport;

  Future<void> initialize() async {
    await eventStore.initialize();
    await transport.initialize();
  }

  @override
  Future<void> flush() async {
    final pending = await eventStore.peekBatch(limit: 100);
    for (final event in pending) {
      try {
        await transport.send(event);
        await eventStore.deleteByIds([event.id]);
      } catch (_) {
        await eventStore.incrementAttempts(event.id);
      }
    }
    await transport.flush();
  }

  @override
  Future<dynamic> getFeatureFlag(String flagKey) {
    return transport.getFeatureFlag(flagKey);
  }

  @override
  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  }) {
    return transport.group(
      groupType,
      groupKey,
      properties: withContext(properties),
    );
  }

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) {
    return transport.identify(
      userId,
      properties: withContext(properties),
    );
  }

  @override
  Future<bool> isFeatureEnabled(String flagKey) {
    return transport.isFeatureEnabled(flagKey);
  }

  @override
  Future<void> reloadFeatureFlags() {
    return transport.reloadFeatureFlags();
  }

  @override
  Future<void> reset() {
    return transport.reset();
  }

  @override
  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  }) {
    return sendOrQueue(
      PendingAnalyticsEvent(
        eventName: r'$screen',
        type: PendingAnalyticsEventType.screen,
        properties: withContext({
          'screen_name': screenName,
          ...properties,
        }),
      ),
    );
  }

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) {
    return sendOrQueue(
      PendingAnalyticsEvent(
        eventName: eventName,
        type: PendingAnalyticsEventType.capture,
        properties: withContext(properties),
      ),
    );
  }
}
