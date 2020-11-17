import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/ui/widget/custom_widgets.dart';
import 'package:flipper/services/proxy.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';

import 'package:flipper/utils/app_colors.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/viewmodels/drawer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'business/business_list.dart';

class FlipperDrawer extends StatefulWidget {
  const FlipperDrawer({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;
  @override
  _FlipperDrawerState createState() => _FlipperDrawerState();
}


class _FlipperDrawerState extends State<FlipperDrawer> {
  final FlipperNavigationService _navigationService = ProxyService.nav;

  ListTile _menuListRowButton(String title,
      {Function onPressed, int icon, bool isEnable = false}) {
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
                    : Colors
                        .grey, // TODO(richard): should come from Theme as it is a single source
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

  Positioned _footer({DrawerViewModel drawerViewmodel}) {
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

  void _logOut() {}

  void _navigateTo(String path) {
    _navigationService.navigateTo(path);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
      viewModelBuilder: () => DrawerViewModel(),
      builder: (BuildContext context, DrawerViewModel model, Widget child) =>
          Container(
        child: Drawer(
          elevation: 0,
          child: Container(
            color: AppColors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BusinessList(
                  vm: widget.vm,
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: <Widget>[
                            _menuListRowButton('Profile',
                                icon: AppIcon.profile,
                                isEnable: true, onPressed: () {
                              _navigateTo('ProfilePage');
                            }),
                            _menuListRowButton('Lists', icon: AppIcon.lists,
                                onPressed: () {
                              //_navigateTo(Routing.allItemScreen);
                            }),
                            _menuListRowButton('Reports',
                                icon: AppIcon.bookmark, onPressed: () {
                              _navigateTo(Routing.salesView);
                            }),
                            _menuListRowButton(
                              'Payroll',
                              icon: AppIcon.moments,
                              onPressed: () {
                                _navigateTo(Routing.contactView);
                              },
                            ),
                            _menuListRowButton('Flipper deals',
                                icon: AppIcon.twitterAds),
                            const Divider(),
                            _menuListRowButton('Settings and privacy',
                                isEnable: true, onPressed: () {
                              _navigateTo('SettingsAndPrivacyPage');
                            }),
                            _menuListRowButton('Help Center'),
                            const Divider(),
                            _menuListRowButton('Logout',
                                icon: null, onPressed: _logOut, isEnable: true),
                          ],
                        ),
                      ),
                      _footer(drawerViewmodel: model)
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
