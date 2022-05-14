import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterfire_ui/auth.dart';

import '../widgets/internal/universal_scaffold.dart';
import 'internal/responsive_page.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final FirebaseAuth? auth;
  final WidgetBuilder? subtitleBuilder;
  final WidgetBuilder? footerBuilder;
  final String? email;
  final HeaderBuilder? headerBuilder;
  final double? headerMaxExtent;
  final SideBuilder? sideBuilder;
  final TextDirection? desktopLayoutDirection;
  final bool? resizeToAvoidBottomInset;
  final double breakpoint;
  final Set<FlutterFireUIStyle>? styles;

  const ForgotPasswordScreen({
    Key? key,
    this.auth,
    this.email,
    this.subtitleBuilder,
    this.footerBuilder,
    this.headerBuilder,
    this.headerMaxExtent,
    this.sideBuilder,
    this.desktopLayoutDirection,
    this.resizeToAvoidBottomInset,
    this.breakpoint = 600,
    this.styles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = ForgotPasswordView(
      auth: auth,
      email: email,
      footerBuilder: footerBuilder,
      subtitleBuilder: subtitleBuilder,
    );

    return FlutterFireUITheme(
      styles: styles ?? const {},
      child: UniversalScaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: ResponsivePage(
          desktopLayoutDirection: desktopLayoutDirection,
          headerBuilder: headerBuilder,
          headerMaxExtent: headerMaxExtent,
          sideBuilder: sideBuilder,
          breakpoint: breakpoint,
          maxWidth: 1200,
          contentFlex: 1,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: child,
          ),
        ),
      ),
    );
  }
}
