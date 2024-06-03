import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'dart:ui' as ui;
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/all_routes.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:stacked/stacked.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/scheduler.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:device_type/device_type.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appService = loc.getIt<AppService>();
  final _routerService = locator<RouterService>();
  bool _isLogin = false;
  Future<void> isNetAvailable() async {
    if (!(await appService.isLoggedIn())) {
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
    if (!(await appService.isLoggedIn())) {}
  }

  @override
  initState() {
    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();
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

    return ViewModelBuilder<StartupViewModel>.reactive(
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
          firebase.FirebaseAuth.instance
              .userChanges()
              .listen((firebase.User? user) {
            if (user != null) {
              if (_isLogin == false) {
                setState(() {
                  _isLogin = true;
                });

                _routerService
                    .clearStackAndShow(StartUpViewRoute(invokeLogin: true));
              }
            }
          });
        }
      },
      viewModelBuilder: () => StartupViewModel(),
      builder: (context, model, child) {
        final data = ui.PlatformDispatcher.instance.views.first;
        final ui.Size size = data.physicalSize;
        final double width = size.width / data.devicePixelRatio;

        // Define the threshold for differentiating between phone and desktop
        const double desktopWidthThreshold =
            768.0; // Standard desktop screen size threshold

        final bool isDesktop =
            deviceType != 'Phone' && width >= desktopWidthThreshold;

        return (isDesktop)
            ? Scaffold(
                body: DesktopLoginView(),
                backgroundColor: Colors.white,
              )
            : Scaffold(body: Landing());
      },
    );
  }
}
