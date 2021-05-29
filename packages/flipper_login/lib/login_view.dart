library flipper_login;

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'mobile.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: UniversalPlatform.isWeb ||
              UniversalPlatform.isWindows ||
              UniversalPlatform.isMacOS
          ? SingleChildScrollView(child: MobileLogin())
          : SingleChildScrollView(child: MobileLogin()),
    );
  }
}
