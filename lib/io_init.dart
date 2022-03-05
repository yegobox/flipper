import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';

Future<void> initDb() async {
  await ObjectBoxApi.getDir(dbName: 'omni_sync');
  Directory dir = await getApplicationDocumentsDirectory();

  await IsarAPI.getDir(dbName: dir.path+"/omni_local");
  if (Platform.isIOS || Platform.isMacOS || Platform.isAndroid) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(options: firebaseOptions);
  }
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    if (!isWindows) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
    // Pass all uncaught errors from the framework to Crashlytics.
    if (!isWindows) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }
}

void recordBug(dynamic error, dynamic stack) {
  FirebaseCrashlytics.instance.recordError(error, stack);
}
