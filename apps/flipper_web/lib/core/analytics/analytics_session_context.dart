import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The signed-in Flipper user and the business and branch picked on Login
/// Choices, as every analytics event reports them.
///
/// The context provider reads these synchronously on every event, and `main()`
/// builds it before any provider container exists, so they can't be read from
/// Riverpod there. They live here as plain fields instead, and
/// [analyticsSessionSyncProvider] copies the session's state in whenever it
/// changes. A read is a field read: it can't throw and costs nothing.
class AnalyticsSessionContext {
  /// The Flipper user id POS signs in with (`public.users.id`), never the
  /// login phone or email.
  String? userId;
  String? businessId;
  String? branchId;

  /// The context provider Books and HR hand to `FlipperAnalytics.initialize`.
  CallbackAnalyticsContextProvider contextProvider({
    required String appName,
    required String platformName,
    required String buildMode,
  }) {
    return CallbackAnalyticsContextProvider(
      appName: appName,
      platformName: platformName,
      buildMode: buildMode,
      userIdGetter: () => userId,
      businessIdGetter: () => businessId,
      branchIdGetter: () => branchId,
    );
  }
}

/// The app's one [AnalyticsSessionContext], shared by `main()` and
/// [analyticsSessionSyncProvider].
final analyticsSessionContext = AnalyticsSessionContext();

/// Overridden in tests with a fresh context.
final analyticsSessionContextProvider = Provider<AnalyticsSessionContext>(
  (ref) => analyticsSessionContext,
);

/// Keeps [AnalyticsSessionContext] in step with the session: the API user id,
/// and the selected business and branch, which sign-in, Login Choices, reload
/// restore and sign-out all go through.
///
/// The app root watches it, so it lives as long as the app.
final analyticsSessionSyncProvider = Provider<void>((ref) {
  final context = ref.watch(analyticsSessionContextProvider);
  ref.listen<String?>(
    sessionApiUserIdProvider,
    (_, id) => context.userId = id,
    fireImmediately: true,
  );
  ref.listen<String?>(
    selectedBusinessProvider.select((business) => business?.id),
    (_, id) => context.businessId = id,
    fireImmediately: true,
  );
  ref.listen<String?>(
    selectedBranchProvider.select((branch) => branch?.id),
    (_, id) => context.branchId = id,
    fireImmediately: true,
  );
});
