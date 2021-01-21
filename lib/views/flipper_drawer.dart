import 'package:flipper_services/flipperNavigation_service.dart';

import 'package:flipper/utils/app_colors.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/viewmodels/drawer_viewmodel.dart';

import 'package:flipper/widget/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'business/business_list.dart';

class FlipperDrawer extends StatelessWidget {
  FlipperDrawer({Key key}) : super(key: key);

  final FlipperNavigationService _navigationService = ProxyService.nav;

  ListTile _menuListRowButton(String title,
      {Function onPressed,
      int icon,
      bool isEnable = false,
      BuildContext context}) {
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
      ),
    );
  }

  Positioned _footer({DrawerViewModel drawerViewmodel, BuildContext context}) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: <Widget>[
          const Divider(height: 0),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
                height: 45,
              ),
              customIcon(context,
                  icon: AppIcon.bulbOn,
                  istwitterIcon: true,
                  size: 25,
                  iconColor: Theme.of(context).accentColor),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  drawerViewmodel.loginWithQr(context: context);
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

  // void _navigateTo(String path) {
  //   _navigationService.navigateTo(path);
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.nonReactive(
      viewModelBuilder: () => DrawerViewModel(),
      onModelReady: (DrawerViewModel model) {
        model.getBusiness();
        model.getBranches();
      },
      builder: (BuildContext context, DrawerViewModel model, Widget child) =>
          Container(
        child: Drawer(
          elevation: 0,
          child: Container(
            color: AppColors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const BusinessList(),
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
