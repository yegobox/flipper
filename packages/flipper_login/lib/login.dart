import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flipper_login/LoadingDialog.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/all_routes.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart' hide Category;

/// A stateful widget that handles user authentication and login flow
/// Supports multiple platforms (Web, Desktop, Mobile) with different UI layouts
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Checks network availability and updates LoginInfo accordingly
  /// This is called during widget initialization
  Future<void> checkNetworkAvailability() async {
    // await initDependencies();

    if (!(await ProxyService.app.isLoggedIn())) {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasInternet = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;

      LoginInfo().noNet = !hasInternet;
    }
  }

  /// Initializes required configurations and remote settings
  Future<void> initializeConfigurations() async {
    // await initDependencies();

    // Setup remote configurations
    final remoteConfig = ProxyService.remoteConfig;
    remoteConfig.config();
    remoteConfig.setDefault();
    remoteConfig.fetch();
  }

  @override
  void initState() {
    super.initState();

    // Check network availability after the first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkNetworkAvailability();
    });

    initializeConfigurations();
  }

  // Auth handling has been moved to AuthWithMultipleProviders.dart
  // This is kept as a stub for backward compatibility
  Future<void> handleAuthStateChanges(LoginViewModel model) async {
    // No-op - authentication is now handled in AuthWithMultipleProviders
    // We don't need to check for Platform.isWindows anymore since this is just a stub
  }

  /// Split-panel desktop login: based on this route's [MediaQuery], not platform views.
  ///
  /// Uses [MediaQuery.sizeOf] so resizable windows, embedded views, and multi-display
  /// match the actual layout context. [shortestSide] keeps compact login on phones
  /// (including landscape) while still allowing tablets and desktop windows.
  bool _useDesktopLoginLayout(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const minWidth = 768.0;
    if (size.shortestSide < 600) return false;
    return size.width >= minWidth;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.nonReactive(
      onViewModelReady: (model) => handleAuthStateChanges(model),
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        final isDesktop = _useDesktopLoginLayout(context);

        if (isDesktop && !kIsWeb) {
          return Scaffold(
            body: const DesktopLoginView(),
            backgroundColor: Colors.white,
          );
        }

        if (kIsWeb) {
          return _buildWebLoginScreen();
        }

        return Scaffold(body: Landing());
      },
    );
  }

  /// Builds the web-specific login screen with multiple authentication providers
  Widget _buildWebLoginScreen() {
    return SignInScreen(
      showAuthActionSwitch: true,
      sideBuilder: _buildWebLoginLogo,
      providers: [
        EmailAuthProvider(),
        PhoneAuthProvider(),
        GoogleProvider(clientId: 'YOUR_GOOGLE_CLIENT_ID'),
        AppleProvider()
      ],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          // Show loading dialog immediately for better UX
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const LoadingDialog(
                  message: 'Finalizing authentication...');
            },
          );

          // Pop back to Login widget where Firebase auth state changes will be detected
          // by the centralized handler in AuthWithMultipleProviders
          Navigator.of(context).pop();

          // Email verification handling if needed
          if (!state.user!.emailVerified) {
            // Handle email verification if needed
          }
        }),
      ],
    );
  }

  /// Builds the logo section for the web login screen
  Widget _buildWebLoginLogo(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          'assets/logo.png',
          package: 'flipper_login',
        ),
      ),
    );
  }
}
