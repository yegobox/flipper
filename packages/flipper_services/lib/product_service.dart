import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/models/models.dart';
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
  ProductSync? get product => _product.value;

  final _discounts = ReactiveValue<List<DiscountSync>>([]);
  List<DiscountSync> get discounts => _discounts.value;

  final _products = ReactiveValue<List<ProductSync>>([]);
  List<ProductSync> get products => _products.value
      .where((element) =>
          element.name != 'temp' && element.name != 'Custom Amount')
      .toList();

  String? get userId => ProxyService.box.read(key: 'userId');
  int? get branchId => ProxyService.box.read(key: 'branchId');

  setProductUnit({required String unit}) {
    _currentUnit = unit;
  }

  setCurrentProduct({required ProductSync product}) {
    _product.value = product;
  }

  final _variants = ReactiveValue<dynamic>(null);
  List<VariantSync>? get variants => _variants.value;

  Future<void> variantsProduct({required int productId}) async {
    final int? branchId = ProxyService.box.read(key: 'branchId');

    _variants.value = await ProxyService.api
        .variants(branchId: branchId!, productId: productId);
  }

  Future<List<ProductSync>> loadProducts({required int branchId}) async {
    //load discounts  in a list merge them with products make discount be at the top.
    final List<DiscountSync> _discountss =
        await ProxyService.api.getDiscounts(branchId: branchId);
    final List<ProductSync> _productss =
        await ProxyService.api.products(branchId: branchId);
    _discounts.value = _discountss;
    //merge _discounts with _products
    // final List _merged = [];
    // _merged.addAll(_discounts);
    // _merged.addAll(_productss);
    _products.value = _productss;
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

  Future<ProductSync?> getProductByBarCode({required String? code}) async {
    if (code == null) return null;
    return await ProxyService.api.getProductByBarCode(barCode: code);
  }

  final _stocks = ReactiveValue<List<StockSync>>([]);
  List<StockSync> get stocks => _stocks.value;
  List<StockSync> loadStockByProductId({required int productId}) {
    _stocks.value = ProxyService.api.stocks(productId: productId);
    return stocks;
  }

  ProductService() {
    listenToReactiveValues([_product, _variants, _products, _barCode, _stocks]);
  }
}
