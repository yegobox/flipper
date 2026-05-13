import 'dart:async';

import 'package:flipper_dashboard/CreditIcon.dart';
import 'package:flipper_dashboard/dashboard_app_shortcuts.dart';
import 'package:flipper_dashboard/dashboard_quick_apps_navigation.dart';
import 'package:flipper_dashboard/features/services_gigs/providers/services_gig_admin_provider.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flipper_services/app_shortcuts_platform.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';

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
        'icon': FluentIcons.savings_24_regular,
        'color': const Color(0xFF7C3AED),
        'page': "PersonalGoals",
        'label': "Personal goals",
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
        'icon': FluentIcons.people_32_regular,
        'color': const Color(0xFF2563EB),
        'page': "Leads",
        'label': "Leads",
        'feature': AppFeature.Leads,
        'svg': AdminDashboardSvgs.leadsUsersMultiple,
        'svgBg': const Color(0xFFEFF2FF),
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
    final uid = ProxyService.box.getUserId() ?? '';
    final filteredApps = rippleApps.where((app) {
      if (app['feature'] == 'Orders') return true;
      if (app['feature'] == 'ServicesGigs') return true;
      if (app['feature'] == 'Settings') return true;
      final feature = app['feature'] as String;
      // POS hosts "Add product"; show tile if user can sell or add catalog items.
      if (feature == 'Sales' || app['page'] == 'POS') {
        final canSell = ref.watch(
          featureAccessProvider(userId: uid, featureName: AppFeature.Sales),
        );
        final canAddProduct = ref.watch(
          featureAccessProvider(
            userId: uid,
            featureName: AppFeature.AddProduct,
          ),
        );
        return canSell || canAddProduct;
      }
      return ref.watch(
        featureAccessProvider(userId: uid, featureName: feature),
      );
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
          shortcutsEnabled: onAppSelected == null,
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
    required bool shortcutsEnabled,
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
          await navigateToDashboardAppPage(
            context: context,
            isBigScreen: isBigScreen,
            page: app['page'] as String,
            onAppSelected: onAppSelected,
          );
        },
        onLongPress: shortcutsEnabled
            ? () => unawaited(_offerPinnedShortcut(context: context, app: app))
            : null,
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
    } else if (app['svg'] != null) {
      iconArea = Center(
        child: SvgPicture.string(
          app['svg'] as String,
          width: isBigScreen ? 26 : 24,
          height: isBigScreen ? 26 : 24,
          colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
        ),
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
                : (app['svgBg'] as Color?) ??
                    effectiveColor.withValues(alpha: 0.1),
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
        await navigateToDashboardAppPage(
          context: context,
          isBigScreen: isBigScreen,
          page: app['page'] as String,
          onAppSelected: onAppSelected,
        );
      },
      onLongPress: shortcutsEnabled &&
              UniversalPlatform.isAndroid &&
              dashboardAppPageSupportsLauncherShortcut(page)
          ? () => unawaited(_offerPinnedShortcut(context: context, app: app))
          : null,
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

Future<void> _offerPinnedShortcut({
  required BuildContext context,
  required Map<String, dynamic> app,
}) async {
  final page = app['page'] as String;
  final label = app['label'] as String;
  if (!dashboardAppPageSupportsLauncherShortcut(page)) return;

  final messenger = ScaffoldMessenger.maybeOf(context);
  final supported = await AppShortcutsPlatform.isPinShortcutSupported();
  if (!supported) {
    messenger?.showSnackBar(
      const SnackBar(
        content: Text('Pinned shortcuts are not supported on this device.'),
      ),
    );
    return;
  }

  final id = dashboardPinnedShortcutId(page);
  final result = await AppShortcutsPlatform.requestPinShortcut(
    id: id,
    label: label,
    page: page,
  );

  if (!context.mounted) return;

  if (result.ok) {
    messenger?.showSnackBar(
      SnackBar(content: Text('Add "$label" to your home screen when prompted.')),
    );
  } else {
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          result.reason == 'launcher_unsupported'
              ? 'Your launcher does not support pinned shortcuts.'
              : 'Could not create shortcut.',
        ),
      ),
    );
  }
}

class _CreditsAppCard extends ConsumerWidget {
  final Map<String, dynamic> app;
  final bool isBigScreen;
  final bool wrapInMobileTile;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _CreditsAppCard({
    Key? key,
    required this.app,
    required this.isBigScreen,
    this.wrapInMobileTile = false,
    required this.onTap,
    this.onLongPress,
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
      onLongPress: onLongPress,
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
