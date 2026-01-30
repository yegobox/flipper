import 'package:flipper_dashboard/layout.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Defines the search context based on the active page
enum SearchContext {
  products, // For inventory/POS pages
  transactions, // For reports/transactions pages
  orders, // For orders page
  general, // For other pages
}

/// Provider that determines search context from the active page
final searchContextProvider = Provider<SearchContext>((ref) {
  final selectedPage = ref.watch(selectedPageProvider);

  switch (selectedPage) {
    case DashboardPage.inventory:
      return SearchContext.products;
    case DashboardPage.orders:
    case DashboardPage.incomingOrders:
      return SearchContext.orders;
    case DashboardPage.reports:
      return SearchContext.transactions;
    case DashboardPage.kitchen:
    case DashboardPage.ai:
    case DashboardPage.stockRecount:
    case DashboardPage.delegations:
    case DashboardPage.shiftHistory:
    case DashboardPage.productionOutput:
      return SearchContext.general;
  }
});
