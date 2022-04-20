import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterfire_ui/auth.dart';

import 'internal/provider_screen.dart';
import 'internal/responsive_page.dart';
import '../widgets/internal/universal_scaffold.dart';

class EmailLinkSignInScreen
    extends ProviderScreen<EmailLinkProviderConfiguration> {
  final List<FlutterFireUIAction>? actions;
  final HeaderBuilder? headerBuilder;
  final double? headerMaxExtent;
  final SideBuilder? sideBuilder;
  final TextDirection? desktoplayoutDirection;
  final double breakpoint;

  const EmailLinkSignInScreen({
    Key? key,
    FirebaseAuth? auth,
    this.actions,
    EmailLinkProviderConfiguration? config,
    this.headerBuilder,
    this.headerMaxExtent,
    this.sideBuilder,
    this.desktoplayoutDirection,
    this.breakpoint = 500,
  }) : super(key: key, auth: auth, config: config);

  @override
  Widget build(BuildContext context) {
    return FlutterFireUIActions(
      actions: actions ?? const [],
      child: UniversalScaffold(
        body: ResponsivePage(
          breakpoint: breakpoint,
          headerBuilder: headerBuilder,
          headerMaxExtent: headerMaxExtent,
          maxWidth: 1200,
          sideBuilder: sideBuilder,
          desktopLayoutDirection: desktoplayoutDirection,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: EmailLinkSignInView(
              auth: auth,
              config: config,
            ),
          ),
        ),
      ),
    );
  }
}
