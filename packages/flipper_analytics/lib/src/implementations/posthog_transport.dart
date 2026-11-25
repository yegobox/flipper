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
    this.superProperties = const {},
    Future<SharedPreferences> Function()? preferences,
    @visibleForTesting Posthog? posthog,
    @visibleForTesting bool? isWeb,
    @visibleForTesting Future<bool> Function()? loadWeb,
    @visibleForTesting bool Function()? webReady,
  }) : _preferences = preferences ?? SharedPreferences.getInstance,
       _posthogOverride = posthog,
       _isWeb = isWeb ?? kIsWeb,
       _loadWebOverride = loadWeb,
       _webReadyOverride = webReady;

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

  /// Registered with the SDK next to `device_id`, so every event carries
  /// them, the SDK's own lifecycle events included.
  final Map<String, Object> superProperties;
  final Future<SharedPreferences> Function() _preferences;
  final Posthog? _posthogOverride;
  final bool _isWeb;
  final Future<bool> Function()? _loadWebOverride;
  final bool Function()? _webReadyOverride;

  bool get _webReady => _webReadyOverride?.call() ?? isPostHogJsReady;

  Posthog get _posthog => _posthogOverride ?? Posthog();

  bool _initialized = false;

  /// Web calls run one after another, in the order they were made.
  Future<void> _webChain = Future<void>.value();
  final List<Future<void> Function()> _webQueue = [];

  /// How many web calls wait for posthog-js at most.
  @visibleForTesting
  static const maxQueuedWebCalls = 50;
  Future<void>? _deviceRegistration;

  /// One lookup shared by every caller, so concurrent calls never mint two
  /// install ids (and unreadable prefs still give one id per run).
  Future<String>? _deviceId;

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
    // Dart errors arrive through the app's own handler (deduplicated, see
    // reportException); the SDK's Dart autocapture would bypass that and
    // send a per-frame assertion once per frame. NDK crashes on Android
    // reach no Dart handler, so the SDK records those.
    config.errorTrackingConfig.captureNativeCrashes = true;
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
      unawaited(_onLive(() async {}));
      return;
    }
    await _posthog.setup(buildConfig());
    await _ensureDeviceRegistered();
  }

  Future<void> _ensureDeviceRegistered() =>
      _deviceRegistration ??= _registerDevice();

  Future<void> _registerDevice() async {
    await _posthog.register('device_id', await _loadDeviceId());
    for (final entry in superProperties.entries) {
      await _posthog.register(entry.key, entry.value);
    }
  }

  /// Completes once posthog-js is loaded on web (true at once on native).
  Future<bool> get ready => _isWeb ? _loadWeb() : Future.value(true);

  /// PostHog project tokens start with `phc_`. CI and local builds carry a
  /// placeholder, and posthog-js would fetch that token's remote config and
  /// log a 404, so nothing is loaded without a real token.
  bool get hasProjectToken => projectToken.startsWith('phc_');

  Future<bool> _loadWeb() {
    if (!hasProjectToken) return Future.value(false);
    return _loadWebOverride?.call() ??
        loadPostHogJs(projectToken: projectToken, host: host);
  }

  /// Runs [call] against the live client. On native that is now. On web,
  /// before posthog-js has loaded, [call] is queued behind the load and this
  /// returns at once: Books' startup and login never wait on the CDN. Queued
  /// calls run in the order they were made; a failed load drops them (the
  /// next call retries the load).
  Future<void> _onLive(Future<void> Function() call) async {
    if (!_initialized) await initialize();
    if (!_isWeb) return call();
    _webQueue.add(call);
    // Bounded: with no token (or the CDN blocked for good) nothing loads,
    // and the oldest calls give way.
    if (_webQueue.length > maxQueuedWebCalls) _webQueue.removeAt(0);
    final step = _webChain.then((_) async {
      // A failed load keeps the queue; the next call tries the load again
      // and runs everything queued so far, in order.
      if (!_webReady && !await _loadWeb()) return;
      await _ensureDeviceRegistered();
      while (_webQueue.isNotEmpty) {
        final next = _webQueue.removeAt(0);
        try {
          await next();
        } catch (_) {}
      }
    });
    _webChain = step.catchError((Object _) {});
    // Already loaded: the caller may wait for its own call. Not loaded yet:
    // return at once, never holding up startup or login on the CDN.
    if (_webReady) await _webChain;
  }

  @override
  Future<void> setEnabled(bool enabled) => _onLive(() async {
    // Only on a real change: posthog-js records an `$opt_in` event each time.
    if (await _posthog.isOptOut() == !enabled) return;
    if (enabled) {
      await _posthog.optIn();
    } else {
      await _posthog.optOut();
    }
  });

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  }) => _onLive(
    () => _posthog.captureException(
      // posthog-js sends the message as is; native runs it through
      // beforeSend, which scrubs it there.
      error: _isWeb ? ScrubbedError(error) : error,
      stackTrace: stackTrace,
      properties: _compact({
        // The native SDKs send `$os_name`, which PostHog turns into `$os`
        // for other events but not for `$exception`; posthog-js sets it.
        if (!_isWeb) r'$os': osNameFor(defaultTargetPlatform),
        ...properties,
      }),
    ),
  );

  /// The `$os` the native SDKs report as `$os_name` on [platform].
  @visibleForTesting
  static String? osNameFor(TargetPlatform platform) => switch (platform) {
    TargetPlatform.android => 'Android',
    TargetPlatform.iOS => 'iOS',
    TargetPlatform.macOS => 'macOS',
    TargetPlatform.windows => 'Windows',
    TargetPlatform.linux => 'Linux',
    TargetPlatform.fuchsia => null,
  };

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
  }) => _onLive(
    () => _posthog.group(
      groupType: groupType,
      groupKey: groupKey,
      groupProperties: _compact(properties),
    ),
  );

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) => _onLive(
    () =>
        _posthog.identify(userId: userId, userProperties: _compact(properties)),
  );

  @override
  Future<bool> isFeatureEnabled(String flagKey) =>
      _posthog.isFeatureEnabled(flagKey);

  @override
  Future<void> reloadFeatureFlags() => _posthog.reloadFeatureFlags();

  @override
  Future<void> reset() => _onLive(() async {
    await _posthog.reset();
    // reset() drops registered properties too.
    await _registerDevice();
  });

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
    if (_isWeb && !_webReady) {
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

  Future<String> _loadDeviceId() => _deviceId ??= _readDeviceId();

  Future<String> _readDeviceId() async {
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
    event.properties = scrubExceptions(redact(event.properties ?? const {}));
    return event;
  }

  static final _email = RegExp(r'[\w.+-]+@[\w-]+(\.[\w-]+)+');
  // Phone numbers, card and account numbers: 7+ digits, maybe spaced.
  static final _longNumber = RegExp(r'\+?\d[\d \-]{5,}\d');

  /// Removes emails and long numbers from free text. Exception messages can
  /// carry response bodies (`Key (email)=(…)`, a customer's phone), and
  /// those must not reach PostHog; the full text stays in the local Log row.
  @visibleForTesting
  static String scrubText(String text) =>
      text.replaceAll(_email, '[email]').replaceAll(_longNumber, '[number]');

  /// Scrubs the message of each exception in an `$exception` event.
  @visibleForTesting
  static Map<String, Object> scrubExceptions(Map<String, Object> properties) {
    final list = properties[r'$exception_list'];
    if (list is! List) return properties;
    return {
      ...properties,
      r'$exception_list': [
        for (final item in list)
          if (item is Map && item['value'] is String)
            {...item, 'value': scrubText(item['value'] as String)}
          else
            item,
      ],
    };
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
  /// (`pin_user_id`), and is kept. Nested maps and lists are walked at every
  /// depth, and null entries inside them are dropped.
  @visibleForTesting
  static Map<String, Object> redact(Map<String, Object> properties) => {
    for (final entry in properties.entries)
      entry.key: isSensitiveKey(entry.key)
          ? '[redacted]'
          : _redactValue(entry.value),
  };

  static Object _redactValue(Object value) => switch (value) {
    Map() => {
      for (final entry in value.entries)
        if (entry.value != null)
          '${entry.key}': isSensitiveKey('${entry.key}')
              ? '[redacted]'
              : _redactValue(entry.value as Object),
    },
    List() => [
      for (final item in value)
        if (item != null) _redactValue(item as Object),
    ],
    _ => value,
  };

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

/// An error whose message has had emails and long numbers removed; used where
/// the SDK sends the message without running beforeSend (web).
@visibleForTesting
class ScrubbedError implements Exception {
  ScrubbedError(this.source);

  final Object source;

  @override
  String toString() => PostHogTransport.scrubText(source.toString());
}
