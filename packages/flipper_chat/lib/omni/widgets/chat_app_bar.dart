import 'package:flipper_chat/omni/helpers.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flipper_dashboard/flipper_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar(this.title, {Key? key, this.btnBack = true})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String title;
  final bool btnBack;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return AppBar(
          /// the scan widget will be used to order food in a restaurant,
          /// make appointment, or check in/out.
          title: InkWell(
            onTap: () {
              ProxyService.nav.navigateTo(
                Routes.qrview,
                arguments: ScannViewArguments(intent: 'attendance'),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.center_focus_weak,
                color: primary,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            GestureDetector(
              onTap: () {
                getThemeManager(context).toggleDarkLightTheme();
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  CupertinoIcons.moon_fill,
                  color: primary,
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                ProxyService.nav.navigateTo(Routes.contacts);
              },
              icon: Icon(
                Icons.edit,
                color: primary,
              ),
            )

            // ButtonCircle(
            //   onPressed: () {},
            //   icon: CupertinoIcons.search,
            // ),
            // ButtonCircle(
            //   onPressed: () {},
            //   icon: Icons.more_horiz,
            // ),
          ],
          automaticallyImplyLeading: false,
          leading: btnBack
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Helpers.principalColor,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context))
              : null,
        );
      },
    );
  }
}
