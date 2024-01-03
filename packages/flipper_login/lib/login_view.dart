library flipper_login;

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'desktop_login_view.dart';
import 'mobile_login_view.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: UniversalPlatform.isAndroid
          ? SingleChildScrollView(child: MobileLoginView())
          : SingleChildScrollView(child: DesktopLoginView()),
    );
  }
}
