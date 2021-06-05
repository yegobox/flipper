import 'package:chat/flat_widgets/flat_info_page_wrapper.dart';
import 'package:chat/flat_widgets/flat_primary_button.dart';
import 'package:chat/screens/homepage.dart';
import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';

class KAboutpage extends StatefulWidget {
  static final String id = "Aboutpage";

  @override
  _KAboutpageState createState() => _KAboutpageState();
}

class _KAboutpageState extends State<KAboutpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: FlatPrimaryButton(
            onPressed: () {
              ProxyService.nav.navigateTo(Routes.chatHome);
            },
            prefixIcon: Icons.arrow_forward,
            textAlign: TextAlign.right,
            text: "Continue to Flipper Social",
          ),
        ),
      ),
    );
  }
}
