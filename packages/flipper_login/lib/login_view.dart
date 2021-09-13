library flipper_login;

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'desktop_login_view.dart';
import 'mobile.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: UniversalPlatform.isWeb ||
              UniversalPlatform.isWindows ||
              UniversalPlatform.isMacOS
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: DesktopLoginView())
          : SingleChildScrollView(child: MobileLogin()),
    );
  }
}
