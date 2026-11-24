import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_hr/main.dart';
import 'package:flipper_hr/router/hr_router.dart';
import 'package:flipper_web/core/analytics/analytics_session_context.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Tags properties the way HR's analytics tags every event.
class _Tagger with AnalyticsContextMixin {
  _Tagger(this.contextProvider);

  @override
  final AnalyticsContextProvider contextProvider;
}

void main() {
  testWidgets('HR events carry the business and branch once picked', (
    tester,
  ) async {
    final context = AnalyticsSessionContext();
    final tagger = _Tagger(
      context.contextProvider(
        appName: 'flipper_hr',
        platformName: 'web',
        buildMode: 'debug',
      ),
    );
    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, __) => const Text('hr'))],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsSessionContextProvider.overrideWithValue(context),
          hrRouterProvider.overrideWithValue(router),
        ],
        child: const FlipperHrApp(),
      ),
    );
    await tester.pumpAndSettle();

    final before = tagger.withEventContext(const {});
    expect(before[AnalyticsProperties.userId], isNull);
    expect(before[AnalyticsProperties.businessId], isNull);
    expect(before[AnalyticsProperties.branchId], isNull);
    expect(before[AnalyticsGroups.property], isNull);

    final container = ProviderScope.containerOf(
      tester.element(find.text('hr')),
    );
    container.read(sessionApiUserIdProvider.notifier).state = '42';
    container
        .read(selectedBusinessProvider.notifier)
        .set(placeholderBusiness('biz-1'));
    container
        .read(selectedBranchProvider.notifier)
        .set(placeholderBranch(id: 'br-1', businessId: 'biz-1'));

    final after = tagger.withEventContext(const {});
    expect(after[AnalyticsProperties.app], 'flipper_hr');
    expect(after[AnalyticsProperties.userId], '42');
    expect(after[AnalyticsProperties.businessId], 'biz-1');
    expect(after[AnalyticsProperties.branchId], 'br-1');
    expect(after[AnalyticsGroups.property], {
      AnalyticsGroups.business: 'biz-1',
      AnalyticsGroups.branch: 'br-1',
    });
  });
}
