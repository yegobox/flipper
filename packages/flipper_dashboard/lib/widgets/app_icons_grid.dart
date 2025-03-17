import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class AppIconsGrid extends ConsumerWidget {
  final bool isBigScreen;

  const AppIconsGrid({
    Key? key,
    required this.isBigScreen,
  }) : super(key: key);
  Future<void> _navigateToPage(String page) async {
    final _routerService = locator<RouterService>();
    switch (page) {
      case "POS":
        await _routerService.navigateTo(CheckOutRoute(
          isBigScreen: isBigScreen,
        ));
        break;
      case "Inventory":
        await _routerService.navigateTo(CheckOutRoute(
          isBigScreen: isBigScreen,
        ));
        break;
      case "Cashbook":
        await _routerService.navigateTo(CashbookRoute(
          isBigScreen: isBigScreen,
        ));
        break;
      case "Settings":
        await _routerService.navigateTo(SettingPageRoute());
        break;
      case "Support":
        final Uri whatsappUri = Uri.parse('https://wa.me/250788360058');
        if (await canLaunchUrl(whatsappUri)) {
          await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $whatsappUri';
        }
        break;
      case "Connecta":
        ProxyService.box.writeString(key: 'defaultApp', value: "2");
        await _routerService.navigateTo(SocialHomeViewRoute());
        break;
      case "Transactions":
        await _routerService.navigateTo(TransactionsRoute());
        break;
      case "Contacts":
        await _routerService.navigateTo(CustomersRoute());
        break;
      //TODO: if a user is of type agent do not show this Order menu.
      case "Orders":
        await _routerService.navigateTo(InventoryRequestMobileViewRoute());
        break;
      default:
        await _routerService.navigateTo(CheckOutRoute(
          isBigScreen: isBigScreen,
        ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> apps = [
      {
        'icon': FluentIcons.calculator_24_regular,
        'color': const Color(0xff006AFE),
        'page': "POS",
        'label': "Point of Sale"
      },
      {
        'icon': FluentIcons.book_48_regular,
        'color': const Color(0xFF66AAFF),
        'page': "Cashbook",
        'label': "Cash Book"
      },
      {
        'icon': FluentIcons.arrow_swap_20_regular,
        'color': const Color(0xFFFF0331),
        'page': "Transactions",
        'label': "Transactions"
      },
      {
        'icon': FluentIcons.people_32_regular,
        'color': Colors.cyan,
        'page': "Contacts",
        'label': "Contacts"
      },
      {
        'icon': Icons.store_rounded,
        'color': Colors.green,
        'page': "Orders",
        'label': "Orders"
      },
      {
        'icon': Icons.call,
        'color': Colors.lightBlue,
        'page': "Support",
        'label': "Support"
      }
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              HapticFeedback.lightImpact();
              await _navigateToPage(app['page']);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: app['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    app['icon'],
                    color: app['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  app['label'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
