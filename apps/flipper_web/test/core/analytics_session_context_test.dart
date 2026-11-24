import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/core/analytics/analytics_provider.dart';
import 'package:flipper_web/core/analytics/analytics_session_context.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/features/business_selection/session_business_selection.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/services/accounting_bootstrap_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_product_analytics.dart';

class _ReadyBootstrap extends AccountingBootstrapService {
  @override
  Future<BootstrapAccountingResult> ensureBusinessReady(String businessId) {
    return Future.value(
      const BootstrapAccountingResult(seeded: false, alreadyReady: true),
    );
  }
}

const _sessionKeys = [
  AnalyticsProperties.userId,
  AnalyticsProperties.businessId,
  AnalyticsProperties.branchId,
  AnalyticsGroups.property,
];

RecordingProductAnalytics _analyticsFor(AnalyticsSessionContext context) {
  return RecordingProductAnalytics(
    context.contextProvider(
      appName: 'flipper_web',
      platformName: 'web',
      buildMode: 'debug',
    ),
  );
}

UserProfile _profile() {
  return UserProfile(
    id: '42',
    phoneNumber: '+250788000000',
    token: 't',
    tenants: [
      Tenant(
        id: 't1',
        name: 'Owner',
        phoneNumber: '+250788000000',
        email: '',
        imageUrl: '',
        permissions: const [],
        branches: [
          Branch(
            id: 'br-1',
            description: '',
            name: 'Main',
            longitude: '',
            latitude: '',
            businessId: 'biz-1',
            serverId: 1,
          ),
        ],
        businesses: [
          Business(
            id: 'biz-1',
            name: 'Kigali Shop',
            country: 'RW',
            currency: 'RWF',
            latitude: '',
            longitude: '',
            active: true,
            userId: '42',
            phoneNumber: '',
            lastSeen: 0,
            backUpEnabled: false,
            fullName: '',
            tinNumber: 0,
            taxEnabled: false,
            businessTypeId: 1,
            serverId: 1,
            isDefault: true,
            lastSubscriptionPaymentSucceeded: true,
          ),
        ],
        nfcEnabled: false,
        userId: 42,
        pin: 1234,
        isDefault: true,
        type: 'owner',
      ),
    ],
  );
}

void main() {
  test('the app context is the one main() hands to analytics', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(analyticsSessionContextProvider),
      same(analyticsSessionContext),
    );
  });

  test('events carry the user, business and branch only once known', () async {
    final context = AnalyticsSessionContext();
    final container = ProviderContainer(
      overrides: [analyticsSessionContextProvider.overrideWithValue(context)],
    );
    addTearDown(container.dispose);
    container.read(analyticsSessionSyncProvider);
    final analytics = _analyticsFor(context);

    await analytics.track('before');
    expect(
      analytics.lastEvent('before').keys,
      isNot(contains(anyOf(_sessionKeys))),
    );

    container.read(sessionApiUserIdProvider.notifier).state = '42';
    container
        .read(selectedBusinessProvider.notifier)
        .set(placeholderBusiness('biz-1'));
    container
        .read(selectedBranchProvider.notifier)
        .set(placeholderBranch(id: 'br-1', businessId: 'biz-1'));
    await analytics.track('after');

    final after = analytics.lastEvent('after');
    expect(after[AnalyticsProperties.userId], '42');
    expect(after[AnalyticsProperties.businessId], 'biz-1');
    expect(after[AnalyticsProperties.branchId], 'br-1');
    expect(after[AnalyticsGroups.property], {
      AnalyticsGroups.business: 'biz-1',
      AnalyticsGroups.branch: 'br-1',
    });

    // Sign-out clears the selection; events stop naming the old shop.
    clearSessionBusinessSelection(container);
    container.read(sessionApiUserIdProvider.notifier).state = null;
    await analytics.track('signed out');
    expect(
      analytics.lastEvent('signed out').keys,
      isNot(contains(anyOf(_sessionKeys))),
    );
  });

  testWidgets('picking a branch identifies and groups by business and branch', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'flipper_web_api_user_id': '42'});

    final context = AnalyticsSessionContext();
    final analytics = _analyticsFor(context);
    final profile = _profile();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'login',
          builder: (_, __) => BusinessBranchSelector(userProfile: profile),
        ),
        GoRoute(
          path: '/accounting',
          name: 'accounting',
          builder: (_, __) => const Text('books'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsSessionContextProvider.overrideWithValue(context),
          productAnalyticsProvider.overrideWithValue(analytics),
          accountingBootstrapServiceProvider.overrideWithValue(
            _ReadyBootstrap(),
          ),
          sessionApiUserIdProvider.overrideWith((ref) => '42'),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            ref.watch(analyticsSessionSyncProvider);
            return MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: FlipperLocalizationDelegates.delegates,
              supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await analytics.track('before');
    expect(analytics.lastEvent('before')[AnalyticsGroups.property], isNull);

    // One branch: picking the business picks it too.
    await tester.tap(find.text('Kigali Shop'));
    await tester.pumpAndSettle();

    expect(find.text('books'), findsOneWidget);
    expect(analytics.calls, [
      'identify:42',
      'group:business:biz-1',
      'group:branch:br-1',
    ]);
    // Ids only: a business name can be the owner's own name.
    expect(analytics.callProperties[1], {'source': 'business_branch_selector'});
    expect(analytics.callProperties[2], {
      'source': 'business_branch_selector',
      AnalyticsProperties.businessId: 'biz-1',
    });

    // The business is known before its branch is.
    final businessSelected = analytics.lastEvent(
      AnalyticsEvents.businessSelected,
    );
    expect(businessSelected[AnalyticsGroups.property], {
      AnalyticsGroups.business: 'biz-1',
    });
    expect(businessSelected.containsKey('business_name'), isFalse);
    expect(
      analytics
          .lastEvent(AnalyticsEvents.branchSelected)
          .containsKey('branch_name'),
      isFalse,
    );

    final started = analytics.lastEvent(AnalyticsEvents.booksSessionStarted);
    expect(started[AnalyticsProperties.userId], '42');
    expect(started[AnalyticsGroups.property], {
      AnalyticsGroups.business: 'biz-1',
      AnalyticsGroups.branch: 'br-1',
    });
  });
}
