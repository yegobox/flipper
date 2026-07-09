import 'dart:convert';
import 'dart:io' show HttpException, Platform;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:posthog_flutter/posthog_flutter.dart';

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
  }) : _httpClient = httpClient ?? http.Client();

  final String projectToken;
  final String host;
  final bool enableSessionReplay;
  final bool maskAllTexts;
  final bool maskAllImages;
  final http.Client _httpClient;

  bool _initialized = false;

  bool get _usesHttpFallback {
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
          properties: {
            'screen_name': screenName,
            ...properties,
          },
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
        screenName: event.properties['screen_name']?.toString() ?? event.eventName,
        properties: _compact(event.properties),
      );
      return;
    }
    await Posthog().capture(
      eventName: event.eventName,
      properties: _compact(event.properties),
    );
  }

  Future<void> _sendViaHttp(PendingAnalyticsEvent event) async {
    final payload = {
      'api_key': projectToken,
      'event': event.eventName,
      'properties': _compact(event.properties),
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

  PostHogEvent? _redactSensitiveFields(PostHogEvent event) {
    final current = Map<String, Object>.from(event.properties ?? const {});
    for (final key in current.keys.toList()) {
      final lower = key.toLowerCase();
      final isSensitive = lower.contains('pin') ||
          lower.contains('otp') ||
          lower.contains('password') ||
          lower.contains('tin') ||
          lower.contains('card');
      if (isSensitive) {
        current[key] = '[redacted]';
      }
    }
    event.properties = current;
    return event;
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
