// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/material.dart';

void main() async {
  // Crashlytics.instance.enableInDevMode = true;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  configureLogger();
  WidgetsFlutterBinding.ensureInitialized();
  // final ThemeMode themeMode = await getThemeMode();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
  //     .copyWith(systemNavigationBarColor: Colors.white));
  // SystemChrome.
  // snapshot.data.fold(0, (a, b) => a + (b.count * b.price));
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  await Firebase.initializeApp();
  runApp(FlipperApp());
}
