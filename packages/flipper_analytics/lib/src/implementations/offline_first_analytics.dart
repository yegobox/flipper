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
    bool enabled = true,
  }) : _enabled = enabled;

  /// A queued event that has failed this many sends is dropped, so one event
  /// PostHog will never accept can't hold up everything queued behind it.
  static const maxSendAttempts = 5;

  bool _enabled;

  /// False while the device is opted out (local mode).
  bool get enabled => _enabled;

  @override
  final AnalyticsContextProvider contextProvider;

  @override
  final AnalyticsEventStore eventStore;

  @override
  final AnalyticsTransport transport;

  Future<void> initialize() async {
    await eventStore.initialize();
    await transport.initialize();
    // The SDK remembers an opt-out across restarts and prefers it to the
    // config, so a till that left local mode must be opted back in here.
    await transport.setEnabled(_enabled);
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    if (_enabled == enabled) return;
    _enabled = enabled;
    await transport.setEnabled(enabled);
  }

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  }) async {
    if (!_enabled) return;
    try {
      await transport.captureException(
        error,
        stackTrace: stackTrace,
        properties: withContext(properties),
      );
    } catch (_) {
      // Error reporting runs inside error handlers: it must never throw.
    }
  }

  @override
  Future<void> flush() async {
    if (!_enabled) return;
    final pending = await eventStore.peekBatch(limit: 100);
    for (final event in pending) {
      if (event.attemptCount >= maxSendAttempts) {
        await eventStore.deleteByIds([event.id]);
        continue;
      }
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
  }) async {
    if (!_enabled) return;
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
  }) async {
    if (!_enabled) return;
    return transport.identify(userId, properties: withContext(properties));
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
  }) async {
    if (!_enabled) return;
    return sendOrQueue(
      PendingAnalyticsEvent(
        eventName: r'$screen',
        type: PendingAnalyticsEventType.screen,
        properties: withContext({'screen_name': screenName, ...properties}),
      ),
    );
  }

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {
    if (!_enabled) return;
    return sendOrQueue(
      PendingAnalyticsEvent(
        eventName: eventName,
        type: PendingAnalyticsEventType.capture,
        properties: withContext(properties),
      ),
    );
  }
}
