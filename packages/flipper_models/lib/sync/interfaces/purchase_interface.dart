import 'dart:async';

import 'package:flipper_models/db_model_export.dart';

abstract class PurchaseInterface {
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastRequestdate,
  });

  Future<List<Purchase>> purchases();

  Future<List<Variant>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
    required String lastRequestdate,
  });

  Future<void> saveVariant(
    Variant item,
    Business business,
    int branchId,
  );
  FutureOr<Purchase?> getPurchase({
    required String id,
  });
}
