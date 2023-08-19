import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/all_routes.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:stacked/stacked.dart';
import 'config.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/scheduler.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with AutomaticKeepAliveClientMixin {
  final appService = loc.locator<AppService>();
  final _routerService = locator<RouterService>();
  bool _isLogin = false;
  Future<void> isNetAvailable() async {
    if (!(await appService.isLoggedIn())) {
      ConnectivityResult connectivityResult =
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
    if (!(await appService.isLoggedIn())) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) {
          if (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) {
            // _routerService.navigateTo(LoginViewRoute());
          } else {
            // TODO: show a notification istead of going to NoNetRoute page
            // _routerService.navigateTo(NoNetRoute());
          }
        });
      });
    }
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
    super.build(context);
    return ViewModelBuilder<StartupViewModel>.reactive(
      onViewModelReady: (model) {
        FirebaseAuth.instance.userChanges().listen((User? user) {
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
        return isDesktopOrWeb
            ? Scaffold(body: DesktopLoginView())
            : Scaffold(body: Landing());
      },
    );
  }

  List<AuthProvider> providers() {
    if (ProxyService.remoteConfig.isGoogleLoginAvailable() &&
        ProxyService.remoteConfig.isFacebookLoginAvailable() &&
        ProxyService.remoteConfig.isTwitterLoginAvailable()) {
      return [
        PhoneAuthProvider(),
        //add otherProviders
      ];
    } else if (ProxyService.remoteConfig.isGoogleLoginAvailable()) {
      return [
        PhoneAuthProvider(),
        // EmailProviderConfiguration(),
        GoogleProvider(clientId: GOOGLE_CLIENT_ID),
      ];
    } else {
      return [
        PhoneAuthProvider(),
        // EmailProviderConfiguration(),
        // GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID),
      ];
    }
  }

  @override
  // https://github.com/memspace/zefyr/issues/341#issuecomment-663965567
  bool get wantKeepAlive => true;
}
