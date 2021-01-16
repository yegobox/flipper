import 'package:awesome_notifications/awesome_notifications.dart'
    hide DateUtils;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/generated/i18n.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_services/analytics_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';

import 'domain/redux/app_actions/app_action_middleware.dart';
import 'domain/redux/app_reducer.dart';
import 'domain/redux/app_state.dart';
import 'domain/redux/authentication/auth_actions.dart';
import 'domain/redux/authentication/auth_middleware.dart';
import 'domain/redux/business/business_actions.dart';
import 'domain/redux/permission/permission_middleware.dart';
import 'domain/redux/push/push_actions.dart';
import 'domain/redux/push/push_middleware.dart';
import 'domain/redux/user/user_middleware.dart';
import 'lifecycle_manager.dart';

class FlipperApp extends StatefulWidget {
  const FlipperApp({Key key}) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  final Logger log = Logging.getLogger('Firestore service ....');
  final _state = locator<SharedStateService>();

  Store<AppState> store;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> showLargeIconNotification(int id, String message) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'big_picture',
            title: 'Hello!',
            body: '$message',
            largeIcon:
                'https://image.freepik.com/vetores-gratis/modelo-de-logotipo-de-restaurante-retro_23-2148451519.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'uuid': 'uuid-test'}));
  }

  Future<void> initFCM() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    _state.didLogout.listen((loggedOut) {
      if (loggedOut) {
        StoreProvider.of<AppState>(context).dispatch(
          VerifyAuthenticationState(),
        );
      }
    });

    store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: createAuthenticationMiddleware(_navigatorKey)
        ..addAll(permissionMiddleware(_navigatorKey))
        ..addAll(AppActionMiddleware(_navigatorKey))
        ..addAll(userMiddleware(_navigatorKey))
        ..addAll(
          createPushMiddleware(
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
    // FIXME: when working on background message then see the fix of crash here https://github.com/Stone2517/Truact-1/blob/master/android/app/src/main/java/com/exanite/truact/Application.java and discussion here: https://github.com/FirebaseExtended/flutterfire/issues/2777

    initFCM();
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      if (token != null) {
        log.i('Push Messaging token: $token');
        ProxyService.sharedPref.setToken(token: token);
        store.dispatch(UpdateUserTokenAction(token, store));
      }
    });
    _firebaseMessaging.subscribeToTopic('all');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');
      if (message.notification != null) {
        showLargeIconNotification(2, message.notification.body);
      }
    });
    // ignore: always_specify_types
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     store.dispatch(OnPushNotificationReceivedAction(message));
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     store.dispatch(OnPushNotificationOpenAction(message));
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     store.dispatch(OnPushNotificationOpenAction(message));
    //   },
    // );
    // ignore: always_specify_types
    return LifeCycleManager(
      // ignore: always_specify_types
      child: StoreProvider(
        store: store,
        child: MaterialApp(
          // builder: (BuildContext context, Widget child) => Navigator(
          //   key: locator<DialogService>.dialogNavigationKey,
          //   // ignore: always_specify_types
          //   onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
          //       builder: (BuildContext context) => DialogManager(child: child)),
          // ),
          navigatorObservers: <NavigatorObserver>[
            locator<AnalyticsService>().getAnalyticsObserver()
          ],
          debugShowCheckedModeBanner: false,
          // ignore: prefer_const_literals_to_create_immutables, always_specify_types
          localizationsDelegates: [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Flipper',
          navigatorKey: locator<FlipperNavigationService>()
              .navigationKey, //slowly use mvm stacked architecture
          theme: appTheme(),
          initialRoute: Routing.splashScreen,
          onGenerateRoute: Routing.onGenerateRoute,
        ),
      ),
    );
  }

  @override
  // ignore: avoid_void_async
  void dispose() async {
    super.dispose();
  }
}

// enable analytics on debuging device
// adb shell setprop debug.firebase.analytics.app rw.flipper
