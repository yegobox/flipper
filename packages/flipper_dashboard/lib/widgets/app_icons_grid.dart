import 'package:flipper_dashboard/features/ai/screens/ai_screen.dart';
import 'package:flipper_models/providers/all_providers.dart';
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
import 'package:flipper_dashboard/CreditIcon.dart';

class AppIconsGrid extends ConsumerWidget {
  final bool isBigScreen;
  final Function(String)? onAppSelected;

  const AppIconsGrid({Key? key, required this.isBigScreen, this.onAppSelected})
    : super(key: key);

  Future<void> _navigateToPage(
    String page,
    WidgetRef ref,
    String feature,
    BuildContext context,
  ) async {
    if (onAppSelected != null) {
      onAppSelected!(page);
      return;
    }

    final _routerService = locator<RouterService>();
    switch (page) {
      case "POS":
        await _routerService.navigateTo(
          CheckOutRoute(isBigScreen: isBigScreen),
        );
        break;
      case "Inventory":
        await _routerService.navigateTo(
          CheckOutRoute(isBigScreen: isBigScreen),
        );
        break;
      case "Cashbook":
        await _routerService.navigateTo(
          CashbookRoute(isBigScreen: isBigScreen),
        );
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
      case "Credits":
        await _routerService.navigateTo(CreditAppRoute());
        break;
      case "Chat":
        // Use the navigation service to navigate to the AI screen
        // locator<NavigationService>().navigateToView(const Ai());
        // use navigator to navigate to the AI screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AiScreen()),
        );
        break;
      default:
        await _routerService.navigateTo(
          CheckOutRoute(isBigScreen: isBigScreen),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> rippleApps = [
      {
        'icon': FluentIcons.calculator_24_regular,
        'color': const Color(0xff006AFE),
        'page': "POS",
        'label': "Point of Sale",
        'feature': 'Sales',
      },
      {
        'icon': FluentIcons.book_48_regular,
        'color': const Color(0xFF66AAFF),
        'page': "Cashbook",
        'label': "Cash Book",
        'feature': 'Cashbook',
      },
      {
        'icon': FluentIcons.arrow_swap_20_regular,
        'color': const Color(0xFFFF0331),
        'page': "Transactions",
        'label': "Transactions",
        'feature': 'Transactions',
      },
      {
        'icon': FluentIcons.people_32_regular,
        'color': Colors.cyan,
        'page': "Contacts",
        'label': "Contacts",
        'feature': 'Contacts',
      },
      {
        'icon': Icons.call,
        'color': Colors.lightBlue,
        'page': "Support",
        'label': "Support",
        'feature': 'Support',
      },
      {
        'icon': Icons.credit_card,
        'color': Colors.orange,
        'page': "Credits",
        'label': "Credits",
        'feature': 'Credits',
        'isSpecial': true,
      },
      {
        'icon': FluentIcons.chat_24_regular,
        'color': Colors.purple,
        'page': "Chat",
        'label': "AI Chat",
        'feature': 'Chat',
      },
    ];

    // Filtering out apps the user does not have access to
    final filteredApps = rippleApps.where((app) {
      final hasAccess = ref.watch(
        featureAccessProvider(
          featureName: app['feature'],
          userId: ProxyService.box.getUserId() ?? "",
        ),
      );
      return hasAccess;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isBigScreen ? 6 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredApps.length,
      itemBuilder: (context, index) {
        final app = filteredApps[index];
        return _buildAppCard(
          app,
          isBigScreen: isBigScreen,
          ref: ref,
          context: context,
        );
      },
    );
  }

  Widget _buildAppCard(
    Map<String, dynamic> app, {
    required bool isBigScreen,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    // Special handling for Credits app
    if (app['isSpecial'] == true && app['page'] == "Credits") {
      return _CreditsAppCard(
        app: app,
        isBigScreen: isBigScreen,
        onTap: () async {
          HapticFeedback.lightImpact();
          await _navigateToPage(app['page'], ref, app['feature'], context);
        },
      );
    }

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await _navigateToPage(app['page'], ref, app['feature'], context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isBigScreen ? 60 : 72,
            height: isBigScreen ? 60 : 72,
            decoration: BoxDecoration(
              color: app['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18), // Squircle
            ),
            child: Icon(
              app['icon'],
              color: app['color'],
              size: isBigScreen ? 28 : 36,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              app['label'],
              style: GoogleFonts.poppins(
                fontSize: isBigScreen ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditsAppCard extends ConsumerWidget {
  final Map<String, dynamic> app;
  final bool isBigScreen;
  final VoidCallback onTap;

  const _CreditsAppCard({
    Key? key,
    required this.app,
    required this.isBigScreen,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId();
    final creditAsyncValue = branchId != null
        ? ref.watch(creditStreamProvider(branchId))
        : const AsyncValue.data(null); // Handle null branchId case

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isBigScreen ? 60 : 72,
            height: isBigScreen ? 60 : 72,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18), // Squircle
            ),
            child: Center(
              child: creditAsyncValue.when(
                data: (credit) {
                  final availableCredits = credit?.credits.toInt() ?? 100;
                  return CreditIconWidget(
                    credits: availableCredits,
                    maxCredits: 1000000,
                    size: isBigScreen ? 28 : 36,
                  );
                },
                loading: () => SizedBox(
                  width: isBigScreen ? 24 : 32,
                  height: isBigScreen ? 24 : 32,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => Icon(
                  Icons.error,
                  color: Colors.red,
                  size: isBigScreen ? 28 : 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              app['label'],
              style: GoogleFonts.poppins(
                fontSize: isBigScreen ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
