import 'package:flipper_services/constants.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'button.dart';
import 'customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class Apps extends StatefulWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final BusinessHomeViewModel model;

  Apps({
    Key? key,
    required final TextEditingController controller,
    required final bool isBigScreen,
    required final BusinessHomeViewModel model,
  })  : controller = controller,
        isBigScreen = isBigScreen,
        model = model,
        super(key: key);

  @override
  State<Apps> createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  final _routerService = locator<RouterService>();
  Widget _buildCustomPaintWithIcon(
      {required IconData iconData,
      required Color backgroundColor,
      required String page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        switch (page) {
          case "keypad":
            _routerService.navigateTo(CheckOutRoute(
              isBigScreen: widget.isBigScreen,
            ));
            return;
          case "settings":
            _routerService.navigateTo(SettingPageRoute());
            return;
          case "Connecta":
            ProxyService.box.write(key: 'defaultApp', value: 2);
            _routerService.navigateTo(SocialHomeViewRoute());
            return;
          case "Transactions":
            _routerService.navigateTo(TransactionsRoute());
            return;
          default:
            _routerService.navigateTo(CheckOutRoute(
              isBigScreen: widget.isBigScreen,
            ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 40),
        child: Column(
          children: [
            CustomPaint(
              painter: RPSCustomPainter(
                backgroundColor: backgroundColor,
              ),
              child: SizedBox(
                height: 90,
                width: 90,
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              page,
              style: primaryTextStyle.copyWith(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        closeButton: CLOSEBUTTON.WIDGET,
        customTrailingWidget: Container(
          child: FutureBuilder<ITenant?>(
              future: ProxyService.isar
                  .getTenantBYUserId(userId: ProxyService.box.getUserId()!),
              builder: (a, snapshoot) {
                if (snapshoot.connectionState == ConnectionState.waiting ||
                    !snapshoot.hasData) {
                  return const SizedBox.shrink();
                }
                final data = snapshoot.data;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: ProfileWidget(
                        tenant: data!,
                        size: 25,
                        showIcon: false,
                      )),
                );
              }),
        ),
        customLeadingWidget: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset(
              'assets/logo.png',
              package: 'flipper_dashboard',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCustomPaintWithIcon(
                      iconData: FluentIcons.dialpad_24_regular,
                      backgroundColor: Colors.blue,
                      page: "POS"),
                  _buildCustomPaintWithIcon(
                      iconData: FluentIcons.communication_20_regular,
                      backgroundColor: Color(0xff99DDFF),
                      page: "Connecta"),
                  _buildCustomPaintWithIcon(
                      iconData: FluentIcons.arrow_trending_lines_24_regular,
                      backgroundColor: Colors.red,
                      page: "Transactions"),
                ],
              ),
              Row(
                children: [
                  _buildCustomPaintWithIcon(
                      iconData: FluentIcons.settings_16_regular,
                      backgroundColor: Colors.blueGrey,
                      page: "settings"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
