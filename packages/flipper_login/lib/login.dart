import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'dart:ui' as ui;
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_routing/all_routes.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/scheduler.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';

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
    if (!areDependenciesInitialized) {
      await initDependencies();
    }

    if (!(await ProxyService.app.isLoggedIn())) {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasInternet = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;

      LoginInfo().noNet = !hasInternet;
    }
  }

  /// Initializes required configurations and remote settings
  Future<void> initializeConfigurations() async {
    if (!areDependenciesInitialized) {
      await initDependencies();
    }

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

  /// Handles user authentication state changes and login flow
  /// This is only needed for non-Windows platforms
  Future<void> handleAuthStateChanges(LoginViewModel model) async {
    if (Platform.isWindows) return;

    firebase.FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) return;

      final bool shouldProcessLogin = !await ProxyService.box.pinLogin()! &&
          !await ProxyService.box.authComplete();

      if (!shouldProcessLogin) return;

      try {
        final userPin = await _processUserLogin(user);
        await _completeLoginProcess(userPin, model);
      } catch (e, s) {
        _handleLoginError(e, s);
      }
    });
  }

  /// Process user login and retrieve PIN information
  Future<Pin> _processUserLogin(firebase.User user) async {
    final key = user.phoneNumber ?? user.email!;

    // Get user information
    final response = await ProxyService.strategy
        .sendLoginRequest(key, ProxyService.http, AppSecrets.apihubProd);
    final iUser = IUser.fromJson(json.decode(response.body));

    // Get PIN information
    final pin = await ProxyService.strategy.getPin(
        pinString: iUser.id.toString(), flipperHttpClient: ProxyService.http);

    return Pin(
        userId: int.parse(pin!.userId),
        pin: pin.pin,
        branchId: pin.branchId,
        businessId: pin.businessId,
        ownerName: pin.ownerName,
        tokenUid: iUser.uid,
        uid: user.uid,
        phoneNumber: iUser.phoneNumber);
  }

  /// Complete the login process with the retrieved PIN
  Future<void> _completeLoginProcess(Pin userPin, LoginViewModel model) async {
    await ProxyService.box
        .writeInt(key: "userId", value: int.parse(userPin.userId.toString()));

    await ProxyService.strategy.login(
        userPhone: userPin.phoneNumber!,
        skipDefaultAppSetup: false,
        pin: userPin,
        flipperHttpClient: ProxyService.http);

    await ProxyService.box.writeBool(key: 'authComplete', value: true);
    model.completeLogin(userPin);
  }

  /// Handle login-related errors
  void _handleLoginError(Object e, StackTrace s) {
    talker.error(e, s);

    if (e is NeedSignUpException || e is BusinessNotFoundException) {
      locator<RouterService>().navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
    } else if (e is NoPaymentPlanFound) {
      locator<RouterService>().navigateTo(PaymentPlanUIRoute());
      return;
    }
    throw e;
  }

  /// Determines if the current device is a desktop based on screen width
  bool _isDesktopPlatform(BuildContext context, String deviceType) {
    final data = ui.PlatformDispatcher.instance.views.first;
    final width = data.physicalSize.width / data.devicePixelRatio;
    const desktopWidthThreshold = 768.0;

    return deviceType != 'Phone' && width >= desktopWidthThreshold;
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceType.getDeviceType(context);

    return ViewModelBuilder<LoginViewModel>.reactive(
      onViewModelReady: (model) => handleAuthStateChanges(model),
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        final isDesktop = _isDesktopPlatform(context, deviceType);

        if (isDesktop && !kIsWeb) {
          return Scaffold(
            body: DesktopLoginView(),
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
