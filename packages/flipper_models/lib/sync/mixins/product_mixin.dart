import 'dart:async';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin ProductMixin implements ProductInterface {
  Repository get repository;

  @override
  Future<List<Product>> products({required int branchId}) async {
    return await repository.get<Product>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Stream<List<Product>> productStreams({String? prodIndex}) {
    if (prodIndex != null) {
      return repository
          .get<Product>(
            query: Query(where: [Where('id').isExactly(prodIndex)]),
          )
          .asStream();
    }
    return repository.get<Product>().asStream();
  }

  @override
  Future<double> totalStock({String? productId, String? variantId}) async {
    double totalStock = 0.0;
    if (productId != null) {
      List<Stock> stocksIn = await repository.get<Stock>(
          query: Query(where: [Where('productId').isExactly(productId)]));
      totalStock =
          stocksIn.fold(0.0, (sum, stock) => sum + (stock.currentStock!));
    } else if (variantId != null) {
      List<Stock> stocksIn = await repository.get<Stock>(
          query: Query(where: [Where('variantId').isExactly(variantId)]));
      totalStock =
          stocksIn.fold(0.0, (sum, stock) => sum + (stock.currentStock!));
    }
    return totalStock;
  }

  @override
  Stream<double> wholeStockValue({required int branchId}) async* {
    final products = await repository.get<Product>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );

    double totalValue = 0;
    for (var product in products) {
      final variants = await repository.get<Variant>(
        query: Query(where: [Where('productId').isExactly(product.id)]),
      );
      for (var variant in variants) {
        totalValue += (variant.quantity ?? 0) * (variant.retailPrice ?? 0);
      }
    }
    yield totalValue;
  }

  @override
  Future<Product?> getProduct({
    String? id,
    String? barCode,
    required int branchId,
    String? name,
    required int businessId,
  }) async {
    final query = Query(where: [
      Where('branchId').isExactly(branchId),
      if (id != null) Where('id').isExactly(id),
      if (barCode != null) Where('barCode').isExactly(barCode),
      if (name != null) Where('name').isExactly(name),
    ]);

    return (await repository.get<Product>(query: query)).firstOrNull;
  }

  @override
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
  }) async {
    // Implement the product creation logic here, reusing the existing implementation
    // from CoreSync.dart
    return await repository.upsert<Product>(product);
  }
}
