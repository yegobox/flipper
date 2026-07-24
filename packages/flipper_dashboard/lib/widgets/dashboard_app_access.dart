import 'package:flipper_dashboard/providers/agent_commission_access_provider.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Whether a dashboard app tile should be visible for the signed-in user.
bool dashboardAppTileVisible(WidgetRef ref, DashboardAllAppTile tile) {
  if (tile.page == 'DailyReports') {
    return ref.watch(sideMenuShowDailyReportFilesProvider);
  }
  if (tile.page == 'StockRecount') {
    return ref.watch(sideMenuShowStockRecountProvider);
  }
  if (tile.feature == 'Orders') return true;
  if (tile.feature == 'ServicesGigs') return true;
  if (tile.feature == 'Settings') return true;
  if (tile.feature == 'AgentCommission') {
    return ref.watch(showAgentCommissionNavProvider);
  }

  final uid = ProxyService.box.getUserId() ?? '';
  final feature = tile.feature;
  if (feature == null) return true;

  if (feature == 'Sales' || tile.page == 'POS' || tile.page == 'Inventory') {
    final canSell = ref.watch(
      featureAccessProvider(userId: uid, featureName: AppFeature.Sales),
    );
    final canAddProduct = ref.watch(
      featureAccessProvider(userId: uid, featureName: AppFeature.AddProduct),
    );
    return canSell || canAddProduct;
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
