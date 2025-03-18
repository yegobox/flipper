import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';

abstract class ProductInterface {
  Future<List<Product>> products({required int branchId});
  Stream<List<Product>> productStreams({String? prodIndex});
  Future<double> totalStock({String? productId, String? variantId});
  Stream<double> wholeStockValue({required int branchId});
  FutureOr<String> itemCode(
      {required String countryCode,
      required String productType,
      required packagingUnit,
      required int branchId,
      required String quantityUnit});
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
  });
}
