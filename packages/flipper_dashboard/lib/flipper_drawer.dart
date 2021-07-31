import 'package:flipper/localization.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/drawer_viewmodel.dart';
import 'package:flipper_services/abstractions/dynamic_link.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'business_list.dart';
import 'custom_widgets.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_services/constants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ant_icons/ant_icons.dart';

class FlipperDrawer extends StatefulWidget {
  FlipperDrawer({Key? key, required this.businesses}) : super(key: key);
  final List<Business> businesses;

  @override
  State<FlipperDrawer> createState() => _FlipperDrawerState();
}

class _FlipperDrawerState extends State<FlipperDrawer> {
  final DynamicLink _link = locator<DynamicLink>();
  bool isSwitched = false;

  ListTile _menuListRowButton(String title,
      {Function? onPressed,
      IconData? icon,
      bool isEnable = true,
      required BuildContext context}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      title: IconButton(
        icon: Icon(icon ?? Icons.settings),
        tooltip: 'Settings',
        onPressed: () {
          onPressed!();
        },
      ),
      leading: customText(
        //was title when leading was not commented out.
        title,
        style: TextStyle(
          fontSize: 20,
          color: isEnable
              ? Theme.of(context)
                  .copyWith(canvasColor: Colors.black)
                  .canvasColor
              : Theme.of(context)
                  .copyWith(canvasColor: const Color(0xffe2e8ea))
                  .canvasColor,
        ),
        context: context,
      ),
    );
  }

  Widget _footer(
      {required DrawerViewModel drawerViewmodel,
      required BuildContext context}) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: <Widget>[
          _menuListRowButton(
            'Flipper Social',
            context: context,
            icon: Ionicons.chatbox,
            onPressed: () {
              ProxyService.box.write(key: pageKey, value: 'social');

              ProxyService.nav.navigateTo(Routes.startUpView);
            },
          ),
          const Divider(height: 0),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
                height: 45,
              ),
              FutureBuilder<String>(
                future: _link.createDynamicLink(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final String uri = snapshot.data as String;
                    return GestureDetector(
                      onTap: () {
                        ProxyService.share.share(uri.toString());
                      },
                      child: customIcon(context,
                          icon: 0xf066,
                          istwitterIcon: true,
                          size: 25,
                          iconColor: Theme.of(context).colorScheme.secondary),
                    );
                  } else {
                    return customIcon(context,
                        icon: 0xf066,
                        istwitterIcon: true,
                        size: 25,
                        iconColor: Theme.of(context).colorScheme.secondary);
                  }
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // drawerViewmodel.loginWithQr(context: context);
                },
                child: Image.asset(
                  'assets/images/qr.png',
                  height: 25,
                ),
              ),
              const SizedBox(
                width: 10,
                height: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
      viewModelBuilder: () => DrawerViewModel(),
      builder: (context, model, child) => Container(
        child: Drawer(
          elevation: 0,
          child: Container(
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BusinessList(
                  businesses: widget.businesses,
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: <Widget>[
                            const Divider(),
                            _menuListRowButton(
                              Localization.of(context)!.flipperSetting,
                              context: context,
                              icon: AntIcons.setting,
                              onPressed: () {
                                ProxyService.nav.navigateTo(Routes.settings);
                              },
                            ),
                            const Divider(),
                            if (ProxyService.remoteConfig
                                .isAnalyticFeatureAvailable())
                              _menuListRowButton(
                                'Analytics',
                                context: context,
                                icon: Ionicons.analytics,
                                onPressed: () {
                                  ProxyService.nav.navigateTo(Routes.analytics);
                                },
                              ),
                            const Divider(),
                          ],
                        ),
                      ),
                      ProxyService.remoteConfig.isChatAvailable() || kDebugMode
                          ? _footer(
                              drawerViewmodel: model,
                              context: context,
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
