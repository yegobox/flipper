import 'package:flipper_analytics/flipper_analytics.dart';

/// Singleton service for PostHog analytics, feature flags, session replay, and user/group management.
class PosthogService {
  static final PosthogService instance = PosthogService._internal();
  bool _isInitialized = false;

  PosthogService._internal();

  /// Initialize PostHog with configuration
  Future<void> initialize() async {
    if (_isInitialized) return;
    await FlipperAnalytics.instance.flush();
    _isInitialized = true;
  }

  /// Capture an event
  Future<void> capture(String event, {Map<String, Object>? properties}) async {
    await FlipperAnalytics.instance.track(
      event,
      properties: properties ?? const {},
    );
  }

  /// Identify a user
  Future<void> identify(String userId,
      {Map<String, Object>? properties}) async {
    await FlipperAnalytics.instance.identify(
      userId,
      properties: properties ?? const {},
    );
  }

  /// Group analytics (set group for the user)
  Future<void> group(String groupType, String groupKey,
      {Map<String, Object>? properties}) async {
    await FlipperAnalytics.instance.group(
      groupType,
      groupKey,
      properties: properties ?? const {},
    );
  }

  /// Check if a feature flag is enabled for the current user
  Future<bool> isFeatureEnabled(String flagKey) async {
    return FlipperAnalytics.instance.isFeatureEnabled(flagKey);
  }

  /// Get value of a feature flag (for multivariate flags)
  Future<dynamic> getFeatureFlag(String flagKey) async {
    return FlipperAnalytics.instance.getFeatureFlag(flagKey);
  }

  /// Reload feature flags (useful after login or identify)
  Future<void> reloadFeatureFlags() async {
    await FlipperAnalytics.instance.reloadFeatureFlags();
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
    await FlipperAnalytics.instance.screen(
      screenName,
      properties: properties ?? const {},
    );
  }
}
