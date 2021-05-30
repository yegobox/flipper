import 'package:flipper_models/product.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/variation.dart';

class ProductService with ReactiveServiceMixin {
  String? _currentUnit = 'Kg'; //set default to kg
  String? get currentUnit => _currentUnit;

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

  Future<void> loadProducts() async {
    _products.value = await ProxyService.api.products();
  }

  ProductService() {
    listenToReactiveValues([_product, _variants, _products]);
  }
}
