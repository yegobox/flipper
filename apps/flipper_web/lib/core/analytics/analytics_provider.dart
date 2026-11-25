import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productAnalyticsProvider = Provider<ProductAnalytics>((ref) {
  return FlipperAnalytics.instance;
});

/// The app's analytics, or null when it never started (it is optional at
/// startup). For events about an action that must finish either way, such as
/// a saved expense. Auto-disposed, so a read made before analytics started
/// is not kept.
final optionalProductAnalyticsProvider =
    Provider.autoDispose<ProductAnalytics?>(
      (ref) => FlipperAnalytics.maybeInstance,
    );
