import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_dashboard/features/production_output/production_output_app.dart';
import 'package:flipper_dashboard/features/services_gigs/services_gigs_app.dart';
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
import 'package:flipper_dashboard/features/services_gigs/providers/services_gig_admin_provider.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';

class AppIconsGrid extends ConsumerWidget {
  final bool isBigScreen;
  final Function(String)? onAppSelected;
  final VoidCallback? onQuickAccessSeeAll;

  const AppIconsGrid({
    Key? key,
    required this.isBigScreen,
    this.onAppSelected,
    this.onQuickAccessSeeAll,
  }) : super(key: key);

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
      case "ProductionOutput":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductionOutputApp()),
        );
        break;
      case "ServicesGigs":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ServicesGigsApp()),
        );
        break;
      case "Orders":
        await _routerService.navigateTo(InventoryRequestMobileViewRoute());
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
      if (!isBigScreen)
        {
          'icon': FluentIcons.handshake_24_regular,
          'color': const Color(0xFF0D9488),
          'page': "ServicesGigs",
          'label': "Services hub",
          'feature': 'ServicesGigs',
        },
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
      {
        'icon': FluentIcons.settings_24_regular,
        'color': const Color(0xFF64748B),
        'page': "Settings",
        'label': "Settings",
        'feature': 'Settings',
      },
      {
        'icon': Icons.factory_outlined,
        'color': const Color(0xFF0078D4), // SAP Fiori blue
        'page': "ProductionOutput",
        'label': "Production",
        'feature': 'ProductionOutput',
      },
      if (!isBigScreen)
        {
          'icon': FluentIcons.clipboard_letter_24_regular,
          'color': Colors.blue,
          'page': "Orders",
          'label': "Orders",
          'feature': 'Orders',
        },
    ];

    // Filtering out apps the user does not have access to
    final filteredApps = rippleApps.where((app) {
      if (app['feature'] == 'Orders') return true;
      if (app['feature'] == 'ServicesGigs') return true;
      if (app['feature'] == 'Settings') return true;
      final hasAccess = ref.watch(
        featureAccessProvider(
          featureName: app['feature'],
          userId: ProxyService.box.getUserId() ?? "",
        ),
      );
      return hasAccess;
    }).toList();

    final grid = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isBigScreen ? 6 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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

    if (!isBigScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                Text(
                  'QUICK ACCESS',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                if (onQuickAccessSeeAll != null)
                  TextButton(
                    onPressed: onQuickAccessSeeAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'See all',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF006AFE),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          grid,
        ],
      );
    }

    return grid;
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
        wrapInMobileTile: !isBigScreen,
        onTap: () async {
          HapticFeedback.lightImpact();
          await _navigateToPage(app['page'], ref, app['feature'], context);
        },
      );
    }

    final page = app['page'] as String;
    final useMobileSvg = !isBigScreen && DashboardQuickAccessSvgs.hasSvgTile(page);

    final isServicesHub = page == 'ServicesGigs';
    final baseColor = app['color'] as Color;
    final userId = ProxyService.box.getUserId() ?? '';
    final Color effectiveColor;
    if (useMobileSvg) {
      effectiveColor = baseColor;
    } else if (isServicesHub && userId.isNotEmpty) {
      effectiveColor = ref.watch(servicesGigAdminProvider(userId)).when(
            data: (isAdmin) =>
                isAdmin ? const Color(0xFFDC2626) : baseColor,
            loading: () => baseColor,
            error: (_, __) => baseColor,
          );
    } else {
      effectiveColor = baseColor;
    }

    final Widget iconArea;
    if (useMobileSvg) {
      iconArea = Center(
        child: DashboardQuickAccessSvgs.mobileTileIcon(page),
      );
    } else {
      iconArea = Icon(
        app['icon'] as IconData,
        color: effectiveColor,
        size: isBigScreen ? 28 : 30,
      );
    }

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: isBigScreen ? 60 : 56,
          height: isBigScreen ? 60 : 56,
          decoration: BoxDecoration(
            color: useMobileSvg
                ? DashboardQuickAccessSvgs.mobileTileBackground(page)
                : effectiveColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: iconArea,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            app['label'],
                      style: GoogleFonts.outfit(
              fontSize: isBigScreen ? 12 : 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await _navigateToPage(app['page'], ref, app['feature'], context);
      },
      child: isBigScreen ? content : _quickAccessTileShell(child: content),
    );
  }

  Widget _quickAccessTileShell({required Widget child}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: child,
      ),
    );
  }
}

class _CreditsAppCard extends ConsumerWidget {
  final Map<String, dynamic> app;
  final bool isBigScreen;
  final bool wrapInMobileTile;
  final VoidCallback onTap;

  const _CreditsAppCard({
    Key? key,
    required this.app,
    required this.isBigScreen,
    this.wrapInMobileTile = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId();
    final creditAsyncValue = branchId != null
        ? ref.watch(creditStreamProvider(branchId))
        : const AsyncValue.data(null); // Handle null branchId case

    final inner = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: isBigScreen ? 60 : 56,
          height: isBigScreen ? 60 : 56,
          decoration: BoxDecoration(
            color: !isBigScreen
                ? DashboardQuickAccessSvgs.mobileTileBackground('Credits')
                : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: !isBigScreen
                ? creditAsyncValue.when(
                    data: (_) => DashboardQuickAccessSvgs.mobileTileIcon(
                      'Credits',
                    ),
                    loading: () => SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    error: (_, __) => const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 28,
                    ),
                  )
                : creditAsyncValue.when(
                    data: (credit) {
                      final availableCredits = credit?.credits.toInt() ?? 100;
                      return CreditIconWidget(
                        credits: availableCredits,
                        maxCredits: 1000000,
                        size: 28,
                      );
                    },
                    loading: () => SizedBox(
                      width: 24,
                      height: 24,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (error, stack) => const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            app['label'],
                      style: GoogleFonts.outfit(
              fontSize: isBigScreen ? 12 : 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: wrapInMobileTile
          ? Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: inner,
              ),
            )
          : inner,
    );
  }
}
