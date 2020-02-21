import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  configureLogger();
  //todo:this might cause the error please review this.
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
  //     .copyWith(systemNavigationBarColor: Colors.white));
  // SystemChrome.
  // snapshot.data.fold(0, (a, b) => a + (b.count * b.price));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(FlipperApp());

  //todo: to be cleaned
// StoreProvider.of<AppState>(context)
//               .dispatch(WithUnitId(unitId: unitsList[i].id));
//           StoreProvider.of<AppState>(context)
//               .dispatch(UpdateUnitAction(unitId: unitsList[i].id));
//           //todo:clean this dups store
//           StoreProvider.of<AppState>(context)
//               .dispatch(CurrentUnit(unit: unitsList[i]));
}
