import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'dart:ui' as ui;
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/all_routes.dart';
import 'package:realm/realm.dart';
import 'package:flipper_services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/scheduler.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flutter/foundation.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> isNetAvailable() async {
    if (!areDependenciesInitialized) {
      /// This is high likely that we were logged out and we need to re-init the dependencies
      await initDependencies();
    }
    if (!(await ProxyService.app.isLoggedIn())) {
      List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        LoginInfo().noNet = false;
      } else {
        LoginInfo().noNet = true;
      }
    }
  }

  Future<void> futures() async {
    if (!areDependenciesInitialized) {
      /// This is high likely that we were logged out and we need to re-init the dependencies
      await initDependencies();
    }
    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();
    if (!(await ProxyService.app.isLoggedIn())) {}
  }

  @override
  initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isNetAvailable();
    });
    futures();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // FlutterFireUIActions
    // context.dependOnInheritedWidgetOfExactType<FirebaseAuthAc>();

    super.didChangeDependencies();
  }

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = _getDeviceType(context);

    return ViewModelBuilder<LoginViewModel>.reactive(
      onViewModelReady: (model) async {
        /// on non-windows and when we are logging, we know for sure
        /// logout on firebase works as expected therefore no need to worry that this might re-login a user
        /// as a result of fail logout, but on windows we don't need this anyway
        /// this is only needed on windows because we sometime logout and when the app reaches here
        /// we find a user is not full logged out there we forbid the user to continue
        /// but on android a user might be on phone-otp screen and logged succeeded
        /// but for some reason or we need to listen for that event of login here for us to re-navigate to startup
        /// page to authorize the user to continue.
        if (!Platform.isWindows) {
          // final user = await firebase.FirebaseAuth.instance.currentUser;

          firebase.FirebaseAuth.instance
              .userChanges()
              .listen((firebase.User? user) async {
            if (user != null && !ProxyService.box.pinLogin()!) {
              final key = user.phoneNumber ?? user.email!;
              final response = await ProxyService.local.sendLoginRequest(
                  key, ProxyService.http, AppSecrets.apihubProd);
              final IUser iUser = IUser.fromJson(json.decode(response.body));

              /// pre-configure the system beore sending login request to

              talker.warning("iUser: ${iUser.id}");

              try {
                IPin? pin = await ProxyService.local.getPin(
                    pinString: iUser.id.toString(),
                    flipperHttpClient: ProxyService.http);
                final thePin = Pin(ObjectId(),
                    userId: int.parse(pin!.userId),
                    pin: pin.pin,
                    id: int.parse(pin.userId),
                    branchId: pin.branchId,
                    businessId: pin.businessId,
                    ownerName: pin.ownerName,
                    tokenUid: iUser.uid,
                    phoneNumber: iUser.phoneNumber);
                ProxyService.local.login(
                    userPhone: key,
                    skipDefaultAppSetup: false,
                    pin: thePin,
                    flipperHttpClient: ProxyService.http);

                model.completeLogin(thePin);
              } catch (e) {
                rethrow;
              }
            }
          });
        }
      },
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        final data = ui.PlatformDispatcher.instance.views.first;
        final ui.Size size = data.physicalSize;
        final double width = size.width / data.devicePixelRatio;

        // Define the threshold for differentiating between phone and desktop
        const double desktopWidthThreshold =
            768.0; // Standard desktop screen size threshold

        final bool isDesktop =
            deviceType != 'Phone' && width >= desktopWidthThreshold;

        return (isDesktop && !kIsWeb)
            ? Scaffold(
                body: DesktopLoginView(),
                backgroundColor: Colors.white,
              )
            : kIsWeb
                ? DesktopLoginView()
                // ? SignInScreen(
                //     showAuthActionSwitch: false,
                //     sideBuilder: (context, constraints) {
                //       return Padding(
                //         padding: const EdgeInsets.all(20),
                //         child: AspectRatio(
                //           aspectRatio: 1,
                //           child: Image.asset(
                //               package: 'flipper_login', 'assets/logo.png'),
                //         ),
                //       );
                //     },
                //     providers: [EmailAuthProvider(), PhoneAuthProvider()],
                //     actions: [
                //       AuthStateChangeAction<SignedIn>((context, state) {
                //         if (!state.user!.emailVerified) {
                //           // Navigator.pushNamed(context, '/verify-email');
                //         } else {
                //           // Navigator.pushReplacementNamed(context, '/profile');
                //         }
                //       }),
                //     ],
                //   )
                : Scaffold(body: Landing());
      },
    );
  }
}
