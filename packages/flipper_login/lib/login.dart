import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_login/config.dart';
import 'package:flipper_rw/gate.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
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

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final log = getLogger('LoginView');

  Future<void> isNetAvailable() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // GoRouter.of(context).pushNamed('login');
      loginInfo.noNet = false;
    } else {
      loginInfo.noNet = true;
    }
  }

  @override
  void initState() {
    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();
    isNetAvailable();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        loginInfo.noNet = false;
      } else {
        loginInfo.noNet = true;
      }
    });
    super.initState();
  }

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
              ? const Scaffold(body: DesktopLoginView())
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
    if (ProxyService.remoteConfig.isGoogleLoginAvailable() &&
        ProxyService.remoteConfig.isFacebookLoginAvailable() &&
        ProxyService.remoteConfig.isTwitterLoginAvailable()) {
      return const [
        PhoneProviderConfiguration(),
        // EmailProviderConfiguration(),
        GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID),
        FacebookProviderConfiguration(clientId: FACEBOOK_CLIENT_ID),
        TwitterProviderConfiguration(
          apiKey: TWITTER_API_KEY,
          apiSecretKey: TWITTER_API_SECRET_KEY,
          redirectUri: TWITTER_REDIRECT_URI,
        ),
      ];
    } else if (ProxyService.remoteConfig.isGoogleLoginAvailable()) {
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
