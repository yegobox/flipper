import 'package:flutter/material.dart';
import 'package:flipper_dashboard/ProfileFutureWidget.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/dashboard_view.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_app_bar_leading.dart';
import 'drawerB.dart';
import 'customappbar.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Apps extends StatefulHookConsumerWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final CoreViewModel model;
  final Function(String appId)? onAppLongPress;

  const Apps({
    Key? key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
    this.onAppLongPress,
  }) : super(key: key);

  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends ConsumerState<Apps> {
  // ignore: unused_field
  final _routerService = locator<RouterService>();
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
