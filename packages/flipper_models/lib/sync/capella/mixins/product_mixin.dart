import 'dart:async';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaProductMixin implements ProductInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Product>> products({required int branchId}) async {
    throw UnimplementedError('products needs to be implemented for Capella');
  }

  @override
  Stream<List<Product>> productStreams({String? prodIndex}) {
    throw UnimplementedError(
        'productStreams needs to be implemented for Capella');
  }

  @override
  Future<double> totalStock({String? productId, String? variantId}) async {
    throw UnimplementedError('totalStock needs to be implemented for Capella');
  }

  @override
  Stream<double> wholeStockValue({required int branchId}) {
    throw UnimplementedError(
        'wholeStockValue needs to be implemented for Capella');
  }

  @override
  FutureOr<String> itemCode({
    required String countryCode,
    required String productType,
    required packagingUnit,
    required int branchId,
    required String quantityUnit,
  }) async {
    throw UnimplementedError('itemCode needs to be implemented for Capella');
  }

  @override
  Future<Product?> getProduct({
    String? id,
    String? barCode,
    required int branchId,
    String? name,
    required int businessId,
  }) async {
    throw UnimplementedError('getProduct needs to be implemented for Capella');
  }

  @override
  FutureOr<SKU> getSku({required int branchId, required int businessId}) async {
    throw UnimplementedError('getSku needs to be implemented for Capella');
  }

  @override
  Future<Product?> createProduct({
    required Product product,
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
    Map<String, String>? taxTypes,
    Map<String, String>? itemClasses,
    Map<String, String>? itemTypes,
    double? splyAmt,
    String? taxTyCd,
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
  }) async {
    throw UnimplementedError(
        'createProduct needs to be implemented for Capella');
  }

  @override
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
      String? categoryId}) {
    throw UnimplementedError(
        'updateProduct needs to be implemented for Capella');
  }

  @override
  Future<void> hydrateDate({required String branchId}) async {
    throw UnimplementedError('hydrateDate needs to be implemented for Capella');
  }
}
