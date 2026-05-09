import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_dashboard/features/leads/leads_mobile_screen.dart';
import 'package:flipper_dashboard/features/production_output/production_output_app.dart';
import 'package:flipper_dashboard/features/services_gigs/services_gigs_app.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Central navigation for dashboard quick-access apps (grid tiles, launcher shortcuts).
///
/// Keep in sync with [AppIconsGrid] routing logic.
Future<void> navigateToDashboardAppPage({
  required BuildContext context,
  required bool isBigScreen,
  required String page,
  void Function(String page)? onAppSelected,
}) async {
  if (onAppSelected != null) {
    onAppSelected(page);
    return;
  }

  final routerService = locator<RouterService>();
  switch (page) {
    case 'POS':
      await routerService.navigateTo(
        CheckOutRoute(isBigScreen: isBigScreen),
      );
      break;
    case 'Inventory':
      await routerService.navigateTo(
        CheckOutRoute(isBigScreen: isBigScreen),
      );
      break;
    case 'Cashbook':
      await routerService.navigateTo(
        CashbookRoute(isBigScreen: isBigScreen),
      );
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
      ProxyService.box.writeString(key: 'defaultApp', value: '2');
      await routerService.navigateTo(SocialHomeViewRoute());
      break;
    case 'Transactions':
      await routerService.navigateTo(TransactionsRoute());
      break;
    case 'Contacts':
      await routerService.navigateTo(CustomersRoute());
      break;
    case 'Credits':
      await routerService.navigateTo(CreditAppRoute());
      break;
    case 'Chat':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => const AiScreen()),
      );
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
        MaterialPageRoute<void>(
          builder: (context) => const ServicesGigsApp(),
        ),
      );
      break;
    case 'Orders':
      await routerService.navigateTo(InventoryRequestMobileViewRoute());
      break;
    case 'Leads':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const LeadsMobileScreen(),
        ),
      );
      break;
    default:
      await routerService.navigateTo(
        CheckOutRoute(isBigScreen: isBigScreen),
      );
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
