import 'dart:async';
import 'package:flipper_models/db_model_export.dart';

abstract class ProductInterface {
  Future<List<Product>> products({required int branchId});
  FutureOr<void> updateProduct(
      {String? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      required int branchId,
      required int businessId,
      String? imageUrl,
      String? expiryDate,
      String? categoryId});
  Stream<List<Product>> productStreams({String? prodIndex});
  Future<double> totalStock({String? productId, String? variantId});
  Stream<double> wholeStockValue({required int branchId});
  Future<String> itemCode({
    required int branchId,
    required String countryCode, // e.g., "RW"
    required String productType, // e.g., "2"
    required String packagingUnit, // e.g., "NT"
    required String quantityUnit, // e.g., "BJ"
  });

  Future<Product?> getProduct({
    String? id,
    String? barCode,
    required int branchId,
    String? name,
    required int businessId,
  });
  FutureOr<SKU> getSku({required int branchId, required int businessId});
  Future<Product?> createProduct({
    required Product product,
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
    Map<String, String>? taxTypes,
    Map<String, String>? itemClasses,
    Map<String, String>? itemTypes,
    String? modrId,
    String? orgnNatCd,
    String? exptNatCd,
    int? pkg,
    String? pkgUnitCd,
    String? qtyUnitCd,
    int? totWt,
    int? netWt,
    String? spplrNm,
    String? agntNm,
    int? invcFcurAmt,
    String? invcFcurCd,
    double? invcFcurExcrt,
    String? dclNo,
    String? taskCd,
    String? dclDe,
    String? hsCd,
    String? imptItemsttsCd,
    String? spplrItemClsCd,
    String? spplrItemCd,
    bool skipRegularVariant = false,
    double qty = 1,
    double supplyPrice = 0,
    double retailPrice = 0,
    int itemSeq = 1,
    required bool createItemCode,
    bool ebmSynced = false,
    String? saleListId,
    Purchase? purchase,
    String? pchsSttsCd,
    double? totAmt,
    double? taxAmt,
    double? taxblAmt,
    String? itemCd,
    String? taxTyCd,
    double? splyAmt,
  });

  Future<void> hydrateDate({required String branchId});
  Future<void> hydrateCodes({required int branchId});
  Future<void> hydrateSars({required int branchId});
}
