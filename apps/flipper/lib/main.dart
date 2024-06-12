// import 'dart:async';
// import 'dart:io';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flipper_rw/StateObserver.dart';

// import 'package:flipper_localize/flipper_localize.dart';
// import 'package:flipper_routing/app.bottomsheets.dart';
// import 'package:flipper_routing/app.dialogs.dart';
// import 'package:flipper_routing/app.locator.dart' as loc;
// import 'package:flipper_routing/app.router.dart';
// import 'package:flipper_services/constants.dart';
// import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';

// import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
// import 'package:flutter/foundation.dart' as foundation;
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_fonts/google_fonts.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:flipper_services/locator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sizer/sizer.dart';
// import 'package:talker_flutter/talker_flutter.dart';
// import 'firebase_options.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'newRelic.dart' if (dart.library.html) 'newRelic_web.dart';
// import 'package:flutter/foundation.dart';
// // import 'package:firebase_app_check/firebase_app_check.dart';

// Future<void> backgroundHandler(RemoteMessage message) async {}

// /**
//  *TODO: need to generate this key in firebase
//  */
// const kWebRecaptchaSiteKey = '';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final talker = TalkerFlutter.init();
//   GoogleFonts.config.allowRuntimeFetching = false;
//   foundation.LicenseRegistry.addLicense(() async* {
//     final license = await rootBundle.loadString('google_fonts/OFL.txt');
//     yield foundation.LicenseEntryWithLineBreaks(['google_fonts'], license);
//   });
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   if (!isWindows) {
//     ///https://firebase.google.com/docs/app-check/flutter/debug-provider?hl=en&authuser=1
//     // await FirebaseAppCheck.instance.activate(
//     //   // Android:
//     //   androidProvider:
//     //       kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,

//     //   ///TODO: enable appCheck on ios and web when I support them
//     //   appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
//     //   // Web:
//     //   webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
//     // );
//   }
//   // TODO: to support Ios following these instruction https://developers.google.com/admob/flutter/quick-start#ios
//   if (!isWindows && !isWeb && !isMacOs) {
//     /// init admob
//     // await MobileAds.instance.initialize();
//     FlutterError.onError = (FlutterErrorDetails details) {
//       // Log the error to the console.
//       FlutterError.dumpErrorToConsole(details);

//       // Send the error to Firebase Crashlytics.
//       FirebaseCrashlytics.instance.recordFlutterError(details);
//     };
//   }
//   if (isAndroid && foundation.kReleaseMode && !isWeb & !isWindows && !isMacOs) {
//     NewRelic.initialize();
//   }
//   if (!isWindows) {
//     FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//     FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       badge: true,
//     );
//   }

//   //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//   await initDependencies();
//   loc.setupLocator(
//     stackedRouter: stackedRouter,
//   );
//   setupDialogUi();
//   setupBottomSheetUi();

//   ///Will switch to localNotification when it support windows
//   if (isAndroid || isIos && !isWeb) {
//     await NotificationsCubit.initialize(
//       flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
//     );
//   }

//   HttpOverrides.global = MyHttpOverrides();
//   ByteData data =
//       await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
//   SecurityContext.defaultContext
//       .setTrustedCertificatesBytes(data.buffer.asUint8List());
//   talker.info('App is started');
//   await SentryFlutter.init(
//     (options) {
//       options.dsn = kDebugMode
//           ? ''
//           : 'https://f3b8abd190f84fa0abdb139178362bc2@o205255.ingest.sentry.io/6067680';
//       // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
//       // We recommend adjusting this value in production.
//       options.tracesSampleRate = 1.0;
//       options.attachScreenshot = true;
//     },
//     appRunner: () => runApp(
//       ProviderScope(
//         observers: [StateObserver()],
//         child: OverlaySupport.global(
//           child: Sizer(builder: (context, orientation, deviceType) {
//             return MaterialApp.router(
//               debugShowCheckedModeBanner: true,
//               title: 'flipper',
//               // Define the light theme for the app, based on defined colors and
//               // properties above.
//               //TODOimplement my own as this is killing design
//               // theme: GThemeGenerator.generate(),
//               // darkTheme: GThemeGenerator.generateDark(),
//               theme: ThemeData(
//                 textTheme: GoogleFonts.poppinsTextTheme(),
//                 colorScheme:
//                     const ColorScheme.light().copyWith(surface: Colors.white),
//               ),
//               localizationsDelegates: [
//                 FirebaseUILocalizations.withDefaultOverrides(
//                   const LabelOverrides(),
//                 ),
//                 const FlipperLocalizationsDelegate(),
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 CountryLocalizations.delegate
//               ],
//               supportedLocales: const [
//                 Locale('en'), // English
//                 Locale('es'), // Spanish
//               ],
//               locale: const Locale('en'),
//               // locale: model
//               //     .languageService.locale,
//               // themeMode: model.settingService.themeMode.value,
//               themeMode: ThemeMode.system,
//               routerDelegate: stackedRouter.delegate(),
//               routeInformationParser: stackedRouter.defaultRouteParser(),
//             );
//           }),
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
// import 'package:realm_app/locator.dart';
// import 'package:realm_app/proxy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initDependencies(); // register getIt dependencies

  // trigger realm to throw error
  // ProxyService.cron.schedule();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
