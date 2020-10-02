import 'package:flipper/helper/constant.dart';
import 'package:flipper/helper/theme.dart';
import 'package:flipper/home/widget/custom_widgets.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/app_colors.dart';
import 'package:flutter/material.dart';

import 'business_list/business_list.dart';

enum DrawerState { CALENDAR, CHANNEL }

class FlipperDrawer extends StatefulWidget {
  const FlipperDrawer({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;
  @override
  _FlipperDrawerState createState() => _FlipperDrawerState();
}

class _FlipperDrawerState extends State<FlipperDrawer> {

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
                iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
              ),
            ),
      title: customText(
        title,
        style: TextStyle(
          fontSize: 20,
          color: isEnable ? AppColor.secondary : AppColor.lightGrey,
        ),
      ),
    );
  }

  Positioned _footer() {
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
                  iconColor: TwitterColor.dodgetBlue),
              const Spacer(),
              Image.asset(
                'assets/images/qr.png',
                height: 25,
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

  void _logOut() {
    // Navigator.pop(context);
    // state.logoutCallback();
  }

  void _navigateTo(String path) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/$path');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  children:<Widget> [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 45),
                      child: Column(
                        // physics: const BouncingScrollPhysics(),
                        children: [
                          const Divider(),
                          _menuListRowButton('Profile',
                              icon: AppIcon.profile,
                              isEnable: true, onPressed: () {
                            _navigateTo('ProfilePage');
                          }),
                          _menuListRowButton('Lists', icon: AppIcon.lists),
                          _menuListRowButton('Bookmark',
                              icon: AppIcon.bookmark),
                          _menuListRowButton('Moments', icon: AppIcon.moments),
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
                     _footer()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
