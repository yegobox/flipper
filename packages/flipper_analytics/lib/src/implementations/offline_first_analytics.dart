import '../events/analytics_properties.dart';
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

  /// The user and groups this run has given the SDK. A till that reopens
  /// with a saved session never signs in, so nothing else would identify or
  /// group it: its events would stay personless, and PostHog drops `$groups`
  /// from personless events. [_syncSession] fills that in once per run, and
  /// again when the business or branch changes.
  String? _syncedUserId;
  final Map<String, String> _syncedGroups = {};
  // Being sent now, so concurrent events don't send them twice. Moved to
  // the synced fields only once the SDK call succeeds; a failure is retried
  // on the next event.
  String? _syncingUserId;
  final Map<String, String> _syncingGroups = {};
  Future<void>? _syncing;

  /// Bumped by [reset]: a sync queued before it belongs to the old session
  /// and must neither run nor record anything afterwards.
  int _session = 0;

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
      // Like any event: a restored session's first exception must not go
      // out personless (PostHog would drop its groups).
      await _syncSession();
      await transport.captureException(
        error,
        stackTrace: stackTrace,
        properties: withEventContext(properties),
      );
    } catch (_) {
      // Error reporting runs inside error handlers: it must never throw.
    }
  }

  @override
  Future<void> flush() async {
    if (!_enabled) return;
    await _syncSession();
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
    await transport.group(
      groupType,
      groupKey,
      properties: withContext(properties),
    );
    // Only once the SDK has it, so a failed call is synced again later.
    _syncedGroups[groupType] = groupKey;
  }

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {
    if (!_enabled) return;
    await transport.identify(userId, properties: withContext(properties));
    _syncedUserId = userId;
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
    // The SDK forgets the user and groups; the next event gives it the
    // session's again.
    _session++;
    _syncedUserId = null;
    _syncedGroups.clear();
    _syncingUserId = null;
    _syncingGroups.clear();
    _syncing = null;
    return transport.reset();
  }

  @override
  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  }) async {
    if (!_enabled) return;
    final event = PendingAnalyticsEvent(
      eventName: r'$screen',
      type: PendingAnalyticsEventType.screen,
      properties: withEventContext({'screen_name': screenName, ...properties}),
    );
    await _syncSession();
    return sendOrQueue(event);
  }

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {
    if (!_enabled) return;
    final event = PendingAnalyticsEvent(
      eventName: eventName,
      type: PendingAnalyticsEventType.capture,
      properties: withEventContext(properties),
    );
    await _syncSession();
    return sendOrQueue(event);
  }

  /// Identifies and groups the SDK with the session's user, business and
  /// branch when they differ from what this run already gave it.
  ///
  /// Events wait for it, so the first event of a restored session is already
  /// person-processed and grouped. It never throws: analytics must not break
  /// the caller.
  Future<void> _syncSession() {
    final groups = currentGroups();
    // The SDK keeps a registered group until it is reset, and it outranks the
    // event's own `$groups` on native. posthog_flutter cannot drop a single
    // group, so when one the SDK holds has gone from the session (a business
    // with no branch yet), it is reset and given the current user and groups.
    final stale = _syncedGroups.keys.any((key) => !groups.containsKey(key));
    if (stale) {
      final session = ++_session;
      _syncedUserId = null;
      _syncedGroups.clear();
      _syncingUserId = null;
      _syncingGroups.clear();
      final previous = _syncing ?? Future<void>.value();
      _syncing = previous.then((_) async {
        if (session != _session) return;
        try {
          await transport.reset();
        } catch (_) {}
      });
    }
    final current = contextProvider.userId?.trim();
    final userId =
        current == null ||
            current.isEmpty ||
            current == _syncedUserId ||
            current == _syncingUserId
        ? null
        : current;
    final changed = {
      for (final entry in groups.entries)
        if (_syncedGroups[entry.key] != entry.value &&
            _syncingGroups[entry.key] != entry.value)
          entry.key: entry.value,
    };
    if (userId == null && changed.isEmpty) return _syncing ?? Future.value();

    if (userId != null) _syncingUserId = userId;
    _syncingGroups.addAll(changed);
    final businessId = groups[AnalyticsGroups.business];
    final session = _session;
    Future<void> run() async {
      // Queued before a reset: that session is over.
      if (session != _session) return;
      // Each call separately: a failed identify must not skip the groups,
      // and only what succeeded counts as synced.
      if (userId != null) {
        try {
          // No person properties: the SDK then ignores a repeat identify of
          // the user it already has, instead of sending a `$set` each start.
          await transport.identify(userId);
          if (session == _session) _syncedUserId = userId;
        } catch (_) {
        } finally {
          if (session == _session && _syncingUserId == userId) {
            _syncingUserId = null;
          }
        }
      }
      for (final entry in changed.entries) {
        try {
          await transport.group(
            entry.key,
            entry.value,
            properties: {
              if (entry.key == AnalyticsGroups.branch && businessId != null)
                AnalyticsProperties.businessId: businessId,
            },
          );
          if (session == _session) _syncedGroups[entry.key] = entry.value;
        } catch (_) {
        } finally {
          if (session == _session && _syncingGroups[entry.key] == entry.value) {
            _syncingGroups.remove(entry.key);
          }
        }
      }
    }

    return _syncing = (_syncing ?? Future<void>.value()).then((_) => run());
  }
}
