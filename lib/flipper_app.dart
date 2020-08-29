import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/couchbase.dart';
import 'package:flipper/generated/i18n.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'data/respositories/branch_repository.dart';
import 'data/respositories/business_repository.dart';
import 'data/respositories/general_repository.dart';
import 'data/respositories/user_repository.dart';
import 'domain/redux/app_actions/app_action_middleware.dart';
import 'domain/redux/app_reducer.dart';
import 'domain/redux/app_state.dart';
import 'domain/redux/authentication/auth_actions.dart';
import 'domain/redux/authentication/auth_middleware.dart';
import 'domain/redux/branch/branch_middleware.dart';
import 'domain/redux/business/business_actions.dart';
import 'domain/redux/business/business_middleware.dart';
import 'domain/redux/permission/permission_middleware.dart';
import 'domain/redux/push/push_actions.dart';
import 'domain/redux/push/push_middleware.dart';
import 'domain/redux/user/user_middleware.dart';
import 'home/selling/selling_middleware.dart';


class FlipperApp extends StatefulWidget {
  FlipperApp({Key key}) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  Store<AppState> store;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  final UserRepository userRepo = UserRepository();
  final BusinessRepository businessRepo = BusinessRepository();
  final BranchRepository branchRepo = BranchRepository();
  final GeneralRepository generalRepo = GeneralRepository();
  final AppDatabase instance = AppDatabase.instance;
  @override
  void initState() {
    super.initState();
    instance.login();
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
        ..addAll(
          createPushMiddleware(
            userRepo,
            _firebaseMessaging,
          ),
        ),
    );
    store.dispatch(
      VerifyAuthenticationState(),
    );
    store.dispatch(
      ShouldLoadBusiness(),
    );
    // _firebaseMessaging.configure(onBackgroundMessage: backgroundMessageHandler);
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
    
    // ignore: always_specify_types
    return StoreProvider(
      store: store,
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        debugShowCheckedModeBanner: false,
        // ignore: prefer_const_literals_to_create_immutables, always_specify_types
        localizationsDelegates: [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Flipper',
        // theme: buildLightThemeData(mainTextStyle, headerTextStyle),
        // darkTheme: buildDarkThemeData(mainTextStyle, headerTextStyle),
        navigatorKey: Routing.navigator.key,
        initialRoute: Routing.afterSplash,
        onGenerateRoute: Routing.onGenerateRoute,
      ),
    );
  }

  ThemeData buildLightThemeData(
      TextStyle mainTextStyle, TextStyle headerTextStyle) {
    return ThemeData(
      primarySwatch: Colors.deepOrange,
      toggleableActiveColor: Colors.deepOrangeAccent,
      accentColor: Colors.deepOrangeAccent,
      cursorColor: Colors.deepOrangeAccent,
      textSelectionColor: Colors.orangeAccent[100],
      textSelectionHandleColor: Colors.deepOrangeAccent,
      brightness: Brightness.light,
      popupMenuTheme: PopupMenuThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      cardTheme: CardTheme(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      textTheme: TextTheme(
        headline1: mainTextStyle,
        headline2: mainTextStyle,
        headline3: mainTextStyle,
        headline4: headerTextStyle.copyWith(
            color: Colors.deepOrangeAccent, fontSize: 18),
        headline5: headerTextStyle.copyWith(fontSize: 24),
        headline6: mainTextStyle,
        subtitle1: mainTextStyle,
        subtitle2: mainTextStyle,
        bodyText1: mainTextStyle,
        bodyText2: mainTextStyle,
        button: mainTextStyle,
        caption: mainTextStyle,
        overline: mainTextStyle,
      ),
    );
  }

  ThemeData buildDarkThemeData(
      TextStyle mainTextStyle, TextStyle headerTextStyle) {
    return ThemeData(
      primarySwatch: Colors.orange,
      toggleableActiveColor: Colors.orangeAccent,
      accentColor: Colors.orangeAccent,
      cursorColor: Colors.orangeAccent,
      textSelectionColor: Colors.deepOrangeAccent,
      textSelectionHandleColor: Colors.orangeAccent,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF272727),
      canvasColor: const Color(0xFF323232),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF323232),
        contentTextStyle: TextStyle(color: Colors.white),
        actionTextColor: Colors.orangeAccent,
      ),
      popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xFF323232),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      dialogTheme: DialogTheme(
          backgroundColor: const Color(0xFF323232),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      textTheme: TextTheme(
        headline1: mainTextStyle,
        headline2: mainTextStyle,
        headline3: mainTextStyle,
        headline4:
            headerTextStyle.copyWith(color: Colors.orangeAccent, fontSize: 18),
        headline5: headerTextStyle.copyWith(fontSize: 24),
        headline6: mainTextStyle,
        subtitle1: mainTextStyle,
        subtitle2: mainTextStyle,
        bodyText1: mainTextStyle,
        bodyText2: mainTextStyle,
        button: mainTextStyle,
        caption: mainTextStyle,
        overline: mainTextStyle,
      ),
    );
  }
}
