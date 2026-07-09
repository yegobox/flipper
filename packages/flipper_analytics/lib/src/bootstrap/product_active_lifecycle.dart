import 'dart:async';

import 'package:flutter/widgets.dart';

import '../events/analytics_events.dart';
import '../events/analytics_properties.dart';
import '../interfaces/product_analytics.dart';

/// Emits [AnalyticsEvents.productActive] on cold start and each foreground resume.
///
/// Use this event as the "active user" definition in PostHog dashboards instead of
/// `$pageview` (web-only). See `packages/flipper_analytics/README.md`.
class ProductActiveLifecycle with WidgetsBindingObserver {
  ProductActiveLifecycle(this._analytics);

  final ProductAnalytics _analytics;
  bool _attached = false;
  AppLifecycleState? _lastState;

  void attach() {
    if (_attached) return;
    _attached = true;
    _lastState = WidgetsBinding.instance.lifecycleState;
    WidgetsBinding.instance.addObserver(this);
    unawaited(_track(source: 'cold_start'));
  }

  Future<void> detach() async {
    if (!_attached) return;
    WidgetsBinding.instance.removeObserver(this);
    _attached = false;
    _lastState = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final wasBackgrounded =
        _lastState == AppLifecycleState.paused ||
        _lastState == AppLifecycleState.inactive ||
        _lastState == AppLifecycleState.hidden ||
        _lastState == AppLifecycleState.detached;
    _lastState = state;

    if (state == AppLifecycleState.resumed && wasBackgrounded) {
      unawaited(_track(source: 'resume'));
    }
  }

  Future<void> _track({required String source}) {
    return _analytics.track(
      AnalyticsEvents.productActive,
      properties: {AnalyticsProperties.source: source},
    );
  }
}
