import 'package:flipper_dashboard/ProfileFutureWidget.dart';
import 'package:flipper_dashboard/dashboard_mobile_pos_navigation.dart';
import 'package:flipper_dashboard/dashboard_view.dart';
import 'package:flipper_dashboard/dashboard_drawer.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_app_bar_leading.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Shared mobile dashboard shell for [MobileView] and [Apps].
class MobileDashboardShell extends StatefulHookConsumerWidget {
  const MobileDashboardShell({
    super.key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  });

  final TextEditingController controller;
  final bool isBigScreen;
  final CoreViewModel model;

  @override
  ConsumerState<MobileDashboardShell> createState() =>
      _MobileDashboardShellState();
}

class _MobileDashboardShellState extends ConsumerState<MobileDashboardShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DashboardMobileTab _activeTab = DashboardMobileTab.home;

  static const Color _pageBg = Color(0xFFF4F6FB);

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      warmMobilePosForCheckout(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen is only valid during build (same pattern as [CheckOut]).
    listenCachedPendingCartTransactionSyncWidget(ref, isExpense: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _pageBg,
      drawer: const DashboardDrawer(),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 56,
                child: Row(
                  children: [
                    DashboardMobileAppBarLeading(onOpenDrawer: _openDrawer),
                    const Spacer(),
                    const ProfileFutureWidget(),
                  ],
                ),
              ),
            ),
          ),
          // The nav overlays the content so its raised New sale button can
          // overlap the dashboard while staying fully tappable.
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: DashboardMobileBottomNav.barExtent(context),
                  child: DashboardView(
                    isBigScreen: widget.isBigScreen,
                    model: widget.model,
                    onQuickAccessSeeAll: _openDrawer,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DashboardMobileBottomNav(
                    activeTab: _activeTab,
                    onTabSelected: (tab) {
                      if (tab == DashboardMobileTab.home) {
                        setState(() => _activeTab = DashboardMobileTab.home);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
