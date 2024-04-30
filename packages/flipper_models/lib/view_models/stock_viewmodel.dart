library flipper_models;

import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class StockViewModel extends BaseViewModel {
  double _stocks = 0.0;
  get stocks => _stocks;

  loadStockByProductId({required int productId}) async {
    _stocks = await ProxyService.isar.stocks(productId: productId);
    notifyListeners();
  }
}
