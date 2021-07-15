import 'package:chat/flat_widgets/flat_info_page_wrapper.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';

class AboutChatMiniApp extends StatefulWidget {
  static final String id = "Aboutpage";

  @override
  _AboutChatMiniAppState createState() => _AboutChatMiniAppState();
}

class _AboutChatMiniAppState extends State<AboutChatMiniApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FlatInfoPageWrapper(
        heading: "About Flipper social",
        subHeading: "Because we like fun!",
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Flipper social is built interely on top of flipper business so you can manage your business in style!",
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).primaryColorDark.withOpacity(0.54),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        footer: Container(
            margin: EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: BoxButton.outline(
              title: 'Continue to Flipper Social',
              onTap: () {
                ProxyService.nav.navigateTo(Routes.chatHome);
              },
            )),
      ),
    );
  }
}
