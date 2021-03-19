import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/generated/i18n.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_services/analytics_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/remote_config_service.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:redux/redux.dart';
import 'package:flipper_services/navigation_service.dart';

import 'domain/redux/app_actions/app_action_middleware.dart';
import 'domain/redux/app_reducer.dart';
import 'domain/redux/app_state.dart';
import 'domain/redux/authentication/auth_actions.dart';
import 'domain/redux/authentication/auth_middleware.dart';
import 'domain/redux/business/business_actions.dart';
// import 'domain/redux/permission/permission_middleware.dart';
import 'domain/redux/push/push_middleware.dart';
import 'domain/redux/user/user_middleware.dart';
import 'lifecycle_manager.dart';

class FlipperApp extends StatefulWidget {
  const FlipperApp({Key key}) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  final Logger log = Logging.getLogger('Flipper Application');
  final _state = locator<SharedStateService>();
  final _inAppNav = locator<InAppNavigationService>();
  // final _config = locator<RemoteConfigService>();

  Store<AppState> store;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  Future<void> initBeams() async {
    // FIXME:should fix the remote config
    // await ProxyService.remoteConfig.initialise();
    // Platform messages may fail, so we use a try/catch PlatformException.
    //sub on pusher events

    try {
      // As in Pusher Beams Get Started
      await PusherBeams.addDeviceInterest('app');
      // For debug purposes on Debug Console
      await PusherBeams.addDeviceInterest('debug-notifications');

      await PusherBeams.getDeviceInterests();
      // ignore: empty_catches
    } on PlatformException {}
  }

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> showLargeIconNotification(int id, String message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'big_picture',
        body: '$message',
        largeIcon: 'asset://assets/icon/icon.png',
        notificationLayout: NotificationLayout.BigPicture,
        payload: {'uuid': 'uuid-test'},
      ),
    );
  }

  Future<void> initFCM() async {
    await ProxyService.link.handleDynamicLink();
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
  void initState() {
    super.initState();
    initBeams();
    ProxyService.sharedState.setClear(c: true);
    // _config.initialise();
    _inAppNav.navigation.listen((path) {
      if (path == 'contacts') {
        ProxyService.nav.navigateTo(Routing.contactView);
      }
      if (path == 'completeSaleView') {
        ProxyService.nav.navigateTo(Routing.completeSaleView);
      }
      if (path == 'afterSaleView') {
        ProxyService.nav.navigateTo(Routing.afterSaleView);
      }
      if (path == 'addCustomerView') {
        ProxyService.nav.navigateTo(Routing.addCustomerView);
      }
      if (path == 'customerListView') {
        ProxyService.nav.navigateTo(Routing.customerListView);
      }
      if (path == 'ticketsView') {
        ProxyService.nav.navigateTo(Routing.ticketsView);
      }
    });
    _inAppNav.navToChat.listen((Map data) {
      if (data == null) {
        return null;
      }
      if (data['path'] == 'chat') {
        ProxyService.nav.navigateTo(
          Routing.chatView,
          arguments: ChatViewArguments(
            channels: data['channels'],
          ),
        );
      }
    });
    _state.didLogout.listen((loggedOut) {
      if (loggedOut) {
        ProxyService.nav.navigateTo(Routing.afterSplash);
      }
    });

    store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: createAuthenticationMiddleware(_navigatorKey)
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
    initFCM();
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
    });
    _firebaseMessaging.subscribeToTopic('app');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLargeIconNotification(2, message.notification.body);
        log.d(message.notification.body);
      }
    });
    // ignore: always_specify_types
    return LifeCycleManager(
      // ignore: always_specify_types
      child: StoreProvider(
        store: store,
        child: MaterialApp(
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
