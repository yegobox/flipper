import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_dashboard/books_module_navigation.dart';
import 'package:flipper_dashboard/features/daily_report_files/daily_report_files_app.dart';
import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_screen.dart';
import 'package:flipper_dashboard/features/leads/leads_mobile_screen.dart';
import 'package:flipper_dashboard/features/production_output/production_output_app.dart';
import 'package:flipper_dashboard/features/stock_recount/stock_recount_list_screen.dart';
import 'package:flipper_dashboard/features/transfers_report/transfers_report_screen.dart';
import 'package:flipper_dashboard/features/import_purchase/purchases_mobile_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/services_gigs_app.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

/// A second tap inside this window is a double tap, not a new request.
const Duration _dashboardNavDoubleTapWindow = Duration(milliseconds: 600);
DateTime? _lastDashboardNavAt;

/// Central navigation for dashboard quick-access apps (grid tiles, launcher shortcuts).
///
/// Keep in sync with [AppIconsGrid] and [dashboardAllAppsCatalog].
Future<void> navigateToDashboardAppPage({
  required BuildContext context,
  required bool isBigScreen,
  required String page,
  WidgetRef? ref,
  NavigatorState? navigator,
  void Function(String page)? onAppSelected,
}) async {
  if (onAppSelected != null) {
    onAppSelected(page);
    return;
  }

  // Pushed routes only complete when popped, so an in-flight flag would block
  // every later navigation; a short window drops just the double tap that
  // would otherwise push the same page twice.
  final now = DateTime.now();
  final last = _lastDashboardNavAt;
  if (last != null && now.difference(last) < _dashboardNavDoubleTapWindow) {
    return;
  }
  _lastDashboardNavAt = now;

  final nav = navigator ?? Navigator.maybeOf(context, rootNavigator: true);

  if (page != 'Accounting' && nav != null) {
    popBooksModuleIfOpen(nav);
  }

  final routerService = locator<RouterService>();
  switch (page) {
    case 'Accounting':
      if (ref == null) return;
      await navigateToBooksModule(context, ref, navigator: nav);
      break;
    case 'POS':
      await routerService.navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
      break;
    case 'Inventory':
      await routerService.navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
      break;
    case 'Cashbook':
      await routerService.navigateTo(CashbookRoute(isBigScreen: isBigScreen));
      break;
    case 'Settings':
      await routerService.navigateTo(SettingPageRoute());
      break;
    case 'Support':
      final whatsappUri = Uri.parse('https://wa.me/250788360058');
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $whatsappUri';
      }
      break;
    case 'Connecta':
      // The social home screen this opened no longer exists — the route it
      // used was a stale generated class with no page behind it, so this
      // navigation has been failing at runtime. The preference is still
      // written; restore the navigation when there is a screen to land on.
      ProxyService.box.writeString(key: 'defaultApp', value: '2');
      break;
    case 'Transactions':
      await routerService.navigateTo(TransactionsRoute());
      break;
    case 'Tickets':
      await routerService.navigateTo(TicketsListRoute(transaction: null));
      break;
    case 'Contacts':
      await routerService.navigateTo(CustomersRoute());
      break;
    case 'Credits':
      await routerService.navigateTo(CreditAppRoute());
      break;
    case 'Chat':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (context) => const AiScreen()));
      break;
    case 'ProductionOutput':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const ProductionOutputApp(),
        ),
      );
      break;
    case 'ServicesGigs':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => const ServicesGigsApp()),
      );
      break;
    case 'Orders':
      await routerService.navigateTo(InventoryRequestMobileViewRoute());
      break;
    case 'Purchases':
      // Supplier purchases (RRA + manually recorded, incl. bought on credit).
      // Desktop reaches this through DashboardPage.purchases.
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const PurchasesMobileScreen()),
      );
      break;
    case 'Leads':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const LeadsMobileScreen(),
        ),
      );
      break;
    case 'PersonalGoals':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const PersonalGoalsScreen(),
        ),
      );
      break;
    case 'AgentCommission':
      await routerService.navigateTo(AgentCommissionScreenRoute());
      break;
    case 'DailyReports':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const DailyReportFilesApp()),
      );
      break;
    case 'StockRecount':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const StockRecountListScreen()),
      );
      break;
    case 'TransfersReport':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          // The screen is chrome-less so it can sit inside the desktop
          // layout; a pushed route needs its own Scaffold and back button.
          builder: (_) => Scaffold(
            backgroundColor: OmTokens.canvas,
            appBar: AppBar(
              backgroundColor: OmTokens.canvas,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            body: const SafeArea(top: false, child: TransfersReportScreen()),
          ),
        ),
      );
      break;
    default:
      await routerService.navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
      break;
  }
}

bool dashboardAppPageSupportsLauncherShortcut(String page) {
  switch (page) {
    case 'Support':
      return false;
    default:
      return true;
  }
}
