import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Singleton service for PostHog analytics, feature flags, session replay, and user/group management.
class PosthogService {
  static final PosthogService instance = PosthogService._internal();
  bool _isInitialized = false;
  final String _apiUrl = 'https://us.i.posthog.com/capture/';

  PosthogService._internal();

  /// Initialize PostHog with configuration
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (!Platform.isWindows) {
      final config = PostHogConfig(AppSecrets.postHogApiKey);
      config.host = 'https://us.i.posthog.com';
      config.debug = kDebugMode;
      config.captureApplicationLifecycleEvents = true;
      config.sessionReplay = true;
      config.sessionReplayConfig.maskAllTexts = false;
      config.sessionReplayConfig.maskAllImages = false;
      await Posthog().setup(config);
    }
    _isInitialized = true;
  }

  /// Capture an event
  Future<void> capture(String event, {Map<String, Object>? properties}) async {
    if (Platform.isWindows) {
      await _captureViaApi(event, properties);
    } else {
      await Posthog().capture(eventName: event, properties: properties);
    }
  }

  Future<void> _captureViaApi(
      String event, Map<String, Object>? properties) async {
    final payload = {
      'api_key': AppSecrets.postHogApiKey,
      'event': event,
      'properties': properties ?? {},
    };
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200) {
      debugPrint('PostHog API error: ${response.statusCode}: ${response.body}');
    }
  }

  /// Identify a user
  Future<void> identify(String userId,
      {Map<String, Object>? properties}) async {
    if (Platform.isWindows) {
      // Not supported via API
      return;
    }
    await Posthog().identify(userId: userId, userProperties: properties);
  }

  /// Group analytics (set group for the user)
  Future<void> group(String groupType, String groupKey,
      {Map<String, Object>? properties}) async {
    if (Platform.isWindows) {
      // Not supported via API
      return;
    }
    await Posthog().group(
        groupType: groupType, groupKey: groupKey, groupProperties: properties);
  }

  /// Check if a feature flag is enabled for the current user
  Future<bool> isFeatureEnabled(String flagKey) async {
    if (Platform.isWindows) {
      return false;
    }
    return await Posthog().isFeatureEnabled(flagKey);
  }

  /// Get value of a feature flag (for multivariate flags)
  Future<dynamic> getFeatureFlag(String flagKey) async {
    if (Platform.isWindows) {
      return null;
    }
    return await Posthog().getFeatureFlag(flagKey);
  }

  /// Reload feature flags (useful after login or identify)
  Future<void> reloadFeatureFlags() async {
    if (Platform.isWindows) {
      return;
    }
    await Posthog().reloadFeatureFlags();
  }

  // Session replay methods are not available in the current posthog_flutter SDK, so these are placeholders.
  Future<void> startSessionReplay() async {
    // Not implemented in posthog_flutter as of April 2025
  }

  Future<void> stopSessionReplay() async {
    // Not implemented in posthog_flutter as of April 2025
  }

  /// Track a screen view
  Future<void> screen(String screenName,
      {Map<String, Object>? properties}) async {
    if (Platform.isWindows) {
      await capture('[PostHog Screen]', properties: {
        'screen_name': screenName,
        ...?properties,
      });
      return;
    }
    await Posthog().screen(screenName: screenName, properties: properties);
  }
}
