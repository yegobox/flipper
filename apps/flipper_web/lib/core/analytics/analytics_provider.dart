import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productAnalyticsProvider = Provider<ProductAnalytics>((ref) {
  return FlipperAnalytics.instance;
});
