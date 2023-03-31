import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_services/locator.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'config.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'decorations.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/scheduler.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with AutomaticKeepAliveClientMixin {
  final appService = locator<AppService>();

  Future<void> isNetAvailable() async {
    if (!appService.isLoggedIn()) {
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

  @override
  void initState() {
    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isNetAvailable();
    });
    if (!appService.isLoggedIn()) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) {
          // Got a new connectivity status!
          if (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) {
            LoginInfo().noNet = false;
            GoRouter.of(context).refresh();
          } else {
            LoginInfo().noNet = true;
            GoRouter.of(context).refresh();
          }
        });
      });
    }
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
        FirebaseAuth.instance.userChanges().listen((event) {
          if (event != null) {
            model.runStartupLogic(invokeLogin: true);
          }
        });
      },
      viewModelBuilder: () => StartupViewModel(context: context),
      builder: (context, model, child) {
        return Scaffold(
          key: Key("login-page"),
          body: Theme(
            data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: SignInScreen(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  //do nothing to avoid bug.
                }),
              ],
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
              providers: providers(),
            ),
          ),
        );
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
