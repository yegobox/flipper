import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/hooks/use_dashboard_feature_usage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// flutter test test/dashboard_feature_usage_test.dart

class _Recorder implements ProductAnalytics {
  final modules = <String>[];

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {
    expect(eventName, AnalyticsEvents.featureUsed);
    expect(properties['source'], 'dashboard');
    modules.add(properties['module']! as String);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Host extends HookConsumerWidget {
  const _Host(this.analytics);

  final ProductAnalytics analytics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useDashboardFeatureUsage(ref, analytics: analytics);
    return const SizedBox();
  }
}

void main() {
  group('analyticsModuleForPage', () {
    test('the inventory page is the POS till and the AI page is Flo', () {
      expect(analyticsModuleForPage(DashboardPage.inventory), 'pos');
      expect(analyticsModuleForPage(DashboardPage.ai), 'flo');
    });

    test('other pages use their name in snake_case', () {
      expect(analyticsModuleForPage(DashboardPage.orders), 'orders');
      expect(
        analyticsModuleForPage(DashboardPage.productionOutput),
        'production_output',
      );
      expect(
        analyticsModuleForPage(DashboardPage.dailyReportFiles),
        'daily_report_files',
      );
    });
  });

  testWidgets('reports the first page once, then each switch', (tester) async {
    final analytics = _Recorder();
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: _Host(analytics)),
    );
    await tester.pump();
    expect(analytics.modules, ['pos']);

    container.read(selectedPageProvider.notifier).state = DashboardPage.ai;
    await tester.pump();
    container.read(selectedPageProvider.notifier).state = DashboardPage.ai;
    await tester.pump();
    container.read(selectedPageProvider.notifier).state = DashboardPage.orders;
    await tester.pump();

    expect(analytics.modules, ['pos', 'flo', 'orders']);
  });
}
