import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ProductService with ReactiveServiceMixin {
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

  final _discounts = ReactiveValue<List<DiscountSync>>([]);
  List<DiscountSync> get discounts => _discounts.value;

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

  /// load discounts  in a list merge them with products make discount be at the top.
  Stream<List<Product>> loadProducts({required int branchId}) async* {
    final List<DiscountSync> _discountss =
        await ProxyService.isarApi.getDiscounts(branchId: branchId);
    final Stream<List<Product>> _productss =
        ProxyService.isarApi.productStreams(branchId: branchId);
    _discounts.value = _discountss;
    yield* _productss;
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

  Future<Product?> getProductByBarCode({required String? code}) async {
    if (code == null) return null;
    return await ProxyService.isarApi.getProductByBarCode(barCode: code);
  }

  List<Stock?> _stocks = [];
  List<Stock?> get stocks => _stocks;
  Future<List<Stock?>> loadStockByProductId({required int productId}) async {
    _stocks = await ProxyService.isarApi.stocks(productId: productId);
    // log.i("stock::${_stocks[0]!.retailPrice}");
    return stocks;
  }

  ProductService() {
    listenToReactiveValues([_product, _variants, _products, _barCode, _stocks]);
  }
}
