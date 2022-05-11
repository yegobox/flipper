import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';

Future<void> initDb() async {
  // await ObjectBoxApi.getDir(dbName: 'db');
  Directory dir = await getApplicationDocumentsDirectory();
  late Isar isar;
  isar = await Isar.open(
    directory: dir.path + "/db",
    schemas: [
      OrderSchema,
      BusinessSchema,
      BranchSchema,
      OrderItemSchema,
      ProductSchema,
      VariantSchema,
      ProfileSchema,
      SubscriptionSchema,
      PointsSchema,
      StockSchema,
      FeatureSchema,
      VoucherSchema,
      PColorSchema,
      CategorySchema,
      UnitSchema,
      SettingSchema,
      DiscountSyncSchema,
      CustomerSchema,
      PinSchema,
      ReceiptSchema,
    ],
    inspector: false,
  );
  IsarAPI(isar: isar);
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
