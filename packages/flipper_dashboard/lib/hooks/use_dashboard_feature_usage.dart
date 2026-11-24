import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Reports which dashboard modules a till uses: `feature_used` for the page
/// shown first, then for each page switched to. The pages are tabs of one
/// route, so PostHog's screen views never see them.
void useDashboardFeatureUsage(WidgetRef ref, {ProductAnalytics? analytics}) {
  useEffect(() {
    trackFeatureUsed(
      analyticsModuleForPage(ref.read(selectedPageProvider)),
      properties: const {'source': 'dashboard'},
      analytics: analytics,
    );
    return null;
  }, const []);
  ref.listen<DashboardPage>(selectedPageProvider, (previous, next) {
    if (previous == next) return;
    trackFeatureUsed(
      analyticsModuleForPage(next),
      properties: const {'source': 'dashboard'},
      analytics: analytics,
    );
  });
}
