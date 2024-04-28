import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'dart:ui' as ui;
import 'package:flipper_models/isar_models.dart';
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      onViewModelReady: (model) {
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
      },
      viewModelBuilder: () => StartupViewModel(),
      builder: (context, model, child) {
        // Get the physical size and device pixel ratio using PlatformDispatcher
        final data = PlatformDispatcher.instance.views.first;
        ui.Size size = data.physicalSize;
        double width = size.width;
        // I am using https://www.altamira.ai/blog/common-screen-sizes-for-responsive-web-design/ as my standard for screen sizes
        return (width >= 1280)
            ? Scaffold(
                body: DesktopLoginView(),
                backgroundColor: Colors.white,
              )
            : Scaffold(body: Landing());
      },
    );
  }
}
