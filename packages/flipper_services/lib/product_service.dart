import 'package:flipper_models/models/product.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/models/variation.dart';

class ProductService with ReactiveServiceMixin {
  String? _currentUnit = 'Kg'; //set default to kg
  String? get currentUnit => _currentUnit;

  final _product = ReactiveValue<dynamic>(null);
  Product? get product => _product.value;

  String? get userId => ProxyService.box.read(key: 'userId');
  String? get branchId => ProxyService.box.read(key: 'branchId');

  setProductUnit({required String unit}) {
    _currentUnit = unit;
  }

  setCurrentProduct({required Product product}) {
    _product.value = product;
  }

  final _variants = ReactiveValue<dynamic>(null);
  List<Variation>? get variants => _variants.value;

  Future<void> variantsProduct({required String productId}) async {
    final String? branchId = ProxyService.box.read(key: 'branchId');

    _variants.value = await ProxyService.api
        .variants(branchId: branchId!, productId: productId);
  }

  ProductService() {
    listenToReactiveValues([_product, _variants]);
  }
}
