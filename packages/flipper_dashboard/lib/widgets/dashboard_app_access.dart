import 'package:flipper_dashboard/hr_module_entry.dart';
import 'package:flipper_dashboard/providers/agent_commission_access_provider.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The signed-in user's id, read fresh each time (a logout and login as
/// someone else must not leave the previous id behind).
String currentDashboardUserId() => ProxyService.box.getUserId() ?? '';

/// Whether the signed-in user runs the business: the owner or an admin.
/// autoDispose, so the user id is read again whenever it is next watched.
final dashboardIsAdminProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(
    featureAccessLevelProvider(
      userId: currentDashboardUserId(),
      accessLevel: AccessLevel.ADMIN,
    ),
  ),
);

/// Whether [accesses] let someone run HR in [businessId]: an Admin of that
/// business, or a live Admin-level 'HR' grant there — what HR's own RLS honours
/// (`hr_manager_business_ids()`, migration 0006). A Write-level HR grant, or
/// a grant from another business, does not count: HR would open and show
/// nothing.
bool canRunHr(
  List<Access> accesses, {
  required String? businessId,
  required DateTime now,
}) {
  if (businessId == null || businessId.isEmpty) return false;
  return accesses.any(
    (a) =>
        a.businessId == businessId &&
        a.status == 'active' &&
        (a.expiresAt == null || a.expiresAt!.isAfter(now)) &&
        (a.userType?.toLowerCase() == AccessLevel.ADMIN ||
            (a.featureName?.toLowerCase() == 'hr' &&
                a.accessLevel?.toLowerCase() == AccessLevel.ADMIN)),
  );
}

/// Whether the signed-in user may open Flipper HR (the More → Apps tile and
/// the desktop app chooser).
///
/// HR holds salaries and national IDs, so it is for whoever runs the business
/// (see [canRunHr]). Never in Local Mode, and never when the running app does
/// not ship HR.
bool dashboardCanOpenHr(WidgetRef ref) {
  if (ref.watch(hrAppBuilderProvider) == null) return false;
  if (hiddenInLocalMode(ref, 'HR')) return false;
  final accesses =
      ref.watch(allAccessesProvider(currentDashboardUserId())).value ??
      const <Access>[];
  return canRunHr(
    accesses,
    businessId: ProxyService.box.getBusinessId(),
    now: DateTime.now(),
  );
}

/// [dashboardCanOpenHr] for code that runs once instead of in build, such as
/// the login hand-off. Reads rather than watches, and waits for the access rows
/// so "not loaded yet" is never taken for "no". Fails closed.
Future<bool> dashboardCanOpenHrNow(WidgetRef ref) async {
  if (ref.read(hrAppBuilderProvider) == null) return false;
  if (ref.read(isLocalModeProvider)) return false;
  final provider = allAccessesProvider(currentDashboardUserId());
  // allAccesses is autoDispose: hold it while the rows load.
  final keepAlive = ref.listenManual(provider, (_, _) {});
  try {
    return canRunHr(
      await ref.read(provider.future),
      businessId: ProxyService.box.getBusinessId(),
      now: DateTime.now(),
    );
  } catch (_) {
    return false;
  } finally {
    keepAlive.close();
  }
}

/// Whether a dashboard app tile should be visible for the signed-in user.
bool dashboardAppTileVisible(WidgetRef ref, DashboardAllAppTile tile) {
  if (hiddenInLocalMode(ref, tile.page)) return false;
  if (tile.page == 'DailyReports') {
    return ref.watch(sideMenuShowDailyReportFilesProvider);
  }
  if (tile.page == 'StockRecount') {
    return ref.watch(sideMenuShowStockRecountProvider);
  }
  if (tile.feature == 'Orders') {
    return ref.watch(sideMenuShowIncomingOrdersProvider);
  }
  if (tile.feature == 'ServicesGigs') return true;
  if (tile.feature == 'Settings') return true;
  // Credits is an account-level MoMo top-up, not a staff permission. It is not
  // in [AppFeature] and no code path grants an Access row for it, so gating it
  // on featureAccessProvider hid the tile from everyone. Always visible.
  if (tile.feature == 'Credits') return true;
  if (tile.feature == 'AgentCommission') {
    return ref.watch(showAgentCommissionNavProvider);
  }

  final uid = currentDashboardUserId();
  final feature = tile.feature;
  if (feature == null) return true;

  // 'HR' is not an [AppFeature], so the generic check below would hide it
  // from everyone.
  if (tile.page == 'HR') return dashboardCanOpenHr(ref);

  if (feature == 'Sales' || tile.page == 'POS' || tile.page == 'Inventory') {
    // Browse the POS/inventory catalog under view (read+) access — selling and
    // product-management actions inside are gated on their own edit-access
    // (canSellProvider / admin). Includes Inventory so an Inventory grant
    // reveals this screen (the tile is otherwise tagged feature: 'Sales').
    return ref.watch(
          featureViewAccessProvider(userId: uid, featureName: AppFeature.Sales),
        ) ||
        ref.watch(
          featureViewAccessProvider(
            userId: uid,
            featureName: AppFeature.AddProduct,
          ),
        ) ||
        ref.watch(
          featureViewAccessProvider(
            userId: uid,
            featureName: AppFeature.Inventory,
          ),
        );
  }

  // The Tickets screen also hosts the Review Queue and Record Handover
  // actions, so let review-only / handover-only staff reach it. Each action
  // inside is gated on its own feature; management (collect/delete) stays
  // gated on Tickets write.
  if (feature == 'Tickets') {
    return ref.watch(
          featureAccessProvider(userId: uid, featureName: AppFeature.Tickets),
        ) ||
        ref.watch(
          featureAccessProvider(
            userId: uid,
            featureName: AppFeature.TicketReview,
          ),
        ) ||
        ref.watch(
          featureAccessProvider(
            userId: uid,
            featureName: AppFeature.StockHandover,
          ),
        );
  }

  // Read-only viewable surfaces: show under view-access (any active grant).
  // Their mutating actions (e.g. transaction refund) are gated on edit-access
  // inside the screen, so exposing the tile to read-only staff is safe.
  if (feature == AppFeature.Transactions) {
    return ref.watch(
      featureViewAccessProvider(userId: uid, featureName: feature),
    );
  }

  return ref.watch(featureAccessProvider(userId: uid, featureName: feature));
}

/// Filter catalog sections to tiles the user can access.
List<DashboardAllAppSection> filterDashboardAllAppsCatalog(
  BuildContext context,
  WidgetRef ref,
) {
  return dashboardAllAppsCatalog(context)
      .map((section) {
        final apps = section.apps
            .where((tile) => dashboardAppTileVisible(ref, tile))
            .toList();
        if (apps.isEmpty) return null;
        return DashboardAllAppSection(label: section.label, apps: apps);
      })
      .whereType<DashboardAllAppSection>()
      .toList();
}
