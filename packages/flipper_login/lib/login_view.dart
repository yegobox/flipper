library flipper_login;

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'desktop_login_view.dart';
import 'mobile.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: UniversalPlatform.isWeb ||
              UniversalPlatform.isAndroid ||
              UniversalPlatform.isMacOS
          ? SingleChildScrollView(child: MobileLogin())
          : SingleChildScrollView(child: DesktopLoginView()),
    );
  }
}
