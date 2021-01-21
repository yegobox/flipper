import 'package:customappbar/customappbar.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/views/welcome/settings/privacy_settings_button.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          Routing.navigator.pop();
        },
        disableButton: false,
        title: 'Setting',
      ),
      body: ListView(
        children: <Widget>[
          PrivacySettingsButton(),
        ],
      ),
    );
  }
}
