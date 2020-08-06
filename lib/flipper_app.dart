import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/data/respositories/branch_repository.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/app_action_middleware.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/business/business_middleware.dart';
import 'package:flipper/domain/redux/permission/permission_middleware.dart';
import 'package:flipper/domain/redux/user/user_middleware.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/selling/selling_middleware.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'data/respositories/business_repository.dart';
import 'data/respositories/user_repository.dart';
import 'domain/redux/app_reducer.dart';
import 'domain/redux/authentication/auth_actions.dart';
import 'domain/redux/authentication/auth_middleware.dart';
import 'domain/redux/branch/branch_middleware.dart';
import 'domain/redux/push/push_actions.dart';
import 'domain/redux/push/push_middleware.dart';

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
  throw 422;

}

class FlipperApp extends StatefulWidget {
  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  static FirebaseAnalytics analytics =  FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  Store<AppState> store;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final UserRepository userRepo = UserRepository();
  final BusinessRepository businessRepo = BusinessRepository();
  final BranchRepository branchRepo = BranchRepository();
  final GeneralRepository generalRepo = GeneralRepository();

  @override
  // ignore: avoid_void_async
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await store.state.couch.syncRemoteToLocal(store: store);
  }

  @override
  void initState() {
    super.initState();
    store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: createAuthenticationMiddleware(
          userRepo, businessRepo, branchRepo, generalRepo, _navigatorKey)
        ..addAll(createBusinessMiddleware(_navigatorKey, businessRepo))
        ..addAll(permissionMiddleware(_navigatorKey))
        ..addAll(sellMiddleware(_navigatorKey))
        ..addAll(AppActionMiddleware(_navigatorKey, generalRepo))
        ..addAll(userMiddleware(userRepo, _navigatorKey))
        ..addAll(createBranchMiddleware(_navigatorKey, branchRepo, generalRepo))
        ..addAll(createPushMiddleware(
          userRepo,
          _firebaseMessaging,
        )),
    );
    store.dispatch(
      VerifyAuthenticationState(),
    );
    store.dispatch(
      ShouldLoadBusiness(),
    );
    _firebaseMessaging.configure(
      onBackgroundMessage: backgroundMessageHandler
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      Logger.d('Settings registered: $settings');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      if (token != null) {
        Logger.d('Push Messaging token: $token');

        store.dispatch(UpdateUserTokenAction(token, store));
      }
    });
    _firebaseMessaging.subscribeToTopic('all');
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        store.dispatch(OnPushNotificationReceivedAction(message));
      },
      onLaunch: (Map<String, dynamic> message) async {
        store.dispatch(OnPushNotificationOpenAction(message));
      },
      onResume: (Map<String, dynamic> message) async {
        store.dispatch(OnPushNotificationOpenAction(message));
      },
    );
    return StoreProvider(
      store: store,
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        debugShowCheckedModeBanner: false,
        // ignore: prefer_const_literals_to_create_immutables, always_specify_types
        localizationsDelegates: [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Flipper',
        theme: AppTheme.theme,
        navigatorKey: Router.navigator.key,
        initialRoute: Router.splashScreen,
        onGenerateRoute: Router.onGenerateRoute,
      ),
    );
  }
}
