import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ProductService with ListenableServiceMixin {
  String? _currentUnit = 'Kg'; //set default to kg
  String? get currentUnit => _currentUnit;
  final log = getLogger('ProductService');

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

  String? get userId => ProxyService.box.getUserId();
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
    log.d(variants!.first.retailPrice);
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
