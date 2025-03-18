import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';

abstract class ProductInterface {
  Future<List<Product>> products({required int branchId});
  Stream<List<Product>> productStreams({String? prodIndex});
  Future<double> totalStock({String? productId, String? variantId});
  Stream<double> wholeStockValue({required int branchId});
  
  Future<Product?> getProduct({
    String? id,
    String? barCode,
    required int branchId,
    String? name,
    required int businessId,
  });
  
  Future<Product?> createProduct({
    required Product product,
    Purchase? purchase,
    String? modrId,
    String? orgnNatCd,
    String? exptNatCd,
    int? pkg,
    String? pkgUnitCd,
    String? spplrItemClsCd,
    String? spplrItemCd,
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
    required bool createItemCode,
  });
}
