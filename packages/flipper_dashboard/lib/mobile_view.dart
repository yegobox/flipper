import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/dashboard_view.dart';
import 'package:flipper_dashboard/ProfileFutureWidget.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_app_bar_leading.dart';
import 'drawerB.dart';
import 'customappbar.dart';

class MobileView extends StatefulHookConsumerWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final CoreViewModel model;

  const MobileView({
    Key? key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  }) : super(key: key);

  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: MyDrawer(),
      appBar: CustomAppBar(
        isDividerVisible: false,
        bottomSpacer: 48.99,
        closeButton: CLOSEBUTTON.WIDGET,
        customTrailingWidget: ProfileFutureWidget(),
        customLeadingWidget: DashboardMobileAppBarLeading(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: DashboardView(
        isBigScreen: widget.isBigScreen,
        model: widget.model,
        onQuickAccessSeeAll: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }
}
