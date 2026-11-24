import 'package:flutter_riverpod/legacy.dart';

enum DashboardPage {
  inventory,
  ai,
  leads,
  kitchen,
  orders,
  stockRecount,
  delegations,
  incomingOrders,
  transfersReport,
  shiftHistory,
  productionOutput,
  dailyReportFiles,
  agentCommission,
  purchases,
}

final selectedPageProvider = StateProvider<DashboardPage>(
  (ref) => DashboardPage.inventory,
);

/// The `module` a dashboard page reports in `feature_used`. The inventory
/// page is the POS till; the AI page is Flo.
String analyticsModuleForPage(DashboardPage page) => switch (page) {
  DashboardPage.inventory => 'pos',
  DashboardPage.ai => 'flo',
  _ => page.name.replaceAllMapped(
    RegExp('[A-Z]'),
    (m) => '_${m[0]!.toLowerCase()}',
  ),
};
