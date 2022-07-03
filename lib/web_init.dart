import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

final isAndroid = UniversalPlatform.isAndroid;
Future<void> initDb() async {
  late Isar isar;
  late String apihub;
  if (kDebugMode && !isAndroid) {
    apihub = "http://localhost:8082";
  } else if (isAndroid) {
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
    directory: 'db',
  );
  IsarAPI.instance(isarRef: isar, url: apihub);
  await Firebase.initializeApp();
}

void recordBug(dynamic error, dynamic stack) {
  // throw UnimplementedError('this does not work on web');
}
