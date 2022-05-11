import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/isar_models.dart';

Future<void> initDb() async {
  late Isar isar;
  isar = await Isar.open(
    directory: 'db',
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
  await Firebase.initializeApp();
}

void recordBug(dynamic error, dynamic stack) {
  // throw UnimplementedError('this does not work on web');
}
