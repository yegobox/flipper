import 'dart:async';

import 'package:flipper_models/realm_model_export.dart';

abstract class VariantInterface {
  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
    int? page,
    String? variantId,
    String? name,
    String? bcd,
    String? purchaseId,
    int? itemsPerPage,
    String? imptItemsttsCd,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    bool fetchRemote = false,
  });
  Future<Variant?> getVariant({required String id});

  Future<int> addVariant({
    required List<Variant> variations,
    required int branchId,
  });

  Future<List<IUnit>> units({required int branchId});

  Future<int> addUnits<T>({required List<Map<String, dynamic>> units});

  FutureOr<void> updateVariant(
      {required List<Variant> updatables,
      String? color,
      String? taxTyCd,
      String? variantId,
      double? newRetailPrice,
      double? retailPrice,
      Map<String, String>? rates,
      double? supplyPrice,
      Map<String, String>? dates,
      String? selectedProductType,
      String? productId,
      String? productName,
      String? unit,
      String? pkgUnitCd,
      DateTime? expirationDate,
      bool? ebmSynced, String? categoryId});

  FutureOr<Variant> addStockToVariant({required Variant variant, Stock? stock});
}
