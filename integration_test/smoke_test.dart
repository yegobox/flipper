import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flipper_models/mocks/isarApiMock.dart';
import 'package:flipper_rw/StateObserver.dart';
import 'package:flipper_rw/firebase_options.dart';
import 'package:flipper_rw/flipper_localize/lib/flipper_localize.dart';
import 'package:flipper_rw/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart';
// Import the relevant file
import 'package:google_fonts/google_fonts.dart';
import 'package:nock/nock.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:integration_test/integration_test.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test -d windows integration_test/smoke_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // Mock the HTTP client at the ViewModel level
  setUpAll(nock.init);

  setUp(() async {
    nock.cleanAll();
    await initDependencies();
    loc.setupLocator(
      stackedRouter: stackedRouter,
    );
    setupDialogUi();
    setupBottomSheetUi();
    loc.locator.registerLazySingleton(() => IsarAPIMock());
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (isAndroid || isIos && !isWeb) {
      await NotificationsCubit.initialize(
        flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
      );
    }

    HttpOverrides.global = MyHttpOverrides();
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  });

  testWidgets('App start and runs', (WidgetTester tester) async {
    // int? userId = ProxyService.box.getUserId();
    // final interceptor =
    //     nock("https://apihub.yegobox.com/v2/api").get("/businessUserId/$userId")
    //       ..reply(
    //         200,
    //         "result",
    //       );

    // expect(interceptor.isDone, true);
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(
      observers: [StateObserver()],
      child: OverlaySupport.global(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: true,
          title: 'flipper',
          // Define the light theme for the app, based on defined colors and
          // properties above.
          //TODOimplement my own as this is killing design
          // theme: GThemeGenerator.generate(),
          // darkTheme: GThemeGenerator.generateDark(),
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          localizationsDelegates: [
            FirebaseUILocalizations.withDefaultOverrides(
              const LabelOverrides(),
            ),
            const FlipperLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            CountryLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('es'), // Spanish
          ],
          locale: const Locale('en'),
          // locale: model
          //     .languageService.locale,
          // themeMode: model.settingService.themeMode.value,
          themeMode: ThemeMode.system,
          routerDelegate: stackedRouter.delegate(),
          routeInformationParser: stackedRouter.defaultRouteParser(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2)); // Wait some time

    // Verify that our counter starts at 0.
    expect(find.text('A revolutionary business software ...'), findsOneWidget);

    // Test additional functionality...
  });
}
