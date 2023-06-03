import 'dart:async';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ProductService with ListenableServiceMixin {
  String? _currentUnit = 'Kg'; //set default to kg
  String? get currentUnit => _currentUnit;

  final _barCode = ReactiveValue<String>('');
  String get barCode => _barCode.value;
  void setBarcode(String? value) {
    if (value == null) {
      _barCode.value = '';
    } else {
      _barCode.value = value;
    }
    notifyListeners();
  }

  final _product = ReactiveValue<dynamic>(null);
  Product? get product => _product.value;

  final _products = ReactiveValue<List<Product>>([]);

  List<Product> get products => _products.value
      .where((element) =>
          element.name != 'temp' && element.name != 'Custom Amount')
      .toList();
  set products(List<Product> value) {
    _products.value = value;
    notifyListeners();
  }

  List<Product> get nonFavoriteProducts => _products.value
      .where((element) =>
          element.name != 'temp' && element.name != 'Custom Amount' && element.id != 1)
      .toList();
  set nonFavoriteProducts(List<Product> value) {
    _products.value = value;
    notifyListeners();
  }

  int? get userId => ProxyService.box.getUserId();
  int? get branchId => ProxyService.box.getBranchId()!;

  setProductUnit({required String unit}) {
    _currentUnit = unit;
  }

  setCurrentProduct({required Product product}) {
    _product.value = product;
  }

  final _variants = ReactiveValue<dynamic>(null);
  List<Variant>? get variants => _variants.value;

  Future<void> variantsProduct({required int productId}) async {
    _variants.value = await ProxyService.isarApi
        .variants(branchId: branchId!, productId: productId);
    notifyListeners();
  }

  /// discount streams
  Stream<List<Discount>> discountStream({required int branchId}) async* {
    yield* ProxyService.isarApi.discountStreams(branchId: branchId);
  }

  /// products streams
  Stream<List<Product>> productStream({required int branchId}) async* {
    yield* ProxyService.isarApi.productStreams(branchId: branchId);
  }

  StreamTransformer<List<Product>, List<Product>> searchTransformer(
      String query) {
    return StreamTransformer<List<Product>, List<Product>>.fromHandlers(
      handleData: (products, sink) {
        if (query.isEmpty) {
          sink.add(products); // Pass through all products if query is empty
        } else {
          final filteredProducts = products.where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()));
          sink.add(filteredProducts.toList()); // Add filtered products to sink
        }
      },
    );
  }

  Future<Product?> getProductByBarCode({required String? code}) async {
    if (code == null) return null;
    return await ProxyService.isarApi.getProductByBarCode(barCode: code);
  }

  List<Stock?> _stocks = [];
  List<Stock?> get stocks => _stocks;
  Future<List<Stock?>> loadStockByProductId({required int productId}) async {
    _stocks = await ProxyService.isarApi.stocks(productId: productId);
    return stocks;
  }

  ProductService() {
    listenToReactiveValues([_product, _variants, _products, _barCode, _stocks]);
  }
}
