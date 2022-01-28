import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_login/config.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'decorations.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:universal_platform/universal_platform.dart';
import 'desktop_login_view.dart';

final isWindows = UniversalPlatform.isWindows;
final isWeb = UniversalPlatform.isWeb;

// Overrides a label for en locale
// To add localization for a custom language follow the guide here:
// https://flutter.dev/docs/development/accessibility-and-localization/internationalization#an-alternative-class-for-the-apps-localized-resources
class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Enter your email';
}

final emailLinkProviderConfig = EmailLinkProviderConfiguration(
  actionCodeSettings: ActionCodeSettings(
    url: 'https://reactnativefirebase.page.link',
    handleCodeInApp: true,
    androidMinimumVersion: '12',
    androidPackageName:
        'io.flutter.plugins.flutterfire_ui.flutterfire_ui_example',
    iOSBundleId: 'io.flutter.plugins.flutterfireui.flutterfireUIExample',
  ),
);

final providerConfigs = [
  const EmailProviderConfiguration(),
  // emailLinkProviderConfig,
  const PhoneProviderConfiguration(),
  // const GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID),
  // const AppleProviderConfiguration(),
  // const FacebookProviderConfiguration(clientId: FACEBOOK_CLIENT_ID),
  // const TwitterProviderConfiguration(
  //   apiKey: TWITTER_API_KEY,
  //   apiSecretKey: TWITTER_API_SECRET_KEY,
  //   redirectUri: TWITTER_REDIRECT_URI,
  // ),
];

class LoginView extends StatelessWidget {
  final log = getLogger('LoginView');

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const StartUpView(
            invokeLogin: true,
          );
        } else {
          return isWindows
              ? const Scaffold(
                  body: SingleChildScrollView(child: DesktopLoginView()))
              : Scaffold(
                  body: Theme(
                    data: ThemeData(
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: SignInScreen(
                      headerBuilder: headerImage('assets/logo.png'),
                      sideBuilder: sideImage('assets/logo.png'),
                      subtitleBuilder: (context, action) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            action == AuthAction.signIn
                                ? 'Welcome to Flipper Please sign in to continue.'
                                : 'Welcome to Flipper Please create an account to continue',
                          ),
                        );
                      },
                      footerBuilder: (context, action) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              action == AuthAction.signIn
                                  ? 'By signing in, you agree to our terms and conditions.'
                                  : 'By registering, you agree to our terms and conditions.',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                      providerConfigs: providers(),
                    ),
                  ),
                );
        }
      },
    );
  }

  List<ProviderConfiguration> providers() {
    if (ProxyService.remoteConfig.isGoogleLoginAvailable()) {
      return const [
        PhoneProviderConfiguration(),
        // EmailProviderConfiguration(),
        GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID),
      ];
    } else {
      return const [
        PhoneProviderConfiguration(),
        // EmailProviderConfiguration(),
        // GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID),
      ];
    }
  }
}
