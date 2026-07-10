import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../interfaces/product_analytics.dart';

class AnalyticsFlushService {
  AnalyticsFlushService(this._analytics);

  final ProductAnalytics _analytics;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _timer;

  void initialize() {
    _connectivitySubscription ??=
        Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);
    _timer ??= Timer.periodic(const Duration(minutes: 5), (_) {
      unawaited(_analytics.flush());
    });
    unawaited(_analytics.flush());
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    _timer?.cancel();
    _connectivitySubscription = null;
    _timer = null;
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);
    if (hasConnection) {
      unawaited(_analytics.flush());
    }
  }
}
