import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';

abstract class PurchaseInterface {
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
  });

  Future<List<Purchase>> purchases();

  Future<List<Purchase>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
  });

  Future<List<Variant>> allImportsToDate();
  Future<List<PurchaseReportItem>> allPurchasesToDate();

  Future<void> saveVariant(
    Variant item,
    Business business,
    int branchId,
  );
  FutureOr<Purchase?> getPurchase({
    required String id,
  });
}
