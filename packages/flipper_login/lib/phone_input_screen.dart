import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

import 'universal_button.dart' as uni;
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, MultiFactorSession, PhoneMultiFactorInfo;
import 'package:flutter/widgets.dart';

import 'phone_input_view.dart' as view;

import 'internal/responsive_page.dart' as b;
import 'widgets/internal/universal_page_route.dart';
import 'widgets/internal/universal_scaffold.dart';

/// A screen displaying a fully styled phone number entry screen, with a country-code
/// picker.
///
/// {@subCategory service:auth}
/// {@subCategory type:screen}
/// {@subCategory description:A screen displaying a fully styled phone number entry input with a country-code picker.}
/// {@subCategory img:https://place-hold.it/400x150}

/// A screen displaying a fully styled phone number entry screen, with a country-code
/// picker.

/// A screen displaying a fully styled phone number entry screen, with a country-code
/// picker.
class PhoneInputScreen extends StatelessWidget {
  /// {@macro ui.auth.auth_action}
  final AuthAction? action;

  final String countryCode;

  final List<FirebaseUIAction>? actions;

  /// {@macro ui.auth.auth_controller.auth}
  final FirebaseAuth? auth;

  /// A returned widget would be placed under the title of the screen.
  final WidgetBuilder? subtitleBuilder;

  /// A returned widget would be placed at the bottom.
  final WidgetBuilder? footerBuilder;

  /// {@macro ui.auth.screens.responsive_page.header_builder}
  final HeaderBuilder? headerBuilder;

  /// {@macro ui.auth.screens.responsive_page.header_max_extent}
  final double? headerMaxExtent;

  /// {@macro ui.auth.screens.responsive_page.side_builder}
  final SideBuilder? sideBuilder;

  /// {@macro ui.auth.screens.responsive_page.desktop_layout_direction}
  final TextDirection? desktopLayoutDirection;

  /// {@macro ui.auth.screens.responsive_page.breakpoint}
  final double breakpoint;

  /// {@macro ui.auth.providers.phone_auth_provider.mfa_session}
  final MultiFactorSession? multiFactorSession;

  /// {@macro ui.auth.providers.phone_auth_provider.mfa_hint}
  final PhoneMultiFactorInfo? mfaHint;

  const PhoneInputScreen({
    super.key,
    this.action,
    this.actions,
    this.auth,
    required this.countryCode,
    this.subtitleBuilder,
    this.footerBuilder,
    this.headerBuilder,
    this.headerMaxExtent,
    this.sideBuilder,
    this.desktopLayoutDirection,
    this.breakpoint = 500,
    this.multiFactorSession,
    this.mfaHint,
  });

  void _next(BuildContext context, AuthAction? action, Object flowKey, _) {
    Navigator.of(context).push(
      createPageRoute(
        context: context,
        builder: (_) => FirebaseUIActions.inherit(
          from: context,
          child: SMSCodeInputScreen(
            action: action,
            flowKey: flowKey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flowKey = Object();
    final l = FirebaseUILocalizations.labelsOf(context);

    return FirebaseUIActions(
      actions: actions ?? [SMSCodeRequestedAction(_next)],
      child: UniversalScaffold(
        body: b.ResponsivePage(
          desktopLayoutDirection: desktopLayoutDirection,
          sideBuilder: sideBuilder,
          headerBuilder: headerBuilder,
          headerMaxExtent: headerMaxExtent,
          breakpoint: breakpoint,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                view.PhoneInputView(
                  auth: auth,
                  action: action,
                  pickedCountryCode: countryCode,
                  subtitleBuilder: subtitleBuilder,
                  footerBuilder: footerBuilder,
                  flowKey: flowKey,
                  multiFactorSession: multiFactorSession,
                  mfaHint: mfaHint,
                ),
                const SizedBox(height: 8),
                uni.UniversalButton(
                  text: l.goBackButtonLabel,
                  variant: ButtonVariant.text,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
