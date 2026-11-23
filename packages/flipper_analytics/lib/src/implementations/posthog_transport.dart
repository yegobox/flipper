import 'dart:convert';
import 'dart:io' show HttpException, Platform;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/pending_analytics_event.dart';
import '../interfaces/analytics_transport.dart';

class PostHogTransport implements AnalyticsTransport {
  PostHogTransport({
    required this.projectToken,
    required this.host,
    this.enableSessionReplay = true,
    this.maskAllTexts = true,
    this.maskAllImages = true,
    http.Client? httpClient,
    Future<SharedPreferences> Function()? preferences,
    @visibleForTesting bool? useHttp,
  }) : _httpClient = httpClient ?? http.Client(),
       _preferences = preferences ?? SharedPreferences.getInstance,
       _useHttp = useHttp;

  /// Where the Windows HTTP path keeps this install's anonymous id.
  static const deviceIdKey = 'posthog_device_id';

  final String projectToken;
  final String host;
  final bool enableSessionReplay;
  final bool maskAllTexts;
  final bool maskAllImages;
  final http.Client _httpClient;
  final Future<SharedPreferences> Function() _preferences;
  final bool? _useHttp;
  String? _deviceId;

  bool _initialized = false;

  bool get _usesHttpFallback {
    if (_useHttp != null) return _useHttp;
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  @override
  Future<void> flush() async {
    if (_usesHttpFallback) return;
    await Posthog().flush();
  }

  @override
  Future<dynamic> getFeatureFlag(String flagKey) async {
    if (_usesHttpFallback) return null;
    return Posthog().getFeatureFlag(flagKey);
  }

  @override
  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  }) async {
    if (_usesHttpFallback) return;
    await Posthog().group(
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
    if (_usesHttpFallback) return;
    await Posthog().identify(
      userId: userId,
      userProperties: _compact(properties),
    );
  }

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    if (!_usesHttpFallback) {
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
      config.sessionReplay = enableSessionReplay;
      config.sessionReplayConfig.maskAllTexts = maskAllTexts;
      config.sessionReplayConfig.maskAllImages = maskAllImages;
      await Posthog().setup(config);
    }
    _initialized = true;
  }

  @override
  Future<bool> isFeatureEnabled(String flagKey) async {
    if (_usesHttpFallback) return false;
    return Posthog().isFeatureEnabled(flagKey);
  }

  @override
  Future<void> reloadFeatureFlags() async {
    if (_usesHttpFallback) return;
    await Posthog().reloadFeatureFlags();
  }

  @override
  Future<void> reset() async {
    if (_usesHttpFallback) return;
    await Posthog().reset();
  }

  @override
  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  }) async {
    if (_usesHttpFallback) {
      await send(
        PendingAnalyticsEvent(
          eventName: r'$screen',
          type: PendingAnalyticsEventType.screen,
          properties: {'screen_name': screenName, ...properties},
        ),
      );
      return;
    }
    await Posthog().screen(
      screenName: screenName,
      properties: _compact(properties),
    );
  }

  @override
  Future<void> send(PendingAnalyticsEvent event) async {
    await initialize();
    if (_usesHttpFallback) {
      await _sendViaHttp(event);
      return;
    }
    if (event.type == PendingAnalyticsEventType.screen) {
      await Posthog().screen(
        screenName:
            event.properties['screen_name']?.toString() ?? event.eventName,
        properties: _compact(event.properties),
      );
      return;
    }
    await Posthog().capture(
      eventName: event.eventName,
      properties: _compact(event.properties),
    );
  }

  // PostHog answers 200 to an event with no `distinct_id` and then drops it,
  // so every Windows event (stall reports included) used to vanish. The SDK
  // sets one on the other platforms; here it is the signed-in user, or this
  // install's id before anyone signs in.
  Future<void> _sendViaHttp(PendingAnalyticsEvent event) async {
    final deviceId = await _loadDeviceId();
    final userId = event.properties['user_id']?.toString();
    final hasUser = userId != null && userId.isNotEmpty;
    final payload = {
      'api_key': projectToken,
      'event': event.eventName,
      'distinct_id': hasUser ? userId : deviceId,
      'properties': redact({
        ..._compact(event.properties),
        // Tells one till's events apart when several share a login.
        'device_id': deviceId,
        // No person profile for a till nobody has signed in on yet.
        if (!hasUser) r'$process_person_profile': false,
      }),
      'timestamp': event.createdAt.toIso8601String(),
    };
    final response = await _httpClient.post(
      Uri.parse('$host/capture/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'PostHog capture failed with status ${response.statusCode}',
      );
    }
  }

  Future<String> _loadDeviceId() async {
    final cached = _deviceId;
    if (cached != null) return cached;
    try {
      final prefs = await _preferences();
      var id = prefs.getString(deviceIdKey);
      if (id == null || id.isEmpty) {
        id = const Uuid().v4();
        await prefs.setString(deviceIdKey, id);
      }
      return _deviceId = id;
    } catch (_) {
      // Unreadable prefs: one id for this run is still better than none,
      // which PostHog would drop.
      return _deviceId = const Uuid().v4();
    }
  }

  PostHogEvent? _redactSensitiveFields(PostHogEvent event) {
    event.properties = redact(event.properties ?? const {});
    return event;
  }

  /// The same keys are masked on both paths: the SDK's `beforeSend` and
  /// the Windows HTTP payload.
  @visibleForTesting
  static Map<String, Object> redact(Map<String, Object> properties) {
    final current = Map<String, Object>.from(properties);
    for (final key in current.keys.toList()) {
      final lower = key.toLowerCase();
      final isSensitive =
          lower.contains('pin') ||
          lower.contains('otp') ||
          lower.contains('password') ||
          lower.contains('tin') ||
          lower.contains('card');
      if (isSensitive) {
        current[key] = '[redacted]';
      }
    }
    return current;
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
