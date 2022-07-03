import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'firebase_options.dart';

final isAndroid = UniversalPlatform.isAndroid;
Future<void> initDb() async {
  // await ObjectBoxApi.getDir(dbName: 'db');
  Directory dir = await getApplicationDocumentsDirectory();
  late Isar isar;
  late String apihub;
  if (kDebugMode && !isAndroid) {
    apihub = "http://localhost:8082";
  } else if (kDebugMode && isAndroid) {
    apihub = "http://10.0.2.2:8082";
  } else {
    apihub = "https://apihub.yegobox.com";
  }
  isar = await Isar.open(
    [
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
      DiscountSchema,
      CustomerSchema,
      PinSchema,
      ReceiptSchema,
      DrawersSchema,
      ITenantSchema,
      PermissionSchema
    ],
    directory: dir.path,
  );
  IsarAPI.instance(isarRef: isar, url: apihub);
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
