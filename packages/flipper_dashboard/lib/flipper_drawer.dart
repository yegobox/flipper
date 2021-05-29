import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/drawer_viewmodel.dart';
import 'package:flipper_services/abstractions/dynamic_link.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'business_list.dart';
import 'custom_widgets.dart';
import 'package:flipper_models/business.dart';

class FlipperDrawer extends StatelessWidget {
  FlipperDrawer({Key? key, required this.businesses}) : super(key: key);
  final List<Business> businesses;
  final DynamicLink _link = locator<DynamicLink>();

  ListTile _menuListRowButton(String title,
      {Function? onPressed,
      int? icon,
      bool isEnable = false,
      required BuildContext context}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 5),
              child: customIcon(
                context,
                icon: icon,
                size: 25,
                iconColor: isEnable
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context)
                        .copyWith(canvasColor: Colors.grey)
                        .canvasColor,
              ),
            ),
      title: customText(
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
          Row(
            children: [
              Text('Swith to Social?'),
              Switch.adaptive(
                value: drawerViewmodel.isSwitched,
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
                onChanged: (newValue) {
                  drawerViewmodel.setisSwitched();
                },
              ),
            ],
          ),
          _menuListRowButton('Close a day',
              isEnable: true, context: context, icon: 0xf155, onPressed: () {
            //TODOfinish the feature soon.
            // ProxyService.nav.navigateTo(
            //   Routing.openCloseDrawerview,
            //   arguments: OpenCloseDrawerViewArguments(
            //     wording: 'Closing Float',
            //     businessState: BusinessState.CLOSE,
            //   ),
            // );
          }),
          const Divider(height: 0),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
                height: 45,
              ),
              FutureBuilder(
                future: _link.createDynamicLink(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final ShortDynamicLink uri =
                        snapshot.data as ShortDynamicLink;
                    return GestureDetector(
                      onTap: () {
                        // print(uri.shortUrl.toString());
                        ProxyService.share.share(uri.shortUrl.toString());
                      },
                      child: customIcon(context,
                          icon: 0xf066,
                          istwitterIcon: true,
                          size: 25,
                          iconColor: Theme.of(context).accentColor),
                    );
                  } else {
                    return customIcon(context,
                        icon: 0xf066,
                        istwitterIcon: true,
                        size: 25,
                        iconColor: Theme.of(context).accentColor);
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

  void _navigateTo(String path) {
    // ProxyService.nav.navigateTo(path);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
      viewModelBuilder: () => DrawerViewModel(),
      onModelReady: (model) {
        // model.getBusiness();
        // model.getBranches();
      },
      builder: (context, model, child) => Container(
        child: Drawer(
          elevation: 0,
          child: Container(
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BusinessList(
                  businesses: businesses,
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: <Widget>[
                            // Future feature.
                            // _menuListRowButton('Profile',
                            //     icon: AppIcon.profile,
                            //     context: context,
                            //     isEnable: true, onPressed: () {
                            //   _navigateTo('ProfilePage');
                            // }),
                            // _menuListRowButton('Lists',
                            //     context: context,
                            //     icon: AppIcon.lists, onPressed: () {
                            //   //_navigateTo(Routing.allItemScreen);
                            // }),
                            // _menuListRowButton('Reports',
                            //     context: context,
                            //     icon: AppIcon.bookmark, onPressed: () {
                            //   _navigateTo(Routing.salesView);
                            // }),
                            // _menuListRowButton('Items',
                            //     context: context,
                            //     icon: AppIcon.lists, onPressed: () {
                            //   _navigationService.navigateTo(Routing.productView,
                            //       arguments: ProductViewArguments(
                            //           items: true,
                            //           sellingModeView: true,
                            //           userId: '1'));
                            // }),
                            // _menuListRowButton(
                            //   'Payroll',
                            //   context: context,
                            //   icon: AppIcon.moments,
                            //   onPressed: () {
                            //     _navigateTo(Routing.contactView);
                            //   },
                            // ),
                            // _menuListRowButton('Flipper deals',
                            //     context: context, icon: AppIcon.twitterAds),
                            // const Divider(),
                            // _menuListRowButton('Settings and privacy',
                            //     context: context,
                            //     isEnable: true, onPressed: () {
                            //   _navigateTo(Routing.settingsView);
                            // }),

                            const Divider(),
                            _menuListRowButton(
                              'Help Center',
                              context: context,
                            ),
                            const Divider(),
                            // _menuListRowButton('Logout',
                            //     context: context,
                            //     icon: null,
                            //     onPressed: _logOut,
                            //     isEnable: true),
                          ],
                        ),
                      ),
                      _footer(
                        drawerViewmodel: model,
                        context: context,
                      )
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
