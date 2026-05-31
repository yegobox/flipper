import 'package:flipper_dashboard/ProfileFutureWidget.dart';
import 'package:flipper_dashboard/dashboard_view.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_app_bar_leading.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:flipper_models/db_model_export.dart';
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
  DashboardMobileTab _activeTab = DashboardMobileTab.home;

  static const Color _pageBg = Color(0xFFF4F6FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
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
                    const DashboardMobileAppBarLeading(),
                    const Spacer(),
                    const ProfileFutureWidget(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: DashboardView(
              isBigScreen: widget.isBigScreen,
              model: widget.model,
            ),
          ),
          DashboardMobileBottomNav(
            activeTab: _activeTab,
            onTabSelected: (tab) {
              if (tab == DashboardMobileTab.home) {
                setState(() => _activeTab = DashboardMobileTab.home);
              }
            },
          ),
        ],
      ),
    );
  }
}
