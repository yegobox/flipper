import 'package:flipper_models/models/product.dart';
import 'package:flipper_services/proxy.dart';

class ProductService {
  String? _currentUnit;
  String? get currentUnit => _currentUnit;

  Product? _product;
  Product? get product => _product;

  String? get userId => ProxyService.box.read(key: 'userId');
  String? get branchId => ProxyService.box.read(key: 'branchId');

  setProductUnit({required String unit}) {
    _currentUnit = unit;
  }

  setCurrentProduct({required Product}) {
    _product = product;
  }
}
