library flipper_login;

import 'package:flipper_login/web.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mobile.dart';

class LoginView extends StatelessWidget {
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
