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

  const AppIconsGrid({
    Key? key,
    required this.isBigScreen,
    this.onAppSelected,
  }) : super(key: key);

  Future<void> _navigateToPage(
      String page, WidgetRef ref, String feature) async {
    if (onAppSelected != null) {
      onAppSelected!(page);
      return;
    }

    final _routerService = locator<RouterService>();
    switch (page) {
      case "POS":
        await _routerService
            .navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
        break;
      case "Inventory":
        await _routerService
            .navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
        break;
      case "Cashbook":
        await _routerService
            .navigateTo(CashbookRoute(isBigScreen: isBigScreen));
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
      case "Orders":
        await _routerService.navigateTo(InventoryRequestMobileViewRoute());
        break;
      case "Credits":
        await _routerService.navigateTo(CreditAppRoute());
        break;
      default:
        await _routerService
            .navigateTo(CheckOutRoute(isBigScreen: isBigScreen));
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
        'feature': 'Sales'
      },
      {
        'icon': FluentIcons.book_48_regular,
        'color': const Color(0xFF66AAFF),
        'page': "Cashbook",
        'label': "Cash Book",
        'feature': 'Cashbook'
      },
      {
        'icon': FluentIcons.arrow_swap_20_regular,
        'color': const Color(0xFFFF0331),
        'page': "Transactions",
        'label': "Transactions",
        'feature': 'Transactions'
      },
      {
        'icon': FluentIcons.people_32_regular,
        'color': Colors.cyan,
        'page': "Contacts",
        'label': "Contacts",
        'feature': 'Contacts'
      },
      {
        'icon': Icons.store_rounded,
        'color': Colors.green,
        'page': "Orders",
        'label': "Orders",
        'feature': 'Orders'
      },
      {
        'icon': Icons.call,
        'color': Colors.lightBlue,
        'page': "Support",
        'label': "Support",
        'feature': 'Support'
      },
      {
        'icon': Icons.credit_card,
        'color': Colors.orange,
        'page': "Credits",
        'label': "Credits",
        'feature': 'Credits',
        'isSpecial': true
      }
    ];

    // Filtering out apps the user does not have access to
    final filteredApps = rippleApps.where((app) {
      final hasAccess = ref.watch(featureAccessProvider(
          featureName: app['feature'], userId: ProxyService.box.getUserId()!));
      return hasAccess;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isBigScreen ? 6 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredApps.length,
      itemBuilder: (context, index) {
        final app = filteredApps[index];
        return _buildAppCard(app, isBigScreen: isBigScreen, ref: ref);
      },
    );
  }

  Widget _buildAppCard(Map<String, dynamic> app,
      {required bool isBigScreen, required WidgetRef ref}) {
    // Special handling for Credits app
    if (app['isSpecial'] == true && app['page'] == "Credits") {
      return _CreditsAppCard(
        app: app,
        isBigScreen: isBigScreen,
        onTap: () async {
          HapticFeedback.lightImpact();
          await _navigateToPage(app['page'], ref, app['feature']);
        },
      );
    }

    return Card(
      elevation: 1,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          HapticFeedback.lightImpact();
          await _navigateToPage(app['page'], ref, app['feature']);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isBigScreen ? 6 : 12),
              decoration: BoxDecoration(
                color: app['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(app['icon'],
                  color: app['color'], size: isBigScreen ? 18 : 28),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                app['label'],
                style: GoogleFonts.poppins(
                  fontSize: isBigScreen ? 11 : 12,
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
      ),
    );
  }
}

// Separate widget for Credits app card to handle its own state
class _CreditsAppCard extends StatefulWidget {
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
  State<_CreditsAppCard> createState() => _CreditsAppCardState();
}

class _CreditsAppCardState extends State<_CreditsAppCard> {
  // Local instance of CreditData - in a real app, you'd get this from a repository or service
  final CreditData _creditData = CreditData();

  @override
  void initState() {
    super.initState();
    // Initialize credit data from API
    _loadCreditsFromApi();
  }

  Future<void> _loadCreditsFromApi() async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId != null) {
        // Get branch from server ID
        final branch = await ProxyService.strategy.branch(serverId: branchId);
        if (branch != null) {
          // Get credit from branch ID
          final creditStream = ProxyService.strategy.credit(branchId: branch.id);
          // Take the first value from the stream to get initial credit amount
          final initialCredit = await creditStream.first;
          if (initialCredit != null) {
            // Use buyCredits with the actual credit value from the API
            _creditData.buyCredits(initialCredit.credits.toInt());
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading credits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CreditIconWidget(
              credits: _creditData.availableCredits,
              maxCredits: _creditData.maxCredits,
              size: widget.isBigScreen ? 30 : 40,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.app['label'],
                style: GoogleFonts.poppins(
                  fontSize: widget.isBigScreen ? 11 : 12,
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
      ),
    );
  }
}
