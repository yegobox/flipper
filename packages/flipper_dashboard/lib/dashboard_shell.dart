import 'package:flutter_riverpod/legacy.dart';

enum DashboardPage {
  inventory,
  ai,
  leads,
  reports,
  kitchen,
  orders,
  stockRecount,
  delegations,
  incomingOrders,
  shiftHistory,
  productionOutput,
  dailyReportFiles,
  agentCommission,
  purchases,
  recordPurchase,
}

final selectedPageProvider = StateProvider<DashboardPage>(
  (ref) => DashboardPage.inventory,
);
