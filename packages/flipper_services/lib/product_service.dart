import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
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

  int? get userId => ProxyService.box.getUserId();
  int? get branchId => ProxyService.box.getBranchId()!;

  setProductUnit({required String unit}) {
    _currentUnit = unit;
  }

  Stream<List<Product>> productStream({required int branchId}) {
    return Stream.fromFuture(ProxyService.strategy
            .getProducts(branchId: ProxyService.box.getBranchId()!))
        .asyncExpand((products) async* {
      // Yield the products as they become available
      yield products;
    });
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
    return await ProxyService.strategy.getProduct(
        barCode: code,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!);
  }

  ProductService() {
    listenToReactiveValues([_barCode]);
  }
}
