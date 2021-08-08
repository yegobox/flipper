import 'package:flipper_chat/lite/helpers.dart';
import 'package:flipper_chat/lite/widgets/button_circle.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';

class AppBarW extends StatelessWidget implements PreferredSizeWidget {
  const AppBarW(this.title, {Key? key, this.btnBack = true})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String title;
  final bool btnBack;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Flipper',
        style: TextStyle(
            color: Helpers.greenColor,
            fontFamily: 'Konnect',
            fontWeight: FontWeight.bold,
            fontSize: 25),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        ButtonCircle(
          onPressed: () {},
          icon: CupertinoIcons.moon_fill,
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
  }
}
