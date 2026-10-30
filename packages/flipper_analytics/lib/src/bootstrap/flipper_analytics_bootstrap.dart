import 'package:flutter/foundation.dart';

import '../implementations/analytics_flush_service.dart';
import '../implementations/callback_analytics_context_provider.dart';
import '../implementations/ga4_active_user_pinger.dart';
import '../implementations/offline_first_analytics.dart';
import '../implementations/posthog_transport.dart';
import '../interfaces/analytics_event_store.dart';
import '../interfaces/product_analytics.dart';
import 'product_active_lifecycle.dart';

class FlipperAnalytics {
  FlipperAnalytics._();

  static ProductAnalytics? _instance;
  static AnalyticsFlushService? _flushService;
  static ProductActiveLifecycle? _productActiveLifecycle;
  static Ga4ActiveUserPinger? _ga4ActiveUserPinger;

  static ProductAnalytics get instance {
    final analytics = _instance;
    if (analytics == null) {
      throw StateError(
        'FlipperAnalytics has not been initialized. Call FlipperAnalytics.initialize() first.',
      );
    }
    return analytics;
  }

  static Future<ProductAnalytics> initialize({
    required String appName,
    required String platformName,
    required String projectToken,
    required AnalyticsEventStore store,
    required CallbackAnalyticsContextProvider contextProvider,
    String host = 'https://us.i.posthog.com',
    String? ga4MeasurementId,
    String? ga4ApiSecret,
    bool Function()? ga4IsEnabled,
  }) async {
    final analytics = OfflineFirstAnalytics(
      contextProvider: contextProvider,
      eventStore: store,
      transport: PostHogTransport(
        projectToken: projectToken,
        host: host,
        enableSessionReplay: !kIsWeb,
        maskAllTexts: true,
        maskAllImages: true,
      ),
    );
    await analytics.initialize();

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
    _flushService = flushService;
    return analytics;
  }

  static Future<void> dispose() async {
    await _productActiveLifecycle?.detach();
    _productActiveLifecycle = null;
    await _ga4ActiveUserPinger?.detach();
    _ga4ActiveUserPinger = null;
    await _flushService?.dispose();
    _flushService = null;
    _instance = null;
  }
}
