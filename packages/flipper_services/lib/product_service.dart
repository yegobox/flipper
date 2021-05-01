import 'package:flipper_models/models/product.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ProductService with ReactiveServiceMixin {
  String? _currentUnit;
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

  ProductService() {
    listenToReactiveValues([_product]);
  }
}
