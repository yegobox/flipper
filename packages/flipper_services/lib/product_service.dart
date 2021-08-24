import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/variants.dart';

class ProductService with ReactiveServiceMixin {
  String? _currentUnit = 'Kg'; //set default to kg
  String? get currentUnit => _currentUnit;
  final log = getLogger('ProductService');

  final _barCode = ReactiveValue<String>('');
  String get barCode => _barCode.value;
  void setBarcode(String value) {
    _barCode.value = value;
    notifyListeners();
  }

  final _product = ReactiveValue<dynamic>(null);
  Product? get product => _product.value;

  final _products = ReactiveValue<List<Product>>([]);
  List<Product> get products => _products.value
      .where((element) =>
          element.name != 'temp' && element.name != 'Custom Amount')
      .toList();

  String? get userId => ProxyService.box.read(key: 'userId');
  int? get branchId => ProxyService.box.read(key: 'branchId');

  setProductUnit({required String unit}) {
    _currentUnit = unit;
  }

  setCurrentProduct({required Product product}) {
    _product.value = product;
  }

  final _variants = ReactiveValue<dynamic>(null);
  List<Variant>? get variants => _variants.value;

  Future<void> variantsProduct({required int productId}) async {
    final int? branchId = ProxyService.box.read(key: 'branchId');

    _variants.value = await ProxyService.api
        .variants(branchId: branchId!, productId: productId);
  }

  Future<List<Product>> loadProducts({required int branchId}) async {
    _products.value = await ProxyService.api.products(branchId: branchId);
    return products;
  }

  Future<void> filtterProduct(
      {required String searchKey, required int branchId}) async {
    _products.value = _products.value
        .where((element) =>
            element.name.toLowerCase().contains(searchKey) ||
            element.name.toLowerCase() == searchKey ||
            element.name
                .toLowerCase()
                .allMatches(searchKey)
                .any((element) => true))
        .toList();
    if (searchKey.isEmpty) loadProducts(branchId: branchId);
  }

  Future<Product?> getProductByBarCode({required String code}) async {
    return await ProxyService.api.getProductByBarCode(barCode: code);
  }

  final _stocks = ReactiveValue<List<Stock>>([]);
  List<Stock> get stocks => _stocks.value;
  List<Stock> loadStockByProductId({required int productId}) {
    _stocks.value = ProxyService.api.stocks(productId: productId);
    return stocks;
  }

  ProductService() {
    listenToReactiveValues([_product, _variants, _products, _barCode, _stocks]);
  }
}
