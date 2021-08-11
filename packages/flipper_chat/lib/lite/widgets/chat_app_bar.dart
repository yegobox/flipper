import 'package:flipper_chat/lite/helpers.dart';
import 'package:flipper_chat/lite/widgets/button_circle.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';

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
    return AppBar(
      /// the scan widget will be used to order food in a restaurant,
      /// make appointment, or check in/out.
      title: CircleAvatar(
        child: Icon(
          Icons.center_focus_weak,
          color: primary,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        ButtonCircle(
          iconColor: primary,
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
