import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/pending_analytics_event.dart';
import '../interfaces/analytics_transport.dart';
import '../web/posthog_js_loader.dart';

/// Sends through the PostHog SDK on every platform.
///
/// Since posthog_flutter 5.55 the SDK has its own Windows and Linux client
/// (file-backed queue, retries, `distinct_id`), which replaced the raw HTTP
/// path Windows used before: that path once lost every event because it sent
/// no `distinct_id`. On web the SDK drives the posthog-js instance that each
/// app's `web/index.html` initializes; `setup()` does nothing there.
class PostHogTransport implements AnalyticsTransport {
  PostHogTransport({
    required this.projectToken,
    required this.host,
    this.enableSessionReplay = true,
    this.maskAllTexts = true,
    this.maskAllImages = true,
    this.startOptedOut = false,
    Future<SharedPreferences> Function()? preferences,
    @visibleForTesting Posthog? posthog,
    @visibleForTesting bool? isWeb,
  }) : _preferences = preferences ?? SharedPreferences.getInstance,
       _posthogOverride = posthog,
       _isWeb = isWeb ?? kIsWeb;

  /// Where this install's anonymous id is kept. Its value is sent as
  /// `device_id` on every event, to tell tills that share a login apart.
  static const deviceIdKey = 'posthog_device_id';

  final String projectToken;
  final String host;
  final bool enableSessionReplay;
  final bool maskAllTexts;
  final bool maskAllImages;

  /// A till that must not reach the cloud (local mode) starts opted out, so
  /// nothing at all leaves it, session replay included.
  final bool startOptedOut;
  final Future<SharedPreferences> Function() _preferences;
  final Posthog? _posthogOverride;
  final bool _isWeb;

  Posthog get _posthog => _posthogOverride ?? Posthog();

  bool _initialized = false;

  @visibleForTesting
  PostHogConfig buildConfig() {
    final config = PostHogConfig(
      projectToken,
      beforeSend: [_redactSensitiveFields],
    );
    config.host = host;
    config.debug = kDebugMode;
    config.captureApplicationLifecycleEvents = true;
    config.flushAt = 20;
    config.flushInterval = const Duration(seconds: 30);
    config.maxQueueSize = 1000;
    config.optOut = startOptedOut;
    config.sessionReplay = enableSessionReplay && !startOptedOut;
    config.sessionReplayConfig.maskAllTexts = maskAllTexts;
    config.sessionReplayConfig.maskAllImages = maskAllImages;
    // Flipper registers its own FCM tokens; on iOS the SDK would also swizzle
    // the app delegate for this.
    config.capturePushNotificationSubscriptions = false;
    config.capturePushNotificationOpened = false;
    return config;
  }

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    if (_isWeb) {
      // In the background: a slow CDN must not hold up Books' startup.
      // Events sent meanwhile throw and wait in the offline queue.
      unawaited(_loadWeb());
      return;
    }
    await _posthog.setup(buildConfig());
    await _posthog.register('device_id', await _loadDeviceId());
  }

  /// Completes once posthog-js is loaded on web (true at once on native).
  Future<bool> get ready => _isWeb ? _loadWeb() : Future.value(true);

  Future<bool> _loadWeb() =>
      loadPostHogJs(projectToken: projectToken, host: host);

  /// identify/group/reset need the live client: on web they wait (bounded)
  /// for posthog-js rather than being dropped while it loads.
  Future<void> _whenReady() async {
    await initialize();
    if (_isWeb && !isPostHogJsReady) await _loadWeb();
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    await _whenReady();
    // Only on a real change: posthog-js records an `$opt_in` event each time.
    if (await _posthog.isOptOut() == !enabled) return;
    if (enabled) {
      await _posthog.optIn();
    } else {
      await _posthog.optOut();
    }
  }

  @override
  Future<void> flush() => _posthog.flush();

  @override
  Future<dynamic> getFeatureFlag(String flagKey) =>
      _posthog.getFeatureFlag(flagKey);

  @override
  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  }) async {
    await _whenReady();
    return _posthog.group(
      groupType: groupType,
      groupKey: groupKey,
      groupProperties: _compact(properties),
    );
  }

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {
    await _whenReady();
    return _posthog.identify(
      userId: userId,
      userProperties: _compact(properties),
    );
  }

  @override
  Future<bool> isFeatureEnabled(String flagKey) =>
      _posthog.isFeatureEnabled(flagKey);

  @override
  Future<void> reloadFeatureFlags() => _posthog.reloadFeatureFlags();

  @override
  Future<void> reset() async {
    await _whenReady();
    await _posthog.reset();
    // reset() drops registered properties too.
    if (!_isWeb) {
      await _posthog.register('device_id', await _loadDeviceId());
    }
  }

  @override
  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  }) {
    return _posthog.screen(
      screenName: screenName,
      properties: _compact(properties),
    );
  }

  @override
  Future<void> send(PendingAnalyticsEvent event) async {
    await initialize();
    if (_isWeb && !isPostHogJsReady) {
      // Thrown so the offline queue keeps it for the next flush.
      throw StateError('posthog-js is not loaded yet');
    }
    if (event.type == PendingAnalyticsEventType.screen) {
      await _posthog.screen(
        screenName:
            event.properties['screen_name']?.toString() ?? event.eventName,
        properties: _compact(event.properties),
      );
      return;
    }
    await _posthog.capture(
      eventName: event.eventName,
      properties: _compact(event.properties),
    );
  }

  Future<String> _loadDeviceId() async {
    try {
      final prefs = await _preferences();
      var id = prefs.getString(deviceIdKey);
      if (id == null || id.isEmpty) {
        id = const Uuid().v4();
        await prefs.setString(deviceIdKey, id);
      }
      return id;
    } catch (_) {
      // Unreadable prefs: one id for this run still tells tills apart.
      return const Uuid().v4();
    }
  }

  PostHogEvent? _redactSensitiveFields(PostHogEvent event) {
    event.properties = redact(event.properties ?? const {});
    return event;
  }

  /// Words that mark a property as a secret wherever they appear in its key:
  /// `pin`, `user_pin`, `pinCode`, `otp_code`, `card_number`, `tin`.
  static const _sensitiveWords = {
    'pin',
    'pincode',
    'otp',
    'password',
    'passcode',
    'secret',
    'tin',
    'card',
    'cardnumber',
    'cvv',
  };

  /// Masks secrets before an event leaves the device.
  ///
  /// Keys are matched by whole word (split on `_`, `-`, `.`, spaces and
  /// camelCase), not by substring, so `printer`, `setting` or `discard` are
  /// left alone. A key that ends in `id` names a record, not a secret
  /// (`pin_user_id`), and is kept.
  @visibleForTesting
  static Map<String, Object> redact(Map<String, Object> properties) {
    final current = Map<String, Object>.from(properties);
    for (final key in current.keys.toList()) {
      if (isSensitiveKey(key)) current[key] = '[redacted]';
    }
    return current;
  }

  @visibleForTesting
  static bool isSensitiveKey(String key) {
    final words = key
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (m) => '${m[1]}_${m[2]}',
        )
        .toLowerCase()
        .split(RegExp(r'[^a-z0-9]+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty || words.last == 'id' || words.last == 'ids') {
      return false;
    }
    return words.any(_sensitiveWords.contains);
  }

  Map<String, Object> _compact(Map<String, Object?> source) {
    final result = <String, Object>{};
    source.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return result;
  }
}
