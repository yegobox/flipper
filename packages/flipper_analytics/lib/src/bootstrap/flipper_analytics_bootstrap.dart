import 'package:flutter/foundation.dart';

import '../implementations/analytics_flush_service.dart';
import '../implementations/callback_analytics_context_provider.dart';
import '../implementations/ga4_active_user_pinger.dart';
import '../implementations/offline_first_analytics.dart';
import '../implementations/posthog_transport.dart';
import '../interfaces/analytics_event_store.dart';
import '../interfaces/product_analytics.dart';
import '../report_exception.dart';
import 'product_active_lifecycle.dart';

class FlipperAnalytics {
  FlipperAnalytics._();

  static ProductAnalytics? _instance;
  static AnalyticsFlushService? _flushService;
  static ProductActiveLifecycle? _productActiveLifecycle;
  static Ga4ActiveUserPinger? _ga4ActiveUserPinger;
  static VoidCallback? _stopFollowingEnabled;

  static ProductAnalytics get instance {
    final analytics = _instance;
    if (analytics == null) {
      throw StateError(
        'FlipperAnalytics has not been initialized. Call FlipperAnalytics.initialize() first.',
      );
    }
    return analytics;
  }

  /// Null when initialization never finished (it is optional at startup), so
  /// callers such as logout can't be broken by analytics.
  static ProductAnalytics? get maybeInstance => _instance;

  static Future<ProductAnalytics> initialize({
    required String appName,
    required String platformName,
    required String projectToken,
    required AnalyticsEventStore store,
    required CallbackAnalyticsContextProvider contextProvider,
    String host = 'https://us.i.posthog.com',
    // isEnabled: false keeps everything on the device (local mode); with
    // enabledChanges it is re-read whenever that notifier fires.
    String? ga4MeasurementId,
    String? ga4ApiSecret,
    bool Function()? ga4IsEnabled,
    bool Function()? isEnabled,
    ValueListenable<bool>? enabledChanges,
    // On every event, including the SDK's own (see PostHogTransport).
    Map<String, Object> superProperties = const {},
  }) async {
    final enabled = isEnabled?.call() ?? true;
    final transport = PostHogTransport(
      projectToken: projectToken,
      host: host,
      enableSessionReplay: !kIsWeb,
      maskAllTexts: true,
      maskAllImages: true,
      startOptedOut: !enabled,
      superProperties: superProperties,
    );
    final analytics = OfflineFirstAnalytics(
      contextProvider: contextProvider,
      eventStore: store,
      enabled: enabled,
      transport: transport,
    );
    await analytics.initialize();
    // On web, what queued while posthog-js loaded goes out as soon as it is
    // up, not at the next 5-minute flush.
    if (kIsWeb) {
      transport.ready.then((ok) {
        if (ok) analytics.flush().ignore();
      }).ignore();
    }

    // A till can enter local mode (signup) or leave it (opting in to sync)
    // while running; follow it rather than waiting for a restart.
    if (isEnabled != null && enabledChanges != null) {
      void follow() => analytics.setEnabled(isEnabled()).ignore();
      enabledChanges.addListener(follow);
      _stopFollowingEnabled = () => enabledChanges.removeListener(follow);
    }

    final flushService = AnalyticsFlushService(analytics);
    flushService.initialize();

    _productActiveLifecycle = ProductActiveLifecycle(analytics);
    _productActiveLifecycle!.attach();

    // Only for platforms without a Firebase Analytics SDK (Windows): the others
    // already report active users natively and would be counted twice.
    if ((ga4MeasurementId?.isNotEmpty ?? false) &&
        (ga4ApiSecret?.isNotEmpty ?? false)) {
      _ga4ActiveUserPinger = Ga4ActiveUserPinger(
        measurementId: ga4MeasurementId!,
        apiSecret: ga4ApiSecret!,
        contextProvider: contextProvider,
        isEnabled: ga4IsEnabled,
      )..attach();
    }

    _instance = analytics;
    // Startup steps that failed before analytics existed.
    flushEarlyExceptions(analytics);
    _flushService = flushService;
    return analytics;
  }

  static Future<void> dispose() async {
    _stopFollowingEnabled?.call();
    _stopFollowingEnabled = null;
    await _productActiveLifecycle?.detach();
    _productActiveLifecycle = null;
    await _ga4ActiveUserPinger?.detach();
    _ga4ActiveUserPinger = null;
    await _flushService?.dispose();
    _flushService = null;
    _instance = null;
  }
}
