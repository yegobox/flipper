library flipper_login;

import 'package:flutter/material.dart';
import 'desktop_login_view.dart';
import 'mobile.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: LayoutBuilder(
          // Wrap content with LayoutBuilder
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              // Consider a breakpoint for desktops
              return DesktopLoginView();
            } else {
              return MobileLogin();
            }
          },
        ),
      ),
    );
  }
}
